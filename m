Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41AF34AB
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:32:45 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299433083"
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="299433083"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:39 -0700
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="511702726"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:39 -0700
From: ira.weiny@intel.com
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH V7 17/18] nvdimm/pmem: Enable stray access protection
Date: Tue,  3 Aug 2021 21:32:30 -0700
Message-Id: <20210804043231.2655537-18-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20210804043231.2655537-1-ira.weiny@intel.com>
References: <20210804043231.2655537-1-ira.weiny@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

Now that all potential / valid kernel initiated access' to PMEM have
been annotated with {__}pgmap_mk_{readwrite,noaccess}(), turn on
PGMAP_PROTECTION.

Implement the dax_protected which communicates this memory has extra
protection.  Also implement pmem_mk_{readwrite,noaccess}() to relax
those protections for valid users.

Internally, the pmem driver uses a cached virtual address,
pmem->virt_addr (pmem_addr).

Call __pgmap_mk_{readwrite,noaccess}() directly when PGMAP_PROTECTION is
active on the device.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes for V7
	Remove global param
	Add internal structure which uses the pmem device and pgmap
		device directly in the *_mk_*() calls.
	Add pmem dax ops callbacks
	Use pgmap_protection_enabled()
	s/PGMAP_PKEY_PROTECT/PGMAP_PROTECTION
---
 drivers/nvdimm/pmem.c | 55 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 1e0615b8565e..6e924b907264 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -138,6 +138,18 @@ static blk_status_t read_pmem(struct page *page, unsigned int off,
 	return BLK_STS_OK;
 }
 
+static void __pmem_mk_readwrite(struct pmem_device *pmem)
+{
+	if (pmem->pgmap.flags & PGMAP_PROTECTION)
+		__pgmap_mk_readwrite(&pmem->pgmap);
+}
+
+static void __pmem_mk_noaccess(struct pmem_device *pmem)
+{
+	if (pmem->pgmap.flags & PGMAP_PROTECTION)
+		__pgmap_mk_noaccess(&pmem->pgmap);
+}
+
 static blk_status_t pmem_do_read(struct pmem_device *pmem,
 			struct page *page, unsigned int page_off,
 			sector_t sector, unsigned int len)
@@ -149,7 +161,10 @@ static blk_status_t pmem_do_read(struct pmem_device *pmem,
 	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
 		return BLK_STS_IOERR;
 
+	__pmem_mk_readwrite(pmem);
 	rc = read_pmem(page, page_off, pmem_addr, len);
+	__pmem_mk_noaccess(pmem);
+
 	flush_dcache_page(page);
 	return rc;
 }
@@ -181,11 +196,14 @@ static blk_status_t pmem_do_write(struct pmem_device *pmem,
 	 * after clear poison.
 	 */
 	flush_dcache_page(page);
+
+	__pmem_mk_readwrite(pmem);
 	write_pmem(pmem_addr, page, page_off, len);
 	if (unlikely(bad_pmem)) {
 		rc = pmem_clear_poison(pmem, pmem_off, len);
 		write_pmem(pmem_addr, page, page_off, len);
 	}
+	__pmem_mk_noaccess(pmem);
 
 	return rc;
 }
@@ -320,6 +338,23 @@ static size_t pmem_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 	return _copy_mc_to_iter(addr, bytes, i);
 }
 
+static bool pmem_map_protected(struct dax_device *dax_dev)
+{
+	struct pmem_device *pmem = dax_get_private(dax_dev);
+
+	return (pmem->pgmap.flags & PGMAP_PROTECTION);
+}
+
+static void pmem_mk_readwrite(struct dax_device *dax_dev)
+{
+	__pmem_mk_readwrite(dax_get_private(dax_dev));
+}
+
+static void pmem_mk_noaccess(struct dax_device *dax_dev)
+{
+	__pmem_mk_noaccess(dax_get_private(dax_dev));
+}
+
 static const struct dax_operations pmem_dax_ops = {
 	.direct_access = pmem_dax_direct_access,
 	.dax_supported = generic_fsdax_supported,
@@ -328,6 +363,17 @@ static const struct dax_operations pmem_dax_ops = {
 	.zero_page_range = pmem_dax_zero_page_range,
 };
 
+static const struct dax_operations pmem_protected_dax_ops = {
+	.direct_access = pmem_dax_direct_access,
+	.dax_supported = generic_fsdax_supported,
+	.copy_from_iter = pmem_copy_from_iter,
+	.copy_to_iter = pmem_copy_to_iter,
+	.zero_page_range = pmem_dax_zero_page_range,
+	.map_protected = pmem_map_protected,
+	.mk_readwrite = pmem_mk_readwrite,
+	.mk_noaccess = pmem_mk_noaccess,
+};
+
 static const struct attribute_group *pmem_attribute_groups[] = {
 	&dax_attribute_group,
 	NULL,
@@ -432,6 +478,8 @@ static int pmem_attach_disk(struct device *dev,
 	if (is_nd_pfn(dev)) {
 		pmem->pgmap.type = MEMORY_DEVICE_FS_DAX;
 		pmem->pgmap.ops = &fsdax_pagemap_ops;
+		if (pgmap_protection_enabled())
+			pmem->pgmap.flags |= PGMAP_PROTECTION;
 		addr = devm_memremap_pages(dev, &pmem->pgmap);
 		pfn_sb = nd_pfn->pfn_sb;
 		pmem->data_offset = le64_to_cpu(pfn_sb->dataoff);
@@ -446,6 +494,8 @@ static int pmem_attach_disk(struct device *dev,
 		pmem->pgmap.nr_range = 1;
 		pmem->pgmap.type = MEMORY_DEVICE_FS_DAX;
 		pmem->pgmap.ops = &fsdax_pagemap_ops;
+		if (pgmap_protection_enabled())
+			pmem->pgmap.flags |= PGMAP_PROTECTION;
 		addr = devm_memremap_pages(dev, &pmem->pgmap);
 		pmem->pfn_flags |= PFN_MAP;
 		bb_range = pmem->pgmap.range;
@@ -483,7 +533,10 @@ static int pmem_attach_disk(struct device *dev,
 
 	if (is_nvdimm_sync(nd_region))
 		flags = DAXDEV_F_SYNC;
-	dax_dev = alloc_dax(pmem, disk->disk_name, &pmem_dax_ops, flags);
+	if (pmem->pgmap.flags & PGMAP_PROTECTION)
+		dax_dev = alloc_dax(pmem, disk->disk_name, &pmem_protected_dax_ops, flags);
+	else
+		dax_dev = alloc_dax(pmem, disk->disk_name, &pmem_dax_ops, flags);
 	if (IS_ERR(dax_dev)) {
 		return PTR_ERR(dax_dev);
 	}
-- 
2.28.0.rc0.12.gb6a658bd00c9

