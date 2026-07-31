Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5F73D75D1
	for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 08:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487781; cv=none; b=Lq29BNpj420f8jyP+MFXmF/wAmj+74khMr4RbEAjnHh8Ic4F5aCzo/an49O9Kw+bdSpf2wF3D9ZZr9GlBKv2Iy7JE4vPSgrzjBGYZHitNd9JKpxre/EF8mcMh8SJySRGedxcujpftuCmYBGScrX4w0nti//qm4DJW5pZMEGUDio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487781; c=relaxed/simple;
	bh=5CJDiK1L6YNDbUW5Cu1Fdb5mVPJ25ymBR9VdR1qYoH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7SooVKcu+Pzt95fry8qA/wRHzSI0uHVy1hapTO/Q1y/HHXM1uYenIo1Y9JQ5zEcmofz/Jb5ss8F6H7b/U6cE9yUaAinm/+bElW51OUCgVJFiG43iRCeWecmzV1vMpz4dKRdBvVSpUeJ5OroKEfW8xZ9EX69Kpk2l6Jr6YR+C48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eqmw4Fmp; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eqmw4Fmp"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2caea3f742bso8240645ad.0
        for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 01:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785487780; x=1786092580; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lw90wO5t99ejao3BX1gIeILEn6WuTY7Fx6rXmrY2A4M=;
        b=Eqmw4Fmp7FN1yKfQnaqnnoE5iHkELkNJFqkeuv2XLdrnREyowplHTiKCRNin5YaLTU
         b4SSfk3InPcgngSlSnKKlahdZdHSzt56h3i7G7POHhDuLs8+PvORYXr0AGaSv2zR/gMu
         dPMvTiLv8JOv6gQaXL+s5hrJwWDczQiuXFZ3uqlu2irx5kF4D4IV1GZL3DLPK49uAnaK
         hvbuCILR6yATd3HaRedOqfxqK/B7XHEJG691+8atGMo7Ql0+66+jTGANYwtakUbnadIe
         aefJTmKMFK1Ly86eCnNg0e5OSt42PE2verIdSiZS0lWip4xHdCMu84Tdc492xh2ZsfZw
         yS2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785487780; x=1786092580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lw90wO5t99ejao3BX1gIeILEn6WuTY7Fx6rXmrY2A4M=;
        b=r2FkT34VWlF+92XCbFalv418n2CTGz6EeM+LSdJ3G79aeW8nENImEtEnkQpA39Hm/Z
         ajy2qgNrOkaYL0D+4ohpO76sqznaNEMJe8mVkgsBrmbJEBJQnxNLxAgsTgCIR9DoviNo
         aOH+lRSM9AFodnfYFttjvU81P8kBMnNq8ZfJNgL+h0mEgi9LhV+Zv+WR/9wuIjdw+AOu
         KKhMFtbhzZTKkwYIFIKm009I6J+w/vOtHseRw2Mrp/F/dylUVXSuFt0hchvyEy0PEOTx
         RdO3vx2piYcgaqUIrg4e9kFKFA6MxKmyZLYZm0RdU+czwBMe+kQJue5UjKUMSW2SoJ+M
         glzw==
X-Gm-Message-State: AOJu0YzVN5mRZYd+fKQ9pgC/5ceLVWFiO8TUmC63StIrWh8YxCLWGWZq
	Cx+7BZzv6PYh3thsPshQzlM4HZTenaDrjeHFEKHOeJ5KPRk6z1BStxSm
X-Gm-Gg: AR+sD127/hOzV+jhlIPZz4DytBLBcOcXbsk18GTpSClsyNdDugvcdf2C8b/RWGSpnoI
	qzD6FoLoq74prJe/uRz9VsbbgpJCsSPgUlAWvVWT/nlzliYtbLUGPpbg8XDHeo0p6X3exWrafaz
	VwYX1HCMhhJlfMfSwHWXBL18JpDEWx1kjsnzpn0Wt0omobIzko742lPkh758si4MhNAUReXIHiF
	c5Sh3La0I9aOxbCP6Ik4Mc9gO/CB1lCTDIg85fXGnglBHfR+AV1UXXzZq7LDZXDQ5zr45pa7yEU
	c5TQf4Ma9dMz2+u1gvQi5j6zmALWjvPSI3o6GCc+in1O3IDkchkhjWriAWumqqrAmHVqChuENg0
	65Kp6TFBkRFtdxyIlKL4UY9zVIGLh4mwtUjixK40+EPOUoRUz09ao56kbEqzKobKPURfd6Z2Li5
	HsKQJpH6cGNJwjEAUmbWE68zkJUdhP2N6O0pj+SHpWqbzGQ95xoDPuOnYPmofL9vgqu2u5T0VeX
	l2yzYcJTlk8Kkd6v/R+9v6/pcf4aTBUmISOzjy0rkPD3BUkMNhcdwk=
X-Received: by 2002:a17:903:2c0c:b0:2ca:73aa:b48f with SMTP id d9443c01a7336-2d046e99fdcmr11410495ad.35.1785487779751;
        Fri, 31 Jul 2026 01:49:39 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae5abaesm2708425ad.27.2026.07.31.01.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 01:49:39 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Wonjae Lee <wj28.lee@samsung.com>,
	Junhee Park <jh9934.park@samsung.com>,
	Heesoo Kim <habil.kim@samsung.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v12 3/8] cxl/cdat: Gather DSMAS data for DCD partitions
Date: Fri, 31 Jul 2026 01:48:08 -0700
Message-ID: <20260731084901.1512819-4-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260731084901.1512819-1-anisa.su@samsung.com>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Additional DCD partition (AKA region) information is contained in the
DSMAS CDAT tables, including performance, read only, and shareable
attributes.

Match DCD partitions with DSMAS tables and store the meta data.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Co-developed-by: Anisa Su <anisa.su@samsung.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/core/cdat.c | 13 +++++++++++++
 drivers/cxl/core/hdm.c  |  1 +
 drivers/cxl/core/mbox.c | 22 ++++++++++++++++------
 drivers/cxl/cxlmem.h    |  2 ++
 include/cxl/cxl.h       |  4 ++++
 5 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
index 5c9f07262513..37136b2cf7e4 100644
--- a/drivers/cxl/core/cdat.c
+++ b/drivers/cxl/core/cdat.c
@@ -17,6 +17,7 @@ struct dsmas_entry {
 	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
 	int entries;
 	int qos_class;
+	bool shareable;
 };
 
 static u32 cdat_normalize(u16 entry, u64 base, u8 type)
@@ -74,6 +75,7 @@ static int cdat_dsmas_handler(union acpi_subtable_headers *header, void *arg,
 		return -ENOMEM;
 
 	dent->handle = dsmas->dsmad_handle;
+	dent->shareable = dsmas->flags & ACPI_CDAT_DSMAS_SHAREABLE;
 	dent->dpa_range.start = le64_to_cpu((__force __le64)dsmas->dpa_base_address);
 	dent->dpa_range.end = le64_to_cpu((__force __le64)dsmas->dpa_base_address) +
 			      le64_to_cpu((__force __le64)dsmas->dpa_length) - 1;
@@ -266,15 +268,26 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
 		bool found = false;
 
 		for (int i = 0; i < cxlds->nr_partitions; i++) {
+			enum cxl_partition_mode mode = cxlds->part[i].mode;
 			struct resource *res = &cxlds->part[i].res;
+			u8 handle = cxlds->part[i].handle;
 			struct range range = {
 				.start = res->start,
 				.end = res->end,
 			};
 
 			if (range_contains(&range, &dent->dpa_range)) {
+				if (mode == CXL_PARTMODE_DYNAMIC_RAM_1 &&
+				    dent->handle != handle) {
+					dev_warn(dev,
+						 "Dynamic RAM perf mismatch; %pra (%u) vs %pra (%u)\n",
+						 &range, handle, &dent->dpa_range,
+						 dent->handle);
+					continue;
+				}
 				update_perf_entry(dev, dent,
 						  &cxlds->part[i].perf);
+				cxlds->part[i].shareable = dent->shareable;
 				found = true;
 				break;
 			}
diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 0ef076c08ed2..7f63b86887f4 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -477,6 +477,7 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
 
 		cxlds->part[i].perf.qos_class = CXL_QOS_CLASS_INVALID;
 		cxlds->part[i].mode = part->mode;
+		cxlds->part[i].handle = part->handle;
 
 		/* Require ordered + contiguous partitions */
 		if (i) {
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index d79019fbd790..a6cdea9f4080 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1357,10 +1357,16 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_a
 {
 	u64 blk_size = le64_to_cpu(dev_part->block_size);
 	u64 len = le64_to_cpu(dev_part->length);
+	u32 handle = le32_to_cpu(dev_part->dsmad_handle);
 
 	part_array[index].start = le64_to_cpu(dev_part->base);
 	part_array[index].size = le64_to_cpu(dev_part->decode_length);
 	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
+	if (handle & ~0xFF) {
+		dev_warn(dev, "DSMAD handle 0x%x has non-zero reserved bits\n", handle);
+		return -EINVAL;
+	}
+	part_array[index].handle = handle;
 
 	/* Check partitions are in increasing DPA order */
 	if (index > 0) {
@@ -1536,6 +1542,7 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
 	/* Return 1st partition */
 	dc_info->start = partitions[0].start;
 	dc_info->size = partitions[0].size;
+	dc_info->handle = partitions[0].handle;
 	dev_dbg(dev, "Returning partition 0 %llu size %llu\n",
 		dc_info->start, dc_info->size);
 
@@ -1543,7 +1550,8 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
 }
 EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
 
-static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
+static void add_part(struct cxl_dpa_info *info, u64 start, u64 size,
+		     enum cxl_partition_mode mode, u8 handle)
 {
 	int i = info->nr_partitions;
 
@@ -1555,6 +1563,7 @@ static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_pa
 		.end = start + size - 1,
 	};
 	info->part[i].mode = mode;
+	info->part[i].handle = handle;
 	info->nr_partitions++;
 }
 
@@ -1572,9 +1581,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
 	info->size = mds->total_bytes;
 
 	if (mds->partition_align_bytes == 0) {
-		add_part(info, 0, mds->volatile_only_bytes, CXL_PARTMODE_RAM);
+		add_part(info, 0, mds->volatile_only_bytes, CXL_PARTMODE_RAM, 0);
 		add_part(info, mds->volatile_only_bytes,
-			 mds->persistent_only_bytes, CXL_PARTMODE_PMEM);
+			 mds->persistent_only_bytes, CXL_PARTMODE_PMEM, 0);
 		return 0;
 	}
 
@@ -1584,9 +1593,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
 		return rc;
 	}
 
-	add_part(info, 0, mds->active_volatile_bytes, CXL_PARTMODE_RAM);
+	add_part(info, 0, mds->active_volatile_bytes, CXL_PARTMODE_RAM, 0);
 	add_part(info, mds->active_volatile_bytes, mds->active_persistent_bytes,
-		 CXL_PARTMODE_PMEM);
+		 CXL_PARTMODE_PMEM, 0);
 
 	return 0;
 }
@@ -1638,7 +1647,8 @@ void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
 	info->size += dc_info.size;
 	dev_dbg(dev, "Adding dynamic ram partition 1; %llu size %llu\n",
 		dc_info.start, dc_info.size);
-	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1);
+	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1,
+		 dc_info.handle);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
 
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index a9782939d82b..eb1e6f7a2038 100644
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
@@ -853,6 +854,7 @@ int cxl_dev_state_identify(struct cxl_memdev_state *mds);
 struct cxl_dc_partition_info {
 	u64 start;
 	u64 size;
+	u8 handle;
 };
 
 int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
index 87c2bd73df21..baf0132c70a3 100644
--- a/include/cxl/cxl.h
+++ b/include/cxl/cxl.h
@@ -141,11 +141,15 @@ enum cxl_partition_mode {
  * @res: shortcut to the partition in the DPA resource tree (cxlds->dpa_res)
  * @perf: performance attributes of the partition from CDAT
  * @mode: operation mode for the DPA capacity, e.g. ram, pmem, dynamic...
+ * @handle: DSMAS handle intended to represent this partition
+ * @shareable: Is the partition sharable (from its CDAT DSMAS entry)
  */
 struct cxl_dpa_partition {
 	struct resource res;
 	struct cxl_dpa_perf perf;
 	enum cxl_partition_mode mode;
+	u8 handle;
+	bool shareable;
 };
 
 #define CXL_NR_PARTITIONS_MAX 3
-- 
2.43.0

