Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BF0284688
	for <nvdimm@lists.linux.dev>; Fri,  6 Jun 2025 08:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749198435; cv=none; b=YWqM7nGQSmxUyj23Gv1bZv3Mtw+d6G4xwRzWHVqfgLcMpD5BWW2f3i+dofg6c1pXIW/cMiml/wOzmngjWSFLk9TVTjDsIoDf90rmNZt1sJP7UmIwqpYfley9Js/vGlE5kwXxv5X3uhVGBtgTpfojoZTArLF38g25TawOypoIf6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749198435; c=relaxed/simple;
	bh=GUe49uEBje2seW3kBTDoZdmBDgc00U9icBdzKvpEZpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GC12sR3GWFX7GT/aVd9mZPANgypKLXywlTbILj7KZZDLbsNOstyiGbW4QVrU1HxWKjuOmjFhrHqAq2fZtyuLTdILtgV0O8Gs1xUwVhtHwqaldWFOXBqr2QDWhznFz3yw2Gscvg5HMp834wduvwCXaGCT0TT78O30XJYs9ROJLIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wO3P6wlX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=97BLMfZJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wO3P6wlX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=97BLMfZJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wO3P6wlX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="97BLMfZJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wO3P6wlX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="97BLMfZJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F202E1F46E;
	Fri,  6 Jun 2025 08:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749198432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AbHdt3R0Dg9obxm/5Tz1H6QEtuLCv5Q1f/9X9tztXsM=;
	b=wO3P6wlXjt+W2MXDO5dpFJQtBoEA+cO0kTABzo8wu0ZgsP/GIND4cEv9ird8Jj3G8dfomz
	0apDkoEosXdlMJ2mO5i7mrUL9GnYJW5IqmKRwDyENFT/OwpIxt5NBae9DUe8WuxUhVmEji
	WIb+diNAClLe+73zzJUpkfbtp+bmNjo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749198432;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AbHdt3R0Dg9obxm/5Tz1H6QEtuLCv5Q1f/9X9tztXsM=;
	b=97BLMfZJ9qD0GtqMNCwjkDm9sNoMwU91m0fym1mB+cyV4t8UjT2cKTAwWqQyv6JCtK13qN
	dXD9J2eP/h35eYCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749198432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AbHdt3R0Dg9obxm/5Tz1H6QEtuLCv5Q1f/9X9tztXsM=;
	b=wO3P6wlXjt+W2MXDO5dpFJQtBoEA+cO0kTABzo8wu0ZgsP/GIND4cEv9ird8Jj3G8dfomz
	0apDkoEosXdlMJ2mO5i7mrUL9GnYJW5IqmKRwDyENFT/OwpIxt5NBae9DUe8WuxUhVmEji
	WIb+diNAClLe+73zzJUpkfbtp+bmNjo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749198432;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AbHdt3R0Dg9obxm/5Tz1H6QEtuLCv5Q1f/9X9tztXsM=;
	b=97BLMfZJ9qD0GtqMNCwjkDm9sNoMwU91m0fym1mB+cyV4t8UjT2cKTAwWqQyv6JCtK13qN
	dXD9J2eP/h35eYCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E88001369F;
	Fri,  6 Jun 2025 08:27:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zkcMNl6mQmhgBgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Fri, 06 Jun 2025 08:27:10 +0000
Date: Fri, 6 Jun 2025 10:27:09 +0200
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
Message-ID: <aEKmXbkbSpaPLXPD@localhost.localdomain>
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
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.30

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

Reviewed-by: Oscar Salvador <osalvador@suse.de>



-- 
Oscar Salvador
SUSE Labs
