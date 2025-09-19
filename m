Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31BA1B87C0
	for <nvdimm@lists.linux.dev>; Fri, 19 Sep 2025 23:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758324856; cv=none; b=EroLMv6yMBKl0ChISFaREBxgjzZkn7GYuL/kiJH6njLVvT7mYgCNF82DX3qPhMz6Y+Woopl7/AZcpb69AU/rBU9SL1c07RfeS1Ve0htPXhHq1d2JSljD2KDtCkQjErLkhwZXJT2Tsu77dzcD7K3tqIpz4t6awMdzAA/PYnKA8hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758324856; c=relaxed/simple;
	bh=d3zGKIZuyyxwE/xv6aG96jzmf4NvjpivczUTXWgbtI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=efFn/V7QnBejdne1pR+jI9VKygmM433PFdD9cDhWXmlomXjw94jcn+slIEdBS7o1i+ZE/8dPx4ElanJ7deXbkNDydzxOd0x5jkw3Y3AlpvbPOhXzY6xfix/trkZlow3aOyjCrDihxSdVCluemJ3HRNO4S3gWDaeksnOPaTfyVB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aRxFc2qG; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aRxFc2qG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758324855; x=1789860855;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=d3zGKIZuyyxwE/xv6aG96jzmf4NvjpivczUTXWgbtI4=;
  b=aRxFc2qGAO+1w9A0gG9N1XzxxE1cYqPEScdTYzWdf4HI5ca6mVhR3Vca
   JUb490iE97q/WDcVcu78eYxRU3d7xzKLIOCOOOgsRkcm+LFDRjGpL3BEU
   Nh7PgDP4LzTrwzq5RcD3YIIP3UJBfkKTVYz3WeYzf+pslX3iYx02ub05X
   uQg89x5NIUiqmmORkNuSz+rSJHWuNGnzvdcnY8+Nlq2qdV1pxlbTjtS5W
   NVmS/V9dxPITicfnKO1XM0X4rBAfQvoemi38p+13+8T3xqCC4rtAEdYs5
   u35RUsxV8RV1ryP1kqS2Dz6t/n6Y/d/4C42rCLfGjt9uUfx7uwRmPMkgN
   A==;
X-CSE-ConnectionGUID: RBwGa8GRTc6A9enyO1WTGQ==
X-CSE-MsgGUID: 1g45JBO+TKqoSnLH1/TIdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="60605495"
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="60605495"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 16:34:14 -0700
X-CSE-ConnectionGUID: Hr0PMIDuQXyiWPCP9RSxMg==
X-CSE-MsgGUID: zYOEuUsDTZOM3cJm9apd9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="176390562"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.108.58]) ([10.125.108.58])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 16:34:13 -0700
Message-ID: <7622b25c-a0d8-47b6-910b-9b2e42e099e4@intel.com>
Date: Fri, 19 Sep 2025 16:34:12 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 03/20] nvdimm/label: Modify nd_label_base() signature
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134134epcas5p3f64af9556015ed9dfb881f852ea854c4@epcas5p3.samsung.com>
 <20250917134116.1623730-4-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250917134116.1623730-4-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/25 6:40 AM, Neeraj Kumar wrote:
> nd_label_base() was being used after typecasting with 'unsigned long'. Thus
> modified nd_label_base() to return 'unsigned long' instead of 'struct
> nd_namespace_label *'
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Just a nit below:


> ---
>  drivers/nvdimm/label.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 0a9b6c5cb2c3..668e1e146229 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -271,11 +271,11 @@ static void nd_label_copy(struct nvdimm_drvdata *ndd,
>  	memcpy(dst, src, sizeof_namespace_index(ndd));
>  }
>  
> -static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
> +static unsigned long nd_label_base(struct nvdimm_drvdata *ndd)
>  {
>  	void *base = to_namespace_index(ndd, 0);
>  
> -	return base + 2 * sizeof_namespace_index(ndd);
> +	return (unsigned long) (base + 2 * sizeof_namespace_index(ndd));

Space is not needed between casting and the var. Also applies to other instances in this commit.

DJ

>  }
>  
>  static int to_slot(struct nvdimm_drvdata *ndd,
> @@ -284,7 +284,7 @@ static int to_slot(struct nvdimm_drvdata *ndd,
>  	unsigned long label, base;
>  
>  	label = (unsigned long) nd_label;
> -	base = (unsigned long) nd_label_base(ndd);
> +	base = nd_label_base(ndd);
>  
>  	return (label - base) / sizeof_namespace_label(ndd);
>  }
> @@ -293,7 +293,7 @@ static struct nd_namespace_label *to_label(struct nvdimm_drvdata *ndd, int slot)
>  {
>  	unsigned long label, base;
>  
> -	base = (unsigned long) nd_label_base(ndd);
> +	base = nd_label_base(ndd);
>  	label = base + sizeof_namespace_label(ndd) * slot;
>  
>  	return (struct nd_namespace_label *) label;
> @@ -684,7 +684,7 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
>  			nd_label_next_nsindex(index))
>  		- (unsigned long) to_namespace_index(ndd, 0);
>  	nsindex->otheroff = __cpu_to_le64(offset);
> -	offset = (unsigned long) nd_label_base(ndd)
> +	offset = nd_label_base(ndd)
>  		- (unsigned long) to_namespace_index(ndd, 0);
>  	nsindex->labeloff = __cpu_to_le64(offset);
>  	nsindex->nslot = __cpu_to_le32(nslot);

