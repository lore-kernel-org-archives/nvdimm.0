Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F1F3A202E5318
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 13:37:55 -0800 (PST)
Subject: [PATCH 7/7] libnvdimm/pfn: Fix 'start_pad' implementation
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Feb 2019 13:25:17 -0800
Message-ID: <155000671719.348031.2347363160141119237.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In the beginning the pmem driver simply passed the persistent memory
resource range to memremap and was done. With the introduction of
devm_memremap_pages() and vmem_altmap the implementation needed to
contend with metadata at the start of the resource to indicate whether
the vmemmap is located in System RAM or Persistent Memory, and reserve
vmemmap capacity in pmem for the latter case.

The indication of metadata space was communicated in the
nd_pfn->data_offset property and it was defined to be identical to the
pmem_device->data_offset property, i.e. relative to the raw resource
base of the namespace. Up until this point in the driver's development
pmem_device->phys_addr == __pa(pmem_device->virt_addr). This
implementation was fine up until the discovery of platforms with
physical address layouts that mapped Persistent Memory and System RAM to
the same Linux memory hotplug section (128MB span).

The nd_pfn->start_pad and nd_pfn->end_trunc properties were introduced
to pad and truncate the capacity to fit within an exclusive Linux
memory hotplug section span, and it was at this point where the
->start_pad definition did not comprehend the pmem_device->phys_addr to
pmem_device->virt_addr relationship. Platforms in the wild typically
only collided 'System RAM' at the end of the Persistent Memory range so
->start_pad was often zero.

Lately Linux has encountered platforms that collide Persistent Memory
regions between each other, specifically cases where ->start_pad needed
to be non-zero. This lead to commit ae86cbfef381 "libnvdimm, pfn: Pad
pfn namespaces relative to other regions". That commit allowed
namespaces to be mapped with devm_memremap_pages(). However dax
operations on those configurations currently fail if attempted within the
->start_pad range because pmem_device->data_offset was still relative to
raw resource base not relative to the section aligned resource range
mapped by devm_memremap_pages().

Luckily __bdev_dax_supported() caught these failures and simply disabled
dax. However, to fix this situation a non-backwards compatible change
needs to be made to the interpretation of the nd_pfn info-block.
->start_pad needs to be accounted in ->map.map_offset (formerly
->data_offset), and ->map.map_base (formerly ->phys_addr) needs to be
adjusted to the section aligned resource base used to establish
->map.map formerly (formerly ->virt_addr).

The guiding principles of the info-block compatibility fixup is to
maintain the interpretation of ->data_offset for implementations like
the EFI driver that only care about data_access not dax, but cause older
Linux implementations that care about the mode and dax to fail to parse
the new info-block.

A unit test in ndctl is introduced to test the collision case going
forward as well as how new kernels interpret older info-block
configurations. Recall that the __bdev_dax_supported() checks have been
strengthened to catch more failure cases (changed in a previous patch)
and the new test caught several regressions in the course of developing
this fixed support.

Fixes: ae86cbfef381 ("libnvdimm, pfn: Pad pfn namespaces relative to other regions")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/nd.h       |    2 +
 drivers/nvdimm/pfn.h      |    2 -
 drivers/nvdimm/pfn_devs.c |  163 +++++++++++++++++++++++++++++----------------
 3 files changed, 109 insertions(+), 58 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 4339d338928b..7c33e7f7fae0 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -198,6 +198,8 @@ enum nd_pfn_mode {
 	PFN_MODE_NONE,
 	PFN_MODE_RAM,
 	PFN_MODE_PMEM,
+	PFN3_MODE_RAM,
+	PFN3_MODE_PMEM,
 };
 
 struct nd_pfn {
diff --git a/drivers/nvdimm/pfn.h b/drivers/nvdimm/pfn.h
index 710cb743fad6..53563a67c48d 100644
--- a/drivers/nvdimm/pfn.h
+++ b/drivers/nvdimm/pfn.h
@@ -20,7 +20,7 @@
 #define PFN_SIG_LEN 16
 #define PFN_SIG "NVDIMM_PFN_INFO\0"
 #define DAX_SIG "NVDIMM_DAX_INFO\0"
-#define PFN_VERSION_SUPPORT 2
+#define PFN_VERSION_SUPPORT 3
 
 struct nd_pfn_sb {
 	u8 signature[PFN_SIG_LEN];
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 1c2a0e707da3..56fa75a299b7 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -210,6 +210,36 @@ static ssize_t namespace_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(namespace);
 
+static u32 pfn_start_pad(struct nd_pfn *nd_pfn)
+{
+	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
+
+	/* starting v1.3 start_pad is accounted in dataoff */
+	if (__le16_to_cpu(pfn_sb->version_minor) < 3)
+		return __le32_to_cpu(pfn_sb->start_pad);
+	return 0;
+}
+
+/*
+ * Where does data start relative to the start of the namespace resource
+ * base?
+ */
+static u64 pfn_dataoff(struct nd_pfn *nd_pfn)
+{
+	return __le64_to_cpu(nd_pfn->pfn_sb->dataoff);
+}
+
+/*
+ * How much of the namespace resource capacity is taking up by padding,
+ * outside of what is accounted in the data_offset?
+ */
+static u32 pfn_pad(struct nd_pfn *nd_pfn)
+{
+	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
+
+	return pfn_start_pad(nd_pfn) + __le32_to_cpu(pfn_sb->end_trunc);
+}
+
 static ssize_t resource_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -218,14 +248,11 @@ static ssize_t resource_show(struct device *dev,
 
 	device_lock(dev);
 	if (dev->driver) {
-		struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
-		u64 offset = __le64_to_cpu(pfn_sb->dataoff);
 		struct nd_namespace_common *ndns = nd_pfn->ndns;
-		u32 start_pad = __le32_to_cpu(pfn_sb->start_pad);
 		struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 
 		rc = sprintf(buf, "%#llx\n", (unsigned long long) nsio->res.start
-				+ start_pad + offset);
+				+ pfn_dataoff(nd_pfn) + pfn_start_pad(nd_pfn));
 	} else {
 		/* no address to convey if the pfn instance is disabled */
 		rc = -ENXIO;
@@ -244,16 +271,12 @@ static ssize_t size_show(struct device *dev,
 
 	device_lock(dev);
 	if (dev->driver) {
-		struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
-		u64 offset = __le64_to_cpu(pfn_sb->dataoff);
 		struct nd_namespace_common *ndns = nd_pfn->ndns;
-		u32 start_pad = __le32_to_cpu(pfn_sb->start_pad);
-		u32 end_trunc = __le32_to_cpu(pfn_sb->end_trunc);
 		struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 
 		rc = sprintf(buf, "%llu\n", (unsigned long long)
-				resource_size(&nsio->res) - start_pad
-				- end_trunc - offset);
+				resource_size(&nsio->res) - pfn_dataoff(nd_pfn)
+				- pfn_pad(nd_pfn));
 	} else {
 		/* no size to convey if the pfn instance is disabled */
 		rc = -ENXIO;
@@ -422,10 +445,10 @@ static int nd_pfn_clear_memmap_errors(struct nd_pfn *nd_pfn)
 
 int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 {
+	unsigned long align;
 	u64 checksum, offset;
 	enum nd_pfn_mode mode;
 	struct nd_namespace_io *nsio;
-	unsigned long align, start_pad;
 	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
 	const u8 *parent_uuid = nd_dev_to_uuid(&ndns->dev);
@@ -465,20 +488,29 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	if (__le16_to_cpu(pfn_sb->min_version) > PFN_VERSION_SUPPORT)
 		return -EINVAL;
 
-	switch (le32_to_cpu(pfn_sb->mode)) {
+	mode = le32_to_cpu(pfn_sb->mode);
+	/*
+	 * PFN3_MODEs are used to make older Linux implementations fail
+	 * to parse the info-block.
+	 */
+	switch (mode) {
 	case PFN_MODE_RAM:
 	case PFN_MODE_PMEM:
 		break;
+	case PFN3_MODE_RAM:
+		mode = PFN_MODE_RAM;
+		break;
+	case PFN3_MODE_PMEM:
+		mode = PFN_MODE_PMEM;
+		break;
 	default:
 		return -ENXIO;
 	}
 
 	align = le32_to_cpu(pfn_sb->align);
 	offset = le64_to_cpu(pfn_sb->dataoff);
-	start_pad = le32_to_cpu(pfn_sb->start_pad);
 	if (align == 0)
 		align = 1UL << ilog2(offset);
-	mode = le32_to_cpu(pfn_sb->mode);
 
 	if (!nd_pfn->uuid) {
 		/*
@@ -534,7 +566,8 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 		return -EBUSY;
 	}
 
-	if ((align && !IS_ALIGNED(nsio->res.start + offset + start_pad, align))
+	if ((align && !IS_ALIGNED(nsio->res.start + offset
+					+ pfn_start_pad(nd_pfn), align))
 			|| !IS_ALIGNED(offset, PAGE_SIZE)) {
 		dev_err(&nd_pfn->dev,
 				"bad offset: %#llx dax disabled align: %#lx\n",
@@ -586,31 +619,23 @@ int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns)
 }
 EXPORT_SYMBOL(nd_pfn_probe);
 
-static u32 info_block_reserve(void)
+static u32 info_block_reserve(u32 start_pad)
 {
-	return ALIGN(SZ_8K, PAGE_SIZE);
+	u32 reserve = ALIGN(SZ_8K, PAGE_SIZE);
+
+	/*
+	 * Does the start_pad subsume the info-block at the start of the
+	 * raw resource base?
+	 */
+	if (start_pad <= reserve)
+		return reserve - start_pad;
+	return 0;
 }
 
 /*
  * We hotplug memory at section granularity, pad the reserved area from
  * the previous section base to the namespace base address.
  */
-static unsigned long init_altmap_base(resource_size_t base)
-{
-	unsigned long base_pfn = PHYS_PFN(base);
-
-	return PFN_SECTION_ALIGN_DOWN(base_pfn);
-}
-
-static unsigned long init_altmap_reserve(resource_size_t base)
-{
-	unsigned long reserve = info_block_reserve() >> PAGE_SHIFT;
-	unsigned long base_pfn = PHYS_PFN(base);
-
-	reserve += base_pfn - PFN_SECTION_ALIGN_DOWN(base_pfn);
-	return reserve;
-}
-
 static int __nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap,
 		struct pfn_map_info *mi)
 {
@@ -618,31 +643,39 @@ static int __nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap,
 	struct vmem_altmap *altmap = &pgmap->altmap;
 	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
 	u64 offset = le64_to_cpu(pfn_sb->dataoff);
-	u32 start_pad = __le32_to_cpu(pfn_sb->start_pad);
+	u32 start_pad = __le32_to_cpu(pfn_sb->start_pad), map_start_pad;
 	u32 end_trunc = __le32_to_cpu(pfn_sb->end_trunc);
-	u32 reserve = info_block_reserve();
+	u32 reserve = info_block_reserve(start_pad);
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 	resource_size_t base = nsio->res.start + start_pad;
+	struct device *dev = &nd_pfn->dev;
 	struct vmem_altmap __altmap = {
-		.base_pfn = init_altmap_base(base),
-		.reserve = init_altmap_reserve(base),
+		.base_pfn = PHYS_PFN(base),
+		.reserve = PHYS_PFN(reserve),
 	};
 
 	memcpy(res, &nsio->res, sizeof(*res));
 	res->start += start_pad;
 	res->end -= end_trunc;
 
+	/*
+	 * map_start_pad is adjusted to 0 for pre-v1.3 infoblocks to
+	 * preserve a bug in the implementation that can only be fixed
+	 * by migrating to a v1.3+ configuration.
+	 *
+	 * Post v1.3 start_pad is accounted in ->data_offset, and
+	 * ensures that:
+	 *     __va(map_base) == __pa(map)
+	 *
+	 * map_pad is only non-zero when ensuring backwards
+	 * compatibility with pre-v1.3 configurations.
+	 */
+	map_start_pad = start_pad - pfn_start_pad(nd_pfn);
 	*mi = (struct pfn_map_info) {
-		/*
-		 * TODO fix implementation to properly account for
-		 * 'start_pad' in map_base, and map_offset. As is, the
-		 * fact that __va(map_base) != __pa(map) leads
-		 * mistranslations in pmem_direct_access().
-		 */
-		.map_base = nsio->res.start,
-		.map_pad = start_pad,
-		.map_offset = offset,
+		.map_base = nsio->res.start + map_start_pad,
+		.map_pad = pfn_start_pad(nd_pfn),
+		.map_offset = offset - map_start_pad,
 		.map_size = resource_size(res),
 	};
 
@@ -653,14 +686,14 @@ static int __nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap,
 		pgmap->altmap_valid = false;
 	} else if (nd_pfn->mode == PFN_MODE_PMEM) {
 		nd_pfn->npfns = PFN_SECTION_ALIGN_UP((resource_size(res)
+					- pfn_start_pad(nd_pfn)
 					- offset) / PAGE_SIZE);
 		if (le64_to_cpu(nd_pfn->pfn_sb->npfns) > nd_pfn->npfns)
-			dev_info(&nd_pfn->dev,
-					"number of pfns truncated from %lld to %ld\n",
+			dev_info(dev, "number of pfns truncated from %lld to %ld\n",
 					le64_to_cpu(nd_pfn->pfn_sb->npfns),
 					nd_pfn->npfns);
 		memcpy(altmap, &__altmap, sizeof(*altmap));
-		altmap->free = PHYS_PFN(offset - reserve);
+		altmap->free = PHYS_PFN(mi->map_offset - reserve);
 		altmap->alloc = 0;
 		pgmap->altmap_valid = true;
 	} else
@@ -712,7 +745,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 {
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
-	u32 start_pad, end_trunc, reserve = info_block_reserve();
+	u32 start_pad, end_trunc, reserve;
 	resource_size_t start, size;
 	struct nd_region *nd_region;
 	struct nd_pfn_sb *pfn_sb;
@@ -750,6 +783,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	if (start_pad + end_trunc)
 		dev_info(&nd_pfn->dev, "%s alignment collision, truncate %d bytes\n",
 				dev_name(&ndns->dev), start_pad + end_trunc);
+	reserve = info_block_reserve(start_pad);
 
 	/*
 	 * Note, we use 64 here for the standard size of struct page,
@@ -769,29 +803,44 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 		 */
 		offset = ALIGN(start + reserve + 64 * npfns,
 				max(nd_pfn->align, PMD_SIZE)) - start;
-	} else if (nd_pfn->mode == PFN_MODE_RAM)
+		offset += start_pad;
+	} else if (nd_pfn->mode == PFN_MODE_RAM) {
 		offset = ALIGN(start + reserve, nd_pfn->align) - start;
-	else
+		offset += start_pad;
+	} else
 		return -ENXIO;
 
-	if (offset + start_pad + end_trunc >= size) {
+	if (offset + end_trunc >= size) {
 		dev_err(&nd_pfn->dev, "%s unable to satisfy requested alignment\n",
 				dev_name(&ndns->dev));
 		return -ENXIO;
 	}
 
-	npfns = (size - offset - start_pad - end_trunc) / SZ_4K;
-	pfn_sb->mode = cpu_to_le32(nd_pfn->mode);
+
+	npfns = (size - offset - end_trunc) / SZ_4K;
+
 	pfn_sb->dataoff = cpu_to_le64(offset);
 	pfn_sb->npfns = cpu_to_le64(npfns);
 	memcpy(pfn_sb->signature, sig, PFN_SIG_LEN);
 	memcpy(pfn_sb->uuid, nd_pfn->uuid, 16);
 	memcpy(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16);
 	pfn_sb->version_major = cpu_to_le16(1);
-	pfn_sb->version_minor = cpu_to_le16(2);
-	pfn_sb->min_version = cpu_to_le16(2);
 	pfn_sb->start_pad = cpu_to_le32(start_pad);
 	pfn_sb->end_trunc = cpu_to_le32(end_trunc);
+	if (start_pad) {
+		/*
+		 * Require implementations to account for start_pad in
+		 * data_offset. Use PFN3_MODE to cause versions older
+		 * than the introduction of min_version to fail.
+		 */
+		pfn_sb->mode = cpu_to_le32(nd_pfn->mode + 2);
+		pfn_sb->version_minor = cpu_to_le16(3);
+		pfn_sb->min_version = cpu_to_le16(3);
+	} else {
+		pfn_sb->mode = cpu_to_le32(nd_pfn->mode);
+		pfn_sb->version_minor = cpu_to_le16(2);
+		pfn_sb->min_version = cpu_to_le16(2);
+	}
 	pfn_sb->align = cpu_to_le32(nd_pfn->align);
 	checksum = nd_sb_checksum((struct nd_gen_sb *) pfn_sb);
 	pfn_sb->checksum = cpu_to_le64(checksum);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
