Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 11BF0211518D1
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 15:45:07 -0700 (PDT)
Subject: [PATCH v2 4/5] libnvdimm: add overwrite status notification
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 28 Sep 2018 15:45:06 -0700
Message-ID: <153817470623.19407.2154312383983084713.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153817460190.19407.1009470794996360570.stgit@djiang5-desk3.ch.intel.com>
References: <153817460190.19407.1009470794996360570.stgit@djiang5-desk3.ch.intel.com>
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

Adding sysfs notification for when overwrite has completed to allow
user monitoring app to be aware of overwrite completion status.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/core.c   |    5 +++++
 drivers/nvdimm/dimm_devs.c |   12 ++++++++++++
 drivers/nvdimm/nd-core.h   |    1 +
 include/linux/libnvdimm.h  |    1 +
 4 files changed, 19 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index b7773c70ee81..93c044527994 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1950,6 +1950,11 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		if (!nvdimm)
 			continue;
 
+		rc = nvdimm_setup_security_events(nvdimm);
+		if (rc < 0)
+			dev_warn(acpi_desc->dev,
+					"no security event setup failed\n");
+
 		nfit_kernfs = sysfs_get_dirent(nvdimm_kobj(nvdimm)->sd, "nfit");
 		if (nfit_kernfs)
 			nfit_mem->flags_attr = sysfs_get_dirent(nfit_kernfs,
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 73f7e879d6e0..12bafa3ba8f9 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -211,6 +211,8 @@ static void nvdimm_overwrite_query(struct work_struct *work)
 	else
 		dev_info(&nvdimm->dev, "Overwrite completed\n");
 
+	if (nvdimm->overwrite_state)
+		sysfs_notify_dirent(nvdimm->overwrite_state);
 	nvdimm->overwrite_tmo = 0;
 	nvdimm_clear_security_busy(&nvdimm->dev);
 	nvdimm_security_get_state(&nvdimm->dev);
@@ -1134,6 +1136,16 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 }
 EXPORT_SYMBOL_GPL(nvdimm_create);
 
+int nvdimm_setup_security_events(struct nvdimm *nvdimm)
+{
+	nvdimm->overwrite_state = sysfs_get_dirent(nvdimm->dev.kobj.sd,
+			"security");
+	if (!nvdimm->overwrite_state)
+		return -ENODEV;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvdimm_setup_security_events);
+
 int alias_dpa_busy(struct device *dev, void *data)
 {
 	resource_size_t map_end, blk_start, new;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index efc7eb9e624c..043016f41156 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -48,6 +48,7 @@ struct nvdimm {
 	struct key *key;
 	struct delayed_work dwork;
 	unsigned int overwrite_tmo;
+	struct kernfs_node *overwrite_state;
 };
 
 /**
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index b59ff6b798b2..baf33b74cddf 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -218,6 +218,7 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		unsigned long cmd_mask, int num_flush,
 		struct resource *flush_wpq, const char *dimm_id,
 		const struct nvdimm_security_ops *sec_ops);
+int nvdimm_setup_security_events(struct nvdimm *nvdimm);
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
 u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
