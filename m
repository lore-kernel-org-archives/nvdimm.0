Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCF539CD0B
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 22:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791673039; cv=none; b=KQmlx3MXGi2hEwPsyRxDv4rdliBsxdN3j4tzBLhHFh5NPj7HaFTC1xsz9LS7hFXNEdxnEoKe+BFxi4U/uZMKpzHjK2I1+6yiPwnaF+AF5VbSSr5h5rZLDgg9cYlPJWLwZKxUuuARU+5gt/UYxcxqyKjGV31O8ukf7xeQ3YZ/m1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791673039; c=relaxed/simple;
	bh=C3N1+KMuNw7rEqbheuqOqtg1AVHTuQbnCilpkCGn2nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odadunnRGmG/05+/kZ5OUYk9kspvcM5MCXXeernHuHHu1Rwfp+m2cwqI/i1Fl9EpA0TGR1ikFIVXf/EmkJmfOVrsTfrqgxu69a5g7JNHNK44IrIrqFftSDIKPit0F125LHb7I3WXTefEUkwvDVoYj4zoX9SLcGAy9J7QQ6sEyDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oHSQe+hd; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oHSQe+hd"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d71d1cc8b2so4149055ad.1
        for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 15:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791673037; x=1792277837; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aKPcv4ihK4dweaSF5AzKZy2rcAhS9MICix+A3Pbi4B0=;
        b=oHSQe+hdr7taMvJeHiU0ikZ/MvO2+Eb/yUiVTwMMsh7QAAQ6CoBBjm0M9wdVEmNXZd
         Wy4BqZ5DlNJPxdhdmGVb6KPJvjTwcxo5Q8+8ZH7qhcwnGdGNbloyuGCsy81St1mijtEM
         uVsPx79ipqFEgDUaisSQr1PWAVLPFsN8Wi83t00RgCMT4s12clYAUWb+G58cGTIwKnzX
         /DrkGd3qesOztoSeJ6600lv87IhlxzjAMg3Dm7E6HldM8X/1se1fzLe4fRpb1icy3Fub
         OJYVUT3MX39Wlm52RRGoW92Ox7jqt2UaZt3n0p3Ll07vp1O4kfyi1zyoYZ3kEWxazSNN
         HX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791673037; x=1792277837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aKPcv4ihK4dweaSF5AzKZy2rcAhS9MICix+A3Pbi4B0=;
        b=YUjVqHXD1ZKecVgOiuh75z0uqwoVoXImpzGDOyN/dil7p/XIsjYTd6y6tZFno2+ttQ
         JEcvh/Hl0ChzLLifgmsIkEvkJZSRZQsup5SMq4XJYNY+sfhM3jRb3FmqIOrXjPrRixP6
         VuOv+ezyzzre71hcDUTFi2oHhM/3QfYL3xLYeNQAGxPh0Gue3F9klf4DpCJmg4xndpKN
         rDNX7Muu6DDmBc6xPBJ/wVnmSf36BoK0EheSq4KxLSubgKtaUe4IysNfxk5tiFpLF753
         bsqyl5sg2DxylZHTjwvFCD3+jDH9A5MD8eUI9R7lWM59QQlL0g5RnPdtlO4OJ8ccqgdm
         EOdw==
X-Gm-Message-State: AFq9FYKslUYZj/ByJZR/dJfwY6dT7hZLM8ieYOGq8UmPENdnd/qEzKoE
	o1K8G3+deqPaGwBUfN27fCHKKj8x1y+JgjeZbNzUxGXosSBPLSWgvNXN
X-Gm-Gg: AYBFou0mMUhLgqdDN5pRAjisyW0n35alChl1uKpEhqrcLUtOAT8mQ0M7PfuolOgpMZj
	n/trrE4njdURKpcJliG1rwE+TGbkZOu289b1rkctLz6YoTTOT11yQE5Rroeco2wmwnj0RB5kpjP
	Nur+wcA2/PMCElfGvo4Nj71gdM+tVNasYKznD+edh33ntRUtQXJ35c9wKqVROeFr/Ckrsao0KVn
	z+fDECFygkcMf7TqepUcqUx7q4wBEyCmiIDEkoVjO/niq/LP+LFU+gHEtUVvL7qzqv5bggz7TCa
	B+Cxfmmpff+LlC7JQoOV7lWTcqFEc0WpXL8b8FWkGB5+gveBSnDyle2HKN5+5sOFUSTW8PClRAt
	pwVxsBz1bsWCeKGDJhvQ/Bfai/NCngk94Q945aWc3cgHbX/MFlDY1ncZnw1gdgti+IMQnguZ1NY
	9Ng9CSOqS9UXQcihgmvQ5Dp+CXc5NGnqNOJdBBqRT4sylcFJczjiivyoM8HpHaU40nqy+6Mze1A
	in2FMG8uuWEeovv2pTEBiPhsGnFqxuaxg902hg=
X-Received: by 2002:a17:90b:17cd:b0:39e:6c6a:657f with SMTP id 98e67ed59e1d1-3ab3a9d3fd5mr5604542a91.66.1791673037366;
        Sat, 10 Oct 2026 15:57:17 -0700 (PDT)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e07329sm2603662a12.5.2026.10.10.15.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 15:57:17 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Richard Cheng <icheng@nvidia.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v16 3/8] cxl/cdat: Gather DSMAS data for DCD partitions
Date: Sun, 11 Oct 2026 07:54:54 +0900
Message-ID: <20261010225852.10727-4-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010225852.10727-1-anisa.su@samsung.com>
References: <20261010225852.10727-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Additional DCD partition (AKA region) information is contained in the
DSMAS CDAT tables, including performance, shareable and read-only
attributes.

Match DCD partitions with DSMAS tables and store the meta data. A DCD
shall describe its DC partition in a DSMAS entry (CXL r4.0 9.13.3), so
if the CDAT is absent, fails to parse, or has no entry matching the DC
partition, disable DCD rather than run with unknown attributes.

DSLBIS is optional, but cxl_cdat_endpoint_process() treated zero DSLBIS
entries as a parse failure, which would now disable DCD on a device with
a valid DSMAS. Accept an empty DSLBIS, and skip DSMAS entries with no
DSLBIS coordinates.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Co-developed-by: Anisa Su <anisa.su@samsung.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>

---
Changes:
1. cdat.c: initialise dsmas_entry.qos_class to CXL_QOS_CLASS_INVALID so an
   entry that is skipped (no DSLBIS) or whose QTG lookup fails no longer
   reports qos_class 0, a valid class, through update_perf_entry().
   [Sashiko]
2. mbox.c: handle > U8_MAX instead of an open-coded mask.
   [Dave]
---
 drivers/cxl/core/cdat.c   | 99 ++++++++++++++++++++++++++++++++++-----
 drivers/cxl/core/hdm.c    |  1 +
 drivers/cxl/core/mbox.c   |  9 ++++
 drivers/cxl/core/memdev.c | 17 ++++---
 drivers/cxl/cxlmem.h      | 11 +++++
 include/cxl/cxl.h         |  6 +++
 6 files changed, 124 insertions(+), 19 deletions(-)

diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
index 5c9f07262513..ef04af813dbb 100644
--- a/drivers/cxl/core/cdat.c
+++ b/drivers/cxl/core/cdat.c
@@ -17,6 +17,8 @@ struct dsmas_entry {
 	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
 	int entries;
 	int qos_class;
+	bool shareable;
+	bool read_only;
 };
 
 static u32 cdat_normalize(u16 entry, u64 base, u8 type)
@@ -73,7 +75,13 @@ static int cdat_dsmas_handler(union acpi_subtable_headers *header, void *arg,
 	if (!dent)
 		return -ENOMEM;
 
+	/* Stays invalid unless the QTG lookup assigns a class */
+	dent->qos_class = CXL_QOS_CLASS_INVALID;
 	dent->handle = dsmas->dsmad_handle;
+	/* Shareable is CDAT 1.03 and later, DSMAS Flags bit 3 */
+	dent->shareable = dsmas->flags & ACPI_CDAT_DSMAS_SHAREABLE;
+	/* Read Only is CDAT 1.04 and later, DSMAS Flags bit 6 */
+	dent->read_only = dsmas->flags & ACPI_CDAT_DSMAS_READ_ONLY;
 	dent->dpa_range.start = le64_to_cpu((__force __le64)dsmas->dpa_base_address);
 	dent->dpa_range.end = le64_to_cpu((__force __le64)dsmas->dpa_base_address) +
 			      le64_to_cpu((__force __le64)dsmas->dpa_length) - 1;
@@ -188,9 +196,10 @@ static int cxl_cdat_endpoint_process(struct cxl_port *port,
 	if (rc)
 		return rc;
 
+	/* DSLBIS is optional; zero entries is not an error */
 	rc = cdat_table_parse(ACPI_CDAT_TYPE_DSLBIS, cdat_dslbis_handler,
 			      dsmas_xa, port->cdat.table, port->cdat.length);
-	return cdat_table_parse_output(rc);
+	return rc < 0 ? rc : 0;
 }
 
 static int cxl_port_perf_data_calculate(struct cxl_port *port,
@@ -219,6 +228,13 @@ static int cxl_port_perf_data_calculate(struct cxl_port *port,
 	xa_for_each(dsmas_xa, index, dent) {
 		int qos_class;
 
+		/* No DSLBIS for this DSMAS; nothing to hand the QTG _DSM */
+		if (!dent->cdat_coord[ACCESS_COORDINATE_CPU].read_bandwidth &&
+		    !dent->cdat_coord[ACCESS_COORDINATE_CPU].write_bandwidth &&
+		    !dent->cdat_coord[ACCESS_COORDINATE_CPU].read_latency &&
+		    !dent->cdat_coord[ACCESS_COORDINATE_CPU].write_latency)
+			continue;
+
 		cxl_coordinates_combine(dent->coord, dent->cdat_coord, ep_c);
 		dent->entries = 1;
 		rc = cxl_root->ops.qos_class(cxl_root,
@@ -255,35 +271,90 @@ static void update_perf_entry(struct device *dev, struct dsmas_entry *dent,
 		dent->coord[ACCESS_COORDINATE_CPU].write_latency);
 }
 
-static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
-				     struct xarray *dsmas_xa)
+/*
+ * A DCD shall describe its DC partition in a DSMAS entry (CXL r4.0 9.13.3).
+ * Without one the partition's attributes are unknown, so disable DCD.
+ */
+static void cxl_dcd_dsmas_missing(struct cxl_dev_state *cxlds, const char *why)
+{
+	struct cxl_memdev_state *mds;
+
+	if (cxlds->type != CXL_DEVTYPE_CLASSMEM)
+		return;
+
+	mds = to_cxl_memdev_state(cxlds);
+	if (!cxl_dcd_supported(mds) ||
+	    !cxl_part_size(cxlds, CXL_PARTMODE_DYNAMIC_RAM))
+		return;
+
+	dev_warn(cxlds->dev, "DC partition has no valid DSMAS entry (%s), disabling DCD\n",
+		 why);
+	cxl_disable_dcd(mds);
+}
+
+enum cxl_dsmas_apply {
+	CXL_DSMAS_APPLY_FLAGS,		/* shareable etc.; no QTG data */
+	CXL_DSMAS_APPLY_FLAGS_PERF,	/* perf coordinates and qos_class */
+};
+
+/*
+ * DSMAS flags such as shareable are properties of the CDAT entry and are
+ * applied regardless; perf data is applied only if the QTG lookup produced
+ * recommendations.
+ */
+static void cxl_memdev_apply_dsmas(struct cxl_dev_state *cxlds,
+				   struct xarray *dsmas_xa,
+				   enum cxl_dsmas_apply attrs)
 {
 	struct device *dev = cxlds->dev;
 	struct dsmas_entry *dent;
+	bool dc_matched = false;
 	unsigned long index;
 
 	xa_for_each(dsmas_xa, index, dent) {
 		bool found = false;
 
 		for (int i = 0; i < cxlds->nr_partitions; i++) {
-			struct resource *res = &cxlds->part[i].res;
+			struct cxl_dpa_partition *part = &cxlds->part[i];
 			struct range range = {
-				.start = res->start,
-				.end = res->end,
+				.start = part->res.start,
+				.end = part->res.end,
 			};
 
-			if (range_contains(&range, &dent->dpa_range)) {
-				update_perf_entry(dev, dent,
-						  &cxlds->part[i].perf);
-				found = true;
+			if (!range_contains(&range, &dent->dpa_range))
+				continue;
+
+			found = true;
+			/*
+			 * part->handle is from Get DC Config, dent->handle
+			 * from the CDAT DSMAS entry.
+			 */
+			if (part->mode == CXL_PARTMODE_DYNAMIC_RAM &&
+			    dent->handle != part->handle) {
+				dev_warn(dev,
+					 "DSMAD handle mismatch: %pra has %u, DSMAS %pra has %u\n",
+					 &range, part->handle,
+					 &dent->dpa_range, dent->handle);
 				break;
 			}
+
+			if (attrs == CXL_DSMAS_APPLY_FLAGS_PERF)
+				update_perf_entry(dev, dent, &part->perf);
+			if (part->mode == CXL_PARTMODE_DYNAMIC_RAM) {
+				part->shareable = dent->shareable;
+				part->read_only = dent->read_only;
+				dc_matched = true;
+			}
+			break;
 		}
 
 		if (!found)
 			dev_dbg(dev, "no partition for dsmas dpa: %pra\n",
 				&dent->dpa_range);
 	}
+
+	if (!dc_matched)
+		cxl_dcd_dsmas_missing(cxlds, "no matching entry");
 }
 
 static int match_cxlrd_qos_class(struct device *dev, void *data)
@@ -409,22 +480,26 @@ void cxl_endpoint_parse_cdat(struct cxl_port *port)
 	int rc;
 
 	xa_init(&__dsmas_xa);
-	if (!port->cdat.table)
+	if (!port->cdat.table) {
+		cxl_dcd_dsmas_missing(cxlds, "no CDAT");
 		return;
+	}
 
 	rc = cxl_cdat_endpoint_process(port, dsmas_xa);
 	if (rc < 0) {
 		dev_dbg(&port->dev, "Failed to parse CDAT: %d\n", rc);
+		cxl_dcd_dsmas_missing(cxlds, "CDAT parse failed");
 		return;
 	}
 
 	rc = cxl_port_perf_data_calculate(port, dsmas_xa);
 	if (rc) {
 		dev_dbg(&port->dev, "Failed to do perf coord calculations.\n");
+		cxl_memdev_apply_dsmas(cxlds, dsmas_xa, CXL_DSMAS_APPLY_FLAGS);
 		return;
 	}
 
-	cxl_memdev_set_qos_class(cxlds, dsmas_xa);
+	cxl_memdev_apply_dsmas(cxlds, dsmas_xa, CXL_DSMAS_APPLY_FLAGS_PERF);
 	cxl_qos_class_verify(cxlmd);
 	cxl_memdev_update_perf(cxlmd);
 }
diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 5fa2177cefcc..379540246333 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -486,6 +486,7 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
 
 		cxlds->part[i].perf.qos_class = CXL_QOS_CLASS_INVALID;
 		cxlds->part[i].mode = part->mode;
+		cxlds->part[i].handle = part->handle;
 
 		/* Require ordered + contiguous partitions */
 		if (i) {
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 72af23ba288e..ae00e940d68c 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1366,6 +1366,7 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part,
 	u64 decode_len = le64_to_cpu(dev_part->decode_length);
 	u64 blk_size = le64_to_cpu(dev_part->block_size);
 	u64 len = le64_to_cpu(dev_part->length);
+	u32 handle = le32_to_cpu(dev_part->dsmad_handle);
 	u64 size;
 
 	/*
@@ -1378,6 +1379,13 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part,
 		return 0;
 	}
 
+	/* The CDAT DSMAD handle this refers to is 8 bits */
+	if (handle > U8_MAX) {
+		dev_warn(dev, "DSMAD handle 0x%x exceeds the 8 bit CDAT DSMAD handle\n",
+			 handle);
+		return -EINVAL;
+	}
+
 	/*
 	 * Decode length is a count of 256M units, so a device reporting 2^36
 	 * or more wraps.
@@ -1391,6 +1399,7 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part,
 	*part = (struct cxl_dc_partition_info) {
 		.start = le64_to_cpu(dev_part->base),
 		.size = size,
+		.handle = handle,
 	};
 
 	/*
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 469767f1de70..71493231f5e5 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -594,7 +594,8 @@ bool is_cxl_memdev(const struct device *dev)
 }
 EXPORT_SYMBOL_NS_GPL(is_cxl_memdev, "CXL");
 
-static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
+static void add_part(struct cxl_dpa_info *info, u64 start, u64 size,
+		     enum cxl_partition_mode mode, u8 handle)
 {
 	int i = info->nr_partitions;
 
@@ -606,6 +607,7 @@ static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_pa
 		.end = start + size - 1,
 	};
 	info->part[i].mode = mode;
+	info->part[i].handle = handle;
 	info->nr_partitions++;
 }
 
@@ -623,9 +625,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
 	info->size = mds->total_bytes;
 
 	if (mds->partition_align_bytes == 0) {
-		add_part(info, 0, mds->volatile_only_bytes, CXL_PARTMODE_RAM);
+		add_part(info, 0, mds->volatile_only_bytes, CXL_PARTMODE_RAM, 0);
 		add_part(info, mds->volatile_only_bytes,
-			 mds->persistent_only_bytes, CXL_PARTMODE_PMEM);
+			 mds->persistent_only_bytes, CXL_PARTMODE_PMEM, 0);
 		return 0;
 	}
 
@@ -635,9 +637,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
 		return rc;
 	}
 
-	add_part(info, 0, mds->active_volatile_bytes, CXL_PARTMODE_RAM);
+	add_part(info, 0, mds->active_volatile_bytes, CXL_PARTMODE_RAM, 0);
 	add_part(info, mds->active_volatile_bytes, mds->active_persistent_bytes,
-		 CXL_PARTMODE_PMEM);
+		 CXL_PARTMODE_PMEM, 0);
 
 	return 0;
 }
@@ -691,7 +693,8 @@ int cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
 		info->size = dc_end;
 	dev_dbg(dev, "Adding dynamic ram partition; %#llx size %#llx\n",
 		dc_info.start, dc_info.size);
-	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM);
+	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM,
+		 dc_info.handle);
 
 	return 0;
 }
@@ -709,7 +712,7 @@ int cxl_set_capacity(struct cxl_dev_state *cxlds, u64 capacity)
 		.size = capacity,
 	};
 
-	add_part(&range_info, 0, capacity, CXL_PARTMODE_RAM);
+	add_part(&range_info, 0, capacity, CXL_PARTMODE_RAM, 0);
 	return cxl_dpa_setup(cxlds, &range_info);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_set_capacity, "CXL");
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 4fac65dbb808..b539b5a5c829 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -140,6 +140,7 @@ struct cxl_dpa_info {
 	struct cxl_dpa_part_info {
 		struct range range;
 		enum cxl_partition_mode mode;
+		u8 handle;
 	} part[CXL_NR_PARTITIONS_MAX];
 	int nr_partitions;
 };
@@ -421,6 +422,15 @@ static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
 	return 0;
 }
 
+static inline resource_size_t cxl_part_size(struct cxl_dev_state *cxlds,
+					    enum cxl_partition_mode mode)
+{
+	for (int i = 0; i < cxlds->nr_partitions; i++)
+		if (cxlds->part[i].mode == mode)
+			return resource_size(&cxlds->part[i].res);
+	return 0;
+}
+
 static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
 {
 	return dev_get_drvdata(cxl_mbox->host);
@@ -851,6 +861,7 @@ int cxl_dev_state_identify(struct cxl_memdev_state *mds);
 struct cxl_dc_partition_info {
 	u64 start;
 	u64 size;
+	u8 handle;
 };
 
 int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
index e07360849344..728decda57fd 100644
--- a/include/cxl/cxl.h
+++ b/include/cxl/cxl.h
@@ -141,11 +141,17 @@ enum cxl_partition_mode {
  * @res: shortcut to the partition in the DPA resource tree (cxlds->dpa_res)
  * @perf: performance attributes of the partition from CDAT
  * @mode: operation mode for the DPA capacity, e.g. ram, pmem, dynamic...
+ * @handle: DSMAS handle that represents this partition
+ * @shareable: Is the partition shareable (from its CDAT DSMAS entry)
+ * @read_only: Is the partition read-only (from its CDAT DSMAS entry)
  */
 struct cxl_dpa_partition {
 	struct resource res;
 	struct cxl_dpa_perf perf;
 	enum cxl_partition_mode mode;
+	u8 handle;
+	bool shareable;
+	bool read_only;
 };
 
 #define CXL_NR_PARTITIONS_MAX 3
-- 
2.43.0

