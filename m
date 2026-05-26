Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22048358372
	for <nvdimm@lists.linux.dev>; Tue, 26 May 2026 23:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779838269; cv=none; b=iIPt/eCJCdOJM/fU2eP42i6mfGBTQTMX+4tBt/SPlvlG5nIkLgBMtKlayuhPbHkxss0DSx9ocunnYuToatk7YxFjgtmzgFYlUSoqEO6WnnpnXFgBoGpTB81ei8oARRB3Tfnh3lIYmQ2lx8bqPb2ZC8i7l8YVbaELFUtiEoUKv+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779838269; c=relaxed/simple;
	bh=Uh1B4LC7Ou4oWh//ZNCWVQ5wMvyjm3M8AdnFd11S5ck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YmqZzPdOlXdDSU0B2WlYIZeSw9VHa8DqtzBzjxtAik3a6VWqzuKEnslmPaKkYiXghUOStRJDBPru+QRuSLREpE6ipxjl/Rj763Ywbv63S3B1HHAXsIH8cYvNWBSJRf0s764bEmwM0dLJ2r7g2zOueqbRO8J5Ot2IwyNtSk9NL3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F5vFPw+w; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F5vFPw+w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779838268; x=1811374268;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Uh1B4LC7Ou4oWh//ZNCWVQ5wMvyjm3M8AdnFd11S5ck=;
  b=F5vFPw+wMQ+zfUpPqZyapykduBHnNWYkNZPuQCjRusYGXmrVrIML8Dl1
   roYsaOwW7NDRLJBdJu6SITaNY2DMsVCw1idC21PdIBgtml4RjxIX1giEv
   XXM8QUUEnAgR20tS0a7qdUwq6NsMq8GbZ9ppNV8jEvEdxXKmFK8IWmidp
   SRxVmvkm6VFH+CioZvPplTzqrDY+KSwuo3IXLzSKF7OcixjHWWIgponBB
   QWS+0yLvv9hcgSmYRUht42hhdzcD9cE0seNrzVAlVm4ZHxbpt3ENysrqR
   coCXxCp0Td2LnNaEql6V8bNGScK0cDbL7v2PYLR+zoDxYEmkRYv69Tgl5
   Q==;
X-CSE-ConnectionGUID: 7Niqw1FwReamc6cXVkk/tA==
X-CSE-MsgGUID: ngIMtBaeRSyBCTk9M2tPPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="84557517"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="84557517"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 16:31:08 -0700
X-CSE-ConnectionGUID: gDndoBbXQzuShIVkjqPc2g==
X-CSE-MsgGUID: 1b/CbDUQTPSa2hcls/N2qA==
X-ExtLoop1: 1
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.110.201]) ([10.125.110.201])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 16:31:06 -0700
Message-ID: <1aa37178-4d36-4a4c-8b36-bf2789ce9655@intel.com>
Date: Tue, 26 May 2026 16:31:05 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 3/7] dax/fsdev: fix kaddr for multi-range and fail
 probe on invalid pgmap offset
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 Dan Williams <djbw@kernel.org>
Cc: John Groves <jgroves@micron.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
 <20260522191859.79167-1-john@jagalactic.com>
 <0100019e51208026-d62e0ffa-73d4-4cac-b950-dbbbb13ab38c-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019e51208026-d62e0ffa-73d4-4cac-b950-dbbbb13ab38c-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/22/26 12:19 PM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Two fixes for virtual address handling in fsdev:
> 
> 1. Use __va(phys) instead of virt_addr + linear_offset for the kaddr
>    return in __fsdev_dax_direct_access(). The previous code added a
>    device-linear byte offset to virt_addr (which is __va of ranges[0]),
>    but for multi-range devices with physical gaps between ranges, this
>    linear arithmetic crosses the gap and produces a wrong kernel virtual
>    address. Using __va(phys) where phys comes from dax_pgoff_to_phys()
>    is correct for any range layout because the direct map translates
>    each physical address independently.
> 
> 2. Convert the WARN_ON to a fatal error when pgmap_phys > phys. This
>    condition means the remapped region starts after the device's data
>    region, which is an impossible state. Previously the probe continued
>    with data_offset=0, leaving virt_addr silently misaligned. Now probe
>    returns -EINVAL with a diagnostic message.

Split to 2 different patches I'd say.

DJ

> 
> Fixes: 759455848df0b ("dax: Save the kva from memremap")
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/fsdev.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index 42aac7e952516..aac0130ab2833 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -51,9 +51,7 @@ static long __fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>  	struct dev_dax *dev_dax = dax_get_private(dax_dev);
>  	size_t size = nr_pages << PAGE_SHIFT;
>  	size_t offset = pgoff << PAGE_SHIFT;
> -	void *virt_addr = dev_dax->virt_addr + offset;
>  	phys_addr_t phys;
> -	unsigned long local_pfn;
>  
>  	phys = dax_pgoff_to_phys(dev_dax, pgoff, size);
>  	if (phys == -1) {
> @@ -63,11 +61,10 @@ static long __fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>  	}
>  
>  	if (kaddr)
> -		*kaddr = virt_addr;
> +		*kaddr = __va(phys);
>  
> -	local_pfn = PHYS_PFN(phys);
>  	if (pfn)
> -		*pfn = local_pfn;
> +		*pfn = PHYS_PFN(phys);
>  
>  	/*
>  	 * Use cached_size which was computed at probe time. The size cannot
> @@ -313,8 +310,13 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  		u64 phys = dev_dax->ranges[0].range.start;
>  		u64 pgmap_phys = dev_dax->pgmap[0].range.start;
>  
> -		if (!WARN_ON(pgmap_phys > phys))
> -			data_offset = phys - pgmap_phys;
> +		if (pgmap_phys > phys) {
> +			dev_err(dev, "pgmap start %#llx exceeds data start %#llx\n",
> +				pgmap_phys, phys);
> +			rc = -EINVAL;
> +			goto err_pgmap;
> +		}
> +		data_offset = phys - pgmap_phys;
>  
>  		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
>  		       __func__, phys, pgmap_phys, data_offset);

