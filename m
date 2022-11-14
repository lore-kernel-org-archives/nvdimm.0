Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3D18482
	for <nvdimm@lists.linux.dev>; Mon, 14 Nov 2022 20:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668458090; x=1699994090;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jpSWnISbv2VImCMR2REZ86zBTitBZ/PNe/oOYeKWB3w=;
  b=g68MULU6LWaUDbeidgv819wH0MeHnsnzSVZysS3jyAJaVWQ64ZEF6PaY
   qwm1XwDPj2IeX368Bf8cB0BTFDCvG2xKo3XYsGPumcWkTUnatFInITyXG
   6yd4o+01xN/ETtkdUadGfZ2UQ8dL3fVoGlhJMm93BkZdOnKi0G7Gb74ce
   lpjmBAV/SQ5lNz6bvP4LlJokWiQ95tk44H2rTFSmb6a5tl3fRpEFZfxzs
   lsACrKUWQJFRj2wZatbiLSxTdgeJ9em/hT31WkhFXgOnTt6mUQR6wtnef
   +mvrHokAY/7nimYfIo4s4ArTKb1kHsyENZmMKh2o4PcqLYe2c6h+yEcL5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="338868769"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="338868769"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 12:34:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="702155142"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="702155142"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 12:34:48 -0800
Subject: [PATCH v4 18/18] cxl: add dimm_id support for __nvdimm_create()
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Mon, 14 Nov 2022 13:34:48 -0700
Message-ID: 
 <166845808855.2496228.2510882323325476885.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166845791969.2496228.8357488385523295841.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166845791969.2496228.8357488385523295841.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Set the cxlds->serial as the dimm_id to be fed to __nvdimm_create(). The
security code uses that as the key description for the security key of the
memory device. The nvdimm unlock code cannot find the respective key
without the dimm_id.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/cxlmem.h         |    3 +++
 drivers/cxl/pci.c            |    4 ++++
 drivers/cxl/pmem.c           |    4 +++-
 tools/testing/cxl/test/mem.c |    4 ++++
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 75baeb0bbe57..76bdec873868 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -178,6 +178,8 @@ struct cxl_endpoint_dvsec_info {
 	struct range dvsec_range[2];
 };
 
+#define CXL_DEV_ID_LEN 32
+
 /**
  * struct cxl_dev_state - The driver device state
  *
@@ -244,6 +246,7 @@ struct cxl_dev_state {
 
 	resource_size_t component_reg_phys;
 	u64 serial;
+	u8 dev_id[CXL_DEV_ID_LEN]; /* for nvdimm, string of 'serial' */
 
 	struct xarray doe_mbs;
 
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 621a0522b554..c48fcd2a90ef 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -456,6 +456,10 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return PTR_ERR(cxlds);
 
 	cxlds->serial = pci_get_dsn(pdev);
+	rc = snprintf(cxlds->dev_id, CXL_DEV_ID_LEN, "%llu", cxlds->serial);
+	if (rc <= 0)
+		return -ENXIO;
+
 	cxlds->cxl_dvsec = pci_find_dvsec_capability(
 		pdev, PCI_DVSEC_VENDOR_ID_CXL, CXL_DVSEC_PCIE_DEVICE);
 	if (!cxlds->cxl_dvsec)
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 322f834cc27d..80556dc8d29c 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -112,9 +112,11 @@ static int cxl_nvdimm_probe(struct device *dev)
 	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
 	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
 	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
+
 	nvdimm = __nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd,
 				 cxl_dimm_attribute_groups, flags,
-				 cmd_mask, 0, NULL, NULL, cxl_security_ops, NULL);
+				 cmd_mask, 0, NULL, cxlds->dev_id,
+				 cxl_security_ops, NULL);
 	if (!nvdimm) {
 		rc = -ENOMEM;
 		goto out;
diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index fc28f7cc147a..35723d45438e 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -571,6 +571,10 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 		return PTR_ERR(cxlds);
 
 	cxlds->serial = pdev->id;
+	rc = snprintf(cxlds->dev_id, CXL_DEV_ID_LEN, "%llu", cxlds->serial);
+	if (rc <= 0)
+		return -ENXIO;
+
 	cxlds->mbox_send = cxl_mock_mbox_send;
 	cxlds->payload_size = SZ_4K;
 


