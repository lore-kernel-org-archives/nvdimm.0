Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1A29721F3882D
 for <linux-nvdimm@lists.01.org>; Thu, 12 Oct 2017 17:08:48 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 4/6] ndctl/test: add a new unit test for inject-error
Date: Thu, 12 Oct 2017 18:10:02 -0600
Message-Id: <20171013001004.14963-5-vishal.l.verma@intel.com>
In-Reply-To: <20171013001004.14963-1-vishal.l.verma@intel.com>
References: <20171013001004.14963-1-vishal.l.verma@intel.com>
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

Add a new unit test to test all the features of the inject-error
command.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/Makefile.am     |   3 +-
 test/inject-error.sh | 120 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 122 insertions(+), 1 deletion(-)
 create mode 100755 test/inject-error.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index ac3547e..8cec451 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -13,7 +13,8 @@ TESTS =\
 	multi-dax.sh \
 	btt-check.sh \
 	label-compat.sh \
-	blk-exhaust.sh
+	blk-exhaust.sh \
+	inject-error.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/inject-error.sh b/test/inject-error.sh
new file mode 100755
index 0000000..976be5e
--- /dev/null
+++ b/test/inject-error.sh
@@ -0,0 +1,120 @@
+#!/bin/bash -Ex
+
+# Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
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
+dev=""
+size=""
+blockdev=""
+rc=77
+err_block=42
+err_count=8
+
+trap 'err $LINENO' ERR
+
+# sample json:
+#{
+#  "dev":"namespace7.0",
+#  "mode":"memory",
+#  "size":"60.00 MiB (62.92 MB)",
+#  "uuid":"f1baa71a-d165-4da4-bb6a-083a2b0e6469",
+#  "blockdev":"pmem7",
+#}
+
+# $1: Line number
+# $2: exit code
+err()
+{
+	[ -n "$2" ] && rc="$2"
+	echo "test/inject-error.sh: failed at line $1"
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
+check_min_kver "4.15" || { echo "kernel $KVER may not support error injection"; exit "$rc"; }
+
+create()
+{
+	json=$($ndctl create-namespace -b "$bus" -t pmem --align=4k)
+	eval "$(echo "$json" | sed -e "$json2var")"
+	[ -n "$dev" ] || err "$LINENO" 2
+	[ -n "$size" ] || err "$LINENO" 2
+	[ -n "$blockdev" ] || err "$LINENO" 2
+	[ $size -gt 0 ] || err "$LINENO" 2
+}
+
+reset()
+{
+	$ndctl disable-region -b "$bus" all
+	$ndctl zero-labels -b "$bus" all
+	$ndctl enable-region -b "$bus" all
+}
+
+check_status()
+{
+	local sector="$1"
+	local count="$2"
+
+	json="$($ndctl inject-error --status $dev)"
+	[[ "$sector" == "$(jq ".badblocks[0].block" <<< "$json")" ]]
+	[[ "$count" == "$(jq ".badblocks[0].count" <<< "$json")" ]]
+}
+
+do_tests()
+{
+	# inject without notification
+	$ndctl inject-error --block=$err_block --count=$err_count --no-notify $dev
+	check_status "$err_block" "$err_count"
+	if read -r sector len < /sys/block/$blockdev/badblocks; then
+		# fail if reading badblocks returns data
+		echo "fail: $LINENO" && exit 1
+	fi
+
+	# clear via err-inj-clear
+	$ndctl inject-error --block=$err_block --count=$err_count --uninject $dev
+	check_status
+
+	# inject normally
+	$ndctl inject-error --block=$err_block --count=$err_count $dev
+	check_status "$err_block" "$err_count"
+	if read -r sector len < /sys/block/$blockdev/badblocks; then
+		test "$sector" -eq "$err_block"
+		test "$len" -eq "$err_count"
+	fi
+
+	# clear via write
+	dd if=/dev/zero of=/dev/$blockdev bs=512 count=$err_count seek=$err_block oflag=direct
+	if read -r sector len < /sys/block/$blockdev/badblocks; then
+		# fail if reading badblocks returns data
+		echo "fail: $LINENO" && exit 1
+	fi
+	check_status
+}
+
+modprobe nfit_test
+rc=1
+reset && create
+do_tests
+reset
+exit 0
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
