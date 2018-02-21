Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3DAE92034D8C9
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 10:06:57 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/2] ndctl: tests must use local ndctl
Date: Wed, 21 Feb 2018 11:12:47 -0700
Message-Id: <20180221181248.13351-1-ross.zwisler@linux.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Fix a few places in our unit tests where we were using the system ndctl
instead of the locally built one.  On my system this was leading to false
positive test failures because my local ndctl didn't support this new
command:

  ndctl check-namespace --rewrite-log --repair --force --verbose $dev

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 test/btt-errors.sh     | 4 ++--
 test/btt-pad-compat.sh | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/test/btt-errors.sh b/test/btt-errors.sh
index 68e3652..383abb6 100755
--- a/test/btt-errors.sh
+++ b/test/btt-errors.sh
@@ -47,9 +47,9 @@ force_raw()
 {
 	raw="$1"
 	if grep -q "$MNT" /proc/mounts; then umount $MNT; fi
-	ndctl disable-namespace "$dev"
+	$NDCTL disable-namespace "$dev"
 	echo "$raw" > "/sys/bus/nd/devices/$dev/force_raw"
-	ndctl enable-namespace "$dev"
+	$NDCTL enable-namespace "$dev"
 	echo "Set $dev to raw mode: $raw"
 	if [[ "$raw" == "1" ]]; then
 		raw_bdev=${blockdev%s}
diff --git a/test/btt-pad-compat.sh b/test/btt-pad-compat.sh
index faa773c..618e802 100755
--- a/test/btt-pad-compat.sh
+++ b/test/btt-pad-compat.sh
@@ -112,9 +112,9 @@ cycle_ns()
 force_raw()
 {
 	raw="$1"
-	ndctl disable-namespace "$dev"
+	$ndctl disable-namespace "$dev"
 	echo "$raw" > "/sys/bus/nd/devices/$dev/force_raw"
-	ndctl enable-namespace "$dev"
+	$ndctl enable-namespace "$dev"
 	echo "Set $dev to raw mode: $raw"
 	if [[ "$raw" == "1" ]]; then
 		raw_bdev=${blockdev%s}
@@ -187,13 +187,13 @@ do_tests()
 	verify_idx 0 2
 
 	# rewrite log using ndctl, verify conversion to new format
-	ndctl check-namespace --rewrite-log --repair --force --verbose $dev
+	$ndctl check-namespace --rewrite-log --repair --force --verbose $dev
 	do_random_io "/dev/$blockdev"
 	cycle_ns "$dev"
 	verify_idx 0 1
 
 	# check-namespace again to make sure everything is ok
-	ndctl check-namespace --force --verbose $dev
+	$ndctl check-namespace --force --verbose $dev
 
 	# the old format btt metadata was created with a null parent uuid,
 	# making it 'stickier' than a normally created btt. Be sure to clean
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
