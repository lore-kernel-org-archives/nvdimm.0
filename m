Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2747F384235
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529862; cv=none; b=fBrEhgjLVUNvoSwlpwpMnjRZvU3l19FlcxcdZePKgQwiLVByKMIGHzVU+bCEMfwOxhEMCiIz/gfenrgmfNEDkfeLpTqntFQwIzgRkLLn/0bEPf9Btz2gVU44m83fnUhTSYXOhmxHsixbw7TVI3MVaP2hMQRnrsCrlcObHZ4CK/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529862; c=relaxed/simple;
	bh=jCEHApWqv0hzZwZpXbD5jrSPD2cM1dtmn7Aic6jAUK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rlh3ST/Chgi/6q8F06fhsBs8CRDhZtToa4K2ixWCaj9jhfVLXgucpEODo6p5xF58O4gmecAapM7MngB+X8Rh2YCaAT5a8zKuw9NSFmOgXIfwUcdzrcmaO2yV06SLFL7k4TN5pos2NlasI3wtMM7zjTFh3NctIFiZPVHqw+5mneA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p92RCOZ5; arc=none smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p92RCOZ5"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-3044857f09aso2982988eec.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529860; x=1780134660; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WB2DB1mYBidB9TwFtpFj7mZX6EdDGm71XkD/oRhHqD8=;
        b=p92RCOZ5Eg2Bao5xQJAxu+9b7qr6p/pfdE5diqcwYMSOkzZ558bHy6wFcq8vjTcVz0
         wPq4Vua1hPOMJGVM++gp3ToSCg2wUqeb2InF7aft2lrSWde8NqVL65/jogOqkzyq+wyO
         Q6aQyO6tX9+sNHN7Nqy0iKB2472DBUl+uxcO0RmxXamTp7rpGcTRIcfTzn0MNzxEDv0r
         a4GxqBZ4h1Q5nD2p/6IMJnYPlSBDtcGcQdpHpV8OBPyQ37hfUDYSgIEwCulRJ3VUO3iO
         4jsQ7JK6QYpeKJgq8BtVOslVgqL/5rPEfr0Uy7+Pkes/UgXffx3WyFJF4aA57aBIK92Z
         iVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529860; x=1780134660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WB2DB1mYBidB9TwFtpFj7mZX6EdDGm71XkD/oRhHqD8=;
        b=hfl4lk/FSPjMoBQrUSrVykq0TSafVEJ7CQeRT+npuZs8S9WgbeBNoalV6KT5MG0ANr
         uwfPmOXOYg+5LVbJ72ULZ1ZcCtnDorKUkrkPuH9vNtdJ+xAPd2VPRAaIxc6V4gwqJwWv
         i7LXisaVNjizdHIGrC++ro3ZzCQSapKPt8Ov8LHumAdCB2I6xN96VRS0nuaYL1WWsOvH
         tAbjKTfyoFNX5YssQCX9wTqsXD1fCewHEuC5R6wL5ROMFw1Fz90VI/hkDEETsOJSShaL
         iRoSkJ6gUlROi6KgZ62XSRfQQDSceyuoJ56fhCNPzxgkQcIpSy74JmqyC0NLgzStrvJ1
         v7zQ==
X-Gm-Message-State: AOJu0YzZnVJVnipaJ8eRdfvGmPwqSkdakNcLpRkM7IoU7OjV1pGFhbhJ
	5mwjJ+tZtVgdJneMP8hrjal52IeJ9JR8LtmKtTmCjrCaGfruFhGATdWl
X-Gm-Gg: Acq92OGWuXoTTlenUogMCz0hgdPhr8O0OsKtsGpTe2akiMtA/MevqVrq3/GP3nDf2mc
	kVXvCfYwc1dY/IWu/PNm1nSsOXnP5+syWeqn+3R0jPfIXwT+QfIPnEbiji9XYLDiUEG1++arua2
	4aeH3xFX+pyYcNl0D9usbx23/gcj9R17jvKftqr9I1Iwk9LJfA7fVnMI11+fUMgdTTTtyuNRvaU
	PJpoQMOa/st56CW4S6Ts214A0JB6LxC9pQRN7QxAa/icjQywd0em/jLwasGxGYf6ltMeIa/vNcF
	aEnDUm2RLl77w7zViokEUMrDZMugXlo109EXApEciGLSx8F2wFtVNvcWsVjPpL+thI8dYdaIw2J
	npQHS2DK6dDcwuNdMHPlgx4/rsWp0KqGsXnLfciChv4p83icCetcTC0E3vIlcGCgft812ewNJ3J
	1u9mb/rC5Qvc47n5sDR0KS+wjk6hrTHCqXmtOHWCtjuM7enL9vhsY7fR+pin8LhtV52v3JtgL17
	gOYp9S3VOnSCr9FxcrHokUx68aY
X-Received: by 2002:a05:7300:2313:b0:2f5:285c:4374 with SMTP id 5a478bee46e88-30449119476mr3508800eec.35.1779529860170;
        Sat, 23 May 2026 02:51:00 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3045225b7b6sm4595756eec.25.2026.05.23.02.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:50:59 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v6 4/7] libcxl: Add extent functionality to DC regions
Date: Sat, 23 May 2026 02:50:39 -0700
Message-ID: <20260523095043.471098-5-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260523095043.471098-1-anisa.su@samsung.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

DCD regions have 0 or more extents.  The ability to list those and their
properties is useful to end users.

Add extent scanning and reporting functionality to libcxl.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[alison: s/tag/uuid/ for extents]
---
 Documentation/cxl/lib/libcxl.txt |  27 ++++++
 cxl/lib/libcxl.c                 | 138 +++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |   5 ++
 cxl/lib/private.h                |  11 +++
 cxl/libcxl.h                     |  11 +++
 5 files changed, 192 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 9921ac1..0ad294c 100644
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
index be0bc03..c096666 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -635,6 +635,7 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 	region->ctx = ctx;
 	region->decoder = decoder;
 	list_head_init(&region->mappings);
+	list_head_init(&region->extents);
 
 	region->dev_path = strdup(cxlregion_base);
 	if (!region->dev_path)
@@ -1257,6 +1258,143 @@ cxl_mapping_get_next(struct cxl_memdev_mapping *mapping)
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
index 258bdd3..dcfe242 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -298,6 +298,11 @@ global:
 	cxl_memdev_get_dynamic_ram_a_qos_class;
 	cxl_decoder_is_dynamic_ram_a_capable;
 	cxl_decoder_create_dynamic_ram_a_region;
+	cxl_extent_get_first;
+	cxl_extent_get_next;
+	cxl_extent_get_offset;
+	cxl_extent_get_length;
+	cxl_extent_get_uuid;
 } LIBECXL_8;
 
 LIBCXL_10 {
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 37b7b06..c5f3bed 100644
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
@@ -209,6 +211,15 @@ struct cxl_memdev_mapping {
 	struct list_node list;
 };
 
+#define CXL_REGION_EXTENT_TAG 0x10
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
index fd41122..a60509f 100644
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

