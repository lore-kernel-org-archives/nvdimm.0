Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80F53B4EA7
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 22:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779920941; cv=none; b=oHFzknH4ufxGFs2EtlWNLNJ1X29gODYzprbDZsO1pAjh43Sjpydtkkf+QWzRZEXLY8iPrnYZ/cl8SaWoizUAw+YoFP4s4AQi11FpnQlF4Hl1RzTrbNA9+GSoAl2bUErRLGAZYKBiMhFptahycIqF0PuBXaVfVNUDMUGFygMQ8xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779920941; c=relaxed/simple;
	bh=4jeqmL88MjWr1/3kg+JmoCV4aZ7fBiWUkJphfmxaPQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HSzpRXxyggj2W9irRE4PJepVtBiTNTzg6kqw08J2XKbF0AlgLQuYjCxi352sLk+ulFqhnQVm9A2T0JsdjGj5cdnRJE0LQFtqRLrv9QQ/yk4nW/nxeMwWs4U9AXR/TDCxAf6adUNU8TZzUkKrm67W1cT50v1uxyE+Qc1xtFassp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WdO4doqN; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WdO4doqN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779920938; x=1811456938;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4jeqmL88MjWr1/3kg+JmoCV4aZ7fBiWUkJphfmxaPQ4=;
  b=WdO4doqNS26inBdEzqfNKv1Vs/VXK/WZrTvxYqIJ4FUFNOI49ZqP6uIR
   U2ZCU0ABkXy9heiQTlbgk6wyJOc4h7Yj4Ri6rnvWqFGB4ah9zsbX7duiQ
   HNehA1b/MWyjW6fPdQNywlUaFrVSuNUT8xzaEpIBfrbLpDAWFDxYFacPj
   R4jqKitMZGzJw913CFiMOMsqRknX+NJkI1Q+8PFtFm960y+14YquJFKfj
   hUnM7D9MRTRVMNOeYSf/Lc2YukUFx1rxQgHu+2XrDAhxDAuqUNb3Ys57j
   ssXuiCtWLcasouAaozVVy6iipOrmIXha8Q2/qpihOqnoFV4svlGf+yGLY
   g==;
X-CSE-ConnectionGUID: 8LZ4ww8sTNSl5dX4fTKMLQ==
X-CSE-MsgGUID: Fp+/JyVzRfei1gMTVlgnfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="79914113"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="79914113"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 15:28:58 -0700
X-CSE-ConnectionGUID: YXo44gCyRLWR3XNBoSmVLw==
X-CSE-MsgGUID: OObp1j15Tim//WF5JzLQPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="237943765"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.111.23]) ([10.125.111.23])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 15:28:57 -0700
Message-ID: <c250bffc-005c-4ce5-bf46-94219a7ba5b2@intel.com>
Date: Wed, 27 May 2026 15:28:56 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 02/31] cxl/mem: Read dynamic capacity configuration
 from the device
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Ira Weiny <ira.weiny@intel.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <692890d6934d844cbbe90596499b28833e45f4f5.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <692890d6934d844cbbe90596499b28833e45f4f5.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/26 2:42 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Devices which optionally support Dynamic Capacity (DC) are configured
> via mailbox commands.  CXL 3.2 section 9.13.3 requires the host to issue

4.0

> the Get DC Configuration command in order to properly configure DCDs.
> Without the Get DC Configuration command DCD can't be supported.
> 
> Implement the DC mailbox commands as specified in CXL 3.2 section

4.0

> 8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
> information.  Disable DCD if an invalid configuration is found.
> 
> Linux has no support for more than one dynamic capacity partition.  Read
> and validate all the partitions but configure only the first partition
> as 'dynamic ram A'.  Additional partitions can be added in the future if
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

Missing Anisa sign off

> 
> ---
> Changes:
> [anisa: rebase]
> [jonathan: mbox.c: use max possible size for get_dc_config command to
> avoid vmalloc]
> [jonathan & fan: cxlmem.h: remove unused struct cxl_mem_dev_info]
> ---
>  drivers/cxl/core/hdm.c  |   2 +
>  drivers/cxl/core/mbox.c | 182 ++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxlmem.h    |  47 +++++++++++
>  drivers/cxl/pci.c       |   3 +
>  include/cxl/cxl.h       |   3 +-
>  5 files changed, 236 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 3930e130d6b6..28974adaab75 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -453,6 +453,8 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
>  		return "ram";
>  	case CXL_PARTMODE_PMEM:
>  		return "pmem";
> +	case CXL_PARTMODE_DYNAMIC_RAM_A:
> +		return "dynamic_ram_a";
>  	default:
>  		return "";
>  	};
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 7ef5708bf210..71b29cd6abfe 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1351,6 +1351,156 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
>  	return -EBUSY;
>  }
>  
> +static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_array,
> +			u8 index, struct cxl_dc_partition *dev_part)
> +{
> +	size_t blk_size = le64_to_cpu(dev_part->block_size);
> +	size_t len = le64_to_cpu(dev_part->length);
> +
> +	part_array[index].start = le64_to_cpu(dev_part->base);
> +	part_array[index].size = le64_to_cpu(dev_part->decode_length);
> +	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
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

size: instead of size;

> +			index, blk_size);
> +		return -EINVAL;
> +	}
> +
> +	dev_dbg(dev, "DC partition %d start %zu start %zu size %zu\n",

should it be "DC partition %d start %zu size %zu blk_size: %zu\n"?

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
> +		.min_out = 8,
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
> +	struct device *dev = mbox->host;
> +	size_t dc_resp_size =
> +		sizeof(struct cxl_mbox_get_dc_config_out) + sizeof(partitions);

I think it needs to be something like below because of the 'partition' flex array:
size_t dc_resp_size = struct_size(dc_resp, partition, CXL_MAX_DC_PARTITIONS);

partitions is type 'struct cxl_dc_partition_info'. and dc_resp->partition is type 'struct cxl_dc_partition'. So the size calucation is wrong. It should at least be:
size_t dc_resp_size = sizeof(struct cxl_mbox_get_dc_config_out) + sizeof(struct cxl_dc_partition) * CXL_MAX_DC_PARTITIONS;


> +	u8 start_partition;
> +	u8 num_partitions;
> +
> +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) =
> +					kmalloc(dc_resp_size, GFP_KERNEL);
> +	if (!dc_resp)
> +		return -ENOMEM;
> +
> +	/**

/*

> +	 * Read and check all partition information for validity and potential
> +	 * debugging; see debug output in cxl_dc_check()
> +	 */
> +	start_partition = 0;
> +	num_partitions = 0;
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

Would cxl_get_dc_config() keep returning 0 be a problem? Not likely to happen unless device is malicious.

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
> @@ -1421,6 +1571,38 @@ int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_get_dirty_count, "CXL");
>  
> +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> +{
> +	struct cxl_dc_partition_info dc_info = { 0 };
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

Would this be sufficient?

if (dc_info.start != info->size)

DJ
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
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 53444af448d7..87386488ad10 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -380,6 +380,8 @@ struct cxl_security_state {
>  	struct kernfs_node *sanitize_node;
>  };
>  
> +#define CXL_MAX_DC_PARTITIONS 8
> +
>  static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
>  {
>  	/*
> @@ -664,6 +666,31 @@ struct cxl_mbox_set_shutdown_state_in {
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
> @@ -787,9 +814,18 @@ enum {
>  int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
>  			  struct cxl_mbox_cmd *cmd);
>  int cxl_dev_state_identify(struct cxl_memdev_state *mds);
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
>  struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
>  						 u16 dvsec);
>  void set_exclusive_cxl_commands(struct cxl_memdev_state *mds,
> @@ -803,6 +839,17 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
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
> index bace662dc988..60f9fa05d9ef 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -870,6 +870,9 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (rc)
>  		return rc;
>  
> +	if (cxl_dcd_supported(mds))
> +		cxl_configure_dcd(mds, &range_info);
> +
>  	rc = cxl_dpa_setup(cxlds, &range_info);
>  	if (rc)
>  		return rc;
> diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> index fa7269154620..bb1df0cef863 100644
> --- a/include/cxl/cxl.h
> +++ b/include/cxl/cxl.h
> @@ -133,6 +133,7 @@ struct cxl_dpa_perf {
>  enum cxl_partition_mode {
>  	CXL_PARTMODE_RAM,
>  	CXL_PARTMODE_PMEM,
> +	CXL_PARTMODE_DYNAMIC_RAM_A,
>  };
>  
>  /**
> @@ -147,7 +148,7 @@ struct cxl_dpa_partition {
>  	enum cxl_partition_mode mode;
>  };
>  
> -#define CXL_NR_PARTITIONS_MAX 2
> +#define CXL_NR_PARTITIONS_MAX 3
>  
>  /**
>   * struct cxl_dev_state - The driver device state

