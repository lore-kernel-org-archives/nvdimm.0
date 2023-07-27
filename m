Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE09D17AC4
	for <nvdimm@lists.linux.dev>; Thu, 27 Jul 2023 21:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690493217; x=1722029217;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=Wti/jXSZfQ/t2DS4yBYQhpyKMfzz6KR66DqQJw09Fxo=;
  b=Yab4ksaXexKfotYkDBk5LE3X7gbRtjRmKTU/deTS/AVpKVnglqXdd4Nd
   PtVci3zraeTFrmfQ4RPwub2UJNjJ/c32sXvu8NE4m2o1fKCBU2sy6wDnk
   ZZ6Q2QCJ7zIA1FSSvDkd6g4gy/9lIrI3H8BRkbvM/VqtzoqgZLz3/XW7o
   QZWvmqwGOK9DBLcB8mWRyOy/FZvVOB81d1t3oDB6e7sNWmfND6t7TkWo7
   WxbvekALyFwEODJHY9KIdpJlNReaivtTFkEHo6gPUgMNDXH/wdNgWoZ14
   gEuKpMCl2T6l4VO9fv2Sj5nZvKZ01Ausdsby2pO3eMMNlrD7/is1R1svT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10784"; a="399373687"
X-IronPort-AV: E=Sophos;i="6.01,236,1684825200"; 
   d="scan'208";a="399373687"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2023 14:26:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10784"; a="721020671"
X-IronPort-AV: E=Sophos;i="6.01,236,1684825200"; 
   d="scan'208";a="721020671"
Received: from iweiny-mobl.amr.corp.intel.com (HELO localhost) ([10.212.124.125])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2023 14:26:56 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Thu, 27 Jul 2023 14:21:09 -0700
Subject: [PATCH ndctl] ndctl/cxl/test: Add CXL event test
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230726-cxl-event-v1-1-1cf8cb02b211@intel.com>
X-B4-Tracking: v=1; b=H4sIAMTfwmQC/x2NQQqEMAxFryJZTyBTRRmvIrNIa9TAmJFWRBDvb
 nX5Pu/zDkgSVRK0xQFRNk36twzvVwFhYhsFtc8MjlxJjasx7D+UTWzFPhCxGz6Vrwmy7zkJ+sg
 Wpvsxs9o9L1EG3Z9E9z3PC4tk8DtyAAAA
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>, 
 "Schofield, Alison" <alison.schofield@intel.com>, 
 "Williams, Dan J" <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org, 
 nvdimm@lists.linux.dev, Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.13-dev-c6835
X-Developer-Signature: v=1; a=ed25519-sha256; t=1690493215; l=3320;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=Wti/jXSZfQ/t2DS4yBYQhpyKMfzz6KR66DqQJw09Fxo=;
 b=1kCWbI3eVo/adZgF0XED9DM2ToWNVzwIaK2JeL/foEL4SRRIzpUqAr258dvLudp3FiPbcUCNh
 +cc/pGIYTB4ABKbRDaHAkzqxQcDSHJHYQ1sdNPq4fD28VBG0TRn26MJ
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Previously CXL event testing was run by hand.  This reduces testing
coverage including a lack of regression testing.

Add a CXL test as part of the meson test infrastructure.  Passing is
predicated on receiving the appropriate number of errors in each log.
Individual event values are not checked.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 test/cxl-events.sh | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build   |  2 ++
 2 files changed, 70 insertions(+)

diff --git a/test/cxl-events.sh b/test/cxl-events.sh
new file mode 100644
index 000000000000..f51046ec39ad
--- /dev/null
+++ b/test/cxl-events.sh
@@ -0,0 +1,68 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2023 Intel Corporation. All rights reserved.
+
+. $(dirname $0)/common
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
+dev_path="/sys/bus/platform/devices"
+
+test_cxl_events()
+{
+	memdev="$1"
+
+	echo "TEST: triggering $memdev"
+	echo 1 > $dev_path/$memdev/event_trigger
+}
+
+readarray -t memdevs < <("$CXL" list -b cxl_test -Mi | jq -r '.[].host')
+
+echo "TEST: Prep event trace"
+echo "" > /sys/kernel/tracing/trace
+echo 1 > /sys/kernel/tracing/events/cxl/enable
+echo 1 > /sys/kernel/tracing/tracing_on
+
+# Only need to test 1 device
+#for memdev in ${memdevs[@]}; do
+#done
+
+test_cxl_events "$memdevs"
+
+echo 0 > /sys/kernel/tracing/tracing_on
+
+echo "TEST: Events seen"
+cat /sys/kernel/tracing/trace
+num_overflow=$(grep "cxl_overflow" /sys/kernel/tracing/trace | wc -l)
+num_fatal=$(grep "log=Fatal" /sys/kernel/tracing/trace | wc -l)
+num_failure=$(grep "log=Failure" /sys/kernel/tracing/trace | wc -l)
+num_info=$(grep "log=Informational" /sys/kernel/tracing/trace | wc -l)
+echo "     LOG     (Expected) : (Found)"
+echo "     overflow      ( 1) : $num_overflow"
+echo "     Fatal         ( 2) : $num_fatal"
+echo "     Failure       (16) : $num_failure"
+echo "     Informational ( 3) : $num_info"
+
+if [ "$num_overflow" -ne 1 ]; then
+	err "$LINENO"
+fi
+if [ "$num_fatal" -ne 2 ]; then
+	err "$LINENO"
+fi
+if [ "$num_failure" -ne 16 ]; then
+	err "$LINENO"
+fi
+if [ "$num_info" -ne 3 ]; then
+	err "$LINENO"
+fi
+
+check_dmesg "$LINENO"
+
+modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index a956885f6df6..a33255bde1a8 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -155,6 +155,7 @@ cxl_sysfs = find_program('cxl-region-sysfs.sh')
 cxl_labels = find_program('cxl-labels.sh')
 cxl_create_region = find_program('cxl-create-region.sh')
 cxl_xor_region = find_program('cxl-xor-region.sh')
+cxl_events = find_program('cxl-events.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -183,6 +184,7 @@ tests = [
   [ 'cxl-labels.sh',          cxl_labels,	  'cxl'   ],
   [ 'cxl-create-region.sh',   cxl_create_region,  'cxl'   ],
   [ 'cxl-xor-region.sh',      cxl_xor_region,     'cxl'   ],
+  [ 'cxl-events.sh',          cxl_events,         'cxl'   ],
 ]
 
 if get_option('destructive').enabled()

---
base-commit: 2fd570a0ed788b1bd0971dfdb1466a5dbcb79775
change-id: 20230726-cxl-event-dc00a2f94b60

Best regards,
-- 
Ira Weiny <ira.weiny@intel.com>

