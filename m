Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x244.google.com (mail-qk0-x244.google.com
 [IPv6:2607:f8b0:400d:c09::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C339E2131BA20
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jun 2018 18:56:43 -0700 (PDT)
Received: by mail-qk0-x244.google.com with SMTP id g126-v6so624142qke.10
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jun 2018 18:56:43 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: [PATCH v2 2/2] ndctl, test: cleanup test scripts
Date: Tue, 12 Jun 2018 21:56:16 -0400
Message-Id: <20180613015616.26487-3-msys.mizuma@gmail.com>
In-Reply-To: <20180613015616.26487-1-msys.mizuma@gmail.com>
References: <20180613015616.26487-1-msys.mizuma@gmail.com>
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

Include 'common' file to use some functions for test scritps.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 test/blk-exhaust.sh       | 21 +++-------------
 test/btt-check.sh         | 35 ++++++++------------------
 test/btt-errors.sh        | 20 ++++-----------
 test/btt-pad-compat.sh    | 52 ++++++++++++++-------------------------
 test/clear.sh             | 23 ++++-------------
 test/create.sh            | 21 +++-------------
 test/daxdev-errors.sh     | 19 +++-----------
 test/firmware-update.sh   | 26 +++++---------------
 test/inject-error.sh      | 31 ++++++-----------------
 test/label-compat.sh      | 21 +++-------------
 test/multi-dax.sh         | 19 +++-----------
 test/pmem-errors.sh       | 20 +++++----------
 test/rescan-partitions.sh | 44 +++++++++------------------------
 test/sector-mode.sh       |  5 +---
 14 files changed, 91 insertions(+), 266 deletions(-)

diff --git a/test/blk-exhaust.sh b/test/blk-exhaust.sh
index b6991f6..1ec67fd 100755
--- a/test/blk-exhaust.sh
+++ b/test/blk-exhaust.sh
@@ -11,30 +11,17 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
+set -e
+
 NDCTL="../ndctl/ndctl"
 BUS="-b nfit_test.0"
 BUS1="-b nfit_test.1"
 rc=77
 
-set -e
-
-err() {
-	echo "test/label-compat.sh: failed at line $1"
-	exit $rc
-}
+. ./common
 
-check_min_kver()
-{
-	local ver="$1"
-	: "${KVER:=$(uname -r)}"
+check_min_kver "4.11" || do_skip "may lack blk-exhaustion fix"
 
-	[ -n "$ver" ] || return 1
-	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
-}
-
-check_min_kver "4.11" || { echo "kernel $KVER may lack blk-exhaustion fix"; exit $rc; }
-
-set -e
 trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
diff --git a/test/btt-check.sh b/test/btt-check.sh
index 353d437..0d5ca6e 100755
--- a/test/btt-check.sh
+++ b/test/btt-check.sh
@@ -24,6 +24,8 @@ blockdev=""
 bs=4096
 rc=77
 
+. ./common
+
 trap 'err $LINENO' ERR
 
 # sample json:
@@ -36,36 +38,19 @@ trap 'err $LINENO' ERR
 #   "blockdev":"pmem5s"
 # }
 
-# $1: Line number
-# $2: exit code
-err()
-{
-	[ -n "$2" ] && rc="$2"
-	echo "test/btt-check: failed at line $1"
-	exit "$rc"
-}
-
-check_min_kver()
-{
-	local ver="$1"
-	: "${KVER:=$(uname -r)}"
-
-	[ -n "$ver" ] || return 1
-	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
-}
-
-check_min_kver "4.14" || { echo "kernel $KVER may not support badblocks clearing on pmem via btt"; exit $rc; }
+check_min_kver "4.14" || do_skip "may not support badblocks clearing on pmem via btt"
 
 create()
 {
 	json=$($ndctl create-namespace -b "$bus" -t pmem -m sector)
+	rc=2
 	eval "$(echo "$json" | sed -e "$json2var")"
-	[ -n "$dev" ] || err "$LINENO" 2
-	[ "$mode" = "sector" ] || err "$LINENO" 2
-	[ -n "$size" ] || err "$LINENO" 2
-	[ -n "$sector_size" ] || err "$LINENO" 2
-	[ -n "$blockdev" ] || err "$LINENO" 2
-	[ $size -gt 0 ] || err "$LINENO" 2
+	[ -n "$dev" ] || err "$LINENO"
+	[ "$mode" = "sector" ] || err "$LINENO"
+	[ -n "$size" ] || err "$LINENO"
+	[ -n "$sector_size" ] || err "$LINENO"
+	[ -n "$blockdev" ] || err "$LINENO"
+	[ $size -gt 0 ] || err "$LINENO"
 }
 
 reset()
diff --git a/test/btt-errors.sh b/test/btt-errors.sh
index ecc1282..115e1c3 100755
--- a/test/btt-errors.sh
+++ b/test/btt-errors.sh
@@ -19,10 +19,10 @@ json2var="s/[{}\",]//g; s/:/=/g"
 blockdev=""
 rc=77
 
-err() {
-	rc=1
-	echo "test/btt-errors: failed at line $1"
+. ./common
 
+cleaup()
+{
 	rm -f $FILE
 	rm -f $MNT/$FILE
 	if [ -n "$blockdev" ]; then
@@ -31,16 +31,6 @@ err() {
 		rc=77
 	fi
 	rmdir $MNT
-	exit $rc
-}
-
-check_min_kver()
-{
-	local ver="$1"
-	: "${KVER:=$(uname -r)}"
-
-	[ -n "$ver" ] || return 1
-	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
 }
 
 force_raw()
@@ -59,11 +49,11 @@ force_raw()
 	fi
 }
 
-check_min_kver "4.15" || { echo "kernel $KVER may lack BTT error handling"; exit $rc; }
+check_min_kver "4.15" || do_skip "may lack BTT error handling"
 
 set -e
 mkdir -p $MNT
-trap 'err $LINENO' ERR
+trap 'err $LINENO cleanup' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
diff --git a/test/btt-pad-compat.sh b/test/btt-pad-compat.sh
index 281a8e5..eb15296 100755
--- a/test/btt-pad-compat.sh
+++ b/test/btt-pad-compat.sh
@@ -21,6 +21,8 @@ size=""
 blockdev=""
 rc=77
 
+. ./common
+
 trap 'err $LINENO' ERR
 
 # sample json:
@@ -32,36 +34,19 @@ trap 'err $LINENO' ERR
 #  "blockdev":"pmem7",
 #}
 
-# $1: Line number
-# $2: exit code
-err()
-{
-	[ -n "$2" ] && rc="$2"
-	echo "test/btt-pad-compat.sh: failed at line $1"
-	exit "$rc"
-}
-
-check_prereq()
-{
-	if ! command -v "$1" >/dev/null; then
-		echo "missing '$1', skipping.."
-		exit "$rc"
-	fi
-}
-
 create()
 {
 	json=$($ndctl create-namespace -b "$bus" -t pmem -m sector)
+	rc=2
 	eval "$(echo "$json" | sed -e "$json2var")"
-	[ -n "$dev" ] || err "$LINENO" 2
-	[ -n "$size" ] || err "$LINENO" 2
-	[ -n "$blockdev" ] || err "$LINENO" 2
-	[ $size -gt 0 ] || err "$LINENO" 2
+	[ -n "$dev" ] || err "$LINENO"
+	[ -n "$size" ] || err "$LINENO"
+	[ -n "$blockdev" ] || err "$LINENO"
+	[ $size -gt 0 ] || err "$LINENO"
 	bttdev=$(cat /sys/bus/nd/devices/$dev/holder)
-	[ -n "$bttdev" ] || err "$LINENO" 2
+	[ -n "$bttdev" ] || err "$LINENO"
 	if [ ! -e /sys/kernel/debug/btt/$bttdev/arena0/log_index_0 ]; then
-		echo "kernel $(uname -r) seems to be missing the BTT compatibility fixes, skipping"
-		exit 77
+		do_skip "seems to be missing the BTT compatibility fixes, skipping."
 	fi
 }
 
@@ -141,22 +126,23 @@ create_oldfmt_ns()
 	# v4.13 raw namespaces are limited to 512-byte sector size.
 	rc=77
 	json=$($ndctl create-namespace -b "$bus" -s 64M -t pmem -m raw -l 4096 -u 00000000-0000-0000-0000-000000000000)
-	rc=1
+	rc=2
 	eval "$(echo "$json" | sed -e "$json2var")"
-	[ -n "$dev" ] || err "$LINENO" 2
-	[ -n "$size" ] || err "$LINENO" 2
-	[ $size -gt 0 ] || err "$LINENO" 2
+	[ -n "$dev" ] || err "$LINENO"
+	[ -n "$size" ] || err "$LINENO"
+	[ $size -gt 0 ] || err "$LINENO"
 
 	# reconfig it to sector mode
 	json=$($ndctl create-namespace -b "$bus" -e $dev -m sector --force)
 	eval "$(echo "$json" | sed -e "$json2var")"
-	[ -n "$dev" ] || err "$LINENO" 2
-	[ -n "$size" ] || err "$LINENO" 2
-	[ -n "$blockdev" ] || err "$LINENO" 2
-	[ $size -gt 0 ] || err "$LINENO" 2
+	[ -n "$dev" ] || err "$LINENO"
+	[ -n "$size" ] || err "$LINENO"
+	[ -n "$blockdev" ] || err "$LINENO"
+	[ $size -gt 0 ] || err "$LINENO"
 	bttdev=$(cat /sys/bus/nd/devices/$dev/holder)
-	[ -n "$bttdev" ] || err "$LINENO" 2
+	[ -n "$bttdev" ] || err "$LINENO"
 
+	rc=1
 	# copy old-padding-format btt image, and try to re-enable the resulting btt
 	force_raw 1
 	copy_xxd_img "/dev/$raw_bdev"
diff --git a/test/clear.sh b/test/clear.sh
index d64dd27..f4b095f 100755
--- a/test/clear.sh
+++ b/test/clear.sh
@@ -11,6 +11,8 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
+set -e
+
 DEV=""
 NDCTL="../ndctl/ndctl"
 BUS="-b nfit_test.0"
@@ -18,25 +20,10 @@ BUS1="-b nfit_test.1"
 json2var="s/[{}\",]//g; s/:/=/g"
 rc=77
 
-set -e
-
-err() {
-	echo "test/clear: failed at line $1"
-	exit $rc
-}
+. ./common
 
-check_min_kver()
-{
-	local ver="$1"
-	: "${KVER:=$(uname -r)}"
+check_min_kver "4.6" || do_skip "lacks clear poison support"
 
-	[ -n "$ver" ] || return 1
-	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
-}
-
-check_min_kver "4.6" || { echo "kernel $KVER lacks clear poison support"; exit $rc; }
-
-set -e
 trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
@@ -88,7 +75,7 @@ if read sector len < /sys/block/$blockdev/badblocks; then
 	echo "fail: $LINENO" && exit 1
 fi
 
-if check_min_kver "4.9.0"; then
+if check_min_kver "4.9"; then
 	# check for re-appearance of stale badblocks from poison_list
 	$NDCTL disable-region $BUS all
 	$NDCTL enable-region $BUS all
diff --git a/test/create.sh b/test/create.sh
index 3f30d6e..4a3177b 100755
--- a/test/create.sh
+++ b/test/create.sh
@@ -11,6 +11,8 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
+set -e
+
 DEV=""
 NDCTL="../ndctl/ndctl"
 BUS="-b nfit_test.0"
@@ -18,25 +20,10 @@ json2var="s/[{}\",]//g; s/:/=/g"
 SECTOR_SIZE="4096"
 rc=77
 
-set -e
-
-err() {
-	echo "test/create: failed at line $1"
-	exit $rc
-}
+. ./common
 
-check_min_kver()
-{
-	local ver="$1"
-	: "${KVER:=$(uname -r)}"
+check_min_kver "4.5" || do_skip "may lack namespace mode attribute"
 
-	[ -n "$ver" ] || return 1
-	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
-}
-
-check_min_kver "4.5" || { echo "kernel $KVER may lack namespace mode attribute"; exit $rc; }
-
-set -e
 trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
index 0c8acf5..102645d 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -11,6 +11,8 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
+set -e
+
 DEV=""
 NDCTL="../ndctl/ndctl"
 DAXCTL="../daxctl/daxctl"
@@ -19,23 +21,10 @@ BUS1="-b nfit_test.1"
 json2var="s/[{}\",]//g; s/:/=/g"
 rc=77
 
-err() {
-	echo "test/daxdev-errors: failed at line $1"
-	exit $rc
-}
-
-check_min_kver()
-{
-	local ver="$1"
-	: "${KVER:=$(uname -r)}"
+. ./common
 
-	[ -n "$ver" ] || return 1
-	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
-}
+check_min_kver "4.12" || do_skip "lacks dax dev error handling"
 
-check_min_kver "4.12" || { echo "kernel $KVER lacks dax dev error handling"; exit $rc; }
-
-set -e
 trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
diff --git a/test/firmware-update.sh b/test/firmware-update.sh
index c2cf578..aec10ff 100755
--- a/test/firmware-update.sh
+++ b/test/firmware-update.sh
@@ -12,25 +12,9 @@ rc=77
 dev=""
 image="update-fw.img"
 
-trap 'err $LINENO' ERR
+. ./common
 
-# $1: Line number
-# $2: exit code
-err()
-{
-	[ -n "$2" ] && rc="$2"
-	echo "test/firmware-update.sh: failed at line $1"
-	exit "$rc"
-}
-
-check_min_kver()
-{
-	local ver="$1"
-	: "${KVER:=$(uname -r)}"
-
-	[ -n "$ver" ] || return 1
-	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
-}
+trap 'err $LINENO' ERR
 
 reset()
 {
@@ -52,7 +36,7 @@ cleanup()
 detect()
 {
 	dev=$($ndctl list -b "$bus" -D | jq .[0].dev | tr -d '"')
-	[ -n "$dev" ] || err "$LINENO" 2
+	[ -n "$dev" ] || err "$LINENO"
 }
 
 do_tests()
@@ -61,10 +45,12 @@ do_tests()
 	$ndctl update-firmware -f $image $dev
 }
 
-check_min_kver "4.16" || { echo "kernel $KVER may lack firmware update test handling"; exit $rc; }
+check_min_kver "4.16" || do_skip "may lack firmware update test handling"
+
 modprobe nfit_test
 rc=1
 reset
+rc=2
 detect
 do_tests
 cleanup
diff --git a/test/inject-error.sh b/test/inject-error.sh
index 8630745..a8b7c1b 100755
--- a/test/inject-error.sh
+++ b/test/inject-error.sh
@@ -23,6 +23,8 @@ rc=77
 err_block=42
 err_count=8
 
+. ./common
+
 trap 'err $LINENO' ERR
 
 # sample json:
@@ -34,34 +36,17 @@ trap 'err $LINENO' ERR
 #  "blockdev":"pmem7",
 #}
 
-# $1: Line number
-# $2: exit code
-err()
-{
-	[ -n "$2" ] && rc="$2"
-	echo "test/inject-error.sh: failed at line $1"
-	exit "$rc"
-}
-
-check_min_kver()
-{
-	local ver="$1"
-	: "${KVER:=$(uname -r)}"
-
-	[ -n "$ver" ] || return 1
-	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
-}
-
-check_min_kver "4.15" || { echo "kernel $KVER may not support error injection"; exit "$rc"; }
+check_min_kver "4.15" || do_skip "kernel $KVER may not support error injection"
 
 create()
 {
 	json=$($ndctl create-namespace -b "$bus" -t pmem --align=4k)
+	rc=2
 	eval "$(echo "$json" | sed -e "$json2var")"
-	[ -n "$dev" ] || err "$LINENO" 2
-	[ -n "$size" ] || err "$LINENO" 2
-	[ -n "$blockdev" ] || err "$LINENO" 2
-	[ $size -gt 0 ] || err "$LINENO" 2
+	[ -n "$dev" ] || err "$LINENO"
+	[ -n "$size" ] || err "$LINENO"
+	[ -n "$blockdev" ] || err "$LINENO"
+	[ $size -gt 0 ] || err "$LINENO"
 }
 
 reset()
diff --git a/test/label-compat.sh b/test/label-compat.sh
index 8c9ee63..f1fd450 100755
--- a/test/label-compat.sh
+++ b/test/label-compat.sh
@@ -11,30 +11,17 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
+set -e
+
 NDCTL="../ndctl/ndctl"
 BUS="-b nfit_test.0"
 BUS1="-b nfit_test.1"
 rc=77
 
-set -e
-
-err() {
-	echo "test/label-compat.sh: failed at line $1"
-	exit $rc
-}
+. ./common
 
-check_min_kver()
-{
-	local ver="$1"
-	: "${KVER:=$(uname -r)}"
+check_min_kver "4.11" || do_skip "may not provide reliable isetcookie values"
 
-	[ -n "$ver" ] || return 1
-	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
-}
-
-check_min_kver "4.11" || { echo "kernel $KVER may not provide reliable isetcookie values"; exit $rc; }
-
-set -e
 trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
diff --git a/test/multi-dax.sh b/test/multi-dax.sh
index 59ec6d6..548fa1a 100755
--- a/test/multi-dax.sh
+++ b/test/multi-dax.sh
@@ -11,6 +11,8 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
+set -e
+
 DEV=""
 NDCTL="../ndctl/ndctl"
 DAXCTL="../daxctl/daxctl"
@@ -19,23 +21,10 @@ BUS1="-b nfit_test.1"
 json2var="s/[{}\",]//g; s/:/=/g"
 rc=77
 
-err() {
-	echo "test/multi-dax: failed at line $1"
-	exit $rc
-}
-
-check_min_kver()
-{
-	local ver="$1"
-	: "${KVER:=$(uname -r)}"
+. ./common
 
-	[ -n "$ver" ] || return 1
-	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
-}
+check_min_kver "4.13" || do_skip "may lack multi-dax support"
 
-check_min_kver "4.13" || { echo "kernel $KVER may lack multi-dax support"; exit $rc; }
-
-set -e
 trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
diff --git a/test/pmem-errors.sh b/test/pmem-errors.sh
index e0ab9e8..11470c6 100755
--- a/test/pmem-errors.sh
+++ b/test/pmem-errors.sh
@@ -11,8 +11,10 @@ FILE=image
 json2var="s/[{}\",]//g; s/:/=/g"
 rc=77
 
-err() {
-	echo "test/dax-errors: failed at line $1"
+. ./common
+
+cleanup()
+{
 	rm -f $FILE
 	rm -f $MNT/$FILE
 	if [ -n "$blockdev" ]; then
@@ -21,23 +23,13 @@ err() {
 		rc=77
 	fi
 	rmdir $MNT
-	exit $rc
-}
-
-check_min_kver()
-{
-	local ver="$1"
-	: "${KVER:=$(uname -r)}"
-
-	[ -n "$ver" ] || return 1
-	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
 }
 
-check_min_kver "4.7" || { echo "kernel $KVER may lack dax error handling"; exit $rc; }
+check_min_kver "4.7" || do_skip "may lack dax error handling"
 
 set -e
 mkdir -p $MNT
-trap 'err $LINENO' ERR
+trap 'err $LINENO cleanup' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
diff --git a/test/rescan-partitions.sh b/test/rescan-partitions.sh
index eb313fb..337d65d 100755
--- a/test/rescan-partitions.sh
+++ b/test/rescan-partitions.sh
@@ -2,9 +2,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright(c) 2018 Intel Corporation. All rights reserved.
 
-[ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ] && ndctl="../ndctl/ndctl"
-[ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ] && ndctl="./ndctl/ndctl"
-[ -z "$ndctl" ] && echo "Couldn't find an ndctl binary" && exit 1
 bus="nfit_test.0"
 json2var="s/[{}\",]//g; s/:/=/g"
 dev=""
@@ -12,6 +9,8 @@ size=""
 blockdev=""
 rc=77
 
+. ./common
+
 trap 'err $LINENO' ERR
 
 # sample json:
@@ -23,32 +22,8 @@ trap 'err $LINENO' ERR
 #  "blockdev":"pmem5s",
 #}
 
-# $1: Line number
-# $2: exit code
-err()
-{
-	[ -n "$2" ] && rc="$2"
-	echo "test/rescan-partitions.sh: failed at line $1"
-	exit "$rc"
-}
-
-check_min_kver()
-{
-	local ver="$1"
-	: "${KVER:=$(uname -r)}"
-
-	[ -n "$ver" ] || return 1
-	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
-}
-check_min_kver "4.16" || { echo "kernel $KVER may not contain fixes for partition rescanning"; exit "$rc"; }
+check_min_kver "4.16" || do_skip "may not contain fixes for partition rescanning"
 
-check_prereq()
-{
-	if ! command -v "$1" >/dev/null; then
-		echo "missing '$1', skipping.."
-		exit "$rc"
-	fi
-}
 check_prereq "parted"
 check_prereq "blockdev"
 
@@ -65,12 +40,14 @@ test_mode()
 
 	# create namespace
 	json=$($ndctl create-namespace -b "$bus" -t pmem -m "$mode")
+	rc=2
 	eval "$(echo "$json" | sed -e "$json2var")"
-	[ -n "$dev" ] || err "$LINENO" 2
-	[ -n "$size" ] || err "$LINENO" 2
-	[ -n "$blockdev" ] || err "$LINENO" 2
-	[ $size -gt 0 ] || err "$LINENO" 2
+	[ -n "$dev" ] || err "$LINENO"
+	[ -n "$size" ] || err "$LINENO"
+	[ -n "$blockdev" ] || err "$LINENO"
+	[ $size -gt 0 ] || err "$LINENO"
 
+	rc=1
 	# create partition
 	parted --script /dev/$blockdev mklabel gpt mkpart primary 1MiB 10MiB
 
@@ -89,7 +66,8 @@ test_mode()
 		echo "mode: $mode - partition read successful"
 	else
 		echo "mode: $mode - partition read failed"
-		err "$LINENO" 1
+		rc=1
+		err "$LINENO"
 	fi
 
 	$ndctl disable-namespace $dev
diff --git a/test/sector-mode.sh b/test/sector-mode.sh
index ee364eb..c71bd08 100755
--- a/test/sector-mode.sh
+++ b/test/sector-mode.sh
@@ -17,10 +17,7 @@ BUS1="-b nfit_test.1"
 TEST=$0
 rc=77
 
-err() {
-	echo "$TEST: failed at line $1"
-	exit $rc
-}
+. ./common
 
 set -e
 trap 'err $LINENO' ERR
-- 
2.18.0.rc1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
