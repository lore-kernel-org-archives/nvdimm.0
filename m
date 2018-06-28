Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B4FFB202E5403
 for <linux-nvdimm@lists.01.org>; Thu, 28 Jun 2018 15:13:08 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, test: add start/wait scrub to injection tests
Date: Thu, 28 Jun 2018 16:13:03 -0600
Message-Id: <20180628221303.3837-1-vishal.l.verma@intel.com>
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

A number of tests that perform error injection were missing the
start/wait scrub workaround needed for nfit_test namespaces, causing
these tests to ocassionally fail. Fix it by starting and waiting for a
scrub after injection in these remaining places.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/btt-errors.sh   | 2 ++
 test/clear.sh        | 1 +
 test/inject-error.sh | 1 +
 3 files changed, 4 insertions(+)

diff --git a/test/btt-errors.sh b/test/btt-errors.sh
index e9cc209..cb35865 100755
--- a/test/btt-errors.sh
+++ b/test/btt-errors.sh
@@ -115,6 +115,7 @@ bb_inj=$((dataoff/512))
 
 # inject badblocks for one page at the start of the file
 $NDCTL inject-error --block="$bb_inj" --count=8 $dev
+$NDCTL start-scrub && $NDCTL wait-scrub
 
 force_raw 0
 mount -o nodelalloc "/dev/$blockdev" $MNT
@@ -148,6 +149,7 @@ map=$(hexdump -s 96 -n 4 "/dev/$raw_bdev" | head -1 | cut -d' ' -f2-)
 map=$(tr -d ' ' <<< "0x${map#* }${map%% *}")
 bb_inj=$((map/512))
 $NDCTL inject-error --block="$bb_inj" --count=1 $dev
+$NDCTL start-scrub && $NDCTL wait-scrub
 force_raw 0
 
 # make sure reading the first block of the namespace fails
diff --git a/test/clear.sh b/test/clear.sh
index 6cc43db..17d5bed 100755
--- a/test/clear.sh
+++ b/test/clear.sh
@@ -41,6 +41,7 @@ err_sector="$(((size/512) / 2))"
 err_count=8
 if ! read sector len < /sys/block/$blockdev/badblocks; then
 	$NDCTL inject-error --block="$err_sector" --count=$err_count $dev
+	$NDCTL start-scrub && $NDCTL wait-scrub
 fi
 read sector len < /sys/block/$blockdev/badblocks
 [ $((sector * 2)) -ne $((size /512)) ] && echo "fail: $LINENO" && exit 1
diff --git a/test/inject-error.sh b/test/inject-error.sh
index 7bda35b..49e68b3 100755
--- a/test/inject-error.sh
+++ b/test/inject-error.sh
@@ -77,6 +77,7 @@ do_tests()
 
 	# inject normally
 	$NDCTL inject-error --block=$err_block --count=$err_count $dev
+	$NDCTL start-scrub && $NDCTL wait-scrub
 	check_status "$err_block" "$err_count"
 	if read -r sector len < /sys/block/$blockdev/badblocks; then
 		test "$sector" -eq "$err_block"
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
