Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D7320298E
	for <nvdimm@lists.linux.dev>; Fri,  6 Jun 2025 08:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749198019; cv=none; b=YjpOGwYZcaXKVFrn5sTIyRuTC4qTvCbJl+kHjQ/ySXzBZapqNYFw/1nHce+oLBa98Orpm1JvbHdwWclsq/N3yVzBs2X9zfomsBrzA/3pgtArn3W8iGOOaRkzywixvThFlZQh3sKG2K370o1pfZOfRLP8w+EhMMe7rS9JyRHc9qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749198019; c=relaxed/simple;
	bh=DFK0enjsDPlNXgMmzgeZ/eEpmn1q/94j/EFDqLqDEGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CxRXJRFJ1sOdhNSL44wWtAWvuQJG6Ouc7dJ/Fs5xL+/2555ubgQw0agdDF7xb5d1xunTRIckcDqB7jX+lOxJXMxAiYQ347L9HjyofSkwaDc/C5skJedq7mB7e+QisNf2J6vQ5H6Jxdia39qBcfGoyGFit0H0wYVmSOE3GM4U0wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MitPkhnC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pr7ciNVw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MitPkhnC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pr7ciNVw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MitPkhnC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pr7ciNVw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MitPkhnC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pr7ciNVw"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 12EE91F46E;
	Fri,  6 Jun 2025 08:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749198016; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xPPCQgVTU9igB5wVJT7oj3CtdzrH4k5GbPxzRDDz2ws=;
	b=MitPkhnCE/m1UL+eiwSqT48a8zIh4RmGtHolImnFPG0Y8bwen2/MXzyvn82oZBa+ByhvBF
	Yc9lgYMCuADcGRTJGmBzFPzQi3Bpn+GWCJqwT928WI9fyN0eybt68nPD6uDm3t16ANUJ1O
	LYhvc67RpnmSlNbW89XNPzerd22tENA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749198016;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xPPCQgVTU9igB5wVJT7oj3CtdzrH4k5GbPxzRDDz2ws=;
	b=pr7ciNVwces3HHVQ0sy0AjX6ZZBoczoDFUyAmHwDKNxZevZNa0w7ZxkkWv92FCF+9rbTUW
	WHtHTvD3VAlmbxAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MitPkhnC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pr7ciNVw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749198016; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xPPCQgVTU9igB5wVJT7oj3CtdzrH4k5GbPxzRDDz2ws=;
	b=MitPkhnCE/m1UL+eiwSqT48a8zIh4RmGtHolImnFPG0Y8bwen2/MXzyvn82oZBa+ByhvBF
	Yc9lgYMCuADcGRTJGmBzFPzQi3Bpn+GWCJqwT928WI9fyN0eybt68nPD6uDm3t16ANUJ1O
	LYhvc67RpnmSlNbW89XNPzerd22tENA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749198016;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xPPCQgVTU9igB5wVJT7oj3CtdzrH4k5GbPxzRDDz2ws=;
	b=pr7ciNVwces3HHVQ0sy0AjX6ZZBoczoDFUyAmHwDKNxZevZNa0w7ZxkkWv92FCF+9rbTUW
	WHtHTvD3VAlmbxAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 105D21369F;
	Fri,  6 Jun 2025 08:20:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OmoQO76kQmgbBAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Fri, 06 Jun 2025 08:20:14 +0000
Date: Fri, 6 Jun 2025 10:20:13 +0200
From: Oscar Salvador <osalvador@suse.de>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 1/2] mm/huge_memory: don't mark refcounted pages
 special in vmf_insert_folio_pmd()
Message-ID: <aEKkvdSAplmukcXz@localhost.localdomain>
References: <20250603211634.2925015-1-david@redhat.com>
 <20250603211634.2925015-2-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250603211634.2925015-2-david@redhat.com>
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[19];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,localhost.localdomain:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 12EE91F46E
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -4.51

On Tue, Jun 03, 2025 at 11:16:33PM +0200, David Hildenbrand wrote:
> Marking PMDs that map a "normal" refcounted folios as special is
> against our rules documented for vm_normal_page().
> 
> Fortunately, there are not that many pmd_special() check that can be
> mislead, and most vm_normal_page_pmd()/vm_normal_folio_pmd() users that
> would get this wrong right now are rather harmless: e.g., none so far
> bases decisions whether to grab a folio reference on that decision.
> 
> Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
> implications as it seems.
> 
> Getting this right will get more important as we use
> folio_normal_page_pmd() in more places.
> 
> Fix it by just inlining the relevant code, making the whole
> pmd_none() handling cleaner. We can now use folio_mk_pmd().
> 
> While at it, make sure that a pmd that is not-none is actually present
> before comparing PFNs.
> 
> Fixes: 6c88f72691f8 ("mm/huge_memory: add vmf_insert_folio_pmd()")
> Signed-off-by: David Hildenbrand <david@redhat.com>

Hi David,

> ---
>  mm/huge_memory.c | 39 ++++++++++++++++++++++++++++++++-------
>  1 file changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d3e66136e41a3..f9e23dfea76f8 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1474,9 +1474,10 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
>  	struct vm_area_struct *vma = vmf->vma;
>  	unsigned long addr = vmf->address & PMD_MASK;
>  	struct mm_struct *mm = vma->vm_mm;
> +	pmd_t *pmd = vmf->pmd;
>  	spinlock_t *ptl;
>  	pgtable_t pgtable = NULL;
> -	int error;
> +	pmd_t entry;
>  
>  	if (addr < vma->vm_start || addr >= vma->vm_end)
>  		return VM_FAULT_SIGBUS;
> @@ -1490,17 +1491,41 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
>  			return VM_FAULT_OOM;
>  	}
>  
> -	ptl = pmd_lock(mm, vmf->pmd);
> -	if (pmd_none(*vmf->pmd)) {
> +	ptl = pmd_lock(mm, pmd);
> +	if (pmd_none(*pmd)) {
>  		folio_get(folio);
>  		folio_add_file_rmap_pmd(folio, &folio->page, vma);
>  		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PMD_NR);
> +
> +		entry = folio_mk_pmd(folio, vma->vm_page_prot);
> +		if (write) {
> +			entry = pmd_mkyoung(pmd_mkdirty(entry));
> +			entry = maybe_pmd_mkwrite(entry, vma);
> +		}
> +		set_pmd_at(mm, addr, pmd, entry);
> +		update_mmu_cache_pmd(vma, addr, pmd);
> +
> +		if (pgtable) {
> +			pgtable_trans_huge_deposit(mm, pmd, pgtable);
> +			mm_inc_nr_ptes(mm);
> +			pgtable = NULL;
> +		}
> +	} else if (pmd_present(*pmd) && write) {
> +		/*
> +		 * We only allow for upgrading write permissions if the
> +		 * same folio is already mapped.
> +		 */
> +		if (pmd_pfn(*pmd) == folio_pfn(folio)) {
> +			entry = pmd_mkyoung(*pmd);
> +			entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
> +			if (pmdp_set_access_flags(vma, addr, pmd, entry, 1))
> +				update_mmu_cache_pmd(vma, addr, pmd);
> +		} else {
> +			WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
> +		}

So, this is pretty much insert_pfn_pmd without pmd_mkdevmap/pmd_mkspecial().
I guess vmf_inser_folio_pmd() doesn't have to be concerned with devmaps
either, right?

Looks good to me, just a nit: would it not be better to pass a boolean
to insert_pfn_pmd() that lets it know whether it "can" create a
devmap/special entries?


-- 
Oscar Salvador
SUSE Labs
