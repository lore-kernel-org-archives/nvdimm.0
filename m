Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 42E821A1E40
 for <linux-nvdimm@lists.01.org>; Sun,  9 Oct 2016 17:35:44 -0700 (PDT)
From: Haozhong Zhang <haozhong.zhang@intel.com>
Subject: [RFC KERNEL PATCH 1/2] nvdimm: add PFN_MODE_XEN to pfn device for Xen
 usage
Date: Mon, 10 Oct 2016 08:35:22 +0800
Message-Id: <20161010003523.4423-2-haozhong.zhang@intel.com>
In-Reply-To: <20161010003523.4423-1-haozhong.zhang@intel.com>
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org, xen-devel@lists.xenproject.org
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

pfn device in PFN_MODE_XEN reserves an area for Xen hypervisor to place
its own pmem management data structures (i.e. frame table and M2P
table). The reserved area is not used and not mapped by Linux kernel,
and only the data area is mapped.

Signed-off-by: Haozhong Zhang <haozhong.zhang@intel.com>
---
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-kernel@vger.kernel.org
---
 drivers/nvdimm/namespace_devs.c |  2 ++
 drivers/nvdimm/nd.h             |  7 +++++++
 drivers/nvdimm/pfn_devs.c       | 37 +++++++++++++++++++++++++++++++++----
 drivers/nvdimm/pmem.c           | 36 +++++++++++++++++++++++++++++++++---
 include/linux/pfn_t.h           |  2 ++
 5 files changed, 77 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 3509cff..b1df653 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1394,6 +1394,8 @@ static ssize_t mode_show(struct device *dev,
 	claim = ndns->claim;
 	if (claim && is_nd_btt(claim))
 		mode = "safe";
+	else if (claim && is_nd_pfn_xen(claim))
+		mode = "xen";
 	else if (claim && is_nd_pfn(claim))
 		mode = "memory";
 	else if (claim && is_nd_dax(claim))
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index d3b2fca..6af3a78 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -192,6 +192,7 @@ enum nd_pfn_mode {
 	PFN_MODE_NONE,
 	PFN_MODE_RAM,
 	PFN_MODE_PMEM,
+	PFN_MODE_XEN,
 };
 
 struct nd_pfn {
@@ -272,6 +273,7 @@ struct nd_pfn *to_nd_pfn(struct device *dev);
 #if IS_ENABLED(CONFIG_NVDIMM_PFN)
 int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns);
 bool is_nd_pfn(struct device *dev);
+bool is_nd_pfn_xen(struct device *dev);
 struct device *nd_pfn_create(struct nd_region *nd_region);
 struct device *nd_pfn_devinit(struct nd_pfn *nd_pfn,
 		struct nd_namespace_common *ndns);
@@ -289,6 +291,11 @@ static inline bool is_nd_pfn(struct device *dev)
 	return false;
 }
 
+static inline bool is_nd_pfn_xen(struct device *dev)
+{
+	return false;
+}
+
 static inline struct device *nd_pfn_create(struct nd_region *nd_region)
 {
 	return NULL;
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index cea8350..6624f72 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -45,6 +45,12 @@ bool is_nd_pfn(struct device *dev)
 }
 EXPORT_SYMBOL(is_nd_pfn);
 
+bool is_nd_pfn_xen(struct device *dev)
+{
+	return is_nd_pfn(dev) ? to_nd_pfn(dev)->mode == PFN_MODE_XEN : false;
+}
+EXPORT_SYMBOL(is_nd_pfn_xen);
+
 struct nd_pfn *to_nd_pfn(struct device *dev)
 {
 	struct nd_pfn *nd_pfn = container_of(dev, struct nd_pfn, dev);
@@ -64,6 +70,8 @@ static ssize_t mode_show(struct device *dev,
 		return sprintf(buf, "ram\n");
 	case PFN_MODE_PMEM:
 		return sprintf(buf, "pmem\n");
+	case PFN_MODE_XEN:
+		return sprintf(buf, "xen\n");
 	default:
 		return sprintf(buf, "none\n");
 	}
@@ -88,6 +96,9 @@ static ssize_t mode_store(struct device *dev,
 		} else if (strncmp(buf, "ram\n", n) == 0
 				|| strncmp(buf, "ram", n) == 0)
 			nd_pfn->mode = PFN_MODE_RAM;
+		else if (strncmp(buf, "xen\n", n) == 0
+				|| strncmp(buf, "xen", n) == 0)
+			nd_pfn->mode = PFN_MODE_XEN;
 		else if (strncmp(buf, "none\n", n) == 0
 				|| strncmp(buf, "none", n) == 0)
 			nd_pfn->mode = PFN_MODE_NONE;
@@ -383,6 +394,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	switch (le32_to_cpu(pfn_sb->mode)) {
 	case PFN_MODE_RAM:
 	case PFN_MODE_PMEM:
+	case PFN_MODE_XEN:
 		break;
 	default:
 		return -ENXIO;
@@ -532,11 +544,10 @@ static struct vmem_altmap *__nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
 	res->start += start_pad;
 	res->end -= end_trunc;
 
-	if (nd_pfn->mode == PFN_MODE_RAM) {
+	if (nd_pfn->mode == PFN_MODE_RAM || nd_pfn->mode == PFN_MODE_XEN) {
 		if (offset < SZ_8K)
 			return ERR_PTR(-EINVAL);
 		nd_pfn->npfns = le64_to_cpu(pfn_sb->npfns);
-		altmap = NULL;
 	} else if (nd_pfn->mode == PFN_MODE_PMEM) {
 		nd_pfn->npfns = (resource_size(res) - offset) / PAGE_SIZE;
 		if (le64_to_cpu(nd_pfn->pfn_sb->npfns) > nd_pfn->npfns)
@@ -544,11 +555,15 @@ static struct vmem_altmap *__nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
 					"number of pfns truncated from %lld to %ld\n",
 					le64_to_cpu(nd_pfn->pfn_sb->npfns),
 					nd_pfn->npfns);
+	} else
+		return ERR_PTR(-ENXIO);
+
+	if (nd_pfn->mode == PFN_MODE_PMEM || nd_pfn->mode == PFN_MODE_XEN) {
 		memcpy(altmap, &__altmap, sizeof(*altmap));
 		altmap->free = PHYS_PFN(offset - SZ_8K);
 		altmap->alloc = 0;
 	} else
-		return ERR_PTR(-ENXIO);
+		altmap = NULL;
 
 	return altmap;
 }
@@ -639,7 +654,21 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	} else if (nd_pfn->mode == PFN_MODE_RAM)
 		offset = ALIGN(start + SZ_8K + dax_label_reserve,
 				nd_pfn->align) - start;
-	else
+	else if (nd_pfn->mode == PFN_MODE_XEN) {
+		/*
+		 * Reserve 64 bytes for each entry of Xen frame table
+		 * and 8 bytes for each entry of Xen M2P table. The
+		 * frame table and M2P table are used by Xen for its
+		 * memory management.
+		 */
+		unsigned long reserved_size;
+		unsigned long nr_pfns = ALIGN(size, SZ_4K) / SZ_4K;
+
+		reserved_size  = ALIGN(64 * nr_pfns, HPAGE_SIZE);
+		reserved_size += ALIGN(8 * nr_pfns, HPAGE_SIZE);
+		offset = ALIGN(start + SZ_8K + reserved_size + dax_label_reserve,
+			       nd_pfn->align) - start;
+	} else
 		return -ENXIO;
 
 	if (offset + start_pad + end_trunc >= size) {
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 42b3a82..d2c9ead 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -92,7 +92,12 @@ static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 {
 	int rc = 0;
 	bool bad_pmem = false;
-	phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
+	/*
+	 * Only the data area of pfn_xen is mapped, so its offset
+	 * should be calculated from the beginning of the data area.
+	 */
+	phys_addr_t pmem_off = sector * 512 +
+		((pmem->pfn_flags & PFN_XEN) ? 0 : pmem->data_offset);
 	void *pmem_addr = pmem->virt_addr + pmem_off;
 
 	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
@@ -194,7 +199,12 @@ __weak long pmem_direct_access(struct block_device *bdev, sector_t sector,
 		      void **kaddr, pfn_t *pfn, long size)
 {
 	struct pmem_device *pmem = bdev->bd_queue->queuedata;
-	resource_size_t offset = sector * 512 + pmem->data_offset;
+	/*
+	 * Only the data area of pfn_xen is mapped, so its offset
+	 * should be calculated from the beginning of the data area.
+	 */
+	resource_size_t offset = sector * 512 +
+		((pmem->pfn_flags & PFN_XEN) ? 0 : pmem->data_offset);
 
 	if (unlikely(is_bad_pmem(&pmem->bb, sector, size)))
 		return -EIO;
@@ -276,7 +286,27 @@ static int pmem_attach_disk(struct device *dev,
 		return -ENOMEM;
 
 	pmem->pfn_flags = PFN_DEV;
-	if (is_nd_pfn(dev)) {
+	if (is_nd_pfn_xen(dev)) {
+		/*
+		 * The reserved area on nd_pfn_xen is used by Xen
+		 * hypervisor other than Linux kernel, so it is not
+		 * necessary and should not be mapped here. We only
+		 * create the memory map for the data area.
+		 */
+		resource_size_t dataoff;
+		size_t datasize;
+
+		pfn_sb = nd_pfn->pfn_sb;
+		dataoff = pmem->phys_addr + le32_to_cpu(pfn_sb->start_pad) +
+			  le64_to_cpu(pfn_sb->dataoff);
+		datasize = resource_size(&pfn_res) - le64_to_cpu(pfn_sb->dataoff);
+		addr = devm_memremap(dev, dataoff, datasize, ARCH_MEMREMAP_PMEM);
+		pmem->data_offset = le64_to_cpu(pfn_sb->dataoff);
+		pmem->pfn_pad = resource_size(res) - resource_size(&pfn_res);
+		pmem->pfn_flags |= PFN_XEN;
+		res = &pfn_res; /* for badblocks populate */
+		res->start += pmem->data_offset;
+	} else if (is_nd_pfn(dev)) {
 		addr = devm_memremap_pages(dev, &pfn_res, &q->q_usage_counter,
 				altmap);
 		pfn_sb = nd_pfn->pfn_sb;
diff --git a/include/linux/pfn_t.h b/include/linux/pfn_t.h
index a3d90b9..65f90f8 100644
--- a/include/linux/pfn_t.h
+++ b/include/linux/pfn_t.h
@@ -8,12 +8,14 @@
  * PFN_SG_LAST - pfn references a page and is the last scatterlist entry
  * PFN_DEV - pfn is not covered by system memmap by default
  * PFN_MAP - pfn has a dynamic page mapping established by a device driver
+ * PFN_XEN - pfn has an area reserved for Xen hypervisor
  */
 #define PFN_FLAGS_MASK (((u64) ~PAGE_MASK) << (BITS_PER_LONG_LONG - PAGE_SHIFT))
 #define PFN_SG_CHAIN (1ULL << (BITS_PER_LONG_LONG - 1))
 #define PFN_SG_LAST (1ULL << (BITS_PER_LONG_LONG - 2))
 #define PFN_DEV (1ULL << (BITS_PER_LONG_LONG - 3))
 #define PFN_MAP (1ULL << (BITS_PER_LONG_LONG - 4))
+#define PFN_XEN (1ULL << (BITS_PER_LONG_LONG - 5))
 
 static inline pfn_t __pfn_to_pfn_t(unsigned long pfn, u64 flags)
 {
-- 
2.10.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
