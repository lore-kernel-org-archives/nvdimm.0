Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 743401A1F0A
 for <linux-nvdimm@lists.01.org>; Wed, 21 Sep 2016 15:28:30 -0700 (PDT)
Subject: [PATCH] [TRIVIAL] nvdimm: remove duplicate nd_mapping declaration
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 21 Sep 2016 15:28:29 -0700
Message-ID: <147449690946.52615.17016908065359499642.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/nd-core.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 38ce6bb..1414784 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -79,7 +79,6 @@ resource_size_t nd_blk_available_dpa(struct nd_mapping *nd_mapping);
 resource_size_t nd_region_available_dpa(struct nd_region *nd_region);
 resource_size_t nvdimm_allocated_dpa(struct nvdimm_drvdata *ndd,
 		struct nd_label_id *label_id);
-struct nd_mapping;
 struct resource *nsblk_add_resource(struct nd_region *nd_region,
 		struct nvdimm_drvdata *ndd, struct nd_namespace_blk *nsblk,
 		resource_size_t start);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
