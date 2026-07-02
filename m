Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ACB3A4F5F
	for <nvdimm@lists.linux.dev>; Thu,  2 Jul 2026 10:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988645; cv=none; b=hmX0qg9Z7GxEHyYHwfxMVo+fSRFialJ+/SJOYhxlukJY38UWI4Yz9aF4/uALXoW6dudjUiBXZgPNHDQjlQWqN8vYAUI/l4M8qVhzwbM7C7qF1Pi8nALHzm9IifUujomILIkSmSdq2Uj7sV2D+Atx+gaLXt89Og587zUVzDs9QOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988645; c=relaxed/simple;
	bh=+KQX16ped1r/1I89bM4qTRjZccy6cVbjtQ6QZbCT7VU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6tSxo8eq0tjUCvLDfn6iqFkFkYZFvMAuxD/17LDeOncE73dcN7OKw11v+bilDij6OqkgqaUVWoipg2WYzqDBdK5xAIxk1+bU/I1BVmrTasT4u6/kSp1xskUxxoAYkCgkAfwb829x8ahJUsoq/XCbgkIIiMW564glRVxgxCmWEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kE2mS3r+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=D+60qnzp; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oONF3XqM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0UKXLPaB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kE2mS3r+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="D+60qnzp";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oONF3XqM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0UKXLPaB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1F52D74140;
	Thu,  2 Jul 2026 10:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782988638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+xpjuJ3xq8ZwM9C98H0+/B2HgccrB/M755Ut4TioEwI=;
	b=kE2mS3r+s4uFAeeC60ChSDS9r2CTWPRmIt8qJ2SdMFCaSWpD42G4wOSiES4ZIlc4diBJzm
	vs2deGla5IsTZbrZnzl064PvBzwLFLZhsuJVp4Vmh2C1zjs/3DIiNaZuGvoH/vYMtynx6R
	mtZl7IZAiX4dJf/QBtjMLi10Se/cJUA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782988638;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+xpjuJ3xq8ZwM9C98H0+/B2HgccrB/M755Ut4TioEwI=;
	b=D+60qnzp/BfT9fuN5kcly9Qm0cXvD8ADgrHEOIFBaXQPYPNp5xSr5/SG94H9lHVgKEIKBG
	SFX6rV9ZUxdbSUCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782988637; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+xpjuJ3xq8ZwM9C98H0+/B2HgccrB/M755Ut4TioEwI=;
	b=oONF3XqMMWJrykAtsu6pwaL2/kpEuxV9bCWy9bwB7V6/R2x+egjgfTgOLGAINpL/V2WiJS
	A7tamtfaDyyraOw6tMc1hzICxYOm3EE6OJzs+0kJ0cpcpfXNJcWKrc6mCg5qeCi3ByW7Lk
	blVKNlpa44SZeQTdHBLszXOFxxxAmfs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782988637;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+xpjuJ3xq8ZwM9C98H0+/B2HgccrB/M755Ut4TioEwI=;
	b=0UKXLPaBvpl4WYpis3D8Wt3jNFduWCDpcaSjWCCuLmFuWe+TD49vvHiAYk97AAjiw7TqoI
	Ny5pfTmgmhZqSpAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B9471779AA;
	Thu,  2 Jul 2026 10:37:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cEPIKVg/RmrfQQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 02 Jul 2026 10:37:12 +0000
Date: Thu, 2 Jul 2026 11:37:11 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 13/30] mm/vma: refactor vmg_adjust_set_range() for clarity
Message-ID: <akY-Z1fsp9rHSc70@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <ada7972f49ea7f1ff1df6d11e4651f270444f8fd.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada7972f49ea7f1ff1df6d11e4651f270444f8fd.1782735110.git.ljs@kernel.org>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,armlinux.org.uk,kernel.org,siemens-energy.com,hansenpartnership.com,gmx.de,redhat.com,alien8.de,linux.intel.com,mev.co.uk,visionengravers.com,pengutronix.de,gmail.com,ffwll.ch,suse.de,oss.qualcomm.com,ideasonboard.com,nvidia.com,amd.com,shazbot.org,zeniv.linux.org.uk,linux.dev,google.com,infradead.org,samsung.com,goodmis.org,huawei.com,vger.kernel.org,lists.infradead.org,lists.freedesktop.org,lists.linux.dev,kvack.org,googlegroups.com,surriel.com];
	R_RATELIMIT(0.00)[to_ip_from(RL3mhzhn45zpqpmgqn4z7synfm)];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_GT_50(0.00)[75];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,pedro-suse.lan:mid,suse.de:email]
X-Spam-Level: 
X-Spam-Score: -2.80

On Mon, Jun 29, 2026 at 01:23:24PM +0100, Lorenzo Stoakes wrote:
> Add comments with ASCII diagrams to describe what we're doing, avoid
> dubious use of PHYS_PFN(), and use vma_start_pgoff().
> 
> The most complicated scenario represented here is vmg->__adjust_next_start
> - when this is set, vmg->[start, end] actually indicate the range to be
> retained, so take special care to describe this accurately.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  mm/vma.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index 6296acecf3b7..1e99fe8aa6ef 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -704,11 +704,54 @@ static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
>  	pgoff_t pgoff;
>  
>  	if (vmg->__adjust_middle_start) {
> -		adjust = vmg->middle;
> -		pgoff = adjust->vm_pgoff + PHYS_PFN(vmg->end - adjust->vm_start);
> +		/*
> +		 * vmg->start    vmg->end
> +		 * |             |
> +		 * v    merge    v
> +		 * <------------->
> +		 *         delta
> +		 *        <------>
> +		 * |------|----------------|
> +		 * | prev |    middle      |
> +		 * |------|----------------|
> +		 *        ^
> +		 *        |
> +		 *        middle->vm_start
> +		 */
> +		struct vm_area_struct *middle = vmg->middle;

FWIW this can be simplified to
		adjust = middle;
		const unsigned long delta = vmg->end - adjust->vm_start;

But I guess you're looking for explicitness here?

> +		const unsigned long delta = vmg->end - middle->vm_start;
> +
> +		pgoff = vma_start_pgoff(middle) + (delta >> PAGE_SHIFT);
> +		adjust = middle;
>  	} else if (vmg->__adjust_next_start) {
> -		adjust = vmg->next;
> -		pgoff = adjust->vm_pgoff - PHYS_PFN(adjust->vm_start - vmg->end);
> +		/*
> +		 *                Originally:
> +		 *
> +		 *            vmg->start   vmg->end
> +		 *            |            |
> +		 *            v    merge   v
> +		 *            <------------>
> +		 *            .            .
> +		 * merge_existing_range() updates to:
> +		 *            .            .
> +		 * vmg->start vmg->end     .
> +		 * |          |            .
> +		 * v  retain  v            .
> +		 * <---------->            .
> +		 *             delta       .
> +		 *            <----->      .
> +		 * |----------------|------|
> +		 * |    middle      | next |
> +		 * |----------------|------|
> +		 *                  ^
> +		 *                  |
> +		 *                  next->vm_start
> +		 */
> +		struct vm_area_struct *next = vmg->next;
> +		const unsigned long delta = next->vm_start - vmg->end;
> +
> +		pgoff = vma_start_pgoff(next) - (delta >> PAGE_SHIFT);
> +		adjust = next;
>  	} else {
>  		return;
>  	}

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro
