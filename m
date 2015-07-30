Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 09/24] i915: switch from acpi_os_ioremap to memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Jul 2015 12:54:28 -0400
Message-ID: <20150730165428.33962.30409.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>, mcgrof@suse.com, dri-devel@lists.freedesktop.org, rmk+kernel@arm.linux.org.uk, Daniel Vetter <daniel.vetter@intel.com>, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

i915 expects the OpRegion to be cached (i.e. not __iomem), so explicitly
map it with memremap rather than the implied cache setting of
acpi_os_ioremap().

Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/gpu/drm/i915/i915_debugfs.c   |    2 -
 drivers/gpu/drm/i915/i915_drv.h       |   12 ++---
 drivers/gpu/drm/i915/intel_bios.c     |    7 +--
 drivers/gpu/drm/i915/intel_opregion.c |   87 ++++++++++++++++-----------------
 drivers/gpu/drm/i915/intel_panel.c    |    2 -
 5 files changed, 52 insertions(+), 58 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 82bbe3f2a7e1..9228d6048bde 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -1831,7 +1831,7 @@ static int i915_opregion(struct seq_file *m, void *unused)
 		goto out;
 
 	if (opregion->header) {
-		memcpy_fromio(data, opregion->header, OPREGION_SIZE);
+		memcpy(data, opregion->header, OPREGION_SIZE);
 		seq_write(m, data, OPREGION_SIZE);
 	}
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 5f27290201e0..2efbfd53be51 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -403,14 +403,14 @@ struct opregion_swsci;
 struct opregion_asle;
 
 struct intel_opregion {
-	struct opregion_header __iomem *header;
-	struct opregion_acpi __iomem *acpi;
-	struct opregion_swsci __iomem *swsci;
+	struct opregion_header *header;
+	struct opregion_acpi *acpi;
+	struct opregion_swsci *swsci;
 	u32 swsci_gbda_sub_functions;
 	u32 swsci_sbcb_sub_functions;
-	struct opregion_asle __iomem *asle;
-	void __iomem *vbt;
-	u32 __iomem *lid_state;
+	struct opregion_asle *asle;
+	void *vbt;
+	u32 *lid_state;
 	struct work_struct asle_work;
 };
 #define OPREGION_SIZE            (8*1024)
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index 198fc3c3291b..3e2dca4f5e6e 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -1206,11 +1206,10 @@ static const struct bdb_header *validate_vbt(const void __iomem *_base,
 {
 	/*
 	 * This is the one place where we explicitly discard the address space
-	 * (__iomem) of the BIOS/VBT. (And this will cause a sparse complaint.)
-	 * From now on everything is based on 'base', and treated as regular
-	 * memory.
+	 * (__iomem) of the BIOS/VBT. From now on everything is based on
+	 * 'base', and treated as regular memory.
 	 */
-	const void *base = (const void *) _base;
+	const void *base = (const void __force *) _base;
 	size_t offset = _vbt - _base;
 	const struct vbt_header *vbt = base + offset;
 	const struct bdb_header *bdb;
diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index 481337436f72..7deed1062871 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -232,7 +232,7 @@ struct opregion_asle {
 static int swsci(struct drm_device *dev, u32 function, u32 parm, u32 *parm_out)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct opregion_swsci __iomem *swsci = dev_priv->opregion.swsci;
+	struct opregion_swsci *swsci = dev_priv->opregion.swsci;
 	u32 main_function, sub_function, scic;
 	u16 pci_swsci;
 	u32 dslp;
@@ -257,7 +257,7 @@ static int swsci(struct drm_device *dev, u32 function, u32 parm, u32 *parm_out)
 	}
 
 	/* Driver sleep timeout in ms. */
-	dslp = ioread32(&swsci->dslp);
+	dslp = swsci->dslp;
 	if (!dslp) {
 		/* The spec says 2ms should be the default, but it's too small
 		 * for some machines. */
@@ -270,7 +270,7 @@ static int swsci(struct drm_device *dev, u32 function, u32 parm, u32 *parm_out)
 	}
 
 	/* The spec tells us to do this, but we are the only user... */
-	scic = ioread32(&swsci->scic);
+	scic = swsci->scic;
 	if (scic & SWSCI_SCIC_INDICATOR) {
 		DRM_DEBUG_DRIVER("SWSCI request already in progress\n");
 		return -EBUSY;
@@ -278,8 +278,8 @@ static int swsci(struct drm_device *dev, u32 function, u32 parm, u32 *parm_out)
 
 	scic = function | SWSCI_SCIC_INDICATOR;
 
-	iowrite32(parm, &swsci->parm);
-	iowrite32(scic, &swsci->scic);
+	swsci->parm = parm;
+	swsci->scic = scic;
 
 	/* Ensure SCI event is selected and event trigger is cleared. */
 	pci_read_config_word(dev->pdev, PCI_SWSCI, &pci_swsci);
@@ -294,7 +294,7 @@ static int swsci(struct drm_device *dev, u32 function, u32 parm, u32 *parm_out)
 	pci_write_config_word(dev->pdev, PCI_SWSCI, pci_swsci);
 
 	/* Poll for the result. */
-#define C (((scic = ioread32(&swsci->scic)) & SWSCI_SCIC_INDICATOR) == 0)
+#define C (((scic = swsci->scic) & SWSCI_SCIC_INDICATOR) == 0)
 	if (wait_for(C, dslp)) {
 		DRM_DEBUG_DRIVER("SWSCI request timed out\n");
 		return -ETIMEDOUT;
@@ -310,7 +310,7 @@ static int swsci(struct drm_device *dev, u32 function, u32 parm, u32 *parm_out)
 	}
 
 	if (parm_out)
-		*parm_out = ioread32(&swsci->parm);
+		*parm_out = swsci->parm;
 
 	return 0;
 
@@ -400,7 +400,7 @@ static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_connector *intel_connector;
-	struct opregion_asle __iomem *asle = dev_priv->opregion.asle;
+	struct opregion_asle *asle = dev_priv->opregion.asle;
 
 	DRM_DEBUG_DRIVER("bclp = 0x%08x\n", bclp);
 
@@ -425,7 +425,7 @@ static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
 	DRM_DEBUG_KMS("updating opregion backlight %d/255\n", bclp);
 	list_for_each_entry(intel_connector, &dev->mode_config.connector_list, base.head)
 		intel_panel_set_backlight_acpi(intel_connector, bclp, 255);
-	iowrite32(DIV_ROUND_UP(bclp * 100, 255) | ASLE_CBLV_VALID, &asle->cblv);
+	asle->cblv = DIV_ROUND_UP(bclp * 100, 255) | ASLE_CBLV_VALID;
 
 	drm_modeset_unlock(&dev->mode_config.connection_mutex);
 
@@ -512,14 +512,14 @@ static void asle_work(struct work_struct *work)
 	struct drm_i915_private *dev_priv =
 		container_of(opregion, struct drm_i915_private, opregion);
 	struct drm_device *dev = dev_priv->dev;
-	struct opregion_asle __iomem *asle = dev_priv->opregion.asle;
+	struct opregion_asle *asle = dev_priv->opregion.asle;
 	u32 aslc_stat = 0;
 	u32 aslc_req;
 
 	if (!asle)
 		return;
 
-	aslc_req = ioread32(&asle->aslc);
+	aslc_req = asle->aslc;
 
 	if (!(aslc_req & ASLC_REQ_MSK)) {
 		DRM_DEBUG_DRIVER("No request on ASLC interrupt 0x%08x\n",
@@ -528,34 +528,34 @@ static void asle_work(struct work_struct *work)
 	}
 
 	if (aslc_req & ASLC_SET_ALS_ILLUM)
-		aslc_stat |= asle_set_als_illum(dev, ioread32(&asle->alsi));
+		aslc_stat |= asle_set_als_illum(dev, asle->alsi);
 
 	if (aslc_req & ASLC_SET_BACKLIGHT)
-		aslc_stat |= asle_set_backlight(dev, ioread32(&asle->bclp));
+		aslc_stat |= asle_set_backlight(dev, asle->bclp);
 
 	if (aslc_req & ASLC_SET_PFIT)
-		aslc_stat |= asle_set_pfit(dev, ioread32(&asle->pfit));
+		aslc_stat |= asle_set_pfit(dev, asle->pfit);
 
 	if (aslc_req & ASLC_SET_PWM_FREQ)
-		aslc_stat |= asle_set_pwm_freq(dev, ioread32(&asle->pfmb));
+		aslc_stat |= asle_set_pwm_freq(dev, asle->pfmb);
 
 	if (aslc_req & ASLC_SUPPORTED_ROTATION_ANGLES)
 		aslc_stat |= asle_set_supported_rotation_angles(dev,
-							ioread32(&asle->srot));
+							asle->srot);
 
 	if (aslc_req & ASLC_BUTTON_ARRAY)
-		aslc_stat |= asle_set_button_array(dev, ioread32(&asle->iuer));
+		aslc_stat |= asle_set_button_array(dev, asle->iuer);
 
 	if (aslc_req & ASLC_CONVERTIBLE_INDICATOR)
-		aslc_stat |= asle_set_convertible(dev, ioread32(&asle->iuer));
+		aslc_stat |= asle_set_convertible(dev, asle->iuer);
 
 	if (aslc_req & ASLC_DOCKING_INDICATOR)
-		aslc_stat |= asle_set_docking(dev, ioread32(&asle->iuer));
+		aslc_stat |= asle_set_docking(dev, asle->iuer);
 
 	if (aslc_req & ASLC_ISCT_STATE_CHANGE)
 		aslc_stat |= asle_isct_state(dev);
 
-	iowrite32(aslc_stat, &asle->aslc);
+	asle->aslc = aslc_stat;
 }
 
 void intel_opregion_asle_intr(struct drm_device *dev)
@@ -580,8 +580,8 @@ static int intel_opregion_video_event(struct notifier_block *nb,
 	   Linux, these are handled by the dock, button and video drivers.
 	*/
 
-	struct opregion_acpi __iomem *acpi;
 	struct acpi_bus_event *event = data;
+	struct opregion_acpi *acpi;
 	int ret = NOTIFY_OK;
 
 	if (strcmp(event->device_class, ACPI_VIDEO_CLASS) != 0)
@@ -592,11 +592,10 @@ static int intel_opregion_video_event(struct notifier_block *nb,
 
 	acpi = system_opregion->acpi;
 
-	if (event->type == 0x80 &&
-	    (ioread32(&acpi->cevt) & 1) == 0)
+	if (event->type == 0x80 && ((acpi->cevt & 1) == 0))
 		ret = NOTIFY_BAD;
 
-	iowrite32(0, &acpi->csts);
+	acpi->csts = 0;
 
 	return ret;
 }
@@ -620,7 +619,6 @@ static void intel_didl_outputs(struct drm_device *dev)
 	struct acpi_device *acpi_dev, *acpi_cdev, *acpi_video_bus = NULL;
 	unsigned long long device_id;
 	acpi_status status;
-	u32 temp;
 	int i = 0;
 
 	handle = ACPI_HANDLE(&dev->pdev->dev);
@@ -655,8 +653,7 @@ static void intel_didl_outputs(struct drm_device *dev)
 		if (ACPI_SUCCESS(status)) {
 			if (!device_id)
 				goto blind_set;
-			iowrite32((u32)(device_id & 0x0f0f),
-				  &opregion->acpi->didl[i]);
+			opregion->acpi->didl[i] = device_id & 0x0f0f;
 			i++;
 		}
 	}
@@ -664,7 +661,7 @@ static void intel_didl_outputs(struct drm_device *dev)
 end:
 	/* If fewer than 8 outputs, the list must be null terminated */
 	if (i < 8)
-		iowrite32(0, &opregion->acpi->didl[i]);
+		opregion->acpi->didl[i] = 0;
 	return;
 
 blind_set:
@@ -698,9 +695,7 @@ blind_set:
 			output_type = ACPI_LVDS_OUTPUT;
 			break;
 		}
-		temp = ioread32(&opregion->acpi->didl[i]);
-		iowrite32(temp | (1<<31) | output_type | i,
-			  &opregion->acpi->didl[i]);
+		opregion->acpi->didl[i] |= (1<<31) | output_type | i;
 		i++;
 	}
 	goto end;
@@ -720,8 +715,8 @@ static void intel_setup_cadls(struct drm_device *dev)
 	 * display switching hotkeys. Just like DIDL, CADL is NULL-terminated if
 	 * there are less than eight devices. */
 	do {
-		disp_id = ioread32(&opregion->acpi->didl[i]);
-		iowrite32(disp_id, &opregion->acpi->cadl[i]);
+		disp_id = opregion->acpi->didl[i];
+		opregion->acpi->cadl[i] = disp_id;
 	} while (++i < 8 && disp_id != 0);
 }
 
@@ -740,16 +735,16 @@ void intel_opregion_init(struct drm_device *dev)
 		/* Notify BIOS we are ready to handle ACPI video ext notifs.
 		 * Right now, all the events are handled by the ACPI video module.
 		 * We don't actually need to do anything with them. */
-		iowrite32(0, &opregion->acpi->csts);
-		iowrite32(1, &opregion->acpi->drdy);
+		opregion->acpi->csts = 0;
+		opregion->acpi->drdy = 1;
 
 		system_opregion = opregion;
 		register_acpi_notifier(&intel_opregion_notifier);
 	}
 
 	if (opregion->asle) {
-		iowrite32(ASLE_TCHE_BLC_EN, &opregion->asle->tche);
-		iowrite32(ASLE_ARDY_READY, &opregion->asle->ardy);
+		opregion->asle->tche = ASLE_TCHE_BLC_EN;
+		opregion->asle->ardy = ASLE_ARDY_READY;
 	}
 }
 
@@ -762,19 +757,19 @@ void intel_opregion_fini(struct drm_device *dev)
 		return;
 
 	if (opregion->asle)
-		iowrite32(ASLE_ARDY_NOT_READY, &opregion->asle->ardy);
+		opregion->asle->ardy = ASLE_ARDY_NOT_READY;
 
 	cancel_work_sync(&dev_priv->opregion.asle_work);
 
 	if (opregion->acpi) {
-		iowrite32(0, &opregion->acpi->drdy);
+		opregion->acpi->drdy = 0;
 
 		system_opregion = NULL;
 		unregister_acpi_notifier(&intel_opregion_notifier);
 	}
 
 	/* just clear all opregion memory pointers now */
-	iounmap(opregion->header);
+	memunmap(opregion->header);
 	opregion->header = NULL;
 	opregion->acpi = NULL;
 	opregion->swsci = NULL;
@@ -847,10 +842,10 @@ int intel_opregion_setup(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_opregion *opregion = &dev_priv->opregion;
-	void __iomem *base;
 	u32 asls, mboxes;
 	char buf[sizeof(OPREGION_SIGNATURE)];
 	int err = 0;
+	void *base;
 
 	pci_read_config_dword(dev->pdev, PCI_ASLS, &asls);
 	DRM_DEBUG_DRIVER("graphic opregion physical addr: 0x%x\n", asls);
@@ -863,11 +858,11 @@ int intel_opregion_setup(struct drm_device *dev)
 	INIT_WORK(&opregion->asle_work, asle_work);
 #endif
 
-	base = acpi_os_ioremap(asls, OPREGION_SIZE);
+	base = memremap(asls, OPREGION_SIZE, MEMREMAP_WB);
 	if (!base)
 		return -ENOMEM;
 
-	memcpy_fromio(buf, base, sizeof(buf));
+	memcpy(buf, base, sizeof(buf));
 
 	if (memcmp(buf, OPREGION_SIGNATURE, 16)) {
 		DRM_DEBUG_DRIVER("opregion signature mismatch\n");
@@ -879,7 +874,7 @@ int intel_opregion_setup(struct drm_device *dev)
 
 	opregion->lid_state = base + ACPI_CLID;
 
-	mboxes = ioread32(&opregion->header->mboxes);
+	mboxes = opregion->header->mboxes;
 	if (mboxes & MBOX_ACPI) {
 		DRM_DEBUG_DRIVER("Public ACPI methods supported\n");
 		opregion->acpi = base + OPREGION_ACPI_OFFSET;
@@ -894,12 +889,12 @@ int intel_opregion_setup(struct drm_device *dev)
 		DRM_DEBUG_DRIVER("ASLE supported\n");
 		opregion->asle = base + OPREGION_ASLE_OFFSET;
 
-		iowrite32(ASLE_ARDY_NOT_READY, &opregion->asle->ardy);
+		opregion->asle->ardy = ASLE_ARDY_NOT_READY;
 	}
 
 	return 0;
 
 err_out:
-	iounmap(base);
+	memunmap(base);
 	return err;
 }
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 55aad2322e10..3985396e46a2 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -384,7 +384,7 @@ intel_panel_detect(struct drm_device *dev)
 
 	/* Assume that the BIOS does not lie through the OpRegion... */
 	if (!i915.panel_ignore_lid && dev_priv->opregion.lid_state) {
-		return ioread32(dev_priv->opregion.lid_state) & 0x1 ?
+		return *(dev_priv->opregion.lid_state) & 0x1 ?
 			connector_status_connected :
 			connector_status_disconnected;
 	}

