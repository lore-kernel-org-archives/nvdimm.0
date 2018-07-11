Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED54B2097E26F
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 16:56:50 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/2] ndctl,
 test: convert remaining tests to use test/common
Date: Wed, 11 Jul 2018 17:56:44 -0600
Message-Id: <20180711235644.26998-2-vishal.l.verma@intel.com>
In-Reply-To: <20180711235644.26998-1-vishal.l.verma@intel.com>
References: <20180711235644.26998-1-vishal.l.verma@intel.com>
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

The original test/common conversions missed the --enable-destructive
class of tests. The json single object vs. array changes prompted
changes to the json2var definitions, which these tests had a local copy
of. Instead of fixing up these local copies, take the change to properly
convert these tests to using test/common.

Fixes: 72c46ab194d9 ("ndctl list: always output array without --human")
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/dax.sh            | 18 +++++++++---------
 test/device-dax-fio.sh | 23 +++++------------------
 test/mmap.sh           | 12 +++++-------
 3 files changed, 19 insertions(+), 34 deletions(-)

diff --git a/test/dax.sh b/test/dax.sh
index b63d563..d38fd01 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -11,13 +11,13 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
+. ./common
+
 MNT=test_dax_mnt
 FILE=image
-NDCTL="../ndctl/ndctl"
-json2var="s/[{}\",]//g; s/:/=/g"
 blockdev=""
 
-err() {
+cleanup() {
 	echo "test-dax: failed at line $1"
 	if [ -n "$blockdev" ]; then
 		umount /dev/$blockdev
@@ -40,11 +40,11 @@ run_test() {
 
 set -e
 mkdir -p $MNT
-trap 'err $LINENO' ERR
+trap 'err $LINENO cleanup' ERR
 
 dev=$(./dax-dev)
 json=$($NDCTL list -N -n $dev)
-eval $(echo $json | sed -e "$json2var")
+eval $(json2var <<< "$json")
 rc=1
 
 mkfs.ext4 /dev/$blockdev
@@ -55,7 +55,7 @@ umount $MNT
 
 # convert pmem to put the memmap on the device
 json=$($NDCTL create-namespace -m fsdax -M dev -f -e $dev)
-eval $(echo $json | sed -e "$json2var")
+eval $(json2var <<< "$json")
 [ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
 
 #note the blockdev returned from ndctl create-namespace lacks the /dev prefix
@@ -66,7 +66,7 @@ run_test
 umount $MNT
 
 json=$($NDCTL create-namespace -m raw -f -e $dev)
-eval $(echo $json | sed -e "$json2var")
+eval $(json2var <<< "$json")
 [ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
 
 mkfs.xfs -f /dev/$blockdev
@@ -77,7 +77,7 @@ umount $MNT
 
 # convert pmem to put the memmap on the device
 json=$($NDCTL create-namespace -m fsdax -M dev -f -e $dev)
-eval $(echo $json | sed -e "$json2var")
+eval $(json2var <<< "$json")
 [ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
 
 mkfs.xfs -f /dev/$blockdev
@@ -88,7 +88,7 @@ umount $MNT
 
 # revert namespace to raw mode
 json=$($NDCTL create-namespace -m raw -f -e $dev)
-eval $(echo $json | sed -e "$json2var")
+eval $(json2var <<< "$json")
 [ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
 
 exit $rc
diff --git a/test/device-dax-fio.sh b/test/device-dax-fio.sh
index 6214030..b6d5e0e 100755
--- a/test/device-dax-fio.sh
+++ b/test/device-dax-fio.sh
@@ -11,30 +11,17 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
-NDCTL="../ndctl/ndctl"
+. ./common
+
 rc=77
 
 set -e
 
-err() {
-	echo "test/device-dax-fio.sh: failed at line $1"
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
-}
+check_min_kver "4.11" || do_skip "kernel may lack device-dax fixes"
 
-check_min_kver "4.11" || { echo "kernel $KVER may lack latest device-dax fixes"; exit $rc; }
-
-set -e
 trap 'err $LINENO' ERR
 
+check_prereq "fio"
 if ! fio --enghelp | grep -q "dev-dax"; then
 	echo "fio lacks dev-dax engine"
 	exit 77
@@ -79,7 +66,7 @@ do
 
 	# revert namespace to raw mode
 	json=$($NDCTL create-namespace -m raw -f -e $dev)
-	mode=$(echo $json | jq -r ".mode")
+	eval $(json2var <<< "$json")
 	[ $mode != "fsdax" ] && echo "fail: $LINENO" && exit 1
 done
 
diff --git a/test/mmap.sh b/test/mmap.sh
index 423c283..afe50fd 100755
--- a/test/mmap.sh
+++ b/test/mmap.sh
@@ -11,15 +11,15 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
+. ./common
+
 MNT=test_mmap_mnt
 FILE=image
 DEV=""
 TEST=./mmap
-NDCTL="../ndctl/ndctl"
-json2var="s/[{}\",]//g; s/:/=/g"
 rc=77
 
-err() {
+cleanup() {
 	echo "test-mmap: failed at line $1"
 	if [ -n "$DEV" ]; then
 		umount $DEV
@@ -31,8 +31,6 @@ err() {
 }
 
 test_mmap() {
-	trap 'err $LINENO' ERR
-
 	# SHARED
 	$TEST -Mrwps $MNT/$FILE     # mlock, populate, shared (mlock fail)
 	$TEST -Arwps $MNT/$FILE     # mlockall, populate, shared
@@ -58,11 +56,11 @@ test_mmap() {
 
 set -e
 mkdir -p $MNT
-trap 'err $LINENO' ERR
+trap 'err $LINENO cleanup' ERR
 
 dev=$(./dax-dev)
 json=$($NDCTL list -N -n $dev)
-eval $(echo $json | sed -e "$json2var")
+eval $(json2var <<< "$json")
 DEV="/dev/${blockdev}"
 rc=1
 
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
