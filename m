Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B651B36B919
	for <nvdimm@lists.linux.dev>; Mon, 21 Sep 2026 23:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790032207; cv=none; b=s+1nnj3YoByabIJroFZVzaURAzNu/rM8DA2DCK59/u8t6Tc/ofzsv/FvogG9NAqSfVt/JGVJZ6nENAbZjsGSWQsuJS3TdelR1XKwnkWYnrs4AkgN0tWj8pnj/XwbI4kxD9HF1KrpviYIUwJ13eth0cw0cGwdYFYssx9Cfp6QqIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790032207; c=relaxed/simple;
	bh=exHguLL9nfQTKnWjN14mQ3Dyari+LzvD0kVIeaz2a+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sbp73MPA73sHizEhSS65Pn0e14nYRYWBZxr1i+O3EeFxP/SQtEDu3Bhomv0j2TTEW0bUVFXS0WZRbrK+VeXgElYklySmEjkxrLQJT17bPywCK0aWMYWOTFcuOYN/OyqN0Ur9HPrc2aBZjKSoNBUeQU76MBtvN1lre99bwKSHlqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yt3/ryv1; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yt3/ryv1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790032206; x=1821568206;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=exHguLL9nfQTKnWjN14mQ3Dyari+LzvD0kVIeaz2a+A=;
  b=Yt3/ryv1hkH90cFkfv+YdDeJL2CcFHVe0Nu5bfIuybJgawX0So05uYjQ
   wX+/OU+tE4xa3RvXyq/Rhu8nZDCWSSW79LxAyqHVt6eApyizyrEAX/HRy
   KlX0jtEYces3JCHQBqVBMr9r0dlboe5t3D4bdY6qG9aGVt6w10XjNZJqh
   WyDadbHoGkn/c8CQH5m/sewpZ5xvlEApIl+ujBnzJOi5Y2hvu2xrnd5//
   lUpSm4rCVBJinfU2/WIBfMSJ6pqQxIzNm68YNSnxSpqi3Nf+8p3DuxLEW
   itTZeaIjs1T2doyQsOOyzEvSiYd2ng0948/97cFPZLoHBr9eqDhDVXV28
   A==;
X-CSE-ConnectionGUID: 6NlmJZ0lSA+dnOyP4vnHmA==
X-CSE-MsgGUID: AggF0yb8TRe5U3p4mxSfIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="90607673"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="90607673"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 16:10:05 -0700
X-CSE-ConnectionGUID: Jq/OQVBxRLer427WLqsDLg==
X-CSE-MsgGUID: KENvzc6CRj+dUCte1AgDvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="277649560"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.109.234]) ([10.125.109.234])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 16:10:04 -0700
Message-ID: <f78c491d-588d-416b-ba77-54bebf7b6b02@intel.com>
Date: Mon, 21 Sep 2026 16:10:03 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dax: use assign_bit() where applicable
To: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: linux-kernel@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20260919130750.3041470-1-peng.fan@oss.nxp.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20260919130750.3041470-1-peng.fan@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/19/26 6:07 AM, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> Convert open-coded if/else with set_bit/clear_bit to the assign_bit API.
> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/super.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 45f84b0eb909..60c4aec52ae1 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -385,10 +385,7 @@ EXPORT_SYMBOL_GPL(dax_flush);
>  
>  void dax_write_cache(struct dax_device *dax_dev, bool wc)
>  {
> -	if (wc)
> -		set_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
> -	else
> -		clear_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
> +	assign_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags, wc);
>  }
>  EXPORT_SYMBOL_GPL(dax_write_cache);
>  

