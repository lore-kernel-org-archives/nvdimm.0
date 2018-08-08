Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw1-xc44.google.com (mail-yw1-xc44.google.com
 [IPv6:2607:f8b0:4864:20::c44])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1FD48210DF5EE
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 18:36:02 -0700 (PDT)
Received: by mail-yw1-xc44.google.com with SMTP id y203-v6so410793ywd.9
 for <linux-nvdimm@lists.01.org>; Tue, 07 Aug 2018 18:36:02 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: [PATCH v3] ndctl,
 test: add a new unit test for max_available_extent namespace
Date: Tue,  7 Aug 2018 21:35:45 -0400
Message-Id: <20180808013545.4541-1-msys.mizuma@gmail.com>
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
To: vishal.l.verma@intel.com, linux-nvdimm@lists.01.org
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Add a new unit test to test max_available_extent namespace.
This feature is implemented by the following patches.

  kernel side:
    https://lists.01.org/pipermail/linux-nvdimm/2018-July/016731.html
    https://lists.01.org/pipermail/linux-nvdimm/2018-July/016732.html

  ndctl side:
    https://lists.01.org/pipermail/linux-nvdimm/2018-July/017176.html

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 test/Makefile.am                |  3 ++-
 test/max_available_extent_ns.sh | 46 +++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)
 create mode 100755 test/max_available_extent_ns.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index 8c55056..9af2464 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -22,7 +22,8 @@ TESTS =\
 	firmware-update.sh \
 	ack-shutdown-count-set \
 	rescan-partitions.sh \
-	monitor.sh
+	monitor.sh \
+	max_available_extent_ns.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/max_available_extent_ns.sh b/test/max_available_extent_ns.sh
new file mode 100755
index 0000000..1c7e7bf
--- /dev/null
+++ b/test/max_available_extent_ns.sh
@@ -0,0 +1,46 @@
+#!/bin/bash -Ex
+
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2018, FUJITSU LIMITED. All rights reserved.
+
+rc=77
+
+. ./common
+
+trap 'err $LINENO' ERR
+
+check_min_kver "4.19" || do_skip "kernel $KVER may not support max_available_size"
+
+init()
+{
+	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+}
+
+do_test()
+{
+	region=$($NDCTL list -b $NFIT_TEST_BUS0 -R -t pmem | jq -r 'sort_by(-.size) | .[].dev' | head -1)
+
+	available_sz=$($NDCTL list -r $region | jq -r .[].available_size)
+	size=$(( available_sz/4 ))
+
+	NS=()
+	for ((i=0; i<3; i++))
+	do
+		NS[$i]=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
+		[[ -n ${NS[$i]} ]]
+	done
+
+	$NDCTL disable-namespace ${NS[1]}
+	$NDCTL destroy-namespace ${NS[1]}
+
+	$NDCTL create-namespace -r $region -t pmem
+}
+
+modprobe nfit_test
+rc=1
+init
+do_test
+_cleanup
+exit 0
-- 
2.18.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
