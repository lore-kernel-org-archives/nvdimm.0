Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE20283FE8
	for <nvdimm@lists.linux.dev>; Fri,  6 Jun 2025 08:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749198480; cv=none; b=PZheYj+9Vvrxk+mFW2vJYHTLqtw+fLdmCUPQIsR3YsfaooJ0SYa/eTgStCNfEHyFHwyh/m/AYwRFKQLgCVArIdkRQlV0Iv+rMyRxdncpha2W2uzxyeXfJmZajlKtv0cJfJ/PL3jB/l/czqLDYtN2JvZU3NhCDZOSp4aJJjXXflA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749198480; c=relaxed/simple;
	bh=pxzgXOH7f2i5HEYun5Lr3zFDGbof870M40Sioco0D+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P6TwZ3wQLGO2nwjy9qy8VAkvsgaYYzlb3czjrWqPZKVaXC5srW/e0d07ERn9dFPiMfxcotRnzdrnPSW4wp0jJHtmqv9GBFiAWOInLuHDbQSPp8t2OAk5iAZRpxgoJe5gJzRwRbs2D7zqJlBvFujxytAz5dssYYcbwlzE9xf+aeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KOF1jKI2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AR6NHLpV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WPxQ79t0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Eexde3bT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KOF1jKI2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AR6NHLpV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WPxQ79t0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Eexde3bT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D8A9A33891;
	Fri,  6 Jun 2025 08:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749198477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DwzFtLoAJF6LpFfXdB3aqnEfVul/lrSEoNcvLPxWOR4=;
	b=KOF1jKI2gHjfP3lAzs4XdafSN5r//4FT9CH2yZb1SeGzbiBgvK1fEPYJ73EVQNtDzpB8nK
	nj29N2a6kOnU32RqGRjiIxqKs9OyZb8JUpxTbbG6IdOg64IxVXPGU1ECvcg3FC2fHe+JM4
	3vvFpm4p6l1mK63UX+Wlo0b4CclhufY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749198477;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DwzFtLoAJF6LpFfXdB3aqnEfVul/lrSEoNcvLPxWOR4=;
	b=AR6NHLpVXaal8rWTDncnWHccF5IWUPTfv0c5VrVyDQZmryLFXVmkjeW841HFLq0eBBzvNX
	vGXjGbd4+suMzuDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WPxQ79t0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Eexde3bT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749198476; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DwzFtLoAJF6LpFfXdB3aqnEfVul/lrSEoNcvLPxWOR4=;
	b=WPxQ79t0iVA0bJuYeOc6PWTQs7j2Ou3UF1bCN28JThmtwkJRlY3y8agQdemGgXsmBFK7fn
	YnshLE8EWNaJ39vuhkIUGHVWoO4MS5VPS2vmO/4BgeawXmXMFk92YTNSu18CgyBDa8/CAF
	nqtmQsEa2znGnVBckDnjrA3hUpSGEAg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749198476;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DwzFtLoAJF6LpFfXdB3aqnEfVul/lrSEoNcvLPxWOR4=;
	b=Eexde3bTxa1egIHClBT0y3eyFsVnhvrfHQDX2GO8fqyXMir9clNOrqKM21Dou6DsJsKxOe
	erfmSONNOWmLFWDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C2FF31369F;
	Fri,  6 Jun 2025 08:27:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AEbsLIumQminBgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Fri, 06 Jun 2025 08:27:55 +0000
Date: Fri, 6 Jun 2025 10:27:54 +0200
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
Subject: Re: [PATCH v1 2/2] mm/huge_memory: don't mark refcounted pages
 special in vmf_insert_folio_pud()
Message-ID: <aEKmivRxYEytAIaa@localhost.localdomain>
References: <20250603211634.2925015-1-david@redhat.com>
 <20250603211634.2925015-3-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250603211634.2925015-3-david@redhat.com>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D8A9A33891
X-Rspamd-Action: no action
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51
X-Spam-Level: 

On Tue, Jun 03, 2025 at 11:16:34PM +0200, David Hildenbrand wrote:
> Marking PUDs that map a "normal" refcounted folios as special is
> against our rules documented for vm_normal_page().
> 
> Fortunately, there are not that many pud_special() check that can be
> mislead and are right now rather harmless: e.g., none so far
> bases decisions whether to grab a folio reference on that decision.
> 
> Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
> implications as it seems.
> 
> Getting this right will get more important as we introduce
> folio_normal_page_pud() and start using it in more place where we
> currently special-case based on other VMA flags.
> 
> Fix it by just inlining the relevant code, making the whole
> pud_none() handling cleaner.
> 
> Add folio_mk_pud() to mimic what we do with folio_mk_pmd().
> 
> While at it, make sure that the pud that is non-none is actually present
> before comparing PFNs.
> 
> Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs
