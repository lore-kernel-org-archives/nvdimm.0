Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB444DA53C;
	Thu,  9 Jul 2026 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783619885; cv=none; b=HokdmHxoXksxEHW+he9eqMlJ3ru+YUHDkWdnvSCmAR4jGdYJFXtyD5kxFZkO65H3vSQgEuAYjZ+v0xZo6fbike6mKeLeEjb5W8ofPb4JZxzDPfqWsK9/U6PdxRUH4Vtrz+nEv+fN989yoB5TqQcczXvzDv1kJWVmPOterb/hHJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783619885; c=relaxed/simple;
	bh=ueCfC8mj9W6I1SlYqEpl674vMNV2wFKokvVZLAzEXzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zr/BJlkbfc31imioGeBGIU4shkOYceQysX/Vv51Ck3OoCxanRTkNf7FqbjBcsqc/GQCnonJFvw0as4s4Ji0q4NbFb1zmSx617DN0WsqovxeUs9aIP7MWHZ0pHz0oxNUaWFtnqvyTYVSJ7d1XgKzi0NuU06UMKxHhZKiMgiyPvKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PVsTXJsh; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PVsTXJsh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783619884; x=1815155884;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ueCfC8mj9W6I1SlYqEpl674vMNV2wFKokvVZLAzEXzA=;
  b=PVsTXJsh6fU42lLh4QQE6DPqX9gOHnbjh4C7ahgq9rPY/1DldGvzAtOu
   ip7hCLXdkE2dWWXbKZUh9TAT9OnyHMkIH3sy2HoDIMptgbqjb3pBjQ3vV
   Z7FnbWmmbTl814a7FzD797g6m730A1aJ+bmHBw4clc/AsmE+x6eQDCvo7
   j68HMLPGHghnuIXst+8a+k4wku2WjnplEhhQQDu0l+f0iMCv7fBl0ihZm
   knag5MlROIsR0quqNSpCYbSczzWv7b3cvw27CPg8Up+5vlLulO0jK0FV6
   GQzQnGFG9FUF2HB1d7B3b85u+u4KwlFqi1OZeAAgUqyy3MWLm3RsPYmeE
   w==;
X-CSE-ConnectionGUID: INIwS+g3TB+vWv9CYLm+gQ==
X-CSE-MsgGUID: LVtG1VufTHybv/1l6OShEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="88139590"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="88139590"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 10:58:04 -0700
X-CSE-ConnectionGUID: hf/hEBL1SMaZOpk5XqzpzA==
X-CSE-MsgGUID: mMZej/BNT82mbag9beBfMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="252920685"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 10:58:02 -0700
Message-ID: <c4e18591-137f-4827-b635-a8662a44fe9d@intel.com>
Date: Thu, 9 Jul 2026 10:58:00 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/10] mm/memory: add memory_block_aligned_range()
 helper
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-2-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/30/26 2:18 PM, Gregory Price wrote:
> Memory hotplug operations require ranges aligned to memory block
> boundaries.  This is a generic operation for hotplug.
> 
> Add memory_block_aligned_range() as a common helper in <linux/memory.h>
> that aligns the start address up and end address down to memory block
> boundaries.  Guard against end underflow when the range falls below the
> first memory block boundary, returning an empty range instead.
> 
> Update dax/kmem to use this helper.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/kmem.c     |  4 +---
>  include/linux/memory.h | 27 +++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index a18e2b968e4d..592171ec10f4 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -33,9 +33,7 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
>  	struct dev_dax_range *dax_range = &dev_dax->ranges[i];
>  	struct range *range = &dax_range->range;
>  
> -	/* memory-block align the hotplug range */
> -	r->start = ALIGN(range->start, memory_block_size_bytes());
> -	r->end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
> +	*r = memory_block_aligned_range(range);
>  	if (r->start >= r->end) {
>  		r->start = range->start;
>  		r->end = range->end;
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index 463dc02f6cff..1783299073e4 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -20,6 +20,7 @@
>  #include <linux/compiler.h>
>  #include <linux/mutex.h>
>  #include <linux/memory_hotplug.h>
> +#include <linux/range.h>
>  
>  #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
>  
> @@ -100,6 +101,32 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
>  unsigned long memory_block_size_bytes(void);
>  int set_memory_block_size_order(unsigned int order);
>  
> +/**
> + * memory_block_aligned_range - align a physical address range to memory blocks
> + * @range: the input range to align
> + *
> + * Aligns the start address up and the end address down to memory block
> + * boundaries. This is required for memory hotplug operations which must
> + * operate on memory-block aligned ranges.
> + *
> + * Returns the aligned range. Callers should check that the returned
> + * range is valid (aligned.start < aligned.end) before using it.
> + */
> +static inline struct range memory_block_aligned_range(const struct range *range)
> +{
> +	struct range aligned;
> +
> +	aligned.start = ALIGN(range->start, memory_block_size_bytes());
> +	aligned.end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes());
> +	/* No whole block fits (e.g. range below the first boundary): empty. */
> +	if (aligned.end <= aligned.start)
> +		aligned.start = aligned.end;
> +	else
> +		aligned.end -= 1;
> +
> +	return aligned;
> +}
> +
>  struct memory_notify {
>  	unsigned long start_pfn;
>  	unsigned long nr_pages;

