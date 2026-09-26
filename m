Received: from mta0.migadu.com (out-212.mta0.migadu.com [91.218.175.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F6B3A5433
	for <nvdimm@lists.linux.dev>; Sat, 26 Sep 2026 07:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790406409; cv=none; b=i1vn/Wio+4HdsCwnfD4aE8Ajf75KE8wYc2XLYgyv0j8l2sQtJas85GWRT2bU2gbd5hTV7dqml7FlhmGpCwq2fMEwIRh6d3fM/RpaB0v+pVn/DJNLWsnWkQccOmmAD4IZfSY0gghr148k7LvtmRNchfHx9CEboqSn05Rfvmh1/z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790406409; c=relaxed/simple;
	bh=T2p2H25v2pZGOR2O6w90y62GhLcCItp+jxccTxyxKa4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XOsl4Ou6Tivrt5A//xhJCbnEUwiQev8YKAxBdMsBYWX1hLXQsa3/9t+ZqEJlYMn0w2xrLChvT1A9IzPJ9V87h0KGEJI9s4xdYUuMAgjKPI42/5qRDET0fOD7dFuLOKa0UG4P2WKctfWquu97LNExtS3kz7lItNP3yOpPtNwH1fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aJd7J7E6; arc=none smtp.client-ip=91.218.175.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aJd7J7E6"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=T2p2H25v2pZGOR2O6w90y62GhLcCItp+jxccTxyxKa4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790406402; v=1; x=1791011202;
 b=aJd7J7E6yqryLaw4nLpbgu/FKtofXZ5qfATpxUBwnSANmuAG7DHMaU2WY18yGnU3VAji3026
 AD4S90AWgrmF+zXG/uS8rsO3S3+zSvQM5YppNtV32D52scEMz39KfN9IcM6zMixUw9i6CqRptfm
 7/olAmvU2ZqF6olU1FErgUDk=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta11.migadu.com with ESMTPS id b8b31df069231cb1;
	Sat, 26 Sep 2026 07:06:42 +0000
X-Mizu-Trace-ID: b8b31df069231cb1
X-Migadu-Flow: FLOW_OUT
Message-ID: <3e2690a2-06f9-4819-8e55-2129ab6566ab@linux.dev>
Date: Sat, 26 Sep 2026 15:06:32 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/page-flags: Define HWPoison test-and-change
 helpers unconditionally
To: Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
 <20260903053535.17611-2-kaitao.cheng@linux.dev>
 <6eb272c0-0cfa-4354-a92b-4fc270e3b1fc@kernel.org>
 <20260925231908.25febf6c085f52be3a65d59b@linux-foundation.org>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <20260925231908.25febf6c085f52be3a65d59b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

在 2026/9/26 14:19, Andrew Morton 写道:
> On Mon, 7 Sep 2026 17:42:11 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 9/3/26 07:35, Kaitao Cheng wrote:
>>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>
>>> Page flag helpers for configuration-dependent flags provide false or no-op
>>> variants so that their users can be independent of the configuration.
>>>
>>> The HWPoison helpers do not fully follow this pattern. When
>>> CONFIG_MEMORY_FAILURE is enabled, PAGEFLAG() and TESTSCFLAG() provide the
>>> regular, test-and-set, and test-and-clear operations. When it is disabled,
>>> only PAGEFLAG_FALSE() is instantiated, leaving TestSetPageHWPoison() and
>>> TestClearPageHWPoison() undefined.
>>>
>>> Use TESTSCFLAG_FALSE() to provide the missing accessors when memory failure
>>> handling is disabled. Both accessors return false, which is consistent with
>>> HWPoison state being unavailable, and makes the accessor interface
>>> consistent across configurations.
>>>
>>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>>> ---
>>>  include/linux/page-flags.h | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>>> index 7a863572adce..a2315ab1dd3a 100644
>>> --- a/include/linux/page-flags.h
>>> +++ b/include/linux/page-flags.h
>>> @@ -656,6 +656,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
>>>  #define __PG_HWPOISON (1UL << PG_hwpoison)
>>>  #else
>>>  PAGEFLAG_FALSE(HWPoison, hwpoison)
>>> +TESTSCFLAG_FALSE(HWPoison, hwpoison)
>>>  #define __PG_HWPOISON 0
>>>  #endif
>>>  
>>
>> Can we just squash this patch into #2 please?
> 
> I did that.

I’ve also posted a v2 version.
https://lore.kernel.org/all/20260923055318.57485-1-kaitao.cheng@linux.dev/

> 
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> Subject: mm/page-flags: define HWPoison test-and-change helpers unconditionally
> Date: Thu, 3 Sep 2026 13:35:34 +0800
> 
> Page flag helpers for configuration-dependent flags provide false or no-op
> variants so that their users can be independent of the configuration.
> 
> The HWPoison helpers do not fully follow this pattern.  When
> CONFIG_MEMORY_FAILURE is enabled, PAGEFLAG() and TESTSCFLAG() provide the
> regular, test-and-set, and test-and-clear operations.  When it is
> disabled, only PAGEFLAG_FALSE() is instantiated, leaving
> TestSetPageHWPoison() and TestClearPageHWPoison() undefined.
> 
> Use TESTSCFLAG_FALSE() to provide the missing accessors when memory
> failure handling is disabled.  Both accessors return false, which is
> consistent with HWPoison state being unavailable, and makes the accessor
> interface consistent across configurations.
> 
> Also remove now-unneeded test_and_clear_pmem_poison() from nvdimm/pmem.
> 
> Link: https://lore.kernel.org/20260903053535.17611-1-kaitao.cheng@linux.dev
> Link: https://lore.kernel.org/20260903053535.17611-2-kaitao.cheng@linux.dev
> Link: https://lore.kernel.org/20260903053535.17611-3-kaitao.cheng@linux.dev
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Ira Weiny <iweiny@kernel.org>
> ---
> 
>  drivers/nvdimm/pmem.c      |    2 +-
>  drivers/nvdimm/pmem.h      |   12 ------------
>  include/linux/page-flags.h |    1 +
>  3 files changed, 2 insertions(+), 13 deletions(-)
> 
> --- a/include/linux/page-flags.h~mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally
> +++ a/include/linux/page-flags.h
> @@ -655,6 +655,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
>  #define __PG_HWPOISON (1UL << PG_hwpoison)
>  #else
>  PAGEFLAG_FALSE(HWPoison, hwpoison)
> +TESTSCFLAG_FALSE(HWPoison, hwpoison)
>  #define __PG_HWPOISON 0
>  #endif
>  
> --- a/drivers/nvdimm/pmem.c~mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally
> +++ a/drivers/nvdimm/pmem.c
> @@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct p
>  		 * here since we're in the driver I/O path and
>  		 * outstanding I/O requests pin the dev_pagemap.
>  		 */
> -		if (test_and_clear_pmem_poison(page))
> +		if (TestClearPageHWPoison(page))
>  			clear_mce_nospec(pfn);
>  	}
>  }
> --- a/drivers/nvdimm/pmem.h~mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally
> +++ a/drivers/nvdimm/pmem.h
> @@ -1,7 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #ifndef __NVDIMM_PMEM_H__
>  #define __NVDIMM_PMEM_H__
> -#include <linux/page-flags.h>
>  #include <linux/badblocks.h>
>  #include <linux/memremap.h>
>  #include <linux/types.h>
> @@ -31,15 +30,4 @@ long __pmem_direct_access(struct pmem_de
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
> _

-- 
Thanks
Kaitao Cheng

