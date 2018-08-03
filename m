Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x241.google.com (mail-qt0-x241.google.com
 [IPv6:2607:f8b0:400d:c0d::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB3B921A00AE6
 for <linux-nvdimm@lists.01.org>; Fri,  3 Aug 2018 11:52:42 -0700 (PDT)
Received: by mail-qt0-x241.google.com with SMTP id c15-v6so7302538qtp.0
 for <linux-nvdimm@lists.01.org>; Fri, 03 Aug 2018 11:52:42 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: [PATCH v2] ndctl,
 test: add a new unit test for max_available_extent namespace
Date: Fri,  3 Aug 2018 14:52:19 -0400
Message-Id: <20180803185219.16242-1-msys.mizuma@gmail.com>
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
 test/max_available_extent_ns.sh | 43 +++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)
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
index 0000000..beea3bd
--- /dev/null
+++ b/test/max_available_extent_ns.sh
@@ -0,0 +1,43 @@
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
+	region=$($NDCTL list -b $NFIT_TEST_BUS0 -R -t pmem | jq -r .[].dev | head -1)
+
+	available_sz=$($NDCTL list -r $region | jq -r .[].available_size)
+	size=$(( available_sz/4 ))
+
+	NS1=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
+	NS2=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
+	NS3=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
+
+	$NDCTL disable-namespace $NS2
+	$NDCTL destroy-namespace $NS2
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
