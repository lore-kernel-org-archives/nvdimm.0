Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5C63DFC68
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 12:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389598; cv=none; b=qgxKdqvOaOcvFqTpOHzCnCrYmLGmRkvumqIc5ai9yaw1whylX/p8TXX449+fgjFkFEgl25nqTCZXgqt3SCLOO5TIqLPeg3GqL2pI6Ld79qsigR4WvLm3lIWcNCbAB/Wk5CBr6xGmS4vgdOvV/rDw/90wSgj7p/ml7TJL2USyJSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389598; c=relaxed/simple;
	bh=xJ/ICNkWheqKSMaG5TDZjQwBthEvf+tjk2YxwbB3SGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVLzHyA+89ugr367iwH0oT7GvVoHexbcACsjFr+luel1cuCg7G2K2X8AD94XYuVzwAFCgZ7kFduAHPYPclGvVxUWXDN6IcEfdu3nUqvX8jS01LIabD4TW0oEXPDbTaeFVAfhzH8nCLSQED7Ov6axTZlzo/4WBk390LVyWhKX2bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=guiFXLOs; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="guiFXLOs"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-139aaba3522so651648c88.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 05:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782389595; x=1782994395; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G18zehfJH2C51qiLFUBVCY46IetjGTIchA+W2VJTLjM=;
        b=guiFXLOsVHCJRYM+LwIxR7T0odQDhgOjtOlyI4UveeuYcid0i8hX89vdCLkV+dwF1T
         Kvvsrmjfo+BPPZOtifrNXq+hSRRfq33cxHyyvucA6/bJ2+Q+vs6rlbULio0E9gNtPpnu
         TGRKqWy3PFKWN31U2FvuA9MMym/TtOL1nc793pSe+ks6OCKcKptq2WD14TYkv0Z56W7g
         D5m6t4RAJksSRS0Siu9fQ6UYOIcbNkomb5ZfIQkBl+JzX7GvS0EvENIA5ecs8tBsN/L3
         s4yCn3cbjyIxDo70MEcfl3InzplfeFQ11E+BGLFACuG7eQbuD1xRfF5SMQSENtU1nV4O
         pSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782389595; x=1782994395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G18zehfJH2C51qiLFUBVCY46IetjGTIchA+W2VJTLjM=;
        b=G8LR5dlgvs0AObL30KMcvD9Cwd+6BAMl1IA4UjHLvmb96iM1NB4yTAalGzYEtvwU9I
         GAyiwaXfCIPTaZd0ZvR8UDRq9O4Dd7Uuw8fIXJKhZOdX8CSezvfDJDF4LFddFn87ywpc
         /1X89CiVPTP5Bl5px8YsToOIeIps1htoC4p7stsS6FbCvUVi8fa2UTeR0QypHNqX8RdY
         2VTAm12ULXcLRUB4Uj/WAsghDFydYpmefPGYM+z0GxMxVwJaTzEYO7pW+XSVtQ8P6Cul
         05ihLrWwqwvVzqK96ncLLWFoKCvzmO68gNsx85WMJgu4ckh+f2HrPytIRtUnsrB5TtNA
         Rsvg==
X-Gm-Message-State: AOJu0YwJQdu7+iGd4Jj5DdFJUKtnoyCMTTW03T90Xl2weRK6Dyuvgvok
	t0T0G1RmUtnX4wFWTveCKW2w2Gb6RY3BVCMPppRUKieie1rnrjpgwA39
X-Gm-Gg: AfdE7clgOO6HY9hm/Bmhce2Hl1ZunwkKi0kZn2m/Cem97xgLEtYjE3qX9h8sDK22QcJ
	3pnadn0mkunNEDutopSICNFT4RmZhnK7tOzuTixHvgSVFTDzrNgEHswpG14MwOZlKMO4ZtRCkRg
	gU4xwxu/2yjMlE6lRtznslXKEgVBqW9p4nX+iWYz9WMoMrYksqgacYo24Gm8pHEk+3DVUuZy6x/
	8ynDNxAaJITV9V43NKe6Ut6RDsFz0/fgzlvyT3MHBuF3HV1OVKnjrlxCeQBD+3Q1JBNczs7YitM
	9Ao4LwFXu1KJgxwD6Dahf3EoLHm4u7fWwHyLIR/3aEVPCCgeNp9Q5/dw/KfOx2yTY1y6+Hqt61I
	XOt21gD4JomjqOAsCAlgYlwAJL8ytE9/wDpClqMysHxTkL9Ei/3ajeZhJVoLMWsTYeoMsfFjfT+
	IOs2DWffn/qGQmVy7D/ozLAd/GmbRfMphZypScFRg6zgR1hKFs+3c/xEh7pziwR5s7SWfd4Yyfc
	+N7BnM=
X-Received: by 2002:a05:7022:f112:b0:135:e781:74af with SMTP id a92af1059eb24-139db9f5507mr2036970c88.18.1782389594744;
        Thu, 25 Jun 2026 05:13:14 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d8f77602sm7422206c88.8.2026.06.25.05.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 05:13:14 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>
Subject: [NDCTL PATCH v7 2/5] libcxl: Add extent functionality to DC regions
Date: Thu, 25 Jun 2026 05:09:36 -0700
Message-ID: <20260625121242.603807-3-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625121242.603807-1-anisa.su@samsung.com>
References: <20260625121242.603807-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

DCD regions have 0 or more extents.  The ability to list those and their
properties is useful to end users.

Add extent scanning and reporting functionality to libcxl.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
1. s/tag/uuid/ for extents
---
 Documentation/cxl/lib/libcxl.txt |  27 ++++++
 cxl/lib/libcxl.c                 | 143 +++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |   5 ++
 cxl/lib/private.h                |  10 +++
 cxl/libcxl.h                     |  11 +++
 5 files changed, 196 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 59163e4..7eca5eb 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -635,6 +635,33 @@ where its properties can be interrogated by daxctl. The helper
 cxl_region_get_daxctl_region() returns an 'struct daxctl_region *' that
 can be used with other libdaxctl APIs.
 
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
+void cxl_extent_get_uuid(struct cxl_region_extent *extent, uuid_t uuid);
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
index 240ed75..c211687 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -110,11 +110,16 @@ static void free_target(struct cxl_target *target, struct list_head *head)
 static void free_region(struct cxl_region *region, struct list_head *head)
 {
 	struct cxl_memdev_mapping *mapping, *_m;
+	struct cxl_region_extent *extent, *_e;
 
 	list_for_each_safe(&region->mappings, mapping, _m, list) {
 		list_del_from(&region->mappings, &mapping->list);
 		free(mapping);
 	}
+	list_for_each_safe(&region->extents, extent, _e, list) {
+		list_del_from(&region->extents, &extent->list);
+		free(extent);
+	}
 	if (head)
 		list_del_from(head, &region->list);
 	kmod_module_unref(region->module);
@@ -635,6 +640,7 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 	region->ctx = ctx;
 	region->decoder = decoder;
 	list_head_init(&region->mappings);
+	list_head_init(&region->extents);
 
 	region->dev_path = strdup(cxlregion_base);
 	if (!region->dev_path)
@@ -1257,6 +1263,143 @@ cxl_mapping_get_next(struct cxl_memdev_mapping *mapping)
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
+		sprintf(extent_path, "%s/extent%d.%d/uuid",
+			dax_region_path, region_id, id);
+		buf[0] = '\0';
+		if (sysfs_read_attr(ctx, extent_path, buf) != 0)
+			dbg(ctx, "%s extent%d.%d: failed to read uuid\n",
+				devname, region_id, id);
+
+		extent = calloc(1, sizeof(*extent));
+		if (!extent) {
+			err(ctx, "%s extent%d.%d: allocation failure\n",
+				devname, region_id, id);
+			continue;
+		}
+		if (strlen(buf) && uuid_parse(buf, extent->uuid) < 0)
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
+cxl_extent_get_uuid(struct cxl_region_extent *extent, uuid_t uuid)
+{
+	memcpy(uuid, extent->uuid, sizeof(uuid_t));
+}
+
 CXL_EXPORT struct cxl_decoder *
 cxl_mapping_get_decoder(struct cxl_memdev_mapping *mapping)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 4a8443c..4d7da17 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -327,4 +327,9 @@ global:
 	cxl_memdev_get_dynamic_ram_1_qos_class;
 	cxl_decoder_is_dynamic_ram_1_capable;
 	cxl_decoder_create_dynamic_ram_1_region;
+	cxl_extent_get_first;
+	cxl_extent_get_next;
+	cxl_extent_get_offset;
+	cxl_extent_get_length;
+	cxl_extent_get_uuid;
 } LIBCXL_12;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index fb45e15..cac0cd1 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -183,6 +183,7 @@ struct cxl_region {
 	struct cxl_decoder *decoder;
 	struct list_node list;
 	int mappings_init;
+	int extents_init;
 	struct cxl_ctx *ctx;
 	void *dev_buf;
 	size_t buf_len;
@@ -200,6 +201,7 @@ struct cxl_region {
 	struct daxctl_region *dax_region;
 	struct kmod_module *module;
 	struct list_head mappings;
+	struct list_head extents;
 };
 
 struct cxl_memdev_mapping {
@@ -209,6 +211,14 @@ struct cxl_memdev_mapping {
 	struct list_node list;
 };
 
+struct cxl_region_extent {
+	struct cxl_region *region;
+	u64 offset;
+	u64 length;
+	uuid_t uuid;
+	struct list_node list;
+};
+
 enum cxl_cmd_query_status {
 	CXL_CMD_QUERY_NOT_RUN = 0,
 	CXL_CMD_QUERY_OK,
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 8ee6937..d18a18b 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -394,6 +394,17 @@ unsigned int cxl_mapping_get_position(struct cxl_memdev_mapping *mapping);
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
+void cxl_extent_get_uuid(struct cxl_region_extent *extent, uuid_t uuid);
+
 struct cxl_cmd;
 const char *cxl_cmd_get_devname(struct cxl_cmd *cmd);
 struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev, int opcode);
-- 
2.43.0

