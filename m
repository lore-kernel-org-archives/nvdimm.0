Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 09/25] arm: switch from ioremap_cache to memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jul 2015 22:38:48 -0400
Message-ID: <20150725023848.8664.36275.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for deprecating ioremap_cache() convert its usage in
arch/arm[64]/ to memremap.

Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/include/asm/xen/page.h    |    4 ++--
 arch/arm64/include/asm/acpi.h      |    5 +----
 arch/arm64/include/asm/dmi.h       |    8 ++++----
 arch/arm64/kernel/efi.c            |    9 +++++----
 arch/arm64/kernel/smp_spin_table.c |   19 +++++++++----------
 5 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
index 1bee8ca12494..59c966e51af7 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -103,8 +103,8 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 	return __set_phys_to_machine(pfn, mfn);
 }
 
-#define xen_remap(cookie, size) ioremap_cache((cookie), (size))
-#define xen_unmap(cookie) iounmap((cookie))
+#define xen_remap(cookie, size) memremap((cookie), (size), MEMREMAP_CACHE)
+#define xen_unmap(cookie) memunmap((cookie))
 
 bool xen_arch_need_swiotlb(struct device *dev,
 			   unsigned long pfn,
diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 406485ed110a..5d7e46a1efdb 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -33,10 +33,7 @@
 static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
 					    acpi_size size)
 {
-	if (!page_is_ram(phys >> PAGE_SHIFT))
-		return ioremap(phys, size);
-
-	return ioremap_cache(phys, size);
+	return memremap(phys, size, MEMREMAP_CACHE);
 }
 #define acpi_os_ioremap acpi_os_ioremap
 
diff --git a/arch/arm64/include/asm/dmi.h b/arch/arm64/include/asm/dmi.h
index 69d37d87b159..f3dae56c50da 100644
--- a/arch/arm64/include/asm/dmi.h
+++ b/arch/arm64/include/asm/dmi.h
@@ -22,10 +22,10 @@
  * request a virtual mapping for configuration tables such as SMBIOS.
  * This means we have to map them before use.
  */
-#define dmi_early_remap(x, l)		ioremap_cache(x, l)
-#define dmi_early_unmap(x, l)		iounmap(x)
-#define dmi_remap(x, l)			ioremap_cache(x, l)
-#define dmi_unmap(x)			iounmap(x)
+#define dmi_early_remap(x, l)		memremap(x, l, MEMREMAP_CACHE)
+#define dmi_early_unmap(x, l)		memunmap(x)
+#define dmi_remap(x, l)			memremap(x, l, MEMREMAP_CACHE)
+#define dmi_unmap(x)			memunmap(x)
 #define dmi_alloc(l)			kzalloc(l, GFP_KERNEL)
 
 #endif
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 9d4aa18f2a82..f0d6688cd62c 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -26,6 +26,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/io.h>
 
 #include <asm/cacheflush.h>
 #include <asm/efi.h>
@@ -290,8 +291,8 @@ static int __init arm64_enable_runtime_services(void)
 	pr_info("Remapping and enabling EFI services.\n");
 
 	mapsize = memmap.map_end - memmap.map;
-	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
-						   mapsize);
+	memmap.map = memremap((phys_addr_t) memmap.phys_map, mapsize,
+			MEMREMAP_CACHE);
 	if (!memmap.map) {
 		pr_err("Failed to remap EFI memory map\n");
 		return -1;
@@ -299,8 +300,8 @@ static int __init arm64_enable_runtime_services(void)
 	memmap.map_end = memmap.map + mapsize;
 	efi.memmap = &memmap;
 
-	efi.systab = (__force void *)ioremap_cache(efi_system_table,
-						   sizeof(efi_system_table_t));
+	efi.systab = memremap(efi_system_table, sizeof(efi_system_table_t),
+			MEMREMAP_CACHE);
 	if (!efi.systab) {
 		pr_err("Failed to remap EFI System Table\n");
 		return -1;
diff --git a/arch/arm64/kernel/smp_spin_table.c b/arch/arm64/kernel/smp_spin_table.c
index aef3605a8c47..47da614f6215 100644
--- a/arch/arm64/kernel/smp_spin_table.c
+++ b/arch/arm64/kernel/smp_spin_table.c
@@ -21,11 +21,11 @@
 #include <linux/of.h>
 #include <linux/smp.h>
 #include <linux/types.h>
+#include <linux/io.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cpu_ops.h>
 #include <asm/cputype.h>
-#include <asm/io.h>
 #include <asm/smp_plat.h>
 
 extern void secondary_holding_pen(void);
@@ -73,19 +73,19 @@ static int smp_spin_table_cpu_init(unsigned int cpu)
 
 static int smp_spin_table_cpu_prepare(unsigned int cpu)
 {
-	__le64 __iomem *release_addr;
+	__le64 *release_addr;
 
 	if (!cpu_release_addr[cpu])
 		return -ENODEV;
 
 	/*
 	 * The cpu-release-addr may or may not be inside the linear mapping.
-	 * As ioremap_cache will either give us a new mapping or reuse the
-	 * existing linear mapping, we can use it to cover both cases. In
-	 * either case the memory will be MT_NORMAL.
+	 * As memremap will either give us a new mapping or reuse the existing
+	 * linear mapping, we can use it to cover both cases. In either case
+	 * the memory will be MT_NORMAL.
 	 */
-	release_addr = ioremap_cache(cpu_release_addr[cpu],
-				     sizeof(*release_addr));
+	release_addr = memremap(cpu_release_addr[cpu], sizeof(*release_addr),
+			MEMREMAP_CACHE);
 	if (!release_addr)
 		return -ENOMEM;
 
@@ -97,15 +97,14 @@ static int smp_spin_table_cpu_prepare(unsigned int cpu)
 	 * the boot protocol.
 	 */
 	writeq_relaxed(__pa(secondary_holding_pen), release_addr);
-	__flush_dcache_area((__force void *)release_addr,
-			    sizeof(*release_addr));
+	__flush_dcache_area(release_addr, sizeof(*release_addr));
 
 	/*
 	 * Send an event to wake up the secondary CPU.
 	 */
 	sev();
 
-	iounmap(release_addr);
+	memunmap(release_addr);
 
 	return 0;
 }

