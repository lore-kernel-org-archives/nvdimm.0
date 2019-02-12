Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3CF3121A134A1
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 13:42:08 -0800 (PST)
Subject: [ndctl PATCH 8/8] ndctl/test: Test inter-region collision handling
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Feb 2019 13:29:29 -0800
Message-ID: <155000696975.348282.1495093645316313930.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Given the discovery of a broken padding implementation in the kernel
introduce a regression test to validate collision handling and dax
operation. It is known to fail as of v5.0-rc1.

The test relies on a custom memmap= configuration to generate the
problematic physical alignment condition. Details of the required memmap
configuration are listed / validated in the test script.

The test also validates that the kernel implementation preserves the
pre-v1.3 info block behavior while implementing the new v1.3+ behavior.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/Makefile.am     |    1 
 test/collide.sh      |  226 ++++++++++++++++++++++++++++++++++++++++++++++++++
 test/fsdax-info0.xxd |   11 ++
 test/fsdax-info1.xxd |   11 ++
 test/fsdax-info2.xxd |   11 ++
 test/fsdax-info3.xxd |   11 ++
 6 files changed, 271 insertions(+)
 create mode 100755 test/collide.sh
 create mode 100644 test/fsdax-info0.xxd
 create mode 100644 test/fsdax-info1.xxd
 create mode 100644 test/fsdax-info2.xxd
 create mode 100644 test/fsdax-info3.xxd

diff --git a/test/Makefile.am b/test/Makefile.am
index 42009c310b14..2f7cf5f24afd 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -53,6 +53,7 @@ TESTS +=\
 	dax.sh \
 	device-dax \
 	device-dax-fio.sh \
+	collide.sh \
 	mmap.sh
 
 check_PROGRAMS +=\
diff --git a/test/collide.sh b/test/collide.sh
new file mode 100755
index 000000000000..65b2664bbcc3
--- /dev/null
+++ b/test/collide.sh
@@ -0,0 +1,226 @@
+#!/bin/bash -x
+
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2015-2019 Intel Corporation. All rights reserved.
+
+set -e
+
+SKIP=77
+FAIL=1
+SUCCESS=0
+
+. ./common
+
+check_min_kver "5.0" || do_skip "may lack align collision fixes"
+check_prereq xxd
+
+MNT=test_dax_mnt
+mkdir -p $MNT
+
+rc=$FAIL
+cleanup() {
+	if [ $rc -ne $SUCCESS ]; then
+		echo "test/collide.sh: failed at line $1"
+	fi
+	if mountpoint -q $MNT; then
+		umount $MNT
+	fi
+	rmdir $MNT
+	# opportunistic cleanup, not fatal if these fail
+	for i in $regions
+	do
+		if ! $NDCTL destroy-namespace -f -r $i all; then
+			echo "test/collide.sh: cleanup() failed to destroy $i"
+		fi
+		if ! $NDCTL enable-namespace -r $i all; then
+			echo "test/collide.sh: cleanup() failed to re-enable $i"
+		fi
+	done
+	exit $rc
+}
+
+
+trap 'err $LINENO cleanup' ERR
+
+modprobe nd_e820
+
+# Require TEST_NUM consecutive regions of TEST_SIZE in size, where
+# TEST_SIZE causes every other namespace to collide within a 128MB
+# boundary. I.e. trigger the kernel to allocate a 'start_pad' area. As
+# of writing, an example memmap= configuration this test expects is:
+#    memmap=$((4      << 30))!$((( 7 << 30)))
+#    memmap=$((64 * 3 << 20))!$(((11 << 30)))
+#    memmap=$((64 * 3 << 20))!$(((11 << 30) + (64 * 3 << 20)))
+#    memmap=$((64 * 3 << 20))!$(((11 << 30) + (64 * 6 << 20)))
+#    memmap=$((64 * 3 << 20))!$(((11 << 30) + (64 * 9 << 20)))
+# ...where the first region is the area for tests that depend on the
+# namespace identified by test/dax-dev, and the rest are four namespace
+# that collide per the expectations of this test.
+TEST_NUM=4
+TEST_SIZE=$((64*3 << 20))
+json=$($NDCTL list -Ri -b e820)
+len=$(echo $json | jq length)
+if [ $len -lt $TEST_NUM ]; then
+	exit $SKIP
+fi
+
+found=0
+prev_resource=0
+regions=$(echo $json | jq -r ". | sort_by(.dev) | .[].dev")
+first_region=""
+for i in $regions
+do
+	resource=$(cat /sys/bus/nd/devices/$i/resource)
+	size=$(cat /sys/bus/nd/devices/$i/size)
+	if [ $((size)) -ne $TEST_SIZE ]; then
+		prev_resource=0
+		found=0
+		continue
+	fi
+	if [ $((prev_resource)) -gt 0 ]; then
+		if [ $((prev_resource + TEST_SIZE)) -ne $((resource)) ]; then
+			prev_resource=0
+			found=0
+		else
+			prev_resource=$resource
+			found=$((found+1))
+		fi
+	else
+		first_region=$i
+		prev_resource=$resource
+		found=1
+	fi
+done
+if [ $found -lt $TEST_NUM ]; then
+	echo "failed to find $TEST_NUM regions of size $((TEST_SIZE >> 20))MB"
+	exit $FAIL
+fi
+
+region_id() {
+	echo ${1:6}
+}
+
+reset_region() {
+	id=$(region_id $1)
+	idx=$2
+	ns="namespace${id}.0"
+	# clear out any existing info blocks
+	$NDCTL enable-region $1
+	$NDCTL destroy-namespace $ns -f
+
+	# check that every other namespace fails to auto-enable due to
+	# dev_pagemap collisions
+	if $NDCTL enable-namespace $ns; then
+		if [ $((idx & 1)) -eq 1 ]; then
+			echo "expected enable region$id (idx: $idx) failure"
+			exit $FAIL
+		fi
+	else
+		if [ $((idx & 1)) -eq 0 ]; then
+			echo "expected enable region$id (idx: $idx) success"
+			exit $FAIL
+		fi
+	fi
+}
+
+restore_region() {
+	id=$(region_id $1)
+	idx=$2
+	ns="namespace${id}.0"
+	# restore saved v1.2 info block
+	$NDCTL enable-region $1
+	$NDCTL destroy-namespace $ns -f
+	echo 1 > /sys/bus/nd/devices/$ns/force_raw
+	$NDCTL enable-namespace $ns
+	xxd -r fsdax-info$idx.xxd /dev/pmem$id
+	blockdev --flushbufs /dev/pmem$id
+	echo 0 > /sys/bus/nd/devices/$ns/force_raw
+	$NDCTL disable-namespace $ns
+
+	# check size
+	$NDCTL enable-namespace $ns
+	size=$($NDCTL list -n $ns | jq -r '.[].size')
+	if [ $size -ne 130023424 ]; then
+		false
+	fi
+
+	# check for every other @idx dax-mount fails
+	mkfs.ext4 -b 4096 /dev/pmem$id
+	fail=0
+	mount -o dax /dev/pmem$id $MNT || fail=1
+	if [ $fail -eq 0 ]; then
+		umount $MNT
+		if [ $((idx & 1)) -eq 1 ]; then
+			echo "expected dax-mount region$id (idx: $idx) failure"
+			false
+		fi
+	else
+		if [ $((idx & 1)) -eq 0 ]; then
+			echo "expected dax-mount region$id (idx: $idx) success"
+			false
+		fi
+	fi
+}
+
+# validate pre-5.1 info block handling
+idx=0
+$NDCTL disable-region all -b e820
+for i in $regions
+do
+	if [ $(region_id $i) -lt $(region_id $first_region) ]; then
+		continue
+	fi
+	restore_region $i $idx
+	idx=$((idx+1))
+done
+
+# validate alignment collision assumptions
+idx=0
+$NDCTL disable-region -b e820 all
+for i in $regions
+do
+	if [ $(region_id $i) -lt $(region_id $first_region) ]; then
+		continue
+	fi
+	reset_region $i $idx
+	idx=$((idx+1))
+done
+
+# use ext4 to check for successful dax mount
+check_dax() {
+	id=$(region_id $1)
+	idx=$2
+	ns="namespace${id}.0"
+
+	$NDCTL create-namespace -e $ns -m fsdax -M dev -f
+	mkfs.ext4 -b 4096 /dev/pmem$id
+	mount -o dax /dev/pmem$id $MNT
+	umount $MNT
+}
+
+check_size() {
+	id=$(region_id $1)
+	ns="namespace${id}.0"
+	pfn_size=$($NDCTL list -n $ns | jq -r ".[] | .size")
+	bdev_size=$(blockdev --getsize64 /dev/pmem$id)
+
+	if [ $pfn_size -ne $bdev_size ]; then
+		false
+	fi
+}
+
+for i in $regions
+do
+	if [ $(region_id $i) -lt $(region_id $first_region) ]; then
+		continue
+	fi
+	check_dax $i
+	check_size $i
+done
+
+# check probe
+$NDCTL disable-namespace -b e820 all
+$NDCTL enable-namespace -b e820 all
+
+rc=$SUCCESS
+cleanup $LINENO
diff --git a/test/fsdax-info0.xxd b/test/fsdax-info0.xxd
new file mode 100644
index 000000000000..a89f581ffd7e
--- /dev/null
+++ b/test/fsdax-info0.xxd
@@ -0,0 +1,11 @@
+00000000: 0000 0000 0000 0000 0000 0000 0000 0000  ................
+*
+00001000: 4e56 4449 4d4d 5f50 464e 5f49 4e46 4f00  NVDIMM_PFN_INFO.
+00001010: 2406 11fa 696a 40e7 b85f b9b9 e326 4a3a  $...ij@.._...&J:
+00001020: 0000 0000 0000 0000 0000 0000 0000 0000  ................
+00001030: 0000 0000 0100 0200 0000 4000 0000 0000  ..........@.....
+00001040: 007c 0000 0000 0000 0200 0000 0000 0000  .|..............
+00001050: 0000 0004 0000 2000 0200 0000 0000 0000  ...... .........
+00001060: 0000 0000 0000 0000 0000 0000 0000 0000  ................
+*
+00001ff0: 0000 0000 0000 0000 5cab 09bd be77 7a8d  ........\....wz.
diff --git a/test/fsdax-info1.xxd b/test/fsdax-info1.xxd
new file mode 100644
index 000000000000..36dd36d897bc
--- /dev/null
+++ b/test/fsdax-info1.xxd
@@ -0,0 +1,11 @@
+00000000: 0000 0000 0000 0000 0000 0000 0000 0000  ................
+*
+00001000: 4e56 4449 4d4d 5f50 464e 5f49 4e46 4f00  NVDIMM_PFN_INFO.
+00001010: af1d b9a0 b422 4188 8b3f 67bc 610c 546b  ....."A..?g.a.Tk
+00001020: 0000 0000 0000 0000 0000 0000 0000 0000  ................
+00001030: 0000 0000 0100 0200 0000 4000 0000 0000  ..........@.....
+00001040: 007c 0000 0000 0000 0200 0000 0000 0004  .|..............
+00001050: 0000 0000 0000 2000 0200 0000 0000 0000  ...... .........
+00001060: 0000 0000 0000 0000 0000 0000 0000 0000  ................
+*
+00001ff0: 0000 0000 0000 0000 8340 6a38 b796 d2ec  .........@j8....
diff --git a/test/fsdax-info2.xxd b/test/fsdax-info2.xxd
new file mode 100644
index 000000000000..dc19f7a89342
--- /dev/null
+++ b/test/fsdax-info2.xxd
@@ -0,0 +1,11 @@
+00000000: 0000 0000 0000 0000 0000 0000 0000 0000  ................
+*
+00001000: 4e56 4449 4d4d 5f50 464e 5f49 4e46 4f00  NVDIMM_PFN_INFO.
+00001010: 4c1e 026f 2939 4910 bcf7 0f8e 4dbd ab56  L..o)9I.....M..V
+00001020: 0000 0000 0000 0000 0000 0000 0000 0000  ................
+00001030: 0000 0000 0100 0200 0000 4000 0000 0000  ..........@.....
+00001040: 007c 0000 0000 0000 0200 0000 0000 0000  .|..............
+00001050: 0000 0004 0000 2000 0200 0000 0000 0000  ...... .........
+00001060: 0000 0000 0000 0000 0000 0000 0000 0000  ................
+*
+00001ff0: 0000 0000 0000 0000 b2c0 bb4b 60b8 2cf4  ...........K`.,.
diff --git a/test/fsdax-info3.xxd b/test/fsdax-info3.xxd
new file mode 100644
index 000000000000..468fea13b78a
--- /dev/null
+++ b/test/fsdax-info3.xxd
@@ -0,0 +1,11 @@
+00000000: 0000 0000 0000 0000 0000 0000 0000 0000  ................
+*
+00001000: 4e56 4449 4d4d 5f50 464e 5f49 4e46 4f00  NVDIMM_PFN_INFO.
+00001010: 80ee 77a1 321b 4938 80f2 74a5 234d 2468  ..w.2.I8..t.#M$h
+00001020: 0000 0000 0000 0000 0000 0000 0000 0000  ................
+00001030: 0000 0000 0100 0200 0000 4000 0000 0000  ..........@.....
+00001040: 007c 0000 0000 0000 0200 0000 0000 0004  .|..............
+00001050: 0000 0000 0000 2000 0200 0000 0000 0000  ...... .........
+00001060: 0000 0000 0000 0000 0000 0000 0000 0000  ................
+*
+00001ff0: 0000 0000 0000 0000 89fd 0ecf f199 9fac  ................

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
