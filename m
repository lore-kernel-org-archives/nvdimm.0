Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1087521E87969
 for <linux-nvdimm@lists.01.org>; Fri,  8 Sep 2017 17:59:51 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, test: fix daxdax-errors.sh skip condition
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 08 Sep 2017 17:56:19 -0700
Message-ID: <150491857945.2236.14367331919652638639.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Return the skip code '77' if the test dependencies cannot be satisfied.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/daxdev-errors.sh |    1 -
 1 file changed, 1 deletion(-)

diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
index 4818a4a1efcf..8115087a085f 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -20,7 +20,6 @@ json2var="s/[{}\",]//g; s/:/=/g"
 rc=77
 
 err() {
-	rc=1
 	echo "test/daxdev-errors: failed at line $1"
 	exit $rc
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
