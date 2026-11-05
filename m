Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793910678;
	b=yl6raqKlk7Dn6zfDE6bgM0nXgK6tDfzMyYBFAdwheSReaCF5tGXHpfzygObWhOHDUn9l
	 j7zwkdq89wiKIfl5NGxW5uPkcJXi3uol3gdYaRRer6RJJxrKYh8p3cz9qE7OKTTJRfgz0
	 765ft7WTpfnivuYA9L5g08iDE4nTf0Q+GhL9rslCjRXFHYbtZrBOfgT9UdaS6C91T2h2p
	 UVM4tx7ISiswCzcPPxCsjchHgM98MlJ1HKhdvCR0n5AatJk5K5lJoyncjqLdtiqH26BFr
	 QQznToW8AHStd6FdxS+10jFJ1tB930sAgf5Q7nhpzeru8lBsu7b8BW90exHiu35zkdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793910678;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=TdhuTks2opBXvdhTmIB8yv80bnVd5dlxad76wxXRLWI=;
	b=k715newbfSnjQf1tWr1iUAof5i3TodtInIS3CFcz773tkcOJuOUrz4DhOHwgUfaLqtZz
	 84Pn2HVgs9KtpN33LPERPJbLsAsM+NhxXUWzOsVHhgAPjccDclHQQr/nKjcAMW6ukVrf8
	 bbTlhQjodyaffEBUfIXUbIBqOGTTMFlRYeBF6ZPB9FFmHpbeyj4ZzcsK4BX4VspFHn6y0
	 jYyqfjkUdaXDxnzMBKeqVLTkh8sEdocD+Km1W2MaPPH/ah/FWYtOWH0nNzLVTUT0IMu8V
	 M1pXeKn26o5ygLoJ1E3JZ6T3s5kpHDn9vOmf03SdsByJQ2t+oPEzZ0b7oGISUh/fiCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a4iMyxMc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FBC606A31B;
	Thu,  5 Nov 2026 20:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a4iMyxMc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BFE1F008A2;
	Thu,  5 Nov 2026 20:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793910677;
	bh=TdhuTks2opBXvdhTmIB8yv80bnVd5dlxad76wxXRLWI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=a4iMyxMcWpMfFTfJfNIxFDxA2rvaiekwJvEwJVsD9AgMRJYdXpBXRleMgAFa6IxCh
	 FxiqU8rJv64UEvYRZ/6gYYVbzscWelg+mWv6Rxml44hPWU7nbHgAHW+v4VYvIkPkV/
	 jrzS2BWYyBBEhdTGjYy+JSwh3g9ayrWo75JJNUfN3IjmNpC5TetPa3YBI7J/+aCUtz
	 nuds2tJ1nAwIwPSzDtyMCHzmRlVcDD71BoLwOLZUrwm7nw+6xozQ0y395XW5qmFo/Q
	 xefxjYblhwNI3XBSZj8pucJn0jKefeiSb46zGHMzeR/nBVDl3ee61bD0gtDrlU+qrF
	 qUHeYhx3uhbZQ==
Message-ID: <6f035f97-8b55-47ad-bd52-833b86b8ae8f@kernel.org>
Date: Thu, 5 Nov 2026 21:31:09 +0100
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory: take a reference on a folio PUD
 copied by fork
To: Zi Yan <ziy@nvidia.com>, Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com>
 <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-1-2828fe5a51ed@virtuozzo.com>
 <DMNK05HCXYUJ.578OO1NG15LZ@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <DMNK05HCXYUJ.578OO1NG15LZ@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/5/26 21:19, Zi Yan wrote:
> On Thu Nov 5, 2026 at 12:00 PM EST, Konstantin Khorenko wrote:
>> Device DAX maps its memory with vmf_insert_folio_pud(), which takes a
>> folio reference, adds a PUD rmap and accounts the pages to the mm.
>> zap_huge_pud() drops all three, but copy_huge_pud() copies the PUD into
>> the child without taking any of them. Each child's unmap then drops
>> what the parent took:
>>
>> - the folio is a reference short, so with two children its refcount
>>   drops to zero and free_zone_device_folio() runs while the parent
>>   still maps it;
>> - the child's file counter goes negative, "Bad rss-counter state" when
>>   its mm is freed;
>> - the parent's unmap drives the entire mapcount below zero.
>>
>> fork copies the page tables of a device DAX mapping that has a guard
>> region, and commit f807123d578d ("mm: allow guard regions in file-backed
>> and read-only mappings") allowed MADV_GUARD_INSTALL there.
>>
>> Take the reference, the rmap and the counter for a PUD that
>> vm_normal_page_pud() resolves to a page, as copy_present_ptes() does for
>> a PTE, with a new folio_dup_file_rmap_pud() helper. copy_huge_pud() now
>> needs both VMAs, so pass only them and take the mms from them.
>>
>> Fixes: aed877c2b425 ("device/dax: properly refcount device dax pages when mapping")
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
>> ---
>>  include/linux/huge_mm.h |  5 ++---
>>  include/linux/rmap.h    | 22 ++++++++++++++++++++++
>>  mm/huge_memory.c        | 27 +++++++++++++++++++--------
>>  mm/memory.c             |  4 +---
>>  4 files changed, 44 insertions(+), 14 deletions(-)
>>
> 
> I assume this supersedes David's version[1], which uses
> folio_add_file_rmap_pud().
> 
> [1] https://lore.kernel.org/all/20261031-fixes_core-v3-11-d6437171ecc3@kernel.org/

Ugh, I thought I dropped it to wait for this one here. But turns out the flood
of patches confused me :( (hoping I didn't drop another one by mistake)

It's already part of the fixes PULL request:

https://lore.kernel.org/linux-mm/20261105084704.5703-1-david@kernel.org/

Konstantin, sorry! Can you send a follow up to introduce+use the dup variant?

-- 
Cheers,

David
