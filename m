Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 58F5E21184E66
 for <linux-nvdimm@lists.01.org>; Fri,  9 Nov 2018 14:14:24 -0800 (PST)
Subject: [PATCH 07/11] libnvdimm/security: add overwrite status notification
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 09 Nov 2018 15:14:23 -0700
Message-ID: <154180166375.70506.1085533195452285285.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, zohar@linux.vnet.ibm.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding sysfs notification for when overwrite has completed to allow
user monitoring app to be aware of overwrite completion status.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/core.c   |    5 +++++
 drivers/nvdimm/dimm_devs.c |   10 ++++++++++
 drivers/nvdimm/nd-core.h   |    1 +
 drivers/nvdimm/security.c  |    2 ++
 include/linux/libnvdimm.h  |    1 +
 5 files changed, 19 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index de4e00059277..3e6c7b653872 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2033,6 +2033,11 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
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
index b613c131bfb9..39e40074b5df 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -508,6 +508,16 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_dat
 }
 EXPORT_SYMBOL_GPL(__nvdimm_create);
 
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
index 20a8216c503d..b96e1b10e3eb 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -49,6 +49,7 @@ struct nvdimm {
 	struct mutex sec_mutex;
 	struct delayed_work dwork;
 	unsigned int overwrite_tmo;
+	struct kernfs_node *overwrite_state;
 };
 
 /**
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 725acd211114..f5ba633545b7 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -122,6 +122,8 @@ void nvdimm_overwrite_query(struct work_struct *work)
 	else
 		dev_info(&nvdimm->dev, "Overwrite completed\n");
 
+	if (nvdimm->overwrite_state)
+		sysfs_notify_dirent(nvdimm->overwrite_state);
 	nvdimm->overwrite_tmo = 0;
 	nvdimm_clear_security_busy(nvdimm);
 	nvdimm_security_get_state(nvdimm);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 479421ce62c0..c3c5a1c6b1b7 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -227,6 +227,7 @@ static inline struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 			cmd_mask, num_flush, flush_wpq, NULL, NULL);
 }
 
+int nvdimm_setup_security_events(struct nvdimm *nvdimm);
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
 u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
