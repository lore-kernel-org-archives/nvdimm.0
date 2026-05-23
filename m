Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDEA385503
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529421; cv=none; b=jtGxwBTb7x5uwpcBrnm7M/ehdt/Sg6DLltb+QmQgTrgXIhzj1at3rKbvpL92dHBhu3QivqxmEEwRNzSOnAr4d37cLeSJ0oK47Nce7iPotI6E62sPU7OQzSIo7S1qldfKLEtJpDlXrbjd3ry8uk7nFHXzI4Fu/aqFhVv+g2iia3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529421; c=relaxed/simple;
	bh=dV4P3xSGrsj2qIQxG9IT9QlcLXBACHur0k+875ZgeJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQFvygWOKU7oma4q5FMuFY1JoG5hx3hahWnASkJS3b8l1c8/1CrEkFmiDBmd6T1aqC75t8QJ5dVM4UxgFNrlC7GGSDKo6A+Sf30OpF+Gs62tETdcHImMTWzInQwurtVrO+lvgGnyozRXjS3WgqzyZt5NpeHBdU1CNOvMglPv75w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nw+cnXVY; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nw+cnXVY"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1363e78746eso3079860c88.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529417; x=1780134217; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9BE1R9+1yOEFEgejJi2pBegPCPHKSXEFwRMfiz9Ud5k=;
        b=nw+cnXVYbckev9EG+1V8GTE0alD4slWMul0v0ZTWcnzo05Dwn20+mH1ybmTczkM5AI
         t+z4zOyH+dGkQDSzTI1CfwNwYBJzEDg2xHuUcxV6wlsJrnHLPNe1IS+654v5Rd4RlfxW
         jPLQM8lLgDP0lYC2RGnFXoeSgqoW5oLKl1ltNAm8NmxZhUpIVowrjtS0uHZQPlP8k0dJ
         1glIIOmrHAlNMWgiOivyUf5EmLiswIUs2YWbYvfWx9iaXtz1KOYi+oDt1GVUQecxlZxW
         Fw8C6Vd3hO3JILmrqBtAD/DOsGkQyMINzCPWJFt5MplerCVec7OFMBzyA2NE/Wz2cnT6
         pWkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529417; x=1780134217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9BE1R9+1yOEFEgejJi2pBegPCPHKSXEFwRMfiz9Ud5k=;
        b=dyjhif+xZrXHKOyYV3h2D4TzPPJqVshm8qBHNhPQpdtLo+XN4guNur4GOq3TBM8jdQ
         SKitomgjV4uY/DDruGsuQf+B0Uw8xs1sNXDwqRFRgM5Q0HkRPRYaKyQphoe6AQHSCyWJ
         oonkukyVZ25NOPVcMfKn1F4GDVLmFt6aa2rHTtc50c+Gz+VjBAKFEoMf7QwLdyTxqtyc
         x7To3piKjWz8FoGpffUqcCzzFH2et2DQSKz/D7wgGEY2NMXB8lGwRgXR4Y9g9wZIBMFq
         cWlb2OsEnIpL20TmQceHOOKB8fUnVOU6svBIvOcoy9FhUXmuaTokACFVPhGZE5oXh83i
         Zvsw==
X-Gm-Message-State: AOJu0YygCDS0azxDhcXgACCzaGIxCcpalOpqPnRcBVX5/Ms6KiaEdltQ
	imd2nX3bSif4eahG5i2Z3CZ8xUog3DQEt+xviXJrUE7EHhf/Nbmfjbis
X-Gm-Gg: Acq92OFvUGLdC0tgORbRT5v0AcxqQAW7i4i9XM8xot0syAogw6Ghbf+ZOFG793KTiR+
	RiP8O6sIqPjVQm0LIBRfUQ1ccO4tkKCZI8vkLYI2OKSrGn2i+nY3E6sBLHsdRYyinn8bE/Zumx8
	yHkqlESAfqM0ukpB57agPYseRob1RVED6vHJyXqlNkgFHQImr/c12WmwPIUYIkuMcAspvcYTOnB
	LzwZq5/l6XXUgmHibKyW/d8kkRo6rCjV8Y4MhzZ2S3pOJKzFjsc2nClmYAjgSS78demZnN85AV0
	rnbaCmqJPAPTnWqQiWqol+AmsMMX+N9FD958E115HJDbpp96LG+gjnAtJZnl68rzl39h11OHbit
	FBNKNj13XBogHzr5Q/JbzEKmUMln4A10LmYNbGrfxl4g5UolCIEbfVOEYA4cO1osHjLIE6hIvb2
	iVnucEmBYbvkv4Wi3C36DvMRuqQ1sHme5eYGlbzktcP3j6ad0ENXaViToata9Wi6E8hw2vZ/KFa
	EWP5Dg=
X-Received: by 2002:a05:7022:699f:b0:128:d5bd:3572 with SMTP id a92af1059eb24-1365fb40573mr2368856c88.31.1779529417125;
        Sat, 23 May 2026 02:43:37 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:43:35 -0700 (PDT)
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
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v10 02/31] cxl/mem: Read dynamic capacity configuration from the device
Date: Sat, 23 May 2026 02:42:56 -0700
Message-ID: <692890d6934d844cbbe90596499b28833e45f4f5.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

Devices which optionally support Dynamic Capacity (DC) are configured
via mailbox commands.  CXL 3.2 section 9.13.3 requires the host to issue
the Get DC Configuration command in order to properly configure DCDs.
Without the Get DC Configuration command DCD can't be supported.

Implement the DC mailbox commands as specified in CXL 3.2 section
8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
information.  Disable DCD if an invalid configuration is found.

Linux has no support for more than one dynamic capacity partition.  Read
and validate all the partitions but configure only the first partition
as 'dynamic ram A'.  Additional partitions can be added in the future if
such a device ever materializes.  Additionally is it anticipated that no
skips will be present from the end of the pmem partition.  Check for an
disallow this configuration as well.

Linux has no use for the trailing fields of the Get Dynamic Capacity
Configuration Output Payload (Total number of supported extents, number
of available extents, total number of supported tags, and number of
available tags).  Avoid defining those fields to use the more useful
dynamic C array.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[anisa: rebase]
[jonathan: mbox.c: use max possible size for get_dc_config command to
avoid vmalloc]
[jonathan & fan: cxlmem.h: remove unused struct cxl_mem_dev_info]
---
 drivers/cxl/core/hdm.c  |   2 +
 drivers/cxl/core/mbox.c | 182 ++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxlmem.h    |  47 +++++++++++
 drivers/cxl/pci.c       |   3 +
 include/cxl/cxl.h       |   3 +-
 5 files changed, 236 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 3930e130d6b6..28974adaab75 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -453,6 +453,8 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
 		return "ram";
 	case CXL_PARTMODE_PMEM:
 		return "pmem";
+	case CXL_PARTMODE_DYNAMIC_RAM_A:
+		return "dynamic_ram_a";
 	default:
 		return "";
 	};
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 7ef5708bf210..71b29cd6abfe 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1351,6 +1351,156 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
 	return -EBUSY;
 }
 
+static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_array,
+			u8 index, struct cxl_dc_partition *dev_part)
+{
+	size_t blk_size = le64_to_cpu(dev_part->block_size);
+	size_t len = le64_to_cpu(dev_part->length);
+
+	part_array[index].start = le64_to_cpu(dev_part->base);
+	part_array[index].size = le64_to_cpu(dev_part->decode_length);
+	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
+
+	/* Check partitions are in increasing DPA order */
+	if (index > 0) {
+		struct cxl_dc_partition_info *prev_part = &part_array[index - 1];
+
+		if ((prev_part->start + prev_part->size) >
+		     part_array[index].start) {
+			dev_err(dev,
+				"DPA ordering violation for DC partition %d and %d\n",
+				index - 1, index);
+			return -EINVAL;
+		}
+	}
+
+	if (!IS_ALIGNED(part_array[index].start, SZ_256M) ||
+	    !IS_ALIGNED(part_array[index].start, blk_size)) {
+		dev_err(dev, "DC partition %d invalid start %zu blk size %zu\n",
+			index, part_array[index].start, blk_size);
+		return -EINVAL;
+	}
+
+	if (part_array[index].size == 0 || len == 0 ||
+	    part_array[index].size < len || !IS_ALIGNED(len, blk_size)) {
+		dev_err(dev, "DC partition %d invalid length; size %zu len %zu blk size %zu\n",
+			index, part_array[index].size, len, blk_size);
+		return -EINVAL;
+	}
+
+	if (blk_size == 0 || blk_size % CXL_DCD_BLOCK_LINE_SIZE ||
+	    !is_power_of_2(blk_size)) {
+		dev_err(dev, "DC partition %d invalid block size; %zu\n",
+			index, blk_size);
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "DC partition %d start %zu start %zu size %zu\n",
+		index, part_array[index].start, part_array[index].size,
+		blk_size);
+
+	return 0;
+}
+
+/* Returns the number of partitions in dc_resp or -ERRNO */
+static int cxl_get_dc_config(struct cxl_mailbox *mbox, u8 start_partition,
+			     struct cxl_mbox_get_dc_config_out *dc_resp,
+			     size_t dc_resp_size)
+{
+	struct cxl_mbox_get_dc_config_in get_dc = (struct cxl_mbox_get_dc_config_in) {
+		.partition_count = CXL_MAX_DC_PARTITIONS,
+		.start_partition_index = start_partition,
+	};
+	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
+		.opcode = CXL_MBOX_OP_GET_DC_CONFIG,
+		.payload_in = &get_dc,
+		.size_in = sizeof(get_dc),
+		.size_out = dc_resp_size,
+		.payload_out = dc_resp,
+		.min_out = 8,
+	};
+	int rc;
+
+	rc = cxl_internal_send_cmd(mbox, &mbox_cmd);
+	if (rc < 0)
+		return rc;
+
+	dev_dbg(mbox->host, "Read %d/%d DC partitions\n",
+		dc_resp->partitions_returned, dc_resp->avail_partition_count);
+	return dc_resp->partitions_returned;
+}
+
+/**
+ * cxl_dev_dc_identify() - Reads the dynamic capacity information from the
+ *                         device.
+ * @mbox: Mailbox to query
+ * @dc_info: The dynamic partition information to return
+ *
+ * Read Dynamic Capacity information from the device and return the partition
+ * information.
+ *
+ * Return: 0 if identify was executed successfully, -ERRNO on error.
+ *         on error only dynamic_bytes is left unchanged.
+ */
+int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
+			struct cxl_dc_partition_info *dc_info)
+{
+	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS];
+	struct device *dev = mbox->host;
+	size_t dc_resp_size =
+		sizeof(struct cxl_mbox_get_dc_config_out) + sizeof(partitions);
+	u8 start_partition;
+	u8 num_partitions;
+
+	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) =
+					kmalloc(dc_resp_size, GFP_KERNEL);
+	if (!dc_resp)
+		return -ENOMEM;
+
+	/**
+	 * Read and check all partition information for validity and potential
+	 * debugging; see debug output in cxl_dc_check()
+	 */
+	start_partition = 0;
+	num_partitions = 0;
+	do {
+		int rc, i, j;
+
+		rc = cxl_get_dc_config(mbox, start_partition, dc_resp, dc_resp_size);
+		if (rc < 0) {
+			dev_err(dev, "Failed to get DC config: %d\n", rc);
+			return rc;
+		}
+
+		num_partitions += rc;
+
+		if (num_partitions < 1 || num_partitions > CXL_MAX_DC_PARTITIONS) {
+			dev_err(dev, "Invalid num of dynamic capacity partitions %d\n",
+				num_partitions);
+			return -EINVAL;
+		}
+
+		for (i = start_partition, j = 0; i < num_partitions; i++, j++) {
+			rc = cxl_dc_check(dev, partitions, i,
+					  &dc_resp->partition[j]);
+			if (rc)
+				return rc;
+		}
+
+		start_partition = num_partitions;
+
+	} while (num_partitions < dc_resp->avail_partition_count);
+
+	/* Return 1st partition */
+	dc_info->start = partitions[0].start;
+	dc_info->size = partitions[0].size;
+	dev_dbg(dev, "Returning partition 0 %zu size %zu\n",
+		dc_info->start, dc_info->size);
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
+
 static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
 {
 	int i = info->nr_partitions;
@@ -1421,6 +1571,38 @@ int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_get_dirty_count, "CXL");
 
+void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
+{
+	struct cxl_dc_partition_info dc_info = { 0 };
+	struct device *dev = mds->cxlds.dev;
+	size_t skip;
+	int rc;
+
+	rc = cxl_dev_dc_identify(&mds->cxlds.cxl_mbox, &dc_info);
+	if (rc) {
+		dev_warn(dev,
+			 "Failed to read Dynamic Capacity config: %d\n", rc);
+		cxl_disable_dcd(mds);
+		return;
+	}
+
+	/* Skips between pmem and the dynamic partition are not supported */
+	skip = dc_info.start - info->size;
+	if (skip) {
+		dev_warn(dev,
+			 "Dynamic Capacity skip from pmem not supported: %zu\n",
+			 skip);
+		cxl_disable_dcd(mds);
+		return;
+	}
+
+	info->size += dc_info.size;
+	dev_dbg(dev, "Adding dynamic ram partition A; %zu size %zu\n",
+		dc_info.start, dc_info.size);
+	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_A);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
+
 int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds)
 {
 	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 53444af448d7..87386488ad10 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -380,6 +380,8 @@ struct cxl_security_state {
 	struct kernfs_node *sanitize_node;
 };
 
+#define CXL_MAX_DC_PARTITIONS 8
+
 static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
 {
 	/*
@@ -664,6 +666,31 @@ struct cxl_mbox_set_shutdown_state_in {
 	u8 state;
 } __packed;
 
+/* See CXL 3.2 Table 8-178 get dynamic capacity config Input Payload */
+struct cxl_mbox_get_dc_config_in {
+	u8 partition_count;
+	u8 start_partition_index;
+} __packed;
+
+/* See CXL 3.2 Table 8-179 get dynamic capacity config Output Payload */
+struct cxl_mbox_get_dc_config_out {
+	u8 avail_partition_count;
+	u8 partitions_returned;
+	u8 rsvd[6];
+	/* See CXL 3.2 Table 8-180 */
+	struct cxl_dc_partition {
+		__le64 base;
+		__le64 decode_length;
+		__le64 length;
+		__le64 block_size;
+		__le32 dsmad_handle;
+		u8 flags;
+		u8 rsvd[3];
+	} __packed partition[] __counted_by(partitions_returned);
+	/* Trailing fields unused */
+} __packed;
+#define CXL_DCD_BLOCK_LINE_SIZE 0x40
+
 /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
 struct cxl_mbox_set_timestamp_in {
 	__le64 timestamp;
@@ -787,9 +814,18 @@ enum {
 int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
 			  struct cxl_mbox_cmd *cmd);
 int cxl_dev_state_identify(struct cxl_memdev_state *mds);
+
+struct cxl_dc_partition_info {
+	size_t start;
+	size_t size;
+};
+
+int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
+			struct cxl_dc_partition_info *dc_info);
 int cxl_await_media_ready(struct cxl_dev_state *cxlds);
 int cxl_enumerate_cmds(struct cxl_memdev_state *mds);
 int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
+void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
 struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
 						 u16 dvsec);
 void set_exclusive_cxl_commands(struct cxl_memdev_state *mds,
@@ -803,6 +839,17 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
 			    const uuid_t *uuid, union cxl_event *evt);
 int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count);
 int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds);
+
+static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
+{
+	return mds->dcd_supported;
+}
+
+static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
+{
+	mds->dcd_supported = false;
+}
+
 int cxl_set_timestamp(struct cxl_memdev_state *mds);
 int cxl_poison_state_init(struct cxl_memdev_state *mds);
 int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index bace662dc988..60f9fa05d9ef 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -870,6 +870,9 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
+	if (cxl_dcd_supported(mds))
+		cxl_configure_dcd(mds, &range_info);
+
 	rc = cxl_dpa_setup(cxlds, &range_info);
 	if (rc)
 		return rc;
diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
index fa7269154620..bb1df0cef863 100644
--- a/include/cxl/cxl.h
+++ b/include/cxl/cxl.h
@@ -133,6 +133,7 @@ struct cxl_dpa_perf {
 enum cxl_partition_mode {
 	CXL_PARTMODE_RAM,
 	CXL_PARTMODE_PMEM,
+	CXL_PARTMODE_DYNAMIC_RAM_A,
 };
 
 /**
@@ -147,7 +148,7 @@ struct cxl_dpa_partition {
 	enum cxl_partition_mode mode;
 };
 
-#define CXL_NR_PARTITIONS_MAX 2
+#define CXL_NR_PARTITIONS_MAX 3
 
 /**
  * struct cxl_dev_state - The driver device state
-- 
2.43.0

