Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AD3342524
	for <nvdimm@lists.linux.dev>; Mon,  3 Aug 2026 22:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785795082; cv=none; b=uM693ZE+iF7ErKo+ZpXPLsZU89mda4H5AnvJ4tOxjJkTUjUEZOfes7/WQZIrtzXayzHi4xx7lQR6jErYyDPrWb+uZuADgvX71NjxkI2NZ/bzvfSyBSXP5zS/4ydRht5hq8UnskRzdT56tcnFKpqCaViwA/tIKjdayex8+Xk0+jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785795082; c=relaxed/simple;
	bh=FBoAH0ZCA1S8ietaVeEeSeTEN/ysFM//YAiVJUbpvK4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VH/Kyx/6KT1pWoSfmUQ4397sGpJv1akr5cH0USDZ33atK+H6+1iOvNZL7sRgmgijKsCLRbnWgYe4K2cAlVj4IJqcMJhnJpUuDZ5ODzbyuZ9E02QCborBQgRDIl6VFyc4TD3VjUpU+2ZcFpTArSu2aJhkg7P0IZpKXYMIT5mhMtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LbLyn7YV; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LbLyn7YV"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-848479c9bd5so3296957b3a.3
        for <nvdimm@lists.linux.dev>; Mon, 03 Aug 2026 15:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785795076; x=1786399876; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AuiLDm5rCKBltvJDqNeeqpehy/nSuAJx4ktAR745qws=;
        b=LbLyn7YVNMMEjZYwhsuuBriNLJcQYPgfH52Zx/fcIerTswXmMt342edj7kaOYyZRDi
         uENsaMgriim4BNEtUkGDWMHyVaUPzKLbYdKsciTjmL1rC+pAjaWXU8nqPsT8gPo5ihEM
         scmpVKVW5VsI1IIjc5hoGcfIydhTQ0sC6RzEvPUoNz3wpXn/X0/ydxoC6u4o3nRFn5Hf
         VttPeWInqWVEsvDECVrJaIpMdBszw+g34HBSsaw/X+CC1eCFdqwzVenROUWaMcfv3bZ3
         OTK0HugYeQCZ3h7djMEwGAuO80rT7AZAI/qc3ioj5mbWXFxJ8SlpuRETTOe7q7y2WUGh
         qtPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785795076; x=1786399876;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AuiLDm5rCKBltvJDqNeeqpehy/nSuAJx4ktAR745qws=;
        b=HmMkLzeHkWiUgD6qjSBTQPFtisM2KdY6laggaBc9iZr2TKJ7DcNSeOW/RaUE4OkdB5
         Ukltp2+5gzdbaXkuzssoqjWh7rCsu8Nk5kLWOTyD/iW3NT+J8k0C67nMlMOH4gueWzOa
         iP3Y05f7lTnKmNl/F4F3832Z/c749+75r1wXwcAseJN3HrtIx/Fxz3xbWcARjQzRatW5
         6A3ni1V5qEIM4sG3xaaJ8EJtM7mm3bYWrW3Bgs/9zttpY8auhjiNJd+krBRhboS5OYj9
         9+1tlAP5BKRLeVh+fs0CMYCmTtPABKi6ntZ3yq62mLaYA9wi0nKH7PSDC2DzoqU5QS23
         HIUA==
X-Forwarded-Encrypted: i=1; AHgh+Rq5yocDCN9wbxseqQTvg/3q1SdIGIMreew7WYaoZ0JoEBNf/V1l53/7qN6ohgzDQJIcF7I3Qq8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCvmtubtlWdtA3VqR9oXtAKoV20sS2IGu4bLrqybMHdARPzyh/
	/jH/sYPtNnjdGhxlRZqbbTRTthgxM2DoMH0EskxViPiow7+2CpZqsqgt
X-Gm-Gg: AR+sD11aB+C9T3oeGEW95ayMrUP1MMq4uasuJyd+3I+3q+itHObJifTVxUprDZzWDpd
	hM7dAQty9UODBBARj3RzTN59ZOARaw+lrpv2RSqzdksJZRF+L2qaeDc1mvASTAKzRairupgrRNV
	cplLp+gLGZLdWRPtzThkMKRNh2L9JvCBLk16Imc1k6f7njezEgMS2hjV5l8Vld0d1rbYDgImTaz
	mr/BSOOcn5lb/B0FH/sgtGOnVQcEUa8z9WKCHT2AyOaSauCgHw50kCKQdT+Q0+aN/FSqBwEVu/7
	wqPs1pYz6JsLsZ/lLnsTwSW9DiBhoecfS/Aww8c6qPasmIjfluKzSIAsrapEUZmotBN686qQrEx
	eM7u7FP3fqjoNVyLJKsCYga3swo0zG2EpJqrcDQxGJW1xIwCevuA1PA4xWWMJXedwgFQAmWpodj
	QUAxuXWw7JcWp/1mV2+Il0oNYUnEFwGX3o0MZBEO3GptTyujxHxzO2A7Bb1QZV1bhWN3WQnN8GU
	dcO5ofFZflwpk8XfhEk8AY=
X-Received: by 2002:a05:6300:220a:b0:3c6:5770:9a16 with SMTP id adf61e73a8af0-3c92a9a4cf7mr11194006637.75.1785795075942;
        Mon, 03 Aug 2026 15:11:15 -0700 (PDT)
Received: from 4470NRD-ASU.ssi.samsung.com ([172.59.161.130])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fab1334cfsm38650105c88.1.2026.08.03.15.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 15:11:15 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Mon, 3 Aug 2026 15:11:12 -0700
To: Richard Cheng <icheng@nvidia.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>, Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Wonjae Lee <wj28.lee@samsung.com>,
	Junhee Park <jh9934.park@samsung.com>,
	Heesoo Kim <habil.kim@samsung.com>
Subject: Re: [PATCH v12 2/8] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <anESAO-vIDfUVufW@4470NRD-ASU.ssi.samsung.com>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-3-anisa.su@samsung.com>
 <anBkfosW9jKyOIr1@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anBkfosW9jKyOIr1@MWDK4CY14F>

On Mon, Aug 03, 2026 at 10:33:27PM +0800, Richard Cheng wrote:
> On Fri, Jul 31, 2026 at 01:48:07AM +0800, Anisa Su wrote:
> > From: Ira Weiny <iweiny@kernel.org>
> > 
> > Devices which optionally support Dynamic Capacity (DC) are configured
> > via mailbox commands.  CXL r4.0 section 9.13.3 requires the host to issue
> > the Get DC Configuration command in order to properly configure DCDs.
> > Without the Get DC Configuration command DCD can't be supported.
> > 
> > Implement the DC mailbox commands as specified in CXL 4.0 section
> > 8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
> > information.  Disable DCD if an invalid configuration is found.
> > 
> > Linux has no support for more than one dynamic capacity partition.  Read
> > and validate all the partitions but configure only the first partition
> > as 'dynamic ram 1'.  Additional partitions can be added in the future if
> > such a device ever materializes.  Additionally it is anticipated that no
> > skips will be present from the end of the pmem partition.  Check for and
> > disallow this configuration as well.
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Signed-off-by: Ira Weiny <iweiny@kernel.org>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> > Tested-by: Junhee Park <jh9934.park@samsung.com>
> > Tested-by: Heesoo Kim <habil.kim@samsung.com>
> > 
> > ---
> > Changes:
> > 1. mbox.c: bound the Get DC Config request by the negotiated mailbox
> >    payload. Requesting all CXL_MAX_DC_PARTITIONS (8) needs a 328-byte
> >    response, which exceeds a spec-minimum 256-byte mailbox and fails
> >    -E2BIG, disabling DCD. Cap partition_count per call to what the
> >    payload holds and read the rest via the existing start_partition
> >    loop.
> > ---
> >  drivers/cxl/core/hdm.c  |   2 +
> >  drivers/cxl/core/mbox.c | 220 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/cxl/cxlmem.h    |  55 ++++++++++
> >  drivers/cxl/pci.c       |   3 +
> >  include/cxl/cxl.h       |   3 +-
> >  5 files changed, 282 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> > index 0c80b76a5f9b..0ef076c08ed2 100644
> > --- a/drivers/cxl/core/hdm.c
> > +++ b/drivers/cxl/core/hdm.c
> > @@ -446,6 +446,8 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
> >  		return "ram";
> >  	case CXL_PARTMODE_PMEM:
> >  		return "pmem";
> > +	case CXL_PARTMODE_DYNAMIC_RAM_1:
> > +		return "dynamic_ram_1";
> >  	default:
> >  		return "";
> >  	};
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 4790524c32a7..d79019fbd790 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -1352,6 +1352,197 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
> >  	return -EBUSY;
> >  }
> >  
> > +static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_array,
> > +			u8 index, struct cxl_dc_partition *dev_part)
> > +{
> > +	u64 blk_size = le64_to_cpu(dev_part->block_size);
> > +	u64 len = le64_to_cpu(dev_part->length);
> > +
> > +	part_array[index].start = le64_to_cpu(dev_part->base);
> > +	part_array[index].size = le64_to_cpu(dev_part->decode_length);
> > +	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
> > +
> > +	/* Check partitions are in increasing DPA order */
> > +	if (index > 0) {
> > +		struct cxl_dc_partition_info *prev_part = &part_array[index - 1];
> > +
> > +		if ((prev_part->start + prev_part->size) >
> > +		     part_array[index].start) {
> > +			dev_err(dev,
> > +				"DPA ordering violation for DC partition %d and %d\n",
> > +				index - 1, index);
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	if (part_array[index].size == 0 || len == 0 ||
> > +	    part_array[index].size < len || !IS_ALIGNED(len, blk_size)) {
> > +		dev_err(dev, "DC partition %d invalid length; size %llu len %llu blk size %llu\n",
> > +			index, part_array[index].size, len, blk_size);
> > +		return -EINVAL;
> > +	}
> > +
> 
> Hi Anisa,
> 
> I think here , 0s are legal, according to spec CXL 4.0 8.2.10.9.9.1 "Get Dynamic Capacity Configuration",
> Table 8-347 "DC Region Configuration". It says "Report 0 if the region is unavailable for Dynamici Capacity"
> 
> Imagine if we have a device ports 8 regions and only region 0 is configured, regions 1~7 come back with 0s.
> cxl_dc_check() will check them all, so the first zero region fails and cxl_configure_dcd() ends up disabling
> DCD on a device that is perfectly fine.
> 
> Maybe we should skip the all-zero regions instead of rejecting them ?
> 
> Best regards,
> Richard Cheng.
> 
Thank you for taking a look! Here is what the fix looks like:

Helper function above cxl_dc_check to check for all-zeros and return early
in cxl_dc_check() if unavailable:

/*
 * A partition unavailable for Dynamic Capacity reports zeros for decode_length,
 * length, and block_size.
 */
static bool cxl_dc_partition_unavailable(struct cxl_dc_partition *dev_part)
{
	return !le64_to_cpu(dev_part->decode_length) &&
	       !le64_to_cpu(dev_part->length) &&
	       !le64_to_cpu(dev_part->block_size);
}

static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_array,
			u8 index, struct cxl_dc_partition *dev_part)
{
	u64 blk_size = le64_to_cpu(dev_part->block_size);
	u64 len = le64_to_cpu(dev_part->length);
	u32 handle = le32_to_cpu(dev_part->dsmad_handle);

	/*
	 * Not an error; leave the entry empty. A partially zeroed partition
	 * is rejected by the checks below. CXL r4.0 Table 8-347.
	 */
	if (cxl_dc_partition_unavailable(dev_part)) {
		part_array[index] = (struct cxl_dc_partition_info) { };
		dev_dbg(dev, "Partition %d unavailable for DC\n", index);
		return 0;
	}
	
	... Rest of the function unchanged ...
	
}

I only skip if all 3 fields (decode length, length, and block size) are 0, so
these checks in cxl_dc_check() are still here to catch if only a subset of
the 3 fields are 0:

	if (part_array[index].size == 0 || len == 0 ||
	    part_array[index].size < len || !IS_ALIGNED(len, blk_size)) {
		dev_err(dev, "DC partition %d invalid length; size %llu len %llu blk size %llu\n",
			index, part_array[index].size, len, blk_size);
		return -EINVAL;
	}

	if (blk_size == 0 || blk_size % CXL_DCD_BLOCK_LINE_SIZE ||
	    !is_power_of_2(blk_size)) {
		dev_err(dev, "DC partition %d invalid block size %llu\n",
			index, blk_size);
		return -EINVAL;
	}

Let me know if you think that makes sense.

Thanks,
Anisa

> > +	if (blk_size == 0 || blk_size % CXL_DCD_BLOCK_LINE_SIZE ||
> > +	    !is_power_of_2(blk_size)) {
> > +		dev_err(dev, "DC partition %d invalid block size %llu\n",
> > +			index, blk_size);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!IS_ALIGNED(part_array[index].start, SZ_256M) ||
> > +	    !IS_ALIGNED(part_array[index].start, blk_size)) {
> > +		dev_err(dev, "DC partition %d invalid start %llu blk size %llu\n",
> > +			index, part_array[index].start, blk_size);
> > +		return -EINVAL;
> > +	}
> > +
> > +	dev_dbg(dev, "DC partition %d start %llu size %llu blk_size: %llu\n",
> > +		index, part_array[index].start, part_array[index].size,
> > +		blk_size);
> > +
> > +	return 0;
> > +}
> > +
> > +/* Returns the number of partitions in dc_resp or -ERRNO */
> > +static int cxl_get_dc_config(struct cxl_mailbox *mbox, u8 start_partition,
> > +			     u8 partition_count,
> > +			     struct cxl_mbox_get_dc_config_out *dc_resp,
> > +			     size_t dc_resp_size)
> > +{
> > +	struct cxl_mbox_get_dc_config_in get_dc = (struct cxl_mbox_get_dc_config_in) {
> > +		.partition_count = partition_count,
> > +		.start_partition_index = start_partition,
> > +	};
> > +	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
> > +		.opcode = CXL_MBOX_OP_GET_DC_CONFIG,
> > +		.payload_in = &get_dc,
> > +		.size_in = sizeof(get_dc),
> > +		.size_out = dc_resp_size,
> > +		.payload_out = dc_resp,
> > +		.min_out = 8,
> > +	};
> > +	size_t expected_sz;
> > +	int rc;
> > +
> > +	rc = cxl_internal_send_cmd(mbox, &mbox_cmd);
> > +	if (rc < 0)
> > +		return rc;
> > +
> > +	if (dc_resp->partitions_returned > partition_count) {
> > +		dev_err(mbox->host, "Device returned %u partitions, requested %u\n",
> > +			dc_resp->partitions_returned, partition_count);
> > +		return -EIO;
> > +	}
> > +
> > +	/*
> > +	 * The payload carries trailing extent/tag count fields after the
> > +	 * partition array (CXL r4.0 Table 8-179) which the driver ignores, so
> > +	 * the response is at least, not exactly, expected_sz.
> > +	 */
> > +	expected_sz = struct_size(dc_resp, partition,
> > +				  dc_resp->partitions_returned);
> > +
> > +	if (mbox_cmd.size_out < expected_sz) {
> > +		dev_err(mbox->host,
> > +			"Payload size %zu less than expected %zu for %u partitions\n",
> > +			mbox_cmd.size_out,
> > +			expected_sz,
> > +			dc_resp->partitions_returned);
> > +		return -EIO;
> > +	}
> > +
> > +	dev_dbg(mbox->host, "Read %d/%d DC partitions\n",
> > +		dc_resp->partitions_returned, dc_resp->avail_partition_count);
> > +	return dc_resp->partitions_returned;
> > +}
> > +
> > +/**
> > + * cxl_dev_dc_identify() - Reads the dynamic capacity information from the
> > + *                         device.
> > + * @mbox: Mailbox to query
> > + * @dc_info: The dynamic partition information to return
> > + *
> > + * Read Dynamic Capacity information from the device and return the partition
> > + * information.
> > + *
> > + * Return: 0 if identify was executed successfully, -ERRNO on error.
> > + *         on error only dc_info is left unchanged.
> > + */
> > +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> > +			struct cxl_dc_partition_info *dc_info)
> > +{
> > +	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS];
> > +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) = NULL;
> > +	struct device *dev = mbox->host;
> > +	u8 start_partition;
> > +	u8 num_partitions;
> > +	u8 partition_count;
> > +	size_t dc_resp_size;
> > +
> > +	/* Bound requested number of partitions by mailbox payload size */
> > +	partition_count = min_t(size_t, CXL_MAX_DC_PARTITIONS,
> > +				(mbox->payload_size - sizeof(*dc_resp) -
> > +				 sizeof(struct cxl_mbox_get_dc_config_tail)) /
> > +				sizeof(struct cxl_dc_partition));
> > +	dc_resp_size = struct_size(dc_resp, partition, partition_count) +
> > +		       sizeof(struct cxl_mbox_get_dc_config_tail);
> > +
> > +	dc_resp = kmalloc(dc_resp_size, GFP_KERNEL);
> > +	if (!dc_resp)
> > +		return -ENOMEM;
> > +
> > +	/*
> > +	 * Read and check all partition information for validity and potential
> > +	 * debugging; see debug output in cxl_dc_check()
> > +	 */
> > +	start_partition = 0;
> > +	num_partitions = 0;
> > +	do {
> > +		int rc, i, j;
> > +
> > +		rc = cxl_get_dc_config(mbox, start_partition, partition_count,
> > +				       dc_resp, dc_resp_size);
> > +		if (rc < 0) {
> > +			dev_err(dev, "Failed to get DC config: %d\n", rc);
> > +			return rc;
> > +		}
> > +
> > +		if (rc == 0) {
> > +			dev_err(dev,
> > +				"Device reported %u partitions available but returned none at index %u\n",
> > +				dc_resp->avail_partition_count, start_partition);
> > +			return -EIO;
> > +		}
> > +
> > +		num_partitions += rc;
> > +
> > +		if (num_partitions < 1 || num_partitions > CXL_MAX_DC_PARTITIONS) {
> > +			dev_err(dev, "Invalid num of dynamic capacity partitions %d\n",
> > +				num_partitions);
> > +			return -EINVAL;
> > +		}
> > +
> > +		for (i = start_partition, j = 0; i < num_partitions; i++, j++) {
> > +			rc = cxl_dc_check(dev, partitions, i,
> > +					  &dc_resp->partition[j]);
> > +			if (rc)
> > +				return rc;
> > +		}
> > +
> > +		start_partition = num_partitions;
> > +
> > +	} while (num_partitions < dc_resp->avail_partition_count);
> > +
> > +	/* Return 1st partition */
> > +	dc_info->start = partitions[0].start;
> > +	dc_info->size = partitions[0].size;
> > +	dev_dbg(dev, "Returning partition 0 %llu size %llu\n",
> > +		dc_info->start, dc_info->size);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
> > +
> >  static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
> >  {
> >  	int i = info->nr_partitions;
> > @@ -1422,6 +1613,35 @@ int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
> >  }
> >  EXPORT_SYMBOL_NS_GPL(cxl_get_dirty_count, "CXL");
> >  
> > +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> > +{
> > +	struct cxl_dc_partition_info dc_info = { 0 };
> > +	struct device *dev = mds->cxlds.dev;
> > +	int rc;
> > +
> > +	rc = cxl_dev_dc_identify(&mds->cxlds.cxl_mbox, &dc_info);
> > +	if (rc) {
> > +		dev_warn(dev,
> > +			 "Failed to read Dynamic Capacity config: %d\n", rc);
> > +		cxl_disable_dcd(mds);
> > +		return;
> > +	}
> > +
> > +	/* Skips between pmem and the dynamic partition are not supported */
> > +	if (dc_info.start != info->size) {
> > +		dev_warn(dev,
> > +			 "Dynamic Capacity skip from pmem not supported\n");
> > +		cxl_disable_dcd(mds);
> > +		return;
> > +	}
> > +
> > +	info->size += dc_info.size;
> > +	dev_dbg(dev, "Adding dynamic ram partition 1; %llu size %llu\n",
> > +		dc_info.start, dc_info.size);
> > +	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1);
> > +}
> > +EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
> > +
> >  int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds)
> >  {
> >  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index 616eeaeee5b9..a9782939d82b 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -407,6 +407,8 @@ struct cxl_security_state {
> >  	struct kernfs_node *sanitize_node;
> >  };
> >  
> > +#define CXL_MAX_DC_PARTITIONS 8
> > +
> >  static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
> >  {
> >  	/*
> > @@ -691,6 +693,39 @@ struct cxl_mbox_set_shutdown_state_in {
> >  	u8 state;
> >  } __packed;
> >  
> > +/* See CXL r4.0 Table 8-178 get dynamic capacity config Input Payload */
> > +struct cxl_mbox_get_dc_config_in {
> > +	u8 partition_count;
> > +	u8 start_partition_index;
> > +} __packed;
> > +
> > +/* See CXL r4.0 Table 8-179 get dynamic capacity config Output Payload */
> > +struct cxl_mbox_get_dc_config_out {
> > +	u8 avail_partition_count;
> > +	u8 partitions_returned;
> > +	u8 rsvd[6];
> > +	/* See CXL r4.0 Table 8-180 */
> > +	struct cxl_dc_partition {
> > +		__le64 base;
> > +		__le64 decode_length;
> > +		__le64 length;
> > +		__le64 block_size;
> > +		__le32 dsmad_handle;
> > +		u8 flags;
> > +		u8 rsvd[3];
> > +	} __packed partition[] __counted_by(partitions_returned);
> > +	/* Trailing extent/tag count fields unused */
> > +} __packed;
> > +
> > +/* Trailing counts; cannot be a member after the flex array above */
> > +struct cxl_mbox_get_dc_config_tail {
> > +	__le32 num_extents_supported;
> > +	__le32 num_extents_available;
> > +	__le32 num_tags_supported;
> > +	__le32 num_tags_available;
> > +} __packed;
> > +#define CXL_DCD_BLOCK_LINE_SIZE 0x40
> > +
> >  /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
> >  struct cxl_mbox_set_timestamp_in {
> >  	__le64 timestamp;
> > @@ -814,9 +849,18 @@ enum {
> >  int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
> >  			  struct cxl_mbox_cmd *cmd);
> >  int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> > +
> > +struct cxl_dc_partition_info {
> > +	u64 start;
> > +	u64 size;
> > +};
> > +
> > +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> > +			struct cxl_dc_partition_info *dc_info);
> >  int cxl_await_media_ready(struct cxl_dev_state *cxlds);
> >  int cxl_enumerate_cmds(struct cxl_memdev_state *mds);
> >  int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
> > +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
> >  struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
> >  						 u16 dvsec);
> >  void set_exclusive_cxl_commands(struct cxl_memdev_state *mds,
> > @@ -830,6 +874,17 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
> >  			    const uuid_t *uuid, union cxl_event *evt);
> >  int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count);
> >  int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds);
> > +
> > +static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
> > +{
> > +	return mds->dcd_supported;
> > +}
> > +
> > +static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
> > +{
> > +	mds->dcd_supported = false;
> > +}
> > +
> >  int cxl_set_timestamp(struct cxl_memdev_state *mds);
> >  int cxl_poison_state_init(struct cxl_memdev_state *mds);
> >  int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> > diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> > index 267c679b0b3c..9b320a2b6fe0 100644
> > --- a/drivers/cxl/pci.c
> > +++ b/drivers/cxl/pci.c
> > @@ -870,6 +870,9 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >  	if (rc)
> >  		return rc;
> >  
> > +	if (cxl_dcd_supported(mds))
> > +		cxl_configure_dcd(mds, &range_info);
> > +
> >  	rc = cxl_dpa_setup(cxlds, &range_info);
> >  	if (rc)
> >  		return rc;
> > diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> > index 016c74fb747c..87c2bd73df21 100644
> > --- a/include/cxl/cxl.h
> > +++ b/include/cxl/cxl.h
> > @@ -133,6 +133,7 @@ struct cxl_dpa_perf {
> >  enum cxl_partition_mode {
> >  	CXL_PARTMODE_RAM,
> >  	CXL_PARTMODE_PMEM,
> > +	CXL_PARTMODE_DYNAMIC_RAM_1,
> >  };
> >  
> >  /**
> > @@ -147,7 +148,7 @@ struct cxl_dpa_partition {
> >  	enum cxl_partition_mode mode;
> >  };
> >  
> > -#define CXL_NR_PARTITIONS_MAX 2
> > +#define CXL_NR_PARTITIONS_MAX 3
> >  
> >  /**
> >   * struct cxl_dev_state - The driver device state
> > -- 
> > 2.43.0
> > 
> > 
