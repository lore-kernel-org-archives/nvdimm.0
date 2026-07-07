Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0A93ED3CC;
	Tue,  7 Jul 2026 10:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783420553; cv=none; b=dMVN8C9mVfDmk1DpkFZbofplvGXvW3MJ33KxRSYivGWalSBGg2IxohPS4rlj5plVLkJRoOFZL8UGOA/kPaxnqgbmQXGJxcIqcLOzHvEvfhTpkduXDjwtE+QGbEiXpxOC6aDMNb04qUQpmxFraX7ApbPVrc+2oQmvY3AhG7wBSNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783420553; c=relaxed/simple;
	bh=HvoDLh1pJSoqWDRA6onKpz1ZBpgF670CyjlLdi2zj/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kupQVxKiHfSu/fV81/6x2ynU8rUCbth6y+qfC9Hep2PKiVNcIZOME3rRzzJ6Fl5cd7hW5cRLbt4hYHVUyt2ZpNcTt/z6YDHh1gDChM6wQxnc8hbuCU3cOUIDy9Yj5oA8nUyFb+YFtw/PHR0mtZKj4LYKIdT//m1OWQ2kvlO3XUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=muEHhNZS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="muEHhNZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF751F000E9;
	Tue,  7 Jul 2026 10:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783420551;
	bh=ZIdJ2kWnZSzaIc2VKvx3tV02RUSZsKP0aF813USpRQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=muEHhNZSQ0LSJO5dQUblRtk+3KNiW1Sexx9P7JyID1p9Hp3xGv0J4UbRG+fY5Nk5k
	 lfNOH48QJc7HVhAUIDSaP4FNnIxe1mCFgX523zuLO4ghOrfTq4nTYzyBZzGlQjIANh
	 G5dVcytVLi1Y4Go7lt7Hi1xf1O/iRDFx8vFh8b1fkkLSr//7hIoyAOX0XNg3mhaHuE
	 /MZdzFdyC5bAY2+EfgYmdAJYL+l14uqVN6YBlzzFherZX3IvuvVVB4464w8KwAKHFR
	 Cb6iDTk1N1p2T8kQle7lANNppyIF7SnaCJrLWMjV2fVD3A9nrBk/dbzE9PoWVE/mTu
	 kXgj2SJWBNUbA==
Date: Tue, 7 Jul 2026 11:35:27 +0100
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
Subject: Re: [PATCH 25/30] mm/vma: update vmg_adjust_set_range() to offset
 pgoff instead
Message-ID: <akzVxx6vIeiXO-cV@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <910f7b5be78232304dc7ca01cd57c6f5ca8f3d13.1782735110.git.ljs@kernel.org>
 <akZLhkjsJ_3sGdox@pedro-suse.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZLhkjsJ_3sGdox@pedro-suse.lan>

On Thu, Jul 02, 2026 at 12:29:54PM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:36PM +0100, Lorenzo Stoakes wrote:
> > We are calculating the pgoff as an offset, since we have vma_add_pgoff()
> > and vma_sub_pgoff() available, just offset this value directly and use
> > __vma_set_range() for vma->vm_[start, end] values.
> >
> > We take care to update the range before offsetting the page offset, so the
> > adjusted VMA's vm_start and vm_pgoff are mutually consistent at the point
> > the page offset helpers operate - this matters once vma_set_pgoff() comes
> > to assert invariants which relate the two.
> >
> > Doing so lays the foundation for future work which allows for use of
> > virtual page offsets for MAP_PRIVATE-file backed mappings.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  mm/vma.c | 15 ++++-----------
> >  1 file changed, 4 insertions(+), 11 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index e3355eab11f2..0579fc8c9bd5 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -714,9 +714,6 @@ void validate_mm(struct mm_struct *mm)
> >   */
> >  static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
> >  {
> > -	struct vm_area_struct *adjust;
> > -	pgoff_t pgoff;
> > -
> >  	if (vmg->__adjust_middle_start) {
> >  		/*
> >  		 * vmg->start    vmg->end
> > @@ -735,8 +732,8 @@ static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
> >  		struct vm_area_struct *middle = vmg->middle;
> >  		const unsigned long delta = vmg->end - middle->vm_start;
> >
> > -		pgoff = vma_start_pgoff(middle) + (delta >> PAGE_SHIFT);
> > -		adjust = middle;
> > +		__vma_set_range(middle, vmg->end, middle->vm_end);
> > +		vma_add_pgoff(middle, delta >> PAGE_SHIFT);
> >  	} else if (vmg->__adjust_next_start) {
> >  		/*
> >  		 *                Originally:
> > @@ -764,13 +761,9 @@ static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
> >  		struct vm_area_struct *next = vmg->next;
> >  		const unsigned long delta = next->vm_start - vmg->end;
> >
> > -		pgoff = vma_start_pgoff(next) - (delta >> PAGE_SHIFT);
> > -		adjust = next;
> > -	} else {
> > -		return;
> > +		__vma_set_range(next, vmg->end, next->vm_end);
> > +		vma_sub_pgoff(next, delta >> PAGE_SHIFT);
> >  	}
> > -
> > -	vma_set_range(adjust, vmg->end, adjust->vm_end, pgoff);
> >  }
>
> Maybe this should be squashed with That Other Patch that touches this.

Ah this separation makes more sense from the point of view of the virt pgoff
stuff in the RFC (see [0]).

And would rather keep as vaguely bitesized as possible :>)

>
> Anyway,
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

>
> --
> Pedro

Cheers, Lorenzo

[0]:https://lore.kernel.org/linux-mm/cover.1782745153.git.ljs@kernel.org/
