Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5151CFEBC
	for <nvdimm@lists.linux.dev>; Thu, 22 Aug 2024 18:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724352677; cv=none; b=f710NczzZ36NcKvbgaIyd6qNxOe/dFE/U//lR9fnBiftNXqweWP80T0sRG6qi0wfdFFwfMycSFtq9+Ibnm4Udni8r8WuCXfiUGA6u7XmE9TTtWqsmeLYdsZh3sb61ngfOhdiOSA94XiYnB4u1KsI2hxfp7qOThcTmg1QZjcP9WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724352677; c=relaxed/simple;
	bh=BMaJraMoHW/uTcAAbNBLAoYUBCVavP6nfwEms4SDDjI=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESI3dz3I5NkH95czf8s5rxHLJUz3dTf0piFCQaeL7OjVP/mij/BDGWRBFB904ViQa0AnpptPk8+ziz4AB9xcnYSp4v7lONraMRM2veDFhxH8PBLceMA4btR9N+1zNpaPoHVd1njupDKyJZdEjm/askn06t4KbU5huyCL9SLXlPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GkzE6V/y; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GkzE6V/y"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-712603f7ba5so1037401b3a.3
        for <nvdimm@lists.linux.dev>; Thu, 22 Aug 2024 11:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724352675; x=1724957475; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=J81lmutdj2KlSQdcZOXvnz9hu8mbU7IQ+55GNUYcZ9U=;
        b=GkzE6V/y+4cGaoytpv0lpeqGSTzeJQVcvZO5QcvF42EO4nCAtaVz6QE+xve9fd/nGW
         BmB3SdjHDISknkxJZieIbFyUqign6pMSUhWD6YDXpzrB4m/pw4IWCD2RGjzC+ZnosMnL
         a4zlz3dbBtDpAZZ6P3IpsZ4635I0A2JLBPMZv8FIJ36dASwPjvowPBw+JXa+CboUM7U8
         3U+e80t6XnVQ1+H2i/y49KqN8hVzwhFOvljE+XBnd2j22+WCdr9+YNEpg0ke0OZ/QoFQ
         26ze4o7racGoBBcqD7xqgnFYgtgnWnRPisOsoC6QP80AoVjqlzl92GP2tGe2M23vEXf0
         vIJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724352675; x=1724957475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J81lmutdj2KlSQdcZOXvnz9hu8mbU7IQ+55GNUYcZ9U=;
        b=uxK8a98oZSWcKaBKMhlDSZMBwDrHOlJls8DC84/t7XSkfNmqtytufnSPd2ufUMKmLl
         Zd49bK+7VnBIRslim2f7ayebxrpkDzsmxncpalvrFYNJJ0N135NXO3lUTmiPUpAaBrW/
         rSh8nc1UYWz6zamjGHgQrI/LGK8DzKDlzhMfCrCZxdQkSuNgGMiEE9RdcQX/R4v13uJ6
         Mg6A6SJuu364eOusXyHlQRdiINXsPOgRZtoUVuz9m66pk0vdVxjX2TqN06Lyaq/clQ9Y
         /vDcIvpizm3MJE9aXojXNFcjRsAiGNX2FeU4bntS7VgwYtcpB6fnCqQDiXYVPB/wuAbN
         EyFw==
X-Forwarded-Encrypted: i=1; AJvYcCXEQt/kqB8Q2xfbWOsDnOuToVLyk9tYf793CAjR72iaX/aZ9usqQ9W+feJTrV2xCU4g+rhhvRM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIMti9dhQthwpwDFR5t8NOcLGWDeDWCJdes19eGcE2a+Z7zWTm
	RKXm/6r3H/vedNxEbQblabZpen4jFUbOpH4ja+LzhMOcDmuP+lCe
X-Google-Smtp-Source: AGHT+IEF0d6znvPzsgpm+l7k2pe8qs2gPRoOY9hWFl4DKRKm6TccoUkj66s9kz+p/4KrUyY7XxuRpQ==
X-Received: by 2002:a05:6a20:6f05:b0:1c4:8650:d6db with SMTP id adf61e73a8af0-1cad81455eamr8444970637.40.1724352674618;
        Thu, 22 Aug 2024 11:51:14 -0700 (PDT)
Received: from fan ([2601:646:8f03:9fee:3cd4:f45f:79d:1096])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-714342ffde2sm1758302b3a.145.2024.08.22.11.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2024 11:51:14 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 22 Aug 2024 11:51:12 -0700
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
Subject: Re: [PATCH v3 12/25] cxl/region: Refactor common create region code
Message-ID: <ZseIoP2ZfMdlYjFO@fan>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
 <20240816-dcd-type2-upstream-v3-12-7c9b96cba6d7@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240816-dcd-type2-upstream-v3-12-7c9b96cba6d7@intel.com>

On Fri, Aug 16, 2024 at 09:44:20AM -0500, Ira Weiny wrote:
> create_pmem_region_store() and create_ram_region_store() are identical
> with the exception of the region mode.  With the addition of DC region
> mode this would end up being 3 copies of the same code.
> 
> Refactor create_pmem_region_store() and create_ram_region_store() to use
> a single common function to be used in subsequent DC code.
> 
> Suggested-by: Fan Ni <fan.ni@samsung.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---

Reviewed-by: Fan Ni <fan.ni@samsung.com>

>  drivers/cxl/core/region.c | 28 +++++++++++-----------------
>  1 file changed, 11 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 650fe33f2ed4..f85b26b39b2f 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -2553,9 +2553,8 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
>  	return devm_cxl_add_region(cxlrd, id, mode, CXL_DECODER_HOSTONLYMEM);
>  }
>  
> -static ssize_t create_pmem_region_store(struct device *dev,
> -					struct device_attribute *attr,
> -					const char *buf, size_t len)
> +static ssize_t create_region_store(struct device *dev, const char *buf,
> +				   size_t len, enum cxl_region_mode mode)
>  {
>  	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev);
>  	struct cxl_region *cxlr;
> @@ -2565,31 +2564,26 @@ static ssize_t create_pmem_region_store(struct device *dev,
>  	if (rc != 1)
>  		return -EINVAL;
>  
> -	cxlr = __create_region(cxlrd, CXL_REGION_PMEM, id);
> +	cxlr = __create_region(cxlrd, mode, id);
>  	if (IS_ERR(cxlr))
>  		return PTR_ERR(cxlr);
>  
>  	return len;
>  }
> +
> +static ssize_t create_pmem_region_store(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t len)
> +{
> +	return create_region_store(dev, buf, len, CXL_REGION_PMEM);
> +}
>  DEVICE_ATTR_RW(create_pmem_region);
>  
>  static ssize_t create_ram_region_store(struct device *dev,
>  				       struct device_attribute *attr,
>  				       const char *buf, size_t len)
>  {
> -	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev);
> -	struct cxl_region *cxlr;
> -	int rc, id;
> -
> -	rc = sscanf(buf, "region%d\n", &id);
> -	if (rc != 1)
> -		return -EINVAL;
> -
> -	cxlr = __create_region(cxlrd, CXL_REGION_RAM, id);
> -	if (IS_ERR(cxlr))
> -		return PTR_ERR(cxlr);
> -
> -	return len;
> +	return create_region_store(dev, buf, len, CXL_REGION_RAM);
>  }
>  DEVICE_ATTR_RW(create_ram_region);
>  
> 
> -- 
> 2.45.2
> 
