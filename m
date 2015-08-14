Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] nd_blk: add support for "read flush" DSM flag
Date: Fri, 14 Aug 2015 14:43:28 -0600
Message-Id: <1439585008-30192-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Christoph Jaeger <cj@linux.com>, Dan Streetman <ddstreet@ieee.org>, Ingo Molnar <mingo@redhat.com>, Juergen Gross <jgross@suse.com>, Len Brown <lenb@kernel.org>, Russell King <rmk+kernel@arm.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>, Will Deacon <will.deacon@arm.com>, Yalin Wang <Yalin.Wang@sonymobile.com>, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add support for the "read flush" _DSM flag, as outlined in the DSM spec:

http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf

This flag tells the ND BLK driver that it needs to flush the cache lines
associated with the aperture after the aperture is moved but before any
new data is read.  This ensures that any stale cache lines from the
previous contents of the aperture will be discarded from the processor
cache, and the new data will be read properly from the DIMM.  We know
that the cache lines are clean and will be discarded without any
writeback because either a) the previous aperture operation was a read,
and we never modified the contents of the aperture, or b) the previous
aperture operation was a write and we must have written back the dirtied
contents of the aperture to the DIMM before the I/O was completed.

By supporting the "read flush" flag we can also change the ND BLK
aperture mapping from write-combining to write-back via memremap().

In order to add support for the "read flush" flag I needed to add a
generic routine to invalidate cache lines, mmio_flush_range().  This is
protected by the ARCH_HAS_MMIO_FLUSH Kconfig variable, and is currently
only supported on x86.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 arch/x86/Kconfig                  |  1 +
 arch/x86/include/asm/cacheflush.h |  2 ++
 drivers/acpi/Kconfig              |  1 +
 drivers/acpi/nfit.c               | 55 ++++++++++++++++++++++-----------------
 drivers/acpi/nfit.h               | 16 ++++++++----
 lib/Kconfig                       |  3 +++
 6 files changed, 49 insertions(+), 29 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b3a1a5d..5d4980e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -28,6 +28,7 @@ config X86
 	select ARCH_HAS_FAST_MULTIPLIER
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_PMEM_API
+	select ARCH_HAS_MMIO_FLUSH
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_MIGHT_HAVE_ACPI_PDC		if ACPI
diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 9bf3ea1..7f3104f 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -89,6 +89,8 @@ int set_pages_rw(struct page *page, int numpages);
 
 void clflush_cache_range(void *addr, unsigned int size);
 
+#define mmio_flush_range(addr, size) clflush_cache_range(addr, size)
+
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
 extern const int rodata_test_data;
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 114cf48..4baeb85 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -410,6 +410,7 @@ config ACPI_NFIT
 	tristate "ACPI NVDIMM Firmware Interface Table (NFIT)"
 	depends on PHYS_ADDR_T_64BIT
 	depends on BLK_DEV
+	depends on ARCH_HAS_MMIO_FLUSH
 	select LIBNVDIMM
 	help
 	  Infrastructure to probe ACPI 6 compliant platforms for
diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 628a42c..816c778 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1032,7 +1032,7 @@ static u64 read_blk_stat(struct nfit_blk *nfit_blk, unsigned int bw)
 	if (mmio->num_lines)
 		offset = to_interleave_offset(offset, mmio);
 
-	return readq(mmio->base + offset);
+	return readq(mmio->addr.base + offset);
 }
 
 static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
@@ -1057,11 +1057,11 @@ static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
 	if (mmio->num_lines)
 		offset = to_interleave_offset(offset, mmio);
 
-	writeq(cmd, mmio->base + offset);
+	writeq(cmd, mmio->addr.base + offset);
 	wmb_blk(nfit_blk);
 
 	if (nfit_blk->dimm_flags & ND_BLK_DCR_LATCH)
-		readq(mmio->base + offset);
+		readq(mmio->addr.base + offset);
 }
 
 static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
@@ -1093,11 +1093,16 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
 		}
 
 		if (rw)
-			memcpy_to_pmem(mmio->aperture + offset,
+			memcpy_to_pmem(mmio->addr.aperture + offset,
 					iobuf + copied, c);
-		else
+		else {
+			if (nfit_blk->dimm_flags & ND_BLK_READ_FLUSH)
+				mmio_flush_range((void __force *)
+					mmio->addr.aperture + offset, c);
+
 			memcpy_from_pmem(iobuf + copied,
-					mmio->aperture + offset, c);
+					mmio->addr.aperture + offset, c);
+		}
 
 		copied += c;
 		len -= c;
@@ -1144,7 +1149,10 @@ static void nfit_spa_mapping_release(struct kref *kref)
 
 	WARN_ON(!mutex_is_locked(&acpi_desc->spa_map_mutex));
 	dev_dbg(acpi_desc->dev, "%s: SPA%d\n", __func__, spa->range_index);
-	iounmap(spa_map->iomem);
+	if (spa_map->type == SPA_MAP_APERTURE)
+		memunmap((void __force *)spa_map->addr.aperture);
+	else
+		iounmap(spa_map->addr.base);
 	release_mem_region(spa->address, spa->length);
 	list_del(&spa_map->list);
 	kfree(spa_map);
@@ -1190,7 +1198,7 @@ static void __iomem *__nfit_spa_map(struct acpi_nfit_desc *acpi_desc,
 	spa_map = find_spa_mapping(acpi_desc, spa);
 	if (spa_map) {
 		kref_get(&spa_map->kref);
-		return spa_map->iomem;
+		return spa_map->addr.base;
 	}
 
 	spa_map = kzalloc(sizeof(*spa_map), GFP_KERNEL);
@@ -1206,20 +1214,19 @@ static void __iomem *__nfit_spa_map(struct acpi_nfit_desc *acpi_desc,
 	if (!res)
 		goto err_mem;
 
-	if (type == SPA_MAP_APERTURE) {
-		/*
-		 * TODO: memremap_pmem() support, but that requires cache
-		 * flushing when the aperture is moved.
-		 */
-		spa_map->iomem = ioremap_wc(start, n);
-	} else
-		spa_map->iomem = ioremap_nocache(start, n);
+	spa_map->type = type;
+	if (type == SPA_MAP_APERTURE)
+		spa_map->addr.aperture = (void __pmem *)memremap(start, n,
+								MEMREMAP_WB);
+	else
+		spa_map->addr.base = ioremap_nocache(start, n);
+
 
-	if (!spa_map->iomem)
+	if (!spa_map->addr.base)
 		goto err_map;
 
 	list_add_tail(&spa_map->list, &acpi_desc->spa_maps);
-	return spa_map->iomem;
+	return spa_map->addr.base;
 
  err_map:
 	release_mem_region(start, n);
@@ -1282,7 +1289,7 @@ static int acpi_nfit_blk_get_flags(struct nvdimm_bus_descriptor *nd_desc,
 		nfit_blk->dimm_flags = flags.flags;
 	else if (rc == -ENOTTY) {
 		/* fall back to a conservative default */
-		nfit_blk->dimm_flags = ND_BLK_DCR_LATCH;
+		nfit_blk->dimm_flags = ND_BLK_DCR_LATCH | ND_BLK_READ_FLUSH;
 		rc = 0;
 	} else
 		rc = -ENXIO;
@@ -1322,9 +1329,9 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 	/* map block aperture memory */
 	nfit_blk->bdw_offset = nfit_mem->bdw->offset;
 	mmio = &nfit_blk->mmio[BDW];
-	mmio->base = nfit_spa_map(acpi_desc, nfit_mem->spa_bdw,
+	mmio->addr.base = nfit_spa_map(acpi_desc, nfit_mem->spa_bdw,
 			SPA_MAP_APERTURE);
-	if (!mmio->base) {
+	if (!mmio->addr.base) {
 		dev_dbg(dev, "%s: %s failed to map bdw\n", __func__,
 				nvdimm_name(nvdimm));
 		return -ENOMEM;
@@ -1345,9 +1352,9 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 	nfit_blk->cmd_offset = nfit_mem->dcr->command_offset;
 	nfit_blk->stat_offset = nfit_mem->dcr->status_offset;
 	mmio = &nfit_blk->mmio[DCR];
-	mmio->base = nfit_spa_map(acpi_desc, nfit_mem->spa_dcr,
+	mmio->addr.base = nfit_spa_map(acpi_desc, nfit_mem->spa_dcr,
 			SPA_MAP_CONTROL);
-	if (!mmio->base) {
+	if (!mmio->addr.base) {
 		dev_dbg(dev, "%s: %s failed to map dcr\n", __func__,
 				nvdimm_name(nvdimm));
 		return -ENOMEM;
@@ -1414,7 +1421,7 @@ static void acpi_nfit_blk_region_disable(struct nvdimm_bus *nvdimm_bus,
 	for (i = 0; i < 2; i++) {
 		struct nfit_blk_mmio *mmio = &nfit_blk->mmio[i];
 
-		if (mmio->base)
+		if (mmio->addr.base)
 			nfit_spa_unmap(acpi_desc, mmio->spa);
 	}
 	nd_blk_region_set_provider_data(ndbr, NULL);
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 79b6d83..fd7d41a 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -41,6 +41,7 @@ enum nfit_uuids {
 };
 
 enum {
+	ND_BLK_READ_FLUSH = 1,
 	ND_BLK_DCR_LATCH = 2,
 };
 
@@ -116,12 +117,16 @@ enum nd_blk_mmio_selector {
 	DCR,
 };
 
+struct nd_blk_addr {
+	union {
+		void __iomem *base;
+		void __pmem  *aperture;
+	};
+};
+
 struct nfit_blk {
 	struct nfit_blk_mmio {
-		union {
-			void __iomem *base;
-			void __pmem  *aperture;
-		};
+		struct nd_blk_addr addr;
 		u64 size;
 		u64 base_offset;
 		u32 line_size;
@@ -148,7 +153,8 @@ struct nfit_spa_mapping {
 	struct acpi_nfit_system_address *spa;
 	struct list_head list;
 	struct kref kref;
-	void __iomem *iomem;
+	enum spa_map_type type;
+	struct nd_blk_addr addr;
 };
 
 static inline struct nfit_spa_mapping *to_spa_map(struct kref *kref)
diff --git a/lib/Kconfig b/lib/Kconfig
index 3a2ef67..a938a39 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -531,4 +531,7 @@ config ARCH_HAS_SG_CHAIN
 config ARCH_HAS_PMEM_API
 	bool
 
+config ARCH_HAS_MMIO_FLUSH
+	bool
+
 endmenu
-- 
2.1.0

