Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5859B3ACF1D
	for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 08:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487776; cv=none; b=pTYsSTMkevStWs3+RNCM9Tn7aH34zyADmxUe9+t+vjXu5yDcBe8VEbk1tsxLXq0gnXB4r4pDkW2upLiXY3TAa5kT4d4hG3Hr4f4rZEWMSKs8Gbie7i58jCjF+sJSjlqr8yFMpSVkiq9IuemhQeW5PdgDmfnkRcTxvku7vIIfOSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487776; c=relaxed/simple;
	bh=0Te89DFnQHFqS78qBP2KzmNm9JIpjpTX6sndzk5+Jcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVrgi/gvCAakWG5I9WdbLcgllzBddsJqSssfRfJ6UoKFTisUgQ27P3IsHBSeB560Z5atmfbEa4o5hHWzacstiDzbSgnrjmQZhpbcCePOS5KhxyTliDfwiaRegxdvGnULi/p+Z+VyqYloBtYVM9ZTXOsDdWbgAacRqnjFajQViWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rBTQYY5j; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rBTQYY5j"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so8636475ad.1
        for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 01:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785487774; x=1786092574; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QTmDO6MIUjKf2up5L+caPkZa3xgBSEz0XDoZzRneHAI=;
        b=rBTQYY5jihatNwQtRr5IcSkvqdPXN34X/O5tNN9/OJAeBoNZKCtj2dpKL6LW9MxBIo
         FvYxgxEwOCsEwLPIuu/tc5X1CXp3fHIwOD44Lg9L0fLLcY0AIoVdk1zWkdyTzS7YZySw
         CT5bv0817vsu06LU9vHTL1PhJsDbjR85MpZqbyDVfeZ4VT28WM9exjvtb+yn/58Tax94
         q8Rd5FymrNGpNVY21BWBZ4mPoq87SfY0Dak9gLptOAhJAFw41yuuXfd4+G+9ZrYZ2AcR
         B7I5x7Oxq/USSuZc80fZ0lJoNUTM1xCB9x7YXT6OKJPe3dxeQgr6DQP+sp8exeuJlJ2g
         +l+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785487774; x=1786092574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QTmDO6MIUjKf2up5L+caPkZa3xgBSEz0XDoZzRneHAI=;
        b=EMOBna/HY+tHOXw/JRrxvkiXgv0kT/iK6m+/2cEPu1FH8aTOy4kMivY2ZwmkOPG8r7
         jSUj+ZT4zJKhvw3IMfoC2fT6m2J1J7HWJHBZT5OH+YGB6aHcVbGeLHvAH9mPg41M2k3N
         slQZt5j8H2m1xNYhjuzLE1hN7pNFEm7KkVYUzocjGEBRuz+HZeIPAwBJDgjeTYeytG1Q
         e8wOFjydYMZISYwmXR4lKLLWZHj9k8ZrOqAaJ1sOP6xBJnmWo4XWMaGZZ6CC9aOllYsH
         7pqIQU3cNnmfGFctSKPafbk0kt+JCP6S0njS8kHuJMLIwHuF4eJpsJsb2yazS2aBbFMk
         4L1Q==
X-Gm-Message-State: AOJu0YyppebORoeGoUYzA/BUN0nRlwCdIgeBWOMYMAbz64tzlINu9h71
	fbVYlGHUZ6Ib9bGCCBaV2XzzBzgCGwgWys3yCxO8ohZOLvtEgKQF1T6X
X-Gm-Gg: AR+sD13v1XcfM6nbzajRlArGQZd3OFHGAKRY/LgM7bgwdYG5eMFqMZXeWVWPLrRp18l
	nGC+7DcIKJ/nIXno1a/qVZidw0taqh2+kcOzOvIeWd7JD3KgJfBF6kDaUbRg7g4ZAZGMele4oQR
	RFQTNadRU6A1Ce3CGJ+vXlN8RfTj5mKbYDjJ2xzoHt8lp3FL7KzBqfFeKHqto4yRStchcrwVvr4
	d7ErtDxcgk4eohArpXW1f6FAxBUOsUufmrv3z1PFehHjh4NGvi1RBwSpaUj/0VREI5Gjd75Ae3G
	DDWWtX/LOlIiURI5VzkfaOnlSCHv+qTmSGJfsex2nryF2mGWvASq8pIE32GL9eomWVKpvKNhEc0
	vqH0VrohwUWF0ZgQuHPQ3mCwDRtLfkSdZ+xdyhb8Y2Rfb+ZWqRzZ6QE0V4pX6zdhk3Q7veCdtS4
	bVxFCmdd2gcycjVaNW6OXfEE5q6l1sEAOlAk6u6Ol21jV8KxvamiUpViwPlt/ka/2LmqAP58Qcv
	dh2vEbvJwR6jaclN5oTkiTU6otaYQf3YpZWKgnK0niI
X-Received: by 2002:a17:903:41c3:b0:2c2:be43:39bc with SMTP id d9443c01a7336-2d046e869a9mr12387955ad.22.1785487773645;
        Fri, 31 Jul 2026 01:49:33 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae5abaesm2708425ad.27.2026.07.31.01.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 01:49:33 -0700 (PDT)
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
Subject: [PATCH v12 2/8] cxl/mem: Read dynamic capacity configuration from the device
Date: Fri, 31 Jul 2026 01:48:07 -0700
Message-ID: <20260731084901.1512819-3-anisa.su@samsung.com>
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

Devices which optionally support Dynamic Capacity (DC) are configured
via mailbox commands.  CXL r4.0 section 9.13.3 requires the host to issue
the Get DC Configuration command in order to properly configure DCDs.
Without the Get DC Configuration command DCD can't be supported.

Implement the DC mailbox commands as specified in CXL 4.0 section
8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
information.  Disable DCD if an invalid configuration is found.

Linux has no support for more than one dynamic capacity partition.  Read
and validate all the partitions but configure only the first partition
as 'dynamic ram 1'.  Additional partitions can be added in the future if
such a device ever materializes.  Additionally it is anticipated that no
skips will be present from the end of the pmem partition.  Check for and
disallow this configuration as well.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>

---
Changes:
1. mbox.c: bound the Get DC Config request by the negotiated mailbox
   payload. Requesting all CXL_MAX_DC_PARTITIONS (8) needs a 328-byte
   response, which exceeds a spec-minimum 256-byte mailbox and fails
   -E2BIG, disabling DCD. Cap partition_count per call to what the
   payload holds and read the rest via the existing start_partition
   loop.
---
 drivers/cxl/core/hdm.c  |   2 +
 drivers/cxl/core/mbox.c | 220 ++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxlmem.h    |  55 ++++++++++
 drivers/cxl/pci.c       |   3 +
 include/cxl/cxl.h       |   3 +-
 5 files changed, 282 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 0c80b76a5f9b..0ef076c08ed2 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -446,6 +446,8 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
 		return "ram";
 	case CXL_PARTMODE_PMEM:
 		return "pmem";
+	case CXL_PARTMODE_DYNAMIC_RAM_1:
+		return "dynamic_ram_1";
 	default:
 		return "";
 	};
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 4790524c32a7..d79019fbd790 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1352,6 +1352,197 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
 	return -EBUSY;
 }
 
+static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_array,
+			u8 index, struct cxl_dc_partition *dev_part)
+{
+	u64 blk_size = le64_to_cpu(dev_part->block_size);
+	u64 len = le64_to_cpu(dev_part->length);
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
+	if (part_array[index].size == 0 || len == 0 ||
+	    part_array[index].size < len || !IS_ALIGNED(len, blk_size)) {
+		dev_err(dev, "DC partition %d invalid length; size %llu len %llu blk size %llu\n",
+			index, part_array[index].size, len, blk_size);
+		return -EINVAL;
+	}
+
+	if (blk_size == 0 || blk_size % CXL_DCD_BLOCK_LINE_SIZE ||
+	    !is_power_of_2(blk_size)) {
+		dev_err(dev, "DC partition %d invalid block size %llu\n",
+			index, blk_size);
+		return -EINVAL;
+	}
+
+	if (!IS_ALIGNED(part_array[index].start, SZ_256M) ||
+	    !IS_ALIGNED(part_array[index].start, blk_size)) {
+		dev_err(dev, "DC partition %d invalid start %llu blk size %llu\n",
+			index, part_array[index].start, blk_size);
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "DC partition %d start %llu size %llu blk_size: %llu\n",
+		index, part_array[index].start, part_array[index].size,
+		blk_size);
+
+	return 0;
+}
+
+/* Returns the number of partitions in dc_resp or -ERRNO */
+static int cxl_get_dc_config(struct cxl_mailbox *mbox, u8 start_partition,
+			     u8 partition_count,
+			     struct cxl_mbox_get_dc_config_out *dc_resp,
+			     size_t dc_resp_size)
+{
+	struct cxl_mbox_get_dc_config_in get_dc = (struct cxl_mbox_get_dc_config_in) {
+		.partition_count = partition_count,
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
+	size_t expected_sz;
+	int rc;
+
+	rc = cxl_internal_send_cmd(mbox, &mbox_cmd);
+	if (rc < 0)
+		return rc;
+
+	if (dc_resp->partitions_returned > partition_count) {
+		dev_err(mbox->host, "Device returned %u partitions, requested %u\n",
+			dc_resp->partitions_returned, partition_count);
+		return -EIO;
+	}
+
+	/*
+	 * The payload carries trailing extent/tag count fields after the
+	 * partition array (CXL r4.0 Table 8-179) which the driver ignores, so
+	 * the response is at least, not exactly, expected_sz.
+	 */
+	expected_sz = struct_size(dc_resp, partition,
+				  dc_resp->partitions_returned);
+
+	if (mbox_cmd.size_out < expected_sz) {
+		dev_err(mbox->host,
+			"Payload size %zu less than expected %zu for %u partitions\n",
+			mbox_cmd.size_out,
+			expected_sz,
+			dc_resp->partitions_returned);
+		return -EIO;
+	}
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
+ *         on error only dc_info is left unchanged.
+ */
+int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
+			struct cxl_dc_partition_info *dc_info)
+{
+	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS];
+	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) = NULL;
+	struct device *dev = mbox->host;
+	u8 start_partition;
+	u8 num_partitions;
+	u8 partition_count;
+	size_t dc_resp_size;
+
+	/* Bound requested number of partitions by mailbox payload size */
+	partition_count = min_t(size_t, CXL_MAX_DC_PARTITIONS,
+				(mbox->payload_size - sizeof(*dc_resp) -
+				 sizeof(struct cxl_mbox_get_dc_config_tail)) /
+				sizeof(struct cxl_dc_partition));
+	dc_resp_size = struct_size(dc_resp, partition, partition_count) +
+		       sizeof(struct cxl_mbox_get_dc_config_tail);
+
+	dc_resp = kmalloc(dc_resp_size, GFP_KERNEL);
+	if (!dc_resp)
+		return -ENOMEM;
+
+	/*
+	 * Read and check all partition information for validity and potential
+	 * debugging; see debug output in cxl_dc_check()
+	 */
+	start_partition = 0;
+	num_partitions = 0;
+	do {
+		int rc, i, j;
+
+		rc = cxl_get_dc_config(mbox, start_partition, partition_count,
+				       dc_resp, dc_resp_size);
+		if (rc < 0) {
+			dev_err(dev, "Failed to get DC config: %d\n", rc);
+			return rc;
+		}
+
+		if (rc == 0) {
+			dev_err(dev,
+				"Device reported %u partitions available but returned none at index %u\n",
+				dc_resp->avail_partition_count, start_partition);
+			return -EIO;
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
+	dev_dbg(dev, "Returning partition 0 %llu size %llu\n",
+		dc_info->start, dc_info->size);
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
+
 static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
 {
 	int i = info->nr_partitions;
@@ -1422,6 +1613,35 @@ int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_get_dirty_count, "CXL");
 
+void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
+{
+	struct cxl_dc_partition_info dc_info = { 0 };
+	struct device *dev = mds->cxlds.dev;
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
+	if (dc_info.start != info->size) {
+		dev_warn(dev,
+			 "Dynamic Capacity skip from pmem not supported\n");
+		cxl_disable_dcd(mds);
+		return;
+	}
+
+	info->size += dc_info.size;
+	dev_dbg(dev, "Adding dynamic ram partition 1; %llu size %llu\n",
+		dc_info.start, dc_info.size);
+	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
+
 int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds)
 {
 	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 616eeaeee5b9..a9782939d82b 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -407,6 +407,8 @@ struct cxl_security_state {
 	struct kernfs_node *sanitize_node;
 };
 
+#define CXL_MAX_DC_PARTITIONS 8
+
 static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
 {
 	/*
@@ -691,6 +693,39 @@ struct cxl_mbox_set_shutdown_state_in {
 	u8 state;
 } __packed;
 
+/* See CXL r4.0 Table 8-178 get dynamic capacity config Input Payload */
+struct cxl_mbox_get_dc_config_in {
+	u8 partition_count;
+	u8 start_partition_index;
+} __packed;
+
+/* See CXL r4.0 Table 8-179 get dynamic capacity config Output Payload */
+struct cxl_mbox_get_dc_config_out {
+	u8 avail_partition_count;
+	u8 partitions_returned;
+	u8 rsvd[6];
+	/* See CXL r4.0 Table 8-180 */
+	struct cxl_dc_partition {
+		__le64 base;
+		__le64 decode_length;
+		__le64 length;
+		__le64 block_size;
+		__le32 dsmad_handle;
+		u8 flags;
+		u8 rsvd[3];
+	} __packed partition[] __counted_by(partitions_returned);
+	/* Trailing extent/tag count fields unused */
+} __packed;
+
+/* Trailing counts; cannot be a member after the flex array above */
+struct cxl_mbox_get_dc_config_tail {
+	__le32 num_extents_supported;
+	__le32 num_extents_available;
+	__le32 num_tags_supported;
+	__le32 num_tags_available;
+} __packed;
+#define CXL_DCD_BLOCK_LINE_SIZE 0x40
+
 /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
 struct cxl_mbox_set_timestamp_in {
 	__le64 timestamp;
@@ -814,9 +849,18 @@ enum {
 int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
 			  struct cxl_mbox_cmd *cmd);
 int cxl_dev_state_identify(struct cxl_memdev_state *mds);
+
+struct cxl_dc_partition_info {
+	u64 start;
+	u64 size;
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
@@ -830,6 +874,17 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
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
index 267c679b0b3c..9b320a2b6fe0 100644
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
index 016c74fb747c..87c2bd73df21 100644
--- a/include/cxl/cxl.h
+++ b/include/cxl/cxl.h
@@ -133,6 +133,7 @@ struct cxl_dpa_perf {
 enum cxl_partition_mode {
 	CXL_PARTMODE_RAM,
 	CXL_PARTMODE_PMEM,
+	CXL_PARTMODE_DYNAMIC_RAM_1,
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

