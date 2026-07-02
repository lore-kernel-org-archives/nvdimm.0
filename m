Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8156E3EDAD7
	for <nvdimm@lists.linux.dev>; Thu,  2 Jul 2026 11:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782991220; cv=none; b=V5moxKpr98tmyB7fd9Tx7XHyp0sN729/q1kyWLhIkYnIauhdSXPfm97Yna7+tFsZ1M4vBmQxeFgYzR0yPKIfhW+i15tVn1CWSsuq19VaOHv8H+C0crgt6qkCpIFvD/jG8BB/IVPRkkfAHjWO/My8YZr9c7fGajNn6LqBEKlKnJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782991220; c=relaxed/simple;
	bh=X239wNR/oEz1o+9Hxr196nhAWJXbeoJAICDwBKUZxi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gY9YzuLs/qtw8RPS1UuJDvDZSrCfvJgR7GZUUDKU9Ri9/v0vwJdX3ghJreZFLzcYRyP1t5zJRN9vQK0j24FZlUdEMZgRQSmQO2azbJzDUUFlFhDt+UQJjMxGQ7MKCT7Y/7bZCVC6vPSOWmt9BuX9iBLFSwke34ulujJXrs3N6s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PgCpqqxi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oeEsfdun; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PgCpqqxi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oeEsfdun; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PgCpqqxi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oeEsfdun";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PgCpqqxi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oeEsfdun"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4BB0E74173;
	Thu,  2 Jul 2026 11:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782991216; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j9HqakDIjcCcTQyUF2MV7bxyTIX1upg8T2CXHTGbmPY=;
	b=PgCpqqxie7t8+CkwpPP13NW6wQohMzurOqQ3M60mxkSvPUID4ZQOKndTpBXqeUuVhdKIfx
	t+2FJW3O/MNyOgFxUfD/N1cfpHLCK8FHDiqwUFTQFndqACbeCmnNWvqmGlEefRvEf4d7hB
	IQhWnkSLQ2dpEmnyOFJPaliYHOfjrfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782991216;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j9HqakDIjcCcTQyUF2MV7bxyTIX1upg8T2CXHTGbmPY=;
	b=oeEsfdunpBw1BldK/9+YFlfUYsk4g2GKuSeX7pnNOrhZYXAOuDPvAQY6PG7s0cv9YpWemp
	mWdG22AvAmx0j3Cw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PgCpqqxi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oeEsfdun
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782991216; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j9HqakDIjcCcTQyUF2MV7bxyTIX1upg8T2CXHTGbmPY=;
	b=PgCpqqxie7t8+CkwpPP13NW6wQohMzurOqQ3M60mxkSvPUID4ZQOKndTpBXqeUuVhdKIfx
	t+2FJW3O/MNyOgFxUfD/N1cfpHLCK8FHDiqwUFTQFndqACbeCmnNWvqmGlEefRvEf4d7hB
	IQhWnkSLQ2dpEmnyOFJPaliYHOfjrfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782991216;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j9HqakDIjcCcTQyUF2MV7bxyTIX1upg8T2CXHTGbmPY=;
	b=oeEsfdunpBw1BldK/9+YFlfUYsk4g2GKuSeX7pnNOrhZYXAOuDPvAQY6PG7s0cv9YpWemp
	mWdG22AvAmx0j3Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C6F00779AA;
	Thu,  2 Jul 2026 11:20:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RDeaLGtJRmoSbQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 02 Jul 2026 11:20:11 +0000
Date: Thu, 2 Jul 2026 12:20:10 +0100
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
Subject: Re: [PATCH 21/30] mm/vma: add and use vma_[add/sub]_pgoff()
Message-ID: <akZI0n1U32Ptd0ye@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <794044881e454fd8ac13e59d5ff5fc86fca08b03.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <794044881e454fd8ac13e59d5ff5fc86fca08b03.1782735110.git.ljs@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4BB0E74173
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,armlinux.org.uk,kernel.org,siemens-energy.com,hansenpartnership.com,gmx.de,redhat.com,alien8.de,linux.intel.com,mev.co.uk,visionengravers.com,pengutronix.de,gmail.com,ffwll.ch,suse.de,oss.qualcomm.com,ideasonboard.com,nvidia.com,amd.com,shazbot.org,zeniv.linux.org.uk,linux.dev,google.com,infradead.org,samsung.com,goodmis.org,huawei.com,vger.kernel.org,lists.infradead.org,lists.freedesktop.org,lists.linux.dev,kvack.org,googlegroups.com,surriel.com];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLziudqfrzo6b7hzgpxksh1d9i)];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_GT_50(0.00)[75];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,pedro-suse.lan:mid,suse.de:email,suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Mon, Jun 29, 2026 at 01:23:32PM +0100, Lorenzo Stoakes wrote:
> Add helpers for adding or subtracting to a VMA's page offset, exposed
> internally for VMA users within mm in mm/vma.h.
> 
> This is to lay the foundations for tracking anonymous page offset for
> MAP_PRIVATE file-backed mappings, where adding and subtracting from this
> value must be reflected in both the file and anonymous offsets.
> 
> These are used on VMA split and downward stack expansion.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  mm/nommu.c                      |  6 ++++--
>  mm/vma.c                        |  6 +++---
>  mm/vma.h                        | 12 ++++++++++++
>  tools/testing/vma/include/dup.h | 13 ++++++++++++-
>  4 files changed, 31 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 7333d855e974..c7fafcd87c14 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -41,6 +41,7 @@
>  #include <asm/tlbflush.h>
>  #include <asm/mmu_context.h>
>  #include "internal.h"
> +#include "vma.h"
>  
>  unsigned long highest_memmap_pfn;
>  int heap_stack_gap = 0;
> @@ -1338,7 +1339,8 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  		region->vm_top = region->vm_end = new->vm_end = addr;
>  	} else {
>  		region->vm_start = new->vm_start = addr;
> -		region->vm_pgoff = new->vm_pgoff += npages;
> +		vma_add_pgoff(new, npages);
> +		region->vm_pgoff = vma_start_pgoff(new);
>  	}
>  
>  	vma_iter_config(vmi, new->vm_start, new->vm_end);
> @@ -1355,7 +1357,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	delete_nommu_region(vma->vm_region);
>  	if (new_below) {
>  		vma->vm_region->vm_start = vma->vm_start = addr;
> -		vma->vm_pgoff += npages;
> +		vma_add_pgoff(vma, npages);
>  		vma->vm_region->vm_pgoff = vma_start_pgoff(vma);
>  	} else {
>  		vma->vm_region->vm_end = vma->vm_end = addr;
> diff --git a/mm/vma.c b/mm/vma.c
> index 185d07397ca6..cb7222e20c93 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -517,7 +517,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  		new->vm_end = addr;
>  	} else {
>  		new->vm_start = addr;
> -		new->vm_pgoff += linear_page_delta(vma, addr);
> +		vma_add_pgoff(new, linear_page_delta(vma, addr));
>  	}
>  
>  	err = -ENOMEM;
> @@ -556,7 +556,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  
>  	if (new_below) {
>  		vma->vm_start = addr;
> -		vma->vm_pgoff += (addr - new->vm_start) >> PAGE_SHIFT;
> +		vma_add_pgoff(vma, (addr - new->vm_start) >> PAGE_SHIFT);
>  	} else {
>  		vma->vm_end = addr;
>  	}
> @@ -3305,7 +3305,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
>  				vm_stat_account(mm, vma->vm_flags, grow);
>  				anon_vma_interval_tree_pre_update_vma(vma);
>  				vma->vm_start = address;
> -				vma->vm_pgoff -= grow;
> +				vma_sub_pgoff(vma, grow);
>  				/* Overwrite old entry in mtree. */
>  				vma_iter_store_overwrite(&vmi, vma);
>  				anon_vma_interval_tree_post_update_vma(vma);
> diff --git a/mm/vma.h b/mm/vma.h
> index 2342516ce00e..47fe35e5307e 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -247,6 +247,18 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
>  	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
>  }
>  
> +static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
> +{
> +	vma_assert_can_modify(vma);
> +	vma->vm_pgoff += delta;
> +}
> +
> +static inline void vma_sub_pgoff(struct vm_area_struct *vma, pgoff_t delta)
> +{
> +	vma_assert_can_modify(vma);
> +	vma->vm_pgoff -= delta;
> +}
> +
>  #define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
>  	struct vma_merge_struct name = {				\
>  		.mm = mm_,						\
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> index 7ed165c8d9bc..41fea90a344d 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1163,6 +1163,11 @@ static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
>  	return mas_find(&vmi->mas, ULONG_MAX);
>  }
>  
> +static inline bool vma_is_attached(struct vm_area_struct *vma)
> +{
> +	return refcount_read(&vma->vm_refcnt);
> +}
> +
>  /*
>   * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
>   * assertions should be made either under mmap_write_lock or when the object
> @@ -1170,7 +1175,13 @@ static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
>   */
>  static inline void vma_assert_attached(struct vm_area_struct *vma)
>  {
> -	WARN_ON_ONCE(!refcount_read(&vma->vm_refcnt));
> +	WARN_ON_ONCE(!vma_is_attached(vma));
> +}
> +
> +static inline void vma_assert_can_modify(struct vm_area_struct *vma)
> +{
> +	if (vma_is_attached(vma))
> +		vma_assert_write_locked(vma);
>  }

These hunks in dup.h look lost. Should perhaps be on the previous patch
(adding the helpers).

Anyway, Obviously Correct(tm).

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro
