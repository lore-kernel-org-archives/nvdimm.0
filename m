Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD972E11A6
	for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 14:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749823322; cv=none; b=iDhARN51eADakUtuIxlkDxKB6wOre+YvSs4mLM5EDDlKR0Tq5XF7A9nZ5v2/FHYT8Vb13BUA0+1et0u0Lcs12j/vkZx0Fzr5BccNIIA9xlh3zEktpdlYrN5XlTWnl5DKYD+G7YMyYXL/9sjPKu6vKLkNS1BYD4yHL5v5KAXhDHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749823322; c=relaxed/simple;
	bh=IOQbPRKow8jBAKNt5sq70UbtAwDqIxbw0GdmhwIR0Ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iH6nd4hy5eNGPcGI9meuXQq5oOcybfel/jpOqD7aU1WQ0deQxoHk1EPWoX4O6/SAsa1X2iE5+92EIunIzOPWUnrq4OlpITL0VQEmfAyCvQ5BMMhXgE6f70tX4UgeHYkiioLiPSkoEb8tMEBASJRLqzS88uxTEdCyeJsiEle+UtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a+gtUUKX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=p/i6C4yv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a+gtUUKX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=p/i6C4yv; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a+gtUUKX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="p/i6C4yv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a+gtUUKX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="p/i6C4yv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AD5011F397;
	Fri, 13 Jun 2025 14:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749823318; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sUQdDRyXbbonvF49JKMmGXX6X7F0bhUgdCeb2Z1yoa8=;
	b=a+gtUUKX1GxiEQEETg09fq+vFbA2xh0JXaMO21oAQd4BMYCHM4tTrW8SwXKGDeCc2WaK8r
	Lz4lRJA705z2cSt/3PJKYG26yi7gekO7Q/aB1pCc1P6hFU+aQN8yf4zaDStAZOF1GdT78i
	JAnNF8p3ygUEkNOrOIhcJVe8KBwsBvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749823318;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sUQdDRyXbbonvF49JKMmGXX6X7F0bhUgdCeb2Z1yoa8=;
	b=p/i6C4yvNf3Er50JSOwIpxt2kEKqZd1b3g55zMH6Kl+VbWagR80cUwZLIN+iv6cajIGLbd
	x6aolSjbSvHLCVAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749823318; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sUQdDRyXbbonvF49JKMmGXX6X7F0bhUgdCeb2Z1yoa8=;
	b=a+gtUUKX1GxiEQEETg09fq+vFbA2xh0JXaMO21oAQd4BMYCHM4tTrW8SwXKGDeCc2WaK8r
	Lz4lRJA705z2cSt/3PJKYG26yi7gekO7Q/aB1pCc1P6hFU+aQN8yf4zaDStAZOF1GdT78i
	JAnNF8p3ygUEkNOrOIhcJVe8KBwsBvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749823318;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sUQdDRyXbbonvF49JKMmGXX6X7F0bhUgdCeb2Z1yoa8=;
	b=p/i6C4yvNf3Er50JSOwIpxt2kEKqZd1b3g55zMH6Kl+VbWagR80cUwZLIN+iv6cajIGLbd
	x6aolSjbSvHLCVAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A9FDE137FE;
	Fri, 13 Jun 2025 14:01:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W9rjJlUvTGinDgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Fri, 13 Jun 2025 14:01:57 +0000
Date: Fri, 13 Jun 2025 16:01:47 +0200
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
Subject: Re: [PATCH v3 3/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pud()
Message-ID: <aEwvS8AbW7OHLfmk@localhost.localdomain>
References: <20250613092702.1943533-1-david@redhat.com>
 <20250613092702.1943533-4-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613092702.1943533-4-david@redhat.com>
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,nvidia.com:email]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.30

On Fri, Jun 13, 2025 at 11:27:02AM +0200, David Hildenbrand wrote:
> Marking PUDs that map a "normal" refcounted folios as special is
> against our rules documented for vm_normal_page(). normal (refcounted)
> folios shall never have the page table mapping marked as special.
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
> Fix it just like we fixed vmf_insert_folio_pmd().
> 
> Add folio_mk_pud() to mimic what we do with folio_mk_pmd().
> 
> Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>



-- 
Oscar Salvador
SUSE Labs
