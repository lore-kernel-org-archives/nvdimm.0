Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C511C8E0
	for <nvdimm@lists.linux.dev>; Sat, 15 Feb 2025 05:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739597506; cv=none; b=UuxiL1QudLNZh6ZgykD9ZLxiaHadeMfhpi5B+AngJ82j61aAKG6qCDYKPDS3fWiYrwOxRk/4/elaIs1y1zEmMv7dUiEtvzSy2dbMe1dpDzlm7c1TpX0yzfkB1vsMouVObiqU8MgA+sNGcE5s8eekfJQxM4pQMeTG4eJRnAbQm7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739597506; c=relaxed/simple;
	bh=3dRHaR5rll499YKe2Mv2k5msIJ+yNKNKnReR+Jn5dJw=;
	h=Message-ID:From:Date:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fJNW5mpVRdtKMsxSJih3oqiidf6sDtnnXz4VhU9RLybOc/eQMybVsT+VZDUaoqDwZ5ED96oa1McV4DznQ1tsi9A7/V6xJE5pAeY4IeKNyRLjZl7h0qaw8Aj2sDbA9IbmVqTJzhLC/7prCVscnKUKwGvl0PSJFhoEsauSB0X0fa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FLTRBbdL; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLTRBbdL"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2fa8ada664fso4386665a91.3
        for <nvdimm@lists.linux.dev>; Fri, 14 Feb 2025 21:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739597504; x=1740202304; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:date:from:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=KTmsz7aBaMraFMRnH0ALQy2FOpyB1fYrB6XU3fJoMJE=;
        b=FLTRBbdLMlu88eHmqgY4lOg4AdYd6mTbv58GLXv7Cq7ENav6ISpre0a0am5Mc9Y7oX
         PqIxRYnEb6pu3bg+EkvJPgTtuV+z9SkLwKRDP2lS4s12PyJhtyBCFxAmIdHjneCh0hTO
         CmfYrxd6u9TAIeIhvmTH55juSd/mwa/ww0IrMRVwUumjRBEKCl+9EkMFuaqTsTEf2Mel
         SrSZvIUVkbfhpMMhZ1Q0n2X0PLzVkPQy+fJlxAxlz3p6+qOmfvcxVvPcQ55wXJKv+SzA
         aSHsx1500TpYNa2nDbephcCxOtjUzb2ARpOkvusSquNjTQLOidef5+h36PfBOC6Llg1J
         kGGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739597504; x=1740202304;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:date:from:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KTmsz7aBaMraFMRnH0ALQy2FOpyB1fYrB6XU3fJoMJE=;
        b=kAW8yT3bddjNhb+wgWSvi+T8K/HnhI6TMOzYiv6mxqa9d1wXF0+UKXueUCfPKgr/jM
         fmq/d0ovpCaqAD+a1iGtTWmUMGGhreDd+SMEMU9SKYH1Bemg+RWtWl+PJX4ISPR4Uk/E
         dmFPxASNAeqwD5Ll7yND4YQyeDGaKqLck/l4OL47oocybQEzJkcwbd48EdScbaYvVkPk
         SMefTygC2Cibaur8/YoC4sqhJ9cnCMkeH5D3MiHoAmAR+Z6rrqWQMAWN8AhklHD5QU6A
         YYPElZPZxNpob4fQjp2i6ZAnRqDQNfNy6mfOiHgYT2fWvGWFDXZhuoahD98M245sFMIG
         FBOQ==
X-Gm-Message-State: AOJu0YzwW6s2u8/5p3S13B056znTsAnkx68xokPSQQKHQwPEpkHwPlpV
	Vr1E2PHIARfapZedZpUoW1m9vMCTr7PyjgopLsJOppxnKvQUd5C4
X-Gm-Gg: ASbGnctIBq43grb/q3fE+x2U4dgN0fhMcxlqVtQF/w7VWJV8WSBzTld0qxT9wSkHko4
	D88Zsd2K2duhsiezHidE4p/1ZD2ARePCbH7KBj9SHFdHfxeW7S3qrOcvzbMC9Gw/HM8QysDE4FB
	R2FcD9E0DksVeTa6AQkD2TGQCx3IX/M8e48tBLs3K2OgkXUEbvUcaiE7NxwKiStsTU+RKXicVq1
	Fj9kJKt44PSTqnIxj1dV0HpPiLQsitM92KILVCgcGz0njGAYtRtUl3zm3T5Kug41YACa08Lr/mq
	ahE1AxhmgYaNp3Oovg+9ZjGDk2xt5MzgCIDNa5UnQR4=
X-Google-Smtp-Source: AGHT+IH62GPn18Tt4iWwrL0gis3tyWFj4HxEbm1DpXqKf8esU3esKQcA4hBCKTYyNmve9KSeCfo3nw==
X-Received: by 2002:a17:90a:dfc8:b0:2ee:7c65:ae8e with SMTP id 98e67ed59e1d1-2fc40f103ecmr2888461a91.11.1739597503721;
        Fri, 14 Feb 2025 21:31:43 -0800 (PST)
Received: from asus. (c-73-189-148-61.hsd1.ca.comcast.net. [73.189.148.61])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d5364503sm36852205ad.80.2025.02.14.21.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 21:31:43 -0800 (PST)
Message-ID: <67b026bf.170a0220.3a2be4.9884@mx.google.com>
X-Google-Original-Message-ID: <Z7AmvFlEaRCLNl9Z@asus.>
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Fri, 14 Feb 2025 21:31:40 -0800
To: alison.schofield@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH] cxl/lib: remove unimplemented symbol
 cxl_mapping_get_region
References: <20250215021319.1948097-1-alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250215021319.1948097-1-alison.schofield@intel.com>

On Fri, Feb 14, 2025 at 06:13:16PM -0800, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> User reports this symbol was added but has never had an implementation
> causing their linker ld.lld to fail like so:
> 
> ld.lld: error: version script assignment of 'LIBCXL_3' to symbol 'cxl_mapping_get_region' failed: symbol not defined
> 
> This likely worked for some builds but not others because of different
> toolchains (linkers), compiler optimizations (garbage collection), or
> linker flags (ignoring or only warning on unused symbols).
> 
> Clean this up by removing the symbol.
> 
> Reposted here from github pull request:
> https://github.com/pmem/ndctl/pull/267/
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Fan Ni <fan.ni@samsung.com>

> ---
>  cxl/lib/libcxl.sym | 1 -
>  cxl/libcxl.h       | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 0c155a40ad47..763151fbef59 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -208,7 +208,6 @@ global:
>  	cxl_mapping_get_first;
>  	cxl_mapping_get_next;
>  	cxl_mapping_get_decoder;
> -	cxl_mapping_get_region;
>  	cxl_mapping_get_position;
>  	cxl_decoder_get_by_name;
>  	cxl_decoder_get_memdev;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 0a5fd0e13cc2..43c082acd836 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -354,7 +354,6 @@ struct cxl_memdev_mapping *cxl_mapping_get_first(struct cxl_region *region);
>  struct cxl_memdev_mapping *
>  cxl_mapping_get_next(struct cxl_memdev_mapping *mapping);
>  struct cxl_decoder *cxl_mapping_get_decoder(struct cxl_memdev_mapping *mapping);
> -struct cxl_region *cxl_mapping_get_region(struct cxl_memdev_mapping *mapping);
>  unsigned int cxl_mapping_get_position(struct cxl_memdev_mapping *mapping);
>  
>  #define cxl_mapping_foreach(region, mapping) \
> -- 
> 2.37.3
> 
