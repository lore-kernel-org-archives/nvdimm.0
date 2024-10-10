Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78F01E9064
	for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 18:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728585002; cv=none; b=XBKFGd5HI4x/xQ4p8l6Yh74iO4RhCq0EWRYw6x25j60BbqK/K3VmecGBAByGsguoe2ZdPR7xncaXU94Q5td9LzaCP9l1srJWKfdgmbn1Kq8rly++9Mul+Zo6naScHBCibqMrmDIJQ69w3Cb4HoRzsRQTZNEy22zkLZn6kXjDXg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728585002; c=relaxed/simple;
	bh=ATlE5iF1D+i8hM107h56WYkiC3V5Vr7ynZaWhizuKOg=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FiCbQEx9P9p5AQuu8MkXBAqQCAde3jUwtz52n8vBZ7FORpqYRuZyAt7u50ZMNGFOCaTSeizYXyvjl08sATmRA37GAWRYyie/NR14fwB9G9d79OmGiIVBPgVg2I+6cy7Nuuj6umsl/cN9LMmbtraaViWE/mj+sceZV5Nwf1BlcZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N5OF0Tex; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N5OF0Tex"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2e2b549799eso975652a91.3
        for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 11:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728585000; x=1729189800; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YimOy7qc5N+LKT23Y0mjrXB82RJNkHep3WQxQZ801rM=;
        b=N5OF0TexLPh2DaVxHJnR/BYpBqQXSWTaRbCZnNyIRre5D/FRVT4t86HdXoCxGRLCj2
         6UdDe20J2tyneMhssQP6uresAi7i/linxL2pNbvTYyVsCdqrTsYbwWMiEaajIYZrxWdN
         RrW5VYpFv5i4V8jI8i2/X8TPDn7mMJISGjJJuV3yKYee5N6Sb/c6fTqkzhTBAnCqvmeP
         3xJnmj9y1ZnFkqzY8bbgpXEjajc+eVXBeZJiwql4spAdeytjIBlN6xo9Z9XECfWIa1r+
         glTY8DnTlockObDhjCD0H65VEh++5otiOBgdI8VKb898YmP/cxHlhKLDeNsHMPitSD+1
         yklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728585000; x=1729189800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YimOy7qc5N+LKT23Y0mjrXB82RJNkHep3WQxQZ801rM=;
        b=XeHUhM+KfOoptuBCBG7uipTipszM4gnFZi6zGDyy/GbiKz0B/0QmETYaA1nI3Nxkoy
         1+5V/QbjX7wZJyg1yBM1mpESKpFnbvC0wEibu8kI/WloW23HzAj2j32G2TmIRwp8OrSR
         KFHjevKh8rAd5tTGjMcIM0JQqUCSyBqDS/56WBdVrUAl2e8MlmgQSnATjEkpiOS/cUGq
         OmDe7kyl/XzxQxpIFuuJylDxWfTvPoU0+G6lg05Hl+kWPmJXYTOR0c+W3HTyTktjzmh0
         B3KI8I3udQRzdYznIbohTG3cCgwOsvdPSLC3eoqmUFd700CNASuumXYseuxuB5qgQolY
         N6Ag==
X-Forwarded-Encrypted: i=1; AJvYcCUupfSSNJjoByw+ywxrRVkriOAmHeqVCbmOa/7hSDrt3EITY/ohDK4Yjpx3fn99y5xAhODCgtw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwGrAkVCq2n/askFMfRrv6m7NHnXkJkbuOKZNuBGYP3usD4Z0ru
	dZDSQcYwhwvwI4MKPxYEv9WJ50FnPLx/o3McNov4hhyVTPzDuBMa
X-Google-Smtp-Source: AGHT+IGZrKnj1WJs8nsWKq4t5Jq9tMpObwNCDHwnSBub3/8G7+C0G8eVp4m92pO5SYGehe8jLGH2yg==
X-Received: by 2002:a17:90a:fd0a:b0:2e2:b211:a4da with SMTP id 98e67ed59e1d1-2e2f0a710fcmr118697a91.14.1728585000069;
        Thu, 10 Oct 2024 11:30:00 -0700 (PDT)
Received: from fan ([2601:646:8f03:9fee:c165:c800:4280:d79b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e2d5f0a4edsm1662161a91.31.2024.10.10.11.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 11:29:59 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 10 Oct 2024 11:29:56 -0700
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 20/28] cxl/core: Return endpoint decoder information
 from region search
Message-ID: <ZwgdJC8bSxfJuRuR@fan>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-20-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-20-c261ee6eeded@intel.com>

On Mon, Oct 07, 2024 at 06:16:26PM -0500, Ira Weiny wrote:
> cxl_dpa_to_region() finds the region from a <DPA, device> tuple.
> The search involves finding the device endpoint decoder as well.
> 
> Dynamic capacity extent processing uses the endpoint decoder HPA
> information to calculate the HPA offset.  In addition, well behaved
> extents should be contained within an endpoint decoder.
> 
> Return the endpoint decoder found to be used in subsequent DCD code.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Fan Ni <fan.ni@samsung.com>

> ---
>  drivers/cxl/core/core.h   | 6 ++++--
>  drivers/cxl/core/mbox.c   | 2 +-
>  drivers/cxl/core/memdev.c | 4 ++--
>  drivers/cxl/core/region.c | 8 +++++++-
>  4 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 5d6fe7ab0a78..94ee06cfbdca 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -39,7 +39,8 @@ void cxl_decoder_kill_region(struct cxl_endpoint_decoder *cxled);
>  int cxl_region_init(void);
>  void cxl_region_exit(void);
>  int cxl_get_poison_by_endpoint(struct cxl_port *port);
> -struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
> +struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
> +				     struct cxl_endpoint_decoder **cxled);
>  u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
>  		   u64 dpa);
>  
> @@ -50,7 +51,8 @@ static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
>  	return ULLONG_MAX;
>  }
>  static inline
> -struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
> +struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
> +				     struct cxl_endpoint_decoder **cxled)
>  {
>  	return NULL;
>  }
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 3ba465823564..584d7d282a97 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -916,7 +916,7 @@ void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
>  		guard(rwsem_read)(&cxl_dpa_rwsem);
>  
>  		dpa = le64_to_cpu(evt->media_hdr.phys_addr) & CXL_DPA_MASK;
> -		cxlr = cxl_dpa_to_region(cxlmd, dpa);
> +		cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
>  		if (cxlr)
>  			hpa = cxl_dpa_to_hpa(cxlr, cxlmd, dpa);
>  
> diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> index 2565b10a769c..31872c03006b 100644
> --- a/drivers/cxl/core/memdev.c
> +++ b/drivers/cxl/core/memdev.c
> @@ -313,7 +313,7 @@ int cxl_inject_poison(struct cxl_memdev *cxlmd, u64 dpa)
>  	if (rc)
>  		goto out;
>  
> -	cxlr = cxl_dpa_to_region(cxlmd, dpa);
> +	cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
>  	if (cxlr)
>  		dev_warn_once(cxl_mbox->host,
>  			      "poison inject dpa:%#llx region: %s\n", dpa,
> @@ -377,7 +377,7 @@ int cxl_clear_poison(struct cxl_memdev *cxlmd, u64 dpa)
>  	if (rc)
>  		goto out;
>  
> -	cxlr = cxl_dpa_to_region(cxlmd, dpa);
> +	cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
>  	if (cxlr)
>  		dev_warn_once(cxl_mbox->host,
>  			      "poison clear dpa:%#llx region: %s\n", dpa,
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 34a6f447e75b..a0c181cc33e4 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -2827,6 +2827,7 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
>  struct cxl_dpa_to_region_context {
>  	struct cxl_region *cxlr;
>  	u64 dpa;
> +	struct cxl_endpoint_decoder *cxled;
>  };
>  
>  static int __cxl_dpa_to_region(struct device *dev, void *arg)
> @@ -2860,11 +2861,13 @@ static int __cxl_dpa_to_region(struct device *dev, void *arg)
>  			dev_name(dev));
>  
>  	ctx->cxlr = cxlr;
> +	ctx->cxled = cxled;
>  
>  	return 1;
>  }
>  
> -struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
> +struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
> +				     struct cxl_endpoint_decoder **cxled)
>  {
>  	struct cxl_dpa_to_region_context ctx;
>  	struct cxl_port *port;
> @@ -2876,6 +2879,9 @@ struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
>  	if (port && is_cxl_endpoint(port) && cxl_num_decoders_committed(port))
>  		device_for_each_child(&port->dev, &ctx, __cxl_dpa_to_region);
>  
> +	if (cxled)
> +		*cxled = ctx.cxled;
> +
>  	return ctx.cxlr;
>  }
>  
> 
> -- 
> 2.46.0
> 

-- 
Fan Ni
