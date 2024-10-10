Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086921CDFC3
	for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 16:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728577649; cv=none; b=qZ980dJvJr/2RsQg3ykBMdUBl5psAXNpv698bYERHVgfXZInxpP8BJYoGlmN+tR0IK+MnmB6q2E4D68vOGjfksd+0/DAYq1ZQGbJI8XmxLgCemvGrI4ufRl1H0Qr6PSPqIM9TG1XzeV7CgSDabWH8x6/WEB8S3vHCZobF59geuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728577649; c=relaxed/simple;
	bh=EezNVeA2uyxOZbiJHcAoytd4T0u9uCuZE27/ZijVLTA=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axRx52cq4mvMxCWYTRkhcW4P+8MD9rxtyY6WWNrDmpLtNiF6IE6dvrYFZQpH1YPWqL4oPUnV7SS5rIEnPeM3iT9nTh4RBwrk4uULBH9Pix5uS06KYcRgrAr2PxgjuorPyqiJFjr86Sdt1Mv7Xg9VY2sJxKHtiq/QILYYWKHwr60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LxGAvPj2; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxGAvPj2"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-71e02249621so924196b3a.1
        for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 09:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728577645; x=1729182445; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fSLzl5yBihgiBmsYyY0ZLdSXzjCf12rYeXArERj6rDI=;
        b=LxGAvPj2M+9+sgpQah9kQzaeTA3nIppULiZqGEpjAlsL4Puwkp+F7YN8IrTa1EJhRm
         3lTdTkXC7YY9FGznhJcZCB0drl693HEkbpwAaxpWCTsPA53QxkKXqCC2ZwTUel7EnRYG
         5OuoTvTKiDUplX0utRV+88RmWFFbdQjK6MRhcfQZWY1IcRsDNLQvyBjHmCRMXSIG7df1
         k1/AzqgB/LMf3s7lEOkFnxY/YfDqK+Wb24cZj+l5kqAqQazuF5DS8mf3AwffbMAqDbXl
         wS9jfnaWFP+7IXQQdOiNJn3nUlGSQ5hr9EMNQzDZ9WFajT0ncuFC0nn44au6LL8oCkIm
         G8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728577645; x=1729182445;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fSLzl5yBihgiBmsYyY0ZLdSXzjCf12rYeXArERj6rDI=;
        b=jCPm0eniO36FPIMyCA/ajeekXvWvnZ2rU8H4uHqKqHkBek0pyemAvGyxwEwlukAlj7
         1ohHYjadOXpx9UEB9euUWfgDU7VVNzM+rlqiMuW4aH1lzryZBhQ5sdulqhCW0AgwH6fx
         /AumaJfSA+tly9L1IYk6XjOwj+fBB54VFenwsItwoak6yyeHC5DU1lpzd3fSeKs+K8qb
         H7CIp0jnOpM5DPtEJ7aKfCzJf6X3hqfJJZmZ0dhaZVCtugL7FNYVjU2jToiT6AIuwQKX
         k+b6zNTjVB1PAkoh/B5t/dQBB87zQVANicpZbiHLHNUhs/U1L0CnWZYZsSs5bTjQmo1c
         2Jjw==
X-Forwarded-Encrypted: i=1; AJvYcCU8QEApPw95LyhoKqtcRMj5/MGDxUPT/zdGSjer+lCcu/fe32A7dxW3FfKdMgFMOrtnJXw7xp8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2dqhdqiv9wsxXZwuBeOaSlb/Q2V6XZP//cww9tfO/qXzhgrka
	GsIluokGKY8M5HMlRi9kdyhSvYIubRzW4gW1We0qJaQ0+EcRP/Pl
X-Google-Smtp-Source: AGHT+IGIsf4f/iQQgXnwF0falPkwr2nFCnUFSLBEZqjJbFXQB+jGFOTfXuGfIuYojsJ2HGj2GIYvYg==
X-Received: by 2002:a05:6a00:2e9e:b0:71e:2d2:1de4 with SMTP id d2e1a72fcca58-71e1db6485emr10418466b3a.3.1728577645027;
        Thu, 10 Oct 2024 09:27:25 -0700 (PDT)
Received: from fan ([2601:646:8f03:9fee:c165:c800:4280:d79b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aaba3a7sm1200121b3a.169.2024.10.10.09.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 09:27:24 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 10 Oct 2024 09:27:03 -0700
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
Subject: Re: [PATCH v4 15/28] cxl/region: Refactor common create region code
Message-ID: <ZwgAV81DSbpW7Ezd@fan>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-15-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-15-c261ee6eeded@intel.com>

On Mon, Oct 07, 2024 at 06:16:21PM -0500, Ira Weiny wrote:
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
> index ab00203f285a..2ca6148d108c 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -2552,9 +2552,8 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
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
> @@ -2564,31 +2563,26 @@ static ssize_t create_pmem_region_store(struct device *dev,
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
> 2.46.0
> 

-- 
Fan Ni
