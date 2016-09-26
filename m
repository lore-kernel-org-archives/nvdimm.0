Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 518211A1DF1
 for <linux-nvdimm@lists.01.org>; Mon, 26 Sep 2016 11:06:51 -0700 (PDT)
Subject: [PATCH] nvdimm: reduce duplicated wqp flushes
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 26 Sep 2016 11:06:50 -0700
Message-ID: <147491321005.138924.1988435746987431241.stgit@djiang5-desk3.ch.intel.com>
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

Existing implemenetation writes to all the flush hint addresses for a
given ND region. This is not necessary as the flushes are per imc and
not per DIMM. Search the mappings and clear out the duplicates at init
to avoid multiple flush to the same imc.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/region_devs.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index b1f3bb7..cac917f 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -70,7 +70,7 @@ static int nvdimm_map_flush(struct device *dev, struct nvdimm *nvdimm, int dimm,
 
 int nd_region_activate(struct nd_region *nd_region)
 {
-	int i, num_flush = 0;
+	int i, j, num_flush = 0;
 	struct nd_region_data *ndrd;
 	struct device *dev = &nd_region->dev;
 	size_t flush_data_size = sizeof(void *);
@@ -107,6 +107,21 @@ int nd_region_activate(struct nd_region *nd_region)
 			return rc;
 	}
 
+	/*
+	 * Clear out entries that are duplicates. This should prevent the
+	 * extra flushings.
+	 */
+	for (i = 0; i < nd_region->ndr_mappings - 1; i++) {
+		/* ignore if NULL already */
+		if (!ndrd_get_flush_wpq(ndrd, i, 0))
+			continue;
+
+		for (j = i + 1; j < nd_region->ndr_mappings; j++)
+			if (ndrd_get_flush_wpq(ndrd, i, 0) ==
+			    ndrd_get_flush_wpq(ndrd, j, 0))
+				ndrd_set_flush_wpq(ndrd, j, 0, NULL);
+	}
+
 	return 0;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
