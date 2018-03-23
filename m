Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x242.google.com (mail-pf0-x242.google.com
 [IPv6:2607:f8b0:400e:c00::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D87E22146720
 for <linux-nvdimm@lists.01.org>; Fri, 23 Mar 2018 01:05:57 -0700 (PDT)
Received: by mail-pf0-x242.google.com with SMTP id a11so1086703pff.8
 for <linux-nvdimm@lists.01.org>; Fri, 23 Mar 2018 01:12:30 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 4/6] libnvdimm/of: Symlink platform and region devices
Date: Fri, 23 Mar 2018 19:12:07 +1100
Message-Id: <20180323081209.31387-4-oohall@gmail.com>
In-Reply-To: <20180323081209.31387-1-oohall@gmail.com>
References: <20180323081209.31387-1-oohall@gmail.com>
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
Cc: devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-ID: <linux-nvdimm@lists.01.org>

Add a way direct link between the region and the platform device that
creates the region.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 drivers/nvdimm/of_nvdimm.c   | 11 +++++++++++
 drivers/nvdimm/region_devs.c | 13 +++++++++++++
 include/linux/libnvdimm.h    |  1 +
 3 files changed, 25 insertions(+)

diff --git a/drivers/nvdimm/of_nvdimm.c b/drivers/nvdimm/of_nvdimm.c
index 79c28291f420..28f4ca23a690 100644
--- a/drivers/nvdimm/of_nvdimm.c
+++ b/drivers/nvdimm/of_nvdimm.c
@@ -37,6 +37,7 @@ static int of_nd_region_probe(struct platform_device *pdev)
 	struct resource temp_res;
 	struct nd_region *region;
 	struct device_node *np;
+	int rc;
 
 	np = dev_of_node(&pdev->dev);
 	if (!np)
@@ -71,6 +72,15 @@ static int of_nd_region_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, region);
 
+	/*
+	 * Add a symlink to the ndbus region object. Without this there's no
+	 * simple way to go from the platform device to the region it spawned.
+	 */
+	rc = sysfs_create_link(&pdev->dev.kobj,
+				nd_region_kobj(region), "region");
+	if (rc)
+		pr_warn("Failed to create symlink to region (rc = %d)!\n", rc);
+
 	return 0;
 }
 
@@ -78,6 +88,7 @@ static int of_nd_region_remove(struct platform_device *pdev)
 {
 	struct nd_region *r = platform_get_drvdata(pdev);
 
+	sysfs_delete_link(&pdev->dev.kobj, nd_region_kobj(r), "region");
 	nd_region_destroy(r);
 
 	return 0;
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 76f46fd1fae0..af09acc1d93b 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1054,6 +1054,19 @@ struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
 }
 EXPORT_SYMBOL_GPL(nvdimm_volatile_region_create);
 
+struct kobject *nd_region_kobj(struct nd_region *region)
+{
+	/*
+	 * region init is async so we need to explicitly synchronise
+	 * to prevent handing out a kobj reference before device_add()
+	 * has been run
+	 */
+	nd_synchronize();
+
+	return &region->dev.kobj;
+}
+EXPORT_SYMBOL_GPL(nd_region_kobj);
+
 /**
  * nvdimm_flush - flush any posted write queues between the cpu and pmem media
  * @nd_region: blk or interleaved pmem region
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index df21ca176e98..a4b3663bac38 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -172,6 +172,7 @@ struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus);
 struct device *to_nvdimm_bus_dev(struct nvdimm_bus *nvdimm_bus);
 const char *nvdimm_name(struct nvdimm *nvdimm);
 struct kobject *nvdimm_kobj(struct nvdimm *nvdimm);
+struct kobject *nd_region_kobj(struct nd_region *region);
 unsigned long nvdimm_cmd_mask(struct nvdimm *nvdimm);
 void *nvdimm_provider_data(struct nvdimm *nvdimm);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
