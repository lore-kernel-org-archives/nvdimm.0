Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6F33D905C
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386876; cv=none; b=hx9xcgggF7LBIyZRnHYQN7bZkXPCF0Xbd00ePS/3mB5UDrTgFl+6Panl6rc0Mbmsz0A/YCMjIEiGGj8VdrcglLSjlhqjMOy9MlLXYAPqwOgvBsBaBjDenQKTepXGsPpri/lXp0wZ8AwHUQkBEu83Sy1i4tmsTpBFhhqldRMa7Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386876; c=relaxed/simple;
	bh=0p02hPEZ/bAhBCq16EzRBlEf2fUvcLhhnO0e8JeUtg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPjzQvrmaC1aG1tjh04gFpKGw61HFHwx/RToqxZBVSFdHHgu1FGB9L5VCvugKL7QPTVUozOKC+y8YWGFHY5fC0/ZO27f/f4kN2K9Zmo89eH9yejv/qO6RaMfBINpHth3cGBCnzkiOg3iTGpiHa0+HJQCBps/POOcDZ3Tlg/oME0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HP7/JSn0; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HP7/JSn0"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-137dd4cc208so1044694c88.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386874; x=1782991674; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SlPzcmFZ6xw/Dc/UFqLqokkhlcjNBWLaDyvfOmkQ4nY=;
        b=HP7/JSn0NCSt5Agj+vF8RVmz/XxEVHeYakgVKLqK8CdUAgsHDR3uI1DBaw+46XHk3h
         LaByje/2dJbkVEVWKI8ZGIFdTf6RqgU+0Gl0GsGhqfAEQmwrDBxp8mA2fmH7Iu8RXauo
         7q5Qgl/ajTMzvwuhSt50LPHLyv+kKGud1p3neVCW3hcsI/E9xeReTEbLrOWBIinQL/3e
         0YnqXP7dHWU7YnElyxFeqbVVKq1ifAAEOk/bzevTGRvnCY/612+5RRbZTeofMnjy73yv
         vIxUZHBiuzxuYLXW9fcJ9DsVGqURZr1kERn3bEruxXgiT1r8R9FwXcdI81Qo5LCxpmiJ
         qrJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386874; x=1782991674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SlPzcmFZ6xw/Dc/UFqLqokkhlcjNBWLaDyvfOmkQ4nY=;
        b=j4mECDVnKU0oASWmLpYqLMQIrzvrPFOzSL9cbWDL3sP32QvBPzkb2xZUa79n87W4jS
         n3OAGggn3WWHnMvu41YvjUIuMxow3+ESGdJ8+DVvoB26YArX/c024GrhFbP1dbgRPkyb
         ZYrIXtOxkXse/3k0yzWOx3LN2WnkdiF8ttHipNBJx+nLJ/Av7YGhWcZ+L07Zr1SpE169
         Z5zQspvbPqgzzhOpRiLIbmslv6tMsyF3cwvQjfFzjOihS0DZHeW/mp1bo/fnRFA3esSE
         4JiFXcdTOJkgJsTfPJVrRD8vZWkR+pU2NOARWdxocxAJKghetrCBJMgdBLGnbWMYAm7E
         rn9A==
X-Gm-Message-State: AOJu0YxzwCsckmJ9MSe2poiewJUtBvP+LVoxPFsNUJTDfm9eblyBMWHL
	i4grcgEnIMGbNonyPgmlwcyjeHwZdOYaiV2rsK0MQJsoJLuX3m3Iamjm
X-Gm-Gg: AfdE7cnM1Ax8oHliWwFEZB9j7h3gZSvUNbWL7/xeqJbbrgvNBmmWv9AH4S24kT+ZWQP
	HmWk3AkkXtLFI+S0Q/MOa3cEO6zAaM9FqSrBXyrojf3E0NmHCo/zSTPcwYSxVBX7O+wKRYKxCl/
	OFFlhycyCD3/Q/PKqoWeZctPw4IUbr2mxC6LvrCxU2trYYPf8yM1JapUC/Jmh1zmPxInqjX3m5N
	6t/NUZ7OM6GaTzeI1G5TjwyXeWXZs+uFKQCzW+Tt+Ecr5yQqoc68s1WJ7ds0dbK1CXhL9ri6RHQ
	RrREqj+P6C7v9+vLB0f+PP+zNlHW3cZWujmmRC44exde8xnXtot1+m/rtFgn/soCqXd3CW7hIRy
	TgMNBYdod56ncH6kvTBT8rBcVmRZWpv1q9NvHF+Q2dEdRb65/jSh7Ar+lF7c1PDua+5PdBVcxin
	ngMV6/afjtw8+UtpSj3/byDqJEbB9HyDXGLQJLW5jsrVevbE5qEgkJmnX/SCfX75oxn9/z
X-Received: by 2002:a05:7022:f9b:b0:138:5049:cb88 with SMTP id a92af1059eb24-139c3c1f687mr9105871c88.8.1782386873871;
        Thu, 25 Jun 2026 04:27:53 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:27:53 -0700 (PDT)
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
Subject: [PATCH v11 02/31] cxl/mem: Read dynamic capacity configuration from the device
Date: Thu, 25 Jun 2026 04:04:39 -0700
Message-ID: <20260625112638.550691-3-anisa.su@samsung.com>
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

Linux has no use for the trailing fields of the Get Dynamic Capacity
Configuration Output Payload (Total number of supported extents, number
of available extents, total number of supported tags, and number of
available tags).  Avoid defining those fields to use the more useful
dynamic C array.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
1. Move partition alignment check after is_power_of_2() check on
   blk_size, as IS_ALIGNED(partition start, blk_size) expects blk_size
   to be a power of 2 in cxl_dc_check()

2. cxl_get_dc_config(): verify mbox_cmd.size_out against
   dc_resp->partitions_returned

3. cxl_dev_dc_identify(): originally calculated size of dc_resp using
   struct cxl_dc_partition_info, but dc_resp->partition[] is of type
   struct cxl_dc_partition. Fix size calculation.

4. fix do/while loop in cxl_dev_dc_identify to protect against returning
   0 partitions infinitely

5. cxl_configure_dcd(): originally checked for gap between PMEM and DC
   partition by calculating if a gap exists:
   	if ([start of dc part] - [end of pmem part])
   Replace with: if ([start of dc part] != [end of pmem part]) to avoid
   underflow in case of bad input

6. Change struct cxl_dc_partition_info to use u64 instead of size_t
   fields

7. Original commit message referenced CXL r3.2. Bump to r4.0.
   Verified section numbers remain the same

8. Rename dynamic_ram_a to dynamic_ram_1
---
 drivers/cxl/core/hdm.c  |   2 +
 drivers/cxl/core/mbox.c | 211 ++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxlmem.h    |  47 +++++++++
 drivers/cxl/pci.c       |   3 +
 include/cxl/cxl.h       |   3 +-
 5 files changed, 265 insertions(+), 1 deletion(-)

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
index 07aba6f0b719..2932bbd67e55 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1347,6 +1347,188 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
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
+	size_t expected_sz;
+	int rc;
+
+	rc = cxl_internal_send_cmd(mbox, &mbox_cmd);
+	if (rc < 0)
+		return rc;
+
+	if (dc_resp->partitions_returned > CXL_MAX_DC_PARTITIONS) {
+		dev_err(mbox->host, "Device returned %u partitions, max %d\n",
+			dc_resp->partitions_returned, CXL_MAX_DC_PARTITIONS);
+		return -EIO;
+	}
+
+	/*
+	 * The payload carries trailing extent/tag count fields after the
+	 * partition array (CXL 3.2 Table 8-179) which the driver ignores, so
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
+ *         on error only dynamic_bytes is left unchanged.
+ */
+int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
+			struct cxl_dc_partition_info *dc_info)
+{
+	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS];
+	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree);
+	struct device *dev = mbox->host;
+	u8 start_partition;
+	u8 num_partitions;
+	size_t dc_resp_size = struct_size(dc_resp,
+					  partition,
+					  CXL_MAX_DC_PARTITIONS);
+
+	dc_resp = kmalloc(dc_resp_size, GFP_KERNEL);
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
@@ -1417,6 +1599,35 @@ int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
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
index 60dc3f0006a7..6b548a1ec1e9 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -385,6 +385,8 @@ struct cxl_security_state {
 	struct kernfs_node *sanitize_node;
 };
 
+#define CXL_MAX_DC_PARTITIONS 8
+
 static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
 {
 	/*
@@ -669,6 +671,31 @@ struct cxl_mbox_set_shutdown_state_in {
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
+	/* Trailing extent/tag count fields unused */
+} __packed;
+#define CXL_DCD_BLOCK_LINE_SIZE 0x40
+
 /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
 struct cxl_mbox_set_timestamp_in {
 	__le64 timestamp;
@@ -792,9 +819,18 @@ enum {
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
@@ -808,6 +844,17 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
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
index fa7269154620..e8a0899960d4 100644
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

