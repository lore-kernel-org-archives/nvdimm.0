Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B59F2222C22F
 for <linux-nvdimm@lists.01.org>; Mon, 29 Jan 2018 16:35:11 -0800 (PST)
Subject: [PATCH v4 4/4] ndctl, test: firmware update unit test
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 29 Jan 2018 17:40:45 -0700
Message-ID: <151727284509.3109.4804710419338084460.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151727265453.3109.2878225498038263092.stgit@djiang5-desk3.ch.intel.com>
References: <151727265453.3109.2878225498038263092.stgit@djiang5-desk3.ch.intel.com>
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
 test/firmware-update.sh |   74 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 1 deletion(-)
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
index 0000000..ff777b9
--- /dev/null
+++ b/test/firmware-update.sh
@@ -0,0 +1,74 @@
+#!/bin/bash -Ex
+
+# Copyright(c) 2017 Intel Corporation. All rights reserved.
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of version 2 of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
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
