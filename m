Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B1A3202E5483
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 22:36:31 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id ADF97AC00F7
 for <linux-nvdimm@lists.01.org>; Sat,  7 Jul 2018 14:36:21 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH v3] ndctl, test: add a new unit test for monitor
Date: Sat,  7 Jul 2018 14:35:55 +0900
Message-Id: <20180707053555.3192-1-qi.fuli@jp.fujitsu.com>
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

Add a new unit test to test the following options of the monitor command.
   --dimm
   --bus
   --region
   --namespace
   --logfile
   --config-file

Based-on-patch-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
v2 -> v3:
 - Add filter_obj instead of hard-coded values
v1 -> v2:
 - Add init()
 - Add get_filter_dimm() to get the filter dimms by ndctl list command
   instead of hard-cording
 - Add sleep to call_notify()

 test/Makefile.am |   3 +-
 test/monitor.sh  | 134 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 136 insertions(+), 1 deletion(-)
 create mode 100755 test/monitor.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index cd451e9..8c76462 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -21,7 +21,8 @@ TESTS =\
 	btt-pad-compat.sh \
 	firmware-update.sh \
 	ack-shutdown-count-set \
-	rescan-partitions.sh
+	rescan-partitions.sh \
+	monitor.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/monitor.sh b/test/monitor.sh
new file mode 100755
index 0000000..4a7d733
--- /dev/null
+++ b/test/monitor.sh
@@ -0,0 +1,134 @@
+#!/bin/bash -Ex
+
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2018, FUJITSU LIMITED. All rights reserved.
+
+rc=77
+logfile=""
+conf_file=""
+filter_dimms=""
+filter_obj=""
+monitor_pid=65536
+
+. ./common
+
+trap 'err $LINENO' ERR
+
+check_min_kver "4.15" || do_skip "kernel $KVER may not support monitor service"
+
+start_monitor()
+{
+	logfile=$(mktemp)
+	$NDCTL monitor -l $logfile $1 &
+	monitor_pid=$!
+	truncate --size 0 $logfile #remove startup log
+}
+
+get_filter_dimm()
+{
+	jlist=$($NDCTL list -D -b $NFIT_TEST_BUS0 $1)
+	filter_dimms=$(jq '.[]."dev"?, ."dev"?' <<<$jlist | sort | uniq | sed -e ':loop; N; $!b loop; s/\n/:/g' | sed 's/\"//g')
+}
+
+call_notify()
+{
+	./smart-notify $NFIT_TEST_BUS0
+	sync; sleep 3
+}
+
+check_result()
+{
+	jlog=$(cat $logfile)
+	notify_dimms=$(jq ."dimm"."dev" <<<$jlog | sort | uniq | sed -e ':loop; N; $!b loop; s/\n/:/g' | sed 's/\"//g')
+	[[ $filter_dimms == $notify_dimms ]]
+}
+
+stop_monitor()
+{
+	kill $monitor_pid
+	rm $logfile
+}
+
+create_conf_file()
+{
+	conf_file=$(mktemp)
+	echo "dimm = $1" > $conf_file
+	cat $conf_file
+}
+
+test_filter_dimm()
+{
+	filter_obj=$($NDCTL list -D -b $NFIT_TEST_BUS0 | jq -r .[0].dev)
+	get_filter_dimm "-d $filter_obj"
+	start_monitor "-d $filter_obj"
+	call_notify
+	check_result
+	stop_monitor
+}
+
+test_filter_bus()
+{
+	get_filter_dimm
+	start_monitor "-b $NFIT_TEST_BUS0"
+	call_notify
+	check_result
+	stop_monitor
+}
+
+test_filter_region()
+{
+	filter_obj=$($NDCTL list -R -b $NFIT_TEST_BUS0 | jq -r .[0].dev)
+	get_filter_dimm "-r $filter_obj"
+	start_monitor "-r $filter_obj"
+	call_notify
+	check_result
+	stop_monitor
+}
+
+test_filter_namespace()
+{
+	filter_obj=$($NDCTL list -N -b $NFIT_TEST_BUS0 | jq -r .[0].dev)
+	[ -z $filter_obj ] && filter_obj="namespace1.0"
+	$NDCTL create-namespace -r $($NDCTL list -R -b $NFIT_TEST_BUS0 | jq -r .[0].dev) -n $filter_obj
+	get_filter_dimm "-n $filter_obj"
+	start_monitor "-n $filter_obj"
+	call_notify
+	check_result
+	stop_monitor
+	$NDCTL destroy-namespace $filter_obj -f
+}
+
+test_conf_file()
+{
+	filter_obj=$($NDCTL list -D -b $NFIT_TEST_BUS0 | jq -r .[0].dev)
+	filter_dimms=$filter_obj
+	create_conf_file  $filter_obj
+	start_monitor "-c $conf_file"
+	call_notify
+	check_result
+	stop_monitor
+	rm $conf_file
+}
+
+do_tests()
+{
+	test_filter_dimm
+	test_filter_bus
+	test_filter_region
+	test_filter_namespace
+	test_conf_file
+}
+
+init()
+{
+	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+}
+
+modprobe nfit_test
+rc=1
+init
+do_tests
+_cleanup
+exit 0
-- 
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
