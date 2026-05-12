Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818FD304BDE
	for <nvdimm@lists.linux.dev>; Tue, 12 May 2026 07:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778571971; cv=none; b=PRRl6y8KfZYWLmcxfJjb8XVyLpvAa51tzi9kCx1IPtjgqXtTYJAhKdl5XSDuWeSMbFdX0ArOZKEgzzWNozO2p+RaWGztxC6lbRQ/zhKCvqgf0OnpDvA2ySC8sEkxLriP9KlOBOEnEd+RHebn+EScsIInXHUJsSk4zssEiEHyRG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778571971; c=relaxed/simple;
	bh=KtJQ7GNOjMBTGpf9NA9jxOzLRK7oE3PjlHGi4Ryzkn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+HpGERD1c2QK1NqjjUngYr3hZBmKCW8pzIUnD05e5Bj5780qNXvfFpjlg+1QH5o7Y8GrszJ0K99D42k4uZcXip9O8Plcoj+if6q8JKSPzTccjrrRZpIoE+uSzLmqqUT/JE6jVtx4OdFoKCtJondgSrvPPF2os3VWhR+b3330Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vhCjewmX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yAfrDtkA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vhCjewmX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yAfrDtkA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vhCjewmX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yAfrDtkA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vhCjewmX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yAfrDtkA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6F8CC75987;
	Tue, 12 May 2026 07:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778571961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yHLdHCWpIuvrGHleD2Jqy4bV6mXhHYzDchTWJ+uooJg=;
	b=vhCjewmXJ14jmPxoyoPljvGVqja25tFl+s2LtOwZBYRHdxqohEUQP9+OmLdjVXs8m0R0IJ
	+drJoUe94iejebihfZ/mn7KVSfqrfqLxYHevtfXm0ZpXJuybWLi5j6g94obqX/j09ke8Co
	OC4F9P3U7ejHYNiY0kU7VKyAVCkuHG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778571961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yHLdHCWpIuvrGHleD2Jqy4bV6mXhHYzDchTWJ+uooJg=;
	b=yAfrDtkAVLmGnC96QM2rmP/5S8skAObsrOQl7kUXYCPBAV5FakoKumbQ6tnx3xhz4JzGf8
	t4aWG1a8tk0RPgCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vhCjewmX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yAfrDtkA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778571961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yHLdHCWpIuvrGHleD2Jqy4bV6mXhHYzDchTWJ+uooJg=;
	b=vhCjewmXJ14jmPxoyoPljvGVqja25tFl+s2LtOwZBYRHdxqohEUQP9+OmLdjVXs8m0R0IJ
	+drJoUe94iejebihfZ/mn7KVSfqrfqLxYHevtfXm0ZpXJuybWLi5j6g94obqX/j09ke8Co
	OC4F9P3U7ejHYNiY0kU7VKyAVCkuHG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778571961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yHLdHCWpIuvrGHleD2Jqy4bV6mXhHYzDchTWJ+uooJg=;
	b=yAfrDtkAVLmGnC96QM2rmP/5S8skAObsrOQl7kUXYCPBAV5FakoKumbQ6tnx3xhz4JzGf8
	t4aWG1a8tk0RPgCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 648F6593A9;
	Tue, 12 May 2026 07:46:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DbmBGLnaAmpYUQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 12 May 2026 07:46:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0758CA093D; Tue, 12 May 2026 09:45:52 +0200 (CEST)
Date: Tue, 12 May 2026 09:45:52 +0200
From: Jan Kara <jack@suse.cz>
To: Souvik Banerjee <souvik@amlalabs.com>
Cc: djbw@kernel.org, david@kernel.org, willy@infradead.org, jack@suse.cz, 
	apopple@nvidia.com, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] fs/dax: check for empty/zero entries before calling
 pfn_to_page()
Message-ID: <7hos254p3ta422rfs5bqpvz3p6fmgdagvsxw7nb7vgqew3icq3@77wflvbcdwln>
References: <20260511214020.208939-1-souvik@amlalabs.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511214020.208939-1-souvik@amlalabs.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,nvidia.com:email,suse.cz:dkim,suse.cz:email,amlalabs.com:email];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,nvidia.com:email,suse.cz:dkim,suse.cz:email]
X-Rspamd-Queue-Id: 6F8CC75987
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Mon 11-05-26 21:40:20, Souvik Banerjee wrote:
> Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> added zero/empty-entry early returns to dax_associate_entry() and
> dax_disassociate_entry(), but placed them *after* the
> `struct folio *folio = dax_to_folio(entry);` line.  dax_to_folio()
> expands to page_folio(pfn_to_page(dax_to_pfn(entry))), which calls
> _compound_head() and performs READ_ONCE(page->compound_info) -- a real
> dereference of the struct page pointer derived from a bogus PFN
> extracted from the empty/zero XA value.
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
> zero/empty guard in both dax_associate_entry() and
> dax_disassociate_entry().  Apply the same treatment to dax_busy_page(),
> which has the identical pattern but was not touched by the prior fix.
> dax_associate_entry() is reachable with a zero entry via
> dax_insert_entry() -> dax_associate_entry(new_entry, ...), where
> new_entry can carry DAX_ZERO_PAGE (built by dax_make_entry() in
> dax_load_hole() / dax_pmd_load_hole()).  dax_disassociate_entry() and
> dax_busy_page() additionally see DAX_EMPTY entries created by
> grab_mapping_entry().
> 
> The remaining users of dax_to_folio() / dax_to_pfn() in fs/dax.c are
> either guarded or only reachable on real-PFN entries, so this exhausts
> the anti-pattern.
> 
> Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
> Cc: stable@vger.kernel.org # v6.15+
> Cc: Alistair Popple <apopple@nvidia.com>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v2:
>   - Also fix dax_associate_entry() (Suggested-by: David Hildenbrand,
>     confirmed by Alistair Popple).  The same anti-pattern existed there:
>     dax_to_folio(entry) ran before the zero/empty guard.  new_entry on
>     that path can carry DAX_ZERO_PAGE via dax_load_hole() /
>     dax_pmd_load_hole(), so the dereference reads a struct page derived
>     from the zero-page PFN before the early return discards it.
>   - Audited remaining dax_to_folio() / dax_to_pfn() call sites in fs/dax.c;
>     no further instances of the pattern.
>   - Updated the page_folio() expansion in the commit message to refer to
>     the current field name (page->compound_info via _compound_head()).
> 
> v1: https://lore.kernel.org/all/20260501233933.2614302-1-souvik@amlalabs.com/
> 
>  fs/dax.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 6d175cd47a99..4bca6e2bc342 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -480,11 +480,12 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
>  				unsigned long address, bool shared)
>  {
>  	unsigned long size = dax_entry_size(entry), index;
> -	struct folio *folio = dax_to_folio(entry);
> +	struct folio *folio;
>  
>  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
>  		return;
>  
> +	folio = dax_to_folio(entry);
>  	index = linear_page_index(vma, address & ~(size - 1));
>  	if (shared && (folio->mapping || dax_folio_is_shared(folio))) {
>  		if (folio->mapping)
> @@ -505,21 +506,23 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
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
> -- 
> 2.51.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
