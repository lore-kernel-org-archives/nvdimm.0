Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC94226CFE
	for <nvdimm@lists.linux.dev>; Fri,  2 Oct 2026 03:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790910214; cv=none; b=YGp5kC5bNJVGDYZYEk16FXQiwbcC9OTW0T8KZ4Sp5YYj8ijSmvYpX6w5nCCtU1cweZ46KkZTPzdiyVJMLVR9JegBcE5I7vIi1/QK9FoNH3jkaUiFwp2krxhnoPegU/rrE0u93M4WuYtEoZoDyuE8Ck0ejBBvfmIH1XqX3Ti9ofk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790910214; c=relaxed/simple;
	bh=R5uGZziUWDsA1Ci/pCr6s5hpqjNrZYBUeqFKIURcGa0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s+yK3w5Qrj7+Sx9PLl9dZMLKX4M1cWGCQUhIvqmq2MD17fesGFnlWceLhaCK1bFnOIyhKSvaWaWAGP8G7qGa9FZ7VGaVLM1HW3f8h1qXaFU5Y2gB6Bk4LzuRJquwH//GrRk1ngRTUCPWDf4GBc62YcjmlxynWSlvtQAPfG1wjH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dDVyVZWs; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dDVyVZWs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790910213; x=1822446213;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=R5uGZziUWDsA1Ci/pCr6s5hpqjNrZYBUeqFKIURcGa0=;
  b=dDVyVZWsk/G1ZO2fG/wcLA6pUo5rkXpnXfYf48Tt/VPvrkXb4MVdp+4k
   6sO1/pr+58y6wLwVm/qgDL+p+N2VQNAIDEayPkDl+dJnP4A31xrZPdWOi
   EkJZSVzS8QUe6ZyjDJSQvLe9HHQhJlhLDT5bdkSyPN0jQ2k9X2X5FmOJu
   r8lLZukQp13KQSynu3+MWyQ/UNjTXdyqgK6DQ3ZBP7JdHEe4p6BWChCo6
   SQCM4mcfY+wu/AaF7XWxh7bvcNDfhonHgG1oZncRdcRUGCq1uM4+JxBDb
   mochwQbzjnCsJcHiibBx2vMF9qw0YFs78DZEGSQcs4eAoEvtjMaInf2WG
   A==;
X-CSE-ConnectionGUID: 4Pbgvq4CTDeaSD6az0KSkw==
X-CSE-MsgGUID: wZ8DiGtqRS21vw3dEYbnoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="95492991"
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="95492991"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 20:03:32 -0700
X-CSE-ConnectionGUID: eSiPyL4ETDijiCl2MLOARA==
X-CSE-MsgGUID: Uhtg7cSbTCeBgO4x5+/fjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="168957"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.111.241]) ([10.125.111.241])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 20:03:30 -0700
Message-ID: <2a0bf5e8-281f-4c9f-a0ea-ac195604eae9@intel.com>
Date: Thu, 1 Oct 2026 20:03:28 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] nvdimm/pmem: remove test_and_clear_pmem_poison()
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny <iweiny@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>, Oscar Salvador <osalvador@suse.de>
References: <20260923055318.57485-1-kaitao.cheng@linux.dev>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20260923055318.57485-1-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/22/26 10:53 PM, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> The pmem driver provides test_and_clear_pmem_poison() only to handle
> the CONFIG_MEMORY_FAILURE dependency of TestClearPageHWPoison().
> The wrapper has no other pmem-specific behavior.
> 
> Define the HWPoison test-and-change helpers to return false when
> CONFIG_MEMORY_FAILURE is disabled.  This allows pmem to call
> TestClearPageHWPoison() directly in all configurations.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> Changes in v2 (David Hildenbrand, Oscar Salvador):
> - squash patch#1 into patch#2.
> 
> Link to v1:
> https://lore.kernel.org/all/20260903053535.17611-1-kaitao.cheng@linux.dev/
> ---
>  drivers/nvdimm/pmem.c      |  2 +-
>  drivers/nvdimm/pmem.h      | 12 ------------
>  include/linux/page-flags.h |  1 +
>  3 files changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 30a51c365ce8..5fb86595e8bd 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct pmem_device *pmem, phys_addr_t offset,
>  		 * here since we're in the driver I/O path and
>  		 * outstanding I/O requests pin the dev_pagemap.
>  		 */
> -		if (test_and_clear_pmem_poison(page))
> +		if (TestClearPageHWPoison(page))
>  			clear_mce_nospec(pfn);
>  	}
>  }
> diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
> index a48509f90196..76870505dd79 100644
> --- a/drivers/nvdimm/pmem.h
> +++ b/drivers/nvdimm/pmem.h
> @@ -1,7 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #ifndef __NVDIMM_PMEM_H__
>  #define __NVDIMM_PMEM_H__
> -#include <linux/page-flags.h>
>  #include <linux/badblocks.h>
>  #include <linux/memremap.h>
>  #include <linux/types.h>
> @@ -31,15 +30,4 @@ long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>  		long nr_pages, enum dax_access_mode mode, void **kaddr,
>  		unsigned long *pfn);
>  
> -#ifdef CONFIG_MEMORY_FAILURE
> -static inline bool test_and_clear_pmem_poison(struct page *page)
> -{
> -	return TestClearPageHWPoison(page);
> -}
> -#else
> -static inline bool test_and_clear_pmem_poison(struct page *page)
> -{
> -	return false;
> -}
> -#endif
>  #endif /* __NVDIMM_PMEM_H__ */
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index ae2ebaed6d4d..3dc79c0c5adf 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -655,6 +655,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
>  #define __PG_HWPOISON (1UL << PG_hwpoison)
>  #else
>  PAGEFLAG_FALSE(HWPoison, hwpoison)
> +TESTSCFLAG_FALSE(HWPoison, hwpoison)
>  #define __PG_HWPOISON 0
>  #endif
>  

