Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B0A1802AB
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 21:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730843220; cv=none; b=n4qw06SO9oAEHhtL41F6EW+A10M3IMnycowXg0WdryIzWN2sjjzjbVQlk0b4Slfsy0kcpEJvJa8MWOayAHrhF58r4ogTjgM6D7bPkrKOhwTDMHxZLUOf+0YqfX/GDEgb8JNZbKUVOtN1UMPjL1o/6p35N2lk7j6PyQwU33jISMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730843220; c=relaxed/simple;
	bh=YiVmK3HiMjGzBsQGXN6Ndy+g2Z3vFGA5JWpjY/w++xE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hgAX1wFIxKyCK5LqT0ZHV6geDpSVrCT//7coK6Pz7XqUbRLkPGQxjK1Yj3kZkF/rMgoN+Ba3jKBBwEjXPPy0CUxcnVng8A4NWsTGMAWlb0V2GIOJG1Hq0EWM0imXiuOVRJ/IVBbI8dpt3oCV5c/ASuq3o/JxzLei89UoG9bw5Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GfKqRDTl; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GfKqRDTl"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e28fe3b02ffso5275334276.3
        for <nvdimm@lists.linux.dev>; Tue, 05 Nov 2024 13:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730843218; x=1731448018; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ezOZFwAiYg3IQIIGkQCkTQ4DdSvG8zebAANzDgboVys=;
        b=GfKqRDTlANaMpEwOySgILAdQ23AG21x2vsccQC6YBMGN82X+mMvb7xqjs/eXuXrKAg
         Fh9GVyqa7NJbTiPPWGI1hnmVZPWlW96jlGQDqTOFZW+1EAkzDpYBWg27hWxo8y0uJfc1
         FEfpjsI/OvbGTNmOd0iPR+k+/O1XOHwrxtUSqbsHA2Fznjo23G+ehDTn7J8Wbh3d7GFH
         KlkAMhUreGQnhqOs2jVo1U8sGXxv0Sk7T+TxpEC5wh4S603qcRuK6b82fePfvtD1jbcu
         FY01dIYT9Hp4ssTqLJKC1edDH9QPEPQMhY3+rOQQ9nkRivhm99rkYKHX0Tix410vE5M8
         /kNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730843218; x=1731448018;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezOZFwAiYg3IQIIGkQCkTQ4DdSvG8zebAANzDgboVys=;
        b=IR1HJobhyBRM/fphCIHNKmUGELsba1D0hLpgGyVXmLGSNEOfz/+2lAp2tk+UdcyAma
         4r7Qj7+i5SFvmD0KS0Fe/VbeNkjlQzQfsOaAhi81AvecuE9SyZ3bFUS3SOw7b7YtXubW
         vQnteswA8qxottE6gnvhvgiWEyG8x+b52wxnEnFWSsecCNfVwzHFtfBfZKFe+j++N2i7
         deQzlAjs+JbO1cFUBJNjNT8ZgcJFty61H8Rx3RQRw3NdPhb3Cm60Oe4TC9ErXvOCcZ5g
         5YP7AsCDsfoIM0tZVBXLOJ0nU9AizWZ1f6TDmN1c1Sm9zQJJ4zpr3snCqGxfJW6D6lO7
         Htmw==
X-Forwarded-Encrypted: i=1; AJvYcCWNUO4YCUsPKSefHQ7kXfKWhhJS64hB51KQ9DjjnUNTSaN73uNqYebYpFat2wepPgemKg7VdfQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8sAnhCft/e99wdtyC0ulPlSPnilQf+oQzuyvrXc397UG1w/zS
	GOWVku68XXshDO381Gr788XpN/k7C7alWCr1Udnxt7Wbui3N7Rzn
X-Google-Smtp-Source: AGHT+IHlxnHGg54ndOhGrFPFxmOAASymk/nP5lokz8SdATwfxRccSlsSM8ESlYsWQeJmSy69VggeHg==
X-Received: by 2002:a05:6902:70a:b0:e30:c977:a362 with SMTP id 3f1490d57ef6-e30e5a1a950mr19305273276.7.1730843217729;
        Tue, 05 Nov 2024 13:46:57 -0800 (PST)
Received: from fan ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e30e8a9a269sm2620822276.37.2024.11.05.13.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2024 13:46:57 -0800 (PST)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Tue, 5 Nov 2024 13:46:54 -0800
To: Ira Weiny <ira.weiny@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2 2/6] ndctl/cxl/region: Report max size for
 region creation
Message-ID: <ZyqSToxjsMlXC2NR@fan>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-2-be057b479eeb@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104-dcd-region2-v2-2-be057b479eeb@intel.com>

On Mon, Nov 04, 2024 at 08:10:46PM -0600, Ira Weiny wrote:
> When creating a region if the size exceeds the max an error is printed.
> However, the max available space is not reported which makes it harder
> to determine what is wrong.
> 
> Add the max size available to the output error.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Fan Ni <fan.ni@samsung.com>

> ---
>  cxl/region.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index 96aa5931d2281c7577679b7f6165218964fa0425..207cf2d003148992255c715f286bc0f38de2ca84 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -677,8 +677,8 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>  	}
>  	if (!default_size && size > max_extent) {
>  		log_err(&rl,
> -			"%s: region size %#lx exceeds max available space\n",
> -			cxl_decoder_get_devname(p->root_decoder), size);
> +			"%s: region size %#lx exceeds max available space (%#lx)\n",
> +			cxl_decoder_get_devname(p->root_decoder), size, max_extent);
>  		return -ENOSPC;
>  	}
>  
> 
> -- 
> 2.47.0
> 

-- 
Fan Ni
