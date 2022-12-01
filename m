Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2D210782
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 21:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669930413; x=1701466413;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lBcAzVXuEY6LoB8m9L2g6iCeWfuwVnm7bufy0NoBMoo=;
  b=mXUFvprFo8vOGIAaYZNEh4c6Kj7b/SV/in2Tj9T3xLM7fkPlaFT7LYHm
   zjwp6Sl3rhL3lQmLqGXu3xKM5Wj+ygfhUOGZ8rHCYOq/RSSWrrmiWZAQW
   XCV4VVd6CVqfYP+dJYT1v4nA5aHeEwbAYWjIAyJyKAnFaeXLMzzGCPcBd
   xg2lETlo3Rv34KqBHwyGeXmaQw1hTkMAD0tCBfmWIqwOPUOcZbLDGTd5P
   rHZ1l2+8cuck1DW756Ohm7HnTYxZ57qw/HuVBDdts9fdeeIKL/b2MnrnH
   GaXL5R/8Vv84XOvz5hhUhIsDyqMfheV34lyNgkbliFKfVejbR0MMAKak7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="315831234"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="315831234"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:33:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="677368211"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="677368211"
Received: from navarrof-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.177.235])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:33:32 -0800
Subject: [PATCH v6 02/12] cxl/region: Drop redundant pmem region release
 handling
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Robert Richter <rrichter@amd.com>, alison.schofield@intel.com,
 rrichter@amd.com, terry.bowman@amd.com, bhelgaas@google.com,
 dave.jiang@intel.com, nvdimm@lists.linux.dev
Date: Thu, 01 Dec 2022 13:33:32 -0800
Message-ID: <166993041215.1882361.6321535567798911286.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Now that a cxl_nvdimm object can only experience ->remove() via an
unregistration event (because the cxl_nvdimm bind attributes are
suppressed), additional cleanups are possible.

It is already the case that the removal of a cxl_memdev object triggers
->remove() on any associated region. With that mechanism in place there
is no need for the cxl_nvdimm removal to trigger the same. Just rely on
cxl_region_detach() to tear down the whole cxl_pmem_region.

Tested-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/pmem.c |    2 -
 drivers/cxl/cxl.h       |    1 -
 drivers/cxl/pmem.c      |   90 -----------------------------------------------
 3 files changed, 93 deletions(-)

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index 36aa5070d902..1d12a8206444 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -188,7 +188,6 @@ static void cxl_nvdimm_release(struct device *dev)
 {
 	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
 
-	xa_destroy(&cxl_nvd->pmem_regions);
 	kfree(cxl_nvd);
 }
 
@@ -231,7 +230,6 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
 
 	dev = &cxl_nvd->dev;
 	cxl_nvd->cxlmd = cxlmd;
-	xa_init(&cxl_nvd->pmem_regions);
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &cxl_nvdimm_key);
 	device_set_pm_not_required(dev);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 7d07127eade3..4ac7938eaf6c 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -424,7 +424,6 @@ struct cxl_nvdimm {
 	struct device dev;
 	struct cxl_memdev *cxlmd;
 	struct cxl_nvdimm_bridge *bridge;
-	struct xarray pmem_regions;
 };
 
 struct cxl_pmem_region_mapping {
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 946e171e7d4a..652f00fc68ca 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -27,26 +27,7 @@ static void clear_exclusive(void *cxlds)
 
 static void unregister_nvdimm(void *nvdimm)
 {
-	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
-	struct cxl_nvdimm_bridge *cxl_nvb = cxl_nvd->bridge;
-	struct cxl_pmem_region *cxlr_pmem;
-	unsigned long index;
-
-	device_lock(&cxl_nvb->dev);
-	dev_set_drvdata(&cxl_nvd->dev, NULL);
-	xa_for_each(&cxl_nvd->pmem_regions, index, cxlr_pmem) {
-		get_device(&cxlr_pmem->dev);
-		device_unlock(&cxl_nvb->dev);
-
-		device_release_driver(&cxlr_pmem->dev);
-		put_device(&cxlr_pmem->dev);
-
-		device_lock(&cxl_nvb->dev);
-	}
-	device_unlock(&cxl_nvb->dev);
-
 	nvdimm_delete(nvdimm);
-	cxl_nvd->bridge = NULL;
 }
 
 static int cxl_nvdimm_probe(struct device *dev)
@@ -243,21 +224,6 @@ static int cxl_nvdimm_release_driver(struct device *dev, void *cxl_nvb)
 	return 0;
 }
 
-static int cxl_pmem_region_release_driver(struct device *dev, void *cxl_nvb)
-{
-	struct cxl_pmem_region *cxlr_pmem;
-
-	if (!is_cxl_pmem_region(dev))
-		return 0;
-
-	cxlr_pmem = to_cxl_pmem_region(dev);
-	if (cxlr_pmem->bridge != cxl_nvb)
-		return 0;
-
-	device_release_driver(dev);
-	return 0;
-}
-
 static void offline_nvdimm_bus(struct cxl_nvdimm_bridge *cxl_nvb,
 			       struct nvdimm_bus *nvdimm_bus)
 {
@@ -269,8 +235,6 @@ static void offline_nvdimm_bus(struct cxl_nvdimm_bridge *cxl_nvb,
 	 * nvdimm_bus_unregister() rips the nvdimm objects out from
 	 * underneath them.
 	 */
-	bus_for_each_dev(&cxl_bus_type, NULL, cxl_nvb,
-			 cxl_pmem_region_release_driver);
 	bus_for_each_dev(&cxl_bus_type, NULL, cxl_nvb,
 			 cxl_nvdimm_release_driver);
 	nvdimm_bus_unregister(nvdimm_bus);
@@ -378,48 +342,6 @@ static void unregister_nvdimm_region(void *nd_region)
 	nvdimm_region_delete(nd_region);
 }
 
-static int cxl_nvdimm_add_region(struct cxl_nvdimm *cxl_nvd,
-				 struct cxl_pmem_region *cxlr_pmem)
-{
-	int rc;
-
-	rc = xa_insert(&cxl_nvd->pmem_regions, (unsigned long)cxlr_pmem,
-		       cxlr_pmem, GFP_KERNEL);
-	if (rc)
-		return rc;
-
-	get_device(&cxlr_pmem->dev);
-	return 0;
-}
-
-static void cxl_nvdimm_del_region(struct cxl_nvdimm *cxl_nvd,
-				  struct cxl_pmem_region *cxlr_pmem)
-{
-	/*
-	 * It is possible this is called without a corresponding
-	 * cxl_nvdimm_add_region for @cxlr_pmem
-	 */
-	cxlr_pmem = xa_erase(&cxl_nvd->pmem_regions, (unsigned long)cxlr_pmem);
-	if (cxlr_pmem)
-		put_device(&cxlr_pmem->dev);
-}
-
-static void release_mappings(void *data)
-{
-	int i;
-	struct cxl_pmem_region *cxlr_pmem = data;
-	struct cxl_nvdimm_bridge *cxl_nvb = cxlr_pmem->bridge;
-
-	device_lock(&cxl_nvb->dev);
-	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
-		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
-		struct cxl_nvdimm *cxl_nvd = m->cxl_nvd;
-
-		cxl_nvdimm_del_region(cxl_nvd, cxlr_pmem);
-	}
-	device_unlock(&cxl_nvb->dev);
-}
-
 static void cxlr_pmem_remove_resource(void *res)
 {
 	remove_resource(res);
@@ -508,10 +430,6 @@ static int cxl_pmem_region_probe(struct device *dev)
 		goto out_nvb;
 	}
 
-	rc = devm_add_action_or_reset(dev, release_mappings, cxlr_pmem);
-	if (rc)
-		goto out_nvd;
-
 	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
 		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
 		struct cxl_memdev *cxlmd = m->cxlmd;
@@ -538,14 +456,6 @@ static int cxl_pmem_region_probe(struct device *dev)
 			goto out_nvd;
 		}
 
-		/*
-		 * Pin the region per nvdimm device as those may be released
-		 * out-of-order with respect to the region, and a single nvdimm
-		 * maybe associated with multiple regions
-		 */
-		rc = cxl_nvdimm_add_region(cxl_nvd, cxlr_pmem);
-		if (rc)
-			goto out_nvd;
 		m->cxl_nvd = cxl_nvd;
 		mappings[i] = (struct nd_mapping_desc) {
 			.nvdimm = nvdimm,

