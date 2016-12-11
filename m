Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 605C582029
 for <linux-nvdimm@lists.01.org>; Sat, 10 Dec 2016 22:33:16 -0800 (PST)
Subject: [PATCH 8/8] dax: add debug for region available_size
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Dec 2016 22:29:07 -0800
Message-ID: <148143774706.10950.14457441051651852899.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add dynamic debug statements to dump the per-dax-dev resource
allocations and device offsets.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index b130eff91b83..d1641e69a088 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -97,8 +97,11 @@ static unsigned long long dax_region_avail_size(
 	WARN_ON_ONCE(!mutex_is_locked(&dax_region->lock));
 
 	size = resource_size(&dax_region->res);
-	for_each_dax_region_resource(dax_region, res)
+	for_each_dax_region_resource(dax_region, res) {
+		dev_dbg(dax_region->dev, "%s: %pr offset: %lx\n",
+				res->name, res, res->desc);
 		size -= resource_size(res);
+	}
 
 	return size;
 }
@@ -372,6 +375,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 	dax_region->res.name = dev_name(parent);
 	dax_region->res.start = res->start;
 	dax_region->res.end = res->end;
+	dax_region->res.flags = IORESOURCE_MEM;
 	dax_region->pfn_flags = pfn_flags;
 	mutex_init(&dax_region->lock);
 	kref_init(&dax_region->kref);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
