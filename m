Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14928392C5F
	for <nvdimm@lists.linux.dev>; Wed,  7 Oct 2026 20:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791404320; cv=none; b=h4EonCsO2o4MKh1tpxTZXIBULb1D4hR7T8vkk+oNNWmgbgko7JU+Wga7300Kc45LUB5Y0GpKZyt4sOPw8Cj0UdfOGBH7EWRYz7rZXoLlwNk6GOGfaON0U/bnuu02kptFkRrLTzUndEpTwTm4U4YVE2FQZHDIWOEjI3EiVQEDVio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791404320; c=relaxed/simple;
	bh=+tRv8r+w0l3CHBuasNT/DfsWAX5S+9JYP89iGBigHd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBYHX+D0iXKxFrVvH2xyMzFuFOGbrV+jg/00YZElzt5Qc27F+CepJtPLMba8HdkDy8wG5J+H4LB2nR7KdNmGKAdc0nfH5Exp23GdfH+mOdatUSjjNcGaQSZ8Vp4+kwkD+Hbxcj4cA6pWKTGk8LVXfaHAhwpTxrkEMKCH1uoi8tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Psv2dMjr; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Psv2dMjr"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3a8a2df4f93so742118a91.3
        for <nvdimm@lists.linux.dev>; Wed, 07 Oct 2026 13:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791404318; x=1792009118; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xs0fgo37pLofrmfQ45EqqVh2BpNjioIcMvj7au7UOo0=;
        b=Psv2dMjrT0w8MHgCw77tvUMSXzMK68gEFRu2rHtLN+vq1RjgzaP43vLwQuRV+gTb3j
         6NJV6oHdLn4kiks45TfB9Gbots9aaIELe2mjUioUvnr422VCMSBpaJnHAQv9HtK8j8PT
         JWvCfOpiq/u7ljJHU6tNFeen5fA3sml1Oxnr/OTIjQL816Iv0td9wc+1bYi1s9vsxDiO
         KuQGnXa0kHXPSnbmtxvH2RHUZWS1y+XTipJoV+V2YwnRLilRKVrVedVtMhw3y8p55MeW
         hDPHTRclVwXYQT57bkmoOjgfnH2PJjt5vqpqaZWaaaYlIvs7Un6CqC4RcJG4Vjlek99z
         eJ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791404318; x=1792009118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xs0fgo37pLofrmfQ45EqqVh2BpNjioIcMvj7au7UOo0=;
        b=vHlNHk6y2OSo8PnUKex78EtldX74iGl3t04+pCUSg6SzQdr0VkfQ1KYdB9bsrBxBaY
         uFYa36okjd7bt7udjPfDDqfhfmN0QF4IdmOtOimuO/v3AHHyEKUtcACp1toUKux5Atwt
         KJnY7NK4PvG6vxPWRI0jC1t2MIKzFSxyHzLtlEEfkWUmPRUHKSDsVZY5D/JNpnq4lnGq
         DpADmgHkSzitiHTIHoUxcmdYkJmHzrm8dB+5/LSMtWVfpOaTD6Mc981lWpaPl5qGb1jU
         bSwfIgM7kCIJeXUuU8lrxGZY0oV7osKxzOU4iu33xQF9GNcNlzyhiMCrXDsQdFvdFPoB
         zl/g==
X-Gm-Message-State: AFq9FYJoRucixyJPzHKi1Vn6am9s6CZh1Rz3nFcp88JxGhElub5auME9
	1fhMN0pGNwBZ5RKtHhN8QzTbqJXLHk5oY5C1hk/mlN9I1Be1EJN8zWxa
X-Gm-Gg: AYBFou3WIwmUzkkamW2hI++g0Ck65u5WnVvjHcFk3RVDIOKe2XB3Pfp3UrY2XwM+Plo
	jtrlmYUhG97cdleMFlIuiCXUMXVyUNCfwPKrCU5yq5XYYq9Pqoi1x2nTsGQ1ZZB0cKk0F7+F/s0
	qF20gKIpIp05TGe4w3nWqXbCFeYrLmg2hCG6wmf4gAD1MkohdO5Xx0ks9WLjodmxSpr5wIWF2XB
	a0HDGrHFviURIBXi0HAHWgBVE9UcxksSX+j04ReIMej1SxiSgvKceZXYb5k0e29b85sZly3IMuY
	ZBEHlMvl1FEqLsUWLej9YeFc0e4sNtCtC7LBkaxjyYYeMxTJ2V01siYgXssz6Cr19yWiqUiU21s
	wUbvLQLGBlm5DfdPfdCnekYpfpo2OZdPcZJKziB76HuQNTUISGaL417ac398te3NEQD9X4OBM2n
	gn1IFHsxKApO9gumuJOdWpthB62m5vpmNItbKNluv0njgAz5mjX4Ouoz7GFF2PL4LcVHgH6vWkm
	vUL3LaMFXE66A3Ef9aN1+Ed7pp/daJhDzmFFc6U1QMd/biEXgChk1eTvszAkS7KumeAs3Jts7qS
	Ls5RoTc5ftoziw==
X-Received: by 2002:a17:90b:2e4f:b0:3a8:1830:8b9f with SMTP id 98e67ed59e1d1-3a8a1967353mr2892410a91.16.1791404318101;
        Wed, 07 Oct 2026 13:18:38 -0700 (PDT)
Received: from 4470NRD-ASU.ssi.samsung.com (c-24-19-224-150.hsd1.wa.comcast.net. [24.19.224.150])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9ff7ab034sm967623a91.4.2026.10.07.13.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 13:18:37 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dan Williams <djbw@kernel.org>,
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
Subject: [PATCH v15 2/8] cxl/mem: Read dynamic capacity configuration from the device
Date: Wed,  7 Oct 2026 13:16:35 -0700
Message-ID: <20261007201828.952-3-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007201828.952-1-anisa.su@samsung.com>
References: <20261007201828.952-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Devices which support Dynamic Capacity (DC) are configured via mailbox
commands. CXL r4.0 section 9.13.3 describes the use of the Get DC
Configuration command in order to obtain DCD partition characteristics.

Implement the DC mailbox commands as specified in CXL 4.0 section
8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
information. Disable DCD if an invalid configuration is found.

Initial enablement for Linux only supports one dynamic capacity
partition. Read all the partitions the device reports but validate
only the first, and configure it as 'dynamic ram'.

The specification requires that volatile capacity starts at DPA 0 and
pmem starts at the DPA immediately following it, but DC partitions only
need to be 256MB aligned according to CXL r4.0 section 8.2.10.9.9.1
Table 8-347. So a device could leave a gap between ram/pmem (static)
capacity and its first DC partition, or between one DC partition and
the next.

However, Linux chooses not to support gaps between static and dynamic
capacity, and requires the first DC partition to begin at the DPA
immediately following static capacity.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Co-developed-by: Anisa Su <anisa.su@samsung.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
1. Partition mode renamed CXL_PARTMODE_DYNAMIC_RAM: the mode says what
   kind of capacity this is, not which partition. The DC partition's
   resource name carries its position instead, dynamic_ram_1 for the
   first, formatted in cxl_dpa_setup().
---
 drivers/cxl/core/hdm.c    |  13 ++-
 drivers/cxl/core/mbox.c   | 237 ++++++++++++++++++++++++++++++++++++++
 drivers/cxl/core/memdev.c |  47 ++++++++
 drivers/cxl/cxlmem.h      |  55 +++++++++
 drivers/cxl/pci.c         |   6 +
 include/cxl/cxl.h         |   3 +-
 6 files changed, 359 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 0c80b76a5f9b..5fa2177cefcc 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -446,6 +446,8 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
 		return "ram";
 	case CXL_PARTMODE_PMEM:
 		return "pmem";
+	case CXL_PARTMODE_DYNAMIC_RAM:
+		return "dynamic_ram";
 	default:
 		return "";
 	};
@@ -455,6 +457,7 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
 int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
 {
 	struct device *dev = cxlds->dev;
+	int dc_nth = 0;
 
 	guard(rwsem_write)(&cxl_rwsem.dpa);
 
@@ -471,8 +474,16 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
 
 	for (int i = 0; i < info->nr_partitions; i++) {
 		const struct cxl_dpa_part_info *part = &info->part[i];
+		const char *name = cxl_mode_name(part->mode);
 		int rc;
 
+		if (part->mode == CXL_PARTMODE_DYNAMIC_RAM) {
+			name = devm_kasprintf(dev, GFP_KERNEL, "%s_%d", name,
+					      ++dc_nth);
+			if (!name)
+				return -ENOMEM;
+		}
+
 		cxlds->part[i].perf.qos_class = CXL_QOS_CLASS_INVALID;
 		cxlds->part[i].mode = part->mode;
 
@@ -485,7 +496,7 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
 		}
 		rc = add_dpa_res(dev, &cxlds->dpa_res, &cxlds->part[i].res,
 				 part->range.start, range_len(&part->range),
-				 cxl_mode_name(part->mode));
+				 name);
 		if (rc)
 			return rc;
 		cxlds->nr_partitions++;
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 199bb986d674..72af23ba288e 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1349,6 +1349,243 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
 	return -EBUSY;
 }
 
+/*
+ * A partition unavailable for Dynamic Capacity reports zeros for decode_length,
+ * length, and block_size.
+ */
+static bool cxl_dc_partition_unavailable(struct cxl_dc_partition *dev_part)
+{
+	return !le64_to_cpu(dev_part->decode_length) &&
+	       !le64_to_cpu(dev_part->length) &&
+	       !le64_to_cpu(dev_part->block_size);
+}
+
+static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part,
+			struct cxl_dc_partition *dev_part)
+{
+	u64 decode_len = le64_to_cpu(dev_part->decode_length);
+	u64 blk_size = le64_to_cpu(dev_part->block_size);
+	u64 len = le64_to_cpu(dev_part->length);
+	u64 size;
+
+	/*
+	 * Not an error; leave the entry empty. A partially zeroed partition
+	 * is rejected by the checks below. CXL r4.0 Table 8-347.
+	 */
+	if (cxl_dc_partition_unavailable(dev_part)) {
+		*part = (struct cxl_dc_partition_info) { };
+		dev_dbg(dev, "Partition 0 unavailable for DC\n");
+		return 0;
+	}
+
+	/*
+	 * Decode length is a count of 256M units, so a device reporting 2^36
+	 * or more wraps.
+	 */
+	if (check_mul_overflow(decode_len, (u64)CXL_CAPACITY_MULTIPLIER, &size)) {
+		dev_err(dev, "DC partition 0 decode length %#llx overflows\n",
+			decode_len);
+		return -EINVAL;
+	}
+
+	*part = (struct cxl_dc_partition_info) {
+		.start = le64_to_cpu(dev_part->base),
+		.size = size,
+	};
+
+	/*
+	 * Block size is a power of 2 and a multiple of 40h. is_power_of_2()
+	 * takes an unsigned long, which truncates blk_size on 32 bit.
+	 */
+	if (blk_size == 0 || (blk_size & (blk_size - 1)) ||
+	    blk_size % CXL_DCD_BLOCK_LINE_SIZE) {
+		dev_err(dev, "DC partition 0 invalid block size %#llx\n", blk_size);
+		return -EINVAL;
+	}
+
+	if (part->size == 0) {
+		dev_err(dev, "DC partition 0 zero decode length\n");
+		return -EINVAL;
+	}
+
+	if (len == 0) {
+		dev_err(dev, "DC partition 0 zero length\n");
+		return -EINVAL;
+	}
+
+	if (len > part->size) {
+		dev_err(dev, "DC partition 0 length %#llx exceeds decode length %#llx\n",
+			len, part->size);
+		return -EINVAL;
+	}
+
+	if (!IS_ALIGNED(len, blk_size)) {
+		dev_err(dev, "DC partition 0 length %#llx not a multiple of block size %#llx\n",
+			len, blk_size);
+		return -EINVAL;
+	}
+
+	if (!IS_ALIGNED(part->start, SZ_256M)) {
+		dev_err(dev, "DC partition 0 base %#llx not aligned to 256M\n",
+			part->start);
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "DC partition 0 start %#llx size %#llx blk_size: %#llx\n",
+		part->start, part->size, blk_size);
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
+		/* The device must return at least the fixed header */
+		.min_out = sizeof(*dc_resp),
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
+	/* The trailing extent/tag counts (CXL r4.0 Table 8-346) are not read */
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
+ * Read every partition the device reports, but validate only the first:
+ * Linux maps partition 0 and nothing else, so a defect in capacity the
+ * driver never touches is not a reason to refuse the device dynamic
+ * capacity.  The remaining partitions are read but not recorded.
+ *
+ * Return: 0 if identify was executed successfully, -ERRNO on error.
+ *         On error, @dc_info is left unchanged.
+ */
+int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
+			struct cxl_dc_partition_info *dc_info)
+{
+	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS] = { };
+	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) = NULL;
+	struct device *dev = mbox->host;
+	u8 avail_partitions = 0;
+	u8 start_partition;
+	u8 num_partitions;
+	u8 partition_count;
+	size_t dc_resp_size;
+
+	/*
+	 * Bound requested number of partitions by mailbox payload size. The
+	 * 256 byte spec minimum, verified in cxl_pci_setup_mailbox(), keeps
+	 * the subtraction below from underflowing.
+	 */
+	partition_count = min(CXL_MAX_DC_PARTITIONS,
+			      (mbox->payload_size - sizeof(*dc_resp) -
+			       sizeof(struct cxl_mbox_get_dc_config_tail)) /
+			      sizeof(struct cxl_dc_partition));
+	dc_resp_size = struct_size(dc_resp, partition, partition_count) +
+		       sizeof(struct cxl_mbox_get_dc_config_tail);
+
+	dc_resp = kmalloc(dc_resp_size, GFP_KERNEL);
+	if (!dc_resp)
+		return -ENOMEM;
+
+	start_partition = 0;
+	num_partitions = 0;
+	do {
+		int returned, rc;
+
+		returned = cxl_get_dc_config(mbox, start_partition,
+					     partition_count, dc_resp,
+					     dc_resp_size);
+		if (returned < 0) {
+			dev_err(dev, "Failed to get DC config: %d\n", returned);
+			return returned;
+		}
+
+		if (returned == 0) {
+			dev_err(dev,
+				"Device reported %u partitions available but returned none at index %u\n",
+				dc_resp->avail_partition_count, start_partition);
+			return -EIO;
+		}
+
+		/* A DCD reports at least one partition (CXL r4.0 Table 8-346) */
+		if (dc_resp->avail_partition_count == 0) {
+			dev_err(dev, "Device reported no DC partitions\n");
+			return -EIO;
+		}
+
+		avail_partitions = min(dc_resp->avail_partition_count,
+				       CXL_MAX_DC_PARTITIONS);
+
+		/*
+		 * Only partition 0 is mapped, so it is the only one checked.
+		 * The rest are read to complete the enumeration and dropped.
+		 */
+		if (start_partition == 0) {
+			rc = cxl_dc_check(dev, &partitions[0],
+					  &dc_resp->partition[0]);
+			if (rc)
+				return rc;
+		}
+
+		num_partitions += returned;
+		start_partition = num_partitions;
+
+	} while (num_partitions < avail_partitions);
+
+	/* Linux only supports the 1st partition; nothing to do if it is unavailable */
+	if (partitions[0].size == 0)
+		return -ENODEV;
+
+	*dc_info = partitions[0];
+	dev_dbg(dev, "Returning partition 0 %#llx size %#llx\n",
+		dc_info->start, dc_info->size);
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
+
 int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
 {
 	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index b3419df586b9..def26c490dfe 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -643,6 +643,53 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_mem_dpa_fetch, "CXL");
 
+int cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
+{
+	struct cxl_dc_partition_info dc_info = { };
+	struct device *dev = mds->cxlds.dev;
+	u64 total;
+	int rc;
+
+	if (!mds->cxlds.media_ready)
+		return 0;
+
+	rc = cxl_dev_dc_identify(&mds->cxlds.cxl_mbox, &dc_info);
+	if (rc) {
+		dev_warn(dev,
+			 "Failed to read Dynamic Capacity config: %d\n", rc);
+		return rc;
+	}
+
+	if (dc_info.start < info->size) {
+		dev_err(dev,
+			"DC partition 0 base %#llx overlaps static capacity ending at %#llx\n",
+			dc_info.start, info->size);
+		return -EINVAL;
+	}
+
+	/* A gap between static capacity and the DC partition is not supported */
+	if (dc_info.start > info->size) {
+		dev_warn(dev,
+			 "DC partition 0 base %#llx leaves a gap from static capacity ending at %#llx\n",
+			 dc_info.start, info->size);
+		return -EOPNOTSUPP;
+	}
+
+	if (check_add_overflow(info->size, dc_info.size, &total)) {
+		dev_err(dev,
+			"DC partition 0 size %#llx overflows DPA space ending at %#llx\n",
+			dc_info.size, info->size);
+		return -EINVAL;
+	}
+
+	info->size = total;
+	dev_dbg(dev, "Adding dynamic ram partition; %#llx size %#llx\n",
+		dc_info.start, dc_info.size);
+	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM);
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
 
 /**
  * cxl_set_capacity: initialize dpa by a driver without a mailbox.
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 0c8e23276dc6..4fac65dbb808 100644
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
@@ -689,6 +691,39 @@ struct cxl_mbox_set_shutdown_state_in {
 	u8 state;
 } __packed;
 
+/* See CXL r4.0 Table 8-345 get dynamic capacity config Input Payload */
+struct cxl_mbox_get_dc_config_in {
+	u8 partition_count;
+	u8 start_partition_index;
+} __packed;
+
+/* See CXL r4.0 Table 8-346 get dynamic capacity config Output Payload */
+struct cxl_mbox_get_dc_config_out {
+	u8 avail_partition_count;
+	u8 partitions_returned;
+	u8 rsvd[6];
+	/* See CXL r4.0 Table 8-347 */
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
@@ -812,9 +847,18 @@ enum {
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
+int cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
 struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
 						 u16 dvsec);
 void set_exclusive_cxl_commands(struct cxl_memdev_state *mds,
@@ -828,6 +872,17 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
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
index c7c91e8dc51d..2fe9db4b3d86 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -868,6 +868,12 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
+	if (cxl_dcd_supported(mds)) {
+		rc = cxl_configure_dcd(mds, &range_info);
+		if (rc)
+			cxl_disable_dcd(mds);
+	}
+
 	rc = cxl_dpa_setup(cxlds, &range_info);
 	if (rc)
 		return rc;
diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
index 802b143de83d..e07360849344 100644
--- a/include/cxl/cxl.h
+++ b/include/cxl/cxl.h
@@ -133,6 +133,7 @@ struct cxl_dpa_perf {
 enum cxl_partition_mode {
 	CXL_PARTMODE_RAM,
 	CXL_PARTMODE_PMEM,
+	CXL_PARTMODE_DYNAMIC_RAM,
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

