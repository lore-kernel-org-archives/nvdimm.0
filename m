Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CC919C
	for <nvdimm@lists.linux.dev>; Sat, 26 Nov 2022 00:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669423750; x=1700959750;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=am1NKaz4UpuzCHhhA4tMO6LHAJLavpT7o5EqFmy2ZqY=;
  b=W3G4YAURjHSstfmjfAqH0EAWhn0WwEeKL+6mI6X8h227jM7JNuoxbb3T
   cOAcdBqC67f/n+QEzZ2ItMXwm2cauowgcJk1GVVg/MeadvLuPQB9xCsGO
   b+We2hDPH6WPl74tP/AuY0HMU4zlaHQbwB4a8cpdTNPbNDDMoTqeaTk8p
   F8HUdg+rYLPnYQVukj2zg0D/CFAAToqJkVSwjnsz4sro3jVn+w5mMsNlw
   hu0H+WawytxrxRpSgZLI7uSLrCM3aSQr4DcxTLlaJJ7y9HAorWwIbocBG
   Q+6s4xbjKxbW8t6/gnWnN+bStq40qELTnRAnfrOeRu0CkH0PyOby9o2Z/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="400845073"
X-IronPort-AV: E=Sophos;i="5.96,194,1665471600"; 
   d="scan'208";a="400845073"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 16:49:10 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="817261744"
X-IronPort-AV: E=Sophos;i="5.96,194,1665471600"; 
   d="scan'208";a="817261744"
Received: from aroy3-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.146.179])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 16:49:08 -0800
Subject: [PATCH v5 03/12] cxl/pmem: Refactor nvdimm device registration,
 delete the workqueue
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: rrichter@amd.com, terry.bowman@amd.com, bhelgaas@google.com,
 dave.jiang@intel.com, nvdimm@lists.linux.dev, Jonathan.Cameron@huawei.com
Date: Fri, 25 Nov 2022 16:49:08 -0800
Message-ID: <166942374038.2372574.7499932496181935080.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166931489283.2104015.7355891921648975475.stgit@dwillia2-xfh.jf.intel.com>
References: <166931489283.2104015.7355891921648975475.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The three objects 'struct cxl_nvdimm_bridge', 'struct cxl_nvdimm', and
'struct cxl_pmem_region' manage CXL persistent memory resources. The
bridge represents base platform resources, the nvdimm represents one or
more endpoints, and the region is a collection of nvdimms that
contribute to an assembled address range.

Their relationship is such that a region is torn down if any component
endpoints are removed. All regions and endpoints are torn down if the
foundational bridge device goes down.

A workqueue was deployed to manage these interdependencies, but it is
difficult to reason about, and fragile. A recent attempt to take the CXL
root device lock in the cxl_mem driver was reported by lockdep as
colliding with the flush_work() in the cxl_pmem flows.

Instead of the workqueue, arrange for all pmem/nvdimm devices to be torn
down immediately and hierarchically. A similar change is made to both
the 'cxl_nvdimm' and 'cxl_pmem_region' objects. For bisect-ability both
changes are made in the same patch which unfortunately makes the patch
bigger than desired.

Arrange for cxl_memdev and cxl_region to register a cxl_nvdimm and
cxl_pmem_region as a devres release action of the bridge device.
Additionally, include a devres release action of the cxl_memdev or
cxl_region device that triggers the bridge's release action if an endpoint
exits before the bridge. I.e. this allows either unplugging the bridge,
or unplugging and endpoint to result in the same cleanup actions.

To keep the patch smaller the cleanup of the now defunct workqueue
infrastructure is saved for a follow-on patch.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v4 from Jonathan's feedback:
- Clarify cxl_nvd_unregister()
- Cosmetic and error exit ordering fixups in devm_cxl_add_nvdimm()
  (Jonathan)
- Clarify devm release action comment in devm_cxl_add_nvdimm()
- Clarify that each region member shares the same nvdimm-bridge
- Add similar clarifications to cxlr_pmem_unregister() as
  cxl_nvd_unregister()
- Clarify what the @cxl_nvb attribute of a cxl_region is used for
- Whitespace fixups

 drivers/cxl/core/pmem.c      |   78 +++++++++++++++++++++++----
 drivers/cxl/core/region.c    |   64 +++++++++++++++++++++-
 drivers/cxl/cxl.h            |    7 ++
 drivers/cxl/cxlmem.h         |    4 +
 drivers/cxl/mem.c            |    9 +++
 drivers/cxl/pci.c            |    3 -
 drivers/cxl/pmem.c           |  121 ++++++++++++------------------------------
 tools/testing/cxl/test/mem.c |    3 -
 8 files changed, 181 insertions(+), 108 deletions(-)

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index 1d12a8206444..4d36805079ad 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -219,7 +219,8 @@ EXPORT_SYMBOL_NS_GPL(to_cxl_nvdimm, CXL);
 
 static struct lock_class_key cxl_nvdimm_key;
 
-static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
+static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_nvdimm_bridge *cxl_nvb,
+					   struct cxl_memdev *cxlmd)
 {
 	struct cxl_nvdimm *cxl_nvd;
 	struct device *dev;
@@ -230,6 +231,7 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
 
 	dev = &cxl_nvd->dev;
 	cxl_nvd->cxlmd = cxlmd;
+	cxlmd->cxl_nvd = cxl_nvd;
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &cxl_nvdimm_key);
 	device_set_pm_not_required(dev);
@@ -240,27 +242,60 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
 	return cxl_nvd;
 }
 
-static void cxl_nvd_unregister(void *dev)
+static void cxl_nvd_unregister(void *_cxl_nvd)
 {
-	device_unregister(dev);
+	struct cxl_nvdimm *cxl_nvd = _cxl_nvd;
+	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
+	struct cxl_nvdimm_bridge *cxl_nvb = cxlmd->cxl_nvb;
+
+	/*
+	 * Either the bridge is in ->remove() context under the device_lock(),
+	 * or cxlmd_release_nvdimm() is cancelling the bridge's release action
+	 * for @cxl_nvd and doing it itself (while manually holding the bridge
+	 * lock).
+	 */
+	device_lock_assert(&cxl_nvb->dev);
+	cxl_nvd->cxlmd = NULL;
+	cxlmd->cxl_nvd = NULL;
+	device_unregister(&cxl_nvd->dev);
+}
+
+static void cxlmd_release_nvdimm(void *_cxlmd)
+{
+	struct cxl_memdev *cxlmd = _cxlmd;
+	struct cxl_nvdimm_bridge *cxl_nvb = cxlmd->cxl_nvb;
+
+	device_lock(&cxl_nvb->dev);
+	if (cxlmd->cxl_nvd)
+		devm_release_action(&cxl_nvb->dev, cxl_nvd_unregister,
+				    cxlmd->cxl_nvd);
+	device_unlock(&cxl_nvb->dev);
+	put_device(&cxl_nvb->dev);
 }
 
 /**
  * devm_cxl_add_nvdimm() - add a bridge between a cxl_memdev and an nvdimm
- * @host: same host as @cxlmd
  * @cxlmd: cxl_memdev instance that will perform LIBNVDIMM operations
  *
  * Return: 0 on success negative error code on failure.
  */
-int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd)
+int devm_cxl_add_nvdimm(struct cxl_memdev *cxlmd)
 {
+	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct cxl_nvdimm *cxl_nvd;
 	struct device *dev;
 	int rc;
 
-	cxl_nvd = cxl_nvdimm_alloc(cxlmd);
-	if (IS_ERR(cxl_nvd))
-		return PTR_ERR(cxl_nvd);
+	cxl_nvb = cxl_find_nvdimm_bridge(&cxlmd->dev);
+	if (!cxl_nvb)
+		return -ENODEV;
+
+	cxl_nvd = cxl_nvdimm_alloc(cxl_nvb, cxlmd);
+	if (IS_ERR(cxl_nvd)) {
+		rc = PTR_ERR(cxl_nvd);
+		goto err_alloc;
+	}
+	cxlmd->cxl_nvb = cxl_nvb;
 
 	dev = &cxl_nvd->dev;
 	rc = dev_set_name(dev, "pmem%d", cxlmd->id);
@@ -271,13 +306,34 @@ int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd)
 	if (rc)
 		goto err;
 
-	dev_dbg(host, "%s: register %s\n", dev_name(dev->parent),
-		dev_name(dev));
+	dev_dbg(&cxlmd->dev, "register %s\n", dev_name(dev));
+
+	/*
+	 * The two actions below arrange for @cxl_nvd to be deleted when either
+	 * the top-level PMEM bridge goes down, or the endpoint device goes
+	 * through ->remove().
+	 */
+	device_lock(&cxl_nvb->dev);
+	if (cxl_nvb->dev.driver)
+		rc = devm_add_action_or_reset(&cxl_nvb->dev, cxl_nvd_unregister,
+					      cxl_nvd);
+	else
+		rc = -ENXIO;
+	device_unlock(&cxl_nvb->dev);
+
+	if (rc)
+		goto err_alloc;
 
-	return devm_add_action_or_reset(host, cxl_nvd_unregister, dev);
+	/* @cxlmd carries a reference on @cxl_nvb until cxlmd_release_nvdimm */
+	return devm_add_action_or_reset(&cxlmd->dev, cxlmd_release_nvdimm, cxlmd);
 
 err:
 	put_device(dev);
+err_alloc:
+	cxlmd->cxl_nvb = NULL;
+	cxlmd->cxl_nvd = NULL;
+	put_device(&cxl_nvb->dev);
+
 	return rc;
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_add_nvdimm, CXL);
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index f9ae5ad284ff..1e61d1bafc0c 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1812,6 +1812,7 @@ static struct lock_class_key cxl_pmem_region_key;
 static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
 {
 	struct cxl_region_params *p = &cxlr->params;
+	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct cxl_pmem_region *cxlr_pmem;
 	struct device *dev;
 	int i;
@@ -1839,6 +1840,18 @@ static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
 		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
 		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
 
+		/*
+		 * Regions never span CXL root devices, so by definition the
+		 * bridge for one device is the same for all.
+		 */
+		if (i == 0) {
+			cxl_nvb = cxl_find_nvdimm_bridge(&cxlmd->dev);
+			if (!cxl_nvb) {
+				cxlr_pmem = ERR_PTR(-ENODEV);
+				goto out;
+			}
+			cxlr->cxl_nvb = cxl_nvb;
+		}
 		m->cxlmd = cxlmd;
 		get_device(&cxlmd->dev);
 		m->start = cxled->dpa_res->start;
@@ -1848,6 +1861,7 @@ static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
 
 	dev = &cxlr_pmem->dev;
 	cxlr_pmem->cxlr = cxlr;
+	cxlr->cxlr_pmem = cxlr_pmem;
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &cxl_pmem_region_key);
 	device_set_pm_not_required(dev);
@@ -1860,9 +1874,36 @@ static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
 	return cxlr_pmem;
 }
 
-static void cxlr_pmem_unregister(void *dev)
+static void cxlr_pmem_unregister(void *_cxlr_pmem)
 {
-	device_unregister(dev);
+	struct cxl_pmem_region *cxlr_pmem = _cxlr_pmem;
+	struct cxl_region *cxlr = cxlr_pmem->cxlr;
+	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
+
+	/*
+	 * Either the bridge is in ->remove() context under the device_lock(),
+	 * or cxlr_release_nvdimm() is cancelling the bridge's release action
+	 * for @cxlr_pmem and doing it itself (while manually holding the bridge
+	 * lock).
+	 */
+	device_lock_assert(&cxl_nvb->dev);
+	cxlr->cxlr_pmem = NULL;
+	cxlr_pmem->cxlr = NULL;
+	device_unregister(&cxlr_pmem->dev);
+}
+
+static void cxlr_release_nvdimm(void *_cxlr)
+{
+	struct cxl_region *cxlr = _cxlr;
+	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
+
+	device_lock(&cxl_nvb->dev);
+	if (cxlr->cxlr_pmem)
+		devm_release_action(&cxl_nvb->dev, cxlr_pmem_unregister,
+				    cxlr->cxlr_pmem);
+	device_unlock(&cxl_nvb->dev);
+	cxlr->cxl_nvb = NULL;
+	put_device(&cxl_nvb->dev);
 }
 
 /**
@@ -1874,12 +1915,14 @@ static void cxlr_pmem_unregister(void *dev)
 static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
 {
 	struct cxl_pmem_region *cxlr_pmem;
+	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct device *dev;
 	int rc;
 
 	cxlr_pmem = cxl_pmem_region_alloc(cxlr);
 	if (IS_ERR(cxlr_pmem))
 		return PTR_ERR(cxlr_pmem);
+	cxl_nvb = cxlr->cxl_nvb;
 
 	dev = &cxlr_pmem->dev;
 	rc = dev_set_name(dev, "pmem_region%d", cxlr->id);
@@ -1893,10 +1936,25 @@ static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
 	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
 		dev_name(dev));
 
-	return devm_add_action_or_reset(&cxlr->dev, cxlr_pmem_unregister, dev);
+	device_lock(&cxl_nvb->dev);
+	if (cxl_nvb->dev.driver)
+		rc = devm_add_action_or_reset(&cxl_nvb->dev,
+					      cxlr_pmem_unregister, cxlr_pmem);
+	else
+		rc = -ENXIO;
+	device_unlock(&cxl_nvb->dev);
+
+	if (rc)
+		goto err_bridge;
+
+	/* @cxlr carries a reference on @cxl_nvb until cxlr_release_nvdimm */
+	return devm_add_action_or_reset(&cxlr->dev, cxlr_release_nvdimm, cxlr);
 
 err:
 	put_device(dev);
+err_bridge:
+	put_device(&cxl_nvb->dev);
+	cxlr->cxl_nvb = NULL;
 	return rc;
 }
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 4ac7938eaf6c..fc6083b0e467 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -386,6 +386,8 @@ struct cxl_region_params {
  * @id: This region's id. Id is globally unique across all regions
  * @mode: Endpoint decoder allocation / access mode
  * @type: Endpoint decoder target type
+ * @cxl_nvb: nvdimm bridge for coordinating @cxlr_pmem setup / shutdown
+ * @cxlr_pmem: (for pmem regions) cached copy of the nvdimm bridge
  * @params: active + config params for the region
  */
 struct cxl_region {
@@ -393,6 +395,8 @@ struct cxl_region {
 	int id;
 	enum cxl_decoder_mode mode;
 	enum cxl_decoder_type type;
+	struct cxl_nvdimm_bridge *cxl_nvb;
+	struct cxl_pmem_region *cxlr_pmem;
 	struct cxl_region_params params;
 };
 
@@ -438,7 +442,6 @@ struct cxl_pmem_region {
 	struct device dev;
 	struct cxl_region *cxlr;
 	struct nd_region *nd_region;
-	struct cxl_nvdimm_bridge *bridge;
 	struct range hpa_range;
 	int nr_mappings;
 	struct cxl_pmem_region_mapping mapping[];
@@ -637,7 +640,7 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
 struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
 bool is_cxl_nvdimm(struct device *dev);
 bool is_cxl_nvdimm_bridge(struct device *dev);
-int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd);
+int devm_cxl_add_nvdimm(struct cxl_memdev *cxlmd);
 struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct device *dev);
 
 #ifdef CONFIG_CXL_REGION
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 88e3a8e54b6a..c1c9960ab05f 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -35,6 +35,8 @@
  * @cdev: char dev core object for ioctl operations
  * @cxlds: The device state backing this device
  * @detach_work: active memdev lost a port in its ancestry
+ * @cxl_nvb: coordinate removal of @cxl_nvd if present
+ * @cxl_nvd: optional bridge to an nvdimm if the device supports pmem
  * @id: id number of this memdev instance.
  */
 struct cxl_memdev {
@@ -42,6 +44,8 @@ struct cxl_memdev {
 	struct cdev cdev;
 	struct cxl_dev_state *cxlds;
 	struct work_struct detach_work;
+	struct cxl_nvdimm_bridge *cxl_nvb;
+	struct cxl_nvdimm *cxl_nvd;
 	int id;
 };
 
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 64ccf053d32c..549b6b499bae 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -48,6 +48,7 @@ static int cxl_mem_dpa_show(struct seq_file *file, void *data)
 static int cxl_mem_probe(struct device *dev)
 {
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct cxl_port *parent_port;
 	struct cxl_dport *dport;
 	struct dentry *dentry;
@@ -95,6 +96,14 @@ static int cxl_mem_probe(struct device *dev)
 	if (rc)
 		return rc;
 
+	if (resource_size(&cxlds->pmem_res) && IS_ENABLED(CONFIG_CXL_PMEM)) {
+		rc = devm_cxl_add_nvdimm(cxlmd);
+		if (rc == -ENODEV)
+			dev_info(dev, "PMEM disabled by platform\n");
+		else
+			return rc;
+	}
+
 	/*
 	 * The kernel may be operating out of CXL memory on this device,
 	 * there is no spec defined way to determine whether this device
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 621a0522b554..e15da405b948 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -503,9 +503,6 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (IS_ERR(cxlmd))
 		return PTR_ERR(cxlmd);
 
-	if (resource_size(&cxlds->pmem_res) && IS_ENABLED(CONFIG_CXL_PMEM))
-		rc = devm_cxl_add_nvdimm(&pdev->dev, cxlmd);
-
 	return rc;
 }
 
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 652f00fc68ca..76cf54eeb310 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -34,26 +34,16 @@ static int cxl_nvdimm_probe(struct device *dev)
 {
 	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
 	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
+	struct cxl_nvdimm_bridge *cxl_nvb = cxlmd->cxl_nvb;
 	unsigned long flags = 0, cmd_mask = 0;
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
-	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct nvdimm *nvdimm;
 	int rc;
 
-	cxl_nvb = cxl_find_nvdimm_bridge(dev);
-	if (!cxl_nvb)
-		return -ENXIO;
-
-	device_lock(&cxl_nvb->dev);
-	if (!cxl_nvb->nvdimm_bus) {
-		rc = -ENXIO;
-		goto out;
-	}
-
 	set_exclusive_cxl_commands(cxlds, exclusive_cmds);
 	rc = devm_add_action_or_reset(dev, clear_exclusive, cxlds);
 	if (rc)
-		goto out;
+		return rc;
 
 	set_bit(NDD_LABELING, &flags);
 	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
@@ -61,19 +51,11 @@ static int cxl_nvdimm_probe(struct device *dev)
 	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
 	nvdimm = nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags,
 			       cmd_mask, 0, NULL);
-	if (!nvdimm) {
-		rc = -ENOMEM;
-		goto out;
-	}
+	if (!nvdimm)
+		return -ENOMEM;
 
 	dev_set_drvdata(dev, nvdimm);
-	cxl_nvd->bridge = cxl_nvb;
-	rc = devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
-out:
-	device_unlock(&cxl_nvb->dev);
-	put_device(&cxl_nvb->dev);
-
-	return rc;
+	return devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
 }
 
 static struct cxl_driver cxl_nvdimm_driver = {
@@ -200,6 +182,15 @@ static int cxl_pmem_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	return cxl_pmem_nvdimm_ctl(nvdimm, cmd, buf, buf_len);
 }
 
+static void unregister_nvdimm_bus(void *_cxl_nvb)
+{
+	struct cxl_nvdimm_bridge *cxl_nvb = _cxl_nvb;
+	struct nvdimm_bus *nvdimm_bus = cxl_nvb->nvdimm_bus;
+
+	cxl_nvb->nvdimm_bus = NULL;
+	nvdimm_bus_unregister(nvdimm_bus);
+}
+
 static bool online_nvdimm_bus(struct cxl_nvdimm_bridge *cxl_nvb)
 {
 	if (cxl_nvb->nvdimm_bus)
@@ -303,23 +294,21 @@ static int cxl_nvdimm_bridge_probe(struct device *dev)
 {
 	struct cxl_nvdimm_bridge *cxl_nvb = to_cxl_nvdimm_bridge(dev);
 
-	if (cxl_nvb->state == CXL_NVB_DEAD)
-		return -ENXIO;
+	cxl_nvb->nd_desc = (struct nvdimm_bus_descriptor) {
+		.provider_name = "CXL",
+		.module = THIS_MODULE,
+		.ndctl = cxl_pmem_ctl,
+	};
 
-	if (cxl_nvb->state == CXL_NVB_NEW) {
-		cxl_nvb->nd_desc = (struct nvdimm_bus_descriptor) {
-			.provider_name = "CXL",
-			.module = THIS_MODULE,
-			.ndctl = cxl_pmem_ctl,
-		};
+	cxl_nvb->nvdimm_bus =
+		nvdimm_bus_register(&cxl_nvb->dev, &cxl_nvb->nd_desc);
 
-		INIT_WORK(&cxl_nvb->state_work, cxl_nvb_update_state);
-	}
+	if (!cxl_nvb->nvdimm_bus)
+		return -ENOMEM;
 
-	cxl_nvb->state = CXL_NVB_ONLINE;
-	cxl_nvdimm_bridge_state_work(cxl_nvb);
+	INIT_WORK(&cxl_nvb->state_work, cxl_nvb_update_state);
 
-	return 0;
+	return devm_add_action_or_reset(dev, unregister_nvdimm_bus, cxl_nvb);
 }
 
 static struct cxl_driver cxl_nvdimm_bridge_driver = {
@@ -332,11 +321,6 @@ static struct cxl_driver cxl_nvdimm_bridge_driver = {
 	},
 };
 
-static int match_cxl_nvdimm(struct device *dev, void *data)
-{
-	return is_cxl_nvdimm(dev);
-}
-
 static void unregister_nvdimm_region(void *nd_region)
 {
 	nvdimm_region_delete(nd_region);
@@ -357,8 +341,8 @@ static int cxl_pmem_region_probe(struct device *dev)
 	struct nd_mapping_desc mappings[CXL_DECODER_MAX_INTERLEAVE];
 	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
 	struct cxl_region *cxlr = cxlr_pmem->cxlr;
+	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
 	struct cxl_pmem_region_info *info = NULL;
-	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct nd_interleave_set *nd_set;
 	struct nd_region_desc ndr_desc;
 	struct cxl_nvdimm *cxl_nvd;
@@ -366,28 +350,12 @@ static int cxl_pmem_region_probe(struct device *dev)
 	struct resource *res;
 	int rc, i = 0;
 
-	cxl_nvb = cxl_find_nvdimm_bridge(&cxlr_pmem->mapping[0].cxlmd->dev);
-	if (!cxl_nvb) {
-		dev_dbg(dev, "bridge not found\n");
-		return -ENXIO;
-	}
-	cxlr_pmem->bridge = cxl_nvb;
-
-	device_lock(&cxl_nvb->dev);
-	if (!cxl_nvb->nvdimm_bus) {
-		dev_dbg(dev, "nvdimm bus not found\n");
-		rc = -ENXIO;
-		goto out_nvb;
-	}
-
 	memset(&mappings, 0, sizeof(mappings));
 	memset(&ndr_desc, 0, sizeof(ndr_desc));
 
 	res = devm_kzalloc(dev, sizeof(*res), GFP_KERNEL);
-	if (!res) {
-		rc = -ENOMEM;
-		goto out_nvb;
-	}
+	if (!res)
+		return -ENOMEM;
 
 	res->name = "Persistent Memory";
 	res->start = cxlr_pmem->hpa_range.start;
@@ -397,11 +365,11 @@ static int cxl_pmem_region_probe(struct device *dev)
 
 	rc = insert_resource(&iomem_resource, res);
 	if (rc)
-		goto out_nvb;
+		return rc;
 
 	rc = devm_add_action_or_reset(dev, cxlr_pmem_remove_resource, res);
 	if (rc)
-		goto out_nvb;
+		return rc;
 
 	ndr_desc.res = res;
 	ndr_desc.provider_data = cxlr_pmem;
@@ -415,39 +383,23 @@ static int cxl_pmem_region_probe(struct device *dev)
 	}
 
 	nd_set = devm_kzalloc(dev, sizeof(*nd_set), GFP_KERNEL);
-	if (!nd_set) {
-		rc = -ENOMEM;
-		goto out_nvb;
-	}
+	if (!nd_set)
+		return -ENOMEM;
 
 	ndr_desc.memregion = cxlr->id;
 	set_bit(ND_REGION_CXL, &ndr_desc.flags);
 	set_bit(ND_REGION_PERSIST_MEMCTRL, &ndr_desc.flags);
 
 	info = kmalloc_array(cxlr_pmem->nr_mappings, sizeof(*info), GFP_KERNEL);
-	if (!info) {
-		rc = -ENOMEM;
-		goto out_nvb;
-	}
+	if (!info)
+		return -ENOMEM;
 
 	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
 		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
 		struct cxl_memdev *cxlmd = m->cxlmd;
 		struct cxl_dev_state *cxlds = cxlmd->cxlds;
-		struct device *d;
 
-		d = device_find_child(&cxlmd->dev, NULL, match_cxl_nvdimm);
-		if (!d) {
-			dev_dbg(dev, "[%d]: %s: no cxl_nvdimm found\n", i,
-				dev_name(&cxlmd->dev));
-			rc = -ENODEV;
-			goto out_nvd;
-		}
-
-		/* safe to drop ref now with bridge lock held */
-		put_device(d);
-
-		cxl_nvd = to_cxl_nvdimm(d);
+		cxl_nvd = cxlmd->cxl_nvd;
 		nvdimm = dev_get_drvdata(&cxl_nvd->dev);
 		if (!nvdimm) {
 			dev_dbg(dev, "[%d]: %s: no nvdimm found\n", i,
@@ -488,9 +440,6 @@ static int cxl_pmem_region_probe(struct device *dev)
 				      cxlr_pmem->nd_region);
 out_nvd:
 	kfree(info);
-out_nvb:
-	device_unlock(&cxl_nvb->dev);
-	put_device(&cxl_nvb->dev);
 
 	return rc;
 }
diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index aa2df3a15051..a4ee8e61dd60 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -285,9 +285,6 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	if (IS_ERR(cxlmd))
 		return PTR_ERR(cxlmd);
 
-	if (resource_size(&cxlds->pmem_res) && IS_ENABLED(CONFIG_CXL_PMEM))
-		rc = devm_cxl_add_nvdimm(dev, cxlmd);
-
 	return 0;
 }
 

