Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D232D9EF8
	for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 13:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749822604; cv=none; b=M8nu8Qq6jE+yZ3EsKiZLqNCB6uG2OcbcH/PUAEB9Dqglr8/H6jpuK1YAXcF43wzKaJS2z9x/jsHvW3H2mTepjnkxDD+gvM4hZXa4DFzipaOsCUot7ToXzDRW9U3YPam67XHxuCZ7yy58lemnX96QJ8WnOKh+RknB3ykEAcdjY8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749822604; c=relaxed/simple;
	bh=48Btmq48StA+CNIKojo0XJZQ2ucjHK2q9m1cr1JmpC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=StysjiGWTWRSyjWvXHKdX+v9DHh1sCKGFGZOZGr4lcJR3L8D3Fg/0VjruODKzg7OxOh0FE1g8eWwsccaCsfQvgF9zE58LILJLv6vwG+DdJEdb6JabkXZhzEh106nea43siSQ3ZKFmUZ0HwaXI062Fkb0sVMDeySyQYpwkhulN4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JFjl4Q+8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=o96Nzw7P; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NbaSZyMh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eVEysA6P; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JFjl4Q+8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="o96Nzw7P";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NbaSZyMh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eVEysA6P"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ECA3A1F397;
	Fri, 13 Jun 2025 13:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749822599; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=isd0zIYqD3QWm/e2mMHa02LcMAiVEgUmouA78tywbwM=;
	b=JFjl4Q+8AQh3LwubknOdgVD4oUmh/ajNptA0CrIeZKCCvmOXloT8lUDyYG+1tNPeQWM3jv
	BLIHQfk/uEkLXQA+j5MHUnsYNPvk/h8jfEH0Diex3gDY1oavFRzRBmzRjSQieqP9jYKzsY
	8pHGvZ/oLdcexdUNfJQ9/H7KdHhD57c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749822599;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=isd0zIYqD3QWm/e2mMHa02LcMAiVEgUmouA78tywbwM=;
	b=o96Nzw7PtgzWpMVZQFmTXHcKaN74FiNyCjJ+V8KDPdlG237umtLqeLOLvbEX2pTAJtefK8
	NoSyXdSxlk/8anCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NbaSZyMh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eVEysA6P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749822597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=isd0zIYqD3QWm/e2mMHa02LcMAiVEgUmouA78tywbwM=;
	b=NbaSZyMh2LIU02VlY3UXMG0lONn/VkG1qtlN1zCkfDwjYs+DM0S4mem9gjq4P1zmqkLmDh
	YVclMWgVBTbaXTR/GzcLBnP66qNBEvTk3rrA224aJdYofXtjFExAGEfDRoX5mGE4EXBD8K
	ANJw+A6+MtTJz7uS40K/npORwMS65BU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749822597;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=isd0zIYqD3QWm/e2mMHa02LcMAiVEgUmouA78tywbwM=;
	b=eVEysA6Ptqu/+c6G9EG/hmLqxlRPje3ZL7uIEDYEnzE4yugEDcubXkv7uHVQ5Kw+so46xd
	ClyMP9aLEV0tJ/AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DA7A9137FE;
	Fri, 13 Jun 2025 13:49:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ng2tMoQsTGhFCwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Fri, 13 Jun 2025 13:49:56 +0000
Date: Fri, 13 Jun 2025 15:49:46 +0200
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
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v3 2/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pmd()
Message-ID: <aEwseqmFrpNO5NJC@localhost.localdomain>
References: <20250613092702.1943533-1-david@redhat.com>
 <20250613092702.1943533-3-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613092702.1943533-3-david@redhat.com>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: ECA3A1F397
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51
X-Spam-Level: 

On Fri, Jun 13, 2025 at 11:27:01AM +0200, David Hildenbrand wrote:
> Marking PMDs that map a "normal" refcounted folios as special is
> against our rules documented for vm_normal_page(): normal (refcounted)
> folios shall never have the page table mapping marked as special.
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
> Fix it by teaching insert_pfn_pmd() to properly handle folios and
> pfns -- moving refcount/mapcount/etc handling in there, renaming it to
> insert_pmd(), and distinguishing between both cases using a new simple
> "struct folio_or_pfn" structure.
> 
> Use folio_mk_pmd() to create a pmd for a folio cleanly.
> 
> Fixes: 6c88f72691f8 ("mm/huge_memory: add vmf_insert_folio_pmd()")
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Tested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Altough we have it quite well explained here in the changelog, maybe
having a little comment in insert_pmd() noting why pmds mapping normal
folios cannot be marked special would be nice.

But just saying :-)

Reviewed-by: Oscar salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs
