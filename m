Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B49720968917
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 04:23:37 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 84AFBAC00B6
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 20:23:32 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH] ndctl, test: add a new unit test for monitor
Date: Thu,  5 Jul 2018 20:23:04 +0900
Message-Id: <20180705112304.2656-1-qi.fuli@jp.fujitsu.com>
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

Add a new unit test to test the follow options of the monitor command.
   --dimm
   --bus
   --region
   --namespace
   --logfile
   --config-file

Based-on-patch-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 test/Makefile.am |   3 +-
 test/monitor.sh  | 115 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+), 1 deletion(-)
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
index 0000000..4f113c8
--- /dev/null
+++ b/test/monitor.sh
@@ -0,0 +1,115 @@
+#!/bin/bash -Ex
+
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2018, FUJITSU LIMITED. All rights reserved.
+
+rc=77
+logfile=""
+conf_file=""
+monitor_pid=65536
+FILTER_DIMM="nmem1"
+FILTER_BUS="ndbus1"
+FILTER_BUS_MAP_DIMM="nmem0:nmem1:nmem2:nmem3"
+FILTER_REGION="region1"
+FILTER_REGION_MAP_DIMM="nmem0:nmem1"
+FILTER_NAMESPACE="namespace1.0"
+FILTER_NAMESPACE_MAP_DIMM="nmem0:nmem1"
+CONF_FILE_SET_DIMM="nmem1:nmem3"
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
+call_notify()
+{
+	./smart-notify $NFIT_TEST_BUS0
+}
+
+check_result()
+{
+	json=$(cat $logfile)
+	dimms=$(jq ."dimm"."dev" <<<$json | sort | uniq | sed -e ':loop; N; $!b loop; s/\n/:/g' | sed 's/\"//g')
+	[[ $1 == $dimms ]]
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
+	echo 'dimm=nmem1 nmem3' > $conf_file
+	cat $conf_file
+}
+
+test_filter_dimm()
+{
+	start_monitor "-d $FILTER_DIMM"
+	call_notify
+	check_result "$FILTER_DIMM"
+	stop_monitor
+}
+
+test_filter_bus()
+{
+	start_monitor "-b $FILTER_BUS"
+	call_notify
+	check_result $FILTER_BUS_MAP_DIMM
+	stop_monitor
+}
+
+test_filter_region()
+{
+	start_monitor "-r $FILTER_REGION"
+	call_notify
+	check_result $FILTER_REGION_MAP_DIMM
+	stop_monitor
+}
+
+test_filter_namespace()
+{
+	$NDCTL create-namespace -r region1 -n $FILTER_NAMESPACE
+	start_monitor "-n $FILTER_NAMESPACE"
+	call_notify
+	check_result $FILTER_NAMESPACE_MAP_DIMM
+	stop_monitor
+	$NDCTL destroy-namespace $FILTER_NAMESPACE -f
+}
+
+test_conf_file()
+{
+	create_conf_file
+	start_monitor "-c $conf_file"
+	call_notify
+	check_result $CONF_FILE_SET_DIMM
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
+modprobe nfit_test
+rc=1
+do_tests
+_cleanup
+exit 0
-- 
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
