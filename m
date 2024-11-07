Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A4121A71F
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 20:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731013130; cv=none; b=ovErrGBQK0ECuxOne084R0DftamQL0fy3Fss/pf7/m7lpt/v0QXVVz0jgzBy6Wxxdmy6JuaLD/xj8zS+bippGn+Yq0mWokTb2EevDErMbwVkjk1PviaaZkZcGaZBIWOi+BYGya4XmV6PEvsc/DLF1dS3Q3CXcbfurilAHT8t5TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731013130; c=relaxed/simple;
	bh=lMv8bmlpHA1FGB5LZAblsyfifVr5OcjLjITEIivtIwg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=B37wZYajqPGOIwmariSqNfZX7bUmMhA0vvmofgWJ8/qIduC1TCN+TucrBxXCOoqouqj2Bmr43FCMjQQ7dLds3V8uHG8WA/tBqC5Q4AixArfW2NBEKHDF4c7gvxOUBOvksXJalMGquy62Atzve9dgEjwTHchPqpmofhT6K1WkHYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZtcNLGY9; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZtcNLGY9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731013128; x=1762549128;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=lMv8bmlpHA1FGB5LZAblsyfifVr5OcjLjITEIivtIwg=;
  b=ZtcNLGY9LenWtmnG7He3eEVZ4fKGDy5OqICUlzwq3rJXh8wzSWR0dAcG
   RYIRRucC6LoS+snfKO7+hZrgMKI9w6WAEDlPq5h3NyDBkfRjQ/m3mAeSJ
   W/sO/l3IV+Z0L/BjEJJ68C9jCmMGAENJk3wV2mMG3i66Q1EH6jecYOLrK
   AslS5qREWXuyL97ZVdTlToCClMDXMlwZYI2WXtbSD0htF/nISL8hX7tax
   l+8ITd/7KmfckOKqw+KZPPzaU2AqfpvmLAsv/j8R2YNOOgKlNMcj94zjc
   /LewRQJ/H1oAkJC47k2+ZEwvXgWFiu96KAqguzQGNyJO6ps0ITAl888rF
   g==;
X-CSE-ConnectionGUID: okNOl9McRRy6IWYdK6rOsg==
X-CSE-MsgGUID: eqmLm6UQQ86c5sjpxs7u8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="30300374"
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="30300374"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:58:48 -0800
X-CSE-ConnectionGUID: uZUo7I6XQe+ctCjAud/qWQ==
X-CSE-MsgGUID: BcmHpZ50S8iUe2zvWTpKNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="90093629"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.195])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:58:46 -0800
From: ira.weiny@intel.com
Date: Thu, 07 Nov 2024 14:58:26 -0600
Subject: [PATCH v7 08/27] cxl/mem: Read dynamic capacity configuration from
 the device
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-dcd-type2-upstream-v7-8-56a84e66bc36@intel.com>
References: <20241107-dcd-type2-upstream-v7-0-56a84e66bc36@intel.com>
In-Reply-To: <20241107-dcd-type2-upstream-v7-0-56a84e66bc36@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 linux-hardening@vger.kernel.org
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731013104; l=14041;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=imEV0qrXrqUc/0FzLd1IORH6AtTKFZI0aFEj8VEXe08=;
 b=ClnSgAm+veX7IkOyOB3uGfEQLFmVI2WH7VDV5wJ29mEZc8p68H40Haje0XPO1jBAeKU+92kQY
 gEWCMZH+0dZDqTj/SHmZ3nTVA0ZW1O/5bxfTlkQT29PIxSH+JoXmU0a
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

Devices which optionally support Dynamic Capacity (DC) are configured
via mailbox commands.  CXL 3.1 requires the host to issue the Get DC
Configuration command in order to properly configure DCDs.  Without the
Get DC Configuration command DCD can't be supported.

Implement the DC mailbox commands as specified in CXL 3.1 section
8.2.9.9.9 (opcodes 48XXh) to read and store the DCD configuration
information.  Disable DCD if DCD is not supported.  Leverage the Get DC
Configuration command supported bit to indicate if DCD is supported.

Linux has no use for the trailing fields of the Get Dynamic Capacity
Configuration Output Payload (Total number of supported extents, number
of available extents, total number of supported tags, and number of
available tags).  Avoid defining those fields to use the more useful
dynamic C array.

Cc: Li, Ming <ming4.li@intel.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/core/mbox.c | 166 +++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/cxl/cxlmem.h    |  64 ++++++++++++++++++-
 drivers/cxl/pci.c       |   4 ++
 3 files changed, 232 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index aac3bfc0d2c3f916dd870b9f8288b24d90fc9974..2c9a9af3dde3a294cde628880066b514b870029f 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1168,7 +1168,7 @@ int cxl_dev_state_identify(struct cxl_memdev_state *mds)
 	if (rc < 0)
 		return rc;
 
-	mds->total_bytes =
+	mds->static_bytes =
 		le64_to_cpu(id.total_capacity) * CXL_CAPACITY_MULTIPLIER;
 	mds->volatile_only_bytes =
 		le64_to_cpu(id.volatile_capacity) * CXL_CAPACITY_MULTIPLIER;
@@ -1274,6 +1274,154 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
 	return rc;
 }
 
+static int cxl_dc_save_region_info(struct cxl_memdev_state *mds, u8 index,
+				   struct cxl_dc_region_config *region_config)
+{
+	struct cxl_dc_region_info *dcr = &mds->dc_region[index];
+	struct device *dev = mds->cxlds.dev;
+
+	dcr->base = le64_to_cpu(region_config->region_base);
+	dcr->decode_len = le64_to_cpu(region_config->region_decode_length);
+	dcr->decode_len *= CXL_CAPACITY_MULTIPLIER;
+	dcr->len = le64_to_cpu(region_config->region_length);
+	dcr->blk_size = le64_to_cpu(region_config->region_block_size);
+	dcr->dsmad_handle = le32_to_cpu(region_config->region_dsmad_handle);
+	dcr->flags = region_config->flags;
+	snprintf(dcr->name, CXL_DC_REGION_STRLEN, "dc%d", index);
+
+	/* Check regions are in increasing DPA order */
+	if (index > 0) {
+		struct cxl_dc_region_info *prev_dcr = &mds->dc_region[index - 1];
+
+		if ((prev_dcr->base + prev_dcr->decode_len) > dcr->base) {
+			dev_err(dev,
+				"DPA ordering violation for DC region %d and %d\n",
+				index - 1, index);
+			return -EINVAL;
+		}
+	}
+
+	if (!IS_ALIGNED(dcr->base, SZ_256M) ||
+	    !IS_ALIGNED(dcr->base, dcr->blk_size)) {
+		dev_err(dev, "DC region %d invalid base %#llx blk size %#llx\n",
+			index, dcr->base, dcr->blk_size);
+		return -EINVAL;
+	}
+
+	if (dcr->decode_len == 0 || dcr->len == 0 || dcr->decode_len < dcr->len ||
+	    !IS_ALIGNED(dcr->len, dcr->blk_size)) {
+		dev_err(dev, "DC region %d invalid length; decode %#llx len %#llx blk size %#llx\n",
+			index, dcr->decode_len, dcr->len, dcr->blk_size);
+		return -EINVAL;
+	}
+
+	if (dcr->blk_size == 0 || dcr->blk_size % CXL_DCD_BLOCK_LINE_SIZE ||
+	    !is_power_of_2(dcr->blk_size)) {
+		dev_err(dev, "DC region %d invalid block size; %#llx\n",
+			index, dcr->blk_size);
+		return -EINVAL;
+	}
+
+	dev_dbg(dev,
+		"DC region %s base %#llx length %#llx block size %#llx\n",
+		dcr->name, dcr->base, dcr->decode_len, dcr->blk_size);
+
+	return 0;
+}
+
+/* Returns the number of regions in dc_resp or -ERRNO */
+static int cxl_get_dc_config(struct cxl_memdev_state *mds, u8 start_region,
+			     struct cxl_mbox_get_dc_config_out *dc_resp,
+			     size_t dc_resp_size)
+{
+	struct cxl_mbox_get_dc_config_in get_dc = (struct cxl_mbox_get_dc_config_in) {
+		.region_count = CXL_MAX_DC_REGION,
+		.start_region_index = start_region,
+	};
+	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
+		.opcode = CXL_MBOX_OP_GET_DC_CONFIG,
+		.payload_in = &get_dc,
+		.size_in = sizeof(get_dc),
+		.size_out = dc_resp_size,
+		.payload_out = dc_resp,
+		.min_out = 1,
+	};
+	struct device *dev = mds->cxlds.dev;
+	int rc;
+
+	rc = cxl_internal_send_cmd(&mds->cxlds.cxl_mbox, &mbox_cmd);
+	if (rc < 0)
+		return rc;
+
+	dev_dbg(dev, "Read %d/%d DC regions\n",
+		dc_resp->regions_returned, dc_resp->avail_region_count);
+	return dc_resp->regions_returned;
+}
+
+/**
+ * cxl_dev_dynamic_capacity_identify() - Reads the dynamic capacity
+ *					 information from the device.
+ * @mds: The memory device state
+ *
+ * Read Dynamic Capacity information from the device and populate the state
+ * structures for later use.
+ *
+ * Return: 0 if identify was executed successfully, -ERRNO on error.
+ */
+int cxl_dev_dynamic_capacity_identify(struct cxl_memdev_state *mds)
+{
+	size_t dc_resp_size = mds->cxlds.cxl_mbox.payload_size;
+	struct device *dev = mds->cxlds.dev;
+	u8 start_region, i;
+
+	if (!cxl_dcd_supported(mds)) {
+		dev_dbg(dev, "DCD not supported\n");
+		return 0;
+	}
+
+	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) =
+					kvmalloc(dc_resp_size, GFP_KERNEL);
+	if (!dc_resp)
+		return -ENOMEM;
+
+	start_region = 0;
+	do {
+		int rc, j;
+
+		rc = cxl_get_dc_config(mds, start_region, dc_resp, dc_resp_size);
+		if (rc < 0) {
+			dev_err(dev, "Failed to get DC config: %d\n", rc);
+			return rc;
+		}
+
+		mds->nr_dc_region += rc;
+
+		if (mds->nr_dc_region < 1 || mds->nr_dc_region > CXL_MAX_DC_REGION) {
+			dev_err(dev, "Invalid num of dynamic capacity regions %d\n",
+				mds->nr_dc_region);
+			return -EINVAL;
+		}
+
+		for (i = start_region, j = 0; i < mds->nr_dc_region; i++, j++) {
+			rc = cxl_dc_save_region_info(mds, i, &dc_resp->region[j]);
+			if (rc)
+				return rc;
+		}
+
+		start_region = mds->nr_dc_region;
+
+	} while (mds->nr_dc_region < dc_resp->avail_region_count);
+
+	mds->dynamic_bytes =
+		mds->dc_region[mds->nr_dc_region - 1].base +
+		mds->dc_region[mds->nr_dc_region - 1].decode_len -
+		mds->dc_region[0].base;
+	dev_dbg(dev, "Total dynamic range: %#llx\n", mds->dynamic_bytes);
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_dev_dynamic_capacity_identify, CXL);
+
 static int add_dpa_res(struct device *dev, struct resource *parent,
 		       struct resource *res, resource_size_t start,
 		       resource_size_t size, const char *type)
@@ -1304,8 +1452,15 @@ int cxl_mem_create_range_info(struct cxl_memdev_state *mds)
 {
 	struct cxl_dev_state *cxlds = &mds->cxlds;
 	struct device *dev = cxlds->dev;
+	size_t untenanted_mem;
 	int rc;
 
+	mds->total_bytes = mds->static_bytes;
+	if (mds->nr_dc_region) {
+		untenanted_mem = mds->dc_region[0].base - mds->static_bytes;
+		mds->total_bytes += untenanted_mem + mds->dynamic_bytes;
+	}
+
 	if (!cxlds->media_ready) {
 		cxlds->dpa_res = DEFINE_RES_MEM(0, 0);
 		cxlds->ram_res = DEFINE_RES_MEM(0, 0);
@@ -1315,6 +1470,15 @@ int cxl_mem_create_range_info(struct cxl_memdev_state *mds)
 
 	cxlds->dpa_res = DEFINE_RES_MEM(0, mds->total_bytes);
 
+	for (int i = 0; i < mds->nr_dc_region; i++) {
+		struct cxl_dc_region_info *dcr = &mds->dc_region[i];
+
+		rc = add_dpa_res(dev, &cxlds->dpa_res, &cxlds->dc_res[i],
+				 dcr->base, dcr->decode_len, dcr->name);
+		if (rc)
+			return rc;
+	}
+
 	if (mds->partition_align_bytes == 0) {
 		rc = add_dpa_res(dev, &cxlds->dpa_res, &cxlds->ram_res, 0,
 				 mds->volatile_only_bytes, "ram");
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index e8907c403edbd83c8a36b8d013c6bc3391207ee6..05a0718aea73b3b2a02c608bae198eac7c462523 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -403,6 +403,7 @@ enum cxl_devtype {
 	CXL_DEVTYPE_CLASSMEM,
 };
 
+#define CXL_MAX_DC_REGION 8
 /**
  * struct cxl_dpa_perf - DPA performance property entry
  * @dpa_range: range for DPA address
@@ -434,6 +435,8 @@ struct cxl_dpa_perf {
  * @dpa_res: Overall DPA resource tree for the device
  * @pmem_res: Active Persistent memory capacity configuration
  * @ram_res: Active Volatile memory capacity configuration
+ * @dc_res: Active Dynamic Capacity memory configuration for each possible
+ *          region
  * @serial: PCIe Device Serial Number
  * @type: Generic Memory Class device or Vendor Specific Memory device
  * @cxl_mbox: CXL mailbox context
@@ -449,11 +452,23 @@ struct cxl_dev_state {
 	struct resource dpa_res;
 	struct resource pmem_res;
 	struct resource ram_res;
+	struct resource dc_res[CXL_MAX_DC_REGION];
 	u64 serial;
 	enum cxl_devtype type;
 	struct cxl_mailbox cxl_mbox;
 };
 
+#define CXL_DC_REGION_STRLEN 8
+struct cxl_dc_region_info {
+	u64 base;
+	u64 decode_len;
+	u64 len;
+	u64 blk_size;
+	u32 dsmad_handle;
+	u8 flags;
+	u8 name[CXL_DC_REGION_STRLEN];
+};
+
 static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
 {
 	return dev_get_drvdata(cxl_mbox->host);
@@ -473,7 +488,9 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
  * @dcd_cmds: List of DCD commands implemented by memory device
  * @enabled_cmds: Hardware commands found enabled in CEL.
  * @exclusive_cmds: Commands that are kernel-internal only
- * @total_bytes: sum of all possible capacities
+ * @total_bytes: length of all possible capacities
+ * @static_bytes: length of possible static RAM and PMEM partitions
+ * @dynamic_bytes: length of possible DC partitions (DC Regions)
  * @volatile_only_bytes: hard volatile capacity
  * @persistent_only_bytes: hard persistent capacity
  * @partition_align_bytes: alignment size for partition-able capacity
@@ -483,6 +500,8 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
  * @next_persistent_bytes: persistent capacity change pending device reset
  * @ram_perf: performance data entry matched to RAM partition
  * @pmem_perf: performance data entry matched to PMEM partition
+ * @nr_dc_region: number of DC regions implemented in the memory device
+ * @dc_region: array containing info about the DC regions
  * @event: event log driver state
  * @poison: poison driver state info
  * @security: security driver state info
@@ -499,6 +518,8 @@ struct cxl_memdev_state {
 	DECLARE_BITMAP(enabled_cmds, CXL_MEM_COMMAND_ID_MAX);
 	DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
 	u64 total_bytes;
+	u64 static_bytes;
+	u64 dynamic_bytes;
 	u64 volatile_only_bytes;
 	u64 persistent_only_bytes;
 	u64 partition_align_bytes;
@@ -510,6 +531,9 @@ struct cxl_memdev_state {
 	struct cxl_dpa_perf ram_perf;
 	struct cxl_dpa_perf pmem_perf;
 
+	u8 nr_dc_region;
+	struct cxl_dc_region_info dc_region[CXL_MAX_DC_REGION];
+
 	struct cxl_event_state event;
 	struct cxl_poison_state poison;
 	struct cxl_security_state security;
@@ -708,6 +732,32 @@ struct cxl_mbox_set_partition_info {
 
 #define  CXL_SET_PARTITION_IMMEDIATE_FLAG	BIT(0)
 
+/* See CXL 3.1 Table 8-163 get dynamic capacity config Input Payload */
+struct cxl_mbox_get_dc_config_in {
+	u8 region_count;
+	u8 start_region_index;
+} __packed;
+
+/* See CXL 3.1 Table 8-164 get dynamic capacity config Output Payload */
+struct cxl_mbox_get_dc_config_out {
+	u8 avail_region_count;
+	u8 regions_returned;
+	u8 rsvd[6];
+	/* See CXL 3.1 Table 8-165 */
+	struct cxl_dc_region_config {
+		__le64 region_base;
+		__le64 region_decode_length;
+		__le64 region_length;
+		__le64 region_block_size;
+		__le32 region_dsmad_handle;
+		u8 flags;
+		u8 rsvd[3];
+	} __packed region[] __counted_by(regions_returned);
+	/* Trailing fields unused */
+} __packed;
+#define CXL_DYNAMIC_CAPACITY_SANITIZE_ON_RELEASE_FLAG BIT(0)
+#define CXL_DCD_BLOCK_LINE_SIZE 0x40
+
 /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
 struct cxl_mbox_set_timestamp_in {
 	__le64 timestamp;
@@ -831,6 +881,7 @@ enum {
 int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
 			  struct cxl_mbox_cmd *cmd);
 int cxl_dev_state_identify(struct cxl_memdev_state *mds);
+int cxl_dev_dynamic_capacity_identify(struct cxl_memdev_state *mds);
 int cxl_await_media_ready(struct cxl_dev_state *cxlds);
 int cxl_enumerate_cmds(struct cxl_memdev_state *mds);
 int cxl_mem_create_range_info(struct cxl_memdev_state *mds);
@@ -844,6 +895,17 @@ void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
 			    enum cxl_event_log_type type,
 			    enum cxl_event_type event_type,
 			    const uuid_t *uuid, union cxl_event *evt);
+
+static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
+{
+	return test_bit(CXL_DCD_ENABLED_GET_CONFIG, mds->dcd_cmds);
+}
+
+static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
+{
+	clear_bit(CXL_DCD_ENABLED_GET_CONFIG, mds->dcd_cmds);
+}
+
 int cxl_set_timestamp(struct cxl_memdev_state *mds);
 int cxl_poison_state_init(struct cxl_memdev_state *mds);
 int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 295779c433b2a2e377995b53a70ff2a3158b0a8e..c8454b3ecea5c053bf9723c275652398c0b2a195 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -899,6 +899,10 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
+	rc = cxl_dev_dynamic_capacity_identify(mds);
+	if (rc)
+		cxl_disable_dcd(mds);
+
 	rc = cxl_mem_create_range_info(mds);
 	if (rc)
 		return rc;

-- 
2.47.0

