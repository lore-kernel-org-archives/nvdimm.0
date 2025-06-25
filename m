Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E15282E1
	for <nvdimm@lists.linux.dev>; Wed, 25 Jun 2025 08:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750839469; cv=none; b=H1q6lqTC6lWDO7fFt6blGRnuboRU/LjZLSO8S18sC/YIFzw9SO6vtZCfeAZMBDYzBIeFfvef7SlKKVQ9oGutOv4yKZI6hE5Ce1FBz8ezXCMPjWAWrotMBftipnxhdRmNm7TFVHfceiaP28JJYm6DoG70LTFuCtV+RcDvVHau9oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750839469; c=relaxed/simple;
	bh=dtkjsSlZWt0+g8LpjNbfZtYq2+9xy+jXNhSFZu433vg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BFIctHI6ut733LyLk5gRZM2Y9hmV1uMdXiVdVzHErxRsPPH6qQHXu7qOZLE5XVf+m/E/kpKielsMupI4TgCl6gl8YKf+PD2mAjZnY2pTI21oyxue1fIm8HoklmzR8IzkZell+zQmua6s16cCgp2XOZVWZVk3rHL7L3yq2DiqTZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Q55K0RB8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=E3mgLJH3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Q55K0RB8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=E3mgLJH3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Q55K0RB8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="E3mgLJH3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Q55K0RB8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="E3mgLJH3"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 774E02118F;
	Wed, 25 Jun 2025 08:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1750839460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N6h6TmZN5hM7wrd5vAf+hKIoaRPRzE8gRfNgOUlI21I=;
	b=Q55K0RB8aZ1MZ3MqDUEosymYMztlMXygjqWMtS09PAf9zXxT+vQPaXZvowgh+Y7cQwpGoa
	vMKLbVH9MlvyhhsUC/DzyivxtnCB97w9bxSeVEbEEZCOjSWPCHLB01NJRWqcvpaDSTU+zz
	P5nxwEuhdoEGj1tEt+CSlZzsfK9w09s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1750839460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N6h6TmZN5hM7wrd5vAf+hKIoaRPRzE8gRfNgOUlI21I=;
	b=E3mgLJH3XznDtoKDZyxl17SCQZWzuP3Hehoka7IIu7AEZQsxlWKlMjJGP8iSxk6psd/nIU
	mp6e2ZsfE4odCUDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1750839460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N6h6TmZN5hM7wrd5vAf+hKIoaRPRzE8gRfNgOUlI21I=;
	b=Q55K0RB8aZ1MZ3MqDUEosymYMztlMXygjqWMtS09PAf9zXxT+vQPaXZvowgh+Y7cQwpGoa
	vMKLbVH9MlvyhhsUC/DzyivxtnCB97w9bxSeVEbEEZCOjSWPCHLB01NJRWqcvpaDSTU+zz
	P5nxwEuhdoEGj1tEt+CSlZzsfK9w09s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1750839460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N6h6TmZN5hM7wrd5vAf+hKIoaRPRzE8gRfNgOUlI21I=;
	b=E3mgLJH3XznDtoKDZyxl17SCQZWzuP3Hehoka7IIu7AEZQsxlWKlMjJGP8iSxk6psd/nIU
	mp6e2ZsfE4odCUDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EFCC613301;
	Wed, 25 Jun 2025 08:17:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G7nNN6KwW2hgGgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 25 Jun 2025 08:17:38 +0000
Date: Wed, 25 Jun 2025 10:17:33 +0200
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
Subject: Re: [PATCH RFC 06/14] mm/huge_memory: support huge zero folio in
 vmf_insert_folio_pmd()
Message-ID: <aFuwnb4RmE4IBmqW@localhost.localdomain>
References: <20250617154345.2494405-1-david@redhat.com>
 <20250617154345.2494405-7-david@redhat.com>
 <aFuwGmM0Ebl1IRGl@localhost.localdomain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFuwGmM0Ebl1IRGl@localhost.localdomain>
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[29];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLhwqoz3wsm4df3nfubx4grhps)];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[localhost.localdomain:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Wed, Jun 25, 2025 at 10:15:22AM +0200, Oscar Salvador wrote:
> On Tue, Jun 17, 2025 at 05:43:37PM +0200, David Hildenbrand wrote:
> > Just like we do for vmf_insert_page_mkwrite() -> ... ->
> > insert_page_into_pte_locked(), support the huge zero folio.
> > 
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> insert_page_into_pte_locked() creates a special pte in case it finds the
> zero folio while insert_pmd() doesn't.
> I know that we didn't want to create special mappings for normal refcount folios
> but this seems inconsistent? I'm pretty sure there's a reason but could you
> elaborate on that?

Heh, I should have checked further. I see that happening on patch#8.


-- 
Oscar Salvador
SUSE Labs
