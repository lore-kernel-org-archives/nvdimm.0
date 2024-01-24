Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121B212C532
	for <nvdimm@lists.linux.dev>; Wed, 24 Jan 2024 23:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706140785; cv=none; b=rNQWNXUm3cfhxj/iCfhEyFZ7jThanNZ1dcJzPk3O2L3d+ZgnNNvsdazGvsnJhcIayxbj+Ku1bE/ZUQUfdrX1BcWf6Xm67dxsWHGvJoRMT7T06GE5qTQGDCXsnKQxIeCYeXT5r3juUJ5rDycn4egfkfjzEg1hQtaSQ/r4CCN1ltk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706140785; c=relaxed/simple;
	bh=KJTZmLwaZO9xpsdvzLeVxler7rLsie4jyEXqYk03/nE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eig8MI+kbbEbpfAgCKOPDLlhDpqm96j9dGltNLy05qEGAjLqNNjEEtebsDLJE2Iw8s5/Tyfk2nX2bzi5cUdBS+apc6sLUs9J8MD+DAQdy7nb3E5vd+iOLwN1neohVmdA8YixNK9ehImnt4s9YDsbXv6MnmamFPXVMi5by3O8t/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JpCakFF9; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JpCakFF9"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3bda741ad7dso4722242b6e.1
        for <nvdimm@lists.linux.dev>; Wed, 24 Jan 2024 15:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706140783; x=1706745583; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=70z9zW8c+zY1lhKSF5SMlkbQQJVCvyivNJrKkuHwb3M=;
        b=JpCakFF95ccBu0WdP0pWdJGRYiDSX3gCgKIRjZ/+i+XmzuO1bDoI9yozmut3Mu3bmr
         AuRsRJVdp5PxoK0BdQTa58Gy3LjF8XMlgJLmFAnweyaUy9VAzmOMz+gEjO8n1fm57jym
         29Ao09Id1xuUYaMokk6MgXScHYjHeCT4FDBpJcuBrdroEHBFEy2DhEpcVIdhl2JdxYoy
         /JPc9GZ9OobCV3Aa9tYtVpQ11jKgagHn+4beHwEhTd7bsrvBYpGRrL8rMKl3uT+8tUtw
         5wVxAdS4aVAkKVlIlBqDLzWsW1idPSWrjdi5XjHG0wtnP97KzAHTxuWXtlfutAaS0zOj
         uJWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706140783; x=1706745583;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=70z9zW8c+zY1lhKSF5SMlkbQQJVCvyivNJrKkuHwb3M=;
        b=RFOvEZ63iRLbsdQd97vvJ/wSx5A62Fii/9sUhUNPtOkMAZnZ3ItLhkhLR73dYE6c1+
         zOw6wWXayziUm7fo9OBEOFI7k0DrHD/BHiLcDgu64wk7l84Nn7ktzDysmJf9D+zLRg3U
         UifkSwyH02MjmsmmTvg7YqVwZ425kNMbi46j8YPc5djHZzR81492vK5xtWHOQgF79R1K
         6WQgv0DrVSXgGVs+qytDhtw2niFNMi2UKUErRjNi++UmPV8l+tbNbs7+RLwo2nJnbfv5
         2UrJVuwMijDGnAw3ZtzGa7Nc7D6trabtm1LAGj5Y794QCB5tuBcRAEVL4Gk9Ec18KaoU
         M38A==
X-Gm-Message-State: AOJu0Yzv2fbXvjSFJJDtfTprTn532MjgfUGewEqg55Au6TgWDsaQoajY
	RSLS9wlrey2yNr9ydRkp0vOy9z1RAkF6BP+Ik+8mqTDS6yiGAt0f
X-Google-Smtp-Source: AGHT+IFEzS1g+FvxtLtqxjHGtmlDWqaClEQ3FnfuXQazw35kawdhDmwwT4ef3lPAyHu3Z+d+7Rw62w==
X-Received: by 2002:a05:6808:f8f:b0:3bd:998d:60c1 with SMTP id o15-20020a0568080f8f00b003bd998d60c1mr52032oiw.17.1706140783066;
        Wed, 24 Jan 2024 15:59:43 -0800 (PST)
Received: from debian (c-71-202-32-218.hsd1.ca.comcast.net. [71.202.32.218])
        by smtp.gmail.com with ESMTPSA id t6-20020a625f06000000b006dd87826805sm2599008pfb.75.2024.01.24.15.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 15:59:41 -0800 (PST)
From: fan <nifan.cxl@gmail.com>
X-Google-Original-From: fan <fan@debian>
Date: Wed, 24 Jan 2024 15:59:08 -0800
To: Quanquan Cao <caoqq@fujitsu.com>
Cc: dave.jiang@intel.com, vishal.l.verma@intel.com,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH] =?utf-8?B?Y3hsL3JlZ2lvbu+8mkZp?= =?utf-8?Q?x?= overflow
 issue in alloc_hpa()
Message-ID: <ZbGkTHdfq0YP82YB@debian>
References: <20240124091527.8469-1-caoqq@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124091527.8469-1-caoqq@fujitsu.com>

On Wed, Jan 24, 2024 at 05:15:26PM +0800, Quanquan Cao wrote:
> Creating a region with 16 memory devices caused a problem. The div_u64_rem
> function, used for dividing an unsigned 64-bit number by a 32-bit one,
> faced an issue when SZ_256M * p->interleave_ways. The result surpassed
> the maximum limit of the 32-bit divisor (4G), leading to an overflow
> and a remainder of 0.
> note: At this point, p->interleave_ways is 16, meaning 16 * 256M = 4G
> 
> To fix this issue, I replaced the div_u64_rem function with div64_u64_rem
> and adjusted the type of the remainder.
> 
> Signed-off-by: Quanquan Cao <caoqq@fujitsu.com>
> ---
>  drivers/cxl/core/region.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 0f05692bfec3..ce0e2d82bb2b 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -525,7 +525,7 @@ static int alloc_hpa(struct cxl_region *cxlr, resource_size_t size)
>  	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxlr->dev.parent);
>  	struct cxl_region_params *p = &cxlr->params;
>  	struct resource *res;
> -	u32 remainder = 0;
> +	u64 remainder = 0;
>  
>  	lockdep_assert_held_write(&cxl_region_rwsem);
>  
> @@ -545,7 +545,7 @@ static int alloc_hpa(struct cxl_region *cxlr, resource_size_t size)
>  	    (cxlr->mode == CXL_DECODER_PMEM && uuid_is_null(&p->uuid)))
>  		return -ENXIO;
>  
> -	div_u64_rem(size, SZ_256M * p->interleave_ways, &remainder);
> +	div64_u64_rem(size, (u64)SZ_256M * p->interleave_ways, &remainder);
>  	if (remainder)
>  		return -EINVAL;
>  

Make sense to me.

Fan
> -- 
> 2.43.0
> 
