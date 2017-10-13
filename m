Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0EE6321F7D4F0
 for <linux-nvdimm@lists.01.org>; Thu, 12 Oct 2017 17:08:49 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 6/6] ndctl/test: add a new unit test for BTT error
 clearing
Date: Thu, 12 Oct 2017 18:10:04 -0600
Message-Id: <20171013001004.14963-7-vishal.l.verma@intel.com>
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

The new error injection command allows us to inject errors that persist
through changing the mode of a BTT namespace to 'raw' and back. This
allows us to test error clearing with a BTT by adding a selective error
block to the raw namespace, enabling the BTT, and then clearing it via a
write.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/Makefile.am   |   3 +-
 test/btt-errors.sh | 149 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 151 insertions(+), 1 deletion(-)
 create mode 100755 test/btt-errors.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index 8cec451..881fcea 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -14,7 +14,8 @@ TESTS =\
 	btt-check.sh \
 	label-compat.sh \
 	blk-exhaust.sh \
-	inject-error.sh
+	inject-error.sh \
+	btt-errors.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/btt-errors.sh b/test/btt-errors.sh
new file mode 100755
index 0000000..aec0b9d
--- /dev/null
+++ b/test/btt-errors.sh
@@ -0,0 +1,149 @@
+#!/bin/bash -x
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
+NDCTL="../ndctl/ndctl"
+BUS="nfit_test.0"
+MNT=test_btt_mnt
+FILE=image
+json2var="s/[{}\",]//g; s/:/=/g"
+blockdev=""
+rc=77
+
+err() {
+	rc=1
+	echo "test/btt-errors: failed at line $1"
+
+	rm -f $FILE
+	rm -f $MNT/$FILE
+	if [ -n "$blockdev" ]; then
+		umount "/dev/$blockdev"
+	else
+		rc=77
+	fi
+	rmdir $MNT
+	exit $rc
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
+force_raw()
+{
+	raw="$1"
+	if grep -q "$MNT" /proc/mounts; then umount $MNT; fi
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
+check_min_kver "4.14" || { echo "kernel $KVER may lack BTT error handling"; exit $rc; }
+
+set -e
+mkdir -p $MNT
+trap 'err $LINENO' ERR
+
+# setup (reset nfit_test dimms)
+modprobe nfit_test
+$NDCTL disable-region -b "$BUS" all
+$NDCTL zero-labels -b "$BUS" all
+$NDCTL enable-region -b "$BUS" all
+
+rc=1
+
+# create a btt namespace and clear errors (if any)
+dev="x"
+json=$($NDCTL create-namespace -b "$BUS" -t pmem -m sector)
+eval "$(echo "$json" | sed -e "$json2var")"
+[ $dev = "x" ] && echo "fail: $LINENO" && exit 1
+
+force_raw 1
+if read -r sector len < "/sys/block/$raw_bdev/badblocks"; then
+	dd of=/dev/$raw_bdev if=/dev/zero oflag=direct bs=512 seek="$sector" count="$len"
+fi
+force_raw 0
+
+mkfs.ext4 "/dev/$blockdev" -b 4096
+mount -o nodelalloc "/dev/$blockdev" $MNT
+
+# prepare an image file with random data
+dd if=/dev/urandom of=$FILE bs=4096 count=1
+test -s $FILE
+
+# copy it to the file system
+cp $FILE $MNT/$FILE
+
+# Get the start sector for the file
+start_sect=$(filefrag -v -b512 $MNT/$FILE | grep -E "^[ ]+[0-9]+.*" | head -1 | awk '{ print $4 }' | cut -d. -f1)
+start_4k=$((start_sect/8))
+test -n "$start_sect"
+echo "start sector of the file is: $start_sect (512B) or $start_4k (4096B)"
+
+# figure out the btt offset
+
+force_raw 1
+
+# calculate start of the map
+map=$(hexdump -s 96 -n 4 "/dev/$raw_bdev" | head -1 | cut -d' ' -f2-)
+map=$(tr -d ' ' <<< "0x${map#* }${map%% *}")
+printf "btt map starts at: %x\n" "$map"
+
+# calculate map entry byte offset for the file's block
+map_idx=$((map + (4 * start_4k)))
+printf "btt map entry location for sector %x: %x\n" "$start_4k" "$map_idx"
+
+# read the map entry
+map_ent=$(hexdump -s $map_idx -n 4 "/dev/$raw_bdev" | head -1 | cut -d' ' -f2-)
+map_ent=$(tr -d ' ' <<< "0x${map_ent#* }${map_ent%% *}")
+map_ent=$((map_ent & 0x3fffffff))
+printf "btt map entry: 0x%x\n" "$map_ent"
+
+# calculate the data offset
+dataoff=$(((map_ent * 4096) + 4096))
+printf "dataoff: 0x%x\n" "$dataoff"
+
+bb_inj=$((dataoff/512))
+
+# inject badblocks for one page at the start of the file
+$NDCTL inject-error --block="$bb_inj" --count=8 $dev
+
+force_raw 0
+mount -o nodelalloc "/dev/$blockdev" $MNT
+
+# make sure reading the first block of the file fails as expected
+: The following 'dd' is expected to hit an I/O Error
+dd if=$MNT/$FILE of=/dev/null iflag=direct bs=4096 count=1 && err $LINENO || true
+
+# write via btt to clear the error
+dd if=/dev/zero of=$MNT/$FILE oflag=direct bs=4096 count=1
+
+# read again and that should succeed
+dd if=$MNT/$FILE of=/dev/null iflag=direct bs=4096 count=1
+
+# done, exit
+$NDCTL disable-region -b "$BUS" all
+$NDCTL zero-labels -b "$BUS" all
+$NDCTL enable-region -b "$BUS" all
+exit 0
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
