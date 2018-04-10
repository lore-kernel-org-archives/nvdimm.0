Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C25E62270D335
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 10:17:28 -0700 (PDT)
Subject: [PATCH v2] ndctl: fix libdaxctl memory leak
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 10 Apr 2018 10:17:27 -0700
Message-ID: <152338060678.17137.14896323871568581107.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

When daxctl_unref is releasing the context, we should make sure that the
regions and devices are also being released. free_region() will free
all the devices under the region.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

v2: Use list_for_each_safe() for region removal. (Dan)

 daxctl/lib/libdaxctl.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 9e503201..22f4210a 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -29,6 +29,8 @@
 
 static const char *attrs = "dax_region";
 
+static void free_region(struct daxctl_region *region, struct list_head *head);
+
 /**
  * struct daxctl_ctx - library user context to find "nd" instances
  *
@@ -119,11 +121,17 @@ DAXCTL_EXPORT struct daxctl_ctx *daxctl_ref(struct daxctl_ctx *ctx)
  */
 DAXCTL_EXPORT void daxctl_unref(struct daxctl_ctx *ctx)
 {
+	struct daxctl_region *region, *_r;
+
 	if (ctx == NULL)
 		return;
 	ctx->refcount--;
 	if (ctx->refcount > 0)
 		return;
+
+	list_for_each_safe(&ctx->regions, region, _r, list)
+		free_region(region, &ctx->regions);
+
 	info(ctx, "context %p released\n", ctx);
 	free(ctx);
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
