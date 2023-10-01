Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE398F54
	for <nvdimm@lists.linux.dev>; Sun,  1 Oct 2023 22:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696199502; x=1727735502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=akNBQPskrM8djdz7UCrD/NyGZShfvvdEJHx6llS4OvU=;
  b=TkubvXla6d1z6q5JikF10bnhPsI4FJ5f6r94EzOqEznOGZCC4HpPKjNZ
   Akivi33H4sP3iBeTQJM38ZAurFF5DZ+81ZB/yY4XOU9PqOgGm/69t32EL
   X5HoBRWhKbbCmcnOMDLgLFAEZnXLJU231BMJT9kBFtX34JQHO2UNJHlft
   0MiUTG8Wl1C5ajN6QyQlQ7TIZ5dQFQwymFcoRliyqTtWyQ4qiRTUw+PvW
   tkwH/PgVz3Skyyjzbssu1cq2yYqPwq5oBZT5FoI48sR9tyfFymkuicbBT
   dIil3kUpFb626VCWr6Fo+DqhhFgqZbzePH3eHtHzkeSTwCWrXRql2Tkxn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="367618325"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="367618325"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2023 15:31:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="779781976"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="779781976"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.251.20.198])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2023 15:31:40 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2 5/5] cxl/test: add cxl-poison.sh unit test
Date: Sun,  1 Oct 2023 15:31:35 -0700
Message-Id: <51fdd212d139d203506cc2ee18abb362e5859e3e.1696196382.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1696196382.git.alison.schofield@intel.com>
References: <cover.1696196382.git.alison.schofield@intel.com>
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
 test/cxl-poison.sh | 103 +++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build   |   2 +
 2 files changed, 105 insertions(+)
 create mode 100644 test/cxl-poison.sh

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
new file mode 100644
index 000000000000..3c424532da7b
--- /dev/null
+++ b/test/cxl-poison.sh
@@ -0,0 +1,103 @@
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
+cxl list
+
+# THEORY OF OPERATION: Exercise cxl-cli and cxl driver ability to
+# inject, clear, and get the poison list. Do it by memdev and by region.
+# Based on current cxl-test topology.
+
+create_region()
+{
+	region=$($CXL create-region -d $decoder -m $memdevs | jq -r ".region")
+
+	if [[ ! $region ]]; then
+		echo "create-region failed for $decoder"
+		err "$LINENO"
+	fi
+}
+
+setup_x2_region()
+{
+        # Find an x2 decoder
+        decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
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
+find_media_errors()
+{
+	nr=$(echo $json | jq -r ".nr_poison_records")
+	if [[ $nr -ne $NR_ERRS ]]; then
+		echo "$mem: $NR_ERRS poison records expected, $nr found"
+		err "$LINENO"
+	fi
+}
+
+# Turn Tracing ON
+# Note that 'cxl list --poison' does toggle the tracing, so
+# turning it on here is to enable the test user to view inject
+# and clear trace events, if they wish.
+echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
+
+# Using DEBUGFS:
+# When cxl-cli support for inject and clear arrives, replace
+# the writes to /sys/kernel/debug with the new cxl commands
+# that wrap them.
+
+# Poison by memdev: inject, list, clear, list.
+# Inject 2 into pmem and 2 into ram partition.
+echo 0x40000000 > /sys/kernel/debug/cxl/mem1/inject_poison
+echo 0x40001000 > /sys/kernel/debug/cxl/mem1/inject_poison
+echo 0x0 	> /sys/kernel/debug/cxl/mem1/inject_poison
+echo 0x600	> /sys/kernel/debug/cxl/mem1/inject_poison
+NR_ERRS=4
+json=$("$CXL" list -m mem1 --poison | jq -r '.[].poison')
+find_media_errors
+echo 0x40000000 > /sys/kernel/debug/cxl/mem1/clear_poison
+echo 0x40001000 > /sys/kernel/debug/cxl/mem1/clear_poison
+echo 0x0 	> /sys/kernel/debug/cxl/mem1/clear_poison
+echo 0x600	> /sys/kernel/debug/cxl/mem1/clear_poison
+NR_ERRS=0
+json=$("$CXL" list -m mem1 --poison | jq -r '.[].poison')
+find_media_errors
+
+# Poison by region: inject, list, clear, list.
+setup_x2_region
+create_region
+echo 0x40000000 > /sys/kernel/debug/cxl/"$mem0"/inject_poison
+echo 0x40000000 > /sys/kernel/debug/cxl/"$mem1"/inject_poison
+NR_ERRS=2
+json=$("$CXL" list -r "$region" --poison | jq -r '.[].poison')
+find_media_errors
+echo 0x40000000 > /sys/kernel/debug/cxl/"$mem0"/clear_poison
+echo 0x40000000 > /sys/kernel/debug/cxl/"$mem1"/clear_poison
+NR_ERRS=0
+json=$("$CXL" list -r "$region" --poison | jq -r '.[].poison')
+find_media_errors
+
+check_dmesg "$LINENO"
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

