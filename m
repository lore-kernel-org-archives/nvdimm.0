Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9FF2857E2
	for <nvdimm@lists.linux.dev>; Fri,  6 Jun 2025 08:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749198399; cv=none; b=Euyihl7DFSsJjng/6nLKa1j5l9VV3Xmdpbpk29QRrJKrvYMJa6MOrO/54q4oZpbrgo19Kan3btCc/Oar7pS3ZGyDTOj37m1x7rDxvknOkJuFv0G+07T0+LGFePAHGKDN2mMl+3g1WUPuLDKcFXmT2Ua4b9lLNGjDtvfGSEqsD+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749198399; c=relaxed/simple;
	bh=D7gHEpfkxQ6Uvt1H4cUoE1Sk1l5EYXiGF0yQ+Dr6ehA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T2NcGeVuxmksM3LrNAFETlkeQbYMiuP6zqMh1+4dZ4rEXFswrzZTXXLDIGJdhj8RC/1VYJundyDfruU8AFUJn/WnEWHrkZ/Cc8pR7mtKAntFaMJQUhW0ddM/+C2+EK4KUisai0gluVn78gkI7s07NJKoapaGvxHEhCJd4f3vPII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RAMqapaE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=joF/cB38; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RAMqapaE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=joF/cB38; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RAMqapaE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="joF/cB38";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RAMqapaE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="joF/cB38"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4B55C1F79E;
	Fri,  6 Jun 2025 08:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749198396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mid1kH4OKE9bgaX15SmE1nQ08hTR8IepPOFIfoJ4/zg=;
	b=RAMqapaEEIGmcfJrQqhT75jIusWqUIiYaxjYJAJVhIHZXAWSzblPaun51QMI5ANaum/nbX
	X2ROmt9+8ENpsOBYDATsI/3+TkE3z3Wt1DGmd35UhTwkdE4rJZKyZuonK6NztRVZREMRz9
	zmHAmSOpJ0Jd/VUo94HrIPGGqByT1HY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749198396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mid1kH4OKE9bgaX15SmE1nQ08hTR8IepPOFIfoJ4/zg=;
	b=joF/cB38BB6PyisyaUYzFhPzeZnUHqMCkSM7QplTq1F/RfncfA1ggXfxNNnFK5Ga9c5rDe
	S31+slPHemjmJQDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749198396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mid1kH4OKE9bgaX15SmE1nQ08hTR8IepPOFIfoJ4/zg=;
	b=RAMqapaEEIGmcfJrQqhT75jIusWqUIiYaxjYJAJVhIHZXAWSzblPaun51QMI5ANaum/nbX
	X2ROmt9+8ENpsOBYDATsI/3+TkE3z3Wt1DGmd35UhTwkdE4rJZKyZuonK6NztRVZREMRz9
	zmHAmSOpJ0Jd/VUo94HrIPGGqByT1HY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749198396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mid1kH4OKE9bgaX15SmE1nQ08hTR8IepPOFIfoJ4/zg=;
	b=joF/cB38BB6PyisyaUYzFhPzeZnUHqMCkSM7QplTq1F/RfncfA1ggXfxNNnFK5Ga9c5rDe
	S31+slPHemjmJQDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43E791369F;
	Fri,  6 Jun 2025 08:26:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RDjUDTumQmgUBgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Fri, 06 Jun 2025 08:26:35 +0000
Date: Fri, 6 Jun 2025 10:26:33 +0200
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
Message-ID: <aEKmOfWDIy14Ub6n@localhost.localdomain>
References: <20250603211634.2925015-1-david@redhat.com>
 <20250603211634.2925015-2-david@redhat.com>
 <aEKkvdSAplmukcXz@localhost.localdomain>
 <b6a1b97b-39d9-4c9e-ba95-190684fc4074@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a1b97b-39d9-4c9e-ba95-190684fc4074@redhat.com>
X-Spam-Flag: NO
X-Spam-Score: -4.30
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[localhost.localdomain:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Fri, Jun 06, 2025 at 10:23:11AM +0200, David Hildenbrand wrote:
> See my reply to Dan.
> 
> Yet another boolean, yuck. Passing the folio and the pfn, yuck.
> 
> (I have a strong opinion here ;) )

ok, I see it was already considered. No more questions then ;-)


-- 
Oscar Salvador
SUSE Labs
