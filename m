Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3312749F7
	for <nvdimm@lists.linux.dev>; Mon, 14 Apr 2025 16:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744647325; cv=none; b=mJ6ISqnxqqmwJtKRViKvRw4qkcqXkvRWMyOMpSQz2a3wRZl8ErveIHRQp1SkT9UNHaPoa/q5v30kAGP556pHYL2DqNf8uSkTMoVPokxfIs8gNx+i+aJg9K02zIfAZAlJuN7x+I9fgs1N77EhfotZc2W150SaAjB/PPsL1VW8RYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744647325; c=relaxed/simple;
	bh=xPSV2jFKY1POy8upqapPFgu16bJi7d1Ky6gqBuT27x4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JH7hguGb8oNZdHzvR03yg9M2yM1fjRNmGrMLtPOKkfdn/B2G4b1rVFVwTLw1Wsmsqii6LZj9nNiPrGX3xc87x3a68vJcu1Xwcflg7ILQyodUO+apmt/jrjEiLngPW6QZLt3LpAEK2Nw6E68WL+S5q3IeULn/FxL7vxdppBFxCig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZbsjR74Myz6M4wt;
	Tue, 15 Apr 2025 00:11:23 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 3AE991402FC;
	Tue, 15 Apr 2025 00:15:20 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 14 Apr
 2025 18:15:19 +0200
Date: Mon, 14 Apr 2025 17:15:18 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Dan
 Williams" <dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 16/19] cxl/region: Read existing extents on region
 creation
Message-ID: <20250414171518.00007580@huawei.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-16-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
	<20250413-dcd-type2-upstream-v9-16-1d4911a0b365@intel.com>
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

On Sun, 13 Apr 2025 17:52:24 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

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

A couple of minor things noticed on taking another look.

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index de01c6684530..8af3a4173b99 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1737,6 +1737,115 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
>  
> +/* Return -EAGAIN if the extent list changes while reading */
> +static int __cxl_process_extent_list(struct cxl_endpoint_decoder *cxled)
> +{
> +	u32 current_index, total_read, total_expected, initial_gen_num;
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

Similar to earlier comment (I might well have forgotten how this works) but
why not 16 which is what I think we should get even if no extents.

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
> +			rc = validate_add_extent(mds, extent);
> +			if (rc)
> +				latched_rc = rc;
> +		}
> +
> +		current_index += nr_returned;
> +	} while (total_expected > total_read);
> +
> +	return latched_rc;
> +}

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

Throw some counted_by magic at this?

> +} __packed;
> +
>  struct cxl_mbox_get_supported_logs {
>  	__le16 entries;
>  	u8 rsvd[6];
> 

