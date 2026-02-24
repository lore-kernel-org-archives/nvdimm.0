Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD92622D4C8
	for <nvdimm@lists.linux.dev>; Tue, 24 Feb 2026 01:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771896301; cv=none; b=ncALO1fnHFvZQbXQpYfpY7qqOYZOj6A3/yv6IBLpLYq9tHy2Kxmh/Vk3n6facZzFLDzapzTJnknla0/qnvtoBeq0SAMLsNqWisg7XR3NzQtfoDA/y5vBwgvBZStMZn+vdC5cL5Nfq8hu4qEdjFfIeU4ySe7uuXMr0JE8WbZgsvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771896301; c=relaxed/simple;
	bh=0z2rfSg4pMG/AuE2/ek/uTRDR2bwaJaDIuelXJM++V8=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VNxuh0Rr1PVA0J2atfqfOeWDCB1oV/5VejDkwMGyMJbzl17BeCG5/Fxws0TRG7OAXmiiLzroKxu8beOsSkWuRV51FNtlcule3jfZd8HiaCkgXHlKA8ClVzFf+cQO0AYTK1clNz6qSjA6saxGNmJrNPbYHriBeodDAjIU2fR5zgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=APBWJr4a; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="APBWJr4a"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-79854193a54so8392837b3.3
        for <nvdimm@lists.linux.dev>; Mon, 23 Feb 2026 17:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771896299; x=1772501099; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CQGPzu5YPQ91NVYpBm+9/Kt5TZXA4lsSJTx1at22zpE=;
        b=APBWJr4aRpISKCM/J4XE7Pc3AWGXNPQwDnnFx8qem9L/LFUI+1IEleC1/8P3YTKBJf
         voyAcTEVdpQTWR1S2OkXQq/xPWTaKL2ziMjj8sjq6ICNIz+g3qhfB5GM+OimUycdHcSl
         M1ogSdYBCANPpLuKfp/UKgw2qWUPhrmdavVr/QvQSIBnb1AhwSjqRUqgyoqYdE+2+FDj
         b8gyW1QkAnkixKEnTnL92ND0Jf9DH3bUfgW8byenAOjzA4JgmmDHg55yAvm6QZGXHoTw
         X0QGki9+sL1Ynp8cFvPm84UUIi9J+7bGdopdjoVDrt14rx6lcvhipi+y8464z6kUped1
         u7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771896299; x=1772501099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CQGPzu5YPQ91NVYpBm+9/Kt5TZXA4lsSJTx1at22zpE=;
        b=IBAuaoy2aJbXSsk4FYdt2iIpiNx1/YB4Uq2Hrd1FsYwUB9KxgaQkvKQGoPNfaN9YxT
         QL2oukBnGW6xlLL3LNlrJUlzhdLOL4MQmu1Gag7uSvKr8SC41nS0s2t2W+BGARsaFg6l
         lXGPB9NLyA+6iEIWmqKkr4pnzheLFpaPOoqX5kw3WvDYU3UmOJY1iGEAotruOsWQvh/Y
         N5tnOEe8fa/du7DFv9eVADVe2e+roJPmVwWO72fBXpSAbXdyiet09beX41d1j2UAf9v9
         HgM7EznNWhg62GHf0GYN46M0kmXd6nXAd0AJAibGd/eYnglVcVWUH5F1egDGE4c6RfTs
         lpjg==
X-Forwarded-Encrypted: i=1; AJvYcCW03u0tl5Igo6CsQHIbAVBorgvCeceOjXz4rxl9pCFaogHmDIdQJrwnwK3q6766e2T6SJO6rr4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwvqaliLaEjJF38FTckQls9nSzQTHAvTdnQ7hhwBro9B1G5dRhu
	M6wgI0bOy9skRIV7bXNDg+FDYqxHd7oYQvwKwewE5HcC/s51VSkZOtSz
X-Gm-Gg: ATEYQzysscPwGxLMRT8h2rXiE2Oz9hTSXjp7GedpZtJo9pxfcquzv6aw8bMLChlaVCz
	tZB1lIl4Uu7Foy0RyQzvSwC3LeDjWZP2cERDS+4nCirQSZcy/ix1JyYD9qSIIqs9HjMqxYll/uo
	EZxRIgdvf8pbkCp1plX9etz0r2+hn+UnvjTKTJHNtS6Yr7/JmpFu96+wM2xLg1rxz/4lBRoWGMe
	cDGHrnXG08JKe7QD++aqCi8JWvA5oEEl12MjIub4LScUHdtrypTj9GeCUB6+7z+J3syjFRGP0cz
	/4qE68JSnxTWb2Oks+7JR4IM4wBTAzXUJVXq3KP1qTRNh1YhMnuSQA+A9fIqJRqp9QcfgPuzDmm
	RqfVw+SfaAE8j9mIxXApomx6K6g63uAthR65JA6+ObC0Jh4Me+Yocky0fpgu4Cdl45Xv21rthvB
	ojc5gWuR4mK1ba+RZ82BiUCqli4y1AwhHtt9j72WwDm/oiKOAmlYVn
X-Received: by 2002:a05:690c:6086:b0:794:a7d:6bc4 with SMTP id 00721157ae682-7982916dec3mr98603277b3.58.1771896298694;
        Mon, 23 Feb 2026 17:24:58 -0800 (PST)
Received: from 4470NRD-ASU.ssi.samsung.com ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7982dd84394sm38813677b3.30.2026.02.23.17.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 17:24:58 -0800 (PST)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Mon, 23 Feb 2026 17:24:55 -0800
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v9 12/19] cxl/extent: Process dynamic partition events
 and realize region extents
Message-ID: <aZz9qi1b1DsOETa_@4470NRD-ASU.ssi.samsung.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <20250413-dcd-type2-upstream-v9-12-1d4911a0b365@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250413-dcd-type2-upstream-v9-12-1d4911a0b365@intel.com>

On Sun, Apr 13, 2025 at 05:52:20PM -0500, Ira Weiny wrote:i
A few notes while going through and removing sparse dax semantics and plumbing
for fs-dax mode:
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
> any time.
Partial release is no longer valid for tagged release iirc from the calls

> Thus the 'more' bit grouping of release events is of less
> value and can be ignored in favor of sending multiple release capacity
> responses for groups of release events.
> 
[snip]
> +
> +static int cxl_send_dc_response(struct cxl_memdev_state *mds, int opcode,
> +				struct xarray *extent_array, int cnt)
> +{
> +	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> +	struct cxl_mbox_dc_response *p;
> +	struct cxl_extent *extent;
> +	unsigned long index;
> +	u32 pl_index;
> +
> +	size_t pl_size = struct_size(p, extent_list, cnt);
> +	u32 max_extents = cnt;
> +
> +	/* May have to use more bit on response. */
> +	if (pl_size > cxl_mbox->payload_size) {
> +		max_extents = (cxl_mbox->payload_size - sizeof(*p)) /
> +			      sizeof(struct updated_extent_list);
> +		pl_size = struct_size(p, extent_list, max_extents);
> +	}
> +
> +	struct cxl_mbox_dc_response *response __free(kfree) =
> +						kzalloc(pl_size, GFP_KERNEL);
> +	if (!response)
> +		return -ENOMEM;
> +
> +	if (cnt == 0)
> +		return send_one_response(cxl_mbox, response, opcode, 0, 0);
> +
> +	pl_index = 0;
I was wondering why xarray is used here instead of a list? I didn't see anywhere
that we need to look up a specific index to benefit from the log complexity and
afaict, simply used to iterate over all elements.

> +	xa_for_each(extent_array, index, extent) {
> +		response->extent_list[pl_index].dpa_start = extent->start_dpa;
> +		response->extent_list[pl_index].length = extent->length;
> +		pl_index++;
> +
> +		if (pl_index == max_extents) {
> +			u8 flags = 0;
> +			int rc;
> +
> +			if (pl_index < cnt)
> +				flags |= CXL_DCD_EVENT_MORE;
> +			rc = send_one_response(cxl_mbox, response, opcode,
> +					       pl_index, flags);
> +			if (rc)
> +				return rc;
> +			cnt -= pl_index;
> +			pl_index = 0;
> +		}
> +	}
> +
> +	if (!pl_index) /* nothing more to do */
> +		return 0;
> +	return send_one_response(cxl_mbox, response, opcode, pl_index, 0);
> +}
> +
> +void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range)
> +{
> +	struct device *dev = mds->cxlds.dev;
> +	struct xarray extent_list;
> +
> +	struct cxl_extent extent = {
> +		.start_dpa = cpu_to_le64(range->start),
> +		.length = cpu_to_le64(range_len(range)),
> +	};
> +
> +	dev_dbg(dev, "Release response dpa %pra\n", &range);
> +
> +	xa_init(&extent_list);
> +	if (xa_insert(&extent_list, 0, &extent, GFP_KERNEL)) {
> +		dev_dbg(dev, "Failed to release %pra\n", &range);
> +		goto destroy;
> +	}
> +
> +	if (cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC, &extent_list, 1))
> +		dev_dbg(dev, "Failed to release %pra\n", &range);
> +
> +destroy:
> +	xa_destroy(&extent_list);
> +}
> +
> +static int validate_add_extent(struct cxl_memdev_state *mds,
> +			       struct cxl_extent *extent)
> +{
> +	int rc;
> +
> +	rc = cxl_validate_extent(mds, extent);
> +	if (rc)
> +		return rc;
> +
> +	return cxl_add_extent(mds, extent);
> +}
> +
> +static int cxl_add_pending(struct cxl_memdev_state *mds)
> +{
> +	struct device *dev = mds->cxlds.dev;
> +	struct cxl_extent *extent;
> +	unsigned long cnt = 0;
> +	unsigned long index;
> +	int rc;
> +
Also according to the spec:
"In response to an Add Capacity Event Record, or multiple Add Capacity Event 
records grouped via the More flag (see Table 8-229), the host is expected to 
respond with exactly one Add Dynamic Capacity Response acknowledgment, 
corresponding to the order of the Add Capacity Events received. If the order 
does not match, the device shall return Invalid Input. The Add Dynamic Capacity
Response acknowledgment must be sent in the same order as the Add Capacity 
Event Records."

Using xarray does not preserve the order of the extents, which requires a fifo
queue.

> +	xa_for_each(&mds->pending_extents, index, extent) {
> +		if (validate_add_extent(mds, extent)) {
> +			/*
> +			 * Any extents which are to be rejected are omitted from
> +			 * the response.  An empty response means all are
> +			 * rejected.
> +			 */
> +			dev_dbg(dev, "unconsumed DC extent DPA:%#llx LEN:%#llx\n",
> +				le64_to_cpu(extent->start_dpa),
> +				le64_to_cpu(extent->length));
> +			xa_erase(&mds->pending_extents, index);
> +			kfree(extent);
> +			continue;
> +		}
> +		cnt++;
> +	}
> +	rc = cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
> +				  &mds->pending_extents, cnt);
> +	xa_for_each(&mds->pending_extents, index, extent) {
> +		xa_erase(&mds->pending_extents, index);
> +		kfree(extent);
> +	}
> +	return rc;
> +}
> +
[snip]  
Thanks,
Anisa 
