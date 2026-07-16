Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F2E3CF207;
	Thu, 16 Jul 2026 09:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784195234; cv=none; b=RKds2BO7H2t1EqBKw4PkMTbzgLeE1JjDVHpDAdpJUR2gBhxufHvjr9jvzEAxfYuscPaLOybIhO4dNaZgfxuKWKq8q8ZBHYzAgo1Fi4qiADeUIuZBryHSdK7gk5qifokCUurh8661tziQr44iVtsviVX2sGuR92cC8srVk/UxYEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784195234; c=relaxed/simple;
	bh=Z1xSPfs4YAARG9OG3L5XNAUhtFj5pRy8a4Eqkv3RkjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tot+P8pPphsRY1ZXQPcewj1K4dIFglr3eebxeqXONq062GdO7eaWbLDwiM7FzkqQNJ4v0sPMtr0vAJTOgoQFCD+IyQJ/HmSw4pbbAHj8THiizci9Lrjyv1h0eiQbG/GCrVKWPZBb6u+mRJWbR+Xw2lfvuPauLHLSd04WGEMfss4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VVZute3A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VVZute3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F911F000E9;
	Thu, 16 Jul 2026 09:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784195228;
	bh=pvyju2uSObish5k8L0bIZVWBDfraOY408PSxNPnf71s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VVZute3AX7giYVngkfw7rRVDOUFCkUeehA7gHuqxbodMqI3KudJmc65mfSpIfBov6
	 kXSAk16pNUacGy5D2Eqik2xc88uYve6l8ka8j2PMpSUaZgUEhZKIY7z041kujjV3gv
	 rGAzJUxhhyV9xtmlIz4NzxfzOFiC4fRz/PvrPQenkFYNHGCFErGddvvT9O1t6EWywO
	 9UZ0RSpECerLbC/CPCidoVDZp71WikjEdlVt1g+7lzgsBQgSkLAvh8ELx5JuHO9dAi
	 1y1rYfaoMGsHEnEOpdyzFhFPgW7TnwxSAIncPhTH0YlYChmvl/dlc/qoIWECec5GG7
	 d4Zcal/KBoKSg==
Date: Thu, 16 Jul 2026 10:46:34 +0100
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
	linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, 
	iommu@lists.linux.dev, kasan-dev@googlegroups.com, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 18/33] mm/vma: use vma_start_pgoff(),
 linear_page_index() in mm code
Message-ID: <alioLIH0DqZz04-_@lucifer>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-18-2a5aa403d977@kernel.org>
 <e98110da-f26a-46ca-8360-fc84fc159bd8@kernel.org>
 <aligtF3WwRam1rMd@lucifer>
 <9469d484-f736-4a2d-b1e9-a7ba1c381d18@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9469d484-f736-4a2d-b1e9-a7ba1c381d18@kernel.org>

On Thu, Jul 16, 2026 at 11:43:35AM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/16/26 11:27, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Jul 15, 2026 at 05:23:09PM +0200, Vlastimil Babka (SUSE) wrote:
> >> On 7/10/26 22:16, Lorenzo Stoakes wrote:
> >> > There are many instances in which linear_page_index() (as well as
> >> > linear_page_delta()) is open-coded, which is confusing and inconsistent.
> >> >
> >> > Additionally, vma->vm_pgoff doesn't necessarily make it clear that this is
> >> > the page offset of the start of the VMA range.
> >> >
> >> > Doing so also aids greppability.
> >> >
> >> > So use vma_start_pgoff() in favour of directly accessing vma->vm_pgoff, and
> >> > linear_page_index() where we can.
> >> >
> >> > This also lays the ground for future changes which will add an anonymous
> >> > page offset in order to be able to index MAP_PRIVATE-file backed anon
> >> > folios in terms of their virtual page offset.
> >> >
> >> > No functional change intended.
> >> >
> >> > Reviewed-by: Gregory Price <gourry@gourry.net>
> >> > Reviewed-by: SJ Park <sj@kernel.org>
> >> > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> >> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> >>
> >> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >
> > Thanks!
> >
> >>
> >> Nit:
> >>
> >> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> >> > index 2058db9c01d5..d10b8042adb5 100644
> >> > --- a/mm/damon/vaddr.c
> >> > +++ b/mm/damon/vaddr.c
> >> > @@ -10,6 +10,7 @@
> >> >  #include <linux/mman.h>
> >> >  #include <linux/mmu_notifier.h>
> >> >  #include <linux/page_idle.h>
> >> > +#include <linux/pagemap.h>
> >> >  #include <linux/pagewalk.h>
> >> >  #include <linux/sched/mm.h>
> >> >
> >> > @@ -623,8 +624,8 @@ static void damos_va_migrate_dests_add(struct folio *folio,
> >> >  	}
> >> >
> >> >  	order = folio_order(folio);
> >> > -	ilx = vma->vm_pgoff >> order;
> >> > -	ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
> >> > +	ilx = vma_start_pgoff(vma) >> order;
> >> > +	ilx += linear_page_delta(vma, addr) >> order;
> >>
> >> Could these be combined to linear_page_index(vma, addr) >> order?
> >
> > So this is:
> >
> > 	(x >> order) + (y >> order)
> >
> > And linear_page_index(vma, addr) >> order is:
> >
> > 	(x + y) >> order
> >
> > Consider:
> >
> > 	order = 1, x = 0b11, y = 0b01
> >
> > 	(x    >> order) + (y    >> order) =
> > 	(0b11 >> 1    ) + (0b01 >> 1    ) =
> > 	0b1             + 0               =
> > 	1
> >
> > 	(x    + y   ) >> order =
> > 	(0b11 + 0b01) >> 1     =
> > 	(0b100      ) >> 1     =
> > 	2
> >
> > They are not equivalent - the carry bit changes the result.
>
> Right, thanks. Didn't consider it would be actually working with unaligned
> addresses but seems like it can.

Yeah, I initially did it the way you suggested then ran it by AI review and it
moaned at me so ;)

>
> >>
> >> >
> >> >  	for (i = 0; i < dests->nr_dests; i++)
> >> >  		weight_total += dests->weight_arr[i];
> >>
> >> > diff --git a/mm/filemap.c b/mm/filemap.c
> >> > index b39111abdc4b..1dbb4c6f824e 100644
> >> > --- a/mm/filemap.c
> >> > +++ b/mm/filemap.c
> >> > @@ -3411,8 +3411,8 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
> >> >  		 * of memory.
> >> >  		 */
> >> >  		struct vm_area_struct *vma = vmf->vma;
> >> > -		unsigned long start = vma->vm_pgoff;
> >> > -		unsigned long end = start + vma_pages(vma);
> >> > +		const unsigned long start = vma_start_pgoff(vma);
> >> > +		const unsigned long end = vma_end_pgoff(vma);
> >> >  		unsigned long ra_end;
> >> >
> >> >  		ra->order = exec_folio_order();
> >> > @@ -3930,7 +3930,8 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
> >> >  		goto out;
> >> >  	}
> >> >
> >> > -	addr = vma->vm_start + ((start_pgoff - vma->vm_pgoff) << PAGE_SHIFT);
> >> > +	addr = vma->vm_start +
> >> > +		((start_pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
> >>
> >> This could be linear_page_index(vma, start_pgoff) <<
>
> Thanks for pretending you didn't notice this one, which was even more
> obviously incorrect :)

Again I screwed this up when I first did it so was far more terribly wrong
myself :P All hail AI review I suppose?

>
> >> >  	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, addr, &vmf->ptl);
> >> >  	if (!vmf->pte) {
> >> >  		folio_unlock(folio);
> >>
> >> > --- a/mm/mempolicy.c
> >> > +++ b/mm/mempolicy.c
> >> > @@ -2049,8 +2049,8 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
> >> >  		pol = get_task_policy(current);
> >> >  	if (pol->mode == MPOL_INTERLEAVE ||
> >> >  	    pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
> >> > -		*ilx += vma->vm_pgoff >> order;
> >> > -		*ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
> >> > +		*ilx += vma_start_pgoff(vma) >> order;
> >> > +		*ilx += linear_page_delta(vma, addr) >> order;
> >>
> >> Also?
> >
> > See above.
> >
> >>
> >> >  	}
> >> >  	return pol;
> >> >  }
> >>
> >> > --- a/mm/nommu.c
> >> > +++ b/mm/nommu.c
> >> > @@ -975,7 +975,7 @@ static int do_mmap_private(struct vm_area_struct *vma,
> >> >  		/* read the contents of a file into the copy */
> >> >  		loff_t fpos;
> >> >
> >> > -		fpos = vma->vm_pgoff;
> >> > +		fpos = vma_start_pgoff(vma);
> >> >  		fpos <<= PAGE_SHIFT;
> >> >
> >> >  		ret = kernel_read(vma->vm_file, base, len, &fpos);
> >> > @@ -1378,7 +1378,8 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >> >  	delete_nommu_region(vma->vm_region);
> >> >  	if (new_below) {
> >> >  		vma->vm_region->vm_start = vma->vm_start = addr;
> >> > -		vma->vm_region->vm_pgoff = vma->vm_pgoff += npages;
> >>
> >> yuck, good to remove that ugly construct
> >> it's not the only occurence in this function
> >> oh well
> >
> > Yup at least improved it here :)
>
> And a later patch removes the other occurence.

A game of 2 halves!

>
> >>
> >> > +		vma->vm_pgoff += npages;
> >> > +		vma->vm_region->vm_pgoff = vma_start_pgoff(vma);
> >> >  	} else {
> >> >  		vma->vm_region->vm_end = vma->vm_end = addr;
> >> >  		vma->vm_region->vm_top = addr;
> >
> > Cheers, Lorenzo
>
