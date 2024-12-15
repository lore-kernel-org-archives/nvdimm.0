Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCA28F40
	for <nvdimm@lists.linux.dev>; Sun, 15 Dec 2024 02:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734231529; cv=none; b=KeQhIhbupkWKbJ+To+N+59cT9clnadbhhnghyvfho0kaznOzbRGjobIFM9IiBKy3uPn2e7LUW6CxYmiFaNR2Ou22CNb5o6fvb96rzqZlG/pomcxG+Wp9Be73GaNDoDqtBI/sn0LPGvW4VvOwzC3s/M60l9pvXFiIWH81Ge71w1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734231529; c=relaxed/simple;
	bh=6Nyr7xJsAkzjD9LFKGHwcxKx7vxO4IVRyLaJMOUJZ8s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AEsH+yYAYWUWBrXomFu2PTjGWgC2RVeGQuS/jITtklc1Woai1PMRp6KPfnJvAeX7DTowhKgH3CBCbvo7TCIuqKXMFV6+6j6RM32ikice2AybQ/sxElifir60ttpjy8d/uRmRCiyTVB4/DOZiHxj/02nsdn1/NpHxU49sU4t3VxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BDvYBNvK; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BDvYBNvK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734231528; x=1765767528;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=6Nyr7xJsAkzjD9LFKGHwcxKx7vxO4IVRyLaJMOUJZ8s=;
  b=BDvYBNvKJbKZiDG+dYRRk9KVpurr79nZIj14yuz4gwZedjILfehZCBq5
   ASVIOU3g97TbKBfUVlg8i9IQKjdFOGtgn0Xp7dP1cjgWiI1KynFayjxXZ
   gPaaDdOr/nrCwjPUaKQ/4YUq4+vFHWiYuOyj1+7gnRpm0QePdd59NPR7l
   LibncYqupDU9AS0nnztkad8jYq7/2/zMHJHK1pbnZrJqFRCd5FV1beZES
   reA5CxdSwhR10575QJBfTqRAkHXuF8SqPbs7WnDMq4nEQy/nN6R2Py9QC
   di7AF6DZwORPXHob+EUIFGN7tvzPSZQSOxbGGAZIccLUfiSzc2CuTf1ha
   w==;
X-CSE-ConnectionGUID: FoP4OzniRu2B3Y37xTUOIw==
X-CSE-MsgGUID: D7BfrqpNQPW91V0OBRWO4A==
X-IronPort-AV: E=McAfee;i="6700,10204,11286"; a="38424565"
X-IronPort-AV: E=Sophos;i="6.12,235,1728975600"; 
   d="scan'208";a="38424565"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:48 -0800
X-CSE-ConnectionGUID: 8nu/DKNmQayOlgvzo9pAPA==
X-CSE-MsgGUID: q1d3HvuKSq6z2wHfQ76ZbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="101462511"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.111.42])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:45 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Sat, 14 Dec 2024 20:58:34 -0600
Subject: [ndctl PATCH v4 7/9] libcxl: Add extent functionality to DC
 regions
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241214-dcd-region2-v4-7-36550a97f8e2@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734231510; l=8952;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=6Nyr7xJsAkzjD9LFKGHwcxKx7vxO4IVRyLaJMOUJZ8s=;
 b=wWlSm1k9+RYSkpUri1Q4qloqbzXECesrln7Psz5Ir7aqq7WiiMYBEp+m6JRa0ThjC732jih0i
 E+VyeyzlynIAE7iQiutGpMdaUj3uAr+phOpoFZMi3m1rfm08npU+D0A
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

DCD regions have 0 or more extents.  The ability to list those and their
properties is useful to end users.

Add extent scanning and reporting functionality to libcxl.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 Documentation/cxl/lib/libcxl.txt |  27 ++++++++
 cxl/lib/libcxl.c                 | 138 +++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |   5 ++
 cxl/lib/private.h                |  11 ++++
 cxl/libcxl.h                     |  11 ++++
 5 files changed, 192 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index abca08fc81e6e84d176facafad6decae2f875880..0b53cf9a3a09a3e8c9059f796823b52d22d1077f 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -632,6 +632,33 @@ Regions now have a mode distinct from decoders.  cxl_region_get_mode() is
 deprecated in favor of cxl_region_get_region_mode().  Dynamic capacity regions
 require the use of cxl_region_get_region_mode().
 
+EXTENTS
+-------
+
+=== EXTENT: Enumeration
+----
+struct cxl_region_extent;
+struct cxl_region_extent *cxl_extent_get_first(struct cxl_region *region);
+struct cxl_region_extent *cxl_extent_get_next(struct cxl_region_extent *extent);
+#define cxl_extent_foreach(region, extent) \
+        for (extent = cxl_extent_get_first(region); \
+             extent != NULL; \
+             extent = cxl_extent_get_next(extent))
+
+----
+
+=== EXTENT: Attributes
+----
+unsigned long long cxl_extent_get_offset(struct cxl_region_extent *extent);
+unsigned long long cxl_extent_get_length(struct cxl_region_extent *extent);
+void cxl_extent_get_tag(struct cxl_region_extent *extent, uuid_t tag);
+----
+
+Extents represent available memory within a dynamic capacity region.  Extent
+objects are available for informational purposes to aid in allocation of
+memory.
+
+
 include::../../copyright.txt[]
 
 SEE ALSO
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index df250db9dbacb2f0f34e8a592ce194159584fe4f..a029b14dcccf038b02b28d05df6f0dc71557df5e 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -568,6 +568,7 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 	region->ctx = ctx;
 	region->decoder = decoder;
 	list_head_init(&region->mappings);
+	list_head_init(&region->extents);
 
 	region->dev_path = strdup(cxlregion_base);
 	if (!region->dev_path)
@@ -1178,6 +1179,143 @@ cxl_mapping_get_next(struct cxl_memdev_mapping *mapping)
 	return list_next(&region->mappings, mapping, list);
 }
 
+static void cxl_extents_init(struct cxl_region *region)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	char *extent_path, *dax_region_path;
+	struct dirent *de;
+	DIR *dir = NULL;
+
+	if (region->extents_init)
+		return;
+	region->extents_init = 1;
+
+	dax_region_path = calloc(1, strlen(region->dev_path) + 64);
+	if (!dax_region_path) {
+		err(ctx, "%s: allocation failure\n", devname);
+		return;
+	}
+
+	extent_path = calloc(1, strlen(region->dev_path) + 100);
+	if (!extent_path) {
+		err(ctx, "%s: allocation failure\n", devname);
+		free(dax_region_path);
+		return;
+	}
+
+	sprintf(dax_region_path, "%s/dax_region%d",
+		region->dev_path, region->id);
+	dir = opendir(dax_region_path);
+	if (!dir) {
+		err(ctx, "no extents found (%s): %s\n",
+			strerror(errno), dax_region_path);
+		free(extent_path);
+		free(dax_region_path);
+		return;
+	}
+
+	while ((de = readdir(dir)) != NULL) {
+		struct cxl_region_extent *extent;
+		char buf[SYSFS_ATTR_SIZE];
+		u64 offset, length;
+		int id, region_id;
+
+		if (sscanf(de->d_name, "extent%d.%d", &region_id, &id) != 2)
+			continue;
+
+		sprintf(extent_path, "%s/extent%d.%d/offset",
+			dax_region_path, region_id, id);
+		if (sysfs_read_attr(ctx, extent_path, buf) < 0) {
+			err(ctx, "%s: failed to read extent%d.%d/offset\n",
+				devname, region_id, id);
+			continue;
+		}
+
+		offset = strtoull(buf, NULL, 0);
+		if (offset == ULLONG_MAX) {
+			err(ctx, "%s extent%d.%d: failed to read offset\n",
+				devname, region_id, id);
+			continue;
+		}
+
+		sprintf(extent_path, "%s/extent%d.%d/length",
+			dax_region_path, region_id, id);
+		if (sysfs_read_attr(ctx, extent_path, buf) < 0) {
+			err(ctx, "%s: failed to read extent%d.%d/length\n",
+				devname, region_id, id);
+			continue;
+		}
+
+		length = strtoull(buf, NULL, 0);
+		if (length == ULLONG_MAX) {
+			err(ctx, "%s extent%d.%d: failed to read length\n",
+				devname, region_id, id);
+			continue;
+		}
+
+		sprintf(extent_path, "%s/extent%d.%d/tag",
+			dax_region_path, region_id, id);
+		buf[0] = '\0';
+		if (sysfs_read_attr(ctx, extent_path, buf) != 0)
+			dbg(ctx, "%s extent%d.%d: failed to read tag\n",
+				devname, region_id, id);
+
+		extent = calloc(1, sizeof(*extent));
+		if (!extent) {
+			err(ctx, "%s extent%d.%d: allocation failure\n",
+				devname, region_id, id);
+			continue;
+		}
+		if (strlen(buf) && uuid_parse(buf, extent->tag) < 0)
+			err(ctx, "%s:%s\n", extent_path, buf);
+		extent->region = region;
+		extent->offset = offset;
+		extent->length = length;
+
+		list_node_init(&extent->list);
+		list_add(&region->extents, &extent->list);
+		dbg(ctx, "%s added extent%d.%d\n", devname, region_id, id);
+	}
+	free(dax_region_path);
+	free(extent_path);
+	closedir(dir);
+}
+
+CXL_EXPORT struct cxl_region_extent *
+cxl_extent_get_first(struct cxl_region *region)
+{
+	cxl_extents_init(region);
+
+	return list_top(&region->extents, struct cxl_region_extent, list);
+}
+
+CXL_EXPORT struct cxl_region_extent *
+cxl_extent_get_next(struct cxl_region_extent *extent)
+{
+	struct cxl_region *region = extent->region;
+
+	return list_next(&region->extents, extent, list);
+}
+
+CXL_EXPORT unsigned long long
+cxl_extent_get_offset(struct cxl_region_extent *extent)
+{
+	return extent->offset;
+}
+
+CXL_EXPORT unsigned long long
+cxl_extent_get_length(struct cxl_region_extent *extent)
+{
+	return extent->length;
+}
+
+CXL_EXPORT void
+cxl_extent_get_tag(struct cxl_region_extent *extent, uuid_t tag)
+{
+	memcpy(tag, extent->tag, sizeof(uuid_t));
+}
+
 CXL_EXPORT struct cxl_decoder *
 cxl_mapping_get_decoder(struct cxl_memdev_mapping *mapping)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index fdb227789985443a13c72751bbd42ab383db5f97..d8e8dbc7e091792fe48faa4657ab7cf1d795efdd 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -295,4 +295,9 @@ global:
 	cxl_memdev_get_dc_size;
 	cxl_decoder_is_dc_capable;
 	cxl_decoder_create_dc_region;
+	cxl_extent_get_first;
+	cxl_extent_get_next;
+	cxl_extent_get_offset;
+	cxl_extent_get_length;
+	cxl_extent_get_tag;
 } LIBECXL_8;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 3efa230bfb632e6c6048aadd18f799b07d4bdfd3..62278ec79963c198dcca490015e4c3f7621109b2 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -164,6 +164,7 @@ struct cxl_region {
 	struct cxl_decoder *decoder;
 	struct list_node list;
 	int mappings_init;
+	int extents_init;
 	struct cxl_ctx *ctx;
 	void *dev_buf;
 	size_t buf_len;
@@ -179,6 +180,7 @@ struct cxl_region {
 	struct daxctl_region *dax_region;
 	struct kmod_module *module;
 	struct list_head mappings;
+	struct list_head extents;
 };
 
 struct cxl_memdev_mapping {
@@ -188,6 +190,15 @@ struct cxl_memdev_mapping {
 	struct list_node list;
 };
 
+#define CXL_REGION_EXTENT_TAG 0x10
+struct cxl_region_extent {
+	struct cxl_region *region;
+	u64 offset;
+	u64 length;
+	uuid_t tag;
+	struct list_node list;
+};
+
 enum cxl_cmd_query_status {
 	CXL_CMD_QUERY_NOT_RUN = 0,
 	CXL_CMD_QUERY_OK,
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index d7f8a37816f236acd71fc834eae70a7a17a2721a..1d294ac0278d798214acb2f62e98aaaccaf60ea5 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -445,6 +445,17 @@ unsigned int cxl_mapping_get_position(struct cxl_memdev_mapping *mapping);
              mapping != NULL; \
              mapping = cxl_mapping_get_next(mapping))
 
+struct cxl_region_extent;
+struct cxl_region_extent *cxl_extent_get_first(struct cxl_region *region);
+struct cxl_region_extent *cxl_extent_get_next(struct cxl_region_extent *extent);
+#define cxl_extent_foreach(region, extent) \
+        for (extent = cxl_extent_get_first(region); \
+             extent != NULL; \
+             extent = cxl_extent_get_next(extent))
+unsigned long long cxl_extent_get_offset(struct cxl_region_extent *extent);
+unsigned long long cxl_extent_get_length(struct cxl_region_extent *extent);
+void cxl_extent_get_tag(struct cxl_region_extent *extent, uuid_t tag);
+
 struct cxl_cmd;
 const char *cxl_cmd_get_devname(struct cxl_cmd *cmd);
 struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev, int opcode);

-- 
2.47.1

