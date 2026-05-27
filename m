Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC5C12CDA5
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 23:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779923769; cv=none; b=tw56YdmF7ErTR1jss21Ycm0erix6VQUm5aCdSHSNzrszMlc6tGjHkTiOjMbIRJH6idY+Jh3gJ/eSYikREEu6aQeVXf194HlgnhSzlanJOioJxncKBNCxYjZhRuYgQWHIV1p5Kt7Us7dORUs8jLzkRq2at4A7Fo5bPvAsrVWDKqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779923769; c=relaxed/simple;
	bh=YZzlYgb6F5RjO3DNnRTXQ1iyjcoPI1SNn6zEOJ9X09M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=llBSovBTmH9sXukjzOoqHZ0xTkyjpqRBWkdpymA/mj9bKIuEqsX+BFzyPx9aomjvV7rajwhjqyAS3M+fpUNbMqxdjs0ZpeEAh1v/7X7Ann7y69nGnYYupzPLhhBoxTq/uNve1ljTl4e7Okfa+TZLkUHtsWAGHoxxlqBMUI6SOA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mdYPu3gH; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mdYPu3gH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779923767; x=1811459767;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YZzlYgb6F5RjO3DNnRTXQ1iyjcoPI1SNn6zEOJ9X09M=;
  b=mdYPu3gHIIUlofNGts80ZzHd5IxGy6FkRmkrdOv1o04AHuXsC/jZfQlN
   xuOzdvNHIg+JFuV+J//j3xHeTuSQvKWa/eTXL4m2K4HevxEzZXkiQbp0N
   yTmeOPu2ZIbm52rnIWRU27xW+I7K1sIJk+P0hdiGgQ3PUf8VXEsYs/eM6
   yDqQhw2I+Z4mzj9Vh2uwL/Uki4+H4rwQE12RVDAn9OyRllDDZk5hjMFVj
   w8nhBtRXHK+xw93ekK7Pz/aBTku4YHPmkeblM42JkDf8Tjw8xGfB3W8Ne
   HJT4IyIITrzvYgSQJua0mPYVtaR/JC+jYNnqFMs4HZ3zRJYq3C/h/e8g8
   Q==;
X-CSE-ConnectionGUID: Uy1RTDwLQNeqb1yFVoSzrA==
X-CSE-MsgGUID: FlLyQ8jVRCmmQrOHkBGlNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="83344947"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="83344947"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 16:16:07 -0700
X-CSE-ConnectionGUID: NRnung/PSVGI9/lOay7krg==
X-CSE-MsgGUID: SRu8Kl9DShO6kr3GDwj28Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="244202385"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.111.23]) ([10.125.111.23])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 16:16:06 -0700
Message-ID: <700377ba-af02-4a40-b7d1-0b3f28c064c4@intel.com>
Date: Wed, 27 May 2026 16:16:05 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 03/31] cxl/cdat: Gather DSMAS data for DCD partitions
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Ira Weiny <ira.weiny@intel.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <f7800561164a891513a20381378f2ff052d29288.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <f7800561164a891513a20381378f2ff052d29288.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/26 2:42 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Additional DCD partition (AKA region) information is contained in the
> DSMAS CDAT tables, including performance, read only, and shareable
> attributes.
> 
> Match DCD partitions with DSMAS tables and store the meta data.

DCD handle needs to be propogated. 

add_part() needs to copy over the handle
cxl_dpa_setup() also needs to copy the handle


Would be good to get this checked against actual hardware.


> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes:
> [anisa: rebase]
> [jonathan: core/mbox.c: error if there are non-zero reserved bits in DSMAD
> handle in cxl_dc_check]
> ---
>  drivers/cxl/core/cdat.c | 11 +++++++++++
>  drivers/cxl/core/mbox.c |  7 +++++++
>  drivers/cxl/cxlmem.h    |  2 ++
>  include/cxl/cxl.h       |  4 ++++
>  4 files changed, 24 insertions(+)
> 
> diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
> index 5c9f07262513..c5f3d2ebea55 100644
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
> @@ -244,6 +246,7 @@ static void update_perf_entry(struct device *dev, struct dsmas_entry *dent,
>  		dpa_perf->coord[i] = dent->coord[i];
>  		dpa_perf->cdat_coord[i] = dent->cdat_coord[i];
>  	}
> +	dpa_perf->shareable = dent->shareable;
>  	dpa_perf->dpa_range = dent->dpa_range;
>  	dpa_perf->qos_class = dent->qos_class;
>  	dev_dbg(dev,
> @@ -266,13 +269,21 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
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
> +				if (mode == CXL_PARTMODE_DYNAMIC_RAM_A &&
> +				    dent->handle != handle)
> +					dev_warn(dev,
> +						"Dynamic RAM perf mismatch; %pra (%u) vs %pra (%u)\n",
> +						&range, handle, &dent->dpa_range, dent->handle);

Should it 'continue' here since it mismatches?

DJ

> +
>  				update_perf_entry(dev, dent,
>  						  &cxlds->part[i].perf);
>  				found = true;
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 71b29cd6abfe..f9a5e21f5d09 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1356,10 +1356,16 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_a
>  {
>  	size_t blk_size = le64_to_cpu(dev_part->block_size);
>  	size_t len = le64_to_cpu(dev_part->length);
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
> @@ -1494,6 +1500,7 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
>  	/* Return 1st partition */
>  	dc_info->start = partitions[0].start;
>  	dc_info->size = partitions[0].size;
> +	dc_info->handle = partitions[0].handle;
>  	dev_dbg(dev, "Returning partition 0 %zu size %zu\n",
>  		dc_info->start, dc_info->size);
>  
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 87386488ad10..cee936fb3d03 100644
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
> @@ -818,6 +819,7 @@ int cxl_dev_state_identify(struct cxl_memdev_state *mds);
>  struct cxl_dc_partition_info {
>  	size_t start;
>  	size_t size;
> +	u8 handle;
>  };
>  
>  int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> index bb1df0cef863..51685a01d19c 100644
> --- a/include/cxl/cxl.h
> +++ b/include/cxl/cxl.h
> @@ -122,12 +122,14 @@ struct cxl_register_map {
>   * @coord: QoS performance data (i.e. latency, bandwidth)
>   * @cdat_coord: raw QoS performance data from CDAT
>   * @qos_class: QoS Class cookies
> + * @shareable: Is the range sharable
>   */
>  struct cxl_dpa_perf {
>  	struct range dpa_range;
>  	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
>  	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
>  	int qos_class;
> +	bool shareable;
>  };
>  
>  enum cxl_partition_mode {
> @@ -141,11 +143,13 @@ enum cxl_partition_mode {
>   * @res: shortcut to the partition in the DPA resource tree (cxlds->dpa_res)
>   * @perf: performance attributes of the partition from CDAT
>   * @mode: operation mode for the DPA capacity, e.g. ram, pmem, dynamic...
> + * @handle: DSMAS handle intended to represent this partition
>   */
>  struct cxl_dpa_partition {
>  	struct resource res;
>  	struct cxl_dpa_perf perf;
>  	enum cxl_partition_mode mode;
> +	u8 handle;
>  };
>  
>  #define CXL_NR_PARTITIONS_MAX 3

