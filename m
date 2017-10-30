Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E49FB2095B07B
 for <linux-nvdimm@lists.01.org>; Mon, 30 Oct 2017 10:42:02 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 5/6] ndctl/test: update existing unit tests to use
 inject-error
Date: Mon, 30 Oct 2017 11:43:34 -0600
Message-Id: <20171030174335.6806-6-vishal.l.verma@intel.com>
In-Reply-To: <20171030174335.6806-1-vishal.l.verma@intel.com>
References: <20171030174335.6806-1-vishal.l.verma@intel.com>
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

Until now, various unit tests related to error handling used to expect
'canned' errors to be present in the middle of every nfit_test
namespace. With the ACPI error injection patches for nfit_test, this is
no longer the case. Update the existing unit tests it inject any errors
they need for testing themselves using inject-error, rather than
expecting canned errors.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/clear.sh         |  5 ++++-
 test/dax-errors.sh    |  5 ++++-
 test/daxdev-errors.sh | 17 ++++++++++++++---
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/test/clear.sh b/test/clear.sh
index a60c3d9..c22ff3b 100755
--- a/test/clear.sh
+++ b/test/clear.sh
@@ -54,7 +54,10 @@ eval $(echo $json | sed -e "$json2var")
 [ $dev = "x" ] && echo "fail: $LINENO" && exit 1
 [ $mode != "raw" ] && echo "fail: $LINENO" && exit 1
 
-# check for expected errors in the middle of the namespace
+# inject errors in the middle of the namespace, verify that reading fails
+err_sector="$(((size/512) / 2))"
+err_count=8
+$NDCTL inject-error --block="$err_sector" --count=$err_count $dev
 read sector len < /sys/block/$blockdev/badblocks
 [ $((sector * 2)) -ne $((size /512)) ] && echo "fail: $LINENO" && exit 1
 if dd if=/dev/$blockdev of=/dev/null iflag=direct bs=512 skip=$sector count=$len; then
diff --git a/test/dax-errors.sh b/test/dax-errors.sh
index 5af3859..02bbca8 100755
--- a/test/dax-errors.sh
+++ b/test/dax-errors.sh
@@ -64,7 +64,10 @@ eval $(echo $json | sed -e "$json2var")
 [ $dev = "x" ] && echo "fail: $LINENO" && exit 1
 [ $mode != "raw" ] && echo "fail: $LINENO" && exit 1
 
-# check for expected errors in the middle of the namespace
+# inject errors in the middle of the namespace, verify that reading fails
+err_sector="$(((size/512) / 2))"
+err_count=8
+$NDCTL inject-error --block="$err_sector" --count=$err_count $dev
 read sector len < /sys/block/$blockdev/badblocks
 [ $((sector * 2)) -ne $((size /512)) ] && echo "fail: $LINENO" && exit 1
 if dd if=/dev/$blockdev of=/dev/null iflag=direct bs=512 skip=$sector count=$len; then
diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
index 8115087..e9d9d57 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -37,6 +37,7 @@ check_min_kver "4.12" || { echo "kernel $KVER lacks dax dev error handling"; exi
 
 set -e
 trap 'err $LINENO' ERR
+rc=1
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
@@ -68,18 +69,28 @@ chardev=$(echo $json | jq ". | select(.mode == \"dax\") | .daxregion.devices[0].
 #  }
 #}
 
+json1=$($NDCTL list $BUS --mode=dax --namespaces)
+eval $(echo $json1 | sed -e "$json2var")
+nsdev=$dev
+
 json1=$($NDCTL list $BUS)
 eval $(echo $json1 | sed -e "$json2var")
+busdev=$dev
+
+# inject errors in the middle of the namespace
+err_sector="$(((size/512) / 2))"
+err_count=8
+$NDCTL inject-error --block="$err_sector" --count=$err_count $nsdev
 
-read sector len < /sys/bus/platform/devices/nfit_test.0/$dev/$region/badblocks
+read sector len < /sys/bus/nd/devices/$region/badblocks
 echo "sector: $sector len: $len"
 
 # run the daxdev-errors test
 test -x ./daxdev-errors
-./daxdev-errors $dev $region
+./daxdev-errors $busdev $region
 
 # check badblocks, should be empty
-if read sector len < /sys/bus/platform/devices/nfit_test.0/$dev/$region/badblocks; then
+if read sector len < /sys/bus/platform/devices/nfit_test.0/$busdev/$region/badblocks; then
 	echo "badblocks empty, expected"
 fi
 [ -n "$sector" ] && echo "fail: $LINENO" && exit 1
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
