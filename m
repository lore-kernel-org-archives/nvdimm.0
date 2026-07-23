Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC803F413F
	for <nvdimm@lists.linux.dev>; Thu, 23 Jul 2026 21:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784841002; cv=none; b=bF7UCN7zlrILTCQm4yr7rddDc1DKWdsAiaj5xOPX9slDTFQ+DeScawvNhl70RICaqMASfY2lFKiNXeDP+7YMunyV36tD1+piuafsgCz8PI1CyAzzjCMLQ68CtVfQ+0p3drCqp11WhLG0VHL2Iox7zR4Cvjy238gtqEls8zxssCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784841002; c=relaxed/simple;
	bh=4+uHhvl4ekiShMxILePB/Hv+4TfepbgDvx313qgvA+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V4IKEg+GHjPVzJfeSkEp8LkaSNdQhE0BbjlQjidApe9XMl7qdUx24Ba9+3lgJTaOG6xKpa6zQuQJ25TkxGGc3O7F7EWOTJNJ8/jPG0xZDFh2jjm9iwCWs5ihG2yMhY11yPLm8GGXhEnhKPcs0HAzrto0jEvatKj8JVboo350bgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zm0kQ30n; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zm0kQ30n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784841000; x=1816377000;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4+uHhvl4ekiShMxILePB/Hv+4TfepbgDvx313qgvA+g=;
  b=Zm0kQ30nzimd+XaDsEPU/tT4NAsDpCHK8m+jYMVrtDITacWC6pRdWixw
   VUfGCvvjA7aHlAxcHIqXVL0SfTEhM+VdeeXJ9EXgJoPG0w4KJrQXSdIqF
   HcYgWVc057gsUUhNVYHE/F8F8qfV+1unYiBJTyFP/567c1pKtqKfEqY/b
   2TNSQYLtemLd9tpAqK0RhYBRiHlSDojxfUUG+rXNE5pzj68Dp2MKzaP1I
   yOUovSc0VkJGHujC++aPy9pzxgKm6aw4/TkrWHbLKZSf3CnZBZyNbZ6jy
   UcaImvnMATIt3Z7eSCQ0xzO2YM800N08DIMtTavVgoc4h18V2D1Hb+5nI
   w==;
X-CSE-ConnectionGUID: anNfxcMzQDio6gmf8t2Hrw==
X-CSE-MsgGUID: /BFYk0FZTY2GeLp/2WNqsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="108296319"
X-IronPort-AV: E=Sophos;i="6.25,181,1779174000"; 
   d="scan'208";a="108296319"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 14:09:58 -0700
X-CSE-ConnectionGUID: aErLyPvBT0qnWRftOEpQyA==
X-CSE-MsgGUID: pXRO3lp8S5mXMQxB3bOm7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,181,1779174000"; 
   d="scan'208";a="263500447"
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.110.160]) ([10.125.110.160])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 14:09:56 -0700
Message-ID: <7cae90ce-832b-4262-bfb0-960f1ec69ac6@intel.com>
Date: Thu, 23 Jul 2026 14:09:55 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] nvdimm-btt: clean up kernel-doc warnings
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, nvdimm@lists.linux.dev
References: <20260721172132.3718892-1-rdunlap@infradead.org>
 <20260721172132.3718892-2-rdunlap@infradead.org>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260721172132.3718892-2-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/21/26 10:21 AM, Randy Dunlap wrote:
> Add one missing kernel-doc description and drop one that shouldn't be
> here in order to avoid kernel-doc warnings:
> 
> Warning: ./drivers/nvdimm/btt.h:232 struct member 'nd_region' not described in 'btt'
> Warning: ./drivers/nvdimm/btt.h:232 Excess struct member 'lanes' description in 'btt'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dan Williams <djbw@kernel.org>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Ira Weiny <iweiny@kernel.org>
> Cc: nvdimm@lists.linux.dev
> 
>  drivers/nvdimm/btt.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20260720.orig/drivers/nvdimm/btt.h
> +++ linux-next-20260720/drivers/nvdimm/btt.h
> @@ -210,7 +210,7 @@ struct badblocks;
>   * @lbasize:		LBA size as requested and presented to upper layers.
>   *			This is sector_size + size of any metadata.
>   * @sector_size:	The Linux sector size - 512 or 4096
> - * @lanes:		Per-lane spinlocks
> + * @nd_region:		&struct nd_region pointer
>   * @init_lock:		Mutex used for the BTT initialization
>   * @init_state:		Flag describing the initialization state for the BTT
>   * @num_arenas:		Number of arenas in the BTT instance

