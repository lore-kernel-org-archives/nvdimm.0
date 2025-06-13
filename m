Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FA915530C
	for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 13:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749821702; cv=none; b=N2oYkXLAtwCDhryo6iHiAC4WBxeLGsOHqqM61xT/8+3MJUIJqgZNsz0MiCzsgnu5ApP+x3ck/jMhXwy/tUWLD8JzETyVk+XbOBS6KKzS0klwCLpSTCYSaKYs4s7A5Jd3TWEgm3x2Hf1zHyDLyjo+tVQCTTHTD/V1VkN6DVGMV/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749821702; c=relaxed/simple;
	bh=XkMEBbTYnB+JeeXyiEmPzLJHSnxCwIn+zzhMy1tKDyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BR4pYwN24kdrKWqLm6uPoW9yE3SeXpDkyhgjz9/pnXvhIrq0sWz8M29HCRUtLH1UtNqYUfSVni2/GxcQt32MGXBX4wRtaSpTcejwWVO8TVUZQS8NzS55sjVXH5RVB1SjwbGJOHo0wt9lr95enkx30v7mlpIWM/K9pRgZtjyGfPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eL3wz9D5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SO8FJIhD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eL3wz9D5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SO8FJIhD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eL3wz9D5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SO8FJIhD";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eL3wz9D5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SO8FJIhD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 432F0219A0;
	Fri, 13 Jun 2025 13:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749821692; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K+MrFWmai8pF8/h/UUDqJNHotxCxTwja1uE2TOdFPFM=;
	b=eL3wz9D5ii5Ei5uDLcHOPf4maC4NKWyq+v5ZIW/z1Zfi+EgE15vu1FYk1DlsmXBxag6t88
	LYLEFGLxsmMSG3Uog3RrHhpfehL1OhWnHmuZRsNxoP+YMFZu3oGoERKO8dqMxFfTqTclQw
	qyQX4xxjvaPq1bI3Ko7Voqy28ZPaUlc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749821692;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K+MrFWmai8pF8/h/UUDqJNHotxCxTwja1uE2TOdFPFM=;
	b=SO8FJIhD43ThSBxjsd6jBeWR4lGQuk18SStUlxOe9zTNwbstyBn97n5geQUSi8WpAH3PLm
	UV2Ufd68xxtC52AA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eL3wz9D5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SO8FJIhD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749821692; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K+MrFWmai8pF8/h/UUDqJNHotxCxTwja1uE2TOdFPFM=;
	b=eL3wz9D5ii5Ei5uDLcHOPf4maC4NKWyq+v5ZIW/z1Zfi+EgE15vu1FYk1DlsmXBxag6t88
	LYLEFGLxsmMSG3Uog3RrHhpfehL1OhWnHmuZRsNxoP+YMFZu3oGoERKO8dqMxFfTqTclQw
	qyQX4xxjvaPq1bI3Ko7Voqy28ZPaUlc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749821692;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K+MrFWmai8pF8/h/UUDqJNHotxCxTwja1uE2TOdFPFM=;
	b=SO8FJIhD43ThSBxjsd6jBeWR4lGQuk18SStUlxOe9zTNwbstyBn97n5geQUSi8WpAH3PLm
	UV2Ufd68xxtC52AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 36BA8137FE;
	Fri, 13 Jun 2025 13:34:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DcdzCvsoTGjsBgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Fri, 13 Jun 2025 13:34:51 +0000
Date: Fri, 13 Jun 2025 15:34:45 +0200
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
	Jason Gunthorpe <jgg@nvidia.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm/huge_memory: don't ignore queried cachemode in
 vmf_insert_pfn_pud()
Message-ID: <aEwo9aUZTwW_rFJ9@localhost.localdomain>
References: <20250613092702.1943533-1-david@redhat.com>
 <20250613092702.1943533-2-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613092702.1943533-2-david@redhat.com>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 432F0219A0
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,nvidia.com:email,suse.de:dkim,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51
X-Spam-Level: 

On Fri, Jun 13, 2025 at 11:27:00AM +0200, David Hildenbrand wrote:
> We setup the cache mode but ... don't forward the updated pgprot to
> insert_pfn_pud().
> 
> Only a problem on x86-64 PAT when mapping PFNs using PUDs that
> require a special cachemode.
> 
> Fix it by using the proper pgprot where the cachemode was setup.
> 
> It is unclear in which configurations we would get the cachemode wrong:
> through vfio seems possible. Getting cachemodes wrong is usually ... bad.
> As the fix is easy, let's backport it to stable.
> 
> Identified by code inspection.
> 
> Fixes: 7b806d229ef1 ("mm: remove vmf_insert_pfn_xxx_prot() for huge page-table entries")
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Dan Williams <dan.j.williams@intel.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs
