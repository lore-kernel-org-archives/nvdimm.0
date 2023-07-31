Received: from mgamail.intel.com (unknown [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465A71DDFF
	for <nvdimm@lists.linux.dev>; Mon, 31 Jul 2023 23:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690847653; x=1722383653;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=qSrHuo3hIW9jTblfoo7y2yfOEE1UgLgFNHDpnEUUXPU=;
  b=JkG8B3rwUh+fC9EkYL0xqxP7V3LQnpYGJeFfqcchT8o2hmPw9ypr/1X7
   ZbMAYuYEsWCkn5WU+Ch21lisCPwJANTi2+Cb8Rgaf7AR7zx2JhJaOEDsU
   PZiYDJDaRSM6nTOGnshcEfzvqy7qvikzh1y9MEOU2Hi3eJpj5bybFUiWt
   FaBJCv9HlJjk7Oh9eSqpiRptv1Tn3JTEDXNmE95KWqIOAOOrif27cKctZ
   0dWuMiCLWEmdb8awaNtdQkyxWGENtba9iIMT33J8GQ3tc+ls/b/fsHAcB
   u4xIeu5hRnK5DAB1+LN2XR2OubNMPVDzjKXSCAgyRc0yztX1cCnjq0Ix0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="372775242"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="372775242"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 16:54:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="678487821"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="678487821"
Received: from bgalla7x-mobl.amr.corp.intel.com (HELO localhost) ([10.212.24.48])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 16:54:03 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Mon, 31 Jul 2023 16:53:56 -0700
Subject: [PATCH ndctl v2] ndctl/cxl/test: Add CXL event test
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230726-cxl-event-v2-1-550f5625d22f@intel.com>
X-B4-Tracking: v=1; b=H4sIAJNJyGQC/22NywqDMBBFf0Vm3ZRkWuxj1f8oLpJxrAMaJQnBI
 v57o+tyV+dyHytEDsIRntUKgbNEmXwBPFVAvfUfVtIWBtR40TesFS2D4sw+qZa0ttg9rq7WUPL
 ORlYuWE/93hit+N2eA3eyHBfvpnAvMU3hezxms7v/xrNRRdTdyWl0aMxLfOLhTNMIzbZtP0CXG
 nu5AAAA
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>, 
 "Schofield, Alison" <alison.schofield@intel.com>, 
 "Williams, Dan J" <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org, 
 nvdimm@lists.linux.dev, Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.13-dev-c6835
X-Developer-Signature: v=1; a=ed25519-sha256; t=1690847639; l=4709;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=qSrHuo3hIW9jTblfoo7y2yfOEE1UgLgFNHDpnEUUXPU=;
 b=kk0Dt7blZv1b+8HUz2baBmNb7eN03vjsmYgwhJyyEKOSaNn3Db/SNTKIOP4AUsINl444admdC
 ilAgx9ETVUlAZ6cLHBzMGUpuD2T/ZGEgsKDKrMvRrCAMpAGcZyBCvMt
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Previously CXL event testing was run by hand.  This reduces testing
coverage including a lack of regression testing.

Add a CXL event test as part of the meson test infrastructure.  Passing
is predicated on receiving the appropriate number of errors in each log.
Individual event values are not checked.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
Changes in v2:
[djiang] run shellcheck and fix as needed                                                                             
[vishal] quote variables                                                                                              
[vishal] skip test if event_trigger is not available                                                                  
[vishal] remove dead code                                                                                             
[vishal] explicitly use the first memdev returned from cxl-cli                                                        
[vishal] store trace output in a variable                                                                             
[vishal] simplify grep statement looking for results                                                                  
[vishal] use variables for expected values                                                                            
- Link to v1: https://lore.kernel.org/r/20230726-cxl-event-v1-1-1cf8cb02b211@intel.com
---
 test/cxl-events.sh | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build   |  2 ++
 2 files changed, 78 insertions(+)

diff --git a/test/cxl-events.sh b/test/cxl-events.sh
new file mode 100644
index 000000000000..33b68daa6ade
--- /dev/null
+++ b/test/cxl-events.sh
@@ -0,0 +1,76 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2023 Intel Corporation. All rights reserved.
+
+. "$(dirname "$0")/common"
+
+# Results expected
+num_overflow_expected=1
+num_fatal_expected=2
+num_failure_expected=16
+num_info_expected=3
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
+	if [ ! -f "${dev_path}/${memdev}/event_trigger" ]; then
+		echo "TEST: Kernel does not support test event trigger"
+		exit 77
+	fi
+
+	echo "TEST: triggering $memdev"
+	echo 1 > "${dev_path}/${memdev}/event_trigger"
+}
+
+readarray -t memdevs < <("$CXL" list -b cxl_test -Mi | jq -r '.[].host')
+
+echo "TEST: Prep event trace"
+echo "" > /sys/kernel/tracing/trace
+echo 1 > /sys/kernel/tracing/events/cxl/enable
+echo 1 > /sys/kernel/tracing/tracing_on
+
+test_cxl_events "${memdevs[0]}"
+
+echo 0 > /sys/kernel/tracing/tracing_on
+
+echo "TEST: Events seen"
+trace_out=$(cat /sys/kernel/tracing/trace)
+
+num_overflow=$(grep -c "cxl_overflow" <<< "${trace_out}")
+num_fatal=$(grep -c "log=Fatal" <<< "${trace_out}")
+num_failure=$(grep -c "log=Failure" <<< "${trace_out}")
+num_info=$(grep -c "log=Informational" <<< "${trace_out}")
+echo "     LOG     (Expected) : (Found)"
+echo "     overflow      ($num_overflow_expected) : $num_overflow"
+echo "     Fatal         ($num_fatal_expected) : $num_fatal"
+echo "     Failure       ($num_failure_expected) : $num_failure"
+echo "     Informational ($num_info_expected) : $num_info"
+
+if [ "$num_overflow" -ne $num_overflow_expected ]; then
+	err "$LINENO"
+fi
+if [ "$num_fatal" -ne $num_fatal_expected ]; then
+	err "$LINENO"
+fi
+if [ "$num_failure" -ne $num_failure_expected ]; then
+	err "$LINENO"
+fi
+if [ "$num_info" -ne $num_info_expected ]; then
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

