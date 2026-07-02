Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FF047277E
	for <nvdimm@lists.linux.dev>; Thu,  2 Jul 2026 11:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782992532; cv=none; b=cY9fkBtrZGc+vN/+cHWujqAzeBHB8wYiOL2uNPDq10gV1xbETXN53wGJ/mMVd3ecWJ5QGW4iZ8gB2/RTOGrkGP/PurxXoL9ZokMke8kFVwcE+s38GnmDpguiV68/xSYgwrQSwL2jhZ3TYa+vK8TvyDXowpfwlfi3TxqFoEw3iBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782992532; c=relaxed/simple;
	bh=NbMKaIcLdBgQBZ0t7j6od9BeFSoSoiBXALSr+ADeDeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aCGyPJ7fGCeXxOO35VGP7zGTUwzTNBy+vHyeVHY8Mq6teYNUyx1vwU3waJOc443WX1xMLDwlu3vB3zN51EVUi3DpFgoPd8uoZ6e3YOvN+1pChyIQBQvbY2BsoDLuVKHmMvkPruDCWNTItNuDbl7Rr0pDo4M+aautweK5se9tQ80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MgYtIILH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kLc4/mLR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MgYtIILH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kLc4/mLR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MgYtIILH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kLc4/mLR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MgYtIILH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kLc4/mLR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6F50775C1D;
	Thu,  2 Jul 2026 11:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782992517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vu8L7q6bu0OFvYkJgSdMtxCTTGakF05snV71ypMy454=;
	b=MgYtIILHL5qXtqhKLZ8XZcyinJTvjGOcOgl9W8ycfQIyeho64ZA8/WWTmJrzFxoY1N5LHc
	qu6lRyl/960OCJyZS+uoggilNOJcaArJzm/Owxp0oQSOCDZmX50LbhZ/nQuh5cmPX40bes
	FeJM1XkHumjTX63W8d021JwBwstFBLE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782992517;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vu8L7q6bu0OFvYkJgSdMtxCTTGakF05snV71ypMy454=;
	b=kLc4/mLRWYJrH8utNWwx3dXSehHGYZAVGkuX35UyvhSpGuZ4RYe5xa5lbObDbmB/adQDPi
	gILLGIEL5YqNrqCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MgYtIILH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="kLc4/mLR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782992517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vu8L7q6bu0OFvYkJgSdMtxCTTGakF05snV71ypMy454=;
	b=MgYtIILHL5qXtqhKLZ8XZcyinJTvjGOcOgl9W8ycfQIyeho64ZA8/WWTmJrzFxoY1N5LHc
	qu6lRyl/960OCJyZS+uoggilNOJcaArJzm/Owxp0oQSOCDZmX50LbhZ/nQuh5cmPX40bes
	FeJM1XkHumjTX63W8d021JwBwstFBLE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782992517;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vu8L7q6bu0OFvYkJgSdMtxCTTGakF05snV71ypMy454=;
	b=kLc4/mLRWYJrH8utNWwx3dXSehHGYZAVGkuX35UyvhSpGuZ4RYe5xa5lbObDbmB/adQDPi
	gILLGIEL5YqNrqCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E0722779AA;
	Thu,  2 Jul 2026 11:41:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DgpIM4BORmpgBAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 02 Jul 2026 11:41:52 +0000
Date: Thu, 2 Jul 2026 12:41:51 +0100
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
Subject: Re: [PATCH 28/30] mm/vma: use guard clauses in
 can_vma_merge_[before, after]()
Message-ID: <akZOPG6fxr98Ycl_@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <213918ef85ed427d29d0635db6b07b15280d3bb0.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <213918ef85ed427d29d0635db6b07b15280d3bb0.1782735110.git.ljs@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6F50775C1D
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,armlinux.org.uk,kernel.org,siemens-energy.com,hansenpartnership.com,gmx.de,redhat.com,alien8.de,linux.intel.com,mev.co.uk,visionengravers.com,pengutronix.de,gmail.com,ffwll.ch,suse.de,oss.qualcomm.com,ideasonboard.com,nvidia.com,amd.com,shazbot.org,zeniv.linux.org.uk,linux.dev,google.com,infradead.org,samsung.com,goodmis.org,huawei.com,vger.kernel.org,lists.infradead.org,lists.freedesktop.org,lists.linux.dev,kvack.org,googlegroups.com,surriel.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,pedro-suse.lan:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Mon, Jun 29, 2026 at 01:23:39PM +0100, Lorenzo Stoakes wrote:
> Rather than combining a bunch of conditionals in a single expression,
> simplify by inverting the mergeability requirements into guard clauses.
> 
> that is - instead of checking what must be true for the conditions to be
> met, instead check the inverse of the requirements and return false if any
> are true, defaulting to true.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  mm/vma.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index 5c3062e0e706..7201199fc668 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -215,13 +215,13 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
>   */
>  static bool can_vma_merge_before(struct vma_merge_struct *vmg)
>  {
> -	if (is_mergeable_vma(vmg, /* merge_next = */ true) &&
> -	    is_mergeable_anon_vma(vmg, /* merge_next = */ true)) {
> -		if (vmg_end_pgoff(vmg) == vma_start_pgoff(vmg->next))
> -			return true;
> -	}
> -
> -	return false;
> +	if (!is_mergeable_vma(vmg, /* merge_next = */ true))
> +		return false;
> +	if (!is_mergeable_anon_vma(vmg, /* merge_next = */ true))
> +		return false;
> +	if (vmg_end_pgoff(vmg) != vma_start_pgoff(vmg->next))
> +		return false;
> +	return true;
>  }
>  
>  /*
> @@ -235,12 +235,13 @@ static bool can_vma_merge_before(struct vma_merge_struct *vmg)
>   */
>  static bool can_vma_merge_after(struct vma_merge_struct *vmg)
>  {
> -	if (is_mergeable_vma(vmg, /* merge_next = */ false) &&
> -	    is_mergeable_anon_vma(vmg, /* merge_next = */ false)) {
> -		if (vma_end_pgoff(vmg->prev) == vmg_start_pgoff(vmg))
> -			return true;
> -	}
> -	return false;
> +	if (!is_mergeable_vma(vmg, /* merge_next = */ false))
> +		return false;
> +	if (!is_mergeable_anon_vma(vmg, /* merge_next = */ false))
> +		return false;
> +	if (vma_end_pgoff(vmg->prev) != vmg_start_pgoff(vmg))
> +		return false;
> +	return true;
>  }
>  
>  static void __vma_link_file(struct vm_area_struct *vma,

Looks nicer, thanks.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro
