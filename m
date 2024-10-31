Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBD812D1EA
	for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 17:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730397419; cv=none; b=Kz6ncedkR51EfHCwXnycWUT7cbkIugJAP49fdweyj6uI2tqKvSaleVrXMNjdK3lvimwIYqfB4eLqet+A14djlkWUgD1hxHTP/vU+i/pivbLlk7ijpdYpKjgQ0F+VeMSsuYwJ9j4mYdudGL+hQmoWmRLYascsQ9T8RTULyNWeu/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730397419; c=relaxed/simple;
	bh=yUrGa8onY4ccgE2ialpFQmrSM+ZgSnzvmstuAkksbZg=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tT8W/UbbAoSSqsRYnsEaKA1sW/yFnx6dsvLqQsuvjZAz677FsWnCQg7lDuoLp0GNuii3Fxh45UIbUllvqoooWcWo+72WzBrNRDnkUvb6d3IqoEtSPafwuYajg0Hx2GejWdgi5XrapgrXc3P3bdwziEcYq/ArN+Ujy72XXZimAlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yarzf0XS; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yarzf0XS"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20ca1b6a80aso12306315ad.2
        for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 10:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730397417; x=1731002217; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xPlQvdXSsJyU2fKdSpUte9ErFeNJjpab6hJvuIBFdso=;
        b=Yarzf0XS8wy9LnQoM5MeWDXspbUIs9u8+aZ6LHMBhWquW1DJuGyKmmwzb6rLhN+jkT
         1K5v4M0daApdEWhQPj174H1rEz1TSxvxaYpk8GzwGM2xk6Vc6wbiZN3pLHil8wJzdCkg
         jiAv3JNJOnCyHq+yaOgFqG9L5jR//8CYQTty+7Iuex5RcWn4klukqN0aO5ONfPzxhmYZ
         BEOyl9bxm4yM0+UROKaFy6eNrBrWtwqeLg7dhoBu8JQLjYlaNabezTeWqNHOeLrM9IOW
         GrOUvNyeAox2gLBH4CuFqzBbBNAaAftSI+Skvb27IlGFX8NDsanbNwikOXRMqncL7tPU
         rGYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730397417; x=1731002217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xPlQvdXSsJyU2fKdSpUte9ErFeNJjpab6hJvuIBFdso=;
        b=Ah1/BArTZRS3S4yVewXv09lo0xcJJIdjtEBnCX/9VHiHC/NSAQOet5fOMmSmOUhRH1
         LW9ksbp9vqLdYezEUnx60If+Q+XnswRxewxx5ksiPO+rC9T/pra4EbsuGzVbuqbn+LhD
         G57wQIGOf7QZ4w8wsuT4TPt6y+ozp9Q/JJVrsgWhO3PW1XbOCEWTT3HcQtEjggNrno+O
         xCBU2vA+oV+AEe0TH/pqL0PK9DzFp1hZN45ahakoyG/ZaeTMquiB0RYr7HiQTf5jT4JF
         0XhwS6AAt0N6UMqnkVvthCSQ2mqK4zackPVpZ8JpyNwPxao8PaOCCLdv1Dxv2IK/ZQ7X
         XU9w==
X-Forwarded-Encrypted: i=1; AJvYcCXfgTsYc9k8+luzxynLfJNzKiJ6CuCu+CdEtWWMXdtOCoquMXID/EmzDwB0Y1uI5pFnMjSULik=@lists.linux.dev
X-Gm-Message-State: AOJu0YzegZ+B0z7aGfnYdoJLWPhGUwBmWGCm303ODqSsjO7VlLCaqOzN
	/O+w4NtTaACb3yTAfYl22LXWB384UZ//V1VWW2AKPas95EjeQluC
X-Google-Smtp-Source: AGHT+IFJBfjOi6GCB1tdNfaLp+8634MByXEAM27CFxqvhbEMMGLX4iRgqvOmwaKG96MtpboAxtimnA==
X-Received: by 2002:a17:902:d488:b0:20c:a7db:97bc with SMTP id d9443c01a7336-2111af1756emr5410975ad.12.1730397416730;
        Thu, 31 Oct 2024 10:56:56 -0700 (PDT)
Received: from fan ([2601:646:8f03:9fee:1a14:7759:606e:c90])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211057c68d8sm11212555ad.227.2024.10.31.10.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 10:56:56 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 31 Oct 2024 10:56:36 -0700
To: Ira Weiny <ira.weiny@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH 2/6] ndctl/cxl/region: Report max size for region
 creation
Message-ID: <ZyPE1LG1LQVrLMwl@fan>
References: <20241030-dcd-region2-v1-0-04600ba2b48e@intel.com>
 <20241030-dcd-region2-v1-2-04600ba2b48e@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030-dcd-region2-v1-2-04600ba2b48e@intel.com>

On Wed, Oct 30, 2024 at 04:54:45PM -0500, Ira Weiny wrote:
> When creating a region if the size exceeds the max an error is printed.
> However, the max available space is not reported which makes it harder
> to determine what is wrong.
> 
> Add the max size available to the output error.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---

Reviewed-by: Fan Ni <fan.ni@samsung.com>

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
