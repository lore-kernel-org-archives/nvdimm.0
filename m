Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EDACE2096F33A
 for <linux-nvdimm@lists.01.org>; Sun, 24 Jun 2018 22:39:09 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, test: remove an unused variable assignment
Date: Sun, 24 Jun 2018 23:38:58 -0600
Message-Id: <20180625053858.5927-1-vishal.l.verma@intel.com>
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

Static analysis complains that 'rc' was overwritten immediately after
assigning to it, and therefore the assignment is useless. Remove it.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/dsm-fail.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/test/dsm-fail.c b/test/dsm-fail.c
index 45a6c4f..6845f81 100644
--- a/test/dsm-fail.c
+++ b/test/dsm-fail.c
@@ -339,11 +339,9 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 	sprintf(path, "%s/fail_cmd", DIMM_PATH);
 	sprintf(buf, "0\n");
 	rc = __sysfs_write_attr(&log_ctx, path, buf);
-	if (rc) {
+	if (rc)
 		fprintf(stderr, "%s: failed to clear fail_cmd mask\n",
 				ndctl_dimm_get_devname(victim));
-		rc = -ENXIO;
-	}
 	rc = ndctl_dimm_enable(victim);
 	if (rc) {
 		fprintf(stderr, "failed to enable victim: %s after clearing error\n",
-- 
2.17.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
