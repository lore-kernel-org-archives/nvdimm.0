Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x243.google.com (mail-qt0-x243.google.com
 [IPv6:2607:f8b0:400d:c0d::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56B052116DFB6
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jun 2018 12:37:11 -0700 (PDT)
Received: by mail-qt0-x243.google.com with SMTP id l10-v6so889770qtj.0
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jun 2018 12:37:11 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: [PATCH v3 2/2] ndctl, test: cleanup test scripts
Date: Tue, 19 Jun 2018 15:36:59 -0400
Message-Id: <20180619193659.17815-3-msys.mizuma@gmail.com>
In-Reply-To: <20180619193659.17815-1-msys.mizuma@gmail.com>
References: <20180619193659.17815-1-msys.mizuma@gmail.com>
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
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Cleanup some test scripts by using helper functions.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 test/blk-exhaust.sh       | 21 ++++++----------
 test/btt-check.sh         | 52 ++++++++++++++++++---------------------
 test/btt-errors.sh        | 30 +++++++++++-----------
 test/btt-pad-compat.sh    | 36 ++++++++++++---------------
 test/clear.sh             | 25 +++++++------------
 test/create.sh            | 26 +++++++++-----------
 test/daxdev-errors.sh     | 29 ++++++++--------------
 test/firmware-update.sh   | 25 +++++--------------
 test/inject-error.sh      | 24 ++++++++----------
 test/label-compat.sh      | 17 +++++--------
 test/multi-dax.sh         | 23 ++++++-----------
 test/pmem-errors.sh       | 19 +++++---------
 test/rescan-partitions.sh | 22 ++++++++---------
 test/sector-mode.sh       | 22 ++++++-----------
 14 files changed, 146 insertions(+), 225 deletions(-)

diff --git a/test/blk-exhaust.sh b/test/blk-exhaust.sh
index 1ec67fd..326ce73 100755
--- a/test/blk-exhaust.sh
+++ b/test/blk-exhaust.sh
@@ -13,9 +13,6 @@
 
 set -e
 
-NDCTL="../ndctl/ndctl"
-BUS="-b nfit_test.0"
-BUS1="-b nfit_test.1"
 rc=77
 
 . ./common
@@ -26,21 +23,19 @@ trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region $BUS all
-$NDCTL zero-labels $BUS all
-$NDCTL enable-region $BUS all
+$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 
 # if the kernel accounting is correct we should be able to create two
 # pmem and two blk namespaces on nfit_test.0
 rc=1
-$NDCTL create-namespace $BUS -t pmem
-$NDCTL create-namespace $BUS -t pmem
-$NDCTL create-namespace $BUS -t blk -m raw
-$NDCTL create-namespace $BUS -t blk -m raw
+$NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem
+$NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem
+$NDCTL create-namespace -b $NFIT_TEST_BUS0 -t blk -m raw
+$NDCTL create-namespace -b $NFIT_TEST_BUS0 -t blk -m raw
 
 # clearnup and exit
-$NDCTL disable-region $BUS all
-$NDCTL disable-region $BUS1 all
-modprobe -r nfit_test
+_cleanup
 
 exit 0
diff --git a/test/btt-check.sh b/test/btt-check.sh
index 0d5ca6e..ceabee5 100755
--- a/test/btt-check.sh
+++ b/test/btt-check.sh
@@ -11,11 +11,6 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
-[ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ] && ndctl="../ndctl/ndctl"
-[ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ] && ndctl="./ndctl/ndctl"
-[ -z "$ndctl" ] && echo "Couldn't find an ndctl binary" && exit 1
-bus="nfit_test.0"
-json2var="s/[{}\",]//g; s/:/=/g"
 dev=""
 mode=""
 size=""
@@ -42,9 +37,9 @@ check_min_kver "4.14" || do_skip "may not support badblocks clearing on pmem via
 
 create()
 {
-	json=$($ndctl create-namespace -b "$bus" -t pmem -m sector)
+	json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem -m sector)
 	rc=2
-	eval "$(echo "$json" | sed -e "$json2var")"
+	eval "$(echo "$json" | json2var)"
 	[ -n "$dev" ] || err "$LINENO"
 	[ "$mode" = "sector" ] || err "$LINENO"
 	[ -n "$size" ] || err "$LINENO"
@@ -55,9 +50,9 @@ create()
 
 reset()
 {
-	$ndctl disable-region -b "$bus" all
-	$ndctl zero-labels -b "$bus" all
-	$ndctl enable-region -b "$bus" all
+	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 }
 
 # re-enable the BTT namespace, and do IO to it in an attempt to
@@ -78,25 +73,25 @@ test_normal()
 {
 	echo "=== ${FUNCNAME[0]} ==="
 	# disable the namespace
-	$ndctl disable-namespace $dev
-	$ndctl check-namespace $dev
-	$ndctl enable-namespace $dev
+	$NDCTL disable-namespace $dev
+	$NDCTL check-namespace $dev
+	$NDCTL enable-namespace $dev
 	post_repair_test
 }
 
 test_force()
 {
 	echo "=== ${FUNCNAME[0]} ==="
-	$ndctl check-namespace --force $dev
+	$NDCTL check-namespace --force $dev
 	post_repair_test
 }
 
 set_raw()
 {
-	$ndctl disable-namespace $dev
+	$NDCTL disable-namespace $dev
 	echo -n "set raw_mode: "
 	echo 1 | tee /sys/bus/nd/devices/$dev/force_raw
-	$ndctl enable-namespace $dev
+	$NDCTL enable-namespace $dev
 	raw_bdev="${blockdev%%s}"
 	test -b /dev/$raw_bdev
 	raw_size="$(cat /sys/bus/nd/devices/$dev/size)"
@@ -104,10 +99,10 @@ set_raw()
 
 unset_raw()
 {
-	$ndctl disable-namespace $dev
+	$NDCTL disable-namespace $dev
 	echo -n "set raw_mode: "
 	echo 0 | tee /sys/bus/nd/devices/$dev/force_raw
-	$ndctl enable-namespace $dev
+	$NDCTL enable-namespace $dev
 	raw_bdev=""
 }
 
@@ -119,10 +114,10 @@ test_bad_info2()
 	echo "wiping info2 block (offset = $seek blocks)"
 	dd if=/dev/zero of=/dev/$raw_bdev bs=$bs count=1 seek=$seek
 	unset_raw
-	$ndctl disable-namespace $dev
-	$ndctl check-namespace $dev 2>&1 | grep "info2 needs to be restored"
-	$ndctl check-namespace --repair $dev
-	$ndctl enable-namespace $dev
+	$NDCTL disable-namespace $dev
+	$NDCTL check-namespace $dev 2>&1 | grep "info2 needs to be restored"
+	$NDCTL check-namespace --repair $dev
+	$NDCTL enable-namespace $dev
 	post_repair_test
 }
 
@@ -133,10 +128,10 @@ test_bad_info()
 	echo "wiping info block"
 	dd if=/dev/zero of=/dev/$raw_bdev bs=$bs count=2 seek=0
 	unset_raw
-	$ndctl disable-namespace $dev
-	$ndctl check-namespace $dev 2>&1 | grep -E "info block at offset .* needs to be restored"
-	$ndctl check-namespace --repair $dev
-	$ndctl enable-namespace $dev
+	$NDCTL disable-namespace $dev
+	$NDCTL check-namespace $dev 2>&1 | grep -E "info block at offset .* needs to be restored"
+	$NDCTL check-namespace --repair $dev
+	$NDCTL enable-namespace $dev
 	post_repair_test
 }
 
@@ -155,8 +150,8 @@ test_bitmap()
 	dd if=/tmp/scribble of=/dev/$raw_bdev bs=$bs seek=$seek
 	rm -f /tmp/scribble
 	unset_raw
-	$ndctl disable-namespace $dev
-	$ndctl check-namespace $dev 2>&1 | grep "bitmap error"
+	$NDCTL disable-namespace $dev
+	$NDCTL check-namespace $dev 2>&1 | grep "bitmap error"
 	# This is not repairable
 	reset && create
 }
@@ -176,4 +171,5 @@ rc=1
 reset && create
 do_tests
 reset
+_cleanup
 exit 0
diff --git a/test/btt-errors.sh b/test/btt-errors.sh
index 25f856e..e9cc209 100755
--- a/test/btt-errors.sh
+++ b/test/btt-errors.sh
@@ -11,11 +11,8 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
-NDCTL="../ndctl/ndctl"
-BUS="nfit_test.0"
 MNT=test_btt_mnt
 FILE=image
-json2var="s/[{}\",]//g; s/:/=/g"
 blockdev=""
 rc=77
 
@@ -57,16 +54,16 @@ trap 'err $LINENO cleanup' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region -b "$BUS" all
-$NDCTL zero-labels -b "$BUS" all
-$NDCTL enable-region -b "$BUS" all
+$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 
 rc=1
 
 # create a btt namespace and clear errors (if any)
 dev="x"
-json=$($NDCTL create-namespace -b "$BUS" -t pmem -m sector)
-eval "$(echo "$json" | sed -e "$json2var")"
+json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem -m sector)
+eval "$(echo "$json" | json2var)"
 [ $dev = "x" ] && echo "fail: $LINENO" && exit 1
 
 force_raw 1
@@ -137,12 +134,12 @@ dd if=$MNT/$FILE of=/dev/null iflag=direct bs=4096 count=1
 
 # reset everything to get a clean log
 if grep -q "$MNT" /proc/mounts; then umount $MNT; fi
-$NDCTL disable-region -b "$BUS" all
-$NDCTL zero-labels -b "$BUS" all
-$NDCTL enable-region -b "$BUS" all
+$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 dev="x"
-json=$($NDCTL create-namespace -b "$BUS" -t pmem -m sector)
-eval "$(echo "$json" | sed -e "$json2var")"
+json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem -m sector)
+eval "$(echo "$json" | json2var)"
 [ $dev = "x" ] && echo "fail: $LINENO" && exit 1
 
 # insert error at an arbitrary offset in the map (sector 0)
@@ -158,7 +155,8 @@ force_raw 0
 dd if=/dev/$blockdev of=/dev/null iflag=direct bs=4096 count=1 && err $LINENO || true
 
 # done, exit
-$NDCTL disable-region -b "$BUS" all
-$NDCTL zero-labels -b "$BUS" all
-$NDCTL enable-region -b "$BUS" all
+$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+_cleanup
 exit 0
diff --git a/test/btt-pad-compat.sh b/test/btt-pad-compat.sh
index eb15296..2c1f271 100755
--- a/test/btt-pad-compat.sh
+++ b/test/btt-pad-compat.sh
@@ -11,11 +11,6 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
-[ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ] && ndctl="../ndctl/ndctl"
-[ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ] && ndctl="./ndctl/ndctl"
-[ -z "$ndctl" ] && echo "Couldn't find an ndctl binary" && exit 1
-bus="nfit_test.0"
-json2var="s/[{}\",]//g; s/:/=/g"
 dev=""
 size=""
 blockdev=""
@@ -36,9 +31,9 @@ trap 'err $LINENO' ERR
 
 create()
 {
-	json=$($ndctl create-namespace -b "$bus" -t pmem -m sector)
+	json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem -m sector)
 	rc=2
-	eval "$(echo "$json" | sed -e "$json2var")"
+	eval "$(echo "$json" | json2var)"
 	[ -n "$dev" ] || err "$LINENO"
 	[ -n "$size" ] || err "$LINENO"
 	[ -n "$blockdev" ] || err "$LINENO"
@@ -52,9 +47,9 @@ create()
 
 reset()
 {
-	$ndctl disable-region -b "$bus" all
-	$ndctl zero-labels -b "$bus" all
-	$ndctl enable-region -b "$bus" all
+	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 }
 
 verify_idx()
@@ -90,16 +85,16 @@ cycle_ns()
 {
 	local ns="$1"
 
-	$ndctl disable-namespace $ns
-	$ndctl enable-namespace $ns
+	$NDCTL disable-namespace $ns
+	$NDCTL enable-namespace $ns
 }
 
 force_raw()
 {
 	raw="$1"
-	$ndctl disable-namespace "$dev"
+	$NDCTL disable-namespace "$dev"
 	echo "$raw" > "/sys/bus/nd/devices/$dev/force_raw"
-	$ndctl enable-namespace "$dev"
+	$NDCTL enable-namespace "$dev"
 	echo "Set $dev to raw mode: $raw"
 	if [[ "$raw" == "1" ]]; then
 		raw_bdev=${blockdev%s}
@@ -125,16 +120,16 @@ create_oldfmt_ns()
 	# that supports a raw namespace with a 4K sector size, prior to
 	# v4.13 raw namespaces are limited to 512-byte sector size.
 	rc=77
-	json=$($ndctl create-namespace -b "$bus" -s 64M -t pmem -m raw -l 4096 -u 00000000-0000-0000-0000-000000000000)
+	json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -s 64M -t pmem -m raw -l 4096 -u 00000000-0000-0000-0000-000000000000)
 	rc=2
-	eval "$(echo "$json" | sed -e "$json2var")"
+	eval "$(echo "$json" | json2var)"
 	[ -n "$dev" ] || err "$LINENO"
 	[ -n "$size" ] || err "$LINENO"
 	[ $size -gt 0 ] || err "$LINENO"
 
 	# reconfig it to sector mode
-	json=$($ndctl create-namespace -b "$bus" -e $dev -m sector --force)
-	eval "$(echo "$json" | sed -e "$json2var")"
+	json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -e $dev -m sector --force)
+	eval "$(echo "$json" | json2var)"
 	[ -n "$dev" ] || err "$LINENO"
 	[ -n "$size" ] || err "$LINENO"
 	[ -n "$blockdev" ] || err "$LINENO"
@@ -178,13 +173,13 @@ do_tests()
 	verify_idx 0 2
 
 	# rewrite log using ndctl, verify conversion to new format
-	$ndctl check-namespace --rewrite-log --repair --force --verbose $dev
+	$NDCTL check-namespace --rewrite-log --repair --force --verbose $dev
 	do_random_io "/dev/$blockdev"
 	cycle_ns "$dev"
 	verify_idx 0 1
 
 	# check-namespace again to make sure everything is ok
-	$ndctl check-namespace --force --verbose $dev
+	$NDCTL check-namespace --force --verbose $dev
 
 	# the old format btt metadata was created with a null parent uuid,
 	# making it 'stickier' than a normally created btt. Be sure to clean
@@ -198,4 +193,5 @@ rc=1
 reset
 do_tests
 reset
+_cleanup
 exit 0
diff --git a/test/clear.sh b/test/clear.sh
index f4b095f..6cc43db 100755
--- a/test/clear.sh
+++ b/test/clear.sh
@@ -13,11 +13,6 @@
 
 set -e
 
-DEV=""
-NDCTL="../ndctl/ndctl"
-BUS="-b nfit_test.0"
-BUS1="-b nfit_test.1"
-json2var="s/[{}\",]//g; s/:/=/g"
 rc=77
 
 . ./common
@@ -28,16 +23,16 @@ trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region $BUS all
-$NDCTL zero-labels $BUS all
-$NDCTL enable-region $BUS all
+$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 
 rc=1
 
 # create pmem
 dev="x"
-json=$($NDCTL create-namespace $BUS -t pmem -m raw)
-eval $(echo $json | sed -e "$json2var")
+json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem -m raw)
+eval $(echo $json | json2var)
 [ $dev = "x" ] && echo "fail: $LINENO" && exit 1
 [ $mode != "raw" ] && echo "fail: $LINENO" && exit 1
 
@@ -58,7 +53,7 @@ sector_raw=$sector
 
 # convert pmem to fsdax mode
 json=$($NDCTL create-namespace -m fsdax -f -e $dev)
-eval $(echo $json | sed -e "$json2var")
+eval $(echo $json | json2var)
 [ $mode != "fsdax" ] && echo "fail: $LINENO" && exit 1
 
 # check for errors relative to the offset injected by the pfn device
@@ -77,8 +72,8 @@ fi
 
 if check_min_kver "4.9"; then
 	# check for re-appearance of stale badblocks from poison_list
-	$NDCTL disable-region $BUS all
-	$NDCTL enable-region $BUS all
+	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 
 	# since we have cleared the errors, a disable/reenable shouldn't bring them back
 	if read sector len < /sys/block/$blockdev/badblocks; then
@@ -87,8 +82,6 @@ if check_min_kver "4.9"; then
 	fi
 fi
 
-$NDCTL disable-region $BUS all
-$NDCTL disable-region $BUS1 all
-modprobe -r nfit_test
+_cleanup
 
 exit 0
diff --git a/test/create.sh b/test/create.sh
index 4a3177b..8d78797 100755
--- a/test/create.sh
+++ b/test/create.sh
@@ -13,10 +13,6 @@
 
 set -e
 
-DEV=""
-NDCTL="../ndctl/ndctl"
-BUS="-b nfit_test.0"
-json2var="s/[{}\",]//g; s/:/=/g"
 SECTOR_SIZE="4096"
 rc=77
 
@@ -28,27 +24,27 @@ trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region $BUS all
-$NDCTL zero-labels $BUS all
-$NDCTL enable-region $BUS all
+$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 
 rc=1
 
 # create pmem
 dev="x"
-json=$($NDCTL create-namespace $BUS -t pmem -m raw)
-eval $(echo $json | sed -e "$json2var")
+json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem -m raw)
+eval $(echo $json | json2var )
 [ $dev = "x" ] && echo "fail: $LINENO" && exit 1
 [ $mode != "raw" ] && echo "fail: $LINENO" &&  exit 1
 
 # convert pmem to fsdax mode
 json=$($NDCTL create-namespace -m fsdax -f -e $dev)
-eval $(echo $json | sed -e "$json2var")
+eval $(echo $json | json2var)
 [ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
 
 # convert pmem to sector mode
 json=$($NDCTL create-namespace -m sector -l $SECTOR_SIZE -f -e $dev)
-eval $(echo $json | sed -e "$json2var")
+eval $(echo $json | json2var)
 [ $sector_size != $SECTOR_SIZE ] && echo "fail: $LINENO" &&  exit 1
 [ $mode != "sector" ] && echo "fail: $LINENO" &&  exit 1
 
@@ -57,15 +53,17 @@ $NDCTL destroy-namespace -f $dev
 
 # create blk
 dev="x"
-json=$($NDCTL create-namespace $BUS -t blk -m raw -v)
-eval $(echo $json | sed -e "$json2var")
+json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t blk -m raw -v)
+eval $(echo $json | json2var)
 [ $dev = "x" ] && echo "fail: $LINENO" && exit 1
 [ $mode != "raw" ] && echo "fail: $LINENO" &&  exit 1
 
 # convert blk to sector mode
 json=$($NDCTL create-namespace -m sector -l $SECTOR_SIZE -f -e $dev)
-eval $(echo $json | sed -e "$json2var")
+eval $(echo $json | json2var)
 [ $sector_size != $SECTOR_SIZE ] && echo "fail: $LINENO" &&  exit 1
 [ $mode != "sector" ] && echo "fail: $LINENO" &&  exit 1
 
+_cleanup
+
 exit 0
diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
index 102645d..c5adb72 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -13,12 +13,6 @@
 
 set -e
 
-DEV=""
-NDCTL="../ndctl/ndctl"
-DAXCTL="../daxctl/daxctl"
-BUS="-b nfit_test.0"
-BUS1="-b nfit_test.1"
-json2var="s/[{}\",]//g; s/:/=/g"
 rc=77
 
 . ./common
@@ -29,16 +23,16 @@ trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region $BUS all
-$NDCTL zero-labels $BUS all
-$NDCTL enable-region $BUS all
+$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 
 rc=1
 
 query=". | sort_by(.available_size) | reverse | .[0].dev"
-region=$($NDCTL list $BUS -t pmem -Ri | jq -r "$query")
+region=$($NDCTL list -b $NFIT_TEST_BUS0 -t pmem -Ri | jq -r "$query")
 
-json=$($NDCTL create-namespace $BUS -r $region -t pmem -m devdax -a 4096)
+json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -r $region -t pmem -m devdax -a 4096)
 chardev=$(echo $json | jq ". | select(.mode == \"devdax\") | .daxregion.devices[0].chardev")
 
 #{
@@ -59,12 +53,12 @@ chardev=$(echo $json | jq ". | select(.mode == \"devdax\") | .daxregion.devices[
 #  }
 #}
 
-json1=$($NDCTL list $BUS --mode=devdax --namespaces)
-eval $(echo $json1 | sed -e "$json2var")
+json1=$($NDCTL list -b $NFIT_TEST_BUS0 --mode=devdax --namespaces)
+eval $(echo $json1 | json2var)
 nsdev=$dev
 
-json1=$($NDCTL list $BUS)
-eval $(echo $json1 | sed -e "$json2var")
+json1=$($NDCTL list -b $NFIT_TEST_BUS0)
+eval $(echo $json1 | json2var)
 busdev=$dev
 
 # inject errors in the middle of the namespace
@@ -87,9 +81,6 @@ if read sector len < /sys/bus/platform/devices/nfit_test.0/$busdev/$region/badbl
 fi
 [ -n "$sector" ] && echo "fail: $LINENO" && exit 1
 
-# cleanup
-$NDCTL disable-region $BUS all
-$NDCTL disable-region $BUS1 all
-modprobe -r nfit_test
+_cleanup
 
 exit 0
diff --git a/test/firmware-update.sh b/test/firmware-update.sh
index aec10ff..50674a6 100755
--- a/test/firmware-update.sh
+++ b/test/firmware-update.sh
@@ -2,12 +2,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright(c) 2018 Intel Corporation. All rights reserved.
 
-[ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ] && ndctl="../ndctl/ndctl"
-[ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ] && ndctl="./ndctl/ndctl"
-[ -z "$ndctl" ] && echo "Couldn't find an ndctl binary" && exit 1
-bus="nfit_test.0"
-bus1="nfit_test.1"
-json2var="s/[{}\",]//g; s/:/=/g"
 rc=77
 dev=""
 image="update-fw.img"
@@ -18,31 +12,24 @@ trap 'err $LINENO' ERR
 
 reset()
 {
-	$ndctl disable-region -b "$bus" all
-	$ndctl zero-labels -b "$bus" all
-	$ndctl enable-region -b "$bus" all
+	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 	if [ -f $image ]; then
 		rm -f $image
 	fi
 }
 
-cleanup()
-{
-	$ndctl disable-region -b "$bus" all
-	$ndctl disable-region -b "$bus1" all
-	modprobe -r nfit_test
-}
-
 detect()
 {
-	dev=$($ndctl list -b "$bus" -D | jq .[0].dev | tr -d '"')
+	dev=$($NDCTL list -b $NFIT_TEST_BUS0 -D | jq .[0].dev | tr -d '"')
 	[ -n "$dev" ] || err "$LINENO"
 }
 
 do_tests()
 {
 	truncate -s 196608 $image
-	$ndctl update-firmware -f $image $dev
+	$NDCTL update-firmware -f $image $dev
 }
 
 check_min_kver "4.16" || do_skip "may lack firmware update test handling"
@@ -53,5 +40,5 @@ reset
 rc=2
 detect
 do_tests
-cleanup
+_cleanup
 exit 0
diff --git a/test/inject-error.sh b/test/inject-error.sh
index a8b7c1b..7bda35b 100755
--- a/test/inject-error.sh
+++ b/test/inject-error.sh
@@ -11,11 +11,6 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
-[ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ] && ndctl="../ndctl/ndctl"
-[ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ] && ndctl="./ndctl/ndctl"
-[ -z "$ndctl" ] && echo "Couldn't find an ndctl binary" && exit 1
-bus="nfit_test.0"
-json2var="s/[{}\",]//g; s/:/=/g"
 dev=""
 size=""
 blockdev=""
@@ -40,9 +35,9 @@ check_min_kver "4.15" || do_skip "kernel $KVER may not support error injection"
 
 create()
 {
-	json=$($ndctl create-namespace -b "$bus" -t pmem --align=4k)
+	json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem --align=4k)
 	rc=2
-	eval "$(echo "$json" | sed -e "$json2var")"
+	eval "$(echo "$json" | json2var)"
 	[ -n "$dev" ] || err "$LINENO"
 	[ -n "$size" ] || err "$LINENO"
 	[ -n "$blockdev" ] || err "$LINENO"
@@ -51,9 +46,9 @@ create()
 
 reset()
 {
-	$ndctl disable-region -b "$bus" all
-	$ndctl zero-labels -b "$bus" all
-	$ndctl enable-region -b "$bus" all
+	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 }
 
 check_status()
@@ -61,7 +56,7 @@ check_status()
 	local sector="$1"
 	local count="$2"
 
-	json="$($ndctl inject-error --status $dev)"
+	json="$($NDCTL inject-error --status $dev)"
 	[[ "$sector" == "$(jq ".badblocks[0].block" <<< "$json")" ]]
 	[[ "$count" == "$(jq ".badblocks[0].count" <<< "$json")" ]]
 }
@@ -69,7 +64,7 @@ check_status()
 do_tests()
 {
 	# inject without notification
-	$ndctl inject-error --block=$err_block --count=$err_count --no-notify $dev
+	$NDCTL inject-error --block=$err_block --count=$err_count --no-notify $dev
 	check_status "$err_block" "$err_count"
 	if read -r sector len < /sys/block/$blockdev/badblocks; then
 		# fail if reading badblocks returns data
@@ -77,11 +72,11 @@ do_tests()
 	fi
 
 	# clear via err-inj-clear
-	$ndctl inject-error --block=$err_block --count=$err_count --uninject $dev
+	$NDCTL inject-error --block=$err_block --count=$err_count --uninject $dev
 	check_status
 
 	# inject normally
-	$ndctl inject-error --block=$err_block --count=$err_count $dev
+	$NDCTL inject-error --block=$err_block --count=$err_count $dev
 	check_status "$err_block" "$err_count"
 	if read -r sector len < /sys/block/$blockdev/badblocks; then
 		test "$sector" -eq "$err_block"
@@ -102,4 +97,5 @@ rc=1
 reset && create
 do_tests
 reset
+_cleanup
 exit 0
diff --git a/test/label-compat.sh b/test/label-compat.sh
index f1fd450..dc6226d 100755
--- a/test/label-compat.sh
+++ b/test/label-compat.sh
@@ -13,9 +13,6 @@
 
 set -e
 
-NDCTL="../ndctl/ndctl"
-BUS="-b nfit_test.0"
-BUS1="-b nfit_test.1"
 rc=77
 
 . ./common
@@ -26,12 +23,12 @@ trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region $BUS all
-$NDCTL zero-labels $BUS all
+$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
 
-# grab the largest pmem region on $BUS
+# grab the largest pmem region on -b $NFIT_TEST_BUS0
 query=". | sort_by(.available_size) | reverse | .[0].dev"
-region=$($NDCTL list $BUS -t pmem -Ri | jq -r "$query")
+region=$($NDCTL list -b $NFIT_TEST_BUS0 -t pmem -Ri | jq -r "$query")
 
 # we assume that $region is comprised of 4 dimms
 query=". | .regions[0].mappings | sort_by(.dimm) | .[].dimm"
@@ -43,7 +40,7 @@ do
 	i=$((i+1))
 done
 
-$NDCTL enable-region $BUS all
+$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 
 len=$($NDCTL list -r $region -N | jq -r "length")
 
@@ -53,8 +50,6 @@ if [ -z $len ]; then
 	exit 1
 fi
 
-$NDCTL disable-region $BUS all
-$NDCTL disable-region $BUS1 all
-modprobe -r nfit_test
+_cleanup
 
 exit 0
diff --git a/test/multi-dax.sh b/test/multi-dax.sh
index 548fa1a..0829bf2 100755
--- a/test/multi-dax.sh
+++ b/test/multi-dax.sh
@@ -13,12 +13,6 @@
 
 set -e
 
-DEV=""
-NDCTL="../ndctl/ndctl"
-DAXCTL="../daxctl/daxctl"
-BUS="-b nfit_test.0"
-BUS1="-b nfit_test.1"
-json2var="s/[{}\",]//g; s/:/=/g"
 rc=77
 
 . ./common
@@ -29,22 +23,19 @@ trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region $BUS all
-$NDCTL zero-labels $BUS all
-$NDCTL enable-region $BUS all
+$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 rc=1
 
 query=". | sort_by(.available_size) | reverse | .[0].dev"
-region=$($NDCTL list $BUS -t pmem -Ri | jq -r "$query")
+region=$($NDCTL list -b $NFIT_TEST_BUS0 -t pmem -Ri | jq -r "$query")
 
-json=$($NDCTL create-namespace $BUS -r $region -t pmem -m devdax -a 4096 -s 16M)
+json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -r $region -t pmem -m devdax -a 4096 -s 16M)
 chardev1=$(echo $json | jq ". | select(.mode == \"devdax\") | .daxregion.devices[0].chardev")
-json=$($NDCTL create-namespace $BUS -r $region -t pmem -m devdax -a 4096 -s 16M)
+json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -r $region -t pmem -m devdax -a 4096 -s 16M)
 chardev2=$(echo $json | jq ". | select(.mode == \"devdax\") | .daxregion.devices[0].chardev")
 
-# cleanup
-$NDCTL disable-region $BUS all
-$NDCTL disable-region $BUS1 all
-modprobe -r nfit_test
+_cleanup
 
 exit 0
diff --git a/test/pmem-errors.sh b/test/pmem-errors.sh
index 11470c6..9553a3f 100755
--- a/test/pmem-errors.sh
+++ b/test/pmem-errors.sh
@@ -2,13 +2,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
 
-DEV=""
-NDCTL="../ndctl/ndctl"
-BUS="-b nfit_test.0"
-BUS1="-b nfit_test.1"
 MNT=test_dax_mnt
 FILE=image
-json2var="s/[{}\",]//g; s/:/=/g"
 rc=77
 
 . ./common
@@ -33,16 +28,16 @@ trap 'err $LINENO cleanup' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region $BUS all
-$NDCTL zero-labels $BUS all
-$NDCTL enable-region $BUS all
+$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 
 rc=1
 
 # create pmem
 dev="x"
-json=$($NDCTL create-namespace $BUS -t pmem -m raw)
-eval $(echo $json | sed -e "$json2var")
+json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem -m raw)
+eval $(echo $json | json2var)
 [ $dev = "x" ] && echo "fail: $LINENO" && false
 [ $mode != "raw" ] && echo "fail: $LINENO" && false
 
@@ -126,8 +121,6 @@ if [ -n "$blockdev" ]; then
 fi
 rmdir $MNT
 
-$NDCTL disable-region $BUS all
-$NDCTL disable-region $BUS1 all
-modprobe -r nfit_test
+_cleanup
 
 exit 0
diff --git a/test/rescan-partitions.sh b/test/rescan-partitions.sh
index 337d65d..9c7b7a0 100755
--- a/test/rescan-partitions.sh
+++ b/test/rescan-partitions.sh
@@ -2,8 +2,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright(c) 2018 Intel Corporation. All rights reserved.
 
-bus="nfit_test.0"
-json2var="s/[{}\",]//g; s/:/=/g"
 dev=""
 size=""
 blockdev=""
@@ -29,9 +27,9 @@ check_prereq "blockdev"
 
 reset()
 {
-	$ndctl disable-region -b "$bus" all
-	$ndctl zero-labels -b "$bus" all
-	$ndctl enable-region -b "$bus" all
+	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 }
 
 test_mode()
@@ -39,9 +37,9 @@ test_mode()
 	local mode="$1"
 
 	# create namespace
-	json=$($ndctl create-namespace -b "$bus" -t pmem -m "$mode")
+	json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem -m "$mode")
 	rc=2
-	eval "$(echo "$json" | sed -e "$json2var")"
+	eval "$(echo "$json" | json2var)"
 	[ -n "$dev" ] || err "$LINENO"
 	[ -n "$size" ] || err "$LINENO"
 	[ -n "$blockdev" ] || err "$LINENO"
@@ -60,8 +58,8 @@ test_mode()
 
 	# cycle the namespace, and verify the partition is read
 	# without needing to do a blockdev --rereadpt
-	$ndctl disable-namespace $dev
-	$ndctl enable-namespace $dev
+	$NDCTL disable-namespace $dev
+	$NDCTL enable-namespace $dev
 	if [ -b /dev/$partdev ]; then
 		echo "mode: $mode - partition read successful"
 	else
@@ -70,8 +68,8 @@ test_mode()
 		err "$LINENO"
 	fi
 
-	$ndctl disable-namespace $dev
-	$ndctl destroy-namespace $dev
+	$NDCTL disable-namespace $dev
+	$NDCTL destroy-namespace $dev
 }
 
 modprobe nfit_test
@@ -80,5 +78,5 @@ reset
 test_mode "raw"
 test_mode "fsdax"
 test_mode "sector"
-
+_cleanup
 exit 0
diff --git a/test/sector-mode.sh b/test/sector-mode.sh
index d507788..16c1ddf 100755
--- a/test/sector-mode.sh
+++ b/test/sector-mode.sh
@@ -11,10 +11,6 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
-NDCTL="../ndctl/ndctl"
-BUS="-b nfit_test.0"
-BUS1="-b nfit_test.1"
-TEST=$0
 rc=77
 
 . ./common
@@ -24,25 +20,23 @@ trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region $BUS all
-$NDCTL zero-labels $BUS all
-$NDCTL enable-region $BUS all
+$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 
-$NDCTL disable-region $BUS1 all
-$NDCTL zero-labels $BUS1 all
-$NDCTL enable-region $BUS1 all
+$NDCTL disable-region -b $NFIT_TEST_BUS1 all
+$NDCTL zero-labels -b $NFIT_TEST_BUS1 all
+$NDCTL enable-region -b $NFIT_TEST_BUS1 all
 
 rc=1
 query=". | sort_by(.size) | reverse | .[0].dev"
-NAMESPACE=$($NDCTL list $BUS1 -N | jq -r "$query")
+NAMESPACE=$($NDCTL list -b $NFIT_TEST_BUS1 -N | jq -r "$query")
 REGION=$($NDCTL list -R --namespace=$NAMESPACE | jq -r ".dev")
 echo 0 > /sys/bus/nd/devices/$REGION/read_only
 $NDCTL create-namespace --no-autolabel -e $NAMESPACE -m sector -f -l 4K
 $NDCTL create-namespace --no-autolabel -e $NAMESPACE -m dax -f -a 4K
 $NDCTL create-namespace --no-autolabel -e $NAMESPACE -m sector -f -l 4K
 
-$NDCTL disable-region $BUS all
-$NDCTL disable-region $BUS1 all
-modprobe -r nfit_test
+_cleanup
 
 exit 0
-- 
2.18.0.rc1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
