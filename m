Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66221F09AD;
	Wed, 20 May 2026 05:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779254686; cv=none; b=KFVdyXqa6jjG9Jp/wiMPz+yUZxWmINzpFc1Y1GK8avoeCH4zeGbYwzUzuXbWZhtfS2OdDvSeaciHr7PJjPnk6ypjzYlPM8nzojFgqlMOsC8NKcKti19w8nIF3ikC8eOsDFFM2efoaNnbkPFHxbxpc+IwR99ojb9LfRasArDDAlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779254686; c=relaxed/simple;
	bh=wt5PL7eZzpDLT1c5IQbwq85XravimGfOYHQ1YUDMvC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F8R14pmecocmIsPbFydAMX0y744JY14bJ1sveVhDIyyVVMnwlhsJZKQXuaTFNdcuPeGB4JxrabE8iqdDdamgSKleYOl/q2NXenN9Qjyftijo06y/CGHIOOUoqdF8gTlAsf9LjRrWzXAmOIOY8ET/RHd//Q9lgNqya8vVZQ1Ea/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CeXhaErD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CeXhaErD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B2D1F00893;
	Wed, 20 May 2026 05:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779254684;
	bh=wR7fOlF0LlueJQhUFw+Vok2GUwf2oNEmjv9G0fGQyXM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CeXhaErDxGhpp5vtO2zAUNlzvSOK+rvobBv4yrq+My2/c6N7ZmhIhP7mWNJYuKhTQ
	 zGAf2AFh+6x/Xq2zT3jAoi3TO6bj5YDfN9UXDhWrGKVY4YFKQkM7+K7n6O4gG7/bqn
	 lJUD5RGZJFNPZ/u2iQzScjHZGCIM67LMUWtXJLWaL7aPHASVd5nL771UbKK1NiZeky
	 jurmxJReNsKW8qdxX1U/JI1wVZNvSU3Ptf/jt+ODPmNkeLE5dj6BxKY8h9m5eSVBBr
	 17hwT9qWV3IuEB/BtOF0lBMP/uPFe1FA+IjtQA3HvFTqLjV/pc31XP164/AyzB1DTT
	 CSd8OEOK2iMsA==
Message-ID: <e9a08bed-3d5f-4606-8d17-80a16a4c82f1@kernel.org>
Date: Wed, 20 May 2026 07:24:36 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
To: Juhyung Park <qkrwngud825@gmail.com>, linux-mm@kvack.org
Cc: stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>, "Mike Rapoport (Microsoft)"
 <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dan Williams <djbw@kernel.org>,
 Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <20260519151008.1399226-1-qkrwngud825@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260519151008.1399226-1-qkrwngud825@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/19/26 17:10, Juhyung Park wrote:
> free_pagetable() is called via free_hugepage_table() with
> get_order(PMD_SIZE) = 9 to free the 2 MB vmemmap PMD leaves that back
> struct page arrays on x86_64. After commit bf9e4e30f353 ("x86/mm: use
> pagetable_free()"), it goes through pagetable_free() instead of
> __free_pages(), and pagetable_free() ultimately calls
> __free_pages(page, compound_order()) which ignores the explicit order
> argument and infers it from the page's compound metadata.
> 
> The vmemmap PMD chunks are allocated by vmemmap_alloc_block() using
> alloc_pages_node() without __GFP_COMP, so PG_head is not set and
> compound_order() returns 0. Only the first of 512 pages of each PMD
> chunk is returned to the buddy allocator on hot-remove; the remaining
> 511 pages stay allocated and become unreachable. Generalized: roughly
> 16 MB leaked per GB of hot-removed memory per cycle.
> 
> The leak affects every memory hot-remove path on x86_64 when
> memmap_on_memory=N (the default), including dax_kmem, virtio-mem,
> balloon drivers, ACPI memory hotplug, and direct sysfs offline+remove.
> memmap_on_memory=Y avoids it because free_hugepage_table() then takes
> the altmap branch and does not call free_pagetable().
> 
> Reproduced with CXL memory toggled through DAX in a loop:
> 
>   daxctl reconfigure-device --mode=system-ram dax0.0 --force
>   daxctl reconfigure-device --mode=devdax    dax0.0 --force
> 
> Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
> Cc: stable@vger.kernel.org
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dan Williams <djbw@kernel.org>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: linux-cxl@vger.kernel.org
> Cc: nvdimm@lists.linux.dev
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>
> ---
>  arch/x86/mm/init_64.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index df2261fa4f98..a2301bddb647 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1024,7 +1024,12 @@ static void __meminit free_pagetable(struct page *page, int order)
>  		free_reserved_pages(page, nr_pages);
>  #endif
>  	} else {
> -		pagetable_free(page_ptdesc(page));
> +		/*
> +		 * Use __free_pages() to honor @order: vmemmap PMD leaves
> +		 * freed here are not compound pages, so pagetable_free()
> +		 * would lose leak 511 of 512 pages per 2 MB chunk.
> +		 */
> +		__free_pages(page, order);
>  	}
>  }
>  

I sent a proper fix for this already:

https://lore.kernel.org/all/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org/

-- 
Cheers,

David
