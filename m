Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996317;
	b=sfX6NuRi533xVGIE9ruEcORAjtEWRSv8V5Qcjb3pVh8RJBs5iuiasHTb/k1hyVv2DEi0
	 OmWSIXKJQD4y4dVxHCz1+Fa+KI8m9bungVVQnGjWo1vp9rfBzJzuAhXTl/b98ZCNQUUix
	 WMORYaCNisanHGuXE2JZBpM9bcasLvilI+QI+4/KMOBymQQwcSwVDBIV5aCiX6wuuKpTy
	 bfbny47hARwdNbxLqe+G6s2fd6RNF+5TA9ICg17gJBJeJEX7DRoCJ8YUzMEcogFqV7CkJ
	 vH0SqubCorCqB6fRl4me5O85+SV8zMvpM9Vve3p9BXckFPMw4IJ4sXDd2UcIMxrdj8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996317;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=d1hpg454e2jIOnA+4nAG8EtFurLO1JUftQj9aOKMgHE=;
	b=DDF2xOiJUuC9N0FhvxTLtmND3Er7qHxoSR90U8DheyFcu0DxR55fSJKQMce/SYbGW/MP
	 jtH+vj3eS5ktsglynEZaZINIrYDZcEFaXz4apYh7miEWCX5EKJ2p17bfWfk2U+FdVIFYU
	 1tBg1aDWKMfzwWeREevZcKUc+/1VA82xsWuUIRUBNyrmzAoZiZl1pQiKQL+i9ueuSHx3L
	 vccRx6PTC8IsbiMohRHD5f/xFZMiKhS0i4hbLlUSFXqB5QDKaSgC7N68YI5xin8OONm+8
	 J1n6OuIMAOUIZXTEIL6co5qvXGirKv1HwGaE+iM4j1xPh6oXoit5aNDQy1/3i2K9nMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WFrWTNwp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF50606A888;
	Wed, 18 Nov 2026 10:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WFrWTNwp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906781F00931;
	Wed, 18 Nov 2026 10:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794996317;
	bh=d1hpg454e2jIOnA+4nAG8EtFurLO1JUftQj9aOKMgHE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WFrWTNwpAM/lmrOunHYIJMuKBmpUWUG3jcpAcdazHqcrznkEMle3KdulXgiO4Z9Eg
	 vIQqCFQK1eTVOEvR/Jg6tpfIrOV7t1x8dkqFLOVjQW44zEETKGyttUlETMvqh4Ly28
	 hDgsqPitK4LN6guJrHI/2A8hbsqA/bQCknZxMEFIUXkMQAyyimY1WzX3EcXJ1QOD7T
	 matAulLtMRFxtsWpL3GJJrE03yoZghzeFkGavS0nVWG14danipunAzWhl9dbYGyMlu
	 MXEpvv9adC05luzHpHLJ97SqzcZLi8M1/uT4cC7vcq/xNY+NuQfxPsI5TPKbZJsqcX
	 yZrSBS1iM5o/w==
Message-ID: <eeb8f13f-4535-4fc8-92ee-5f36bcd5abbc@kernel.org>
Date: Wed, 18 Nov 2026 11:05:09 +0100
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
Subject: Re: [PATCH 3/3] mm/memory: don't upgrade non-present PTEs in
 insert_page_into_pte_locked()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Jingyi Sun <1045704958@qq.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
 <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/17/26 16:58, Mike Rapoport (Microsoft) wrote:
> On a write fault insert_page_into_pte_locked() assumes that a non-empty PTE
> maps a page, compares its PFN with the page being inserted and upgrades
> the PTE to writable.
> 
> Since guard regions are allowed in file-backed mappings,
> MADV_GUARD_INSTALL can put a guard marker into a PTE of a DAX mapping
> after the DAX fault handler found that PTE empty and before it inserts
> the page.
> 
> vmf_insert_page_mkwrite() then extracts a PFN from the marker, hits the
> WARN_ON_ONCE() and fails the fault with SIGBUS instead of the SIGSEGV
> expected on access to a guard region:
> 
>   WARNING: mm/memory.c:2489 at insert_page_into_pte_locked+0x47e/0x490, CPU#3: guard-race/157
>   RIP: 0010:insert_page_into_pte_locked+0x47e/0x490
>   Call Trace:
>    <TASK>
>    insert_page+0x6f/0xc0
>    vmf_insert_page_mkwrite+0x31/0x60
>    dax_fault_iter+0x3be/0x5f0
>    dax_iomap_pte_fault+0x1b8/0x390
>    ext4_dax_huge_fault+0x1a4/0x2f0
>    __do_fault+0x34/0xc0
>    do_fault+0x179/0x610
>    __handle_mm_fault+0x8ca/0x1250
>    handle_mm_fault+0xb4/0x290
>    do_user_addr_fault+0x15f/0x730
>    exc_page_fault+0x83/0x190
>    asm_exc_page_fault+0x26/0x30
> 
> Return -EBUSY for non-present PTEs on write faults like it's done for read
> faults, so that the fault is retried and handle_pte_marker() deals with
> the marker.
> 
> Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 66ad58429967..a80925c61706 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2474,7 +2474,7 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
>  		return 0;
>  	}
>  
> -	if (!mkwrite)
> +	if (!mkwrite || !pte_present(pteval))
>  		return -EBUSY;
>  
>  	/*
> 

Should we CC stable?

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

I'll pick this up.

-- 
Cheers,

David
