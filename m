Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE51388382
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 08:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782290192; cv=none; b=bwwekiZFC+p0zdWOcMOrkM0fa+dMSaEROo/ql0X4lj5W8S23QbHzSLtJBdpQ9mwPVKsx9EnlUYnRUqLaYLjWwmv/YRkZfZuvW4LDTkuCd7WesEFRJPV+8i2Hca8ph2kbF3F8jw3UgdVLds+kZmNGgPzM2q9sY50sh5zQvHjF53I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782290192; c=relaxed/simple;
	bh=IC96SJpon10vJpky3Egz7KbIXsoKr7uotQi+Mi3bWy4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VAZIeuISZT0UDX9Te8E3zaFMaXSEwJhrbkNeJJA7Ixtw7F8UbEJHpy4Wh+n2DPAQGJe7fpxg9usdg4m0l6jbfP7cFlKtzu/nV/yuWpMdYG/ZbMJL2F1UjO/PvFMyVAGMalF9RBW5U/Dc6rQRgs2YlwlG1FFjTJuU7ZshZu3/SPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QS4MS2Kb; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QS4MS2Kb"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-30c6c8d7503so1227673eec.0
        for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 01:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782290189; x=1782894989; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i6loG2kbuu3buyD+OMfDQDJAMGaTd6c5fL/hshLRcTg=;
        b=QS4MS2KbF7OadKu+ssu60kfs2m9eUyyAatLwCGhExDnvTJShmg0VtWHP0zNM88y4iP
         f+izivF/eAUKe8jETJnM9VcX6CAroNRan6/1TwDTIGhNGWW85Qp1b61E6EuxT8dmyFgg
         tqIss7yAToAOwplkbEufFUeuwnf1C3YtdLCzWwAlvTF0siwZjFw8gWA3HLCI0I5OPU1e
         0ujifAWx0OvrDoUEIWzKDoSNGYZn31seBf3jqyZOttxBS07lsy02JcrXfLx6DQo/AjlU
         3jj8pF/aEPE4b3P0VJsTSfTmfjI2C8A18IhmbrVN7Hy+IiMp4q+wdqj2970IZ8OOatJ1
         tnDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782290189; x=1782894989;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i6loG2kbuu3buyD+OMfDQDJAMGaTd6c5fL/hshLRcTg=;
        b=VaWa4o0hXWq/iKLi1T6datMsmLu7FCRBZgbV67Y/Ods/43HSiRGPGNnS1EqYEiarOD
         QVR2jCo+/GD30X8qXp6ZIN4+Ql6pONqF50L0z8jBdVloRRDk24u5ISdhD0TwPxMODCGE
         Iyaf1Y92evQvbvyyvw3+jBVB9ITMVW4M9sQpRykgs/eh6oFVMrJsp2ElMCZbShCCW4CR
         PnblAoABW6EZbsL7Jo4u6GxcMzCtya/PAOuPeqB52mI70ORdD3qAi3PfKestqrNRIHPN
         W61iAVUN4LGgiWsunnkqA8D7WoltGXtmOlmByV5M2AaavGai5zg7hV7wrFLkareG/pvm
         efNg==
X-Forwarded-Encrypted: i=1; AHgh+RrtkBSs5o9/hLWxxMb6rkXYC/AC1XyQXzJ2jBtLFs9I4YH2mDKi5JTCkyrGKgAcFe73rIBU1OA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx40T8SRpkrxvuvmO8xijHr03cFcG+ofDPQ912AdnyskGyz1DRk
	k9yxlBD8ScEkogFsVRrZWHrTequka4vEh7gOyCh1QyBchUv4BYv3PFDq
X-Gm-Gg: AfdE7ck6Vr2WcKKuBOWZupJPbDaQQJL4is8xpw6PharIViFEXzS8nqJp4PLHK0B7Xxl
	rKYEW7jGB9EDnr8fkLPlHp2bF/VA1kAMkNulo8LzbYsmQR+UMGCcVY9AUKopcRTO8DpvXTsP5KP
	+yy3xgTXMU5dzDzuP4dCMVu+1ZC0JJVCwA69YZaOQyXqOgV8YPiDzqNMiOFS9Pb9kStI0QY8MQ+
	DEAl6nlXs9EiWYg3HwnmVH5VpXLwbvcgAep/wZ8ZulP1fX67qQutn5Ttm90tli3pcjmXeeg3Fj5
	mWrTArJzOm+9ra1CefeTOj6l3goagBnyE+AG4Z7yVlOZl5xl9LcrgpuBZ4r5ik99e+McI4eKV+M
	OGIwIasJ1LRkhfp3FF8rvJFtfwjtx2wbOv76p9nDZTUOvNdD4lTiFxf8O2Unem+Tlj/yFNZhsTr
	+cWTL8SUi8h8p5AO1bw0CwayKS4FkNt6VCprsgiqFI79NM6lk4nt/qyQNhOLC6cx785oYp4buZS
	8LPyRM=
X-Received: by 2002:a05:7300:506:b0:30b:c502:23e8 with SMTP id 5a478bee46e88-30c692f8c53mr2440312eec.21.1782290188564;
        Wed, 24 Jun 2026 01:36:28 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c6d5717a2sm2764659eec.0.2026.06.24.01.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 01:36:27 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 24 Jun 2026 01:36:26 -0700
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v10 23/31] dax/bus: Factor out dev dax resize logic
Message-ID: <ajuXCluBoji23s8N@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <29393afa419cdffdd5d299cdc323262f5c20c036.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <29393afa419cdffdd5d299cdc323262f5c20c036.1779528761.git.anisa.su@samsung.com>

On Sat, May 23, 2026 at 02:43:17AM -0700, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Dynamic Capacity (DC) DAX regions back their dax devices with per-extent
> resource children of the region, rather than carving from a single
> contiguous dax_region->res.  Allocating space for a DC dax device — on
> initial uuid claim of its backing extents and on shrink-to-0 during
> destroy — needs the same allocator the static case uses, but pointed at
> a different parent resource.
> 
> Factor the body of dev_dax_resize() into __dev_dax_resize(parent, ...)
> and add a dev_dax_resize_static() wrapper that passes dax_region->res
> for static (non-DC) regions.  alloc_dev_dax_range() gains the same
> parent parameter so it can operate under either kind of parent.
> 
Stale commit message :( __dev_dax_resize is introduced in a subsequent
commit. Updated commit message to reflect actual state.

> No functional change.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
[snip]
> +
> +static ssize_t dev_dax_resize(struct dax_region *dax_region,
> +		struct dev_dax *dev_dax, resource_size_t size)
> +{
> +	resource_size_t avail = dax_region_avail_size(dax_region);
> +	resource_size_t dev_size = dev_dax_size(dev_dax);
> +	struct device *dev = &dev_dax->dev;
> +	resource_size_t to_alloc;
> +	resource_size_t alloc;
> +
> +	if (dev->driver)
> +		return -EBUSY;
> +	if (size == dev_size)
> +		return 0;
> +	if (size > dev_size && size - dev_size > avail)
> +		return -ENOSPC;
> +	if (size < dev_size)
> +		return dev_dax_shrink(dev_dax, size);
> +
> +	to_alloc = size - dev_size;
> +	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dev_dax, to_alloc),
> +			"resize of %pa misaligned\n", &to_alloc))
> +		return -ENXIO;
> +
> +retry:
> +	alloc = dev_dax_resize_static(&dax_region->res, dev_dax, to_alloc);
From Sashiko: https://sashiko.dev/#/patchset/cover.1779528761.git.anisa.su%40samsung.com?part=23

alloc is declared as unsigned resource_size_t. A negative errno isn't
returned correctly. Instead, the below line to_alloc -= alloc underflows
and the goto retry loops forever.

Fix: declare ssize_t alloc.

> +	if (alloc <= 0)
> +		return alloc;
>  	to_alloc -= alloc;
>  	if (to_alloc)
>  		goto retry;
> @@ -1367,7 +1396,8 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
>  
>  	to_alloc = range_len(&r);
>  	if (alloc_is_aligned(dev_dax, to_alloc))
> -		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc, NULL);
> +		rc = alloc_dev_dax_range(&dax_region->res, dev_dax, r.start,
> +					 to_alloc, NULL);
>  	up_write(&dax_dev_rwsem);
>  	up_write(&dax_region_rwsem);
>  
> @@ -1659,7 +1689,8 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
>  	device_initialize(dev);
>  	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
>  
> -	rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, data->size, NULL);
> +	rc = alloc_dev_dax_range(&dax_region->res, dev_dax, dax_region->res.start,
> +				 data->size, NULL);
>  	if (rc)
>  		goto err_range;
>  
> -- 
> 2.43.0
> 
