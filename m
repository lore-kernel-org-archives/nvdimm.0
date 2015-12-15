Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 1/9] libnvdimm, pfn: kill ND_PFN_ALIGN
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Dec 2015 18:14:34 -0800
Message-ID: <20151215021434.37090.56710.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
References: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: willy@linux.intel.com, ross.zwisler@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The alignment constraint isn't necessary now that devm_memremap_pages()
allows for unaligned mappings.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/nd.h       |    7 -------
 drivers/nvdimm/pfn_devs.c |   11 +----------
 drivers/nvdimm/pmem.c     |   15 ---------------
 3 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 417e521d299c..2ce428e9b584 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -29,13 +29,6 @@ enum {
 	ND_MAX_LANES = 256,
 	SECTOR_SHIFT = 9,
 	INT_LBASIZE_ALIGNMENT = 64,
-#if IS_ENABLED(CONFIG_NVDIMM_PFN)
-	ND_PFN_ALIGN = PAGES_PER_SECTION * PAGE_SIZE,
-	ND_PFN_MASK = ND_PFN_ALIGN - 1,
-#else
-	ND_PFN_ALIGN = 0,
-	ND_PFN_MASK = 0,
-#endif
 };
 
 struct nvdimm_drvdata {
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 71805a1aa0f3..96c122918ee1 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -241,10 +241,6 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn)
 	if (!is_nd_pmem(nd_pfn->dev.parent))
 		return -ENODEV;
 
-	/* section alignment for simple hotplug */
-	if (nvdimm_namespace_capacity(ndns) < ND_PFN_ALIGN)
-		return -ENODEV;
-
 	if (nvdimm_read_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb)))
 		return -ENXIO;
 
@@ -286,12 +282,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn)
 	 */
 	offset = le64_to_cpu(pfn_sb->dataoff);
 	nsio = to_nd_namespace_io(&ndns->dev);
-	if (nsio->res.start & ND_PFN_MASK) {
-		dev_err(&nd_pfn->dev,
-				"init failed: %s not section aligned\n",
-				dev_name(&ndns->dev));
-		return -EBUSY;
-	} else if (offset >= resource_size(&nsio->res)) {
+	if (offset >= resource_size(&nsio->res)) {
 		dev_err(&nd_pfn->dev, "pfn array size exceeds capacity of %s\n",
 				dev_name(&ndns->dev));
 		return -EBUSY;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 8ee79893d2f5..520c00321dad 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -241,11 +241,6 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	if (rc == 0 || rc == -EBUSY)
 		return rc;
 
-	/* section alignment for simple hotplug */
-	if (nvdimm_namespace_capacity(ndns) < ND_PFN_ALIGN
-			|| pmem->phys_addr & ND_PFN_MASK)
-		return -ENODEV;
-
 	nd_region = to_nd_region(nd_pfn->dev.parent);
 	if (nd_region->ro) {
 		dev_info(&nd_pfn->dev,
@@ -326,16 +321,6 @@ static int nvdimm_namespace_attach_pfn(struct nd_namespace_common *ndns)
 	if (rc)
 		return rc;
 
-	if (PAGE_SIZE != SZ_4K) {
-		dev_err(dev, "only supported on systems with 4K PAGE_SIZE\n");
-		return -ENXIO;
-	}
-	if (nsio->res.start & ND_PFN_MASK) {
-		dev_err(dev, "%s not memory hotplug section aligned\n",
-				dev_name(&ndns->dev));
-		return -ENXIO;
-	}
-
 	pfn_sb = nd_pfn->pfn_sb;
 	offset = le64_to_cpu(pfn_sb->dataoff);
 	nd_pfn->mode = le32_to_cpu(nd_pfn->pfn_sb->mode);

