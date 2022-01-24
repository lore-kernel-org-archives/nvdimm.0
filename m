Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAEA2C80
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 00:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642984141; x=1674520141;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wbN2Ghwl4LjPnudD9Q5iTscQTB2cNc27urMIsP7Da30=;
  b=bnR5hdWcJeM2fXV3omeWbDND/rlWqDRQ0LCkIYX4VO7O4LX4MntyjpEL
   S0p+cAbu/GsspYPk73RhgGsQzv3hRzLx1wD+G9DUL67D/3NUbhGMUYlPr
   20bCVMuiONxkyJAOsVTG3TV4a6cL+JG4lX+Mw2BAa1ku4MM11ZLMlhaGG
   1RU3q2uhIo6t70atGOlhZmxYzKjDULOrWxLz1tVTy5rpmfDH5jXuMej55
   Kl92Qlp9fymvPEZOP2Diy6DpbC7luGD6NbhNf5oqH1C/+v+FIOvKAd4d4
   aQI/dXu49kLtm4Ep6FhUaVsfCfHJxSXpc4iYpPvOE8yuNqVDPtIElpitV
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="233292224"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="233292224"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:29:00 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="766230060"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:29:00 -0800
Subject: [PATCH v3 04/40] cxl: Flesh out register names
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Ben Widawsky <ben.widawsky@intel.com>, linux-pci@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Sun, 23 Jan 2022 16:29:00 -0800
Message-ID: <164298414022.3018233.15522855498759815097.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Ben Widawsky <ben.widawsky@intel.com>

Get a better naming scheme in place for upcoming additions. By dropping
redundant usages of CXL and DVSEC where appropriate we can get more
concise and also more grepable defines.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/pci.c |   14 +++++++-------
 drivers/cxl/pci.h |   19 ++++++++++---------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 91de2e4aff6f..1eeba0ec46f3 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -370,10 +370,10 @@ static int cxl_map_regs(struct cxl_dev_state *cxlds, struct cxl_register_map *ma
 static void cxl_decode_regblock(u32 reg_lo, u32 reg_hi,
 				struct cxl_register_map *map)
 {
-	map->block_offset =
-		((u64)reg_hi << 32) | (reg_lo & CXL_REGLOC_ADDR_MASK);
-	map->barno = FIELD_GET(CXL_REGLOC_BIR_MASK, reg_lo);
-	map->reg_type = FIELD_GET(CXL_REGLOC_RBI_MASK, reg_lo);
+	map->block_offset = ((u64)reg_hi << 32) |
+			    (reg_lo & CXL_DVSEC_REG_LOCATOR_BLOCK_OFF_LOW_MASK);
+	map->barno = FIELD_GET(CXL_DVSEC_REG_LOCATOR_BIR_MASK, reg_lo);
+	map->reg_type = FIELD_GET(CXL_DVSEC_REG_LOCATOR_BLOCK_ID_MASK, reg_lo);
 }
 
 /**
@@ -394,15 +394,15 @@ static int cxl_find_regblock(struct pci_dev *pdev, enum cxl_regloc_type type,
 	int regloc, i;
 
 	regloc = pci_find_dvsec_capability(pdev, PCI_DVSEC_VENDOR_ID_CXL,
-					   PCI_DVSEC_ID_CXL_REGLOC_DVSEC_ID);
+					   CXL_DVSEC_REG_LOCATOR);
 	if (!regloc)
 		return -ENXIO;
 
 	pci_read_config_dword(pdev, regloc + PCI_DVSEC_HEADER1, &regloc_size);
 	regloc_size = FIELD_GET(PCI_DVSEC_HEADER1_LENGTH_MASK, regloc_size);
 
-	regloc += PCI_DVSEC_ID_CXL_REGLOC_BLOCK1_OFFSET;
-	regblocks = (regloc_size - PCI_DVSEC_ID_CXL_REGLOC_BLOCK1_OFFSET) / 8;
+	regloc += CXL_DVSEC_REG_LOCATOR_BLOCK1_OFFSET;
+	regblocks = (regloc_size - CXL_DVSEC_REG_LOCATOR_BLOCK1_OFFSET) / 8;
 
 	for (i = 0; i < regblocks; i++, regloc += 8) {
 		u32 reg_lo, reg_hi;
diff --git a/drivers/cxl/pci.h b/drivers/cxl/pci.h
index 7d3e4bf06b45..29b8eaef3a0a 100644
--- a/drivers/cxl/pci.h
+++ b/drivers/cxl/pci.h
@@ -7,17 +7,21 @@
 
 /*
  * See section 8.1 Configuration Space Registers in the CXL 2.0
- * Specification
+ * Specification. Names are taken straight from the specification with "CXL" and
+ * "DVSEC" redundancies removed. When obvious, abbreviations may be used.
  */
 #define PCI_DVSEC_HEADER1_LENGTH_MASK	GENMASK(31, 20)
 #define PCI_DVSEC_VENDOR_ID_CXL		0x1E98
-#define PCI_DVSEC_ID_CXL		0x0
 
-#define PCI_DVSEC_ID_CXL_REGLOC_DVSEC_ID	0x8
-#define PCI_DVSEC_ID_CXL_REGLOC_BLOCK1_OFFSET	0xC
+/* CXL 2.0 8.1.3: PCIe DVSEC for CXL Device */
+#define CXL_DVSEC_PCIE_DEVICE					0
 
-/* BAR Indicator Register (BIR) */
-#define CXL_REGLOC_BIR_MASK GENMASK(2, 0)
+/* CXL 2.0 8.1.9: Register Locator DVSEC */
+#define CXL_DVSEC_REG_LOCATOR					8
+#define   CXL_DVSEC_REG_LOCATOR_BLOCK1_OFFSET			0xC
+#define     CXL_DVSEC_REG_LOCATOR_BIR_MASK			GENMASK(2, 0)
+#define	    CXL_DVSEC_REG_LOCATOR_BLOCK_ID_MASK			GENMASK(15, 8)
+#define     CXL_DVSEC_REG_LOCATOR_BLOCK_OFF_LOW_MASK		GENMASK(31, 16)
 
 /* Register Block Identifier (RBI) */
 enum cxl_regloc_type {
@@ -28,7 +32,4 @@ enum cxl_regloc_type {
 	CXL_REGLOC_RBI_TYPES
 };
 
-#define CXL_REGLOC_RBI_MASK GENMASK(15, 8)
-#define CXL_REGLOC_ADDR_MASK GENMASK(31, 16)
-
 #endif /* __CXL_PCI_H__ */

