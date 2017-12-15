Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 069E62216D8C3
 for <linux-nvdimm@lists.01.org>; Thu, 14 Dec 2017 16:22:02 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/2] ndctl,
 test: Add a test for the BTT padding incompatibility fix
Date: Thu, 14 Dec 2017 17:26:38 -0700
Message-Id: <20171215002638.25531-2-vishal.l.verma@intel.com>
In-Reply-To: <20171215002638.25531-1-vishal.l.verma@intel.com>
References: <20171215002638.25531-1-vishal.l.verma@intel.com>
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

The test verifies that new BTTs use 'log indices' (0, 1), and also that
old format BTTs can still be read, and that they have log indices of
(0, 2). In both cases, we do some random IO to the namespaces, cycle
them, and verify that the BTT index detection still works.

Reported-by: Juston Li <juston.li@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/Makefile.am       |   3 +-
 test/btt-pad-compat.sh | 208 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 210 insertions(+), 1 deletion(-)
 create mode 100755 test/btt-pad-compat.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index 6698d6c..065f5cb 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -16,7 +16,8 @@ TESTS =\
 	blk-exhaust.sh \
 	sector-mode.sh \
 	inject-error.sh \
-	btt-errors.sh
+	btt-errors.sh \
+	btt-pad-compat.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/btt-pad-compat.sh b/test/btt-pad-compat.sh
new file mode 100755
index 0000000..cbfe990
--- /dev/null
+++ b/test/btt-pad-compat.sh
@@ -0,0 +1,208 @@
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
+	echo "test/btt-pad-compat.sh: failed at line $1"
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
+check_min_kver "4.15" || { echo "kernel $KVER may not have btt padding compat fixes"; exit "$rc"; }
+
+check_prereq()
+{
+	if ! command -v "$1" >/dev/null; then
+		echo "missing '$1', skipping.."
+		exit "$rc"
+	fi
+}
+
+create()
+{
+	json=$($ndctl create-namespace -b "$bus" -t pmem -m sector)
+	eval "$(echo "$json" | sed -e "$json2var")"
+	[ -n "$dev" ] || err "$LINENO" 2
+	[ -n "$size" ] || err "$LINENO" 2
+	[ -n "$blockdev" ] || err "$LINENO" 2
+	[ $size -gt 0 ] || err "$LINENO" 2
+	bttdev=$(cat /sys/bus/nd/devices/$dev/holder)
+	[ -n "$bttdev" ] || err "$LINENO" 2
+}
+
+reset()
+{
+	$ndctl disable-region -b "$bus" all
+	$ndctl zero-labels -b "$bus" all
+	$ndctl enable-region -b "$bus" all
+}
+
+verify_idx()
+{
+	idx0="$1"
+	idx1="$2"
+
+	# check debugfs is mounted
+	if ! grep -qE "debugfs" /proc/mounts; then
+		mount -t debugfs none /sys/kernel/debug
+	fi
+
+	test $(cat /sys/kernel/debug/btt/$bttdev/arena0/log_index_0) -eq "$idx0"
+	test $(cat /sys/kernel/debug/btt/$bttdev/arena0/log_index_1) -eq "$idx1"
+}
+
+do_random_io()
+{
+	local bdev="$1"
+
+	dd if=/dev/urandom of="$bdev" bs=4096 count=32 seek=0 &
+	dd if=/dev/urandom of="$bdev" bs=4096 count=32 seek=32 &
+	dd if=/dev/urandom of="$bdev" bs=4096 count=32 seek=64 &
+	dd if=/dev/urandom of="$bdev" bs=4096 count=32 seek=128 &
+	dd if=/dev/urandom of="$bdev" bs=4096 count=32 seek=256 &
+	dd if=/dev/urandom of="$bdev" bs=4096 count=32 seek=512 &
+	dd if=/dev/urandom of="$bdev" bs=4096 count=32 seek=1024 &
+	dd if=/dev/urandom of="$bdev" bs=4096 count=32 seek=2048 &
+	wait
+}
+
+cycle_ns()
+{
+	local ns="$1"
+
+	$ndctl disable-namespace $ns
+	$ndctl enable-namespace $ns
+}
+
+force_raw()
+{
+	raw="$1"
+	ndctl disable-namespace "$dev"
+	echo "$raw" > "/sys/bus/nd/devices/$dev/force_raw"
+	ndctl enable-namespace "$dev"
+	echo "Set $dev to raw mode: $raw"
+	if [[ "$raw" == "1" ]]; then
+		raw_bdev=${blockdev%s}
+		test -b "/dev/$raw_bdev"
+	else
+		raw_bdev=""
+	fi
+}
+
+copy_xxd_img()
+{
+	local bdev="$1"
+	local xxd_patch="btt-pad-compat.xxd"
+
+	test -s "$xxd_patch"
+	test -b "$bdev"
+	xxd -r "$xxd_patch" "$bdev"
+}
+
+create_oldfmt_ns()
+{
+	# create null-uuid namespace
+	$ndctl create-namespace -b "$bus" -t pmem -m raw -l 4096 -u 00000000-0000-0000-0000-000000000000
+	eval "$(echo "$json" | sed -e "$json2var")"
+	[ -n "$dev" ] || err "$LINENO" 2
+	[ -n "$size" ] || err "$LINENO" 2
+	[ $size -gt 0 ] || err "$LINENO" 2
+
+	# reconfig it to sector mode
+	$ndctl create-namespace -b "$bus" -e $dev -m sector --force
+	eval "$(echo "$json" | sed -e "$json2var")"
+	[ -n "$dev" ] || err "$LINENO" 2
+	[ -n "$size" ] || err "$LINENO" 2
+	[ -n "$blockdev" ] || err "$LINENO" 2
+	[ $size -gt 0 ] || err "$LINENO" 2
+	bttdev=$(cat /sys/bus/nd/devices/$dev/holder)
+	[ -n "$bttdev" ] || err "$LINENO" 2
+
+	# copy old-padding-format btt image, and try to re-enable the resulting btt
+	force_raw 1
+	copy_xxd_img "/dev/$raw_bdev"
+	force_raw 0
+	test -b "/dev/$blockdev"
+}
+
+ns_info_wipe()
+{
+	force_raw 1
+	dd if=/dev/zero of=/dev/$raw_bdev bs=4096 count=2
+}
+
+do_tests()
+{
+	# regular btt
+	create
+	verify_idx 0 1
+
+	# do io, and cycle namespace, verify indices
+	do_random_io "/dev/$blockdev"
+	cycle_ns "$dev"
+	verify_idx 0 1
+
+	# do the same with an old format namespace
+	create_oldfmt_ns
+	verify_idx 0 2
+
+	# do io, and cycle namespace, verify indices
+	do_random_io "/dev/$blockdev"
+	cycle_ns "$dev"
+	verify_idx 0 2
+
+	# the old format btt metadata was created with a null parent uuid,
+	# making it 'stickier' than a normally created btt. Be sure to clean
+	# it up by wiping the info block
+	ns_info_wipe
+}
+
+modprobe nfit_test
+check_prereq xxd
+rc=1
+reset
+do_tests
+reset
+exit 0
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
