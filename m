Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794882729;
	b=ogwXiBl/rRQfC1jTfRtEM1GwdiR7WnJC2CyQPitzSCsERmuz64fvxKX6FgbGprMMgXzv
	 PDKlm4vVLIXVbowptHNQpWBPswUY224FCYJATJJnXvcVAcNNeSmEo02amH37uRoMNrNvG
	 5WCuGcn0ym992AQ5lVyXKTGbwfXHdXgfLcQoKu1V6AsFJqrhfn6ig7tOrdVJ3A3p6hdf/
	 Q9PaNtlFZYCwqqnV6loFmU57+F9V7yuocHsZqUwktpPTnRuD2c8nRXbLgP0uf85CApnIR
	 Fz66JufaFFR8Jl3mAvOM/LsLgcPeBWQbHIKqotaz/JEzCOO4h3wWKpDw6GcE43IS/CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794882729;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=jF3jMumUZAbpVyF1eDwIYxLiuHyevBLWQFM8Owa9OZk=;
	b=GDF4Ho7Kr9ZZg9fewsz6ZgEW3HtHX/iX3Lc0mpH2ULeZEa6M17kB5k7OY3efVa33twxc
	 z5DMjpUsrF9xxYn05PuP+gjw9Oq0a4GWeSGNOfZgDE9jGR+5ZpcXniiqAmwCsormHYRl0
	 CxCxRMdrLy2rYwC/UM+R9J5oMFbndE3wGWCfn0g8jNRsUrUkkiKqZUr/99+lvFSzViMTQ
	 g9swpIQG3LXHvK9wtqLrYOev+FYmjo1SBiXbRdcWSZZjZZPGPAVyMTQhCJ4DlWDOoB4A/
	 4RpUaPsl7m8xQOFCLoWh3wnsIDoiyxaplhqr+BKrQ3CZ+4DmVS1Sh3f7TI7j+1Oo8jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aOrXiRZI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25C4606A31C;
	Tue, 17 Nov 2026 02:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aOrXiRZI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860031F000C4;
	Tue, 17 Nov 2026 02:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794882729;
	bh=jF3jMumUZAbpVyF1eDwIYxLiuHyevBLWQFM8Owa9OZk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aOrXiRZIW5dICW3ndkWDL3PrtzmGBlG4lcfcKqdm3XAq8si+HO1wONlnWEp87s1a/
	 gM6N87I3qh19NleFCWxpKkqo0fIziwqCEVR3C7MGwobKb+K6kM3hzGKLAtXPQK+yN9
	 mJZYILuY5HmwxOQDyNaeCDFNd0sYEoHG72vbSzyoEA6ISoFpxlmMCS5l4AO6z/yqZV
	 blNyPkF5lmSVVZUCJDKleuz4lk4S9EON9RJw8aN0B9jLfYvYTtWH1pTm5yEP+po+AO
	 5MfHhVTzTjtUGx5ampDHF56kKNQpyZNodaILKy2r6QW9Pu/1om4ngUha9wCEzYcn+3
	 WG+yBYtgOtHOA==
Date: Tue, 17 Nov 2026 02:32:01 +0000
From: Jonathan Cameron <jic23@kernel.org>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, Alison
 Schofield <alison.schofield@intel.com>, Davidlohr Bueso
 <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Vishal Verma
 <vishal.l.verma@intel.com>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
 <ming.li@zohomail.com>, Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Gregory Price <gourry@gourry.net>, Richard Cheng <icheng@nvidia.com>, Anisa
 Su <anisa.su@samsung.com>
Subject: Re: [PATCH v1 03/14] cxl/region: Add dynamic DAX region support
Message-ID: <20261117023201.5eee045c@jic23-hlaptop>
In-Reply-To: <20261104230445.66625-4-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
	<20261104230445.66625-4-anisa.su@samsung.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  5 Nov 2026 08:02:27 +0900
Anisa Su <anisa.su887@gmail.com> wrote:

> From: Ira Weiny <iweiny@kernel.org>
> 
> CXL DAX regions must allow memory to be added or removed dynamically
> to support DCD. In addition to the quantity of memory available, the
> location of the memory within a DC partition is dynamic, based on the
> extents offered by a device.  CXL DAX regions must accommodate the
> dynamic movement of this memory in the management of DAX regions and
> devices.
> 
> Introduce the concept of a dynamic DAX region. A dynamic region
> carries the shareable and read-only properties of the partitions it
> decodes, fixed when the region is created: every endpoint decoder
> attached to it must point at a partition with exactly those
> properties, and the region's 'mode' reports the matching selector.
> 
> A dynamic region has no capacity when it is created, so the DAX device
> that cxl_dax_region_probe() creates for every region gets size 0
> instead of the region size: a seed that claims no capacity the device
> has not offered yet.  Its dax_region is created with IORESOURCE_DAX_DCD
no capacity has not been offered?   no capacity as the device
has not offered any yet. perhaps.
> rather than IORESOURCE_DAX_KMEM, so the DAX devices on it bind to
> device_dax and not to kmem.
> 
> Indicate 0 byte available capacity until such time that capacity is
> added.
> 
> While DCD is disabled, auto region creation and the region 'target'
> write refuse endpoint decoders on a DC partition with -ENXIO, as the
> decoder 'mode' write already does. The sysfs entries for manual region
> creation follow in a separate patch.
> 
> Additionally, dynamic regions complicate the range mapping of dax
> devices. There is no known use case for range mapping on dynamic
> regions. Avoid the complication by preventing range mapping of dax
> devices on dynamic regions.
> 
> Interleaving is deferred for now.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Co-developed-by: Anisa Su <anisa.su@samsung.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>

A few small things inline. 

> @@ -2411,6 +2432,7 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
>  	if (sysfs_streq(buf, "\n"))
>  		rc = detach_target(cxlr, pos);
>  	else {
> +		struct cxl_endpoint_decoder *cxled;
>  		struct device *dev;
>  
>  		dev = bus_find_device_by_name(&cxl_bus_type, NULL, buf);
> @@ -2422,8 +2444,14 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
>  			goto out;
>  		}
>  
> -		rc = attach_target(cxlr, to_cxl_endpoint_decoder(dev), pos,
> -				   TASK_INTERRUPTIBLE);
> +		cxled = to_cxl_endpoint_decoder(dev);
> +		if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM &&
> +		    !cxled_dcd_enabled(cxled)) {
> +			dev_dbg(dev, "DCD not enabled\n");
> +			rc = -ENXIO;
> +			goto out;
> +		}
> +		rc = attach_target(cxlr, cxled, pos, TASK_INTERRUPTIBLE);
>  out:
>  		put_device(dev);
Could tidy this up whilst here and use a __free() for the put device.
Entirely up to you though.

>  	}

> @@ -3808,10 +3845,18 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
>  	if (part < 0)
>  		return ERR_PTR(-EBUSY);

There are quite a few cxled->part[part] lookups in this function. Perhaps
a local variable for that is worth introducing?

>  
> +	if (cxlds->part[part].mode == CXL_PARTMODE_DYNAMIC_RAM &&
> +	    !cxled_dcd_enabled(cxled)) {
> +		dev_dbg(&cxled->cxld.dev, "DCD not enabled\n");
> +		return ERR_PTR(-ENXIO);
> +	}
> +
>  	do {
>  		cxlr = __create_region(cxlrd, cxlds->part[part].mode,
>  				       atomic_read(&cxlrd->region_id),
> -				       cxled->cxld.target_type);
> +				       cxled->cxld.target_type,
> +				       cxlds->part[part].shareable,
> +				       cxlds->part[part].read_only);
>  	} while (IS_ERR(cxlr) && PTR_ERR(cxlr) == -EBUSY);
>  
>  	if (IS_ERR(cxlr)) {


