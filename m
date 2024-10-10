Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBB91E3787
	for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 18:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728583634; cv=none; b=NOm9tBzMIMcCV6DxMj7NH6kFfpNKfXCuYH8GyRuDShlt5mWGohtb8N/O7zAQfDOhhca7AvMlNXLCt4grRP5kd9/sOocV6YQqdNPbyEo5q4wFkT9F+0MSuKfIYFYGBGp4pUsulGzm3Pzk25MmlKfp179IhysrYRWtDHvZe7kmYhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728583634; c=relaxed/simple;
	bh=cxG+YNl+v9iEpZmHv73E0r3KZfsBXIVJgAGWTwlWd8E=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mzJMVc3VajOoGa/bChGL1QR4E6fCPBH0WVpro95QPsteAeFJl6Abx+hHJ0FsmFKIzX/WNPFmTgowzu16EZ3u8xyYjGJwkPBBqF2zq+iK/SrOrMhT6y9/zlwFQu6Yzjnj+GllKzTWz4nVRn7AdWpWZR4jfBurb0qcAOqBsOVM1v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TXUcULQd; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TXUcULQd"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-71e05198d1dso897956b3a.1
        for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 11:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728583632; x=1729188432; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hJrjmdMI96zPiPqng8kU9+m7/MaNtEw4rEx+JduNOGM=;
        b=TXUcULQdeEV2wP3rQ/eMCvAZYMmWv4TfJu9NINYynidea83Sjf927UoA9RKkpo0LCu
         iwZuIm0n4xwpn1GQJBxRc5FlhpzM91cNbo5HsoglUAFVj6JPo87Vv3N5qAZXwxuKINVf
         xWolIbVSvFBS3n+B/8zFxfW/Ik3TCcoRARmU3pgt5qYHZIiC6LhjmDqn+5w4r4uvSIQA
         zpJ14MoL3NXHVJT7Yppo725MqX/mM35zepSukFOlwKcz252EWc07c+DsIEkUH1qKylHk
         uOckIQzJ0XyN5OsQ/TGVXuPhjm6DnZ8DFd61uIBFUbGse36VafmFgujlSWht/ud48/5B
         2r/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728583632; x=1729188432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hJrjmdMI96zPiPqng8kU9+m7/MaNtEw4rEx+JduNOGM=;
        b=V0lLvDopLMDU0FOXwIHtvAmFfLl4/UHfXE8fAMpdGYJL4bR3/6luMrhYdhABJF8W3t
         QyE/X7RfrLi2hZPzp6rOHNm1a4EZZ8byjQnQt0ZTn17KI7UBBitgbnRhH8yrNH0hWDrR
         FZtIDvMpuSIRWBwnuHfO+iy0oMnLOShsJgiZhNqeCx6MYOVV/xnN9h8rzx/fG8a05H1q
         vZrbzIqCqK+OUrOtRLohC8QozpMaw9eeFdPgRk0PQB9Btko8nbz7lYmjiut3xl7PgpHX
         0l7fw121XFtkxA+XTw55eOmvRqW0poraSMb2a9a3YLk2BFXFJmyY13yooR5Q4SRvt/tq
         JoJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjV7f7yR4iGx2JN9zGbwcc+Qet5870Aww+FVonvYtpQHtDLQ46v1z0Zd4MjUfDdnSSVHa28fk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCjlLAGK7WcOy0peimm/DkeJ9VjZDst0d8YIHabvZdf/AVBYQV
	xCiChkIxu6MBBn0gFp/CdkRvzRA5ehFHhZ2nfX7pQ+ZvAJZmKUJxVfJ2Aw==
X-Google-Smtp-Source: AGHT+IEjAcQXROm73I8kzCjIfwzpA2mw6XHOqLkD8N3Qu45MZeHc2xU90RHnBEIvm8wQO7RYA0ZqHQ==
X-Received: by 2002:a05:6a00:3cd3:b0:71d:fb83:6301 with SMTP id d2e1a72fcca58-71e1db878d0mr10326087b3a.16.1728583631847;
        Thu, 10 Oct 2024 11:07:11 -0700 (PDT)
Received: from fan ([2601:646:8f03:9fee:c165:c800:4280:d79b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aa0ccd4sm1341853b3a.93.2024.10.10.11.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 11:07:11 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 10 Oct 2024 11:07:08 -0700
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
Subject: Re: [PATCH v4 18/28] cxl/pci: Factor out interrupt policy check
Message-ID: <ZwgXzOwhryyyaEds@fan>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-18-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-18-c261ee6eeded@intel.com>

On Mon, Oct 07, 2024 at 06:16:24PM -0500, Ira Weiny wrote:
> Dynamic Capacity Devices (DCD) require event interrupts to process
> memory addition or removal.  BIOS may have control over non-DCD event
> processing.  DCD interrupt configuration needs to be separate from
> memory event interrupt configuration.
> 
> Factor out event interrupt setting validation.
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 

Reviewed-by: Fan Ni <fan.ni@samsung.com>

> ---
> Changes:
> [iweiny: reword commit message]
> [iweiny: keep review tags on simple patch]
> ---
>  drivers/cxl/pci.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 29a863331bec..c6042db0653d 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -742,6 +742,21 @@ static bool cxl_event_int_is_fw(u8 setting)
>  	return mode == CXL_INT_FW;
>  }
>  
> +static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
> +					  struct cxl_event_interrupt_policy *policy)
> +{
> +	if (cxl_event_int_is_fw(policy->info_settings) ||
> +	    cxl_event_int_is_fw(policy->warn_settings) ||
> +	    cxl_event_int_is_fw(policy->failure_settings) ||
> +	    cxl_event_int_is_fw(policy->fatal_settings)) {
> +		dev_err(mds->cxlds.dev,
> +			"FW still in control of Event Logs despite _OSC settings\n");
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>  static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  			    struct cxl_memdev_state *mds, bool irq_avail)
>  {
> @@ -764,14 +779,8 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  	if (rc)
>  		return rc;
>  
> -	if (cxl_event_int_is_fw(policy.info_settings) ||
> -	    cxl_event_int_is_fw(policy.warn_settings) ||
> -	    cxl_event_int_is_fw(policy.failure_settings) ||
> -	    cxl_event_int_is_fw(policy.fatal_settings)) {
> -		dev_err(mds->cxlds.dev,
> -			"FW still in control of Event Logs despite _OSC settings\n");
> +	if (!cxl_event_validate_mem_policy(mds, &policy))
>  		return -EBUSY;
> -	}
>  
>  	rc = cxl_event_config_msgnums(mds, &policy);
>  	if (rc)
> 
> -- 
> 2.46.0
> 

-- 
Fan Ni
