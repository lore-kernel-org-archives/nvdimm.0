Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AADB188934
	for <nvdimm@lists.linux.dev>; Thu,  5 Sep 2024 19:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725564956; cv=none; b=tZNo3gAzB8I1MRDURCuDrHRDEFwLvVeKRn6PumAi0b3A0o/lkU37hS1hksIo+UGtveU6ID3drA9edDvbn6tHRTpVC7XiPvc4vCq3o5JEBkLFBY8ShbMMbYfO9vazg++lMfmd/wLYZoXUnq3tET+9yPJJKSqcLz5o/dxmto4vK9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725564956; c=relaxed/simple;
	bh=hg1VB48bR/JeQnIfHqGN6DhLpJiuFJBNnlWbbVb1B7U=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ff2YJo6V7JCTzvXag96VvdaRbb2/2vjUFB7l1ifmGvOARof4Mr3rcAlklHfsHZEqcEC5ArvRWoa2wZGN0aQMStTCPu9gXPNG8ye4XCBMK1G959HPF0Yc0rIleiP0CaejudsgTTWo08YOO5P+MPZMN+mkEpVf2mezRNKiTd8qYSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RKLL68Gs; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RKLL68Gs"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-71788bfe60eso1008205b3a.1
        for <nvdimm@lists.linux.dev>; Thu, 05 Sep 2024 12:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725564954; x=1726169754; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ldUcJ/O505YBHpEtE4Y4MG2TZNU+VkuexkFLNr7L7Ng=;
        b=RKLL68GsxaDjk1swmXEwrNmrG3g81CxWh1lmYHHxbUIIgqMdDz+W4tVoUhhqt4QJDh
         eXPeqzzhef1X1z8e2PXubamZ4xZgQFDYwZSfPn9/NdOGEVa99XJK6Bt4rWkGyh5Elv9Q
         4r5E6bnX/YQi9Tagp5bPomlgmNeql2HG3du3940Ne5MLqxU3ovtaWN5C33Z/gvqDrmgd
         BM+HLNsUyfqlM850fzxJ4UIpAPplA4GzA2ampNZyHBrovQkw4xwz0F7D+bGpVqkvLR/C
         d01VQq/K4fk7VKcneqQKgUB85dnpgIlyY1VQKWmt/8KD2xaaIXgox45bfi72jaX3IUJl
         rHHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725564954; x=1726169754;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ldUcJ/O505YBHpEtE4Y4MG2TZNU+VkuexkFLNr7L7Ng=;
        b=JVSi7BLLn4pblTZtMBOf3ZDMPZCw69PnM5yFKcOYtuL+HPwdyHyM8VHz+ETvMX0HlS
         Jv8JDicmuHMt0vWNb2K43S5TYHGM76D6+wQ0K55TRX+pqyAoQBh1XTFu/t/MuLm7FNmh
         xH55UbkLIrV7jQ03RV8cCfPvGwAuVOo1ddPUzE034FUvhk0ljHp0vJv2TPu/1j2CkKgQ
         OfxZevfkHpMtBiZQXIW8+vqquYEuyGeF58a6fXfo+mDFOa6BwOC+Lo4xf55MahSskR7K
         BcWvco1+2iUDVjW99xdLSfd6esTucjxORqKSSGbj2bq0t2GIr9BE1LIUhbdph6Chv00d
         O3vQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOEgQQ1QRrbvX0lNulbVkG31uacnYllL6rFFyXcL7gYB2z+1HDjL6x9tYjK1PVLIZVTFUYY/U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxzGQBjydKW1kYR2NgcKxN+NtK5Xek2XCguSe0MnKR10nmIvPGc
	ADLRBcpMWM0tt4zZJ+YVJAHPTdPUr2LVkxeh+gthCe67WXJ/Yx8Q
X-Google-Smtp-Source: AGHT+IHZ1IEMG5FS4rIqy20GfOj9Vmd9lMPZ3MIwCONUTpNQojCB7EQk4p3T12mTbcpvPU1WvTo9hw==
X-Received: by 2002:a05:6a00:23d2:b0:714:2620:d235 with SMTP id d2e1a72fcca58-718d5e997c2mr255727b3a.16.1725564954136;
        Thu, 05 Sep 2024 12:35:54 -0700 (PDT)
Received: from leg ([2601:646:8f03:9fee:1d73:7db5:2b4a:dfdd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71778521165sm3555838b3a.20.2024.09.05.12.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 12:35:53 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 5 Sep 2024 12:35:50 -0700
To: ira.weiny@intel.com
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 22/25] cxl/region: Read existing extents on region
 creation
Message-ID: <ZtoIFjI9gXp3l9OO@leg>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
 <20240816-dcd-type2-upstream-v3-22-7c9b96cba6d7@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240816-dcd-type2-upstream-v3-22-7c9b96cba6d7@intel.com>

On Fri, Aug 16, 2024 at 09:44:30AM -0500, ira.weiny@intel.com wrote:
> From: Navneet Singh <navneet.singh@intel.com>
> 
> Dynamic capacity device extents may be left in an accepted state on a
> device due to an unexpected host crash.  In this case it is expected
> that the creation of a new region on top of a DC partition can read
> those extents and surface them for continued use.
> 
> Once all endpoint decoders are part of a region and the region is being
> realized a read of the devices extent list can reveal these previously
> accepted extents.
> 
> CXL r3.1 specifies the mailbox call Get Dynamic Capacity Extent List for
> this purpose.  The call returns all the extents for all dynamic capacity
> partitions.  If the fabric manager is adding extents to any DCD
> partition, the extent list for the recovered region may change.  In this
> case the query must retry.  Upon retry the query could encounter extents
> which were accepted on a previous list query.  Adding such extents is
> ignored without error because they are entirely within a previous
> accepted extent.
> 
> The scan for existing extents races with the dax_cxl driver.  This is
> synchronized through the region device lock.  Extents which are found
> after the driver has loaded will surface through the normal notification
> path while extents seen prior to the driver are read during driver load.
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

With the minor things fixed mentioned by Jonathan and Dave,

Reviewed-by: Fan Ni <fan.ni@samsung.com>

> 
> ---
> Changes:
> [iweiny: Leverage the new add path from the event processing code such
> 	 that the adding and surfacing of extents flows through the same
> 	 code path for both event processing and existing extents.
> 	 While this does validate existing extents again on start up
> 	 this is an error recovery case / new boot scenario and should
> 	 not cause any major issues while making the code more
> 	 straight forward and maintainable.]
> 
> [iweiny: use %par]
> [iweiny: rebase]
> [iweiny: Move this patch later in the series such that the realization
>          of extents can go through the same path as an add event]
> [Fan: Issue a retry if the gen number changes]
> [djiang: s/uint64_t/u64/]
> [djiang: update function names]
> [Jørgen/djbw: read the generation and total count on first iteration of
>               the Get Extent List call]
> [djbw: s/cxl_mbox_get_dc_extent_in/cxl_mbox_get_extent_in/]
> [djbw: s/cxl_mbox_get_dc_extent_out/cxl_mbox_get_extent_out/]
> [djbw/iweiny: s/cxl_read_dc_extents/cxl_read_extent_list]
> ---
>  drivers/cxl/core/core.h   |   2 +
>  drivers/cxl/core/mbox.c   | 100 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/core/region.c |  12 ++++++
>  drivers/cxl/cxlmem.h      |  21 ++++++++++
>  4 files changed, 135 insertions(+)
> 
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 8dfc97b2e0a4..9e54064a6f48 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -21,6 +21,8 @@ cxled_to_mds(struct cxl_endpoint_decoder *cxled)
>  	return container_of(cxlds, struct cxl_memdev_state, cxlds);
>  }
>  
> +void cxl_read_extent_list(struct cxl_endpoint_decoder *cxled);
> +
>  #ifdef CONFIG_CXL_REGION
>  extern struct device_attribute dev_attr_create_pmem_region;
>  extern struct device_attribute dev_attr_create_ram_region;
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index f629ad7488ac..d43ac8eabf56 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1670,6 +1670,106 @@ int cxl_dev_dynamic_capacity_identify(struct cxl_memdev_state *mds)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_dev_dynamic_capacity_identify, CXL);
>  
> +/* Return -EAGAIN if the extent list changes while reading */
> +static int __cxl_read_extent_list(struct cxl_endpoint_decoder *cxled)
> +{
> +	u32 current_index, total_read, total_expected, initial_gen_num;
> +	struct cxl_memdev_state *mds = cxled_to_mds(cxled);
> +	struct device *dev = mds->cxlds.dev;
> +	struct cxl_mbox_cmd mbox_cmd;
> +	u32 max_extent_count;
> +	bool first = true;
> +
> +	struct cxl_mbox_get_extent_out *extents __free(kfree) =
> +				kvmalloc(mds->payload_size, GFP_KERNEL);
> +	if (!extents)
> +		return -ENOMEM;
> +
> +	total_read = 0;
> +	current_index = 0;
> +	total_expected = 0;
> +	max_extent_count = (mds->payload_size - sizeof(*extents)) /
> +				sizeof(struct cxl_extent);
> +	do {
> +		struct cxl_mbox_get_extent_in get_extent;
> +		u32 nr_returned, current_total, current_gen_num;
> +		int rc;
> +
> +		get_extent = (struct cxl_mbox_get_extent_in) {
> +			.extent_cnt = max(max_extent_count,
> +					  total_expected - current_index),
> +			.start_extent_index = cpu_to_le32(current_index),
> +		};
> +
> +		mbox_cmd = (struct cxl_mbox_cmd) {
> +			.opcode = CXL_MBOX_OP_GET_DC_EXTENT_LIST,
> +			.payload_in = &get_extent,
> +			.size_in = sizeof(get_extent),
> +			.size_out = mds->payload_size,
> +			.payload_out = extents,
> +			.min_out = 1,
> +		};
> +
> +		rc = cxl_internal_send_cmd(mds, &mbox_cmd);
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
> +			dev_dbg(dev, "Extent list change detected; gen %u != %u : cnt %u != %u\n",
> +				current_gen_num, initial_gen_num,
> +				total_expected, current_total);
> +			return -EAGAIN;
> +		}
> +
> +		for (int i = 0; i < nr_returned ; i++) {
> +			struct cxl_extent *extent = &extents->extent[i];
> +
> +			dev_dbg(dev, "Processing extent %d/%d\n",
> +				current_index + i, total_expected);
> +
> +			rc = validate_add_extent(mds, extent);
> +			if (rc)
> +				continue;
> +		}
> +
> +		current_index += nr_returned;
> +	} while (total_expected > total_read);
> +
> +	return 0;
> +}
> +
> +/**
> + * cxl_read_extent_list() - Read existing extents
> + * @cxled: Endpoint decoder which is part of a region
> + *
> + * Issue the Get Dynamic Capacity Extent List command to the device
> + * and add existing extents if found.
> + */
> +void cxl_read_extent_list(struct cxl_endpoint_decoder *cxled)
> +{
> +	int retry = 10;
> +	int rc;
> +
> +	do {
> +		rc = __cxl_read_extent_list(cxled);
> +	} while (rc == -EAGAIN && retry--);
> +}
> +
>  static int add_dpa_res(struct device *dev, struct resource *parent,
>  		       struct resource *res, resource_size_t start,
>  		       resource_size_t size, const char *type)
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 8c9171f914fb..885fb3004784 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -3190,6 +3190,15 @@ static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
>  	return rc;
>  }
>  
> +static void cxlr_add_existing_extents(struct cxl_region *cxlr)
> +{
> +	struct cxl_region_params *p = &cxlr->params;
> +	int i;
> +
> +	for (i = 0; i < p->nr_targets; i++)
> +		cxl_read_extent_list(p->targets[i]);
> +}
> +
>  static void cxlr_dax_unregister(void *_cxlr_dax)
>  {
>  	struct cxl_dax_region *cxlr_dax = _cxlr_dax;
> @@ -3227,6 +3236,9 @@ static int devm_cxl_add_dax_region(struct cxl_region *cxlr)
>  	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
>  		dev_name(dev));
>  
> +	if (cxlr->mode == CXL_REGION_DC)
> +		cxlr_add_existing_extents(cxlr);
> +
>  	return devm_add_action_or_reset(&cxlr->dev, cxlr_dax_unregister,
>  					cxlr_dax);
>  err:
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 3a40fe1f0be7..11c03637488d 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -624,6 +624,27 @@ struct cxl_mbox_dc_response {
>  	} __packed extent_list[];
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
> 
> -- 
> 2.45.2
> 
