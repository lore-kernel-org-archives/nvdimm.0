Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C95B3242D8
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 00:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779840063; cv=none; b=tSAlkvcCj+mAU1tzykbLsCMpiidmUdFA7jfT23PtiVrdV1yTtwnLEGYYY+OjAywxNj/8q6ya2yxs/fkNXs1K3mCKTUMcaVSGkNhaQdZfTOd9J3VDHKRz8wiozpwrktPR4SEdFd8f+Wx0wfTziEXsDnTKxlPCSwCBJi5DzV0vlog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779840063; c=relaxed/simple;
	bh=3vU/0QPEI07YCkbkMuEpZrpFa05COivePVurXnprpeo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZrzZczx5qdF/5ZwBI9AUXKZn1nFOn/ZwanZYHWSFBnPPusWigdG77iwIajySpPU6sk8WpNAwwaRBaTNEXefjGjVsfOfRbefME0R65JjwIdEYfmMYbkPhLqiLpB7Tn24T7etHxMrspzz78d2qZfCRNL369RXq0h/KP7te9+3kRDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QRqqGDWp; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QRqqGDWp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779840059; x=1811376059;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3vU/0QPEI07YCkbkMuEpZrpFa05COivePVurXnprpeo=;
  b=QRqqGDWp7YrEqSYK7i7Xb+U8VH2necaiTNz2vEEqf/0Af5XKN7LGvpRs
   7kfLHNtYzhNEYcaWTvIZ241ZUyvuLNkF70RJFe14Txwjja0xwRIc/BDSQ
   TLdnJr0lWQlJQFdgjJG4S9G2X9jNxMfIW3MZWdr6NId60vsk/Jb7mF69e
   FNrjASBDZ3DoCLKFBZDhf0OsiAypyYbf3nIlnAHI2gJQ11inePU34/rFU
   v6oSaJnUjy2CDka6L9xvpYD7AdzM4idCyPZuIcIhx2MERP4fMGxhZDQ7B
   jJ3OeCFo09xURt8l9iifzvSjOWjDpwvcZYWnsvcAfnUvpKUrUf2+fyQQM
   g==;
X-CSE-ConnectionGUID: O3LgCrlnTieUNWFc8gnc3Q==
X-CSE-MsgGUID: kJI/KX/bSkSrJAMKYu84xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="80698008"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="80698008"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 17:00:56 -0700
X-CSE-ConnectionGUID: vPbGlu1WTzKZd5LVBK9MQQ==
X-CSE-MsgGUID: eczy78FLS6q9LLNJXpeQYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="265941112"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.110.201]) ([10.125.110.201])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 17:00:55 -0700
Message-ID: <16628b9f-a624-46f8-8a7f-3b9e7963963b@intel.com>
Date: Tue, 26 May 2026 17:00:53 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 4/7] dax/fsdev: clamp direct_access return to current
 physical range
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
 <20260522191907.79187-1-john@jagalactic.com>
 <0100019e51209df4-90c4ba85-6cc5-4f5d-af26-451e7e786535-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019e51209df4-90c4ba85-6cc5-4f5d-af26-451e7e786535-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/22/26 12:19 PM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> __fsdev_dax_direct_access() returned the number of available pages based
> on cached_size (the total size across all ranges). For multi-range
> devices with physical gaps between ranges, this over-reports the number
> of physically contiguous pages available from the returned kaddr/pfn.
> Callers trust this return value to mean contiguous pages, so accessing
> beyond the current range boundary would hit unmapped or unrelated memory.
> 
> Fix by finding the range that contains the translated physical address
> and clamping the return to the remaining pages within that range.
> 
> Also remove the now-unused cached_size field from struct dev_dax, since
> it was only consumed by the old return calculation.
> 
> Fixes: 099c81a1f0ab3 ("dax: Add dax_operations for use by fs-dax on fsdev dax")
> Signed-off-by: John Groves <john@groves.net>

I ran this through Claude and this is what it came back with and it looks reasonable to me:

The claimed bug does not manifest in the current tree. This is a
  refactor + dead-field removal dressed as a bugfix. Either the justification is
   wrong or there's a missing companion change.

  The claim doesn't hold up

  Commit message:

  ▎ __fsdev_dax_direct_access() returned the number of available pages based on
  ▎ cached_size (the total size across all ranges). For multi-range devices with
  ▎  physical gaps between ranges, this over-reports the number of physically
  ▎ contiguous pages available from the returned kaddr/pfn.

  Walk through it. __fsdev_dax_direct_access does:

  phys = dax_pgoff_to_phys(dev_dax, pgoff, size);
  if (phys == -1)
      return -EFAULT;
  ...
  return PHYS_PFN(min(size, dev_dax->cached_size - offset));

  Now look at what dax_pgoff_to_phys (drivers/dax/bus.c:1433) enforces:

  phys = PFN_PHYS(pgoff - dax_range->pgoff) + range->start;
  if (phys + size - 1 <= range->end)
      return phys;
  break;        /* falls through to return -1 */

  It returns valid phys only when the entire requested size fits inside a single
   range. If the request straddles a gap, it returns -1 and the caller bails
  with -EFAULT before ever reaching the clamp.

  So in the only path where the clamp runs, we already know size <= range->end -
   phys + 1, which means cached_size - offset >= size, which means min(size,
  cached_size - offset) == size. Pre-patch returns nr_pages. Post-patch returns
  nr_pages. Same answer.

  I worked it through with concrete numbers on a 2-range device with a physical
  gap (range[0]=4 pages at 0x1000_0000, range[1]=4 pages at 0x2000_0000):
  - pgoff=2, nr_pages=2: both return 2. ✓
  - pgoff=3, nr_pages=2 (straddles gap): both return -EFAULT via the early bail.
   ✓
  - pgoff=4, nr_pages=2: both return 2. ✓

  I cannot construct a case where pre-patch over-reports.

  What's actually changed

  1. A no-op clamp loop replaces a constant calculation. Same return value in
  every reachable case.
  2. The trailing return -EFAULT; is dead code. If dax_pgoff_to_phys returned
  valid phys, then by construction phys lies inside some range in
  dev_dax->ranges[], so the loop will match.
  3. O(N) walk replaces O(1) arithmetic. Trivial for small nr_range, but it's a
  regression in the wrong direction for a hot path.
  4. cached_size field is removed. Good cleanup — I grepped, no other consumers.


DJ

> ---
>  drivers/dax/dax-private.h |  2 --
>  drivers/dax/fsdev.c       | 23 ++++++++++++++---------
>  2 files changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 81e4af49e39c1..7a3727d76a68a 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -70,7 +70,6 @@ struct dev_dax_range {
>   * @region: parent region
>   * @dax_dev: core dax functionality
>   * @virt_addr: kva from memremap; used by fsdev_dax
> - * @cached_size: size of daxdev cached by fsdev_dax
>   * @align: alignment of this instance
>   * @target_node: effective numa node if dev_dax memory range is onlined
>   * @dyn_id: is this a dynamic or statically created instance
> @@ -86,7 +85,6 @@ struct dev_dax {
>  	struct dax_region *region;
>  	struct dax_device *dax_dev;
>  	void *virt_addr;
> -	u64 cached_size;
>  	unsigned int align;
>  	int target_node;
>  	bool dyn_id;
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index aac0130ab2833..f74fd1bb7f4c5 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -50,8 +50,8 @@ static long __fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>  {
>  	struct dev_dax *dev_dax = dax_get_private(dax_dev);
>  	size_t size = nr_pages << PAGE_SHIFT;
> -	size_t offset = pgoff << PAGE_SHIFT;
>  	phys_addr_t phys;
> +	int i;
>  
>  	phys = dax_pgoff_to_phys(dev_dax, pgoff, size);
>  	if (phys == -1) {
> @@ -67,10 +67,20 @@ static long __fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>  		*pfn = PHYS_PFN(phys);
>  
>  	/*
> -	 * Use cached_size which was computed at probe time. The size cannot
> -	 * change while the driver is bound (resize returns -EBUSY).
> +	 * Return the number of physically contiguous pages available from
> +	 * phys, clamped to the current range. For multi-range devices the
> +	 * ranges may not be physically contiguous, so we cannot report
> +	 * pages beyond the end of the range that contains phys.
>  	 */
> -	return PHYS_PFN(min(size, dev_dax->cached_size - offset));
> +	for (i = 0; i < dev_dax->nr_range; i++) {
> +		struct range *range = &dev_dax->ranges[i].range;
> +
> +		if (phys >= range->start && phys <= range->end)
> +			return PHYS_PFN(min(size,
> +					    (size_t)(range->end - phys + 1)));
> +	}
> +
> +	return -EFAULT;
>  }
>  
>  static int fsdev_dax_zero_page_range(struct dax_device *dax_dev,
> @@ -272,11 +282,6 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  		}
>  	}
>  
> -	/* Cache size now; it cannot change while driver is bound */
> -	dev_dax->cached_size = 0;
> -	for (i = 0; i < dev_dax->nr_range; i++)
> -		dev_dax->cached_size += range_len(&dev_dax->ranges[i].range);
> -
>  	/*
>  	 * Use MEMORY_DEVICE_FS_DAX without setting vmemmap_shift, leaving
>  	 * folios at order-0. Unlike device.c (MEMORY_DEVICE_GENERIC), this

