Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FF33BB126;
	Thu, 16 Jul 2026 09:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784194603; cv=none; b=N9mgmQsmcOfgazajJEbCLS9q0y392y0XMBLyoA3DX08UyDHKy7t2jVKPFFf+xD5MiGI7e6ri/MTaFlOgsdjg6hf4lXYThour60tmumiYnLfbqDhVG8SE9Ybf9gr5eKE8RW6CbTxR3SaCZ7WDWnv8bt1oFzZd8meJQDoT0PNGQT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784194603; c=relaxed/simple;
	bh=hJH4yG48JfZTWrhLzphPH7J/2K7VhJiq+izQbmOi3No=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QbJtPz1z9Gf52XVJ+Q/if/gdTgX9uWZ2GXmkYuQt8Yb/9VSfCyQMR/GsjTlP/jKWY6aLu9DkQWOkq+53yBo5Bmkr+HYX09KYZv/mlcXoxPuZzeFElpzGiZ0j0HxofIzQtzcatyuS8Oh7NTvtPRiav8EmG/sjM0/2e2ywwGAwarw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YHRhRgI1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YHRhRgI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D029A1F000E9;
	Thu, 16 Jul 2026 09:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784194601;
	bh=Mw498kcdRvtwf0TpnGBwleBL9K3C9jrPcH99BicHGcY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YHRhRgI1niM3PlrZwisO9rOxfS9iIj2SYZEGwL3nW9xTChS885ATXnOpZrMbCmfcO
	 TEfa1QQhY3PrSN+0+QhLp18PfrTV/Vbj6oj1ihy3kDX5+yLPpiLN7IqJIXodmXMTxA
	 oeuc8fvAK3hIiP354563i84BomUHhL9TK1MpwY9jIW5Q9akTwY3BjKHgxm/xB0scRP
	 CjozPQeYUlzQgbZcJcn3/ZlAoQ4/7QzR/d6WwcwX3rQBBAiyttlcUrcNx6eCqL3EsE
	 VoVo3toLwNuiCOlGj3wlj1VmkF8ZUmOJMRu5lq+kk0xKz6iw5plXK5qO3T06uw8h73
	 wwA2M2VwCazzg==
Date: Thu, 16 Jul 2026 10:36:05 +0100
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
Subject: Re: [PATCH v2 25/33] mm/vma: make vma_set_range() static, drop
 insert_vm_struct() decl
Message-ID: <alilxy8lRdNIbtS-@lucifer>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-25-2a5aa403d977@kernel.org>
 <b470eb19-d59c-4dd6-bf57-648b51281691@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b470eb19-d59c-4dd6-bf57-648b51281691@kernel.org>

On Wed, Jul 15, 2026 at 07:45:59PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/10/26 22:17, Lorenzo Stoakes wrote:
> > With __install_special_mapping() moved to vma.c, vma_set_range() can be
> > made into a static function there and is now completely isolated from the
> > rest of mm.
>
> Pedantic nit: it was already "static", but in a .h file
> Yeah it was also "inline" but that's not the important part of this change.
>
> So I'd say it was rather moved to vma.c, but you can ignore this nit if you
> want.

That is pretty pedantic ;) I mean to say bare 'static' here obvs. I can fix if
any respin but I think ok as-is for now.

>
> > While we're here, we can also remove the insert_vm_struct() declaration
> > from mm.h - the function is implemented in vma.c and already declared in
> > vma.h, and has no users outside of mm.
> >
> > Also update the VMA userland tests to reflect this change.
> >
> > No functional change intended.
> >
> > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > Reviewed-by: Gregory Price <gourry@gourry.net>
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks! :)

>
> > ---
> >  include/linux/mm.h         | 1 -
> >  mm/internal.h              | 9 ---------
> >  mm/vma.c                   | 8 ++++++++
> >  tools/testing/vma/shared.c | 9 ---------
> >  tools/testing/vma/shared.h | 5 -----
> >  5 files changed, 8 insertions(+), 24 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 3d69b597b9b1..762313b47301 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4130,7 +4130,6 @@ void anon_rmap_tree_verify(struct anon_vma_chain *avc);
> >
> >  /* mmap.c */
> >  extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
> > -extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
> >  extern void exit_mmap(struct mm_struct *);
> >  bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
> >  				 unsigned long addr, bool write);
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 01a762bcc2b2..2c650d280e90 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -1540,15 +1540,6 @@ extern bool mirrored_kernelcore;
> >  bool memblock_has_mirror(void);
> >  void memblock_free_all(void);
> >
> > -static __always_inline void vma_set_range(struct vm_area_struct *vma,
> > -					  unsigned long start, unsigned long end,
> > -					  pgoff_t pgoff)
> > -{
> > -	vma->vm_start = start;
> > -	vma->vm_end = end;
> > -	vma->vm_pgoff = pgoff;
> > -}
> > -
> >  static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
> >  {
> >  	/*
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 5308aa5a8c91..cc0e449ad0be 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -70,6 +70,14 @@ struct mmap_state {
> >  		.state = VMA_MERGE_START,				\
> >  	}
> >
> > +static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
> > +			  unsigned long end, pgoff_t pgoff)
> > +{
> > +	vma->vm_start = start;
> > +	vma->vm_end = end;
> > +	vma->vm_pgoff = pgoff;
> > +}
> > +
> >  /* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
> >  static bool vma_is_fork_child(struct vm_area_struct *vma)
> >  {
> > diff --git a/tools/testing/vma/shared.c b/tools/testing/vma/shared.c
> > index 2565a5aecb80..bea9ea6db02a 100644
> > --- a/tools/testing/vma/shared.c
> > +++ b/tools/testing/vma/shared.c
> > @@ -120,12 +120,3 @@ unsigned long rlimit(unsigned int limit)
> >  {
> >  	return (unsigned long)-1;
> >  }
> > -
> > -void vma_set_range(struct vm_area_struct *vma,
> > -		   unsigned long start, unsigned long end,
> > -		   pgoff_t pgoff)
> > -{
> > -	vma->vm_start = start;
> > -	vma->vm_end = end;
> > -	vma->vm_pgoff = pgoff;
> > -}
> > diff --git a/tools/testing/vma/shared.h b/tools/testing/vma/shared.h
> > index 8b9e3b11c3cb..ca4f1238f1c7 100644
> > --- a/tools/testing/vma/shared.h
> > +++ b/tools/testing/vma/shared.h
> > @@ -125,8 +125,3 @@ void __vma_set_dummy_anon_vma(struct vm_area_struct *vma,
> >  /* Provide a simple dummy VMA/anon_vma dummy setup for testing. */
> >  void vma_set_dummy_anon_vma(struct vm_area_struct *vma,
> >  			    struct anon_vma_chain *avc);
> > -
> > -/* Helper function to specify a VMA's range. */
> > -void vma_set_range(struct vm_area_struct *vma,
> > -		   unsigned long start, unsigned long end,
> > -		   pgoff_t pgoff);
> >
>

Cheers, Lorenzo
