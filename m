Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA0B40BCAF;
	Wed,  1 Jul 2026 10:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782901127; cv=none; b=bBNuCa/0Wag/34QGTDWy0Exg4426V+Damu/hNuXstD+/EjSFctIkZW/QDuAvBIBBd5yDBW5dYO4lnCKmVf20g3lhQDGkXvgeBAM5a96pu7ZABwDjVcCjvKX9myOMY/ZdmG4/DCkeS4jTfVjWMD6bTOJHC5SBAunCQ5VmVVTllnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782901127; c=relaxed/simple;
	bh=JM9/CaIlMkjQdFefjm0dVPPjkG/0+O7+5RX4p75h0x0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RNMKH0j47gH/EetkyUUbJsN+RKQrrEzjKrZwOGJ2wM4aPZA1enVTpQEPBt4PHWkR1wASPxctip1C2ngOwntRquxiGKkgQLiL2dyS3Et/DT7jxq7vCdEQEM1pPuKMOkq2KgrZWeNF63LE0GKkP4sa+DXfSiBmlSdonwg1kHrPbYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AXQrg9P0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AXQrg9P0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783341F000E9;
	Wed,  1 Jul 2026 10:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782901125;
	bh=JM9/CaIlMkjQdFefjm0dVPPjkG/0+O7+5RX4p75h0x0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AXQrg9P0AZleFkeFS51+PjUo+B8xcdDVE6tYWDlNGuGdgBpLyKHJD6elc2v/kcqUE
	 8Pcm+GcqRx1k66nL9Uz+zEQ1FGgN7fgq6+QHDdXkD+Pdz0aJff6p2k0V+rzm+2Z3nu
	 iSsIViklzABlCCMKzkBXtJrZyVFo2V4IsTINTz9RKasIkvyuDEwuSlPRQaN1JPh1Ph
	 4s6fRT7pOmRvUznm5PfN3Qg8RbN5uvU10x5Z/rpOw3czvOGlanwtN8QcTVROHG707e
	 UmVvX7bqHJU1MBVNsmN1D97wgCCjA1bFiUR7kEt/Ogvvig/eVyWKvzrNW1JuZ23oNU
	 HGzRMycOX4fdw==
Date: Wed, 1 Jul 2026 11:18:24 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
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
Subject: Re: [PATCH 09/30] mm/rmap: parameterise anon_vma_interval_tree_*()
 by anon_vma
Message-ID: <akTpXVhj3unHRH8o@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <1c1df7b905ef340cbf2effef769a4e770a8e0eb1.1782735110.git.ljs@kernel.org>
 <akPvI4r1rnxxSbzW@pedro-suse.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPvI4r1rnxxSbzW@pedro-suse.lan>

On Tue, Jun 30, 2026 at 05:32:03PM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:20PM +0100, Lorenzo Stoakes wrote:
> > Similar to what we did with mapping_interval_tree*(), let's declare
> > anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.
> >
> > In each case the rb tree referenced is &anon_vma->rb_root, so just pass
> > anon_vma and the functions can figure this out themselves.
> >
> > Additionally, rename 'node' to 'avc', 'index' to 'pgoff_start', and 'last'
> > to 'pgoff_last' to make clear what is being passed.
> >
> > Finally express page offsets in terms of pgoff_t to be consistent.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Yay!
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks :)

>
> I have a vaguely similar comment as for the file part (names could be
> simpler, doesn't really matter whether it's an interval tree or possibly
> even a tree), but I care less strongly about anon rmap :)

And yeah ack, let me agonise over that a bit :P

>
> --
> Pedro

Cheers, Lorenzo
