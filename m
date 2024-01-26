Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCF320323
	for <nvdimm@lists.linux.dev>; Fri, 26 Jan 2024 17:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706290948; cv=none; b=jjsesjhk8CVyLAty11yIUpyw2EAfkQKFmuC+ugEZsEQ67RJxx0+3v7nk/KbnZ1vLcnnnrGWZRViHFZyZQWLHTHUETPNpiX7lUIOKerhRj6FwAmi+DMz79e2GzX+I0X7mkoCSdy6EXmLQpzQEc4/PcC42ipv1XBEOergzTmVypXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706290948; c=relaxed/simple;
	bh=8fTm/4bikTj6WePExouWXSPkmpSnSS6RPuI1d6OHnvg=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lb27t+rG/O8/ty8AumwGgfQfegxXh/idivBAMsEp4KdMqbEurWULfxeGwWzK5G0Sz/wu4J0krqPH24sq7CVKrihOB0DnAKDWaMVNX/54Q9cvidtpEn/C8QhQU7q5MwBHeibQVqMEwqMoBaFtbIF89BYn9BNvInb/M+wqVculzNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TM4gw2BmMz6K8wq;
	Sat, 27 Jan 2024 01:39:24 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 26E52140B67;
	Sat, 27 Jan 2024 01:42:24 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 26 Jan
 2024 17:42:23 +0000
Date: Fri, 26 Jan 2024 17:42:23 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Quanquan Cao <caoqq@fujitsu.com>
CC: <dave.jiang@intel.com>, <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] =?UTF-8?Q?cxl/region=EF=BC=9AFix?= overflow issue in
 alloc_hpa()
Message-ID: <20240126174223.00005736@Huawei.com>
In-Reply-To: <20240124091527.8469-1-caoqq@fujitsu.com>
References: <20240124091527.8469-1-caoqq@fujitsu.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Wed, 24 Jan 2024 17:15:26 +0800
Quanquan Cao <caoqq@fujitsu.com> wrote:

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
Good find, though now I'm curious on whether you have a real system doing
16 way interleave :)

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
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

