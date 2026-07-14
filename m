Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3EA3644CF;
	Tue, 14 Jul 2026 10:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784024268; cv=none; b=KoARJtzUTnXChmf2Ufmh6BWVO6FMgt/WqrkkainQ9/6YkXo72jB14UASOGPznSGKiNKf08VcP09hEZCQXvPVuTF5gZQKaIYMWMn0Fd2fmP63+SPTkE+54Rg5bmIWrpKrjKMLQTR5FfOtdrPgVhhJkLvWSOpUIxWQMiM/y2seVFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784024268; c=relaxed/simple;
	bh=4DH5a6ve/auP/7V1bjyB0V4QG2dck0UzPWpYqC6/K2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gLcLeuk+BDUCgI/Utnn9318eE4ks4juatKBtAsY3GwsxdDJJIB9hXvBcw29WAMPdf0cMeZ/V9I45Joos8rwZ9/pQiT2fRKXgox9poFtuzrL+1YB0g85Pt/QWBmivN9agjPbS8XPa+vaIaW6HuPUPUfJgVdQaKE/EsD0EEfaOEmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fy6x3ScG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fy6x3ScG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4FE1F00A3A;
	Tue, 14 Jul 2026 10:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784024267;
	bh=m1KwIxFOjH59vMqkPqvNJy2V0MLfN207LfncRH5TxDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Fy6x3ScGp4SvjcLCb2EYasEF7Bg+N3JfXA1S2rYhDdGa8fr4+6eT9Z5sUIb80sT2r
	 12V6KN+91XeSPeyZyRfBCNnMtsE0Z3zX1AfM0d9+BaPvnE/m8+pkUwQTaWwez7DEAX
	 40QuoDzKqfzY1GCwuoG58CjBJE29XwBLRxM4TLNdmwQj8Blhck0AkxR92okiojzvMx
	 WvMiVcF3zrA3KFpoksv9rfWx4gssKNluZWhtd5duC3QeTgeKUloBSHGktJzF0RJITM
	 VrXH2ihLGQi0Xivwew6+5RuBX85r1ZYghiUkt5mTAu6e5JRNfb657XTWVfzpRGcHfX
	 762G6nWtq/nvw==
Date: Tue, 14 Jul 2026 11:17:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, Russell King <linux@armlinux.org.uk>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	SJ Park <sj@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>, 
	Kees Cook <kees@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	Christian Gmeiner <christian.gmeiner@gmail.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Rob Clark <robin.clark@oss.qualcomm.com>, 
	Dmitry Baryshkov <lumag@kernel.org>, Abhinav Kumar <abhinav.kumar@linux.dev>, 
	Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
	Marijn Suijten <marijn.suijten@somainline.org>, Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
	Thierry Reding <thierry.reding@kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>, 
	Jonathan Hunter <jonathanh@nvidia.com>, Christian Koenig <christian.koenig@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, 
	Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, iommu@lists.linux.dev, 
	kasan-dev@googlegroups.com, linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org, 
	linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 13/33] mm/vma: introduce and use vmg_pages(),
 vmg_[start, end]_pgoff()
Message-ID: <alYMZkJKJABhPsa6@lucifer>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-13-2a5aa403d977@kernel.org>
 <508301c5-5460-40e8-bc34-6410be5be40a@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508301c5-5460-40e8-bc34-6410be5be40a@kernel.org>

On Mon, Jul 13, 2026 at 08:12:24PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/10/26 22:16, Lorenzo Stoakes wrote:
> > In the VMA logic we often need to determine the number of pages in the
> > specified merge range, as well as the start and end page offsets of that
> > range.
> >
> > Introduce and use helpers for these purposes.
> >
> > No functional change intended.
> >
> > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > Reviewed-by: Gregory Price <gourry@gourry.net>
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Uh, the PHYS_PFN() usage here was quite an abuse. Good riddance.

Yeah and mine :)) but absolutely agree it was wrong and glad to fix my own
mistake in using that ;)

> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

>
> > ---
> >  mm/vma.c | 11 ++++-------
> >  mm/vma.h | 17 +++++++++++++++++
> >  2 files changed, 21 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 35ba3475128f..995de8198fbb 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -197,11 +197,9 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
> >   */
> >  static bool can_vma_merge_before(struct vma_merge_struct *vmg)
> >  {
> > -	pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);
> > -
> >  	if (is_mergeable_vma(vmg, /* merge_next = */ true) &&
> >  	    is_mergeable_anon_vma(vmg, /* merge_next = */ true)) {
> > -		if (vmg->next->vm_pgoff == vmg->pgoff + pglen)
> > +		if (vmg_end_pgoff(vmg) == vma_start_pgoff(vmg->next))
> >  			return true;
> >  	}
> >
> > @@ -221,7 +219,7 @@ static bool can_vma_merge_after(struct vma_merge_struct *vmg)
> >  {
> >  	if (is_mergeable_vma(vmg, /* merge_next = */ false) &&
> >  	    is_mergeable_anon_vma(vmg, /* merge_next = */ false)) {
> > -		if (vmg->prev->vm_pgoff + vma_pages(vmg->prev) == vmg->pgoff)
> > +		if (vma_end_pgoff(vmg->prev) == vmg_start_pgoff(vmg))
> >  			return true;
> >  	}
> >  	return false;
> > @@ -759,7 +757,7 @@ static int commit_merge(struct vma_merge_struct *vmg)
> >  	 */
> >  	vma_adjust_trans_huge(vma, vmg->start, vmg->end,
> >  			      vmg->__adjust_middle_start ? vmg->middle : NULL);
> > -	vma_set_range(vma, vmg->start, vmg->end, vmg->pgoff);
> > +	vma_set_range(vma, vmg->start, vmg->end, vmg_start_pgoff(vmg));
> >  	vmg_adjust_set_range(vmg);
> >  	vma_iter_store_overwrite(vmg->vmi, vmg->target);
> >
> > @@ -962,8 +960,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
> >  		 *    middle     next
> >  		 * shrink/delete extend
> >  		 */
> > -
> > -		pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);
> > +		const pgoff_t pglen = vmg_pages(vmg);
> >
> >  		VM_WARN_ON_VMG(!merge_right, vmg);
> >  		/* If we are offset into a VMA, then prev must be middle. */
> > diff --git a/mm/vma.h b/mm/vma.h
> > index 8e4b61a7304c..527716c8739d 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -230,6 +230,23 @@ static inline bool vmg_nomem(struct vma_merge_struct *vmg)
> >  	return vmg->state == VMA_MERGE_ERROR_NOMEM;
> >  }
> >
> > +static inline pgoff_t vmg_start_pgoff(const struct vma_merge_struct *vmg)
> > +{
> > +	return vmg->pgoff;
> > +}
> > +
> > +static inline pgoff_t vmg_pages(const struct vma_merge_struct *vmg)
> > +{
> > +	const unsigned long size = vmg->end - vmg->start;
> > +
> > +	return size >> PAGE_SHIFT;
> > +}
> > +
> > +static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
> > +{
> > +	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
> > +}
> > +
> >  /* Assumes addr >= vma->vm_start. */
> >  static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
> >  				       unsigned long addr)
> >
>

Cheers, Lorenzo
