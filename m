Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6431628B4F4
	for <nvdimm@lists.linux.dev>; Mon, 14 Apr 2025 16:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744646908; cv=none; b=pQLgOotyyTx4SnjMcpDilMo4ef9EfvXX63rKf+e3qKCm1T70DgeeF14HGtZ9QTebq6QYYSWcWOuBYRPj4+04htLJJ3SwGObgqITBapCV0PwEel3oGiZG8Mok/Sf4+dbCRgC9ONuGWmHPq/+tNlVG4iJREzdSV/xKgloNBw6EBss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744646908; c=relaxed/simple;
	bh=4tzjbsPIalsIkZI1FaTcEcaA14AfUu0LM+YlbM/mrZA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZYGqqexLusrhY8ptMpiY0ZPX/ReYJkUDr69ErlNVNKHUmVvQuc5pW0oAmtltGe546OCJ6i7aGF0wS3bljGjPFQ7KFYc791hF6ZaGW1wSibBNeUITEcils8T5lDEoh1S3DYB99cBxwfsMv7T7msLu6ICiZQYj2u+RM4owgOgclxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZbsXt0t7tz6M4wC;
	Tue, 15 Apr 2025 00:03:58 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 518631402FC;
	Tue, 15 Apr 2025 00:07:54 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 14 Apr
 2025 18:07:53 +0200
Date: Mon, 14 Apr 2025 17:07:52 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Dan
 Williams" <dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Li Ming
	<ming.li@zohomail.com>
Subject: Re: [PATCH v9 12/19] cxl/extent: Process dynamic partition events
 and realize region extents
Message-ID: <20250414170752.00002356@huawei.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-12-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
	<20250413-dcd-type2-upstream-v9-12-1d4911a0b365@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Sun, 13 Apr 2025 17:52:20 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> A dynamic capacity device (DCD) sends events to signal the host for
> changes in the availability of Dynamic Capacity (DC) memory.  These
> events contain extents describing a DPA range and meta data for memory
> to be added or removed.  Events may be sent from the device at any time.
> 
> Three types of events can be signaled, Add, Release, and Force Release.
> 
> On add, the host may accept or reject the memory being offered.  If no
> region exists, or the extent is invalid, the extent should be rejected.
> Add extent events may be grouped by a 'more' bit which indicates those
> extents should be processed as a group.
> 
> On remove, the host can delay the response until the host is safely not
> using the memory.  If no region exists the release can be sent
> immediately.  The host may also release extents (or partial extents) at
> any time.  Thus the 'more' bit grouping of release events is of less
> value and can be ignored in favor of sending multiple release capacity
> responses for groups of release events.
> 
> Force removal is intended as a mechanism between the FM and the device
> and intended only when the host is unresponsive, out of sync, or
> otherwise broken.  Purposely ignore force removal events.
> 
> Regions are made up of one or more devices which may be surfacing memory
> to the host.  Once all devices in a region have surfaced an extent the
> region can expose a corresponding extent for the user to consume.
> Without interleaving a device extent forms a 1:1 relationship with the
> region extent.  Immediately surface a region extent upon getting a
> device extent.
> 
> Per the specification the device is allowed to offer or remove extents
> at any time.  However, anticipated use cases can expect extents to be
> offered, accepted, and removed in well defined chunks.
> 
> Simplify extent tracking with the following restrictions.
> 
> 	1) Flag for removal any extent which overlaps a requested
> 	   release range.
> 	2) Refuse the offer of extents which overlap already accepted
> 	   memory ranges.
> 	3) Accept again a range which has already been accepted by the
> 	   host.  Eating duplicates serves three purposes.
> 	   3a) This simplifies the code if the device should get out of
> 	       sync with the host.  And it should be safe to acknowledge
> 	       the extent again.
> 	   3b) This simplifies the code to process existing extents if
> 	       the extent list should change while the extent list is
> 	       being read.
> 	   3c) Duplicates for a given partition which are seen during a
> 	       race between the hardware surfacing an extent and the cxl
> 	       dax driver scanning for existing extents will be ignored.
> 
> 	   NOTE: Processing existing extents is done in a later patch.
> 
> Management of the region extent devices must be synchronized with
> potential uses of the memory within the DAX layer.  Create region extent
> devices as children of the cxl_dax_region device such that the DAX
> region driver can co-drive them and synchronize with the DAX layer.
> Synchronization and management is handled in a subsequent patch.
> 
> Tag support within the DAX layer is not yet supported.  To maintain
> compatibility with legacy DAX/region processing only tags with a value
> of 0 are allowed.  This defines existing DAX devices as having a 0 tag
> which makes the most logical sense as a default.
> 
> Process DCD events and create region devices.
> 
> Based on an original patch by Navneet Singh.
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Li Ming <ming.li@zohomail.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
I've forgotten what our policy on spec references in new
code. Maybe update them to 3.2?

A few tiny little things inline from a fresh look.

Thanks,

Jonathan

> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> new file mode 100644
> index 000000000000..6df277caf974
> --- /dev/null
> +++ b/drivers/cxl/core/extent.c

> +static int cxlr_rm_extent(struct device *dev, void *data)
> +{
> +	struct region_extent *region_extent = to_region_extent(dev);
> +	struct range *region_hpa_range = data;
> +
> +	if (!region_extent)
> +		return 0;
> +
> +	/*
> +	 * Any extent which 'touches' the released range is removed.
> +	 */

Single line comment syntax.

> +	if (range_overlaps(region_hpa_range, &region_extent->hpa_range)) {
> +		dev_dbg(dev, "Remove region extent HPA %pra\n",
> +			&region_extent->hpa_range);
> +		region_rm_extent(region_extent);
> +	}
> +	return 0;
> +}


> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index b3dd119d166a..de01c6684530 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -930,6 +930,60 @@ int cxl_enumerate_cmds(struct cxl_memdev_state *mds)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_enumerate_cmds, "CXL");
>  
> +static int cxl_validate_extent(struct cxl_memdev_state *mds,
> +			       struct cxl_extent *extent)
> +{
> +	struct cxl_dev_state *cxlds = &mds->cxlds;
> +	struct device *dev = mds->cxlds.dev;
> +	u64 start, length;
> +
> +	start = le64_to_cpu(extent->start_dpa);
> +	length = le64_to_cpu(extent->length);
Set these at declaration..

> +
> +	struct range ext_range = (struct range){
> +		.start = start,
> +		.end = start + length - 1,
> +	};

With the above set at declaration this is then not declaration
mid code which are still generally looked at in a funny way in kernel!

> +
> +	if (le16_to_cpu(extent->shared_extn_seq) != 0) {
> +		dev_err_ratelimited(dev,
> +				    "DC extent DPA %pra (%pU) can not be shared\n",
> +				    &ext_range, extent->uuid);
> +		return -ENXIO;
> +	}
> +
> +	if (!uuid_is_null((const uuid_t *)extent->uuid)) {
> +		dev_err_ratelimited(dev,
> +				    "DC extent DPA %pra (%pU); tags not supported\n",
> +				    &ext_range, extent->uuid);
> +		return -ENXIO;
> +	}
> +
> +	/* Extents must be within the DC partition boundary */
> +	for (int i = 0; i < cxlds->nr_partitions; i++) {
> +		struct cxl_dpa_partition *part = &cxlds->part[i];
> +
> +		if (part->mode != CXL_PARTMODE_DYNAMIC_RAM_A)
> +			continue;
> +
> +		struct range partition_range = (struct range) {

Maybe move the declaration up and just assign it here.

> +			.start = part->res.start,
> +			.end = part->res.end,
> +		};
> +
> +		if (range_contains(&partition_range, &ext_range)) {
> +			dev_dbg(dev, "DC extent DPA %pra (DCR:%pra)(%pU)\n",
> +				&ext_range, &partition_range, extent->uuid);
> +			return 0;
> +		}
> +	}
> +
> +	dev_err_ratelimited(dev,
> +			    "DC extent DPA %pra (%pU) is not in a valid DC partition\n",
> +			    &ext_range, extent->uuid);
> +	return -ENXIO;
> +}

> +/**
> + * struct cxled_extent - Extent within an endpoint decoder
> + * @cxled: Reference to the endpoint decoder
> + * @dpa_range: DPA range this extent covers within the decoder
> + * @uuid: uuid from device for this extent
> + */
> +struct cxled_extent {
> +	struct cxl_endpoint_decoder *cxled;
> +	struct range dpa_range;
> +	uuid_t uuid;
> +};

> +/* See CXL 3.1 8.2.9.2.1.6 */
> +enum dc_event {
> +	DCD_ADD_CAPACITY,
> +	DCD_RELEASE_CAPACITY,
> +	DCD_FORCED_CAPACITY_RELEASE,
> +	DCD_REGION_CONFIGURATION_UPDATED,

Perhaps a comment here that the other values don't apply to the
normal mailbox interface (they are FM only).
Might avoid confusion.

> +};

> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 34a606c5ead0..63a38e449454 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h

> +/*
> + * Add Dynamic Capacity Response
> + * CXL rev 3.1 section 8.2.9.9.9.3; Table 8-168 & Table 8-169
> + */
> +struct cxl_mbox_dc_response {
> +	__le32 extent_list_size;
> +	u8 flags;
> +	u8 reserved[3];
> +	struct updated_extent_list {
> +		__le64 dpa_start;
> +		__le64 length;
> +		u8 reserved[8];
> +	} __packed extent_list[];

counted_by marking always nice to have and here it's the extent_list_size I think
(which has an odd name giving it is a count, not a size... *dramatic sigh*)


> +} __packed;

