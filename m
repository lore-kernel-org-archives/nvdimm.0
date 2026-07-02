Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369C5477983
	for <nvdimm@lists.linux.dev>; Thu,  2 Jul 2026 11:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782992441; cv=none; b=pGO/Rn6o3rHo+zZzKnYgFqcIlCj8oXaOmJgB4DgOUK+qlvxhb62sJVeGTxiFh9gHKqnWbHhDzgOfRqZS2hjZtN9HkbZLVRAPt7wI7eI0jsLLfjAU+qH+30ZRWCsz5SfXUCSwGJxaj7+7qQHyLjunJG5rI4aR48blKfV+p3Vkf+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782992441; c=relaxed/simple;
	bh=/KU+qwds20JhaSAHS/0qK/0mpH1n/3CgmSllPI3f0zw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTL4fgjb6nxiYJdp21B0C2G8jkJV+OHmNn6x8xYQHtxPZ8BVy6G+nWhh+JrFR1mRDOuGEfvLR6KS1Xf9pw4rIUpGtHwTKhuzw2Y7a2e7mrUY/xJ6PT4PaITIFgwAbBDiP57DJT9x69XVGbhT0Y+NURXfkERcUNwCPvj2wH2FJr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Zh8gMbcs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vtJW1UBj; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Zh8gMbcs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vtJW1UBj; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Zh8gMbcs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vtJW1UBj";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Zh8gMbcs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vtJW1UBj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8C7767418D;
	Thu,  2 Jul 2026 11:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782992436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cYFKxI5JULp8gb+ekuRNTWlzvX21cjaKiqCcXlOBcMI=;
	b=Zh8gMbcsGVZsWYcj7s6NxFpfr5kyL+dCesoL+NYZ+EODYF9IH6Hd/X0L9JWcLlDuAVVzRD
	lkFU6fooAwjkvyipCSd6pYrI7ul5JbqcH2WSEGXi2kMhtzt1GEarB+i/bLdIQKj10vBGbz
	EhZtRvw0lzIZvhvJ2rPwW99GAu7sGKs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782992436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cYFKxI5JULp8gb+ekuRNTWlzvX21cjaKiqCcXlOBcMI=;
	b=vtJW1UBjyxnbfNoeO2SWUq2seB26JDH9poeuyJMl+C0R4u0Xqidess1m7AhGShw5crqNPY
	FyMzXeg34AXEWFBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782992436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cYFKxI5JULp8gb+ekuRNTWlzvX21cjaKiqCcXlOBcMI=;
	b=Zh8gMbcsGVZsWYcj7s6NxFpfr5kyL+dCesoL+NYZ+EODYF9IH6Hd/X0L9JWcLlDuAVVzRD
	lkFU6fooAwjkvyipCSd6pYrI7ul5JbqcH2WSEGXi2kMhtzt1GEarB+i/bLdIQKj10vBGbz
	EhZtRvw0lzIZvhvJ2rPwW99GAu7sGKs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782992436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cYFKxI5JULp8gb+ekuRNTWlzvX21cjaKiqCcXlOBcMI=;
	b=vtJW1UBjyxnbfNoeO2SWUq2seB26JDH9poeuyJMl+C0R4u0Xqidess1m7AhGShw5crqNPY
	FyMzXeg34AXEWFBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 16BA4779AA;
	Thu,  2 Jul 2026 11:40:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1gA3AjBORmrpAgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 02 Jul 2026 11:40:32 +0000
Date: Thu, 2 Jul 2026 12:40:30 +0100
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
Subject: Re: [PATCH 27/30] mm/vma: correct incorrect vma.h inclusion
Message-ID: <akZNiN5Y9fPk8bZH@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <22d0f4e3fe11f6fd1312734e242d008267ad142c.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22d0f4e3fe11f6fd1312734e242d008267ad142c.1782735110.git.ljs@kernel.org>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_CC(0.00)[linux-foundation.org,armlinux.org.uk,kernel.org,siemens-energy.com,hansenpartnership.com,gmx.de,redhat.com,alien8.de,linux.intel.com,mev.co.uk,visionengravers.com,pengutronix.de,gmail.com,ffwll.ch,suse.de,oss.qualcomm.com,ideasonboard.com,nvidia.com,amd.com,shazbot.org,zeniv.linux.org.uk,linux.dev,google.com,infradead.org,samsung.com,goodmis.org,huawei.com,vger.kernel.org,lists.infradead.org,lists.freedesktop.org,lists.linux.dev,kvack.org,googlegroups.com,surriel.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RL3mhzhn45zpqpmgqn4z7synfm)];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_GT_50(0.00)[75];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,pedro-suse.lan:mid]
X-Spam-Level: 
X-Spam-Score: -2.80

On Mon, Jun 29, 2026 at 01:23:38PM +0100, Lorenzo Stoakes wrote:
> The only files which should be including vma.h are the implementation files
> for the core VMA logic - vma.c, vma_init.c, and vma_exec.c.
> 
> This is in order to allow for userland testing of core VMA logic. In this
> cases, vma_internal.h and vma.h are included, providing both the
> dependencies upon which the core VMA logic requires and its declarations.
> 
> Userland testable VMA logic is achieved by having separate vma_internal.h
> implementations for userland and kernel.
> 
> Callers other than the core VMA implementation should include internal.h
> instead. This header does not need to include vma_internal.h as it only
> contains the vma.h declarations, for which the includes already present
> suffice.
> 
> Update code to reflect this, update comments to reflect the fact there are
> 3 VMA implementation files and document things more clearly.
> 
> While we're here, slightly improve the language of the comment describing
> vma_exec.c.

Two random thoughts:
1) perhaps vma.h -> vma_private.h
2) https://lore.kernel.org/all/CAHk-=wghMm2c+AYEcwYY7drSVXB27DYqc-ZXpFiq=XFs-w59wA@mail.gmail.com/
   mm/vma/whatever.c :) would PROBABLY solve the issue of people snooping vma.h

> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

> ---
>  mm/mmu_notifier.c | 2 +-
>  mm/nommu.c        | 1 -
>  mm/vma.c          | 4 ++++
>  mm/vma.h          | 9 ++++++++-
>  mm/vma_exec.c     | 8 ++++++--
>  mm/vma_init.c     | 4 ++++
>  mm/vma_internal.h | 4 ++--
>  7 files changed, 25 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> index 245b74f39f91..df69ba6e797f 100644
> --- a/mm/mmu_notifier.c
> +++ b/mm/mmu_notifier.c
> @@ -19,7 +19,7 @@
>  #include <linux/sched/mm.h>
>  #include <linux/slab.h>
>  
> -#include "vma.h"
> +#include "internal.h"
>  
>  /* global SRCU for all MMs */
>  DEFINE_STATIC_SRCU(srcu);
> diff --git a/mm/nommu.c b/mm/nommu.c
> index ba1c923c0942..4fef6fbbd6e9 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -41,7 +41,6 @@
>  #include <asm/tlbflush.h>
>  #include <asm/mmu_context.h>
>  #include "internal.h"
> -#include "vma.h"
>  
>  unsigned long highest_memmap_pfn;
>  int heap_stack_gap = 0;
> diff --git a/mm/vma.c b/mm/vma.c
> index d727150e377a..5c3062e0e706 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -4,6 +4,10 @@
>   * VMA-specific functions.
>   */
>  
> +/*
> + * To allow for userland testing we place internal dependencies in
> + * vma_internal.h and external VMA API declarations in vma.h.
> + */
>  #include "vma_internal.h"
>  #include "vma.h"
>  
> diff --git a/mm/vma.h b/mm/vma.h
> index 155eadda47aa..f4f885615a92 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -2,7 +2,14 @@
>  /*
>   * vma.h
>   *
> - * Core VMA manipulation API implemented in vma.c.
> + * Core VMA manipulation API implemented in vma.c, vma_init.c and vma_exec.c.
> + *
> + * Note that, in order for VMA logic to be userland testable, this header
> + * intentionally includes no dependencies.
> + *
> + * This is specifically scoped to mm-only. Users of this functionality (other
> + * than the core VMA implementation itself) should not include this header
> + * directly, but rather include internal.h.
>   */
>  #ifndef __MM_VMA_H
>  #define __MM_VMA_H
> diff --git a/mm/vma_exec.c b/mm/vma_exec.c
> index 0107a6e3918c..c0f7ba2cfb27 100644
> --- a/mm/vma_exec.c
> +++ b/mm/vma_exec.c
> @@ -1,10 +1,14 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  
>  /*
> - * Functions explicitly implemented for exec functionality which however are
> - * explicitly VMA-only logic.
> + * Functions provided for exec functionality which however are
> + * specifically VMA-only logic.
>   */
>  
> +/*
> + * To allow for userland testing we place internal dependencies in
> + * vma_internal.h and external VMA API declarations in vma.h.
> + */
>  #include "vma_internal.h"
>  #include "vma.h"
>  
> diff --git a/mm/vma_init.c b/mm/vma_init.c
> index a459669a1654..715feee283f0 100644
> --- a/mm/vma_init.c
> +++ b/mm/vma_init.c
> @@ -5,6 +5,10 @@
>   * between CONFIG_MMU and non-CONFIG_MMU kernel configurations.
>   */
>  
> +/*
> + * To allow for userland testing we place internal dependencies in
> + * vma_internal.h and external VMA API declarations in vma.h.
> + */
>  #include "vma_internal.h"
>  #include "vma.h"
>  
> diff --git a/mm/vma_internal.h b/mm/vma_internal.h
> index 2da6d224c1a8..4d300e7bbaf4 100644
> --- a/mm/vma_internal.h
> +++ b/mm/vma_internal.h
> @@ -2,8 +2,8 @@
>  /*
>   * vma_internal.h
>   *
> - * Headers required by vma.c, which can be substituted accordingly when testing
> - * VMA functionality.
> + * Headers required by vma.c, vma_init.c and vma_exec.c, which can be
> + * substituted accordingly when testing VMA functionality.
>   */
>  
>  #ifndef __MM_VMA_INTERNAL_H
> -- 
> 2.54.0
> 

-- 
Pedro
