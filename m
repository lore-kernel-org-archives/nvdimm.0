Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 815E221945DF3
 for <linux-nvdimm@lists.01.org>; Wed, 31 Jan 2018 14:00:31 -0800 (PST)
Subject: [PATCH v5 4/4] ndctl, test: firmware update unit test
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 31 Jan 2018 15:06:07 -0700
Message-ID: <151743636731.50357.13469426517564809891.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151743627634.50357.2692734095508615676.stgit@djiang5-desk3.ch.intel.com>
References: <151743627634.50357.2692734095508615676.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding a unit test that will use nfit_test kernel module to test the
firmware update sequence.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/Makefile.am        |    3 +-
 test/firmware-update.sh |   65 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 1 deletion(-)
 create mode 100755 test/firmware-update.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index d4c2bd6..d5ef648 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -16,7 +16,8 @@ TESTS =\
 	blk-exhaust.sh \
 	sector-mode.sh \
 	inject-error.sh \
-	btt-errors.sh
+	btt-errors.sh \
+	firmware-update.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/firmware-update.sh b/test/firmware-update.sh
new file mode 100755
index 0000000..79767d2
--- /dev/null
+++ b/test/firmware-update.sh
@@ -0,0 +1,65 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+[ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ] && ndctl="../ndctl/ndctl"
+[ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ] && ndctl="./ndctl/ndctl"
+[ -z "$ndctl" ] && echo "Couldn't find an ndctl binary" && exit 1
+bus="nfit_test.0"
+json2var="s/[{}\",]//g; s/:/=/g"
+rc=77
+dev=""
+image="update-fw.img"
+
+trap 'err $LINENO' ERR
+
+# $1: Line number
+# $2: exit code
+err()
+{
+	[ -n "$2" ] && rc="$2"
+	echo "test/firmware-update.sh: failed at line $1"
+	exit "$rc"
+}
+
+check_min_kver()
+{
+	local ver="$1"
+	: "${KVER:=$(uname -r)}"
+
+	[ -n "$ver" ] || return 1
+	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
+}
+
+reset()
+{
+	$ndctl disable-region -b "$bus" all
+	$ndctl zero-labels -b "$bus" all
+	$ndctl enable-region -b "$bus" all
+	if [ -f $image ]; then
+		rm -f $image
+	fi
+}
+
+detect()
+{
+	dev=$($ndctl list -b "$bus" -D | jq .[0].dev | tr -d '"')
+	[ -n "$dev" ] || err "$LINENO" 2
+}
+
+do_tests()
+{
+	fallocate -l 196608 $image
+	$ndctl update-firmware -d $dev -f $image
+}
+
+check_min_kver "4.16" || { echo "kernel $KVER may lack firmware update test handling"; exit
+$rc; }
+modprobe nfit_test
+rc=1
+reset
+detect
+do_tests
+reset
+exit 0
+

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
