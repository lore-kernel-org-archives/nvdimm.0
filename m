Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A0F19C57D
	for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 17:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728583145; cv=none; b=i4u8b6EJiygMahxlU4JCAQ9797bFFa7O4ipGJfgUzJvUwO5GOnsN3UEv6BE+90RWZbVVDUnlXLZt63MTGYlYj3CNjdxm2z37ZbDk/B1hhrTQGsoJ4vk+V/dVHBh/9g0u+5H+JOt2/5EqJ52aQZMAicsePgaVwhTP8wYSqHxYGCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728583145; c=relaxed/simple;
	bh=Kge7wc2eVf7UslF+TD3gPb+FeB7D+a2MobjWWFDO3WA=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ulXSyZSsFKz4xDPoKRJkinAGp50oAnO80BAyEG+/3LD6sGnKGez4IuJPILzw5in0+/N96hELEJsbaypMwQ1r2Z4LnJ0leuHwz88n+dqkIIgNggA58CK/IQQOlL9Wb/Gy0h+w+wQ0usD7b+lDMhlPbvo9IuX+IJglyshQZzBQZJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mlPf2KvQ; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mlPf2KvQ"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20b7eb9e81eso12444725ad.2
        for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 10:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728583143; x=1729187943; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Pjaq1ccy6Z8uwpI+HpuudFCkgY1TCeYNA3gLc2Vpidw=;
        b=mlPf2KvQ10q2vAxkjYVAPy6RweL3vBA+RsC0RvGacHMyceKmfwMGWutpEEax0LUHOG
         vYCpzgbfDEe1cUNiow57fd10HbCVyHeHnPeDY2pf9k5ojMQ+PNTLbL0E0ggUQgFQmoDa
         x14f29GHnu7ot1cY16d3TpZvj41Rry18+O9bmXbxhE3c8MKKiw8x6ltz8CBjwup3FyE7
         zADF7R098V0dEqIXgY3wn1WJqXxdqA2ZIq3fMeuq5WlesSocBunVDmjFFFqEi2cLQLX7
         1lyEdmRjLzVqGWqT6DNR2BCXCp6lAgWqxPLooWFXUzRMOMtji3PMtlxOxAsPwJXNRKiw
         1Vxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728583143; x=1729187943;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pjaq1ccy6Z8uwpI+HpuudFCkgY1TCeYNA3gLc2Vpidw=;
        b=uiRU+lHoFmSAiQKlXzQ8DGpeylNZ2oVK5ENnNlIURSLAGvfsLIIHzSEO2X+8VPBAqC
         m2lLw6qGVcN8q6mrbXwQKCpiu921fV+wdbzjX6ACnsKMqDMQWfsf/w0IY2hXu7chd0pT
         8goiKNldIPvVI084LA87QKmIgTj53/0XMR3J+7stGOJV/Udr01C98qCMAbVLHDo7Mc1N
         fnMuS+mK4v8Yva29j6b0N3Uh9rJzIFBBukgwOAvKhVQhpVPv74WSjbfPaqXuyRep/XNy
         LO5VXtnxSENL0ainvMdGpam1VcuUoGDPROHHZeBM4qUvk3j9PAWGZaVAwqCsEZZVFQ1i
         ijOw==
X-Forwarded-Encrypted: i=1; AJvYcCWShbx8YYxH+F3mQdpV2UoAdXq4JvxhzyM+nEmDYe44uoDI/YdcYi9/AU4I9Z5oA+UGsTb4JSo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzo3FJD75UwLYdM4xXCTUyaa0ERAh4IcFTZZyZl+YdxHeCbJvVQ
	bZZY5EtsL+co3tzElSl+9xkXyTbh/qlnA2sI5nvpZM6wSgwsnt37
X-Google-Smtp-Source: AGHT+IEyOee19JN6mF8IjynsdGZ4gyhcTytl8LOHNBi6Lt4Mwgsu9dLliHXMPgXybxOPTDtUxxBD0w==
X-Received: by 2002:a17:903:1208:b0:20c:70ab:b9c3 with SMTP id d9443c01a7336-20c9d8d2615mr5434325ad.34.1728583142564;
        Thu, 10 Oct 2024 10:59:02 -0700 (PDT)
Received: from fan ([2601:646:8f03:9fee:c165:c800:4280:d79b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c340106sm11950045ad.265.2024.10.10.10.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 10:59:02 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 10 Oct 2024 10:58:56 -0700
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
Subject: Re: [PATCH v4 17/28] cxl/events: Split event msgnum configuration
 from irq setup
Message-ID: <ZwgV4D9NmcC-SAYQ@fan>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-17-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-17-c261ee6eeded@intel.com>

On Mon, Oct 07, 2024 at 06:16:23PM -0500, Ira Weiny wrote:
> Dynamic Capacity Devices (DCD) require event interrupts to process
> memory addition or removal.  BIOS may have control over non-DCD event
> processing.  DCD interrupt configuration needs to be separate from
> memory event interrupt configuration.
> 
> Split cxl_event_config_msgnums() from irq setup in preparation for
> separate DCD interrupts configuration.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
One minor comment inline; otherwise

Reviewed-by: Fan Ni <fan.ni@samsung.com>

>  drivers/cxl/pci.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index fc5ab74448cc..29a863331bec 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -702,35 +702,31 @@ static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
>  	return cxl_event_get_int_policy(mds, policy);
>  }
>  
> -static int cxl_event_irqsetup(struct cxl_memdev_state *mds)
> +static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
> +			      struct cxl_event_interrupt_policy *policy)
>  {
>  	struct cxl_dev_state *cxlds = &mds->cxlds;
> -	struct cxl_event_interrupt_policy policy;
>  	int rc;
>  
> -	rc = cxl_event_config_msgnums(mds, &policy);
> -	if (rc)
> -		return rc;
> -
> -	rc = cxl_event_req_irq(cxlds, policy.info_settings);
> +	rc = cxl_event_req_irq(cxlds, policy->info_settings);
>  	if (rc) {
>  		dev_err(cxlds->dev, "Failed to get interrupt for event Info log\n");
>  		return rc;
>  	}
>  
> -	rc = cxl_event_req_irq(cxlds, policy.warn_settings);
> +	rc = cxl_event_req_irq(cxlds, policy->warn_settings);
>  	if (rc) {
>  		dev_err(cxlds->dev, "Failed to get interrupt for event Warn log\n");
>  		return rc;
>  	}
>  
> -	rc = cxl_event_req_irq(cxlds, policy.failure_settings);
> +	rc = cxl_event_req_irq(cxlds, policy->failure_settings);
>  	if (rc) {
>  		dev_err(cxlds->dev, "Failed to get interrupt for event Failure log\n");
>  		return rc;
>  	}
>  
> -	rc = cxl_event_req_irq(cxlds, policy.fatal_settings);
> +	rc = cxl_event_req_irq(cxlds, policy->fatal_settings);
>  	if (rc) {
>  		dev_err(cxlds->dev, "Failed to get interrupt for event Fatal log\n");
>  		return rc;

There is a lot of duplicate code here, can we simplify it by
iteratting all setttings in cxl_event_interrrupt_policy like 

for setting in policy:
    rc = cxl_event_req_irq(cxlds, setting);
    if (rc) {
        ...
    }

For DCD, handle the setup separately afterwards.

Fan

> @@ -749,7 +745,7 @@ static bool cxl_event_int_is_fw(u8 setting)
>  static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  			    struct cxl_memdev_state *mds, bool irq_avail)
>  {
> -	struct cxl_event_interrupt_policy policy;
> +	struct cxl_event_interrupt_policy policy = { 0 };
>  	int rc;
>  
>  	/*
> @@ -777,11 +773,15 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  		return -EBUSY;
>  	}
>  
> +	rc = cxl_event_config_msgnums(mds, &policy);
> +	if (rc)
> +		return rc;
> +
>  	rc = cxl_mem_alloc_event_buf(mds);
>  	if (rc)
>  		return rc;
>  
> -	rc = cxl_event_irqsetup(mds);
> +	rc = cxl_event_irqsetup(mds, &policy);
>  	if (rc)
>  		return rc;
>  
> 
> -- 
> 2.46.0
> 

-- 
Fan Ni
