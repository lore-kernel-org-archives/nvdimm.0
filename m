Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9318E18FC89
	for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 18:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731696398; cv=none; b=KvyB9wzPdL4hRnZBOtPLUbrM9Npv14gCsDgTJ//oQlUqYapZPjNgscbYIsXWS4nhmLjRz85N+yXG7N6GAcFFX0/gKcYzVwKHHieCz/f7kAxjcdfWYqRwzo2CvRAyZYSVONOyGPEpYeGyPCIODPPhHMvAyukYGm5uLsjpGzeme+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731696398; c=relaxed/simple;
	bh=YmJ3GPJfG2ZcPPrwjtNyeIKNB8tHqC8nBIvqPi44NMc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZQuYamCSZSZDOYPtOYScm51kTx8HT/0GWxxNxNvJ1p/lVF8mopgFZCti3vFSwBjQJgVUEt9t32nAgULkzEssQE0IobQ1JxpyAus42hQPPsbfZv6k51/x0ORddyM5BXYogiB52B/+TBpR7jRJI7m4o/NGNGIQOHBZPUq5vpGYqno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BcACeeEA; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BcACeeEA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731696397; x=1763232397;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=YmJ3GPJfG2ZcPPrwjtNyeIKNB8tHqC8nBIvqPi44NMc=;
  b=BcACeeEAO/wjdR3zaK3zkU7nGlOvXDjTepPxv3HfRcp+nare3EC8EO+y
   q1SxWQkBemofQlN0AOAOxAu65/FEYxslytWaJcwjdIIglfm4+qIsRCfu8
   a+E4ZdA4t7beaC7N3keQwBiUiE96kgbjp+VxynKNa5uAr9huq8xq80a00
   WCjgxGh5YWkrvrXJ2YJNkfO44MV1+ve1U7HMyJ/5BZDfpsH5nMS4EpzCu
   hMMtNywY0a6pCWrBnP3TfjlvhV3GuIgWizTXm+H73SH1X7VDZccwxRrTl
   pNt7v1rl3iuxG1HNi4phcojXeZqvNef18qT/HXTRfjMkgil1In4QpdnEP
   w==;
X-CSE-ConnectionGUID: t1VbxZPxTxqXLBmMXeKNug==
X-CSE-MsgGUID: 5cLzuOSxTSOlAPYVK0ypUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="31848468"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="31848468"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:46:35 -0800
X-CSE-ConnectionGUID: bIu2oi79T3yqUwSn06abSA==
X-CSE-MsgGUID: JLWALOFjS76dlVuwyyNxtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="89392887"
Received: from ehanks-mobl1.amr.corp.intel.com (HELO localhost) ([10.125.108.112])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:46:34 -0800
From: ira.weiny@intel.com
Date: Fri, 15 Nov 2024 12:46:23 -0600
Subject: [ndctl PATCH v3 5/9] libcxl: Add Dynamic Capacity region support
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241115-dcd-region2-v3-5-585d480ccdab@intel.com>
References: <20241115-dcd-region2-v3-0-585d480ccdab@intel.com>
In-Reply-To: <20241115-dcd-region2-v3-0-585d480ccdab@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>, Sushant1 Kumar <sushant1.kumar@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731696382; l=16640;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=k4ri6zLhmakcgPtxLGqpICruyufD9Ijx1p8zKJmXfkk=;
 b=U34EsI+XNd8QUJQJn33SCSAw24Ca3LRRxMB5gBh9A8Ej8rG3BgCl9nRV9EFH2ncgMk4oG69nr
 XgJy3NFFy/XDdeRshAmhhm+zbr7VhvzzXrwRuIkbysgtuVL9zEYsbFS
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

CXL Dynamic Capacity Devices (DCDs) optionally support dynamic capacity
with up to eight partitions (Regions) (dc0-dc7).  CXL regions can now be
sparse and defined as dynamic capacity (dc).

Add support for DCD devices and regions to libcxl.  Add documentation
for the new interfaces.

Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Co-developed-by: Sushant1 Kumar <sushant1.kumar@intel.com>
Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[djiang: remove errant white space changes]
[djiang: use for loop for dc capability sets]
[djiang: change cxl_memdev_get_dc_size() to take unsigned int]
[djiang: change cxl_decoder_is_dc_capable() to take unsigned int]
[Alison: s/Co-Authored-by/Co-developed-by/]
[Alison: document new libcxl calls]
[Alison: reduce indentation]
[Alison: Fix libcxl export symbols]
[iweiny: Add get mode documentation]
[iweiny: add docs for DC support]
[iweiny: use decoder_mode rather than index in libcxl calls]
---
 Documentation/cxl/lib/libcxl.txt | 17 ++++++-
 cxl/lib/libcxl.c                 | 98 ++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |  3 ++
 cxl/lib/private.h                |  4 ++
 cxl/libcxl.h                     | 52 ++++++++++++++++++++-
 5 files changed, 171 insertions(+), 3 deletions(-)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index d5c3558aacecb08d7f5754fdcc77d6e743560601..abca08fc81e6e84d176facafad6decae2f875880 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -68,6 +68,7 @@ int cxl_memdev_get_major(struct cxl_memdev *memdev);
 int cxl_memdev_get_minor(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
+unsigned long long cxl_memdev_get_dc_size(struct cxl_memdev *memdev, enum cxl_decoder_mode mode);
 const char *cxl_memdev_get_firmware_version(struct cxl_memdev *memdev);
 size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev);
 int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev);
@@ -422,11 +423,23 @@ enum cxl_decoder_mode {
 	CXL_DECODER_MODE_MIXED,
 	CXL_DECODER_MODE_PMEM,
 	CXL_DECODER_MODE_RAM,
+	CXL_DECODER_MODE_DC0,
+	CXL_DECODER_MODE_DC1,
+	CXL_DECODER_MODE_DC2,
+	CXL_DECODER_MODE_DC3,
+	CXL_DECODER_MODE_DC4,
+	CXL_DECODER_MODE_DC5,
+	CXL_DECODER_MODE_DC6,
+	CXL_DECODER_MODE_DC7,
 };
 enum cxl_decoder_mode cxl_decoder_get_mode(struct cxl_decoder *decoder);
+const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode);
+enum cxl_decoder_mode cxl_decoder_mode_from_ident(const char *ident);
+bool cxl_decoder_mode_is_dc(enum cxl_decoder_mode mode);
 int cxl_decoder_set_mode(struct cxl_decoder *decoder, enum cxl_decoder_mode mode);
 
 bool cxl_decoder_is_pmem_capable(struct cxl_decoder *decoder);
+bool cxl_decoder_is_dc_capable(struct cxl_decoder *decoder, enum cxl_decoder_mode mode);
 bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder);
@@ -558,6 +571,7 @@ enum cxl_region_mode {
 	CXL_REGION_MODE_MIXED = CXL_DECODER_MODE_MIXED,
 	CXL_REGION_MODE_PMEM = CXL_DECODER_MODE_PMEM,
 	CXL_REGION_MODE_RAM = CXL_DECODER_MODE_RAM,
+	CXL_REGION_MODE_DC,
 };
 const char *cxl_region_mode_name(enum cxl_region_mode mode);
 enum cxl_region_mode cxl_region_mode_from_ident(const char *ident);
@@ -615,7 +629,8 @@ cxl_region_get_daxctl_region() returns an 'struct daxctl_region *' that
 can be used with other libdaxctl APIs.
 
 Regions now have a mode distinct from decoders.  cxl_region_get_mode() is
-deprecated in favor of cxl_region_get_region_mode().
+deprecated in favor of cxl_region_get_region_mode().  Dynamic capacity regions
+require the use of cxl_region_get_region_mode().
 
 include::../../copyright.txt[]
 
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 35a40091e8f5813c1b3ef2ffb931c9ec584b02ad..df250db9dbacb2f0f34e8a592ce194159584fe4f 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1304,6 +1304,19 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	else
 		memdev->ram_qos_class = atoi(buf);
 
+	memdev->dc_partition_count = 0;
+	for (int partition = 0; partition < MAX_NUM_DC_REGIONS; partition++) {
+		sprintf(path, "%s/dc%d/size", cxlmem_base, partition);
+		if (sysfs_read_attr(ctx, path, buf) < 0)
+			continue;
+		memdev->dc_size[partition] = strtoull(buf, NULL, 0);
+		memdev->dc_partition_count++;
+		sprintf(path, "%s/dc%d/qos_class", cxlmem_base, partition);
+		if (sysfs_read_attr(ctx, path, buf) < 0)
+			continue;
+		memdev->dc_qos_class[partition] = strtoull(buf, NULL, 0);
+	}
+
 	sprintf(path, "%s/payload_max", cxlmem_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0) {
 		memdev->payload_max = strtoull(buf, NULL, 0);
@@ -1540,6 +1553,23 @@ CXL_EXPORT int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev)
 	return memdev->ram_qos_class;
 }
 
+static int cxl_decoder_dc_mode_to_index(enum cxl_decoder_mode mode)
+{
+	if (mode < CXL_DECODER_MODE_DC0 || mode > CXL_DECODER_MODE_DC7)
+		return -EINVAL;
+	return mode - CXL_DECODER_MODE_DC0;
+}
+
+CXL_EXPORT unsigned long long cxl_memdev_get_dc_size(struct cxl_memdev *memdev,
+						     enum cxl_decoder_mode mode)
+{
+	int index = cxl_decoder_dc_mode_to_index(mode);
+
+	if (index < 0)
+		return 0;
+	return memdev->dc_size[index];
+}
+
 CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev)
 {
 	return memdev->firmware_version;
@@ -2275,6 +2305,22 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 			decoder->mode = CXL_DECODER_MODE_RAM;
 		else if (strcmp(buf, "pmem") == 0)
 			decoder->mode = CXL_DECODER_MODE_PMEM;
+		else if (strcmp(buf, "dc0") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC0;
+		else if (strcmp(buf, "dc1") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC1;
+		else if (strcmp(buf, "dc2") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC2;
+		else if (strcmp(buf, "dc3") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC3;
+		else if (strcmp(buf, "dc4") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC4;
+		else if (strcmp(buf, "dc5") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC5;
+		else if (strcmp(buf, "dc6") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC6;
+		else if (strcmp(buf, "dc7") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC7;
 		else if (strcmp(buf, "mixed") == 0)
 			decoder->mode = CXL_DECODER_MODE_MIXED;
 		else if (strcmp(buf, "none") == 0)
@@ -2318,6 +2364,8 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 	case CXL_PORT_SWITCH:
 		decoder->pmem_capable = true;
 		decoder->volatile_capable = true;
+		for (unsigned index = 0; index < MAX_NUM_DC_REGIONS; index++)
+			decoder->dc_capable[index] = true;
 		decoder->mem_capable = true;
 		decoder->accelmem_capable = true;
 		sprintf(path, "%s/locked", cxldecoder_base);
@@ -2341,6 +2389,14 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 			{ "cap_type2", &decoder->accelmem_capable },
 			{ "cap_type3", &decoder->mem_capable },
 			{ "cap_ram", &decoder->volatile_capable },
+			{ "cap_ram", &decoder->dc_capable[0] },
+			{ "cap_ram", &decoder->dc_capable[1] },
+			{ "cap_ram", &decoder->dc_capable[2] },
+			{ "cap_ram", &decoder->dc_capable[3] },
+			{ "cap_ram", &decoder->dc_capable[4] },
+			{ "cap_ram", &decoder->dc_capable[5] },
+			{ "cap_ram", &decoder->dc_capable[6] },
+			{ "cap_ram", &decoder->dc_capable[7] },
 			{ "cap_pmem", &decoder->pmem_capable },
 			{ "locked", &decoder->locked },
 		};
@@ -2592,6 +2648,30 @@ CXL_EXPORT int cxl_decoder_set_mode(struct cxl_decoder *decoder,
 	case CXL_DECODER_MODE_RAM:
 		sprintf(buf, "ram");
 		break;
+	case CXL_DECODER_MODE_DC0:
+		sprintf(buf, "dc0");
+		break;
+	case CXL_DECODER_MODE_DC1:
+		sprintf(buf, "dc1");
+		break;
+	case CXL_DECODER_MODE_DC2:
+		sprintf(buf, "dc2");
+		break;
+	case CXL_DECODER_MODE_DC3:
+		sprintf(buf, "dc3");
+		break;
+	case CXL_DECODER_MODE_DC4:
+		sprintf(buf, "dc4");
+		break;
+	case CXL_DECODER_MODE_DC5:
+		sprintf(buf, "dc5");
+		break;
+	case CXL_DECODER_MODE_DC6:
+		sprintf(buf, "dc6");
+		break;
+	case CXL_DECODER_MODE_DC7:
+		sprintf(buf, "dc7");
+		break;
 	default:
 		err(ctx, "%s: unsupported mode: %d\n",
 		    cxl_decoder_get_devname(decoder), mode);
@@ -2648,6 +2728,16 @@ CXL_EXPORT bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder)
 	return decoder->mem_capable;
 }
 
+CXL_EXPORT bool cxl_decoder_is_dc_capable(struct cxl_decoder *decoder,
+					  enum cxl_decoder_mode mode)
+{
+	int index = cxl_decoder_dc_mode_to_index(mode);
+
+	if (index < 0)
+		return false;
+	return decoder->dc_capable[index];
+}
+
 CXL_EXPORT bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder)
 {
 	return decoder->accelmem_capable;
@@ -2717,6 +2807,8 @@ static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
 		sprintf(path, "%s/create_pmem_region", decoder->dev_path);
 	else if (mode == CXL_REGION_MODE_RAM)
 		sprintf(path, "%s/create_ram_region", decoder->dev_path);
+	else if (mode == CXL_REGION_MODE_DC)
+		sprintf(path, "%s/create_dc_region", decoder->dev_path);
 
 	rc = sysfs_read_attr(ctx, path, buf);
 	if (rc < 0) {
@@ -2768,6 +2860,12 @@ cxl_decoder_create_ram_region(struct cxl_decoder *decoder)
 	return cxl_decoder_create_region(decoder, CXL_REGION_MODE_RAM);
 }
 
+CXL_EXPORT struct cxl_region *
+cxl_decoder_create_dc_region(struct cxl_decoder *decoder)
+{
+	return cxl_decoder_create_region(decoder, CXL_REGION_MODE_DC);
+}
+
 CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
 {
 	return decoder->nr_targets;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 17a660f508ad1e053af2992824535ccf7ce877b2..fdb227789985443a13c72751bbd42ab383db5f97 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -292,4 +292,7 @@ global:
 LIBCXL_9 {
 global:
 	cxl_region_get_region_mode;
+	cxl_memdev_get_dc_size;
+	cxl_decoder_is_dc_capable;
+	cxl_decoder_create_dc_region;
 } LIBECXL_8;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 0f45be89b6a00477d13fb6d7f1906213a3073c48..3efa230bfb632e6c6048aadd18f799b07d4bdfd3 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -47,6 +47,9 @@ struct cxl_memdev {
 	struct list_node list;
 	unsigned long long pmem_size;
 	unsigned long long ram_size;
+	unsigned long long dc_size[MAX_NUM_DC_REGIONS];
+	unsigned long long dc_qos_class[MAX_NUM_DC_REGIONS];
+	int dc_partition_count;
 	int ram_qos_class;
 	int pmem_qos_class;
 	int payload_max;
@@ -140,6 +143,7 @@ struct cxl_decoder {
 	bool pmem_capable;
 	bool volatile_capable;
 	bool mem_capable;
+	bool dc_capable[MAX_NUM_DC_REGIONS];
 	bool accelmem_capable;
 	bool locked;
 	enum cxl_decoder_target_type target_type;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 06b87a0924faafec6c80eca83ea7551d4e117256..d7f8a37816f236acd71fc834eae70a7a17a2721a 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -72,6 +72,9 @@ int cxl_memdev_get_minor(struct cxl_memdev *memdev);
 struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
+enum cxl_decoder_mode;
+unsigned long long cxl_memdev_get_dc_size(struct cxl_memdev *memdev,
+					  enum cxl_decoder_mode mode);
 int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev);
 int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
@@ -191,11 +194,20 @@ unsigned long long
 cxl_decoder_get_max_available_extent(struct cxl_decoder *decoder);
 int cxl_root_decoder_get_qos_class(struct cxl_decoder *decoder);
 
+#define MAX_NUM_DC_REGIONS 8
 enum cxl_decoder_mode {
 	CXL_DECODER_MODE_NONE,
 	CXL_DECODER_MODE_MIXED,
 	CXL_DECODER_MODE_PMEM,
 	CXL_DECODER_MODE_RAM,
+	CXL_DECODER_MODE_DC0,
+	CXL_DECODER_MODE_DC1,
+	CXL_DECODER_MODE_DC2,
+	CXL_DECODER_MODE_DC3,
+	CXL_DECODER_MODE_DC4,
+	CXL_DECODER_MODE_DC5,
+	CXL_DECODER_MODE_DC6,
+	CXL_DECODER_MODE_DC7,
 };
 
 static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
@@ -205,9 +217,17 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
 		[CXL_DECODER_MODE_MIXED] = "mixed",
 		[CXL_DECODER_MODE_PMEM] = "pmem",
 		[CXL_DECODER_MODE_RAM] = "ram",
+		[CXL_DECODER_MODE_DC0] = "dc0",
+		[CXL_DECODER_MODE_DC1] = "dc1",
+		[CXL_DECODER_MODE_DC2] = "dc2",
+		[CXL_DECODER_MODE_DC3] = "dc3",
+		[CXL_DECODER_MODE_DC4] = "dc4",
+		[CXL_DECODER_MODE_DC5] = "dc5",
+		[CXL_DECODER_MODE_DC6] = "dc6",
+		[CXL_DECODER_MODE_DC7] = "dc7",
 	};
 
-	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_RAM)
+	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_DC7)
 		mode = CXL_DECODER_MODE_NONE;
 	return names[mode];
 }
@@ -221,9 +241,30 @@ cxl_decoder_mode_from_ident(const char *ident)
 		return CXL_DECODER_MODE_RAM;
 	else if (strcmp(ident, "pmem") == 0)
 		return CXL_DECODER_MODE_PMEM;
+	else if (strcmp(ident, "dc0") == 0)
+		return CXL_DECODER_MODE_DC0;
+	else if (strcmp(ident, "dc1") == 0)
+		return CXL_DECODER_MODE_DC1;
+	else if (strcmp(ident, "dc2") == 0)
+		return CXL_DECODER_MODE_DC2;
+	else if (strcmp(ident, "dc3") == 0)
+		return CXL_DECODER_MODE_DC3;
+	else if (strcmp(ident, "dc4") == 0)
+		return CXL_DECODER_MODE_DC4;
+	else if (strcmp(ident, "dc5") == 0)
+		return CXL_DECODER_MODE_DC5;
+	else if (strcmp(ident, "dc6") == 0)
+		return CXL_DECODER_MODE_DC6;
+	else if (strcmp(ident, "dc7") == 0)
+		return CXL_DECODER_MODE_DC7;
 	return CXL_DECODER_MODE_NONE;
 }
 
+static inline bool cxl_decoder_mode_is_dc(enum cxl_decoder_mode mode)
+{
+	return (mode >= CXL_DECODER_MODE_DC0 && mode <= CXL_DECODER_MODE_DC7);
+}
+
 enum cxl_decoder_mode cxl_decoder_get_mode(struct cxl_decoder *decoder);
 int cxl_decoder_set_mode(struct cxl_decoder *decoder,
 			 enum cxl_decoder_mode mode);
@@ -248,6 +289,8 @@ enum cxl_decoder_target_type {
 enum cxl_decoder_target_type
 cxl_decoder_get_target_type(struct cxl_decoder *decoder);
 bool cxl_decoder_is_pmem_capable(struct cxl_decoder *decoder);
+bool cxl_decoder_is_dc_capable(struct cxl_decoder *decoder,
+			       enum cxl_decoder_mode mode);
 bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder);
@@ -258,6 +301,7 @@ unsigned int cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_get_region(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_create_pmem_region(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_create_ram_region(struct cxl_decoder *decoder);
+struct cxl_region *cxl_decoder_create_dc_region(struct cxl_decoder *decoder);
 struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
 					    const char *ident);
 struct cxl_memdev *cxl_decoder_get_memdev(struct cxl_decoder *decoder);
@@ -308,6 +352,7 @@ enum cxl_region_mode {
 	CXL_REGION_MODE_MIXED = CXL_DECODER_MODE_MIXED,
 	CXL_REGION_MODE_PMEM = CXL_DECODER_MODE_PMEM,
 	CXL_REGION_MODE_RAM = CXL_DECODER_MODE_RAM,
+	CXL_REGION_MODE_DC,
 };
 
 static inline const char *cxl_region_mode_name(enum cxl_region_mode mode)
@@ -317,9 +362,10 @@ static inline const char *cxl_region_mode_name(enum cxl_region_mode mode)
 		[CXL_REGION_MODE_MIXED] = "mixed",
 		[CXL_REGION_MODE_PMEM] = "pmem",
 		[CXL_REGION_MODE_RAM] = "ram",
+		[CXL_REGION_MODE_DC] = "dc",
 	};
 
-	if (mode < CXL_REGION_MODE_NONE || mode > CXL_REGION_MODE_RAM)
+	if (mode < CXL_REGION_MODE_NONE || mode > CXL_REGION_MODE_DC)
 		mode = CXL_REGION_MODE_NONE;
 	return names[mode];
 }
@@ -333,6 +379,8 @@ cxl_region_mode_from_ident(const char *ident)
 		return CXL_REGION_MODE_RAM;
 	else if (strcmp(ident, "pmem") == 0)
 		return CXL_REGION_MODE_PMEM;
+	else if (strcmp(ident, "dc") == 0)
+		return CXL_REGION_MODE_DC;
 	return CXL_REGION_MODE_NONE;
 }
 

-- 
2.47.0

