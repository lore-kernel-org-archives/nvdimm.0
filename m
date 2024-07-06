Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BD41CA9E
	for <nvdimm@lists.linux.dev>; Sat,  6 Jul 2024 06:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720247107; cv=none; b=GW/ncKx+I3p68LdlDy2cWe/hNsv/blhmoNaGMXSzGMPhAJvdDC1wCjDomPQe5ZXGZCn1tBlj4w/ZV4aNClzRp/6VKYn0U998fB4gc4UP9TDN6s2EJx3EZ638hNJ84Fjj7gYSkDJwPeHhyA1Up0WpAN30lP+vz1yUDlaXJ7NHpnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720247107; c=relaxed/simple;
	bh=RkvUXVi/Dt6O4GzRluGcJSTqPWOyEmy7NvPT0BP6324=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QFq52tKOnujtstIYl2lLbV8u3gthXTh8t88RgbhbdvMurbjk9GNKN3pltV0xWr1MdtUxJb2Poanwz3Sfx3Kht+EETYZUltq7X1KaVtNlXerfZcMDjtmnFAOru3Wt6BcQBouOY/kEg83aa+LsGhIlpB/rtSXaCBw8xI3h9uAlhjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TwGKTQC0; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TwGKTQC0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720247106; x=1751783106;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RkvUXVi/Dt6O4GzRluGcJSTqPWOyEmy7NvPT0BP6324=;
  b=TwGKTQC0iuk6xPqsYLHp883zUwyCq/jn29yjU8oEqbASzrMSp0L1SHBE
   YAgC+zLgdIUUINfW9C+tS9ErjkY+DSbh0MOw4FBZ9OX31fEYuYmPEu+5X
   RkZxsxp7Ib0CMwauQsIegQLID8SWqtaTxNwQtPvFpo9z8WTysm1IsuyOY
   d3c9n5MOOL4+5J+fV0oq6tLwXWNRGQ63geQxUhdYs4z2I5n/HrkGzDL3J
   Szd3HnB0LQE3dZzuStOOBujDorbqfktdtD7pVlZZA8Qgb33R79AGTSaqQ
   fu0sHou4XAPyYU97JdXU0Z2OQD4jTisfreAXJFnckAU8+fk305mMvltoh
   A==;
X-CSE-ConnectionGUID: MMKHoLmQShC4ZQdRjt1GMQ==
X-CSE-MsgGUID: 7QrbIzqLSregA0Mth6YZEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="17166950"
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="17166950"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:25:06 -0700
X-CSE-ConnectionGUID: ksjkjPKdQsOvLn+RVuv2wg==
X-CSE-MsgGUID: bv4BEl1vTXCxuzgG3wAyIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="78172561"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.72.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:25:05 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v13 8/8] cxl/test: add cxl-poison.sh unit test
Date: Fri,  5 Jul 2024 23:24:54 -0700
Message-Id: <4212bf9d89e31a17f0092b84da473de2abf554a2.1720241079.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1720241079.git.alison.schofield@intel.com>
References: <cover.1720241079.git.alison.schofield@intel.com>
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
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 test/cxl-poison.sh | 137 +++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build   |   2 +
 2 files changed, 139 insertions(+)
 create mode 100644 test/cxl-poison.sh

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
new file mode 100644
index 000000000000..2caf092db460
--- /dev/null
+++ b/test/cxl-poison.sh
@@ -0,0 +1,137 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2023 Intel Corporation. All rights reserved.
+
+. "$(dirname "$0")"/common
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
+
+find_memdev()
+{
+	readarray -t capable_mems < <("$CXL" list -b "$CXL_TEST_BUS" -M |
+		jq -r ".[] | select(.pmem_size != null) |
+		select(.ram_size != null) | .memdev")
+
+	if [ ${#capable_mems[@]} == 0 ]; then
+		echo "no memdevs found for test"
+		err "$LINENO"
+	fi
+
+	memdev=${capable_mems[0]}
+}
+
+create_x2_region()
+{
+	# Find an x2 decoder
+	decoder="$($CXL list -b "$CXL_TEST_BUS" -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 2) |
+		.decoder")"
+
+	# Find a memdev for each host-bridge interleave position
+	port_dev0="$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 0) | .target")"
+	port_dev1="$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 1) | .target")"
+	mem0="$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")"
+	mem1="$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")"
+
+	region="$($CXL create-region -d "$decoder" -m "$mem0" "$mem1" |
+		jq -r ".region")"
+	if [[ ! $region ]]; then
+		echo "create-region failed for $decoder"
+		err "$LINENO"
+	fi
+	echo "$region"
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
+validate_poison_found()
+{
+	list_by="$1"
+	nr_expect="$2"
+
+	poison_list="$($CXL list "$list_by" --media-errors |
+		jq -r '.[].media_errors')"
+	if [[ ! $poison_list ]]; then
+		nr_found=0
+	else
+		nr_found=$(jq "length" <<< "$poison_list")
+	fi
+	if [ "$nr_found" -ne "$nr_expect" ]; then
+		echo "$nr_expect poison records expected, $nr_found found"
+		err "$LINENO"
+	fi
+}
+
+test_poison_by_memdev()
+{
+	find_memdev
+	inject_poison_sysfs "$memdev" "0x40000000"
+	inject_poison_sysfs "$memdev" "0x40001000"
+	inject_poison_sysfs "$memdev" "0x600"
+	inject_poison_sysfs "$memdev" "0x0"
+	validate_poison_found "-m $memdev" 4
+
+	clear_poison_sysfs "$memdev" "0x40000000"
+	clear_poison_sysfs "$memdev" "0x40001000"
+	clear_poison_sysfs "$memdev" "0x600"
+	clear_poison_sysfs "$memdev" "0x0"
+	validate_poison_found "-m $memdev" 0
+}
+
+test_poison_by_region()
+{
+	create_x2_region
+	inject_poison_sysfs "$mem0" "0x40000000"
+	inject_poison_sysfs "$mem1" "0x40000000"
+	validate_poison_found "-r $region" 2
+
+	clear_poison_sysfs "$mem0" "0x40000000"
+	clear_poison_sysfs "$mem1" "0x40000000"
+	validate_poison_found "-r $region" 0
+}
+
+# Turn tracing on. Note that 'cxl list --media-errors' toggles the tracing.
+# Turning it on here allows the test user to also view inject and clear
+# trace events.
+echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
+
+test_poison_by_memdev
+test_poison_by_region
+
+check_dmesg "$LINENO"
+
+modprobe -r cxl-test
diff --git a/test/meson.build b/test/meson.build
index a965a79fd6cb..d871e28e17ce 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -160,6 +160,7 @@ cxl_events = find_program('cxl-events.sh')
 cxl_sanitize = find_program('cxl-sanitize.sh')
 cxl_destroy_region = find_program('cxl-destroy-region.sh')
 cxl_qos_class = find_program('cxl-qos-class.sh')
+cxl_poison = find_program('cxl-poison.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -192,6 +193,7 @@ tests = [
   [ 'cxl-sanitize.sh',        cxl_sanitize,       'cxl'   ],
   [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
   [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
+  [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.37.3

