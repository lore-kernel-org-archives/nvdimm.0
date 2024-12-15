Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FFCBA20
	for <nvdimm@lists.linux.dev>; Sun, 15 Dec 2024 02:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734231520; cv=none; b=ZV9gWTcM2IOkW6HjFVDwpSregWHCG8QT+3cGTC8dR8rWzObUrSo9a1ocxhQ4yEc5cAIwfPz7EG71h25IJY6IYoKLfTQwi4Oi7NyJIleiiFM45VXEU0WKX3iSlFGJ7xNnxy55jyTftLEhnW/4xrJRoIe59s66dJIIekqcEg1bFSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734231520; c=relaxed/simple;
	bh=gYuIf8iFWgCstPhZQ8M3bKFjkVl0enZVlIXva/K1lgw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PlNh8Ag7l8EZybzRGswi+iKB0+TPDxXg6ldglhIZm8APMkUgRNSHVvzNs9Pu8mTxtNg++yyFkgZT1+vuzWhcBO7FMKCC6LCfxvVZZdwAJzJPffSr2TCjEcQamCQJLNm+r0p1Q2HPIJQ75nFoA6WOWwMD7I97wc56NLmbABsqpVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fYnA8/BT; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fYnA8/BT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734231518; x=1765767518;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=gYuIf8iFWgCstPhZQ8M3bKFjkVl0enZVlIXva/K1lgw=;
  b=fYnA8/BTJmb+oEtvtyKi568YJWwuzzdgbg7qDrB0Y9kNapDeihxd7UjO
   8KoqXsQiotOD4HT/pPEhRXk1aAr0YTD3/fmF0ybSv3sDDMe4RS7KBGu69
   dmF9JWVp/fMztYG2aQhChnL5/gXdL7u3gWu2DLwUqxvgW3RXFyf+nXDy4
   cDo7mOsqiwcQ6C2n2IrJUCJi8+s51HT9NAd7HvlXPsFXk4mG0gx+qXoNf
   OO+eIwQByfzrKXJlwRLKuISjYsEmiEAE3dMlailjEHuQp1nldl4XEKhL6
   lxC3YZvUyCy8ZX+qiSHMwZvtmWY++itAaX2cFHgPWRMAOQTc69haWocKA
   w==;
X-CSE-ConnectionGUID: tJe8UtoHRbmiYeMN586ldA==
X-CSE-MsgGUID: akhLNQSmRUGHggXRc2osyQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11286"; a="52166947"
X-IronPort-AV: E=Sophos;i="6.12,235,1728975600"; 
   d="scan'208";a="52166947"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:37 -0800
X-CSE-ConnectionGUID: G2GMZz7pRX26LN3k9VA3rg==
X-CSE-MsgGUID: ol4njKxwSbSLhjzjlY9SdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="97309317"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.111.42])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:37 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Sat, 14 Dec 2024 20:58:30 -0600
Subject: [ndctl PATCH v4 3/9] libcxl: Separate region mode from decoder
 mode
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241214-dcd-region2-v4-3-36550a97f8e2@intel.com>
References: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
In-Reply-To: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Sushant1 Kumar <sushant1.kumar@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734231510; l=9543;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=gYuIf8iFWgCstPhZQ8M3bKFjkVl0enZVlIXva/K1lgw=;
 b=uaEAmxvbsiQ8pdn2I8soQQZPn1ieVv654yQn9FKokrXqrkQG7zU3Q6GkXQ9/3PlWjEs4p0Wxu
 KPE7H1NsQGAAgF6nPvqZACG2cdS+PZwErOHawvIvEPIVOmG4MX5V60/
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

With the introduction of DCD, region mode and decoder mode no longer
remain a 1:1 relation.  An interleaved region may be made up of Dynamic
Capacity partitions with different indexes on each of the target
devices.

Introduce a new region mode enumeration and access function to libcxl.

To maintain compatibility with existing software the region mode values
are defined the same as the current decoder mode.  In addition
cxl_region_get_mode() is retained.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 Documentation/cxl/lib/libcxl.txt | 20 ++++++++++++++++++--
 cxl/lib/libcxl.c                 | 25 +++++++++++++++----------
 cxl/lib/libcxl.sym               |  5 +++++
 cxl/lib/private.h                |  2 +-
 cxl/libcxl.h                     | 35 +++++++++++++++++++++++++++++++++++
 5 files changed, 74 insertions(+), 13 deletions(-)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 40598a08b9f4840f79e3ab43f62f412d8b2136ed..d5c3558aacecb08d7f5754fdcc77d6e743560601 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -553,11 +553,20 @@ struct cxl_region *cxl_region_get_next(struct cxl_region *region);
 
 ===== REGION: Attributes
 ----
+enum cxl_region_mode {
+	CXL_REGION_MODE_NONE = CXL_DECODER_MODE_NONE,
+	CXL_REGION_MODE_MIXED = CXL_DECODER_MODE_MIXED,
+	CXL_REGION_MODE_PMEM = CXL_DECODER_MODE_PMEM,
+	CXL_REGION_MODE_RAM = CXL_DECODER_MODE_RAM,
+};
+const char *cxl_region_mode_name(enum cxl_region_mode mode);
+enum cxl_region_mode cxl_region_mode_from_ident(const char *ident);
+enum cxl_region_mode cxl_region_get_region_mode(struct cxl_region *region);
+
 int cxl_region_get_id(struct cxl_region *region);
 const char *cxl_region_get_devname(struct cxl_region *region);
 void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
 unsigned long long cxl_region_get_size(struct cxl_region *region);
-enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
 unsigned long long cxl_region_get_resource(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_granularity(struct cxl_region *region);
@@ -576,8 +585,12 @@ int cxl_region_clear_all_targets(struct cxl_region *region);
 int cxl_region_decode_commit(struct cxl_region *region);
 int cxl_region_decode_reset(struct cxl_region *region);
 struct daxctl_region *cxl_region_get_daxctl_region(struct cxl_region *region);
-----
 
+DEPRECATED:
+
+enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
+
+----
 A region's resource attribute is the Host Physical Address at which the region's
 address space starts. The region's address space is a subset of the parent root
 decoder's address space.
@@ -601,6 +614,9 @@ where its properties can be interrogated by daxctl. The helper
 cxl_region_get_daxctl_region() returns an 'struct daxctl_region *' that
 can be used with other libdaxctl APIs.
 
+Regions now have a mode distinct from decoders.  cxl_region_get_mode() is
+deprecated in favor of cxl_region_get_region_mode().
+
 include::../../copyright.txt[]
 
 SEE ALSO
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 63aa4ef3acdc2fb3c4ec6c13be5feb802e817d0d..35a40091e8f5813c1b3ef2ffb931c9ec584b02ad 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -431,10 +431,10 @@ CXL_EXPORT bool cxl_region_qos_class_mismatch(struct cxl_region *region)
 		if (!memdev)
 			continue;
 
-		if (region->mode == CXL_DECODER_MODE_RAM) {
+		if (region->mode == CXL_REGION_MODE_RAM) {
 			if (root_decoder->qos_class != memdev->ram_qos_class)
 				return true;
-		} else if (region->mode == CXL_DECODER_MODE_PMEM) {
+		} else if (region->mode == CXL_REGION_MODE_PMEM) {
 			if (root_decoder->qos_class != memdev->pmem_qos_class)
 				return true;
 		}
@@ -619,9 +619,9 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 
 	sprintf(path, "%s/mode", cxlregion_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
-		region->mode = CXL_DECODER_MODE_NONE;
+		region->mode = CXL_REGION_MODE_NONE;
 	else
-		region->mode = cxl_decoder_mode_from_ident(buf);
+		region->mode = cxl_region_mode_from_ident(buf);
 
 	sprintf(path, "%s/modalias", cxlregion_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
@@ -748,11 +748,16 @@ CXL_EXPORT unsigned long long cxl_region_get_resource(struct cxl_region *region)
 	return region->start;
 }
 
-CXL_EXPORT enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region)
+CXL_EXPORT enum cxl_region_mode cxl_region_get_region_mode(struct cxl_region *region)
 {
 	return region->mode;
 }
 
+CXL_EXPORT enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region)
+{
+	return (enum cxl_decoder_mode)cxl_region_get_region_mode(region);
+}
+
 CXL_EXPORT unsigned int
 cxl_region_get_interleave_ways(struct cxl_region *region)
 {
@@ -2700,7 +2705,7 @@ cxl_decoder_get_region(struct cxl_decoder *decoder)
 }
 
 static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
-						    enum cxl_decoder_mode mode)
+						    enum cxl_region_mode mode)
 {
 	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
 	char *path = decoder->dev_buf;
@@ -2708,9 +2713,9 @@ static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
 	struct cxl_region *region;
 	int rc;
 
-	if (mode == CXL_DECODER_MODE_PMEM)
+	if (mode == CXL_REGION_MODE_PMEM)
 		sprintf(path, "%s/create_pmem_region", decoder->dev_path);
-	else if (mode == CXL_DECODER_MODE_RAM)
+	else if (mode == CXL_REGION_MODE_RAM)
 		sprintf(path, "%s/create_ram_region", decoder->dev_path);
 
 	rc = sysfs_read_attr(ctx, path, buf);
@@ -2754,13 +2759,13 @@ static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
 CXL_EXPORT struct cxl_region *
 cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
 {
-	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_PMEM);
+	return cxl_decoder_create_region(decoder, CXL_REGION_MODE_PMEM);
 }
 
 CXL_EXPORT struct cxl_region *
 cxl_decoder_create_ram_region(struct cxl_decoder *decoder)
 {
-	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_RAM);
+	return cxl_decoder_create_region(decoder, CXL_REGION_MODE_RAM);
 }
 
 CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 0c155a40ad4765106f0eab1745281d462af782fe..17a660f508ad1e053af2992824535ccf7ce877b2 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -288,3 +288,8 @@ global:
 	cxl_memdev_trigger_poison_list;
 	cxl_region_trigger_poison_list;
 } LIBCXL_7;
+
+LIBCXL_9 {
+global:
+	cxl_region_get_region_mode;
+} LIBECXL_8;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index b6cd910e93359b53cac34427acfe84c7abcb78b0..0f45be89b6a00477d13fb6d7f1906213a3073c48 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -171,7 +171,7 @@ struct cxl_region {
 	unsigned int interleave_ways;
 	unsigned int interleave_granularity;
 	enum cxl_decode_state decode_state;
-	enum cxl_decoder_mode mode;
+	enum cxl_region_mode mode;
 	struct daxctl_region *dax_region;
 	struct kmod_module *module;
 	struct list_head mappings;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 0a5fd0e13cc24e0032d4a83d780278fbe0038d32..06b87a0924faafec6c80eca83ea7551d4e117256 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -303,6 +303,39 @@ int cxl_memdev_is_enabled(struct cxl_memdev *memdev);
 	for (endpoint = cxl_endpoint_get_first(port); endpoint != NULL;        \
 	     endpoint = cxl_endpoint_get_next(endpoint))
 
+enum cxl_region_mode {
+	CXL_REGION_MODE_NONE = CXL_DECODER_MODE_NONE,
+	CXL_REGION_MODE_MIXED = CXL_DECODER_MODE_MIXED,
+	CXL_REGION_MODE_PMEM = CXL_DECODER_MODE_PMEM,
+	CXL_REGION_MODE_RAM = CXL_DECODER_MODE_RAM,
+};
+
+static inline const char *cxl_region_mode_name(enum cxl_region_mode mode)
+{
+	static const char *names[] = {
+		[CXL_REGION_MODE_NONE] = "none",
+		[CXL_REGION_MODE_MIXED] = "mixed",
+		[CXL_REGION_MODE_PMEM] = "pmem",
+		[CXL_REGION_MODE_RAM] = "ram",
+	};
+
+	if (mode < CXL_REGION_MODE_NONE || mode > CXL_REGION_MODE_RAM)
+		mode = CXL_REGION_MODE_NONE;
+	return names[mode];
+}
+
+static inline enum cxl_region_mode
+cxl_region_mode_from_ident(const char *ident)
+{
+	if (strcmp(ident, "ram") == 0)
+		return CXL_REGION_MODE_RAM;
+	else if (strcmp(ident, "volatile") == 0)
+		return CXL_REGION_MODE_RAM;
+	else if (strcmp(ident, "pmem") == 0)
+		return CXL_REGION_MODE_PMEM;
+	return CXL_REGION_MODE_NONE;
+}
+
 struct cxl_region;
 struct cxl_region *cxl_region_get_first(struct cxl_decoder *decoder);
 struct cxl_region *cxl_region_get_next(struct cxl_region *region);
@@ -318,6 +351,8 @@ const char *cxl_region_get_devname(struct cxl_region *region);
 void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
 unsigned long long cxl_region_get_size(struct cxl_region *region);
 unsigned long long cxl_region_get_resource(struct cxl_region *region);
+enum cxl_region_mode cxl_region_get_region_mode(struct cxl_region *region);
+/* Deprecated: use cxl_region_get_region_mode() */
 enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_granularity(struct cxl_region *region);

-- 
2.47.1

