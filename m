Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B22D9211BA47B
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 15:13:18 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] libndctl: fix bb iterator leak in namespaces
Date: Wed, 30 Jan 2019 16:13:07 -0700
Message-Id: <20190130231307.5223-1-vishal.l.verma@intel.com>
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
Cc: Piotr Balcer <piotr.balcer@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Piotr Balcer <piotr.balcer@intel.com>

We were neglecting to free bb_iterator in free_namespace(), causing a
memory leak. Close the leak by adding the required deallocation.

Signed-off-by: Piotr Balcer <piotr.balcer@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---

via github:pull/80

 ndctl/lib/libndctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 5eb915f..c9e2875 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -461,6 +461,7 @@ static void free_namespace(struct ndctl_namespace *ndns, struct list_head *head)
 	free(ndns->ndns_buf);
 	free(ndns->bdev);
 	free(ndns->alt_name);
+	badblocks_iter_free(&ndns->bb_iter);
 	kmod_module_unref(ndns->module);
 	free(ndns);
 }
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
