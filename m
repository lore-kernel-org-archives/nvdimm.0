Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6405821E1DAD9
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 00:47:37 -0700 (PDT)
Received: by mail-pg0-x243.google.com with SMTP id 83so792500pgb.4
 for <linux-nvdimm@lists.01.org>; Thu, 03 Aug 2017 00:49:48 -0700 (PDT)
From: Steven Swanson <swanson@eng.ucsd.edu>
Subject: [RFC 14/16] NOVA: Read-only pmem devices
Date: Thu, 03 Aug 2017 00:49:46 -0700
Message-ID: <150174658689.104003.120621559635888592.stgit@hn>
In-Reply-To: <150174646416.104003.14042713459553361884.stgit@hn>
References: <150174646416.104003.14042713459553361884.stgit@hn>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Steven Swanson <steven.swanson@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

Add (and implement) a module command line option to nd_pmem to support read-only pmem devices.

Signed-off-by: Steven Swanson <swanson@cs.ucsd.edu>
---
 arch/x86/include/asm/io.h |    1 +
 arch/x86/mm/ioremap.c     |   25 ++++++++++++++++++-------
 drivers/nvdimm/pmem.c     |   14 ++++++++++++--
 include/linux/io.h        |    2 ++
 kernel/memremap.c         |   24 ++++++++++++++++++++++++
 mm/memory.c               |    2 +-
 mm/mmap.c                 |    1 +
 7 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 7afb0e2f07f4..7aae48f2e4f1 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -173,6 +173,7 @@ extern void __iomem *ioremap_uc(resource_size_t offset, unsigned long size);
 #define ioremap_uc ioremap_uc
 
 extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
+extern void __iomem *ioremap_cache_ro(resource_size_t phys_addr, unsigned long size);
 extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size, unsigned long prot_val);
 
 /**
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index bbc558b88a88..bcd473801817 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -81,7 +81,8 @@ static int __ioremap_check_ram(unsigned long start_pfn, unsigned long nr_pages,
  * caller shouldn't need to know that small detail.
  */
 static void __iomem *__ioremap_caller(resource_size_t phys_addr,
-		unsigned long size, enum page_cache_mode pcm, void *caller)
+		unsigned long size, enum page_cache_mode pcm, void *caller,
+		int readonly)
 {
 	unsigned long offset, vaddr;
 	resource_size_t pfn, last_pfn, last_addr;
@@ -172,6 +173,9 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		break;
 	}
 
+	if (readonly)
+		prot = __pgprot((unsigned long)prot.pgprot & ~_PAGE_RW);
+
 	/*
 	 * Ok, go for it..
 	 */
@@ -239,7 +243,7 @@ void __iomem *ioremap_nocache(resource_size_t phys_addr, unsigned long size)
 	enum page_cache_mode pcm = _PAGE_CACHE_MODE_UC_MINUS;
 
 	return __ioremap_caller(phys_addr, size, pcm,
-				__builtin_return_address(0));
+				__builtin_return_address(0), 0);
 }
 EXPORT_SYMBOL(ioremap_nocache);
 
@@ -272,7 +276,7 @@ void __iomem *ioremap_uc(resource_size_t phys_addr, unsigned long size)
 	enum page_cache_mode pcm = _PAGE_CACHE_MODE_UC;
 
 	return __ioremap_caller(phys_addr, size, pcm,
-				__builtin_return_address(0));
+				__builtin_return_address(0), 0);
 }
 EXPORT_SYMBOL_GPL(ioremap_uc);
 
@@ -289,7 +293,7 @@ EXPORT_SYMBOL_GPL(ioremap_uc);
 void __iomem *ioremap_wc(resource_size_t phys_addr, unsigned long size)
 {
 	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_MODE_WC,
-					__builtin_return_address(0));
+					__builtin_return_address(0), 0);
 }
 EXPORT_SYMBOL(ioremap_wc);
 
@@ -306,23 +310,30 @@ EXPORT_SYMBOL(ioremap_wc);
 void __iomem *ioremap_wt(resource_size_t phys_addr, unsigned long size)
 {
 	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_MODE_WT,
-					__builtin_return_address(0));
+					__builtin_return_address(0), 0);
 }
 EXPORT_SYMBOL(ioremap_wt);
 
 void __iomem *ioremap_cache(resource_size_t phys_addr, unsigned long size)
 {
 	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_MODE_WB,
-				__builtin_return_address(0));
+				__builtin_return_address(0), 0);
 }
 EXPORT_SYMBOL(ioremap_cache);
 
+void __iomem *ioremap_cache_ro(resource_size_t phys_addr, unsigned long size)
+{
+	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_MODE_WB,
+				__builtin_return_address(0), 1);
+}
+EXPORT_SYMBOL(ioremap_cache_ro);
+
 void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
 				unsigned long prot_val)
 {
 	return __ioremap_caller(phys_addr, size,
 				pgprot2cachemode(__pgprot(prot_val)),
-				__builtin_return_address(0));
+				__builtin_return_address(0), 0);
 }
 EXPORT_SYMBOL(ioremap_prot);
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index c544d466ea51..a6b29c731c53 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -35,6 +35,11 @@
 #include "pfn.h"
 #include "nd.h"
 
+int readonly;
+
+module_param(readonly, int, S_IRUGO);
+MODULE_PARM_DESC(readonly, "Mount readonly");
+
 static struct device *to_dev(struct pmem_device *pmem)
 {
 	/*
@@ -324,9 +329,14 @@ static int pmem_attach_disk(struct device *dev,
 		addr = devm_memremap_pages(dev, &nsio->res,
 				&q->q_usage_counter, NULL);
 		pmem->pfn_flags |= PFN_MAP;
-	} else
-		addr = devm_memremap(dev, pmem->phys_addr,
+	} else {
+		if (readonly == 0)
+			addr = devm_memremap(dev, pmem->phys_addr,
 				pmem->size, ARCH_MEMREMAP_PMEM);
+		else
+			addr = devm_memremap_ro(dev, pmem->phys_addr,
+				pmem->size, ARCH_MEMREMAP_PMEM);
+	}
 
 	/*
 	 * At release time the queue must be frozen before
diff --git a/include/linux/io.h b/include/linux/io.h
index 2195d9ea4aaa..00641aef9ab3 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -86,6 +86,8 @@ void devm_ioremap_release(struct device *dev, void *res);
 
 void *devm_memremap(struct device *dev, resource_size_t offset,
 		size_t size, unsigned long flags);
+void *devm_memremap_ro(struct device *dev, resource_size_t offset,
+		size_t size, unsigned long flags);
 void devm_memunmap(struct device *dev, void *addr);
 
 void *__devm_memremap_pages(struct device *dev, struct resource *res);
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 23a6483c3666..68371a9a40e5 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -162,6 +162,30 @@ void *devm_memremap(struct device *dev, resource_size_t offset,
 }
 EXPORT_SYMBOL(devm_memremap);
 
+void *devm_memremap_ro(struct device *dev, resource_size_t offset,
+		size_t size, unsigned long flags)
+{
+	void **ptr, *addr;
+
+	printk("%s\n", __func__);
+	ptr = devres_alloc_node(devm_memremap_release, sizeof(*ptr), GFP_KERNEL,
+			dev_to_node(dev));
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	addr = ioremap_cache_ro(offset, size);
+	if (addr) {
+		*ptr = addr;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+		return ERR_PTR(-ENXIO);
+	}
+
+	return addr;
+}
+EXPORT_SYMBOL(devm_memremap_ro);
+
 void devm_memunmap(struct device *dev, void *addr)
 {
 	WARN_ON(devres_release(dev, devm_memremap_release,
diff --git a/mm/memory.c b/mm/memory.c
index bb11c474857e..625623a90f08 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1793,7 +1793,7 @@ static int remap_pte_range(struct mm_struct *mm, pmd_t *pmd,
 		return -ENOMEM;
 	arch_enter_lazy_mmu_mode();
 	do {
-		BUG_ON(!pte_none(*pte));
+//		BUG_ON(!pte_none(*pte));
 		set_pte_at(mm, addr, pte, pte_mkspecial(pfn_pte(pfn, prot)));
 		pfn++;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
diff --git a/mm/mmap.c b/mm/mmap.c
index a5e3dcd75e79..5423e3340e59 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -126,6 +126,7 @@ void vma_set_page_prot(struct vm_area_struct *vma)
 	/* remove_protection_ptes reads vma->vm_page_prot without mmap_sem */
 	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
 }
+EXPORT_SYMBOL(vma_set_page_prot);
 
 /*
  * Requires inode->i_mapping->i_mmap_rwsem

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
