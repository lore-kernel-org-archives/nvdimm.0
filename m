Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 08/24] gma500: switch from acpi_os_ioremap to memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Jul 2015 12:54:23 -0400
Message-ID: <20150730165423.33962.91402.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, David Airlie <airlied@linux.ie>, mcgrof@suse.com, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

gma500 expects the OpRegion to be cached (i.e. not __iomem), so
explicitly map it with memremap rather than the implied cache setting of
acpi_os_ioremap().

Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/gpu/drm/gma500/opregion.c |    8 ++++----
 drivers/gpu/drm/gma500/psb_drv.h  |    2 +-
 drivers/gpu/drm/gma500/psb_lid.c  |    8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/gma500/opregion.c b/drivers/gpu/drm/gma500/opregion.c
index ab696ca7eeec..7672ac4d4217 100644
--- a/drivers/gpu/drm/gma500/opregion.c
+++ b/drivers/gpu/drm/gma500/opregion.c
@@ -297,7 +297,7 @@ void psb_intel_opregion_fini(struct drm_device *dev)
 	cancel_work_sync(&opregion->asle_work);
 
 	/* just clear all opregion memory pointers now */
-	iounmap(opregion->header);
+	memunmap(opregion->header);
 	opregion->header = NULL;
 	opregion->acpi = NULL;
 	opregion->swsci = NULL;
@@ -310,8 +310,8 @@ int psb_intel_opregion_setup(struct drm_device *dev)
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct psb_intel_opregion *opregion = &dev_priv->opregion;
 	u32 opregion_phy, mboxes;
-	void __iomem *base;
 	int err = 0;
+	void *base;
 
 	pci_read_config_dword(dev->pdev, PCI_ASLS, &opregion_phy);
 	if (opregion_phy == 0) {
@@ -322,7 +322,7 @@ int psb_intel_opregion_setup(struct drm_device *dev)
 	INIT_WORK(&opregion->asle_work, psb_intel_opregion_asle_work);
 
 	DRM_DEBUG("OpRegion detected at 0x%8x\n", opregion_phy);
-	base = acpi_os_ioremap(opregion_phy, 8*1024);
+	base = memremap(opregion_phy, 8*1024, MEMREMAP_WB);
 	if (!base)
 		return -ENOMEM;
 
@@ -351,7 +351,7 @@ int psb_intel_opregion_setup(struct drm_device *dev)
 	return 0;
 
 err_out:
-	iounmap(base);
+	memunmap(base);
 	return err;
 }
 
diff --git a/drivers/gpu/drm/gma500/psb_drv.h b/drivers/gpu/drm/gma500/psb_drv.h
index e38057b91865..189f57135d47 100644
--- a/drivers/gpu/drm/gma500/psb_drv.h
+++ b/drivers/gpu/drm/gma500/psb_drv.h
@@ -253,7 +253,7 @@ struct psb_intel_opregion {
 	struct opregion_swsci *swsci;
 	struct opregion_asle *asle;
 	void *vbt;
-	u32 __iomem *lid_state;
+	u32 *lid_state;
 	struct work_struct asle_work;
 };
 
diff --git a/drivers/gpu/drm/gma500/psb_lid.c b/drivers/gpu/drm/gma500/psb_lid.c
index 1d2ebb5e530f..6b1b9d0741df 100644
--- a/drivers/gpu/drm/gma500/psb_lid.c
+++ b/drivers/gpu/drm/gma500/psb_lid.c
@@ -28,14 +28,14 @@ static void psb_lid_timer_func(unsigned long data)
 	struct drm_psb_private * dev_priv = (struct drm_psb_private *)data;
 	struct drm_device *dev = (struct drm_device *)dev_priv->dev;
 	struct timer_list *lid_timer = &dev_priv->lid_timer;
+	u32 *lid_state = dev_priv->opregion.lid_state;
 	unsigned long irq_flags;
-	u32 __iomem *lid_state = dev_priv->opregion.lid_state;
 	u32 pp_status;
 
-	if (readl(lid_state) == dev_priv->lid_last_state)
+	if (*lid_state == dev_priv->lid_last_state)
 		goto lid_timer_schedule;
 
-	if ((readl(lid_state)) & 0x01) {
+	if ((*lid_state) & 0x01) {
 		/*lid state is open*/
 		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) | POWER_TARGET_ON);
 		do {
@@ -58,7 +58,7 @@ static void psb_lid_timer_func(unsigned long data)
 			pp_status = REG_READ(PP_STATUS);
 		} while ((pp_status & PP_ON) == 0);
 	}
-	dev_priv->lid_last_state =  readl(lid_state);
+	dev_priv->lid_last_state =  *lid_state;
 
 lid_timer_schedule:
 	spin_lock_irqsave(&dev_priv->lid_lock, irq_flags);

