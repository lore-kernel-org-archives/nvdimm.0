Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA00188CD5
	for <nvdimm@lists.linux.dev>; Thu,  5 Sep 2024 19:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725565487; cv=none; b=N3NJ4F1dAETA5jtwFiYAqrGj08pmMrxPE+7ghThpkZVSkGwKAVOqRyA/O7NWRPHFtHrawiWoxqBadcN1mBZANmFRbFkqF3MPBa26j6Bas/+3TEkXjwisdhPBshMU6xRkEf1WvdbZ/DuD/Aj2D+2tXFYUyr8it+1cshEJvajn8eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725565487; c=relaxed/simple;
	bh=fue0HDW/3+IS1tus8cXU1jw98GqL1Ym+HsM/Iofut+Q=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IGBK1qiA0rQ0kyUJhak21dLnFSTfQEs90ToQrSvQHr5CJUkRcVGc08SWbTvO8u3rTPgXNEY8SacKMr4GBpgxu9AOlxUYNDKG3yjJtZr/q+MrFIXbN9B55tNTlIatU5qhP/slUr55V5DdepadjFrJvxTYAouFFUahPeKYXc8Gq3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CAXs+Qy7; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CAXs+Qy7"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-71767ef16b3so797560b3a.0
        for <nvdimm@lists.linux.dev>; Thu, 05 Sep 2024 12:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725565485; x=1726170285; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8blKARCK9hIi8qeqcpQY8FMcJR6skaNK4+MKzRO1q9A=;
        b=CAXs+Qy7+6YyZjvb37zZ9fvf3zIels2AwG9/11D98PpevrbJiA6GWHNtxdYrZSVLWb
         bfjLJIOF7RS+vu76G66vNVq47q6r9CB7wqqeuNvEMfCaU76ajzylpF5t7+i5s67sD1gP
         ISBYJhiw/ek+3ud6dpHw9XK9mQnzN9jWoif806stsgb/B+115gp6KNTJjbMhq+d2qRm9
         wRelqpJ7WSkzOAgqaDLd+PwYyHKRA3JNHqm9QoxROHHlBIsi67BeVqNVB9+5odO0TY0S
         pFh5C7kNrkowt4QtN8hZSJklYyWDMvaASBI1fubKuYZyOCNKUalz4KpibSmwl/3Vhsax
         9XEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725565485; x=1726170285;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8blKARCK9hIi8qeqcpQY8FMcJR6skaNK4+MKzRO1q9A=;
        b=UEBwAWLfC5wO6ImNGV1GW/nFRkvC22ZhldybG+IkLrr8dV93Yr3aWZK9+1kEoNOtY6
         oqZWO5zZ1woOhDEQD/9YRHVPSwa/lVdBtoayePMF7+TwvTiB2Vp+YdKFab7sC8WwlcKz
         7/wC29T1uZXP1vaPjVlPVi7orLP+D4tEEsm4wUWT+xRR/QSWRWHH5Dq8vFiyDJ5r8FMR
         ZZqxRf/XAkIXP5bWcSEoHYFGqXKzJ2al/TKGRIATfhwFK9aI7ehqORI/UHULVWHIoVfm
         nfhBl9qkZ23tqtwyHMJDsW2jcFGry5nnoqLFcj2wtEr3ZrySbVdRVIg14ibOxSGfw+PH
         5tEA==
X-Forwarded-Encrypted: i=1; AJvYcCXlHPcmCnCYAEBFG5zjdqJkl/dzeMYESXytMntzyvA0gcnUU52Fg5KnJ/ir6IUQRcwW+3Y8PWg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwY6IND2WWd9JdkURPpsz/Ye9rjpK2nWorD8WaM5C3OCWRSnxYy
	6HmEvL2N8kg5AqVF9bApcab1XVtHu/EqORCwhAXiCwyI+hWU6oIP
X-Google-Smtp-Source: AGHT+IH4+fX/yHmOeAuqwoSbrIHi2omPpjNgufLcJxCjb0muDVPuPNm2103Rdbup4SGV09v81le2FA==
X-Received: by 2002:a05:6300:44:b0:1ce:ebb7:dcb8 with SMTP id adf61e73a8af0-1cf1d05864amr60468637.3.1725565484771;
        Thu, 05 Sep 2024 12:44:44 -0700 (PDT)
Received: from leg ([2601:646:8f03:9fee:1d73:7db5:2b4a:dfdd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7178e39a188sm1473548b3a.219.2024.09.05.12.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 12:44:44 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 5 Sep 2024 12:44:24 -0700
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 04/25] cxl/pci: Delay event buffer allocation
Message-ID: <ZtoKGEEhNHByhXyw@leg>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
 <20240816-dcd-type2-upstream-v3-4-7c9b96cba6d7@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240816-dcd-type2-upstream-v3-4-7c9b96cba6d7@intel.com>

On Fri, Aug 16, 2024 at 09:44:12AM -0500, Ira Weiny wrote:
> The event buffer does not need to be allocated if something has failed in
> setting up event irq's.
> 
> In prep for adjusting event configuration for DCD events move the buffer
> allocation to the end of the event configuration.
> 
> Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---

Reviewed-by: Fan Ni <fan.ni@samsung.com>

> Changes:
> [iweiny: keep tags for early simple patch]
> [Davidlohr, Jonathan, djiang: move to beginning of series]
> 	[Dave feel free to pick this up if you like]
> ---
>  drivers/cxl/pci.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 4be35dc22202..3a60cd66263e 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -760,10 +760,6 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  		return 0;
>  	}
>  
> -	rc = cxl_mem_alloc_event_buf(mds);
> -	if (rc)
> -		return rc;
> -
>  	rc = cxl_event_get_int_policy(mds, &policy);
>  	if (rc)
>  		return rc;
> @@ -777,6 +773,10 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  		return -EBUSY;
>  	}
>  
> +	rc = cxl_mem_alloc_event_buf(mds);
> +	if (rc)
> +		return rc;
> +
>  	rc = cxl_event_irqsetup(mds);
>  	if (rc)
>  		return rc;
> 
> -- 
> 2.45.2
> 
