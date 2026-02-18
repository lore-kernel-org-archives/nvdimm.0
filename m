Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E890D2773E4
	for <nvdimm@lists.linux.dev>; Wed, 18 Feb 2026 23:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771455663; cv=none; b=NhQOQZjNN1+kR8wOPUrcRj/N95es+BN4WOB7Sb38vooodeNbCSIWeu8OULkismRsljCMbknWiovvNB9+3y7bWRQjIW0pUo3gjJCK6BpVdJ4ZlH8lV0Wo+zNhBXgyN7scml8//dvHw4Jgex39htxoi0jbqpaYcwscFKXsX+eqs8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771455663; c=relaxed/simple;
	bh=Ka3shS3eNTr96+8Nt7+Mh2dJ1uTBTo6+XEd9mbl4GFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ArPNHWHaEvKeoZxNvDq4H/NaMfGu/81aKGuS4L4r6FY+xWqTX05uXatooc3kS2JFMbkD2pxq2X4EtgZYaMR3PSxHBF0T04FT4KZ2I3AD7TbLUtmo1bBC0FK4Zo+/9gmN/XfnFXnQ/rUcmfEft2BkvBn5K1wVKZKpAiD2n5mDwFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fnn4Gy+Z; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fnn4Gy+Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771455662; x=1802991662;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ka3shS3eNTr96+8Nt7+Mh2dJ1uTBTo6+XEd9mbl4GFA=;
  b=fnn4Gy+Z5C4TBGEJL2dPFtc8KOHlaqSIZNW/6cBLrenEs95skmlAPHkP
   FwGjji2m9WM5jW5qYArS7KTKEa7/+V39ydnV63u4G8NTNFY5mHa4CWeZn
   X3AcKtynm7RLDLjHe0z64dHbyDdm2YqQXkSyxjqtCyYL+gKvGXnar2gHy
   gKHwxsDMUP0YQxN8UQs0059U0BR1NshfrBkUNYA7cw6djPeB1WmxlPoBr
   qbvNqTeEPXyt9k4GbMI7etDOmfuAqDNCVbMwLZ+DJ4lXV+13a0CGnjVg9
   j3e6oM6Ak/KhyjqEpOLw+zjAlSSY39ZKdfLcfMgQ+RX7yF8TmRV0OC2y2
   w==;
X-CSE-ConnectionGUID: 5pWVyk/1Ri6pARMI08emdA==
X-CSE-MsgGUID: 6m1aYodaTVmRZSOsSadxtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="89952574"
X-IronPort-AV: E=Sophos;i="6.21,299,1763452800"; 
   d="scan'208";a="89952574"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 15:01:01 -0800
X-CSE-ConnectionGUID: lu4mzYO2Qx2UJSEQGwEIKg==
X-CSE-MsgGUID: UY/jyFuQQHq6b78u0N1xWg==
X-ExtLoop1: 1
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.109.212]) ([10.125.109.212])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 15:00:58 -0800
Message-ID: <066c48be-032c-4d27-8b71-de6ba55a7349@intel.com>
Date: Wed, 18 Feb 2026 16:00:57 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V7 01/19] dax: move dax_pgoff_to_phys from [drivers/dax/]
 device.c to bus.c
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <dan.j.williams@intel.com>,
 Bernd Schubert <bschubert@ddn.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>, John Groves <jgroves@fastmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 David Hildenbrand <david@kernel.org>, Christian Brauner
 <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong
 <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>, James Morse <james.morse@arm.com>,
 Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>,
 Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>,
 Gregory Price <gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>,
 Ajay Joshi <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <0100019bd33b1f66-b835e86a-e8ae-443f-a474-02db88f7e6db-000000@email.amazonses.com>
 <20260118223100.92299-1-john@jagalactic.com>
 <0100019bd33bc40a-12130f8b-289d-4a38-ab4b-7dfedf614d34-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019bd33bc40a-12130f8b-289d-4a38-ab4b-7dfedf614d34-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/18/26 3:31 PM, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> This function will be used by both device.c and fsdev.c, but both are
> loadable modules. Moving to bus.c puts it in core and makes it available
> to both.
> 
> No code changes - just relocated.
> 
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/bus.c    | 24 ++++++++++++++++++++++++
>  drivers/dax/device.c | 23 -----------------------
>  2 files changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index fde29e0ad68b..a73f54eac567 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1417,6 +1417,30 @@ static const struct device_type dev_dax_type = {
>  	.groups = dax_attribute_groups,
>  };
>  
> +/* see "strong" declaration in tools/testing/nvdimm/dax-dev.c */
> +__weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
> +			      unsigned long size)
> +{
> +	int i;
> +
> +	for (i = 0; i < dev_dax->nr_range; i++) {
> +		struct dev_dax_range *dax_range = &dev_dax->ranges[i];
> +		struct range *range = &dax_range->range;
> +		unsigned long long pgoff_end;
> +		phys_addr_t phys;
> +
> +		pgoff_end = dax_range->pgoff + PHYS_PFN(range_len(range)) - 1;
> +		if (pgoff < dax_range->pgoff || pgoff > pgoff_end)
> +			continue;
> +		phys = PFN_PHYS(pgoff - dax_range->pgoff) + range->start;
> +		if (phys + size - 1 <= range->end)
> +			return phys;
> +		break;
> +	}
> +	return -1;
> +}
> +EXPORT_SYMBOL_GPL(dax_pgoff_to_phys);
> +
>  static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
>  {
>  	struct dax_region *dax_region = data->dax_region;
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 22999a402e02..132c1d03fd07 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -57,29 +57,6 @@ static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
>  			   vma->vm_file, func);
>  }
>  
> -/* see "strong" declaration in tools/testing/nvdimm/dax-dev.c */
> -__weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
> -		unsigned long size)
> -{
> -	int i;
> -
> -	for (i = 0; i < dev_dax->nr_range; i++) {
> -		struct dev_dax_range *dax_range = &dev_dax->ranges[i];
> -		struct range *range = &dax_range->range;
> -		unsigned long long pgoff_end;
> -		phys_addr_t phys;
> -
> -		pgoff_end = dax_range->pgoff + PHYS_PFN(range_len(range)) - 1;
> -		if (pgoff < dax_range->pgoff || pgoff > pgoff_end)
> -			continue;
> -		phys = PFN_PHYS(pgoff - dax_range->pgoff) + range->start;
> -		if (phys + size - 1 <= range->end)
> -			return phys;
> -		break;
> -	}
> -	return -1;
> -}
> -
>  static void dax_set_mapping(struct vm_fault *vmf, unsigned long pfn,
>  			      unsigned long fault_size)
>  {

