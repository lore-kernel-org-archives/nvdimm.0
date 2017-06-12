Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AB52821A16EC4
 for <linux-nvdimm@lists.01.org>; Mon, 12 Jun 2017 09:41:24 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH] libnvdimm, pmem: Add sysfs notifications to badblocks
Date: Mon, 12 Jun 2017 10:42:06 -0600
Message-Id: <20170612164206.5794-1-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Sysfs "badblocks" information may be updated during run-time via
MCE, SCI, and sysfs "scrub".

Add support to send sysfs notifications to sysfs "badblocks" file
under region and pmem directories when their badblocks information
is re-evaluated (but is not necessarily changed) during run-time.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linda Knippers <linda.knippers@hpe.com>
---
 drivers/nvdimm/nd.h     |    1 +
 drivers/nvdimm/pmem.c   |   12 ++++++++++++
 drivers/nvdimm/pmem.h   |    1 +
 drivers/nvdimm/region.c |   12 ++++++++++--
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 03852d7..4bb57ff 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -155,6 +155,7 @@ struct nd_region {
 	u64 ndr_start;
 	int id, num_lanes, ro, numa_node;
 	void *provider_data;
+	struct kernfs_node *bb_state;
 	struct badblocks bb;
 	struct nd_interleave_set *nd_set;
 	struct nd_percpu_lane __percpu *lane;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index c544d46..ae8dd5d 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -377,6 +377,13 @@ static int pmem_attach_disk(struct device *dev,
 
 	revalidate_disk(disk);
 
+	pmem->bb_state = sysfs_get_dirent(disk_to_dev(disk)->kobj.sd,
+					  "badblocks");
+	if (pmem->bb_state)
+		sysfs_put(pmem->bb_state);
+	else
+		dev_warn(dev, "sysfs_get_dirent 'badblocks' failed\n");
+
 	return 0;
 }
 
@@ -428,6 +435,7 @@ static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
 	struct nd_namespace_io *nsio;
 	struct resource res;
 	struct badblocks *bb;
+	struct kernfs_node *bb_state;
 
 	if (event != NVDIMM_REVALIDATE_POISON)
 		return;
@@ -439,11 +447,13 @@ static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
 		nd_region = to_nd_region(ndns->dev.parent);
 		nsio = to_nd_namespace_io(&ndns->dev);
 		bb = &nsio->bb;
+		bb_state = NULL;
 	} else {
 		struct pmem_device *pmem = dev_get_drvdata(dev);
 
 		nd_region = to_region(pmem);
 		bb = &pmem->bb;
+		bb_state = pmem->bb_state;
 
 		if (is_nd_pfn(dev)) {
 			struct nd_pfn *nd_pfn = to_nd_pfn(dev);
@@ -463,6 +473,8 @@ static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
 	res.start = nsio->res.start + offset;
 	res.end = nsio->res.end - end_trunc;
 	nvdimm_badblocks_populate(nd_region, bb, &res);
+	if (bb_state)
+		sysfs_notify_dirent(bb_state);
 }
 
 MODULE_ALIAS("pmem");
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index 7f4dbd7..c5917f0 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -17,6 +17,7 @@ struct pmem_device {
 	size_t			size;
 	/* trim size when namespace capacity has been section aligned */
 	u32			pfn_pad;
+	struct kernfs_node	*bb_state;
 	struct badblocks	bb;
 	struct dax_device	*dax_dev;
 	struct gendisk		*disk;
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 869a886..ca94029 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -58,10 +58,16 @@ static int nd_region_probe(struct device *dev)
 
 		if (devm_init_badblocks(dev, &nd_region->bb))
 			return -ENODEV;
+		nd_region->bb_state = sysfs_get_dirent(nd_region->dev.kobj.sd,
+						       "badblocks");
+		if (nd_region->bb_state)
+			sysfs_put(nd_region->bb_state);
+		else
+			dev_warn(&nd_region->dev,
+				"sysfs_get_dirent 'badblocks' failed\n");
 		ndr_res.start = nd_region->ndr_start;
 		ndr_res.end = nd_region->ndr_start + nd_region->ndr_size - 1;
-		nvdimm_badblocks_populate(nd_region,
-				&nd_region->bb, &ndr_res);
+		nvdimm_badblocks_populate(nd_region, &nd_region->bb, &ndr_res);
 	}
 
 	nd_region->btt_seed = nd_btt_create(nd_region);
@@ -126,6 +132,8 @@ static void nd_region_notify(struct device *dev, enum nvdimm_event event)
 				nd_region->ndr_size - 1;
 			nvdimm_badblocks_populate(nd_region,
 					&nd_region->bb, &res);
+			if (nd_region->bb_state)
+				sysfs_notify_dirent(nd_region->bb_state);
 		}
 	}
 	device_for_each_child(dev, &event, child_notify);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
