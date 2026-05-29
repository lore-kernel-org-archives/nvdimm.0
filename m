Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FBE348C51
	for <nvdimm@lists.linux.dev>; Fri, 29 May 2026 21:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780090230; cv=none; b=NTyjG+jkcLCVzwRWCYxQsotoSs+y9NEfwWuL7oQliadCcYLcTTkkBDCC5zxQelxQIJSXe5LFSFcpz5QmwklRNWobNHbmUAgzDvU0qaeDPtBLvdRoe8292MzJ8H+uJBQUVmJJxtgGYOgi0tOEZVIwn6DdeTLHIYVMjQWjCsc7yNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780090230; c=relaxed/simple;
	bh=GAXyvxkFtptxImTqBx3mzsd9cByGj0FWvvDoU48gjPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fs51lOUSY05MWopuT2p6O84RRyqxhPibrxLu53ERVrhjzMc4QwEVWhz/0aLWnEbm6k7gZULWgX2NKRvVX9iDOwRccwe1V9SVoS9HMk+PQUNxttP3n9JK/Wk4WdLtgqhcX9aHzYT7EhyNVtDVKqyXTz/q5eXNTQImYmzUmU1BEi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZCTc5wcN; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZCTc5wcN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780090227; x=1811626227;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GAXyvxkFtptxImTqBx3mzsd9cByGj0FWvvDoU48gjPs=;
  b=ZCTc5wcNvq27DQQKpS4x36/jEDP30983/Diok9s3XtoKf0Yxyu/N/gdJ
   4C7cVieuZKphUWCp8MlQJVYkPBfb1GjkVCse+83vw3UPPvp+lKvimQso/
   4rVIHBsOdTmXIGI7fEBzfKOLkeDaCwu+4FqEkR/4/5NIHnN7htnvZoqjn
   yF6Bt85IM4im10GCBfviEBtrDNqX4rkKjw8idfGA6FV+p0F0ZM7ninv5d
   x3s11Ryod8wC4W2AsAPWG3wRCxRUSGcw8w+B+TWwHmjHv1LTLvXp2vKuh
   GXvqO6WOx3I9P/GCTJufdk5JmrcIsCdtWaOe48eDfu4m5Fc3pTEYw6OAy
   Q==;
X-CSE-ConnectionGUID: JkH6EfUXQEGwLRDaURIwGQ==
X-CSE-MsgGUID: jb2HEDYBRsmxwZ4NeLajLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="80801638"
X-IronPort-AV: E=Sophos;i="6.24,176,1774335600"; 
   d="scan'208";a="80801638"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 14:30:22 -0700
X-CSE-ConnectionGUID: F0kvyui0Rq2cdrlYUkwYzA==
X-CSE-MsgGUID: 1OEx2Kd2RPGZySS017hBSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,176,1774335600"; 
   d="scan'208";a="244790221"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.111.151]) ([10.125.111.151])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 14:30:21 -0700
Message-ID: <a737d037-1331-46f4-b5c3-cf819690727d@intel.com>
Date: Fri, 29 May 2026 14:30:20 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 27/31] cxl/region: Read existing extents on region
 creation
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Ira Weiny <ira.weiny@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, Fan Ni <fan.ni@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <ec8d257b53053061d70ca0b30408be116d479a03.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <ec8d257b53053061d70ca0b30408be116d479a03.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/26 2:43 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Dynamic capacity device extents may be left in an accepted state on a
> device due to an unexpected host crash.  In this case it is expected
> that the creation of a new region on top of a DC partition can read
> those extents and surface them for continued use.
> 
> Once all endpoint decoders are part of a region and the region is being
> realized, a read of the 'devices extent list' can reveal these
> previously accepted extents.
> 
> CXL r3.1 specifies the mailbox call Get Dynamic Capacity Extent List for
> this purpose.  The call returns all the extents for all dynamic capacity
> partitions.  If the fabric manager is adding extents to any DCD
> partition, the extent list for the recovered region may change.  In this
> case the query must retry.  Upon retry the query could encounter extents
> which were accepted on a previous list query.  Adding such extents is
> ignored without error because they are entirely within a previous
> accepted extent.  Instead warn on this case to allow for differentiating
> bad devices from this normal condition.
> 
> Latch any errors to be bubbled up to ensure notification to the user
> even if individual errors are rate limited or otherwise ignored.
> 
> The scan for existing extents races with the dax_cxl driver.  This is
> synchronized through the region device lock.  Extents which are found
> after the driver has loaded will surface through the normal notification
> path while extents seen prior to the driver are read during driver load.
> 
> Based on an original patch by Navneet Singh.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Fan Ni <fan.ni@samsung.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  drivers/cxl/core/core.h       |   1 +
>  drivers/cxl/core/mbox.c       | 116 ++++++++++++++++++++++++++++++++++
>  drivers/cxl/core/region_dax.c |  27 ++++++++
>  drivers/cxl/cxlmem.h          |  21 ++++++
>  4 files changed, 165 insertions(+)
> 
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index c28e357c5817..f5b05de5ed83 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -28,6 +28,7 @@ cxled_to_mds(struct cxl_endpoint_decoder *cxled)
>  	return container_of(cxlds, struct cxl_memdev_state, cxlds);
>  }
>  
> +int cxl_process_extent_list(struct cxl_endpoint_decoder *cxled);
>  int cxl_region_invalidate_memregion(struct cxl_region *cxlr);
>  
>  #ifdef CONFIG_CXL_REGION
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 8071c1ed1b36..486110e1c03d 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -2083,6 +2083,122 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
>  
> +/* Return -EAGAIN if the extent list changes while reading */
> +static int __cxl_process_extent_list(struct cxl_endpoint_decoder *cxled)
> +{
> +	u32 current_index, total_read, total_expected, initial_gen_num;

initial_gen_num should be initialized to something invalid?

> +	struct cxl_memdev_state *mds = cxled_to_mds(cxled);
> +	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> +	struct device *dev = mds->cxlds.dev;
> +	struct cxl_mbox_cmd mbox_cmd;
> +	u32 max_extent_count;
> +	int latched_rc = 0;
> +	bool first = true;
> +
> +	struct cxl_mbox_get_extent_out *extents __free(kvfree) =
> +				kvmalloc(cxl_mbox->payload_size, GFP_KERNEL);
> +	if (!extents)
> +		return -ENOMEM;
> +
> +	total_read = 0;
> +	current_index = 0;
> +	total_expected = 0;
> +	max_extent_count = (cxl_mbox->payload_size - sizeof(*extents)) /
> +				sizeof(struct cxl_extent);
> +	do {
> +		u32 nr_returned, current_total, current_gen_num;
> +		struct cxl_mbox_get_extent_in get_extent;
> +		int rc;
> +
> +		get_extent = (struct cxl_mbox_get_extent_in) {
> +			.extent_cnt = cpu_to_le32(max(max_extent_count,
> +						  total_expected - current_index)),

Should be min() here right?

> +			.start_extent_index = cpu_to_le32(current_index),
> +		};
> +
> +		mbox_cmd = (struct cxl_mbox_cmd) {
> +			.opcode = CXL_MBOX_OP_GET_DC_EXTENT_LIST,
> +			.payload_in = &get_extent,
> +			.size_in = sizeof(get_extent),
> +			.size_out = cxl_mbox->payload_size,
> +			.payload_out = extents,
> +			.min_out = 1,
> +		};
> +
> +		rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
> +		if (rc < 0)
> +			return rc;
> +
> +		/* Save initial data */
> +		if (first) {
> +			total_expected = le32_to_cpu(extents->total_extent_count);
> +			initial_gen_num = le32_to_cpu(extents->generation_num);
> +			first = false;
> +		}
> +
> +		nr_returned = le32_to_cpu(extents->returned_extent_count);
> +		total_read += nr_returned;
> +		current_total = le32_to_cpu(extents->total_extent_count);
> +		current_gen_num = le32_to_cpu(extents->generation_num);
> +
> +		dev_dbg(dev, "Got extent list %d-%d of %d generation Num:%d\n",
> +			current_index, total_read - 1, current_total, current_gen_num);
> +
> +		if (current_gen_num != initial_gen_num || total_expected != current_total) {
> +			dev_warn(dev, "Extent list change detected; gen %u != %u : cnt %u != %u\n",
> +				 current_gen_num, initial_gen_num,
> +				 total_expected, current_total);
> +			return -EAGAIN;
> +		}
> +
> +		for (int i = 0; i < nr_returned ; i++) {
> +			struct cxl_extent *extent = &extents->extent[i];
> +
> +			dev_dbg(dev, "Processing extent %d/%d\n",
> +				current_index + i, total_expected);
> +

Should probably hold the mds->add_ctx->lock before calling add_to_pending_list()? handle_add_event() holds the lock before calling. Maybe also add a lock assert in add_to_pending_list().

> +			rc = add_to_pending_list(&mds->add_ctx.pending_extents,
> +						 extent);
> +			if (rc) {
> +				latched_rc = rc;

Is the intention here to report the last found error and not the first error?

> +			}

{} not needed if single line

> +		}
> +
> +		current_index += nr_returned;
> +	} while (total_expected > total_read);
> +
> +	if (!latched_rc && !list_empty(&mds->add_ctx.pending_extents)) {
> +		latched_rc = cxl_add_pending(mds);
> +	}
> +	clear_pending_extents(mds);
> +
> +	return latched_rc;
> +}
> +
> +#define CXL_READ_EXTENT_LIST_RETRY 10
> +
> +/**
> + * cxl_process_extent_list() - Read existing extents
> + * @cxled: Endpoint decoder which is part of a region
> + *
> + * Issue the Get Dynamic Capacity Extent List command to the device
> + * and add existing extents if found.
> + *
> + * A retry of 10 is somewhat arbitrary, however, extent changes should be
> + * relatively rare while bringing up a region.  So 10 should be plenty.
> + */
> +int cxl_process_extent_list(struct cxl_endpoint_decoder *cxled)
> +{
> +	int retry = CXL_READ_EXTENT_LIST_RETRY;
> +	int rc;
> +
> +	do {
> +		rc = __cxl_process_extent_list(cxled);
> +	} while (rc == -EAGAIN && retry--);

I think it's retrying 11 times here.

> +
> +	return rc;
> +}
> +
>  static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
>  {
>  	int i = info->nr_partitions;
> diff --git a/drivers/cxl/core/region_dax.c b/drivers/cxl/core/region_dax.c
> index 519e203c486a..e7a812e8b2e7 100644
> --- a/drivers/cxl/core/region_dax.c
> +++ b/drivers/cxl/core/region_dax.c
> @@ -82,6 +82,26 @@ static void cxlr_dax_unregister(void *_cxlr_dax)
>  	device_unregister(&cxlr_dax->dev);
>  }
>  
> +static int cxlr_add_existing_extents(struct cxl_region *cxlr)
> +{
> +	struct cxl_region_params *p = &cxlr->params;
> +	int i, latched_rc = 0;
> +
> +	for (i = 0; i < p->nr_targets; i++) {
> +		struct device *dev = &p->targets[i]->cxld.dev;
> +		int rc;
> +
> +		rc = cxl_process_extent_list(p->targets[i]);
> +		if (rc) {
> +			dev_err(dev, "Existing extent processing failed %d\n",
> +				rc);
> +			latched_rc = rc;
> +		}
> +	}
> +
> +	return latched_rc;
> +}
> +
>  int devm_cxl_add_dax_region(struct cxl_region *cxlr)
>  {
>  	struct device *dev;
> @@ -110,6 +130,13 @@ int devm_cxl_add_dax_region(struct cxl_region *cxlr)
>  	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
>  		dev_name(dev));
>  
> +	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A) {
> +		rc = cxlr_add_existing_extents(cxlr);

cxlr_add_existing_extents() -> cxl_process_extent_list() -> __cxl_process_extent_list() -> cxl_add_pending() -> CXL_MBOX_OP_ADD_DC_RESPONSE sent.

CXL r4.0 8.2.10.9.9.3:
Device shall report Invalid Physical Address if:
One or more extents in the updated extent list specify a DPA range that has already been added with a previous call to the Add Dynamic Capacity Response.

Aren't existing extents already been added previously and responded by ADD_DC_RESPONSE? For add existing extent path it seems like no response is needed to send to the device and can be skipped. Otherwise the software will receive error from the device when sending ADD_DC_RESPONSE.

Would be good to get this tested on hw.


> +		if (rc)
> +			dev_err(&cxlr->dev,
> +				"Existing extent processing failed %d\n", rc);

No return on error?

DJ

> +	}
> +
>  	return devm_add_action_or_reset(&cxlr->dev, cxlr_dax_unregister,
>  					no_free_ptr(cxlr_dax));
>  }
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index d992cc9b7811..1ad3dc7e413c 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -564,6 +564,27 @@ struct cxl_mbox_dc_response {
>  	} __packed extent_list[] __counted_by(extent_list_size);
>  } __packed;
>  
> +/*
> + * Get Dynamic Capacity Extent List; Input Payload
> + * CXL rev 3.1 section 8.2.9.9.9.2; Table 8-166
> + */
> +struct cxl_mbox_get_extent_in {
> +	__le32 extent_cnt;
> +	__le32 start_extent_index;
> +} __packed;
> +
> +/*
> + * Get Dynamic Capacity Extent List; Output Payload
> + * CXL rev 3.1 section 8.2.9.9.9.2; Table 8-167
> + */
> +struct cxl_mbox_get_extent_out {
> +	__le32 returned_extent_count;
> +	__le32 total_extent_count;
> +	__le32 generation_num;
> +	u8 rsvd[4];
> +	struct cxl_extent extent[];
> +} __packed;
> +
>  struct cxl_mbox_get_supported_logs {
>  	__le16 entries;
>  	u8 rsvd[6];

