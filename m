Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9CB1E21BADACB
 for <linux-nvdimm@lists.01.org>; Sat,  1 Jul 2017 08:55:34 -0700 (PDT)
Subject: [PATCH] libnvdimm, region,
 pmem: fix 'badblocks' sysfs_get_dirent() reference lifetime
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 01 Jul 2017 08:50:43 -0700
Message-ID: <149892424300.37698.9888818880178611728.stgit@dwillia2-desk3.amr.corp.intel.com>
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

We need to hold a reference on the 'dirent' until we are sure there are
no more notifications that will be sent. As noted in the new comments we
take advantage of the fact that the references are taken and dropped
under device_lock() and that nd_device_notify() holds device_lock() over
new badblocks notifications. The notifications that happen when
badblocks are cleared only occur while the device is active.

Also take the opportunity to fix up the error messages to report the
user visible effect of a sysfs_get_dirent() failure.

Fixes: 975750a98c26 ("libnvdimm, pmem: Add sysfs notifications to badblocks")
Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c   |   16 ++++++++++++----
 drivers/nvdimm/region.c |   13 +++++++++----
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 34189a145ac6..4a9cffc14512 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -382,10 +382,8 @@ static int pmem_attach_disk(struct device *dev,
 
 	pmem->bb_state = sysfs_get_dirent(disk_to_dev(disk)->kobj.sd,
 					  "badblocks");
-	if (pmem->bb_state)
-		sysfs_put(pmem->bb_state);
-	else
-		dev_warn(dev, "sysfs_get_dirent 'badblocks' failed\n");
+	if (!pmem->bb_state)
+		dev_warn(dev, "'badblocks' notification disabled\n");
 
 	return 0;
 }
@@ -418,8 +416,18 @@ static int nd_pmem_probe(struct device *dev)
 
 static int nd_pmem_remove(struct device *dev)
 {
+	struct pmem_device *pmem = dev_get_drvdata(dev);
+
 	if (is_nd_btt(dev))
 		nvdimm_namespace_detach_btt(to_nd_btt(dev));
+	else {
+		/*
+		 * Note, this assumes device_lock() context to not race
+		 * nd_pmem_notify()
+		 */
+		sysfs_put(pmem->bb_state);
+		pmem->bb_state = NULL;
+	}
 	nvdimm_flush(to_nd_region(dev->parent));
 
 	return 0;
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index ca94029d20b3..034f0a07d627 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -60,11 +60,9 @@ static int nd_region_probe(struct device *dev)
 			return -ENODEV;
 		nd_region->bb_state = sysfs_get_dirent(nd_region->dev.kobj.sd,
 						       "badblocks");
-		if (nd_region->bb_state)
-			sysfs_put(nd_region->bb_state);
-		else
+		if (!nd_region->bb_state)
 			dev_warn(&nd_region->dev,
-				"sysfs_get_dirent 'badblocks' failed\n");
+					"'badblocks' notification disabled\n");
 		ndr_res.start = nd_region->ndr_start;
 		ndr_res.end = nd_region->ndr_start + nd_region->ndr_size - 1;
 		nvdimm_badblocks_populate(nd_region, &nd_region->bb, &ndr_res);
@@ -111,6 +109,13 @@ static int nd_region_remove(struct device *dev)
 	dev_set_drvdata(dev, NULL);
 	nvdimm_bus_unlock(dev);
 
+	/*
+	 * Note, this assumes device_lock() context to not race
+	 * nd_region_notify()
+	 */
+	sysfs_put(nd_region->bb_state);
+	nd_region->bb_state = NULL;
+
 	return 0;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
