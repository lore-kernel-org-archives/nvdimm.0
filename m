Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA7C7494
	for <nvdimm@lists.linux.dev>; Fri, 20 Jun 2025 13:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750426053; cv=none; b=eLP1JxAcwrodvm3N1AijEgPpfpnKzyvSaVMoLxTMxrXkOTVQn/JTQTTe2K1lkeuoCLYQvNeK146U1KWbagqTN8b9VL7lEVsYGLcv9ZNAON/PU8epYuH/KlOtLOdlDo66JHA3GI0+YWykCONFLMPRbee7w7oWylkrJiZ++Xbhwt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750426053; c=relaxed/simple;
	bh=cMxJhVrl1BDfs+W14PyfRTuENsH3+iboNY3yZOpma3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pkH/p74um0vWt/lB1qxV4eyo1zJuU5bo+HAItpPT0hQUEf+eO+IY23svetOQ8787ha+2RQLtQqawPh9kiF1sdpM5Tb0qd2Wf3Mt93PfzsBoBr7xN19eLwDy41+G43LXLzy/bty+C8pAYL4SjamHIENYqt4J2p+NUUXlcYA01e5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SrZK7I/i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rbcXHWdN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aaMZSHXh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4XuwhGd3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SrZK7I/i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rbcXHWdN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aaMZSHXh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4XuwhGd3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C703C1F38D;
	Fri, 20 Jun 2025 13:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1750426049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vgT8B72ZKlzEJ9APlmQgwRxz9E0aS0LaOk9Xz0Vb5bA=;
	b=SrZK7I/idHQMeADoyi8bm7Gu7qlNvVQ8vNv6QSVg4NuOuCrxJ73JTd42Rfe1pkFJND/P4Z
	iu92LuogXspQ0rqPxD2oyvNEPeboPIQZxB3ZJgkzB9LRMpJl0gLlWHO10fXwFnVM4s+UBb
	Tc0l9MIN9WgpZ+IkJsvlIeI5He1/lIE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1750426049;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vgT8B72ZKlzEJ9APlmQgwRxz9E0aS0LaOk9Xz0Vb5bA=;
	b=rbcXHWdNdc/1ZOJ5KnBsNwMXYF/WROay7im1HepUHu6eiIBu86/c6Y6jeYyrDKaQe3Qata
	WvnhF5sj5U+QhqAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aaMZSHXh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4XuwhGd3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1750426048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vgT8B72ZKlzEJ9APlmQgwRxz9E0aS0LaOk9Xz0Vb5bA=;
	b=aaMZSHXhFiFV0HzJNvTLPt4rVoAcKk0gUkK6oyyYfxL34BwPH3C5p62bZTZ/9fF0yyUcmn
	3xfS1bb+euHpu9RYvNXg3mwaYRYZO4n2Qy1qpD6ezNj6Qm4N2kx+RcKNxt0SJxpljQFlPX
	UgHV+hdDeXYXXt2x5apcH3v/4Up8KvQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1750426048;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vgT8B72ZKlzEJ9APlmQgwRxz9E0aS0LaOk9Xz0Vb5bA=;
	b=4XuwhGd3RzSVP1OjxD6GE9GUuRs2nWVC0UGH5efpAp/gxIPGsYsSW6pp8rcn29qfiGOLec
	fQ2pf/B/E6kK++DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F22013A99;
	Fri, 20 Jun 2025 13:27:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pBhfDL9hVWiXOQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Fri, 20 Jun 2025 13:27:27 +0000
Date: Fri, 20 Jun 2025 15:27:25 +0200
From: Oscar Salvador <osalvador@suse.de>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, nvdimm@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH RFC 03/14] mm: compare pfns only if the entry is present
 when inserting pfns/pages
Message-ID: <aFVhvYbRH2dtiFKY@localhost.localdomain>
References: <20250617154345.2494405-1-david@redhat.com>
 <20250617154345.2494405-4-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617154345.2494405-4-david@redhat.com>
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RL88oxspsx4bg3gu1yybyqiqt4)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: C703C1F38D
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -4.51

On Tue, Jun 17, 2025 at 05:43:34PM +0200, David Hildenbrand wrote:
> Doing a pte_pfn() etc. of something that is not a present page table
> entry is wrong. Let's check in all relevant cases where we want to
> upgrade write permissions when inserting pfns/pages whether the entry
> is actually present.

Maybe I would add that's because the pte can have other info like
marker, swp_entry etc.

> It's not expected to have caused real harm in practice, so this is more a
> cleanup than a fix for something that would likely trigger in some
> weird circumstances.
> 
> At some point, we should likely unify the two pte handling paths,
> similar to how we did it for pmds/puds.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

Should we scream if someone passes us a non-present entry?


> ---
>  mm/huge_memory.c | 4 ++--
>  mm/memory.c      | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8e0e3cfd9f223..e52360df87d15 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1392,7 +1392,7 @@ static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
>  		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
>  					  fop.pfn;
>  
> -		if (write) {
> +		if (write && pmd_present(*pmd)) {
>  			if (pmd_pfn(*pmd) != pfn) {
>  				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
>  				return -EEXIST;
> @@ -1541,7 +1541,7 @@ static void insert_pud(struct vm_area_struct *vma, unsigned long addr,
>  		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
>  					  fop.pfn;
>  
> -		if (write) {
> +		if (write && pud_present(*pud)) {
>  			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn))
>  				return;
>  			entry = pud_mkyoung(*pud);
> diff --git a/mm/memory.c b/mm/memory.c
> index a1b5575db52ac..9a1acd057ce59 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2137,7 +2137,7 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
>  	pte_t pteval = ptep_get(pte);
>  
>  	if (!pte_none(pteval)) {
> -		if (!mkwrite)
> +		if (!mkwrite || !pte_present(pteval))
>  			return -EBUSY;

Why EBUSY? because it might transitory?


-- 
Oscar Salvador
SUSE Labs
