Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B196420347175
 for <linux-nvdimm@lists.01.org>; Fri, 20 Oct 2017 08:55:04 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [ndctl patch] btt_check_bitmap: initialize rc
Date: Fri, 20 Oct 2017 11:58:42 -0400
Message-ID: <x49k1zperpp.fsf@segfault.boston.devel.redhat.com>
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
To: vishal.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

It may be possible that rc is never set before returning from
the function.  nfree would have to be zero, and the bitmap
would have to be full.  Fix it.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/ndctl/check.c b/ndctl/check.c
index 915bb9d..dafd6a8 100644
--- a/ndctl/check.c
+++ b/ndctl/check.c
@@ -508,7 +508,7 @@ static int btt_check_bitmap(struct arena_info *a)
 {
 	unsigned long *bm;
 	u32 i, btt_mapping;
-	int rc;
+	int rc = BTT_BITMAP_ERROR;
 
 	bm = bitmap_alloc(a->internal_nlba);
 	if (bm == NULL)
@@ -521,7 +521,6 @@ static int btt_check_bitmap(struct arena_info *a)
 			info(a->bttc,
 				"arena %d: internal block %#x is referenced by two map entries\n",
 				a->num, btt_mapping);
-			rc = BTT_BITMAP_ERROR;
 			goto out;
 		}
 		bitmap_set(bm, btt_mapping, 1);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
