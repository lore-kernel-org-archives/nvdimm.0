Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C69F3BF672
	for <nvdimm@lists.linux.dev>; Fri, 26 Jun 2026 22:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782512814; cv=none; b=mxQ46m6T6rpC9e3T1RQ6MLb1iCwbksFhEnPHbb/t99i7t+eQ8BOKgHoMR4rwIjquv05HZ16Lsjm285iIPcn4F3cTmuePqcXJ2ZMiWpCPHYPr+iECmEvvZhvW6T0hYVhf3E/kgEWjWGo+1iTKBAcrYkFDZT6DlFz9Lu4zKj0ChJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782512814; c=relaxed/simple;
	bh=PpcmFzyU9sB1nZ8c6P7QWSTLdEd/nCNGn23yUN+6XIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f0oe1Y1Az8dm4v5p/+L3qWokggxFobL/2EqNWcmqbNib413f0yO8KkLpWICCq0FVPsN8DdZ4CkH8ubTZilf501dwj/2KLIXaZeuQ1gIQ2q0GO9pmF/8yymxhFCatqgEklQg4vim52kVUvYN/t+axd6N38ESPCqERl9i71xQ+C3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EpAL41KD; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EpAL41KD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782512813; x=1814048813;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PpcmFzyU9sB1nZ8c6P7QWSTLdEd/nCNGn23yUN+6XIw=;
  b=EpAL41KDwyV462XBDOHMd4BSAXXDfStMzMKzRLM+q5W3OKPj8eglWfXu
   75SICNuDIUy32D4qVphHAhZgv5Pq0ogcROiS1L8wv7Ub13F8Ib0BjGw4G
   7+KB3SBSM1cIlWDOZm1y76l9UIqleahwYRz+NuZuaTCBPPs6uXKkyY9AH
   qgtd2VHUN6ZjZqed5Aqemg2Fp6dammsGBnhvQ4KzsnhIbQqIIW3JDCdi+
   TnXLHuoPQyurKzmySdaRS4MekLRhjIa8IxRijXbPSpD71NLGq9Z6HyMJU
   l7v5wEo/58H1sj6CRx7iSc2D/XZG+3V99xEsnMFuP79OBPsHDzISz+rum
   g==;
X-CSE-ConnectionGUID: yuFMeMKHTc2q0451Ry/Apg==
X-CSE-MsgGUID: oKqpSevoTcGYttDYiynbjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11829"; a="93965401"
X-IronPort-AV: E=Sophos;i="6.24,227,1774335600"; 
   d="scan'208";a="93965401"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 15:26:52 -0700
X-CSE-ConnectionGUID: ReLV2/EDQpWVduu5ZyZoVw==
X-CSE-MsgGUID: GllTp4TOQ6WmTFEgJTI0qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,227,1774335600"; 
   d="scan'208";a="253333151"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.96]) ([10.125.109.96])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 15:26:50 -0700
Message-ID: <fb0b2eff-6244-4143-a806-5b57e66a1eba@intel.com>
Date: Fri, 26 Jun 2026 15:26:49 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 02/31] cxl/mem: Read dynamic capacity configuration
 from the device
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-3-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260625112638.550691-3-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/25/26 4:04 AM, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Devices which optionally support Dynamic Capacity (DC) are configured
> via mailbox commands.  CXL r4.0 section 9.13.3 requires the host to issue
> the Get DC Configuration command in order to properly configure DCDs.
> Without the Get DC Configuration command DCD can't be supported.
> 
> Implement the DC mailbox commands as specified in CXL 4.0 section
> 8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
> information.  Disable DCD if an invalid configuration is found.
> 
> Linux has no support for more than one dynamic capacity partition.  Read
> and validate all the partitions but configure only the first partition
> as 'dynamic ram 1'.  Additional partitions can be added in the future if
> such a device ever materializes.  Additionally it is anticipated that no
> skips will be present from the end of the pmem partition.  Check for and
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
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>

Couple minor things besides sachiko issues

> 
> ---
> Changes:
> 1. Move partition alignment check after is_power_of_2() check on
>    blk_size, as IS_ALIGNED(partition start, blk_size) expects blk_size
>    to be a power of 2 in cxl_dc_check()
> 
> 2. cxl_get_dc_config(): verify mbox_cmd.size_out against
>    dc_resp->partitions_returned
> 
> 3. cxl_dev_dc_identify(): originally calculated size of dc_resp using
>    struct cxl_dc_partition_info, but dc_resp->partition[] is of type
>    struct cxl_dc_partition. Fix size calculation.
> 
> 4. fix do/while loop in cxl_dev_dc_identify to protect against returning
>    0 partitions infinitely
> 
> 5. cxl_configure_dcd(): originally checked for gap between PMEM and DC
>    partition by calculating if a gap exists:
>    	if ([start of dc part] - [end of pmem part])
>    Replace with: if ([start of dc part] != [end of pmem part]) to avoid
>    underflow in case of bad input
> 
> 6. Change struct cxl_dc_partition_info to use u64 instead of size_t
>    fields
> 
> 7. Original commit message referenced CXL r3.2. Bump to r4.0.
>    Verified section numbers remain the same
> 
> 8. Rename dynamic_ram_a to dynamic_ram_1
> ---
>  drivers/cxl/core/hdm.c  |   2 +
>  drivers/cxl/core/mbox.c | 211 ++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxlmem.h    |  47 +++++++++
>  drivers/cxl/pci.c       |   3 +
>  include/cxl/cxl.h       |   3 +-
>  5 files changed, 265 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 0c80b76a5f9b..0ef076c08ed2 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -446,6 +446,8 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
>  		return "ram";
>  	case CXL_PARTMODE_PMEM:
>  		return "pmem";
> +	case CXL_PARTMODE_DYNAMIC_RAM_1:
> +		return "dynamic_ram_1";
>  	default:
>  		return "";
>  	};
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 07aba6f0b719..2932bbd67e55 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1347,6 +1347,188 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
>  	return -EBUSY;
>  }
>  
> +static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_array,
> +			u8 index, struct cxl_dc_partition *dev_part)
> +{
> +	u64 blk_size = le64_to_cpu(dev_part->block_size);
> +	u64 len = le64_to_cpu(dev_part->length);
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
> +	if (part_array[index].size == 0 || len == 0 ||
> +	    part_array[index].size < len || !IS_ALIGNED(len, blk_size)) {
> +		dev_err(dev, "DC partition %d invalid length; size %llu len %llu blk size %llu\n",
> +			index, part_array[index].size, len, blk_size);
> +		return -EINVAL;
> +	}
> +
> +	if (blk_size == 0 || blk_size % CXL_DCD_BLOCK_LINE_SIZE ||
> +	    !is_power_of_2(blk_size)) {
> +		dev_err(dev, "DC partition %d invalid block size %llu\n",
> +			index, blk_size);
> +		return -EINVAL;
> +	}
> +
> +	if (!IS_ALIGNED(part_array[index].start, SZ_256M) ||
> +	    !IS_ALIGNED(part_array[index].start, blk_size)) {
> +		dev_err(dev, "DC partition %d invalid start %llu blk size %llu\n",
> +			index, part_array[index].start, blk_size);
> +		return -EINVAL;
> +	}
> +
> +	dev_dbg(dev, "DC partition %d start %llu size %llu blk_size: %llu\n",
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
> +	size_t expected_sz;
> +	int rc;
> +
> +	rc = cxl_internal_send_cmd(mbox, &mbox_cmd);
> +	if (rc < 0)
> +		return rc;
> +
> +	if (dc_resp->partitions_returned > CXL_MAX_DC_PARTITIONS) {
> +		dev_err(mbox->host, "Device returned %u partitions, max %d\n",
> +			dc_resp->partitions_returned, CXL_MAX_DC_PARTITIONS);
> +		return -EIO;
> +	}
> +
> +	/*
> +	 * The payload carries trailing extent/tag count fields after the
> +	 * partition array (CXL 3.2 Table 8-179) which the driver ignores, so
> +	 * the response is at least, not exactly, expected_sz.
> +	 */
> +	expected_sz = struct_size(dc_resp, partition,
> +				  dc_resp->partitions_returned);
> +
> +	if (mbox_cmd.size_out < expected_sz) {
> +		dev_err(mbox->host,
> +			"Payload size %zu less than expected %zu for %u partitions\n",
> +			mbox_cmd.size_out,
> +			expected_sz,
> +			dc_resp->partitions_returned);
> +		return -EIO;
> +	}
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

s/dynamic_bytes/dc_info/ ?

> + */
> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info)
> +{
> +	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS];
> +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree);
> +	struct device *dev = mbox->host;
> +	u8 start_partition;
> +	u8 num_partitions;
> +	size_t dc_resp_size = struct_size(dc_resp,
> +					  partition,
> +					  CXL_MAX_DC_PARTITIONS);
> +
> +	dc_resp = kmalloc(dc_resp_size, GFP_KERNEL);
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
> +		if (rc == 0) {
> +			dev_err(dev,
> +				"Device reported %u partitions available but returned none at index %u\n",
> +				dc_resp->avail_partition_count, start_partition);
> +			return -EIO;
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
> +	dev_dbg(dev, "Returning partition 0 %llu size %llu\n",
> +		dc_info->start, dc_info->size);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
> +
>  static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
>  {
>  	int i = info->nr_partitions;
> @@ -1417,6 +1599,35 @@ int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_get_dirty_count, "CXL");
>  
> +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> +{
> +	struct cxl_dc_partition_info dc_info = { 0 };
> +	struct device *dev = mds->cxlds.dev;
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
> +	if (dc_info.start != info->size) {
> +		dev_warn(dev,
> +			 "Dynamic Capacity skip from pmem not supported\n");
> +		cxl_disable_dcd(mds);
> +		return;
> +	}
> +
> +	info->size += dc_info.size;
> +	dev_dbg(dev, "Adding dynamic ram partition 1; %llu size %llu\n",
> +		dc_info.start, dc_info.size);
> +	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1);
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
> +
>  int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds)
>  {
>  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 60dc3f0006a7..6b548a1ec1e9 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -385,6 +385,8 @@ struct cxl_security_state {
>  	struct kernfs_node *sanitize_node;
>  };
>  
> +#define CXL_MAX_DC_PARTITIONS 8
> +
>  static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
>  {
>  	/*
> @@ -669,6 +671,31 @@ struct cxl_mbox_set_shutdown_state_in {
>  	u8 state;
>  } __packed;
>  
> +/* See CXL 3.2 Table 8-178 get dynamic capacity config Input Payload */

Update to r4.0, which is also what the commit log cites.

> +struct cxl_mbox_get_dc_config_in {
> +	u8 partition_count;
> +	u8 start_partition_index;
> +} __packed;
> +
> +/* See CXL 3.2 Table 8-179 get dynamic capacity config Output Payload */

Update to r4.0

DJ

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
> +	/* Trailing extent/tag count fields unused */
> +} __packed;
> +#define CXL_DCD_BLOCK_LINE_SIZE 0x40
> +
>  /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
>  struct cxl_mbox_set_timestamp_in {
>  	__le64 timestamp;
> @@ -792,9 +819,18 @@ enum {
>  int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
>  			  struct cxl_mbox_cmd *cmd);
>  int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> +
> +struct cxl_dc_partition_info {
> +	u64 start;
> +	u64 size;
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
> @@ -808,6 +844,17 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
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
> index fa7269154620..e8a0899960d4 100644
> --- a/include/cxl/cxl.h
> +++ b/include/cxl/cxl.h
> @@ -133,6 +133,7 @@ struct cxl_dpa_perf {
>  enum cxl_partition_mode {
>  	CXL_PARTMODE_RAM,
>  	CXL_PARTMODE_PMEM,
> +	CXL_PARTMODE_DYNAMIC_RAM_1,
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

