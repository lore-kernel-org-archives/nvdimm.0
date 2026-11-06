Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794001805;
	b=1xInn+rs12XFTFDeEj2a+5OmhaYqDTQlE6HgBEnfx3I4+GaEB6Kdau2BBJXzDs/YWok6
	 /ZYQySuEJhPn7zjFN+i1Mr6k2Iq8D4An5j8JNRvj6GAoVxaqp6N0kju3BfddYY2XTxfiS
	 GWlUVeNrd58mV43YBvjOMneV9xwVOi4sjuwpDcaW3k7rqxcfA9/mqbcQHN6J2wBJ/gSIH
	 xWVaCO1YzRL9iN7wcUaLusph1cWv/BZGizZ4280+6o7uceSZtnlHorS3n8ClD8KG+xeOb
	 gYNTbmRyYuuLeCGIJaipM6ok1SeRT3eT3105jc2bdIf9zIQSJdrhxWLmq9H0Zp+6ocw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794001805;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Sp+/rZLBk58dvEP4ySui6/tvD/UNJbnX6ljbENoMxUA=;
	b=fg+/v2miRIDlTW5J56OYEpiRvYxLpHwsEI0efa7fNvDANQtmDTuZIKj8+TvFykv1AeH/
	 irP3mcYpxyxY9gAW50zG3buldqaNlKn7v3L7bQFCjWeemwjijAEqMx59n9KInUmCKt6aT
	 MofT8lbpOqBK68OMr8olNVqYlza4ZjdgpZT1Tw1gJNM5Hao86A5ko/l1gou6Gaj+W4tgY
	 xLdaRqAWppMHK85XMDe1S67NyJu2fvnEmyfF6KPUot5jYVdaQ7DbTKkV9CGApSnsYrdrl
	 UsNgU10iGRiFHNEinsH/0tT0toscoSHGgAFc/jtXwHYV8g7mUSgSGcwQBFwAiSCY4cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Aze8xafZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E338606A331;
	Fri,  6 Nov 2026 21:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Aze8xafZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062D11F008A1;
	Fri,  6 Nov 2026 21:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794001805;
	bh=Sp+/rZLBk58dvEP4ySui6/tvD/UNJbnX6ljbENoMxUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Aze8xafZlbHSmp3d9gsGH2mJakJ8WzD3a2I45CcQLXgo64iNKE9xQZkacX0lkm+9H
	 hRcq5aQCb7lhna/x+9R8R7cPJekBVR8qzl+vs0kvEjC7gv4hCBavI2iFcZHoyBbIxk
	 OsKrdYgxpffMHW2RcNCeXDXQNPHXmOMTR3X8A07Lcck4kt6GhplMauazqY8/y91dGC
	 MbIV/XErrSL3SDbgNCcMMult+cttS6IGg4xRe5v8Uks98nl//+qeG3FmmaFZdaMpcR
	 di+qSJ9HSlfFF9zMdStZ/es33HXVWlqN+tgeWgCWrszeElUjZPfB/2tkbYIgPhsF+9
	 E3nvl4tKuSHPQ==
Message-ID: <54d9955d-a3ac-4aac-98e3-75dec5c64294@kernel.org>
Date: Fri, 6 Nov 2026 22:48:13 +0100
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
Subject: Re: [PATCH] mm/huge_memory: use folio_dup_file_rmap_pud() in
 copy_huge_pud()
To: Konstantin Khorenko <khorenko@virtuozzo.com>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-v1-1-cf8ee4fafabb@virtuozzo.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-v1-1-cf8ee4fafabb@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/26 18:05, Konstantin Khorenko wrote:
> copy_huge_pud() adds the child's rmap of a device DAX PUD with
> folio_add_file_rmap_pud(). That helper maps a folio afresh: it updates
> NR_FILE_MAPPED when the folio becomes mapped and mlocks it in a
> VM_LOCKED VMA. Neither applies at fork: the parent keeps the folio mapped
> under the page table lock, and dup_mmap() clears VM_LOCKED in the
> child's VMA.
> 
> copy_present_ptes() duplicates the rmap of a PTE with
> folio_dup_file_rmap_ptes(), which only raises the mapcounts. Add
> folio_dup_file_rmap_pud() for the PUD level and use it in copy_huge_pud().
> 
> No functional change.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
> David's fix for the device DAX PUD fork bug, commit d90bdc02e36e
> ("mm/huge_memory: properly handle refcounted PUD mappings on fork"),
> went in before v2 of my series for the same bug [1].
> 
> This is the follow-up David asked for [2].
> 
> The Reviewed-by tags are from v2 patch 1, whose rmap.h hunk and
> copy_huge_pud() line this patch carries unchanged.
> 
> The selftest from v2 [3] is not included, as it needs a real devdax
> device. It is there for anyone who wants to run it.
> 
> Based on thp-7.5.misc of the mm/core tree.
> 
> [1] https://lore.kernel.org/all/20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com/
> [2] https://lore.kernel.org/all/6f035f97-8b55-47ad-bd52-833b86b8ae8f@kernel.org/
> [3] https://lore.kernel.org/all/20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-2-2828fe5a51ed@virtuozzo.com/
> 
> Assisted-by: LLM
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks, I'll wait a bit and then pick this up.


-- 
Cheers,

David
