Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CC4A933
	for <nvdimm@lists.linux.dev>; Thu, 22 Aug 2024 21:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724362871; cv=none; b=WduE4mEcxTcl2yQ2JbIn1eImmpH0EkjUW526nUsahX8JUmbBIaqB17rSfFK00GqmWDAQUA8EUozjzRqAPuf8UWyQaoWqV1YqYvu8x1kDvWrsktNk8G2LbfCsGCSVrljzlu76iUW0qU1xc1Oxo7lItZb5zvfM8NcNjS53Q/s3X1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724362871; c=relaxed/simple;
	bh=OY0Cw4jKHYyA2YTNmNjSXtMsaRpmLSV3pecbLOsimfU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j8Tgor+qRhJD/+octBax2dwdhQaIcUQXDfepGWU9uASbru+1kvQ1p2X/Si524QHqB0f89Nbp7awfWSYJX0VsmJwQsE3fz1oW7tZrqQRKZHM9FA1d0Y12eBX2AgpJIWITtVsOItiYZXycobg5dQ6O90N0i3CshR1rPXPAbRTWb8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RUmU4KY1; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RUmU4KY1"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20208830de8so10831105ad.1
        for <nvdimm@lists.linux.dev>; Thu, 22 Aug 2024 14:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724362869; x=1724967669; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fefpIDiQsvmyVmJ9DTk9OrkozwCKfzpukO3kKB0G7io=;
        b=RUmU4KY1XSSc154Rgz1EPpYPpcGgtYMM3RyFWFNTsH/7lYnMCpmN6cHoUE6Zfmhio6
         T5UPozCDag0BN1/78UXYsA84rxRSwBrjrhe963rJ6W5PFOk+Gh3Mfh6gM82jxI2N+1S/
         bYdyGRgATpfzilUM9TsVHbJ+OfBbKRZq4prrgHCDEtW7Dhjosj/X/9yRVrCkoJ5b1TIe
         pDa7KZYBKExWm5YuYDm+ivKsyQwK7VimoA73NTg8dy/2Tcqj2qiznKFfUsROgB6TUVjx
         CF5O0Iz9Au8GlkxUsY1VnIqhU4TyywMiNNRhB0lZed8ZYmMC2r8ZhxLa/X0EYD2AB0Mh
         ZQBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724362869; x=1724967669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fefpIDiQsvmyVmJ9DTk9OrkozwCKfzpukO3kKB0G7io=;
        b=oEE2qMUXUz5Dr1lwtjrkxZgJIQH9RCqLJoIhSQ6ev64MZEoSsF13h4p1Ts4P6zAzqC
         S3ckm2DBk66ff4m8RGoy3WC9BpGr4pkc/kXEwZ8UL4q3WDCILjl1Ee3ovB2Tj4W2qYCu
         pY3opV2XFv5jjnJoKGhqiI0O3miEntjkNAwdrH16esBQljiBf+jg3TFQWcKcjGvfgBJs
         u76A2DQpkppvOEALxkc1gtrT6NPgv12aF8wnb8QrlU3zcJA7nOapYVfhIDPIfMPel/Wz
         clm9Bw3Qa1x+gv+jGGQzqeunuQaMp2GLU3ZP2ybhlpSUhtNfgPNFQTbca08e7f9qSZj5
         ZM6g==
X-Forwarded-Encrypted: i=1; AJvYcCVflTDtZZ/0zp5VUdJwz5SkYKgGoUehdwbqMpzjYoVk34i6PfMxOCL1dgckkWGmFXOyiJcfhnE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxKOtcU29UQYejV3/1CIqo31g2lw2beRN6Y1i4te8b39HCzoNGc
	5uypPnO6/u1cTQc8YWsoALcnsjLJexz6loeFzuykkN3INPkIrcPj
X-Google-Smtp-Source: AGHT+IHCWUeOTFC/rJ8NysGSN8g7BvV82Pdq7JDaAlLehwEn9Kj+6aSkyw+tasX7G1339cnBWDepbA==
X-Received: by 2002:a17:902:d2d0:b0:1fd:8c25:415c with SMTP id d9443c01a7336-2039e4891ddmr1772985ad.24.1724362869331;
        Thu, 22 Aug 2024 14:41:09 -0700 (PDT)
Received: from fan ([2601:646:8f03:9fee:3cd4:f45f:79d:1096])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2038b7ebe0dsm14920535ad.287.2024.08.22.14.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2024 14:41:09 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 22 Aug 2024 14:41:05 -0700
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
Subject: Re: [PATCH v3 15/25] cxl/pci: Factor out interrupt policy check
Message-ID: <Zsewcfl5alK4mvZS@fan>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
 <20240816-dcd-type2-upstream-v3-15-7c9b96cba6d7@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240816-dcd-type2-upstream-v3-15-7c9b96cba6d7@intel.com>

On Fri, Aug 16, 2024 at 09:44:23AM -0500, Ira Weiny wrote:
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
> index 17bea49bbf4d..370c74eae323 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -738,6 +738,21 @@ static bool cxl_event_int_is_fw(u8 setting)
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
> @@ -760,14 +775,8 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
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
> 2.45.2
> 
