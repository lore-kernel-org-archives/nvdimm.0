Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7CAFF2194EB7B
 for <linux-nvdimm@lists.01.org>; Thu, 13 Jun 2019 02:43:58 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/22] memremap: lift the devmap_enable manipulation into
 devm_memremap_pages
Date: Thu, 13 Jun 2019 11:43:12 +0200
Message-Id: <20190613094326.24093-10-hch@lst.de>
In-Reply-To: <20190613094326.24093-1-hch@lst.de>
References: <20190613094326.24093-1-hch@lst.de>
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
To: Dan Williams <dan.j.williams@intel.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, nouveau@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

Just check if there is a ->page_free operation set and take care of the
static key enable, as well as the put using device managed resources.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvdimm/pmem.c | 23 +++--------------
 include/linux/mm.h    | 10 --------
 kernel/memremap.c     | 59 +++++++++++++++++++++++++++----------------
 mm/hmm.c              |  2 --
 4 files changed, 41 insertions(+), 53 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index b9638c6553a1..66837eed6375 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -334,11 +334,6 @@ static void pmem_release_disk(void *__pmem)
 	put_disk(pmem->disk);
 }
 
-static void pmem_release_pgmap_ops(void *__pgmap)
-{
-	dev_pagemap_put_ops();
-}
-
 static void pmem_fsdax_page_free(struct page *page, void *data)
 {
 	wake_up_var(&page->_refcount);
@@ -353,16 +348,6 @@ static const struct dev_pagemap_ops pmem_legacy_pagemap_ops = {
 	.kill			= pmem_kill,
 };
 
-static int setup_pagemap_fsdax(struct device *dev, struct dev_pagemap *pgmap)
-{
-	dev_pagemap_get_ops();
-	if (devm_add_action_or_reset(dev, pmem_release_pgmap_ops, pgmap))
-		return -ENOMEM;
-	pgmap->type = MEMORY_DEVICE_FS_DAX;
-	pgmap->ops = &fsdax_pagemap_ops;
-	return 0;
-}
-
 static int pmem_attach_disk(struct device *dev,
 		struct nd_namespace_common *ndns)
 {
@@ -421,8 +406,8 @@ static int pmem_attach_disk(struct device *dev,
 	pmem->pfn_flags = PFN_DEV;
 	pmem->pgmap.ref = &q->q_usage_counter;
 	if (is_nd_pfn(dev)) {
-		if (setup_pagemap_fsdax(dev, &pmem->pgmap))
-			return -ENOMEM;
+		pmem->pgmap.type = MEMORY_DEVICE_FS_DAX;
+		pmem->pgmap.ops = &fsdax_pagemap_ops;
 		addr = devm_memremap_pages(dev, &pmem->pgmap);
 		pfn_sb = nd_pfn->pfn_sb;
 		pmem->data_offset = le64_to_cpu(pfn_sb->dataoff);
@@ -434,8 +419,8 @@ static int pmem_attach_disk(struct device *dev,
 	} else if (pmem_should_map_pages(dev)) {
 		memcpy(&pmem->pgmap.res, &nsio->res, sizeof(pmem->pgmap.res));
 		pmem->pgmap.altmap_valid = false;
-		if (setup_pagemap_fsdax(dev, &pmem->pgmap))
-			return -ENOMEM;
+		pmem->pgmap.type = MEMORY_DEVICE_FS_DAX;
+		pmem->pgmap.ops = &fsdax_pagemap_ops;
 		addr = devm_memremap_pages(dev, &pmem->pgmap);
 		pmem->pfn_flags |= PFN_MAP;
 		memcpy(&bb_res, &pmem->pgmap.res, sizeof(bb_res));
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0e8834ac32b7..edcf2b821647 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -921,8 +921,6 @@ static inline bool is_zone_device_page(const struct page *page)
 #endif
 
 #ifdef CONFIG_DEV_PAGEMAP_OPS
-void dev_pagemap_get_ops(void);
-void dev_pagemap_put_ops(void);
 void __put_devmap_managed_page(struct page *page);
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
 static inline bool put_devmap_managed_page(struct page *page)
@@ -969,14 +967,6 @@ static inline bool is_pci_p2pdma_page(const struct page *page)
 #endif /* CONFIG_PCI_P2PDMA */
 
 #else /* CONFIG_DEV_PAGEMAP_OPS */
-static inline void dev_pagemap_get_ops(void)
-{
-}
-
-static inline void dev_pagemap_put_ops(void)
-{
-}
-
 static inline bool put_devmap_managed_page(struct page *page)
 {
 	return false;
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 94b830b6eca5..6a3183cac764 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -17,6 +17,37 @@ static DEFINE_XARRAY(pgmap_array);
 #define SECTION_MASK ~((1UL << PA_SECTION_SHIFT) - 1)
 #define SECTION_SIZE (1UL << PA_SECTION_SHIFT)
 
+#ifdef CONFIG_DEV_PAGEMAP_OPS
+DEFINE_STATIC_KEY_FALSE(devmap_managed_key);
+EXPORT_SYMBOL(devmap_managed_key);
+static atomic_t devmap_enable;
+
+static void dev_pagemap_put_ops(void *data)
+{
+	if (atomic_dec_and_test(&devmap_enable))
+		static_branch_disable(&devmap_managed_key);
+}
+
+/*
+ * Toggle the static key for ->page_free() callbacks when dev_pagemap
+ * pages go idle.
+ */
+static int dev_pagemap_enable(struct device *dev)
+{
+	if (atomic_inc_return(&devmap_enable) == 1)
+		static_branch_enable(&devmap_managed_key);
+
+	if (devm_add_action_or_reset(dev, dev_pagemap_put_ops, NULL))
+		return -ENOMEM;
+	return 0;
+}
+#else
+static inline int dev_pagemap_enable(struct device *dev)
+{
+	return 0;
+}
+#endif /* CONFIG_DEV_PAGEMAP_OPS */
+
 #if IS_ENABLED(CONFIG_DEVICE_PRIVATE)
 vm_fault_t device_private_entry_fault(struct vm_area_struct *vma,
 		       unsigned long addr,
@@ -159,6 +190,12 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 	if (!pgmap->ref || !pgmap->ops || !pgmap->ops->kill)
 		return ERR_PTR(-EINVAL);
 
+	if (pgmap->ops->page_free) {
+		error = dev_pagemap_enable(dev);
+		if (error)
+			return ERR_PTR(error);
+	}
+
 	align_start = res->start & ~(SECTION_SIZE - 1);
 	align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
 		- align_start;
@@ -316,28 +353,6 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 EXPORT_SYMBOL_GPL(get_dev_pagemap);
 
 #ifdef CONFIG_DEV_PAGEMAP_OPS
-DEFINE_STATIC_KEY_FALSE(devmap_managed_key);
-EXPORT_SYMBOL(devmap_managed_key);
-static atomic_t devmap_enable;
-
-/*
- * Toggle the static key for ->page_free() callbacks when dev_pagemap
- * pages go idle.
- */
-void dev_pagemap_get_ops(void)
-{
-	if (atomic_inc_return(&devmap_enable) == 1)
-		static_branch_enable(&devmap_managed_key);
-}
-EXPORT_SYMBOL_GPL(dev_pagemap_get_ops);
-
-void dev_pagemap_put_ops(void)
-{
-	if (atomic_dec_and_test(&devmap_enable))
-		static_branch_disable(&devmap_managed_key);
-}
-EXPORT_SYMBOL_GPL(dev_pagemap_put_ops);
-
 void __put_devmap_managed_page(struct page *page)
 {
 	int count = page_ref_dec_return(page);
diff --git a/mm/hmm.c b/mm/hmm.c
index c76a1b5defda..6dc769feb2e1 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -1378,8 +1378,6 @@ struct hmm_devmem *hmm_devmem_add(const struct hmm_devmem_ops *ops,
 	void *result;
 	int ret;
 
-	dev_pagemap_get_ops();
-
 	devmem = devm_kzalloc(device, sizeof(*devmem), GFP_KERNEL);
 	if (!devmem)
 		return ERR_PTR(-ENOMEM);
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
