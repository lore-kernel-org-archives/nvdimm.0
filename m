Received: from mta1.migadu.com (out-30.mta1.migadu.com [95.215.58.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0851373BEC
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 03:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791604656; cv=none; b=C65Mu1LluVYk+O/mT/2MKmuf+yH+QnXBtmQgLKcrJ0JXE2BQJvZMnLoNfkYw67fqwOoIw0JF3VrcmjDpjAzCQJf95xy+MBg+FtPxiGTCH1svKstCuPQGNOXilsthXm52smQq6HSa8ZOVToTY2aLzWoosfysbhjftYRR8+eeHY6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791604656; c=relaxed/simple;
	bh=pqSalTwZbRx4UVyHrQemVyuzGIN85uoeQ6V8gwJ3UrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QrRVzxZ8ovE2qVgRYde35XsKwilWTLNhPLBDk67QZ7xSCOhMC9G5xyuzA8gHyBFbz1Ekdc8bsxQwNp6IgvuGAdmCQPzWq8OCXhpifYJsVfUY/O/Y3P1O7NEyFzEmpJWxocYrAriYG35i8PyC7quZqg9nOZE8XAwfX0I1J44cXuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wplZ5Pq9; arc=none smtp.client-ip=95.215.58.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wplZ5Pq9"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=pqSalTwZbRx4UVyHrQemVyuzGIN85uoeQ6V8gwJ3UrI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791604651; v=1; x=1792209451;
 b=wplZ5Pq9NBhO8d9llWdPZKTekxP+GKvvsOBShwkt/olYQlv1rcBeYvurPqWBsd/Xpi/QcwiR
 Csqmtx9Vdo9xXZ+46D91V98ySmkubluCYcMxMg1ZfmTA3QfNgPGXd+QBfx/lbyJJ8wHz90sGf2y
 iUKLKFCCF50loRk8y4rr3BcU=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta12.migadu.com with ESMTPS id b05c5c691b9353ef;
	Sat, 10 Oct 2026 03:57:31 +0000
X-Mizu-Trace-ID: b05c5c691b9353ef
X-Migadu-Flow: FLOW_OUT
Message-ID: <ca58edc0-3132-4c16-9c45-f23ce51cdd5f@linux.dev>
Date: Sat, 10 Oct 2026 11:57:21 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] nvdimm/pmem: remove test_and_clear_pmem_poison()
To: Alison Schofield <alison.schofield@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>, Oscar Salvador <osalvador@suse.de>
References: <20260923055318.57485-1-kaitao.cheng@linux.dev>
 <asmffUJ1gPDfaAvV@aschofie-mobl2.lan>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <asmffUJ1gPDfaAvV@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/10/10 10:14, Alison Schofield 写道:
> On Wed, Sep 23, 2026 at 01:53:18PM +0800, Kaitao Cheng wrote:
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>
>> The pmem driver provides test_and_clear_pmem_poison() only to handle
>> the CONFIG_MEMORY_FAILURE dependency of TestClearPageHWPoison().
>> The wrapper has no other pmem-specific behavior.
>>
>> Define the HWPoison test-and-change helpers to return false when
>> CONFIG_MEMORY_FAILURE is disabled.  This allows pmem to call
>> TestClearPageHWPoison() directly in all configurations.
> 
> I see this merged here:
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-stable&id=2492d9c0afc02cebe8318155829e7d03bea617b8
> 
> Still not sure how all that works, but I got an email saying merged, yet
> this list was not on the email thread.  

Andrew Morton probably thought the change was straightforward, so he made the
adjustment himself and merged it. There’s nothing wrong with the code itself.

>>
>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Acked-by: Muchun Song <muchun.song@linux.dev>
>> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>> ---
>> Changes in v2 (David Hildenbrand, Oscar Salvador):
>> - squash patch#1 into patch#2.
>>
>> Link to v1:
>> https://lore.kernel.org/all/20260903053535.17611-1-kaitao.cheng@linux.dev/
>> ---
>>  drivers/nvdimm/pmem.c      |  2 +-
>>  drivers/nvdimm/pmem.h      | 12 ------------
>>  include/linux/page-flags.h |  1 +
>>  3 files changed, 2 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
>> index 30a51c365ce8..5fb86595e8bd 100644
>> --- a/drivers/nvdimm/pmem.c
>> +++ b/drivers/nvdimm/pmem.c
>> @@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct pmem_device *pmem, phys_addr_t offset,
>>  		 * here since we're in the driver I/O path and
>>  		 * outstanding I/O requests pin the dev_pagemap.
>>  		 */
>> -		if (test_and_clear_pmem_poison(page))
>> +		if (TestClearPageHWPoison(page))
>>  			clear_mce_nospec(pfn);
>>  	}
>>  }
>> diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
>> index a48509f90196..76870505dd79 100644
>> --- a/drivers/nvdimm/pmem.h
>> +++ b/drivers/nvdimm/pmem.h
>> @@ -1,7 +1,6 @@
>>  /* SPDX-License-Identifier: GPL-2.0 */
>>  #ifndef __NVDIMM_PMEM_H__
>>  #define __NVDIMM_PMEM_H__
>> -#include <linux/page-flags.h>
>>  #include <linux/badblocks.h>
>>  #include <linux/memremap.h>
>>  #include <linux/types.h>
>> @@ -31,15 +30,4 @@ long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>>  		long nr_pages, enum dax_access_mode mode, void **kaddr,
>>  		unsigned long *pfn);
>>  
>> -#ifdef CONFIG_MEMORY_FAILURE
>> -static inline bool test_and_clear_pmem_poison(struct page *page)
>> -{
>> -	return TestClearPageHWPoison(page);
>> -}
>> -#else
>> -static inline bool test_and_clear_pmem_poison(struct page *page)
>> -{
>> -	return false;
>> -}
>> -#endif
>>  #endif /* __NVDIMM_PMEM_H__ */
>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> index ae2ebaed6d4d..3dc79c0c5adf 100644
>> --- a/include/linux/page-flags.h
>> +++ b/include/linux/page-flags.h
>> @@ -655,6 +655,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
>>  #define __PG_HWPOISON (1UL << PG_hwpoison)
>>  #else
>>  PAGEFLAG_FALSE(HWPoison, hwpoison)
>> +TESTSCFLAG_FALSE(HWPoison, hwpoison)
>>  #define __PG_HWPOISON 0
>>  #endif
>>  
>> -- 
>> 2.54.0 (Apple Git-157)
>>

-- 
Thanks
Kaitao Cheng

