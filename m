Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 7C2421A1F36
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 14:48:09 -0800 (PST)
Subject: [PATCH 3/3] libnvdimm, pmem: clear poison on write
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 08 Mar 2016 14:47:29 -0800
Message-ID: <20160308224729.16298.49406.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160308224713.16298.33547.stgit@dwillia2-desk3.jf.intel.com>
References: <20160308224713.16298.33547.stgit@dwillia2-desk3.jf.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

If a write is directed at a known bad block perform the following:

1/ write the data

2/ send a clear poison command

3/ invalidate the poison out of the cache hierarchy

Cc: <x86@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/pmem.h |    5 +++++
 drivers/nvdimm/bus.c        |   46 +++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd.h         |    2 ++
 drivers/nvdimm/pmem.c       |   29 ++++++++++++++++++++++++++-
 include/linux/pmem.h        |   19 ++++++++++++++++++
 5 files changed, 100 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index c57fd1ea9689..bf8b35d2035a 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -137,6 +137,11 @@ static inline void arch_clear_pmem(void __pmem *addr, size_t size)
 	arch_wb_cache_pmem(addr, size);
 }
 
+static inline void arch_invalidate_pmem(void __pmem *addr, size_t size)
+{
+	clflush_cache_range((void __force *) addr, size);
+}
+
 static inline bool __arch_has_wmb_pmem(void)
 {
 	/*
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index cb6fd64b13e3..33557481d452 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -159,6 +159,52 @@ void nvdimm_region_notify(struct nd_region *nd_region, enum nvdimm_event event)
 }
 EXPORT_SYMBOL_GPL(nvdimm_region_notify);
 
+long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
+		unsigned int len)
+{
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct nvdimm_bus_descriptor *nd_desc;
+	struct nd_cmd_clear_error clear_err;
+	struct nd_cmd_ars_cap ars_cap;
+	u32 clear_err_unit, mask;
+	int cmd_rc, rc;
+
+	if (!nvdimm_bus)
+		return -ENXIO;
+
+	nd_desc = nvdimm_bus->nd_desc;
+	if (!nd_desc->ndctl)
+		return -ENXIO;
+
+	memset(&ars_cap, 0, sizeof(ars_cap));
+	ars_cap.address = phys;
+	ars_cap.length = len;
+	rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_CAP, &ars_cap,
+			sizeof(ars_cap), &cmd_rc);
+	if (rc < 0)
+		return rc;
+	if (cmd_rc < 0)
+		return cmd_rc;
+	clear_err_unit = ars_cap.clear_err_unit;
+	if (!clear_err_unit || !is_power_of_2(clear_err_unit))
+		return -ENXIO;
+
+	mask = clear_err_unit - 1;
+	if ((phys | len) & mask)
+		return -ENXIO;
+	memset(&clear_err, 0, sizeof(clear_err));
+	clear_err.address = phys;
+	clear_err.length = len;
+	rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_CLEAR_ERROR, &clear_err,
+			sizeof(clear_err), &cmd_rc);
+	if (rc < 0)
+		return rc;
+	if (cmd_rc < 0)
+		return cmd_rc;
+	return clear_err.cleared;
+}
+EXPORT_SYMBOL_GPL(nvdimm_clear_poison);
+
 static struct bus_type nvdimm_bus_type = {
 	.name = "nd",
 	.uevent = nvdimm_bus_uevent,
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 78b82f6dd191..1799bd97a9ce 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -186,6 +186,8 @@ int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd);
 int nvdimm_init_config_data(struct nvdimm_drvdata *ndd);
 int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 		void *buf, size_t len);
+long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
+		unsigned int len);
 struct nd_btt *to_nd_btt(struct device *dev);
 
 struct nd_gen_sb {
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index e7b86a7fca0a..adc387236fe7 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -62,17 +62,40 @@ static bool is_bad_pmem(struct badblocks *bb, sector_t sector, unsigned int len)
 	return false;
 }
 
+static void pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
+		unsigned int len)
+{
+	struct device *dev = disk_to_dev(pmem->pmem_disk);
+	sector_t sector;
+	long cleared;
+
+	sector = (offset - pmem->data_offset) / 512;
+	cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
+
+	if (cleared > 0 && cleared / 512) {
+		dev_dbg(dev, "%s: %llx clear %ld sector%s\n",
+				__func__, (unsigned long long) sector,
+				cleared / 512, cleared / 512 > 1 ? "s" : "");
+		badblocks_clear(&pmem->bb, sector, cleared / 512);
+	}
+	invalidate_pmem(pmem->virt_addr + offset, len);
+}
+
 static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 			unsigned int len, unsigned int off, int rw,
 			sector_t sector)
 {
 	int rc = 0;
+	bool bad_pmem = false;
 	void *mem = kmap_atomic(page);
 	phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
 	void __pmem *pmem_addr = pmem->virt_addr + pmem_off;
 
+	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
+		bad_pmem = true;
+
 	if (rw == READ) {
-		if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
+		if (unlikely(bad_pmem))
 			rc = -EIO;
 		else {
 			memcpy_from_pmem(mem + off, pmem_addr, len);
@@ -81,6 +104,10 @@ static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 	} else {
 		flush_dcache_page(page);
 		memcpy_to_pmem(pmem_addr, mem + off, len);
+		if (unlikely(bad_pmem)) {
+			pmem_clear_poison(pmem, pmem_off, len);
+			memcpy_to_pmem(pmem_addr, mem + off, len);
+		}
 	}
 
 	kunmap_atomic(mem);
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index 7c3d11a6b4ad..3ec5309e29f3 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -58,6 +58,11 @@ static inline void arch_wb_cache_pmem(void __pmem *addr, size_t size)
 {
 	BUG();
 }
+
+static inline void arch_invalidate_pmem(void __pmem *addr, size_t size)
+{
+	BUG();
+}
 #endif
 
 /*
@@ -186,6 +191,20 @@ static inline void clear_pmem(void __pmem *addr, size_t size)
 }
 
 /**
+ * invalidate_pmem - flush a pmem range from the cache hierarchy
+ * @addr:	virtual start address
+ * @size:	bytes to invalidate (internally aligned to cache line size)
+ *
+ * For platforms that support clearing poison this flushes any poisoned
+ * ranges out of the cache
+ */
+static inline void invalidate_pmem(void __pmem *addr, size_t size)
+{
+	if (arch_has_pmem_api())
+		arch_invalidate_pmem(addr, size);
+}
+
+/**
  * wb_cache_pmem - write back processor cache for PMEM memory range
  * @addr:	virtual start address
  * @size:	number of bytes to write back

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
