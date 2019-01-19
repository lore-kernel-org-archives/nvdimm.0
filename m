Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5887921962301
 for <linux-nvdimm@lists.01.org>; Sat, 19 Jan 2019 10:10:57 -0800 (PST)
Subject: [PATCH] libnvdimm/security: Require nvdimm_security_setup_events()
 to succeed
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 19 Jan 2019 09:58:20 -0800
Message-ID: <154792070048.2307301.10850114897455981881.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The following warning:

    ACPI0012:00: security event setup failed: -19

...is meant to capture exceptional failures of sysfs_get_dirent(),
however it will also fail in the common case when security support is
disabled. A few issues:

1/ A dev_warn() report for a common case is too chatty
2/ The setup of this notifier is generic, no need for it to be driven
   from the nfit driver, it can exist completely in the core.
3/ If it fails for any reason besides security support being disabled,
   that's fatal and should abort DIMM activation. Userspace may hang if
   it never gets overwrite notifications.
4/ The dirent needs to be released.

Move the call to the core 'dimm' driver, make it conditional on security
support being active, make it fatal for the exceptional case, add the
missing sysfs_put() at device disable time.

Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c   |    5 -----
 drivers/nvdimm/dimm.c      |    6 ++++++
 drivers/nvdimm/dimm_devs.c |   22 +++++++++++++++++-----
 drivers/nvdimm/nd.h        |    1 +
 include/linux/libnvdimm.h  |    1 -
 5 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 9c95b82e5e5d..c38c914d8a58 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2073,11 +2073,6 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		if (!nvdimm)
 			continue;
 
-		rc = nvdimm_security_setup_events(nvdimm);
-		if (rc < 0)
-			dev_warn(acpi_desc->dev,
-				"security event setup failed: %d\n", rc);
-
 		nfit_kernfs = sysfs_get_dirent(nvdimm_kobj(nvdimm)->sd, "nfit");
 		if (nfit_kernfs)
 			nfit_mem->flags_attr = sysfs_get_dirent(nfit_kernfs,
diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 0cf58cabc9ed..3cf50274fadb 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -26,6 +26,12 @@ static int nvdimm_probe(struct device *dev)
 	struct nvdimm_drvdata *ndd;
 	int rc;
 
+	rc = nvdimm_security_setup_events(dev);
+	if (rc < 0) {
+		dev_err(dev, "security event setup failed: %d\n", rc);
+		return rc;
+	}
+
 	rc = nvdimm_check_config_data(dev);
 	if (rc) {
 		/* not required for non-aliased nvdimm, ex. NVDIMM-N */
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 4890310df874..efe412a6b5b9 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -578,13 +578,25 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 }
 EXPORT_SYMBOL_GPL(__nvdimm_create);
 
-int nvdimm_security_setup_events(struct nvdimm *nvdimm)
+static void shutdown_security_notify(void *data)
 {
-	nvdimm->sec.overwrite_state = sysfs_get_dirent(nvdimm->dev.kobj.sd,
-			"security");
+	struct nvdimm *nvdimm = data;
+
+	sysfs_put(nvdimm->sec.overwrite_state);
+}
+
+int nvdimm_security_setup_events(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	if (nvdimm->sec.state < 0 || !nvdimm->sec.ops
+			|| !nvdimm->sec.ops->overwrite)
+		return 0;
+	nvdimm->sec.overwrite_state = sysfs_get_dirent(dev->kobj.sd, "security");
 	if (!nvdimm->sec.overwrite_state)
-		return -ENODEV;
-	return 0;
+		return -ENOMEM;
+
+	return devm_add_action_or_reset(dev, shutdown_security_notify, nvdimm);
 }
 EXPORT_SYMBOL_GPL(nvdimm_security_setup_events);
 
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index cfde992684e7..379bf4305e61 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -250,6 +250,7 @@ long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 void nvdimm_set_aliasing(struct device *dev);
 void nvdimm_set_locked(struct device *dev);
 void nvdimm_clear_locked(struct device *dev);
+int nvdimm_security_setup_events(struct device *dev);
 #if IS_ENABLED(CONFIG_NVDIMM_KEYS)
 int nvdimm_security_unlock(struct device *dev);
 #else
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 7315977b64da..ad609617aeb8 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -235,7 +235,6 @@ static inline struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 			cmd_mask, num_flush, flush_wpq, NULL, NULL);
 }
 
-int nvdimm_security_setup_events(struct nvdimm *nvdimm);
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
 u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
