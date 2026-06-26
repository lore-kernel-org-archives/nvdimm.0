Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A783C455B
	for <nvdimm@lists.linux.dev>; Fri, 26 Jun 2026 22:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782513007; cv=none; b=HFptiavQSBvj1ZXIkqBXqlL92U8XTPdiqlq66NUmdHIN/M/L0qEzfNvy4skQ1/gDKNEsfzm9R5AGmejGaFOk2P5NpaDmUDruAhBzdxKYDdAObcdHxqjqkPjTXvd2xgSDhqHCa78OSY5qJo/MoB+HM2n/0ldjhpfiHbxV9DvYeI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782513007; c=relaxed/simple;
	bh=RBT+VNrfqEKropetslFt4xf4rdnoUf6MukNh3fANmNY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DHGAc24HZ1Eji4Qk3Ymg7w5+p9vdlV8oL20YdTWO7OWtinsqt3ffaBDRS0IZpBke8PoioGHL2Fbkfs09vJEkuFk//6iMS8pfNray2eDXbd53zt2hRG2NicHj7yZprGgfkzKIqpUlnTJlLzxsdnLOSa/+PtwnTaAdFgNKctkuBsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kL2Pp8Ex; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kL2Pp8Ex"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782513006; x=1814049006;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RBT+VNrfqEKropetslFt4xf4rdnoUf6MukNh3fANmNY=;
  b=kL2Pp8ExjFWSGUYiuZO5AJf6VN5O/OtLSwxM+VSLrUwQA5siNQxavf1h
   JcNMfumVrIp6YJhevINT30sMFdQHdq6aYZuoWOJZCiRKu/ucaEMwBMev9
   5LccciIh7FpYXNCvB75iNmRqxiFihW1B15qAG6OVheKIG3t57I820D/+u
   PHJf3b02nPDaS/D5lz1aSgV4iuh9PYGEC7ULJfwtUXRuGWJHIR/Dq2UFn
   8wOWe0sw1KEEbnvXTWnqDyegBQXerl4kJwB7jkodpu87ZbZeE+2G079hE
   Rpcz4aygM1Ek4G1UAPJMmuZB1Q6uP55a+FNXhJ1aUhqsW7oFIph8WHE4S
   w==;
X-CSE-ConnectionGUID: z6jR37+WRk6KdRo4W9qGIA==
X-CSE-MsgGUID: 4Gzq5f6DRXWaq/kqAji/Hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11829"; a="93965579"
X-IronPort-AV: E=Sophos;i="6.24,227,1774335600"; 
   d="scan'208";a="93965579"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 15:30:05 -0700
X-CSE-ConnectionGUID: 5yWzFTrRQRWnJi/ic+pi/g==
X-CSE-MsgGUID: 6Fc1uIZvTCGFKOzpuRWIMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,227,1774335600"; 
   d="scan'208";a="253334405"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.96]) ([10.125.109.96])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 15:30:04 -0700
Message-ID: <13b2ef5c-778c-4b8e-bb99-be2c86e3cfc8@intel.com>
Date: Fri, 26 Jun 2026 15:30:03 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 03/31] cxl/cdat: Gather DSMAS data for DCD partitions
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, djbw@kernel.org, jic23@kernel.org,
 dave@stgolabs.net, vishal.l.verma@intel.com, iweiny@kernel.org,
 alison.schofield@intel.com, gourry@gourry.net, anisa.su@samsung.com
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625180028.965-1-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260625180028.965-1-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/25/26 11:00 AM, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Additional DCD partition (AKA region) information is contained in the
> DSMAS CDAT tables, including performance, read only, and shareable
> attributes.
> 
> Match DCD partitions with DSMAS tables and store the meta data.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>

Maybe a co-developed-by tag since you are making changes with the shareable flag location?

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/cxl/core/cdat.c | 12 ++++++++++++
>  drivers/cxl/core/hdm.c  |  1 +
>  drivers/cxl/core/mbox.c | 22 ++++++++++++++++------
>  drivers/cxl/cxlmem.h    |  2 ++
>  include/cxl/cxl.h       |  4 ++++
>  5 files changed, 35 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
> index 5c9f07262513..a280039e4cd1 100644
> --- a/drivers/cxl/core/cdat.c
> +++ b/drivers/cxl/core/cdat.c
> @@ -17,6 +17,7 @@ struct dsmas_entry {
>  	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
>  	int entries;
>  	int qos_class;
> +	bool shareable;
>  };
>  
>  static u32 cdat_normalize(u16 entry, u64 base, u8 type)
> @@ -74,6 +75,7 @@ static int cdat_dsmas_handler(union acpi_subtable_headers *header, void *arg,
>  		return -ENOMEM;
>  
>  	dent->handle = dsmas->dsmad_handle;
> +	dent->shareable = dsmas->flags & ACPI_CDAT_DSMAS_SHAREABLE;
>  	dent->dpa_range.start = le64_to_cpu((__force __le64)dsmas->dpa_base_address);
>  	dent->dpa_range.end = le64_to_cpu((__force __le64)dsmas->dpa_base_address) +
>  			      le64_to_cpu((__force __le64)dsmas->dpa_length) - 1;
> @@ -266,15 +268,25 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
>  		bool found = false;
>  
>  		for (int i = 0; i < cxlds->nr_partitions; i++) {
> +			enum cxl_partition_mode mode = cxlds->part[i].mode;
>  			struct resource *res = &cxlds->part[i].res;
> +			u8 handle = cxlds->part[i].handle;
>  			struct range range = {
>  				.start = res->start,
>  				.end = res->end,
>  			};
>  
>  			if (range_contains(&range, &dent->dpa_range)) {
> +				if (mode == CXL_PARTMODE_DYNAMIC_RAM_1 &&
> +				    dent->handle != handle) {
> +					dev_warn(dev,
> +						"Dynamic RAM perf mismatch; %pra (%u) vs %pra (%u)\n",
> +						&range, handle, &dent->dpa_range, dent->handle);
> +					continue;
> +				}
>  				update_perf_entry(dev, dent,
>  						  &cxlds->part[i].perf);
> +				cxlds->part[i].shareable = dent->shareable;
>  				found = true;
>  				break;
>  			}
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 0ef076c08ed2..7f63b86887f4 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -477,6 +477,7 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  
>  		cxlds->part[i].perf.qos_class = CXL_QOS_CLASS_INVALID;
>  		cxlds->part[i].mode = part->mode;
> +		cxlds->part[i].handle = part->handle;
>  
>  		/* Require ordered + contiguous partitions */
>  		if (i) {
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 2932bbd67e55..bdb908c6e7f3 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1352,10 +1352,16 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_a
>  {
>  	u64 blk_size = le64_to_cpu(dev_part->block_size);
>  	u64 len = le64_to_cpu(dev_part->length);
> +	u32 handle = le32_to_cpu(dev_part->dsmad_handle);
>  
>  	part_array[index].start = le64_to_cpu(dev_part->base);
>  	part_array[index].size = le64_to_cpu(dev_part->decode_length);
>  	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
> +	if (handle & ~0xFF) {
> +		dev_warn(dev, "DSMAD handle 0x%x has non-zero reserved bits\n", handle);
> +		return -EINVAL;
> +	}
> +	part_array[index].handle = handle;
>  
>  	/* Check partitions are in increasing DPA order */
>  	if (index > 0) {
> @@ -1522,6 +1528,7 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
>  	/* Return 1st partition */
>  	dc_info->start = partitions[0].start;
>  	dc_info->size = partitions[0].size;
> +	dc_info->handle = partitions[0].handle;
>  	dev_dbg(dev, "Returning partition 0 %llu size %llu\n",
>  		dc_info->start, dc_info->size);
>  
> @@ -1529,7 +1536,8 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
>  
> -static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
> +static void add_part(struct cxl_dpa_info *info, u64 start, u64 size,
> +		     enum cxl_partition_mode mode, u8 handle)
>  {
>  	int i = info->nr_partitions;
>  
> @@ -1541,6 +1549,7 @@ static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_pa
>  		.end = start + size - 1,
>  	};
>  	info->part[i].mode = mode;
> +	info->part[i].handle = handle;
>  	info->nr_partitions++;
>  }
>  
> @@ -1558,9 +1567,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
>  	info->size = mds->total_bytes;
>  
>  	if (mds->partition_align_bytes == 0) {
> -		add_part(info, 0, mds->volatile_only_bytes, CXL_PARTMODE_RAM);
> +		add_part(info, 0, mds->volatile_only_bytes, CXL_PARTMODE_RAM, 0);
>  		add_part(info, mds->volatile_only_bytes,
> -			 mds->persistent_only_bytes, CXL_PARTMODE_PMEM);
> +			 mds->persistent_only_bytes, CXL_PARTMODE_PMEM, 0);
>  		return 0;
>  	}
>  
> @@ -1570,9 +1579,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
>  		return rc;
>  	}
>  
> -	add_part(info, 0, mds->active_volatile_bytes, CXL_PARTMODE_RAM);
> +	add_part(info, 0, mds->active_volatile_bytes, CXL_PARTMODE_RAM, 0);
>  	add_part(info, mds->active_volatile_bytes, mds->active_persistent_bytes,
> -		 CXL_PARTMODE_PMEM);
> +		 CXL_PARTMODE_PMEM, 0);
>  
>  	return 0;
>  }
> @@ -1624,7 +1633,8 @@ void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
>  	info->size += dc_info.size;
>  	dev_dbg(dev, "Adding dynamic ram partition 1; %llu size %llu\n",
>  		dc_info.start, dc_info.size);
> -	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1);
> +	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1,
> +		 dc_info.handle);
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
>  
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 6b548a1ec1e9..b29fb16725b4 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -118,6 +118,7 @@ struct cxl_dpa_info {
>  	struct cxl_dpa_part_info {
>  		struct range range;
>  		enum cxl_partition_mode mode;
> +		u8 handle;
>  	} part[CXL_NR_PARTITIONS_MAX];
>  	int nr_partitions;
>  };
> @@ -823,6 +824,7 @@ int cxl_dev_state_identify(struct cxl_memdev_state *mds);
>  struct cxl_dc_partition_info {
>  	u64 start;
>  	u64 size;
> +	u8 handle;
>  };
>  
>  int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> index e8a0899960d4..502d8333318b 100644
> --- a/include/cxl/cxl.h
> +++ b/include/cxl/cxl.h
> @@ -141,11 +141,15 @@ enum cxl_partition_mode {
>   * @res: shortcut to the partition in the DPA resource tree (cxlds->dpa_res)
>   * @perf: performance attributes of the partition from CDAT
>   * @mode: operation mode for the DPA capacity, e.g. ram, pmem, dynamic...
> + * @handle: DSMAS handle intended to represent this partition
> + * @shareable: Is the partition sharable (from its CDAT DSMAS entry)
>   */
>  struct cxl_dpa_partition {
>  	struct resource res;
>  	struct cxl_dpa_perf perf;
>  	enum cxl_partition_mode mode;
> +	u8 handle;
> +	bool shareable;
>  };
>  
>  #define CXL_NR_PARTITIONS_MAX 3

