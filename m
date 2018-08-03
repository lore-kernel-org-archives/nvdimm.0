Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 31E4121A00AE6
 for <linux-nvdimm@lists.01.org>; Fri,  3 Aug 2018 15:22:46 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, tests: add a new unit test for inject-smart
Date: Fri,  3 Aug 2018 16:22:42 -0600
Message-Id: <20180803222242.10357-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add a new unit test that exercises all the functionality provided by the
ndctl inject-smart command. This performs injections, un-injections, and
sets thresholds, and verifies all this happened successfully.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/Makefile.am     |   1 +
 test/inject-smart.sh | 178 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 179 insertions(+)
 create mode 100755 test/inject-smart.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index 8c55056..6156a7a 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -22,6 +22,7 @@ TESTS =\
 	firmware-update.sh \
 	ack-shutdown-count-set \
 	rescan-partitions.sh \
+	inject-smart.sh \
 	monitor.sh
 
 check_PROGRAMS =\
diff --git a/test/inject-smart.sh b/test/inject-smart.sh
new file mode 100755
index 0000000..18655ba
--- /dev/null
+++ b/test/inject-smart.sh
@@ -0,0 +1,178 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+rc=77
+. ./common
+bus="$NFIT_TEST_BUS0"
+inj_val="42"
+
+trap 'err $LINENO' ERR
+
+# sample json:
+# {
+#  "dev":"nmem0",
+#  "id":"cdab-0a-07e0-ffffffff",
+#  "handle":0,
+#  "phys_id":0,
+#  "health":{
+#    "health_state":"non-critical",
+#    "temperature_celsius":23,
+#    "spares_percentage":75,
+#    "alarm_temperature":true,
+#    "alarm_spares":true,
+#    "temperature_threshold":40,
+#    "spares_threshold":5,
+#    "life_used_percentage":5,
+#    "shutdown_state":"clean"
+#  }
+#}
+
+translate_field()
+{
+	local in="$1"
+
+	case $in in
+	media-temperature)
+		echo "temperature_celsius"
+		;;
+	ctrl-temperature)
+		echo "controller_temperature_celsius"
+		;;
+	spares)
+		echo "spares_percentage"
+		;;
+	media-temperature-alarm)
+		echo "alarm_temperature"
+		;;
+	ctrl-temperature-alarm)
+		echo "alarm_controller_temperature"
+		;;
+	spares-alarm)
+		echo "alarm_spares"
+		;;
+	media-temperature-threshold)
+		echo "temperature_threshold"
+		;;
+	spares-threshold)
+		echo "spares_threshold"
+		;;
+	unsafe-shutdown)
+		echo "shutdown_state"
+		;;
+	fatal)
+		echo "health_state"
+		;;
+	*)
+		# passthrough
+		echo "$in"
+		return
+		;;
+	esac
+}
+
+translate_val()
+{
+	local in="$1"
+
+	case $in in
+	dirty)
+		;&
+	fatal)
+		;&
+	true)
+		echo "1"
+		;;
+	non-critical)
+		;&
+	clean)
+		;&
+	false)
+		echo "0"
+		;;
+	*)
+		# passthrough
+		echo "$in"
+		;;
+	esac
+}
+
+get_field()
+{
+	local field="$1"
+	local smart_listing="$(translate_field $field)"
+
+	json="$($NDCTL list -b $bus -d $dimm -H)"
+	val="$(jq -r ".[].dimms[].health.$smart_listing" <<< $json)"
+	val="$(translate_val $val)"
+	echo $val
+}
+
+verify()
+{
+	local field="$1"
+	local val="$2"
+
+	[[ "$val" == "$(get_field $field)" ]]
+}
+
+test_field()
+{
+	local field="$1"
+	local val="$2"
+	local op="$3"
+	local old_val=""
+
+	if [ -n "$val" ]; then
+		inj_opt="--${field}=${val}"
+	else
+		inj_opt="--${field}"
+	fi
+
+	old_val=$(get_field $field)
+	if [[ "$old_val" == "0" || "$old_val" == "1" ]]; then
+		val=$(((old_val + 1) % 2))
+	fi
+	$NDCTL inject-smart -b $bus $dimm $inj_opt
+	verify $field $val
+
+	if [[ "$op" != "thresh" ]]; then
+		$NDCTL inject-smart -b $bus --${field}-uninject $dimm
+		verify $field $old_val
+	fi
+}
+
+do_tests()
+{
+	local fields_val=(media-temperature spares)
+	local fields_bool=(unsafe-shutdown fatal)
+	local fields_thresh=(media-temperature-threshold spares-threshold)
+	local field=""
+
+	$NDCTL inject-smart -b $bus --uninject-all $dimm
+
+	# start tests
+	for field in "${fields_val[@]}"; do
+		test_field $field $inj_val
+	done
+
+	for field in "${fields_bool[@]}"; do
+		test_field $field
+	done
+
+	for field in "${fields_thresh[@]}"; do
+		test_field $field $inj_val "thresh"
+	done
+}
+
+check_min_kver "4.19" || do_skip "kernel $KVER may not support smart (un)injection"
+modprobe nfit_test
+rc=1
+
+jlist=$(./list-smart-dimm -b $bus)
+dimm="$(jq '.[]."dev"?, ."dev"?' <<< $jlist | sort | head -1 | xargs)"
+test -n "$dimm"
+
+do_tests
+_cleanup
+exit 0
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
