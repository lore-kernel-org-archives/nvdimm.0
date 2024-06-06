Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053C41B969
	for <nvdimm@lists.linux.dev>; Thu,  6 Jun 2024 16:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717691260; cv=none; b=jZMGiruU8zVmevA4YWGk03U2BeQdCkrI47Oir0rMXlfqEvgHwGZJwHOOLdkwsHjrlcVJx6zBUZwBC+7j/hVmhbPKIsCe0n4zijVvyHhQd4T99TN2Vq+4zkmFvE4fG0xkjPpI8HclJ55lXC5Yl+485Josoo3op4zmkG4QBfwLwZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717691260; c=relaxed/simple;
	bh=awmDsh57h4AtP7unUblPN0J9qBOX9TMrTx1/JBxYOEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BuQOkzp+040oAYidA1cXW3xe/NZxfq7K01o8Eo0u2INDjYKK9ti7P8HUcoUrInXBe79dshYCqYoIQ1cnEt/b/9suxzrFtWOL9dzXs+wcTRsKCcj1oHHjpho3RM8d937Jv0UzUf0VETgScs1JMjgKHq12KDwhmlLyFwsBZKM3n3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HjzAbEJR; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HjzAbEJR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717691259; x=1749227259;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=awmDsh57h4AtP7unUblPN0J9qBOX9TMrTx1/JBxYOEg=;
  b=HjzAbEJR5/EAW38nM/tb9RoSDuv7GSxl0lKVyvBqzv3IYP+Nrp02NwNd
   f9isvp/XrkHQcurPBF16/DJvpVZIhIQdRjYQHcxlBcDCuBqPmaQBUlX+Y
   6yl7jmiq9TBfcpUuOY4Kv/62S7vZQmf/ZqfAwTB7MDMnOOiYUvoRok7cN
   6fFH3u2G1yxv/4LtCAspXYNP2KWDxWZl+ZcogwYFjkk3J+LjlCN5KqehO
   JsiapK9ECBTzSjSt62Nx+tbmnUoDQ2N1nIIezvYzh5qPc7XWHAoCoyknm
   CVRN1NOVg4S80dLNwJQMQ4xwbEi3+UpQU4Der1WliXEa/VP93o4VblYU0
   w==;
X-CSE-ConnectionGUID: z5fnPjYVQqqvyg6x3cCacw==
X-CSE-MsgGUID: rmGYkyHSSxOpWVQAgt7jOA==
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="14212371"
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="14212371"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 09:27:05 -0700
X-CSE-ConnectionGUID: HOGixHSaQPSsx4896ZAKCQ==
X-CSE-MsgGUID: D8rI8EucSEKotOCKzzmewQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="37886303"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.125.109.168]) ([10.125.109.168])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 09:27:04 -0700
Message-ID: <116afccd-c817-4a45-ad77-ccc039339285@intel.com>
Date: Thu, 6 Jun 2024 09:27:03 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvdimm: Fix devs leaks in scan_labels()
To: Li Zhijian <lizhijian@fujitsu.com>, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 linux-kernel@vger.kernel.org
References: <20240604031658.951493-1-lizhijian@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240604031658.951493-1-lizhijian@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/3/24 8:16 PM, Li Zhijian wrote:
> Don't allocate devs again when it's valid pointer which has pionted to
> the memory allocated above with size (count + 2 * sizeof(dev)).
> 
> A kmemleak reports:
> unreferenced object 0xffff88800dda1980 (size 16):
>   comm "kworker/u10:5", pid 69, jiffies 4294671781
>   hex dump (first 16 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace (crc 0):
>     [<00000000c5dea560>] __kmalloc+0x32c/0x470
>     [<000000009ed43c83>] nd_region_register_namespaces+0x6fb/0x1120 [libnvdimm]
>     [<000000000e07a65c>] nd_region_probe+0xfe/0x210 [libnvdimm]
>     [<000000007b79ce5f>] nvdimm_bus_probe+0x7a/0x1e0 [libnvdimm]
>     [<00000000a5f3da2e>] really_probe+0xc6/0x390
>     [<00000000129e2a69>] __driver_probe_device+0x78/0x150
>     [<000000002dfed28b>] driver_probe_device+0x1e/0x90
>     [<00000000e7048de2>] __device_attach_driver+0x85/0x110
>     [<0000000032dca295>] bus_for_each_drv+0x85/0xe0
>     [<00000000391c5a7d>] __device_attach+0xbe/0x1e0
>     [<0000000026dabec0>] bus_probe_device+0x94/0xb0
>     [<00000000c590d936>] device_add+0x656/0x870
>     [<000000003d69bfaa>] nd_async_device_register+0xe/0x50 [libnvdimm]
>     [<000000003f4c52a4>] async_run_entry_fn+0x2e/0x110
>     [<00000000e201f4b0>] process_one_work+0x1ee/0x600
>     [<000000006d90d5a9>] worker_thread+0x183/0x350
> 
> Fixes: 1b40e09a1232 ("libnvdimm: blk labels and namespace instantiation")
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
>  drivers/nvdimm/namespace_devs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index d6d558f94d6b..56b016dbe307 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1994,7 +1994,9 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  		/* Publish a zero-sized namespace for userspace to configure. */
>  		nd_mapping_free_labels(nd_mapping);
>  
> -		devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
> +		/* devs probably has been allocated */
> +		if (!devs)
> +			devs = kcalloc(2, sizeof(dev), GFP_KERNEL);

This changes the behavior of this code and possibly corrupting the previously allocated memory at times when 'devs' is valid. Was the 'devs' leaked out from the previous loop and should be freed instead?

>  		if (!devs)
>  			goto err;
>  
