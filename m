Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8BA378D72
	for <nvdimm@lists.linux.dev>; Mon,  4 May 2026 16:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777910899; cv=none; b=PqRNUj6n8RYVm7lyV+xGhcIwzG20RaLtF4JMezeyO+asnaeE5JCkMdKXNSCccUBpE4SbLjvV09ZgQglTVNmLHJIPDloMXLl/ABiPmUIxjYyytOKT4+LFMAURt7u20v8RIstsVEouGR93SQydug/4qIY3BS2IQfVQxtJIUk8lmZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777910899; c=relaxed/simple;
	bh=4lCsaFuu2B5R467I+7rpTNdF6BZtih2LJJ2lk/PHSPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ljtNCos/Lh2kHM3x1yPmkDYy+j3VxzQo4jJZkjW9S4GguaFd74Yv6MnCbE2v/r2faxXAC6xUytkdu7XhkytnlfCs9djrbYVFQauXhzVY4hlKjeMjfD+DYhVtgzkV0N/+gBEceX3N0OFNW3zfQZY+aBkQtYmKULPqlKUA3obzHes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kEWVtHZS; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kEWVtHZS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777910897; x=1809446897;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4lCsaFuu2B5R467I+7rpTNdF6BZtih2LJJ2lk/PHSPw=;
  b=kEWVtHZSqRTnaUNmYOxZbYen0iR7xrpAYZMh9QBY4EOrU/4kDYlnL9XQ
   F80VXe2bCHZbrEDuQ9l1a9Js42XDFjqQRiNk2QiyHrk7IOxKB+4B/+TL3
   +QUCar8cTMOaNCZlWcJIz+fLd4zRkac5jg0T2Aca1+YFVxuruu4XP0Ld3
   APXjnyaqCmdqv4G+uHostIvyKFccehhNDmwfXArJ8km1rAp3Fkjqy2zA2
   K8kJCvRXwVX1nC9wpg6a5Kdn1dyysFJJSdIgMMph3K2B9ZnRa7NgTW+zF
   wnne4WCfxFz6G1FEGOlPcWENHtu6+vY6ExEhwOHl3smXvdfievSd06utm
   Q==;
X-CSE-ConnectionGUID: NSfHfmL8T8myLniU7aypRA==
X-CSE-MsgGUID: lRnOzJPVSLiLsSzKrzijTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="77789301"
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="77789301"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 09:08:15 -0700
X-CSE-ConnectionGUID: keFM9U6aQ4urZpzFRDdezg==
X-CSE-MsgGUID: pg+QsgYJTZGFA3RcNf/zHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="259211309"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.110.19]) ([10.125.110.19])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 09:08:14 -0700
Message-ID: <1eb01a65-d21a-40a8-948e-0b1a3f088a20@intel.com>
Date: Mon, 4 May 2026 09:08:13 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/dax: check for empty/zero entries before calling
 pfn_to_page()
To: Souvik Banerjee <souvik@amlalabs.com>, dan.j.williams@intel.com
Cc: willy@infradead.org, jack@suse.cz, apopple@nvidia.com,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260501233933.2614302-1-souvik@amlalabs.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260501233933.2614302-1-souvik@amlalabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/1/26 4:39 PM, Souvik Banerjee wrote:
> Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> added zero/empty-entry early returns to dax_associate_entry() and
> dax_disassociate_entry(), but placed them *after* the
> `struct folio *folio = dax_to_folio(entry);` line.  dax_to_folio()
> expands to page_folio(pfn_to_page(dax_to_pfn(entry))), and page_folio()
> performs READ_ONCE(page->compound_head) -- a real dereference of the
> struct page pointer derived from a bogus PFN extracted from the
> empty/zero XA value.
> 
> On systems where vmemmap covers all of RAM that dereference reads
> garbage and is harmless: the early return then discards the result.
> On virtio-pmem with altmap (vmemmap stored inside the device), only
> the real device PFN range is mapped, so the dereference triggers a
> kernel paging fault from the truncate / invalidate path and from the
> PMD-downgrade branch of dax_iomap_pte_fault when an entry is being
> freed:
> 
>   Unable to handle kernel paging request at
>   virtual address ffff_fdff_bf00_0008 (vmemmap region)
>   Call trace:
>    dax_disassociate_entry.isra.0+0x20/0x50
>    dax_iomap_pte_fault
>    dax_iomap_fault
>    erofs_dax_fault
> 
> Close the residual gap by moving the dax_to_folio() call after the
> zero/empty guard in dax_disassociate_entry().  Apply the same
> treatment to dax_busy_page(), which has the identical pattern but
> was not touched by the prior fix.
> 
> Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
> Cc: stable@vger.kernel.org # v6.15+
> Cc: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  fs/dax.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 6d175cd47a99..6878473265bb 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -505,21 +505,23 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
>  static void dax_disassociate_entry(void *entry, struct address_space *mapping,
>  				bool trunc)
>  {
> -	struct folio *folio = dax_to_folio(entry);
> +	struct folio *folio;
>  
>  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
>  		return;
>  
> +	folio = dax_to_folio(entry);
>  	dax_folio_put(folio);
>  }
>  
>  static struct page *dax_busy_page(void *entry)
>  {
> -	struct folio *folio = dax_to_folio(entry);
> +	struct folio *folio;
>  
>  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
>  		return NULL;
>  
> +	folio = dax_to_folio(entry);
>  	if (folio_ref_count(folio) - folio_mapcount(folio))
>  		return &folio->page;
>  	else

