Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 127DE2098EA9F
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 14:14:19 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, test: Fix dax.sh return code
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Jul 2018 14:04:21 -0700
Message-ID: <153073826178.9647.3462886609135347418.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Commit 11b349b5236e "ndctl, test: Disable poison tests for now"
inadvertently prevented the dax.sh test from ever succeeding. Revert the
change to return $rc instead of 0.

Fixes: 11b349b5236e ("ndctl, test: Disable poison tests for now")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/dax.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/dax.sh b/test/dax.sh
index 30fe16721935..2a82281edb35 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -90,4 +90,4 @@ json=$($NDCTL create-namespace -m raw -f -e $dev)
 eval $(echo $json | sed -e "$json2var")
 [ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
 
-exit $rc
+exit 0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
