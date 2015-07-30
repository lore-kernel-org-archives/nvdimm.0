Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 10/24] acpi: switch from ioremap_cache to memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Jul 2015 12:54:34 -0400
Message-ID: <20150730165433.33962.1046.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, mcgrof@suse.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Bob Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org, Lv Zheng <lv.zheng@intel.com>, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for deprecating ioremap_cache() convert its usage in
drivers/acpi and include/acpi/ to memremap.  This includes dropping the
__iomem annotation throughout ACPI since the memremap can be treated as
a normal memory pointer.

Finally, memremap automatically handles requests to map normal memory
pages, so this also drops the calls to "should_use_kmap()".

It seems ARM had a local definition of acpi_os_ioremap() to handle RAM
addresses, but it can be deleted now that memremap() handles this
generically.

Cc: Bob Moore <robert.moore@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm64/include/asm/acpi.h |    8 -----
 drivers/acpi/apei/einj.c      |    9 +++--
 drivers/acpi/apei/erst.c      |    6 ++--
 drivers/acpi/nvs.c            |    6 ++--
 drivers/acpi/osl.c            |   70 +++++++++++------------------------------
 include/acpi/acpi_io.h        |    6 +---
 6 files changed, 32 insertions(+), 73 deletions(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index fdccacd8f7bb..f9f3dcd2bffd 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -29,14 +29,6 @@
 
 /* Basic configuration for ACPI */
 #ifdef	CONFIG_ACPI
-/* ACPI table mapping after acpi_gbl_permanent_mmap is set */
-static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
-					    acpi_size size)
-{
-	return memremap(phys, size, MEMREMAP_WB);
-}
-#define acpi_os_ioremap acpi_os_ioremap
-
 typedef u64 phys_cpuid_t;
 #define PHYS_CPUID_INVALID INVALID_HWID
 
diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index a095d4f858da..270636220746 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -318,7 +318,8 @@ static int __einj_error_trigger(u64 trigger_paddr, u32 type,
 			    sizeof(*trigger_tab) - 1);
 		goto out;
 	}
-	trigger_tab = ioremap_cache(trigger_paddr, sizeof(*trigger_tab));
+	trigger_tab = memremap(trigger_paddr, sizeof(*trigger_tab),
+			MEMREMAP_WB);
 	if (!trigger_tab) {
 		pr_err(EINJ_PFX "Failed to map trigger table!\n");
 		goto out_rel_header;
@@ -346,8 +347,8 @@ static int __einj_error_trigger(u64 trigger_paddr, u32 type,
 		       (unsigned long long)trigger_paddr + table_size - 1);
 		goto out_rel_header;
 	}
-	iounmap(trigger_tab);
-	trigger_tab = ioremap_cache(trigger_paddr, table_size);
+	memunmap(trigger_tab);
+	trigger_tab = memremap(trigger_paddr, table_size, MEMREMAP_WB);
 	if (!trigger_tab) {
 		pr_err(EINJ_PFX "Failed to map trigger table!\n");
 		goto out_rel_entry;
@@ -409,7 +410,7 @@ out_rel_header:
 	release_mem_region(trigger_paddr, sizeof(*trigger_tab));
 out:
 	if (trigger_tab)
-		iounmap(trigger_tab);
+		memunmap(trigger_tab);
 
 	return rc;
 }
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 3670bbab57a3..569237176e18 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -77,7 +77,7 @@ static struct acpi_table_erst *erst_tab;
 static struct erst_erange {
 	u64 base;
 	u64 size;
-	void __iomem *vaddr;
+	void *vaddr;
 	u32 attr;
 } erst_erange;
 
@@ -1185,8 +1185,8 @@ static int __init erst_init(void)
 		goto err_unmap_reg;
 	}
 	rc = -ENOMEM;
-	erst_erange.vaddr = ioremap_cache(erst_erange.base,
-					  erst_erange.size);
+	erst_erange.vaddr = memremap(erst_erange.base, erst_erange.size,
+			MEMREMAP_WB);
 	if (!erst_erange.vaddr)
 		goto err_release_erange;
 
diff --git a/drivers/acpi/nvs.c b/drivers/acpi/nvs.c
index 85287b8fe3aa..e0e15af93b22 100644
--- a/drivers/acpi/nvs.c
+++ b/drivers/acpi/nvs.c
@@ -136,7 +136,7 @@ void suspend_nvs_free(void)
 			entry->data = NULL;
 			if (entry->kaddr) {
 				if (entry->unmap) {
-					iounmap(entry->kaddr);
+					memunmap(entry->kaddr);
 					entry->unmap = false;
 				} else {
 					acpi_os_unmap_iomem(entry->kaddr,
@@ -180,7 +180,7 @@ int suspend_nvs_save(void)
 
 			entry->kaddr = acpi_os_get_iomem(phys, size);
 			if (!entry->kaddr) {
-				entry->kaddr = acpi_os_ioremap(phys, size);
+				entry->kaddr = acpi_os_memremap(phys, size);
 				entry->unmap = !!entry->kaddr;
 			}
 			if (!entry->kaddr) {
@@ -197,7 +197,7 @@ int suspend_nvs_save(void)
  *	suspend_nvs_restore - restore NVS memory regions
  *
  *	This function is going to be called with interrupts disabled, so it
- *	cannot iounmap the virtual addresses used to access the NVS region.
+ *	cannot memunmap the virtual addresses used to access the NVS region.
  */
 void suspend_nvs_restore(void)
 {
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 3b8963f21b36..9d5242179b74 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -31,7 +31,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/highmem.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/kmod.h>
@@ -44,8 +43,8 @@
 #include <linux/list.h>
 #include <linux/jiffies.h>
 #include <linux/semaphore.h>
+#include <linux/io.h>
 
-#include <asm/io.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -90,7 +89,7 @@ static struct workqueue_struct *kacpi_hotplug_wq;
  */
 struct acpi_ioremap {
 	struct list_head list;
-	void __iomem *virt;
+	void *virt;
 	acpi_physical_address phys;
 	acpi_size size;
 	unsigned long refcount;
@@ -294,7 +293,7 @@ acpi_map_lookup(acpi_physical_address phys, acpi_size size)
 }
 
 /* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
-static void __iomem *
+static void *
 acpi_map_vaddr_lookup(acpi_physical_address phys, unsigned int size)
 {
 	struct acpi_ioremap *map;
@@ -306,10 +305,10 @@ acpi_map_vaddr_lookup(acpi_physical_address phys, unsigned int size)
 	return NULL;
 }
 
-void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size)
+void *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size)
 {
 	struct acpi_ioremap *map;
-	void __iomem *virt = NULL;
+	void *virt = NULL;
 
 	mutex_lock(&acpi_ioremap_lock);
 	map = acpi_map_lookup(phys, size);
@@ -324,7 +323,7 @@ EXPORT_SYMBOL_GPL(acpi_os_get_iomem);
 
 /* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
 static struct acpi_ioremap *
-acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
+acpi_map_lookup_virt(void *virt, acpi_size size)
 {
 	struct acpi_ioremap *map;
 
@@ -336,44 +335,13 @@ acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
 	return NULL;
 }
 
-#if defined(CONFIG_IA64) || defined(CONFIG_ARM64)
-/* ioremap will take care of cache attributes */
-#define should_use_kmap(pfn)   0
-#else
-#define should_use_kmap(pfn)   page_is_ram(pfn)
-#endif
-
-static void __iomem *acpi_map(acpi_physical_address pg_off, unsigned long pg_sz)
-{
-	unsigned long pfn;
-
-	pfn = pg_off >> PAGE_SHIFT;
-	if (should_use_kmap(pfn)) {
-		if (pg_sz > PAGE_SIZE)
-			return NULL;
-		return (void __iomem __force *)kmap(pfn_to_page(pfn));
-	} else
-		return acpi_os_ioremap(pg_off, pg_sz);
-}
-
-static void acpi_unmap(acpi_physical_address pg_off, void __iomem *vaddr)
-{
-	unsigned long pfn;
-
-	pfn = pg_off >> PAGE_SHIFT;
-	if (should_use_kmap(pfn))
-		kunmap(pfn_to_page(pfn));
-	else
-		iounmap(vaddr);
-}
-
-void __iomem *__init_refok
+void *__init_refok
 acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 {
 	struct acpi_ioremap *map;
-	void __iomem *virt;
 	acpi_physical_address pg_off;
 	acpi_size pg_sz;
+	void *virt;
 
 	if (phys > ULONG_MAX) {
 		printk(KERN_ERR PREFIX "Cannot map memory that high\n");
@@ -399,7 +367,7 @@ acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 
 	pg_off = round_down(phys, PAGE_SIZE);
 	pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
-	virt = acpi_map(pg_off, pg_sz);
+	virt = acpi_os_memremap(pg_off, pg_sz);
 	if (!virt) {
 		mutex_unlock(&acpi_ioremap_lock);
 		kfree(map);
@@ -437,7 +405,7 @@ static void acpi_os_map_cleanup(struct acpi_ioremap *map)
 {
 	if (!map->refcount) {
 		synchronize_rcu_expedited();
-		acpi_unmap(map->phys, map->virt);
+		memunmap(map->virt);
 		kfree(map);
 	}
 }
@@ -965,7 +933,7 @@ static inline u64 read64(const volatile void __iomem *addr)
 acpi_status
 acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
 {
-	void __iomem *virt_addr;
+	void *virt_addr;
 	unsigned int size = width / 8;
 	bool unmap = false;
 	u64 dummy;
@@ -974,7 +942,7 @@ acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
 	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
 	if (!virt_addr) {
 		rcu_read_unlock();
-		virt_addr = acpi_os_ioremap(phys_addr, size);
+		virt_addr = acpi_os_memremap(phys_addr, size);
 		if (!virt_addr)
 			return AE_BAD_ADDRESS;
 		unmap = true;
@@ -985,23 +953,23 @@ acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
 
 	switch (width) {
 	case 8:
-		*(u8 *) value = readb(virt_addr);
+		*(u8 *) value = *(u8 *) virt_addr;
 		break;
 	case 16:
-		*(u16 *) value = readw(virt_addr);
+		*(u16 *) value = *(u16 *) virt_addr;
 		break;
 	case 32:
-		*(u32 *) value = readl(virt_addr);
+		*(u32 *) value = *(u32 *) virt_addr;
 		break;
 	case 64:
-		*(u64 *) value = read64(virt_addr);
+		*(u64 *) value = *(u64 *) virt_addr;
 		break;
 	default:
 		BUG();
 	}
 
 	if (unmap)
-		iounmap(virt_addr);
+		memunmap(virt_addr);
 	else
 		rcu_read_unlock();
 
@@ -1032,7 +1000,7 @@ acpi_os_write_memory(acpi_physical_address phys_addr, u64 value, u32 width)
 	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
 	if (!virt_addr) {
 		rcu_read_unlock();
-		virt_addr = acpi_os_ioremap(phys_addr, size);
+		virt_addr = acpi_os_memremap(phys_addr, size);
 		if (!virt_addr)
 			return AE_BAD_ADDRESS;
 		unmap = true;
@@ -1056,7 +1024,7 @@ acpi_os_write_memory(acpi_physical_address phys_addr, u64 value, u32 width)
 	}
 
 	if (unmap)
-		iounmap(virt_addr);
+		memunmap(virt_addr);
 	else
 		rcu_read_unlock();
 
diff --git a/include/acpi/acpi_io.h b/include/acpi/acpi_io.h
index dd86c5fc102d..646ce8714109 100644
--- a/include/acpi/acpi_io.h
+++ b/include/acpi/acpi_io.h
@@ -5,13 +5,11 @@
 
 #include <asm/acpi.h>
 
-#ifndef acpi_os_ioremap
-static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
+static inline void *acpi_os_memremap(acpi_physical_address phys,
 					    acpi_size size)
 {
-       return ioremap_cache(phys, size);
+       return memremap(phys, size, MEMREMAP_WB);
 }
-#endif
 
 void __iomem *__init_refok
 acpi_os_map_iomem(acpi_physical_address phys, acpi_size size);

