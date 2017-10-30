Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9CB072034A7D9
 for <linux-nvdimm@lists.01.org>; Mon, 30 Oct 2017 13:32:25 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] test: correctly adjust rc for skip/fail
Date: Mon, 30 Oct 2017 14:33:59 -0600
Message-Id: <20171030203359.13177-1-vishal.l.verma@intel.com>
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

The exit code for daxdev-errors and multi-dax wasn't being set correctly
to distinguish a skipped test from a failure. Fix it by setting rc to 77
prior to probing for nfit_test, and to 1 after it.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/daxdev-errors.sh | 3 ++-
 test/multi-dax.sh     | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
index e9d9d57..d15bd82 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -37,7 +37,6 @@ check_min_kver "4.12" || { echo "kernel $KVER lacks dax dev error handling"; exi
 
 set -e
 trap 'err $LINENO' ERR
-rc=1
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
@@ -45,6 +44,8 @@ $NDCTL disable-region $BUS all
 $NDCTL zero-labels $BUS all
 $NDCTL enable-region $BUS all
 
+rc=1
+
 query=". | sort_by(.available_size) | reverse | .[0].dev"
 region=$($NDCTL list $BUS -t pmem -Ri | jq -r "$query")
 
diff --git a/test/multi-dax.sh b/test/multi-dax.sh
index 751f16f..d70ce69 100755
--- a/test/multi-dax.sh
+++ b/test/multi-dax.sh
@@ -20,7 +20,6 @@ json2var="s/[{}\",]//g; s/:/=/g"
 rc=77
 
 err() {
-	rc=1
 	echo "test/multi-dax: failed at line $1"
 	exit $rc
 }
@@ -45,6 +44,8 @@ $NDCTL disable-region $BUS all
 $NDCTL zero-labels $BUS all
 $NDCTL enable-region $BUS all
 
+rc=1
+
 query=". | sort_by(.available_size) | reverse | .[0].dev"
 region=$($NDCTL list $BUS -t pmem -Ri | jq -r "$query")
 
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
