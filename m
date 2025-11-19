Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4284036E573
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 17:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763571701; cv=none; b=ikCElNNG+yTfugcKTN05vbdTrT3IfUgNragWMKykMDcAaz7tPz7YaAQ1E9Xb/dRi06jQW0bmLk9e3azq2LqPac4p68HjHenxVfaJcI5Itl6ms1fe2LeHkPxDnAtQuvtTjmGUEUGFQRKAxNBj+aPhPCYDLpoqqewQEd3Znq8hnvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763571701; c=relaxed/simple;
	bh=u+f+KJ3IuUCaQxFkYOSmxdM0LKqlDkhUCPWUQhBs2C0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=geHkOdo0elUZXZpV50JXs1DgnkGKImMPLymuTIRJjQcVrY6GsxxhCboLzPsQaMLOh98mjMiv8/uD3wkR06nJQGqy89WtiJOgswz4HPuDpmP0OkbFBcWpp/ODHh5xSXiMg0WJ2koDxkS1s65VmEZJBezYii8Tzqpp1OO9c9xaAXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FCzwMDoi; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FCzwMDoi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763571699; x=1795107699;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u+f+KJ3IuUCaQxFkYOSmxdM0LKqlDkhUCPWUQhBs2C0=;
  b=FCzwMDoiyG6rXxcO5qXd2qZRmV7coL8JxhzjyJUxukt6OMhAGuqH53Uv
   +FgRZUQ+RSMH128q1YF11JF2nHsFXd039vKocbVXT1NMEpx6iqbJDIvNv
   PrEozAVb9jGS5lh/SddQlzS7IwuV5CVG/+y2qcv/SP34SSXhdsuisxj5N
   cxeGpONlnKAOf68r5Gei/KZwdcPavRzwgTR/pGdF87+8tZ0iJeh6TBNIW
   bAGoAccocxnvXb4aOCdIpRBJn37CV1Fz9Xn77pBvpSy6MRJ7rY9GDWrLF
   7oF2N3jFPNlLyFzHaqvkYY5nMkomvifBwmwv00LSRyinbdUqyLr1lYX7J
   A==;
X-CSE-ConnectionGUID: 6q8+vHbGRcuy9dSlO6g2OQ==
X-CSE-MsgGUID: 72KAbc0wRgysCnrvRROGcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="75948395"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="75948395"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 09:01:38 -0800
X-CSE-ConnectionGUID: YIiUhQmsQs2tVzfBrEeG6g==
X-CSE-MsgGUID: mfEOWBtuQRucr5E5guzJ5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="195605963"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.179]) ([10.125.109.179])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 09:01:38 -0800
Message-ID: <e140cf79-e978-4551-9c6d-a4ef4ea7b60e@intel.com>
Date: Wed, 19 Nov 2025 10:01:37 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 05/17] nvdimm/label: Skip region label during ns label
 DPA reservation
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
 <CGME20251119075315epcas5p2be6f51993152492f0dd64366863d70e2@epcas5p2.samsung.com>
 <20251119075255.2637388-6-s.neeraj@samsung.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251119075255.2637388-6-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/19/25 12:52 AM, Neeraj Kumar wrote:
> If Namespace label is present in LSA during nvdimm_probe() then DPA
> reservation is required. But this reservation is not required by region
> label. Therefore if LSA scanning finds any region label, skip it.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/label.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 6ccc51552822..e90e48672da3 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -469,6 +469,10 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  		lsa_label = to_lsa_label(ndd, slot);
>  		nd_label = &lsa_label->ns_label;
>  
> +		/* Skip region label. DPA reservation is for NS label only */
> +		if (is_region_label(ndd, lsa_label))
> +			continue;
> +
>  		if (!slot_valid(ndd, lsa_label, slot))
>  			continue;
>  

