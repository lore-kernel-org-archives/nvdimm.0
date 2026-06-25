Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9724526ED40
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 18:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782410439; cv=none; b=lIL26vbq2b3DYpj9/AZcYmLDiC0TVvf3IvLgoi3Cb1IkUulRfbVFIDssaJAygSqe/6eHXvy54KPG14EvXmEtFJtMhpWPvyww2ORbk1L82TApoq7BbOJ/7w+3VhZhdJyqAUaewFkZKEMmwvquKS9GBb+2OvMUWQ9DugzUdummXW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782410439; c=relaxed/simple;
	bh=pXskB7V/BiUpPqw9qe3Kk5Vjo3SgTVD5AFV76qhpkLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHuWMZGxAXyRBJZDMqWtOC1Njd2jByh+0+D7RVNar276X6csfdHIOzXP85f87l8ZFyE5oYb3US/RJAaiXYgCzdTUhoEdNQlyexGLctnM46zn5cRXHKWLaaVUEPm8s4jcZJhoB6MALGjkZPBtBuiV8krh026k0Br8od7xZfJ3Wtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AGXZ8jdU; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AGXZ8jdU"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-80814edb536so2748437b3.2
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782410437; x=1783015237; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WfaXLqKxjt5Wx4fK3p1hZTD/ltdo7YYhn5wzBTFnlbE=;
        b=AGXZ8jdUo+csVGffAQ8yQDnTmJxhk0Eo6CKIdiyyAyLDvldI/Jvxu1Y2w5hf7eBz8d
         +i+AG8e+zUgGU2thCTxypNQO1XCf3m527KcOwPtSipNgUv9Skt7rfxZ5nLOV2hxm6H0B
         h5ijnxFxsk3hoXQ+AkLPrB0nmqlhUAFj1ziMKtMxEmtWEdiuSA4wVbQpX3qmO05XV4Ql
         QNH7wy/QYvPNvWdCwXqp0gByECziRJwuqPwUaNKn/6rH+T5D77aQLLoLWpW6EER/4b/k
         FSEqKoyqtof2XoRhX1DBM89Lr+LHs6TG55QJiTHoxbH3ksjO2jiS9J79Kj5MUebW7Wh2
         SVUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782410437; x=1783015237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WfaXLqKxjt5Wx4fK3p1hZTD/ltdo7YYhn5wzBTFnlbE=;
        b=TUGRkudb8nKG4+C1Np53YEsVdSRecDl7w2w+/0O4/krxTvpwo+/Dwr/5lNo31crHZy
         UbbhFoyEDDsQY4JD3YDoiSL1XxPof/eeCCLHTAWfWddgqE54G92aekJN/o9kcz2mMzN+
         zhYFvzTSQkqo99U2M7XsClcykB4ziKQIKKsP7V/l6ClEtcSf1BH/2A0arMBYoTwvyuGA
         MSG8SIZZStf+JQm0PQ80xfCUH06oh2H5ztg8o6gNU+X5B7kvlrvOU0J7l+8ZZGI+1aGE
         jOO94pqP5j9x0pIlOOJoHDGPqcfCgzEia5YuNgNbNw9ZGO1Fg1fHO+lUaxT7xBTtAb0z
         NBsQ==
X-Gm-Message-State: AOJu0Yy+HFsMHxvphLwVrauoO94NNQqKY6WME87FQzNPq16WjP1BD07f
	iJalVxrM6zGqIRDZ1JvpjUK349VH8ZNtmk14g2YLdqmm2askyikc4ps5
X-Gm-Gg: AfdE7cn7+WeqsTrddTU6JCfzElszmvg5x9AoKwyMgE15PjujSRnYTS7CbVQNgXjiFEP
	JnTnLd+Su7t+lL3SWXXtyMbHk9FJ12i8S0IujM25WV1jQFlkhGK+An2jhaHNnT+uG68PRsNQq/3
	71TPqPNEziaJ55QkVbBD69ggDUEHqYcfepR91OGKrLijhj+3BmTVlTDpkSQaV3Dv5BzSkPZvegJ
	8MljI1Tm4/HBMdqs2KSAgp4evEXQdelXuj4rHcCscSxaHVxi5yde2KC44rvd6B/h6ZukE9KDW4Q
	VxhiDUv73fikJXtDIrcVLlV8AQuNS1nY56MLZjvKl0t4AmNzAVmPqFzAd1GDTXcOmAmHjsVuuag
	PyY6JQAF/QkIKmVYHhEbRF2qBLAZ+XPiKKzsNYBk0wM/IMbj5c5wiZjMHQLn1QlpMy+6dBMjrkU
	UdFdOsvyEM5eWzxQDLJI4x4rZ1942uEP4=
X-Received: by 2002:a05:690c:604:b0:7dc:f7b3:8e08 with SMTP id 00721157ae682-80a6af938c8mr39725327b3.23.1782410436320;
        Thu, 25 Jun 2026 11:00:36 -0700 (PDT)
Received: from 4470NRD-ASU.ssi.samsung.com ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-80259d20d84sm74353767b3.0.2026.06.25.11.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 11:00:36 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	djbw@kernel.org,
	jic23@kernel.org,
	dave@stgolabs.net,
	dave.jiang@intel.com,
	vishal.l.verma@intel.com,
	iweiny@kernel.org,
	alison.schofield@intel.com,
	gourry@gourry.net,
	anisa.su@samsung.com
Subject: [PATCH v11 03/31] cxl/cdat: Gather DSMAS data for DCD partitions
Date: Thu, 25 Jun 2026 11:00:12 -0700
Message-ID: <20260625180028.965-1-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
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
Signed-off-by: Anisa Su <anisa.su@samsung.com>
---
 drivers/cxl/core/cdat.c | 12 ++++++++++++
 drivers/cxl/core/hdm.c  |  1 +
 drivers/cxl/core/mbox.c | 22 ++++++++++++++++------
 drivers/cxl/cxlmem.h    |  2 ++
 include/cxl/cxl.h       |  4 ++++
 5 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
index 5c9f07262513..a280039e4cd1 100644
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
@@ -266,15 +268,25 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
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
+						"Dynamic RAM perf mismatch; %pra (%u) vs %pra (%u)\n",
+						&range, handle, &dent->dpa_range, dent->handle);
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
index 2932bbd67e55..bdb908c6e7f3 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1352,10 +1352,16 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_a
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
@@ -1522,6 +1528,7 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
 	/* Return 1st partition */
 	dc_info->start = partitions[0].start;
 	dc_info->size = partitions[0].size;
+	dc_info->handle = partitions[0].handle;
 	dev_dbg(dev, "Returning partition 0 %llu size %llu\n",
 		dc_info->start, dc_info->size);
 
@@ -1529,7 +1536,8 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
 }
 EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
 
-static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
+static void add_part(struct cxl_dpa_info *info, u64 start, u64 size,
+		     enum cxl_partition_mode mode, u8 handle)
 {
 	int i = info->nr_partitions;
 
@@ -1541,6 +1549,7 @@ static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_pa
 		.end = start + size - 1,
 	};
 	info->part[i].mode = mode;
+	info->part[i].handle = handle;
 	info->nr_partitions++;
 }
 
@@ -1558,9 +1567,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
 	info->size = mds->total_bytes;
 
 	if (mds->partition_align_bytes == 0) {
-		add_part(info, 0, mds->volatile_only_bytes, CXL_PARTMODE_RAM);
+		add_part(info, 0, mds->volatile_only_bytes, CXL_PARTMODE_RAM, 0);
 		add_part(info, mds->volatile_only_bytes,
-			 mds->persistent_only_bytes, CXL_PARTMODE_PMEM);
+			 mds->persistent_only_bytes, CXL_PARTMODE_PMEM, 0);
 		return 0;
 	}
 
@@ -1570,9 +1579,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
 		return rc;
 	}
 
-	add_part(info, 0, mds->active_volatile_bytes, CXL_PARTMODE_RAM);
+	add_part(info, 0, mds->active_volatile_bytes, CXL_PARTMODE_RAM, 0);
 	add_part(info, mds->active_volatile_bytes, mds->active_persistent_bytes,
-		 CXL_PARTMODE_PMEM);
+		 CXL_PARTMODE_PMEM, 0);
 
 	return 0;
 }
@@ -1624,7 +1633,8 @@ void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
 	info->size += dc_info.size;
 	dev_dbg(dev, "Adding dynamic ram partition 1; %llu size %llu\n",
 		dc_info.start, dc_info.size);
-	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1);
+	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1,
+		 dc_info.handle);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
 
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 6b548a1ec1e9..b29fb16725b4 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -118,6 +118,7 @@ struct cxl_dpa_info {
 	struct cxl_dpa_part_info {
 		struct range range;
 		enum cxl_partition_mode mode;
+		u8 handle;
 	} part[CXL_NR_PARTITIONS_MAX];
 	int nr_partitions;
 };
@@ -823,6 +824,7 @@ int cxl_dev_state_identify(struct cxl_memdev_state *mds);
 struct cxl_dc_partition_info {
 	u64 start;
 	u64 size;
+	u8 handle;
 };
 
 int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
index e8a0899960d4..502d8333318b 100644
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

