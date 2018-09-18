Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C273C21A07A80
 for <linux-nvdimm@lists.01.org>; Tue, 18 Sep 2018 13:16:39 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl,
 test: add a new unit test pfn metadata error clearing
Date: Tue, 18 Sep 2018 14:15:57 -0600
Message-Id: <20180918201557.6043-1-vishal.l.verma@intel.com>
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

The pfn driver lacked a way to clear badblocks in the volatile struct
page area, but this is expected to be fixed for v4.20.
Add a unit test that creates an fsdax namespace, forces it to raw mode,
injects errors to the metadata area, and converts it back to fsdax.

For a kernel with the error clearing improvements, this will clear the
injected errors, but if the kernel changes are missing, the errors will
stay intact. At this point, convert the namespace back to raw mode and
check for the presence of badblocks.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/Makefile.am        |  3 +-
 test/pfn-meta-errors.sh | 74 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 1 deletion(-)
 create mode 100755 test/pfn-meta-errors.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index 50bb2e4..ebdd23f 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -24,7 +24,8 @@ TESTS =\
 	rescan-partitions.sh \
 	inject-smart.sh \
 	monitor.sh \
-	max_available_extent_ns.sh
+	max_available_extent_ns.sh \
+	pfn-meta-errors.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/pfn-meta-errors.sh b/test/pfn-meta-errors.sh
new file mode 100755
index 0000000..2b57f19
--- /dev/null
+++ b/test/pfn-meta-errors.sh
@@ -0,0 +1,74 @@
+#!/bin/bash -Ex
+
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+blockdev=""
+rc=77
+
+. ./common
+
+force_raw()
+{
+	raw="$1"
+	$NDCTL disable-namespace "$dev"
+	echo "$raw" > "/sys/bus/nd/devices/$dev/force_raw"
+	$NDCTL enable-namespace "$dev"
+	echo "Set $dev to raw mode: $raw"
+	if [[ "$raw" == "1" ]]; then
+		raw_bdev=${blockdev}
+		test -b "/dev/$raw_bdev"
+	else
+		raw_bdev=""
+	fi
+}
+
+check_min_kver "4.20" || do_skip "may lack PFN metadata error handling"
+
+set -e
+trap 'err $LINENO' ERR
+
+# setup (reset nfit_test dimms)
+modprobe nfit_test
+$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+
+rc=1
+
+# create a fsdax namespace and clear errors (if any)
+dev="x"
+json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem -m fsdax)
+eval "$(echo "$json" | json2var)"
+[ $dev = "x" ] && echo "fail: $LINENO" && exit 1
+
+force_raw 1
+if read -r sector len < "/sys/block/$raw_bdev/badblocks"; then
+	dd of=/dev/$raw_bdev if=/dev/zero oflag=direct bs=512 seek="$sector" count="$len"
+fi
+force_raw 0
+
+# find dataoff from sb
+force_raw 1
+doff=$(hexdump -s $((4096 + 56)) -n 4 "/dev/$raw_bdev" | head -1 | cut -d' ' -f2-)
+doff=$(tr -d ' ' <<< "0x${doff#* }${doff%% *}")
+printf "pfn dataoff: %x\n" "$doff"
+dblk="$((doff/512))"
+
+metaoff="0x2000"
+mblk="$((metaoff/512))"
+
+# inject in the middle of the struct page area
+bb_inj=$(((dblk - mblk)/2))
+$NDCTL inject-error --block="$bb_inj" --count=32 $dev
+$NDCTL start-scrub && $NDCTL wait-scrub
+
+# after probe from the enable-namespace, the error should've been cleared
+force_raw 0
+force_raw 1
+if read -r sector len < "/sys/block/$raw_bdev/badblocks"; then
+	false
+fi
+
+_cleanup
+exit 0
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
