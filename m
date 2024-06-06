Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F3E198841
	for <nvdimm@lists.linux.dev>; Thu,  6 Jun 2024 16:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717690281; cv=none; b=h4jP8Tw4LuMf75sPIWfGLbbq+ciH6tOYtIabB3pmYfE/zr8yCfNemuD3nk+QGGyy06vbsNmH+ktjGipBfEZBqAZ33tUg269O4BOBCsz/N0Bcfleg5Po9SsyLcHNzQdtX0YjxxOFqPLn+TGc4L3qNkhdFk53ubFRQMcFz5gN09l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717690281; c=relaxed/simple;
	bh=EouAagpep61jA1tkJh5qPmOHoRUQb4lmBEbh90kZRwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VhifWrPcHsJ5Gbac2gMOKudKjr4cxXOYs9Cs0nwu6f+930FfZB/MKfgLCq5Wl03/uGgyU+HVNCUWjExyk7YR+UPFYWV+oEafUHqgpZM9ShIaulki6eUYllq1BJtIHErdVQIkPoPKuuhE/ER4UQu1W7YO1P2rz2/QwhhmpQ+vkQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OaFXcok6; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OaFXcok6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717690280; x=1749226280;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EouAagpep61jA1tkJh5qPmOHoRUQb4lmBEbh90kZRwc=;
  b=OaFXcok6n1CoL2KuGT7qrFwePOGmm9pO8VdRcQRYL7YmQZrE8Z5BeeDu
   Gg4NkCedxA9PfC2cRzLoJR1fq+DJOvRf9ohRp6Hcc64QCgrJ75OQfgEIy
   s0G6gY0yLcpqxw/YyucIM9ZXFX85LSBcFrEwbVst9GeMEEI7lGqgwzyy6
   bMNCyWy5u7jHpHrfk8xVVZFniCwi+xpKyDvS6UHl12+IasLizwo5ByY9M
   Aut3JDleTxb9EVhyHoWii1BiSd9wlmOE1sruvBzIs1dikrxCRoFSjrybo
   eAG7069gX3Bxg2aZE04M0j/gcliRdYccmC2zuVHv+Fi0PZDAwDRy78vBy
   Q==;
X-CSE-ConnectionGUID: cB7jCXfkQdqfwjPzpUK5fQ==
X-CSE-MsgGUID: PqGY4RkdQdW331HypD/Ong==
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="14525407"
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="14525407"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 09:11:20 -0700
X-CSE-ConnectionGUID: LTzS1sx2QHC9CkgSFMHcfQ==
X-CSE-MsgGUID: /kKnSnQoTwWrIAFgmczGpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="38696127"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.125.109.168]) ([10.125.109.168])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 09:11:19 -0700
Message-ID: <4dd8ebe0-868d-4125-ad23-c5a8b5249ce9@intel.com>
Date: Thu, 6 Jun 2024 09:11:17 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvdimm/btt: use sizeof(*pointer) instead of sizeof(type)
To: Erick Archer <erick.archer@outlook.com>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Kees Cook <keescook@chromium.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Justin Stitt <justinstitt@google.com>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <AS8PR02MB72372490C53FB2E35DA1ADD08BFE2@AS8PR02MB7237.eurprd02.prod.outlook.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <AS8PR02MB72372490C53FB2E35DA1ADD08BFE2@AS8PR02MB7237.eurprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/2/24 1:18 AM, Erick Archer wrote:
> It is preferred to use sizeof(*pointer) instead of sizeof(type)
> due to the type of the variable can change and one needs not
> change the former (unlike the latter). This patch has no effect
> on runtime behavior.
> 
> Signed-off-by: Erick Archer <erick.archer@outlook.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/btt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 1e5aedaf8c7b..b25df8fa8e8e 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -751,7 +751,7 @@ static struct arena_info *alloc_arena(struct btt *btt, size_t size,
>  	u64 logsize, mapsize, datasize;
>  	u64 available = size;
>  
> -	arena = kzalloc(sizeof(struct arena_info), GFP_KERNEL);
> +	arena = kzalloc(sizeof(*arena), GFP_KERNEL);
>  	if (!arena)
>  		return NULL;
>  	arena->nd_btt = btt->nd_btt;
> @@ -978,7 +978,7 @@ static int btt_arena_write_layout(struct arena_info *arena)
>  	if (ret)
>  		return ret;
>  
> -	super = kzalloc(sizeof(struct btt_sb), GFP_NOIO);
> +	super = kzalloc(sizeof(*super), GFP_NOIO);
>  	if (!super)
>  		return -ENOMEM;
>  
