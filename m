Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7C847765
	for <nvdimm@lists.linux.dev>; Fri, 17 Nov 2023 22:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nAiuJJpo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700260537; x=1731796537;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fTxS7I3isVdzmeh08r2c/YQ6nODFiMjo+VniI1e7zyY=;
  b=nAiuJJpoCrVmrAXDfFKXJVxNenpJtNcu1e0czBkJwH393opZGDLbneBc
   frA0ZoOULHY8sUWV+MWslT9mz/C+AdnGoYCvKZVvePs0T/xvHyw/307hs
   fczG/QdGE0ruGoPg3QIezEVjnh6vfM0CLx+BCZjg/CUHTWf3b3F0bZZ47
   sxDVBVjvtYxm7OtERTFpuHStR9HCxaajyT9eb01pg0CxhC4Oift4MKS1W
   z7EcoqnKfYN/G4FcHKGm6XLaL4mR3F1JUxdeWjLJQqNGvundD4jGAdKS+
   fbp4OAoXgSe1qHySN3DRe9o8ncevBkNLlc6c+EJZiNIEOira2kZp14upz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="376428470"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="376428470"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 14:35:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="831732286"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="831732286"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.86.159])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 14:35:35 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v3 5/5] cxl/test: add cxl-poison.sh unit test
Date: Fri, 17 Nov 2023 14:35:24 -0800
Message-Id: <2c7aa46e399738867b21bb35120196310ed2613d.1700258145.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1700258145.git.alison.schofield@intel.com>
References: <cover.1700258145.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Exercise cxl list, libcxl, and driver pieces of the get poison list
pathway. Inject and clear poison using debugfs and use cxl-cli to
read the poison list by memdev and by region.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-poison.sh | 135 +++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build   |   2 +
 2 files changed, 137 insertions(+)
 create mode 100644 test/cxl-poison.sh

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
new file mode 100644
index 000000000000..a562153c8324
--- /dev/null
+++ b/test/cxl-poison.sh
@@ -0,0 +1,135 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2022 Intel Corporation. All rights reserved.
+
+. $(dirname $0)/common
+
+rc=77
+
+set -ex
+
+trap 'err $LINENO' ERR
+
+check_prereq "jq"
+
+modprobe -r cxl_test
+modprobe cxl_test
+
+rc=1
+
+# THEORY OF OPERATION: Exercise cxl-cli and cxl driver ability to
+# inject, clear, and get the poison list. Do it by memdev and by region.
+# Based on current cxl-test topology.
+
+find_memdev()
+{
+	readarray -t capable_mems < <("$CXL" list -b "$CXL_TEST_BUS" -M |
+		jq -r ".[] | select(.pmem_size != null) |
+	       	select(.ram_size != null) | .memdev")
+
+	if [ ${#capable_mems[@]} == 0 ]; then
+		echo "no memdevs found for test"
+		err "$LINENO"
+	fi
+
+	memdev=${capable_mems[0]}
+}
+
+setup_x2_region()
+{
+        # Find an x2 decoder
+        decoder=$($CXL list -b "$CXL_TEST_BUS" -D -d root | jq -r ".[] |
+          select(.pmem_capable == true) |
+          select(.nr_targets == 2) |
+          .decoder")
+
+        # Find a memdev for each host-bridge interleave position
+        port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
+            .targets | .[] | select(.position == 0) | .target")
+        port_dev1=$($CXL list -T -d $decoder | jq -r ".[] |
+            .targets | .[] | select(.position == 1) | .target")
+        mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
+        mem1=$($CXL list -M -p $port_dev1 | jq -r ".[0].memdev")
+        memdevs="$mem0 $mem1"
+}
+
+create_region()
+{
+	setup_x2_region
+	region=$($CXL create-region -d $decoder -m $memdevs | jq -r ".region")
+	if [[ ! $region ]]; then
+		echo "create-region failed for $decoder"
+		err "$LINENO"
+	fi
+}
+
+# When cxl-cli support for inject and clear arrives, replace
+# the writes to /sys/kernel/debug with the new cxl commands.
+
+inject_poison_sysfs()
+{
+	memdev="$1"
+	addr="$2"
+
+	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/inject_poison
+}
+
+clear_poison_sysfs()
+{
+	memdev="$1"
+	addr="$2"
+
+	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/clear_poison
+}
+
+find_media_errors()
+{
+	local json="$1"
+
+	nr="$(jq -r ".nr_records" <<< "$json")"
+	if [[ $nr != $NR_ERRS ]]; then
+		echo "$mem: $NR_ERRS poison records expected, $nr found"
+		err "$LINENO"
+	fi
+}
+
+# Turn tracing on. Note that 'cxl list --poison' does toggle the tracing.
+# Turning it on here allows the test user to also view inject and clear
+# trace events.
+echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
+
+# Poison by memdev
+# Inject then clear into cxl_test known pmem and ram partitions
+find_memdev
+inject_poison_sysfs "$memdev" "0x40000000"
+inject_poison_sysfs "$memdev" "0x40001000"
+inject_poison_sysfs "$memdev" "0x600"
+inject_poison_sysfs "$memdev" "0x0"
+NR_ERRS=4
+json=$("$CXL" list -m "$memdev" --poison | jq -r '.[].poison')
+find_media_errors "$json"
+clear_poison_sysfs "$memdev" "0x40000000"
+clear_poison_sysfs "$memdev" "0x40001000"
+clear_poison_sysfs "$memdev" "0x600"
+clear_poison_sysfs "$memdev" "0x0"
+NR_ERRS=0
+json=$("$CXL" list -m "$memdev" --poison | jq -r '.[].poison')
+find_media_errors "$json"
+
+# Poison by region
+# Inject then clear into cxl_test known pmem dpa mappings
+create_region
+inject_poison_sysfs "$mem0" "0x40000000"
+inject_poison_sysfs "$mem1" "0x40000000"
+NR_ERRS=2
+json=$("$CXL" list -r "$region" --poison | jq -r '.[].poison')
+find_media_errors "$json"
+clear_poison_sysfs "$mem0" "0x40000000"
+clear_poison_sysfs "$mem1" "0x40000000"
+NR_ERRS=0
+json=$("$CXL" list -r "$region" --poison | jq -r '.[].poison')
+find_media_errors "$json"
+
+check_dmesg "$LINENO"
+
+modprobe -r cxl-test
diff --git a/test/meson.build b/test/meson.build
index 224adaf41fcc..2706fa5d633c 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -157,6 +157,7 @@ cxl_create_region = find_program('cxl-create-region.sh')
 cxl_xor_region = find_program('cxl-xor-region.sh')
 cxl_update_firmware = find_program('cxl-update-firmware.sh')
 cxl_events = find_program('cxl-events.sh')
+cxl_poison = find_program('cxl-poison.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -186,6 +187,7 @@ tests = [
   [ 'cxl-create-region.sh',   cxl_create_region,  'cxl'   ],
   [ 'cxl-xor-region.sh',      cxl_xor_region,     'cxl'   ],
   [ 'cxl-events.sh',          cxl_events,         'cxl'   ],
+  [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.37.3

