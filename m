Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F06923D2B9
	for <nvdimm@lists.linux.dev>; Mon, 14 Apr 2025 14:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744641326; cv=none; b=f6aGPt78QTNNuDHc22UhPAOuUHA8UiS1yCf+HglE+bfCaOQYGfdegFwvCWFPAsSIFqYZcH2jVK8ddvWD9S3FDAiMDJKYsgir3K+yC/g1hctCLTLimyJgXcltEOGjkMx6kSlp7OySsKeoJy0s5Ietsgtfp+nbmie1jO0CcuDcqT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744641326; c=relaxed/simple;
	bh=0YDodx9g88LFQCfHOABq7ktoKeeDdQ7fb6ReKOTuX14=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oX0WzDtqMvuk76JUVZsanDzVNFKZHmJwllrG0H1Pg4ApOl+e0iO3YIeyhF8sSb5BIXYbUmeIdma/PUyAN5otZdE1PadY19u7aI5VANgF9KlyJr1iAmPDn492mNauGYQm1Yo3QJYnLgLCySH1NASVEPTYGLculIzAQCCvS4oLet4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZbqV523yGz6M4p0;
	Mon, 14 Apr 2025 22:31:25 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 69C631401DC;
	Mon, 14 Apr 2025 22:35:21 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 14 Apr
 2025 16:35:20 +0200
Date: Mon, 14 Apr 2025 15:35:19 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Dan
 Williams" <dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 02/19] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <20250414153519.0000677a@huawei.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-2-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
	<20250413-dcd-type2-upstream-v9-2-1d4911a0b365@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Sun, 13 Apr 2025 17:52:10 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> Devices which optionally support Dynamic Capacity (DC) are configured
> via mailbox commands.  CXL 3.2 section 9.13.3 requires the host to issue
> the Get DC Configuration command in order to properly configure DCDs.
> Without the Get DC Configuration command DCD can't be supported.
> 
> Implement the DC mailbox commands as specified in CXL 3.2 section
> 8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
> information.  Disable DCD if an invalid configuration is found.
> 
> Linux has no support for more than one dynamic capacity partition.  Read
> and validate all the partitions but configure only the first partition
> as 'dynamic ram A'. Additional partitions can be added in the future if
> such a device ever materializes.  Additionally is it anticipated that no
> skips will be present from the end of the pmem partition.  Check for an
> disallow this configuration as well.
> 
> Linux has no use for the trailing fields of the Get Dynamic Capacity
> Configuration Output Payload (Total number of supported extents, number
> of available extents, total number of supported tags, and number of
> available tags).  Avoid defining those fields to use the more useful
> dynamic C array.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes:
> [iweiny: rebase]
> [iweiny: Update spec references to 3.2]
> [djbw: Limit to 1 partition]
> [djbw: Avoid inter-partition skipping]
> [djbw: s/region/partition/]
> [djbw: remove cxl_dc_region[partition]_info->name]
> [iweiny: adjust to lack of dcd_cmds in mds]
> [iweiny: remove extra 'region' from names]
> [iweiny: remove unused CXL_DYNAMIC_CAPACITY_SANITIZE_ON_RELEASE_FLAG]
> ---

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 58d378400a4b..866a423d6125 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1313,6 +1313,153 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
>  	return -EBUSY;
>  }
>  
> +static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_array,
> +			u8 index, struct cxl_dc_partition *dev_part)
> +{
> +	size_t blk_size, len;
> +
> +	part_array[index].start = le64_to_cpu(dev_part->base);
> +	part_array[index].size = le64_to_cpu(dev_part->decode_length);
> +	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
> +	len = le64_to_cpu(dev_part->length);
> +	blk_size = le64_to_cpu(dev_part->block_size);
> +
> +	/* Check partitions are in increasing DPA order */
> +	if (index > 0) {
> +		struct cxl_dc_partition_info *prev_part = &part_array[index - 1];
> +
> +		if ((prev_part->start + prev_part->size) >
> +		     part_array[index].start) {
> +			dev_err(dev,
> +				"DPA ordering violation for DC partition %d and %d\n",
> +				index - 1, index);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (!IS_ALIGNED(part_array[index].start, SZ_256M) ||
> +	    !IS_ALIGNED(part_array[index].start, blk_size)) {
> +		dev_err(dev, "DC partition %d invalid start %zu blk size %zu\n",
> +			index, part_array[index].start, blk_size);
> +		return -EINVAL;
> +	}
> +
> +	if (part_array[index].size == 0 || len == 0 ||
> +	    part_array[index].size < len || !IS_ALIGNED(len, blk_size)) {
> +		dev_err(dev, "DC partition %d invalid length; size %zu len %zu blk size %zu\n",
> +			index, part_array[index].size, len, blk_size);
> +		return -EINVAL;
> +	}
> +
> +	if (blk_size == 0 || blk_size % CXL_DCD_BLOCK_LINE_SIZE ||
> +	    !is_power_of_2(blk_size)) {
> +		dev_err(dev, "DC partition %d invalid block size; %zu\n",
> +			index, blk_size);
> +		return -EINVAL;
> +	}
> +
> +	dev_dbg(dev, "DC partition %d start %zu start %zu size %zu\n",
> +		index, part_array[index].start, part_array[index].size,
> +		blk_size);
> +
> +	return 0;
> +}
> +
> +/* Returns the number of partitions in dc_resp or -ERRNO */
> +static int cxl_get_dc_config(struct cxl_mailbox *mbox, u8 start_partition,
> +			     struct cxl_mbox_get_dc_config_out *dc_resp,
> +			     size_t dc_resp_size)
> +{
> +	struct cxl_mbox_get_dc_config_in get_dc = (struct cxl_mbox_get_dc_config_in) {
> +		.partition_count = CXL_MAX_DC_PARTITIONS,
> +		.start_partition_index = start_partition,
> +	};
> +	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
> +		.opcode = CXL_MBOX_OP_GET_DC_CONFIG,
> +		.payload_in = &get_dc,
> +		.size_in = sizeof(get_dc),
> +		.size_out = dc_resp_size,
> +		.payload_out = dc_resp,
> +		.min_out = 1,
> +	};
> +	int rc;
> +
> +	rc = cxl_internal_send_cmd(mbox, &mbox_cmd);
> +	if (rc < 0)
> +		return rc;
> +
> +	dev_dbg(mbox->host, "Read %d/%d DC partitions\n",
> +		dc_resp->partitions_returned, dc_resp->avail_partition_count);
> +	return dc_resp->partitions_returned;
> +}
> +
> +/**
> + * cxl_dev_dc_identify() - Reads the dynamic capacity information from the
> + *                         device.
> + * @mbox: Mailbox to query
> + * @dc_info: The dynamic partition information to return
> + *
> + * Read Dynamic Capacity information from the device and return the partition
> + * information.
> + *
> + * Return: 0 if identify was executed successfully, -ERRNO on error.
> + *         on error only dynamic_bytes is left unchanged.
> + */
> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info)
> +{
> +	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS];
> +	size_t dc_resp_size = mbox->payload_size;
> +	struct device *dev = mbox->host;
> +	u8 start_partition;
> +	u8 num_partitions;
> +
> +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) =
> +					kvmalloc(dc_resp_size, GFP_KERNEL);
> +	if (!dc_resp)
> +		return -ENOMEM;
> +
> +	/* Read and check all partition information for validity and potential
> +	 * debugging; see debug output in cxl_dc_check() */
> +	start_partition = 0;
> +	do {
> +		int rc, i, j;
> +
> +		rc = cxl_get_dc_config(mbox, start_partition, dc_resp, dc_resp_size);
> +		if (rc < 0) {
> +			dev_err(dev, "Failed to get DC config: %d\n", rc);
> +			return rc;
> +		}
> +
> +		num_partitions += rc;
> +
> +		if (num_partitions < 1 || num_partitions > CXL_MAX_DC_PARTITIONS) {
> +			dev_err(dev, "Invalid num of dynamic capacity partitions %d\n",
> +				num_partitions);
> +			return -EINVAL;
> +		}
> +
> +		for (i = start_partition, j = 0; i < num_partitions; i++, j++) {
> +			rc = cxl_dc_check(dev, partitions, i,
> +					  &dc_resp->partition[j]);
> +			if (rc)
> +				return rc;
> +		}
> +
> +		start_partition = num_partitions;
> +
> +	} while (num_partitions < dc_resp->avail_partition_count);
> +
> +	/* Return 1st partition */
> +	dc_info->start = partitions[0].start;
> +	dc_info->size = partitions[0].size;
> +	dev_dbg(dev, "Returning partition 0 %zu size %zu\n",
> +		dc_info->start, dc_info->size);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
> +
>  static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
>  {
>  	int i = info->nr_partitions;
> @@ -1383,6 +1530,38 @@ int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_get_dirty_count, "CXL");
>  
> +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> +{
> +	struct cxl_dc_partition_info dc_info = { 0 };
Trivial bit of c stuff that surprised me in another thread the other day that doesn't
apply here because of packed nature of structure but...

 = {}; is defined in c23 (and probably before that in practice) as
the "empty initializer"
> +	struct device *dev = mds->cxlds.dev;
> +	size_t skip;
> +	int rc;
> +
> +	rc = cxl_dev_dc_identify(&mds->cxlds.cxl_mbox, &dc_info);
> +	if (rc) {
> +		dev_warn(dev,
> +			 "Failed to read Dynamic Capacity config: %d\n", rc);
> +		cxl_disable_dcd(mds);
> +		return;
> +	}
> +
> +	/* Skips between pmem and the dynamic partition are not supported */
> +	skip = dc_info.start - info->size;
> +	if (skip) {
> +		dev_warn(dev,
> +			 "Dynamic Capacity skip from pmem not supported: %zu\n",
> +			 skip);
> +		cxl_disable_dcd(mds);
> +		return;
> +	}
> +
> +	info->size += dc_info.size;
> +	dev_dbg(dev, "Adding dynamic ram partition A; %zu size %zu\n",
> +		dc_info.start, dc_info.size);
> +	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_A);
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
> +
>  int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds)
>  {
>  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index be8a7dc77719..a9d42210e8a3 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -485,6 +485,7 @@ struct cxl_region_params {
>  enum cxl_partition_mode {
>  	CXL_PARTMODE_RAM,
>  	CXL_PARTMODE_PMEM,
> +	CXL_PARTMODE_DYNAMIC_RAM_A,
>  };
>  
>  /*
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 394a776954f4..057933128d2c 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -97,7 +97,7 @@ int devm_cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
>  			 resource_size_t base, resource_size_t len,
>  			 resource_size_t skipped);
>  
> -#define CXL_NR_PARTITIONS_MAX 2
> +#define CXL_NR_PARTITIONS_MAX 3
>  
>  struct cxl_dpa_info {
>  	u64 size;
> @@ -380,6 +380,7 @@ enum cxl_devtype {
>  	CXL_DEVTYPE_CLASSMEM,
>  };
>  
> +#define CXL_MAX_DC_PARTITIONS 8
>  /**
>   * struct cxl_dpa_perf - DPA performance property entry
>   * @dpa_range: range for DPA address
> @@ -722,6 +723,31 @@ struct cxl_mbox_set_shutdown_state_in {
>  	u8 state;
>  } __packed;
>  
> +/* See CXL 3.2 Table 8-178 get dynamic capacity config Input Payload */
> +struct cxl_mbox_get_dc_config_in {
> +	u8 partition_count;
> +	u8 start_partition_index;
> +} __packed;
> +
> +/* See CXL 3.2 Table 8-179 get dynamic capacity config Output Payload */
> +struct cxl_mbox_get_dc_config_out {
> +	u8 avail_partition_count;
> +	u8 partitions_returned;
> +	u8 rsvd[6];
> +	/* See CXL 3.2 Table 8-180 */
> +	struct cxl_dc_partition {
> +		__le64 base;
> +		__le64 decode_length;
> +		__le64 length;
> +		__le64 block_size;
> +		__le32 dsmad_handle;
> +		u8 flags;
> +		u8 rsvd[3];
> +	} __packed partition[] __counted_by(partitions_returned);
> +	/* Trailing fields unused */
> +} __packed;
> +#define CXL_DCD_BLOCK_LINE_SIZE 0x40
> +
>  /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
>  struct cxl_mbox_set_timestamp_in {
>  	__le64 timestamp;
> @@ -845,9 +871,24 @@ enum {
>  int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
>  			  struct cxl_mbox_cmd *cmd);
>  int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> +
> +struct cxl_mem_dev_info {
> +	u64 total_bytes;
> +	u64 volatile_bytes;
> +	u64 persistent_bytes;
> +};
> +
> +struct cxl_dc_partition_info {
> +	size_t start;
> +	size_t size;
> +};
> +
> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info);
>  int cxl_await_media_ready(struct cxl_dev_state *cxlds);
>  int cxl_enumerate_cmds(struct cxl_memdev_state *mds);
>  int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
> +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
>  struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev);
>  void set_exclusive_cxl_commands(struct cxl_memdev_state *mds,
>  				unsigned long *cmds);
> @@ -860,6 +901,17 @@ void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
>  			    const uuid_t *uuid, union cxl_event *evt);
>  int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count);
>  int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds);
> +
> +static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
> +{
> +	return mds->dcd_supported;
> +}
> +
> +static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
> +{
> +	mds->dcd_supported = false;
> +}
> +
>  int cxl_set_timestamp(struct cxl_memdev_state *mds);
>  int cxl_poison_state_init(struct cxl_memdev_state *mds);
>  int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 7b14a154463c..bc40cf6e2fe9 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -998,6 +998,9 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (rc)
>  		return rc;
>  
> +	if (cxl_dcd_supported(mds))
> +		cxl_configure_dcd(mds, &range_info);
> +
>  	rc = cxl_dpa_setup(cxlds, &range_info);
>  	if (rc)
>  		return rc;
> 

