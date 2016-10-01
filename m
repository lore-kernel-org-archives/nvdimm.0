Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 94D7D1A1E05
 for <linux-nvdimm@lists.01.org>; Fri, 30 Sep 2016 17:08:11 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3] test/clear.sh: test to making sure cleared badblocks
 don't reappear
Date: Fri, 30 Sep 2016 18:07:20 -0600
Message-Id: <1475280440-14641-1-git-send-email-vishal.l.verma@intel.com>
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

>From v4.9 onwards, cleared badblocks won't reappear on an ARS or simply
after disabling/re-enabling a namespace. Add a test to make sure this
doesn't regress.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---

v3: make the script's kernel version check also use the new
check_min_kver function

 test/clear.sh | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/test/clear.sh b/test/clear.sh
index 7765c10..dd5316a 100755
--- a/test/clear.sh
+++ b/test/clear.sh
@@ -13,14 +13,16 @@ err() {
 	exit $rc
 }
 
-eval $(uname -r | awk -F. '{print "maj="$1 ";" "min="$2}')
-if [ $maj -lt 4 ]; then
-	echo "kernel $maj.$min lacks clear poison support"
-	exit $rc
-elif [ $maj -eq 4 -a $min -lt 6 ]; then
-	echo "kernel $maj.$min lacks clear poison support"
-	exit $rc
-fi
+check_min_kver()
+{
+	local ver="$1"
+	${KVER:=$(uname -r)}
+
+	[ -n "$ver" ] || return 1
+	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
+}
+
+check_min_kver "4.6" || { echo "kernel $KVER lacks clear poison support"; exit $rc; }
 
 set -e
 trap 'err $LINENO' ERR
@@ -69,6 +71,18 @@ if read sector len < /sys/block/$blockdev/badblocks; then
 	echo "fail: $LINENO" && exit 1
 fi
 
+if check_min_kver "4.9.0"; then
+	# check for re-appearance of stale badblocks from poison_list
+	$NDCTL disable-region $BUS all
+	$NDCTL enable-region $BUS all
+
+	# since we have cleared the errors, a disable/reenable shouldn't bring them back
+	if read sector len < /sys/block/$blockdev/badblocks; then
+		# fail if reading badblocks returns data
+		echo "fail: $LINENO" && exit 1
+	fi
+fi
+
 $NDCTL disable-region $BUS all
 $NDCTL disable-region $BUS1 all
 modprobe -r nfit_test
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
