Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8109421A04830
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 16:04:57 -0700 (PDT)
Subject: [ndctl PATCH] test, label-compat.sh: fix region determination
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 01 May 2017 15:59:05 -0700
Message-ID: <149367954530.14481.331986452118782394.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The test is accidentally hard-coding the test region, "7", which we
should be determining programmatically. Replace "7" with "$region", the
largest pmem region on the "nfit_test.0" bus. Otherwise, the test can
fail just based on the initialization order of various nvdimm buses.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/label-compat.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/label-compat.sh b/test/label-compat.sh
index f103f64ae7ff..ed26a583a320 100755
--- a/test/label-compat.sh
+++ b/test/label-compat.sh
@@ -46,7 +46,7 @@ done
 
 $NDCTL enable-region $BUS all
 
-len=$($NDCTL list -r 7 -N | jq -r "length")
+len=$($NDCTL list -r $region -N | jq -r "length")
 
 if [ -z $len ]; then
 	rc=1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
