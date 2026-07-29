Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD1C3AFCEE
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 08:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785314094; cv=none; b=SgtQktNnYvEjkaFeQ40Oi0Uprf3XuOksplgsLExHCax2XG4J0uFNKkSU5fLC2daPL095zNRGRhtCwnRLXryrXBi8Oryu87x24ICfw/P5k6SAyxei1WwiIOTenIyww4mGX9vYtI/NidQBr4E04Q72Oy4s03NfBZSOEXxPv9ovf9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785314094; c=relaxed/simple;
	bh=VBWe4z6lpdhgWWhgi9ZL4hf+LSw7oDXHex0pW15bWNM=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nf5bfQPR190Dfh0NZJpe1R8SGAcjFvHN5Ca9K0H/+qM/gTHLFRr+WA10FztO+UYssqjvieZ6O0NEq92w+5bUoMBxrwsKtEMKai8yJEu5oxJuo/4MHwxFVRHxpxLxx++lGGJR4jysnUTfDKk9vSygR+XloDSRR9bw5JE4BsAHF5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gmYunmGf; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gmYunmGf"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2caced6038eso8279025ad.0
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 01:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785314082; x=1785918882; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=y8VVG7c5rynDfSnOxDa5w1W+bUds2tSk8XMQSsCkTs4=;
        b=gmYunmGfthxJ+xY7MM7gn1KmqGxCdTeJQ3H0icBCtUVLwFncoJj0tQZyjCIdxwAID6
         XQrmihHTn2a2wJ0wqpjHvuzNIyoaMcbFAFN7BpxNZ7bDaIISKlAURBEvIXE6Zkkh1/UC
         Z2HUAGPOf88c+6gqpc+LXLsgSU5G5IESGeD+tz74M8tpF4aJ3wGSLXZ40o3BcesQXh11
         sUr9Q/UCERcIqDLi4aL5aKYDM4POES0EfAnQrLHzbXcyXtowuBBXAZn/tylLVugqNqmf
         vwrosydmgMsVO5oOsCSoJodQHIsn7JRC8QjT9bnJWpKF7T/0DNUBK5bMCUTYuIwq+cTk
         aiHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785314082; x=1785918882;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=y8VVG7c5rynDfSnOxDa5w1W+bUds2tSk8XMQSsCkTs4=;
        b=gT5OZYGVUsQXPLMk4idAf7gr+CKEp0oilWeEhrBMgkFwjRQTl4sPAgWiGzsIGJ8bHO
         I4lLXdySWr98VR7Weoybcj46a6Qvap8uiJd8rCmWiUqxDH08nWl/9lFIf4K5JKane1B7
         O0XxbY3uXJLoBq0EjTQLfEKw9CFAoRYk6KxWutMr9Sr3XNgqPTmcBb3BMan+OhJ6J+6Z
         0tQDMQWWx3+twNxce+gjz6aRDGGL84RkxL+lgTKvQwdqexWSlP/RNH4lO0+n7jHZOPXY
         xFpHKzePzUKYJ62ZuU/vzNBTuafIB3hwye06YW7pfCpABb+L5dnvTlki4ZHgCQbwzLod
         01JQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpx75ml5Lf9iQ8YWdbdNjPu/RmDNr8O2FkzPwQe8QLInND0T+EcXbmOJA9D2lCO9Gef5T+Z86k=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZjuNq5S4B+CY9+WZeAaTZCkL471y5IsF6nemXUTdc2vBRduOy
	eCKDrR8gsxYitjDVWAI2MtA6Vu6NZ93o+q8vknc0dnl7qp87NjOGKPgH
X-Gm-Gg: AR+sD11miMLkzbLJeE3rdnUQtJkrPNMXdsswheTEvAMHzEqauYCGQgGEQ4VPfKQjq2L
	Pd0rKFO00st7x9OrwWkdt7KSvKwqTuhe3Rmc2PT7PS7L5WIFuEBTGOwGVvNuw3mMJxaXs07AOWR
	5DfXKHvaGCdUF3H5Z5nUsKAMX71Q0tWr6uyR37Yw3vgC/3TPp5V6cWwzFddxf27qlRUz8SsRxiU
	Q1PIvkh1aeiIadYyHz6TSzTaQle9XMk7pbWOxbuDIhpnCVr1CJSEs7pEEr+nS/DvusfbBk5BOHt
	f5j8W+TH7MvCeKYQNH08Rc3lZ4lJ5G5NonRJyhXKwC5TLiaTFLNxlf53tnZCtKu8Z8Z8d4GX/zw
	n4K/Ie1ZcQLkc6zz/51yeeEednpaWkgn23r9QRyK6GJSfR0xNWaMBHc0ol8JHaiVLFaSw6eTkld
	JnSnseyDIxeMaZvYQOvSgfEYdY0LrzNfbolkeA+9u6GHz57oERr/w4KsNOX06ZXZvhU190HrKzZ
	sx9vsWJvNYivijTBnAhgpqw08C1xEkApxa1vkkx+oDC
X-Received: by 2002:a17:903:2c04:b0:2ca:12aa:a390 with SMTP id d9443c01a7336-2d02625525dmr14066595ad.0.1785314081788;
        Wed, 29 Jul 2026 01:34:41 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022bf888csm7779935ad.64.2026.07.29.01.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 01:34:41 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 29 Jul 2026 01:34:40 -0700
To: sashiko-reviews@lists.linux.dev
Cc: Anisa Su <anisa.su887@gmail.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v11 16/31] cxl/extent: Validate DC extent partition
Message-ID: <amm7IJgMdlMpb7dd@AnisaLaptop.localdomain>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-17-anisa.su@samsung.com>
 <20260625182052.07E301F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260625182052.07E301F000E9@smtp.kernel.org>

On Thu, Jun 25, 2026 at 06:20:51PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Entirely duplicate tag groups are rejected and dropped instead of replying success to the device.
True but benign. And also unlikely. Even if an entirely duplicate tag
group is ommitted from the DC add response, since the capacity was
previously added, it's still provisioned to the host until a release
event.

> - [High] Concurrent access to `group->nr_extents` without locks causes a memory leak and pins the DAX region device indefinitely.
False Positive.

> --
> 
> commit b3bfb6df5d2f0f0f9e2b022064279f74742afa2e
> Author: Ira Weiny <iweiny@kernel.org>
> 
> cxl/extent: Validate DC extent partition
>     
> Extend cxl_validate_extent() — the per-extent check of the add pipeline
> to check partition membership. Resolves an extent's DPA to its containing
> DC partition. Sharability is a property of the partition (part->shareable),
> taken from its CDAT DSMAS entry.
> 
> > diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> > index 6e67e787d14de..2e770c5279c23 100644
> > --- a/drivers/cxl/core/extent.c
> > +++ b/drivers/cxl/core/extent.c
> 
> [ ... ]
> 
> > @@ -101,6 +159,27 @@ static int cxl_validate_extent(struct cxl_memdev_state *mds,
> >  		.end = start_dpa + le64_to_cpu(extent->length) - 1,
> >  	};
> >  	struct range ed_range;
> > +	uuid_t uuid;
> > +
> > +	import_uuid(&uuid, extent->uuid);
> > +
> > +	part = cxl_extent_dc_partition(mds, extent, &ext_range);
> > +	if (!part)
> > +		return -ENXIO;
> > +
> > +	if (part->shareable) {
> > +		if (uuid_is_null(&uuid)) {
> > +			dev_err_ratelimited(dev,
> > +				"DC extent DPA %pra: sharable-partition extent has null tag (firmware bug)\n",
> > +				&ext_range);
> > +			return -ENXIO;
> > +		}
> > +	} else if (le16_to_cpu(extent->shared_extn_seq)) {
> > +		dev_err_ratelimited(dev,
> > +			"DC extent DPA %pra (%pU): non-sharable partition but shared_extn_seq=%u (firmware bug)\n",
> > +			&ext_range, &uuid, le16_to_cpu(extent->shared_extn_seq));
> > +		return -ENXIO;
> > +	}
> >  
> >  	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
> >  	if (!cxlr || !cxlr->cxlr_dax)
> 
> [Severity: High]
> This is a pre-existing issue, but I noticed a potential race condition in
> drivers/cxl/core/extent.c:dc_extent_release() that might lead to a leak:
> 
> 	group->nr_extents--;
> 	if (!group->nr_extents)
> 		free_tag_group(group);
> 
> Could concurrent access to group->nr_extents without locks cause a lost
> decrement?
> 
A tag group's extents are never concurrently torn down.

> When userspace closes sysfs files for multiple extents of the same tag group
> concurrently, their kobject refcounts can drop to 0 simultaneously, causing
> dc_extent_release() to run on multiple CPUs in parallel.
>
??? An open sysfs fd does not pin the device's kobject, and closing it
does not trigger the device's release. sysfs files are backed by kernfs,
and kernfs uses active references that are taken only for the duration
of an individual read/write, then dropped — not held across an idle open
fd. The device's own kref comes from device_add() and is dropped by
device_del()/put_device() in the driver-core teardown path, not by
userspace opening or closing sysfs files.


> If group->nr_extents never reaches 0, does this permanently pin the DAX
> region device (since the reference isn't dropped) and leak the
> cxl_dc_tag_group structure?
> 

Well that never happens because there is no lost decrement race.

> [Severity: High]
> This isn't a bug introduced by this patch, but I have a question about how
> duplicate tag groups are handled between drivers/cxl/core/extent.c and
> drivers/cxl/core/mbox.c.
> 
> In drivers/cxl/core/extent.c:cxl_add_extent(), duplicate extents return 0
> without allocating or assigning mds->add_ctx.group:
> 
> 	case CXL_EXT_DUPLICATE:
> 		/*
> 		 * Idempotent accept simplifies the dax-side scan for existing
> 		 * extents on region creation; reply success without duplicating.
> 		 */
> 		dev_warn_ratelimited(&cxled->cxld.dev,
> 				     "Extent %pra exists; accept again\n",
> 				     &ext_range);
> 		return 0;
> 
> If all extents in a group are duplicates, cxl_realize_group() in
> drivers/cxl/core/mbox.c finishes its loop with group_cnt > 0 but
> mds->add_ctx.group remains NULL. It then returns -ENXIO:
> 
> 	tag_group = mds->add_ctx.group;
> 	mds->add_ctx.group = NULL;
> 	if (!tag_group)
> 		return -ENXIO;
> 
> Since this causes the caller cxl_add_pending() to treat the group as an error
> and drop the extents instead of adding them to the accepted list, does this
> leave the device hanging without an ADD_DC_RESPONSE if it resends an
> unacknowledged extent group?
> 
No. cxl_add_pending() always sends a response, even if it's empty. We
simply omit fully duplicate extents from the response.

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260625112638.550691-1-anisa.su@samsung.com?part=16
