Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F09ED22283504
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 15:50:45 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, test: add a unit test for partition rescanning
Date: Mon,  5 Mar 2018 16:56:55 -0700
Message-Id: <20180305235655.9927-1-vishal.l.verma@intel.com>
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
Cc: Dariusz Dokupil <dariusz.dokupil@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

pre-4.16 kernels had a bug where BTT partitions wouldn't come up on
driver probe because we were adding a zero-sized disk. Add a unit test
that creates partitions, and cycles the namespace to ensure the
partitions are automatically brought up. This performs the test for raw,
memory, and sector modes.

Reported-by: Dariusz Dokupil <dariusz.dokupil@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/Makefile.am          |   3 +-
 test/rescan-partitions.sh | 106 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+), 1 deletion(-)
 create mode 100755 test/rescan-partitions.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index 749055c..496a663 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -20,7 +20,8 @@ TESTS =\
 	hugetlb \
 	btt-pad-compat.sh \
 	firmware-update.sh \
-	ack-shutdown-count-set
+	ack-shutdown-count-set \
+	rescan-partitions.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/rescan-partitions.sh b/test/rescan-partitions.sh
new file mode 100755
index 0000000..6dd289b
--- /dev/null
+++ b/test/rescan-partitions.sh
@@ -0,0 +1,106 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+[ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ] && ndctl="../ndctl/ndctl"
+[ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ] && ndctl="./ndctl/ndctl"
+[ -z "$ndctl" ] && echo "Couldn't find an ndctl binary" && exit 1
+bus="nfit_test.0"
+json2var="s/[{}\",]//g; s/:/=/g"
+dev=""
+size=""
+blockdev=""
+rc=77
+
+trap 'err $LINENO' ERR
+
+# sample json:
+#{
+#  "dev":"namespace5.0",
+#  "mode":"sector",
+#  "size":"60.00 MiB (62.92 MB)",
+#  "uuid":"f1baa71a-d165-4da4-bb6a-083a2b0e6469",
+#  "blockdev":"pmem5s",
+#}
+
+# $1: Line number
+# $2: exit code
+err()
+{
+	[ -n "$2" ] && rc="$2"
+	echo "test/rescan-partitions.sh: failed at line $1"
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
+check_min_kver "4.16" || { echo "kernel $KVER may not contain fixes for partition rescanning"; exit "$rc"; }
+
+check_prereq()
+{
+	if ! command -v "$1" >/dev/null; then
+		echo "missing '$1', skipping.."
+		exit "$rc"
+	fi
+}
+check_prereq "parted"
+check_prereq "blockdev"
+
+reset()
+{
+	$ndctl disable-region -b "$bus" all
+	$ndctl zero-labels -b "$bus" all
+	$ndctl enable-region -b "$bus" all
+}
+
+test_mode()
+{
+	local mode="$1"
+
+	# create namespace
+	json=$($ndctl create-namespace -b "$bus" -t pmem -m "$mode")
+	eval "$(echo "$json" | sed -e "$json2var")"
+	[ -n "$dev" ] || err "$LINENO" 2
+	[ -n "$size" ] || err "$LINENO" 2
+	[ -n "$blockdev" ] || err "$LINENO" 2
+	[ $size -gt 0 ] || err "$LINENO" 2
+
+	# create partition
+	parted --script /dev/$blockdev mklabel gpt mkpart primary 1MiB 10MiB
+
+	# verify it is created
+	sleep 1
+	blockdev --rereadpt /dev/$blockdev
+	sleep 1
+	partdev="$(grep -Eo "${blockdev}.+" /proc/partitions)"
+	test -b /dev/$partdev
+
+	# cycle the namespace, and verify the partition is read
+	# without needing to do a blockdev --rereadpt
+	$ndctl disable-namespace $dev
+	$ndctl enable-namespace $dev
+	if [ -b /dev/$partdev ]; then
+		echo "mode: $mode - partition read successful"
+	else
+		echo "mode: $mode - partition read failed"
+		err "$LINENO" 1
+	fi
+
+	$ndctl disable-namespace $dev
+	$ndctl destroy-namespace $dev
+}
+
+rc=1
+reset
+test_mode "raw"
+test_mode "memory"
+test_mode "sector"
+reset
+
+exit 0
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
