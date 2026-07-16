Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3681E3A2572;
	Thu, 16 Jul 2026 09:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784194467; cv=none; b=DKaTClEH08MhH4MUFHfPIjwEVa532AD5fnl080KVOBK9oixVjOIfHs8VGHi6ssal9h7PXgSpDKVE5sd4wkd5oIu5sKQbJi7tRQOduUMNJZLchVaba4YlBMimpkn7dbeAcoMoXvHsWyrdEOnf7xj0+KE2GApcWXPvssY1a9FH63I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784194467; c=relaxed/simple;
	bh=cOJQeoL/IfToCf5nKi/1WKxwcd+AJrDARDQzSahV+6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DD2B/Jujy7NoyievNXMn+AqSuBHbbYIfLFMXzqAQHex65/gyabeV9EDShRRzN1yzb2M+W6NEZmnXd6z7/Cd+BtXmhOl8+HkIsfGJMNiPlPUoqs1ebmM/5HwSJ7LgEZmukf4Kks/8mb86q/WWP4zetbR+I5IdyLpISE6us9MSoj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HaVMsfnC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HaVMsfnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5AD1F00A3A;
	Thu, 16 Jul 2026 09:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784194465;
	bh=lNYl98mYz28OLVONtUv3HHBbo78s/d/FScrptCSkJqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HaVMsfnCFQZsO8TosGBgjIQcv/23XysFwaqQLFbTwajYekUfxV325I+lW1pF5U/pO
	 0Dfjj/iv0XjXf9UhDL6hNgQ+avTyoYTMX3syk2Dy0ERhQGYHVF3FA3nDn9sUdIbhfJ
	 Mk0OIn7dJxoIKmUhZI12SmOVvm4Y/OF+VsOgVdX/wQ+8GX19Ib/HsiFgtZtxHVv6Pz
	 DNrods1GvRI+Pf6ukfp85qGF3+zDzp0DDcL378JHf0SbOQEW9OANF0im2X+3GMcn6k
	 /10UKMRNrM/8y2nVFByXLA3MOpPLS6A8iGNTe/uuwzVNln9TFQODIte1ksvKdZE7LI
	 BvxtDp2Jg7H3w==
Date: Thu, 16 Jul 2026 10:33:51 +0100
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
Subject: Re: [PATCH v2 23/33] mm/vma: add and use vma_[add/sub]_pgoff()
Message-ID: <alikZjoSBwdxslz7@lucifer>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-23-2a5aa403d977@kernel.org>
 <fb8d7fbb-1b4f-4fec-a087-8b1b9f55a167@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb8d7fbb-1b4f-4fec-a087-8b1b9f55a167@kernel.org>

On Wed, Jul 15, 2026 at 07:38:38PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/10/26 22:17, Lorenzo Stoakes wrote:
> > Add helpers for adding or subtracting to a VMA's page offset, exposed
> > internally for VMA users within mm in mm/vma.h.
> >
> > This is to lay the foundations for tracking anonymous page offset for
> > MAP_PRIVATE file-backed mappings, where adding and subtracting from this
> > value must be reflected in both the file and anonymous offsets.
> >
> > These are used on VMA split and downward stack expansion.
> >
> > No functional change intended.
> >
> > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

>
> Nits:
>
> > ---
> >  mm/nommu.c |  6 ++++--
> >  mm/vma.c   |  6 +++---
> >  mm/vma.h   | 12 ++++++++++++
> >  3 files changed, 19 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/nommu.c b/mm/nommu.c
> > index c0a0869cd0d6..2a0136f6081d 100644
> > --- a/mm/nommu.c
> > +++ b/mm/nommu.c
> > @@ -41,6 +41,7 @@
> >  #include <asm/tlbflush.h>
> >  #include <asm/mmu_context.h>
> >  #include "internal.h"
> > +#include "vma.h"
> >
> >  unsigned long highest_memmap_pfn;
> >  int heap_stack_gap = 0;
> > @@ -1361,7 +1362,8 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  		region->vm_top = region->vm_end = new->vm_end = addr;
> >  	} else {
> >  		region->vm_start = new->vm_start = addr;
> > -		region->vm_pgoff = new->vm_pgoff += npages;
>
> Ah that takes care of the other case of ugliness I noticed earlier, good.

Churn for good ;)

>
> > +		vma_add_pgoff(new, npages);
> > +		region->vm_pgoff = vma_start_pgoff(new);
> >  	}
> >
> >  	vma_iter_config(vmi, new->vm_start, new->vm_end);
> > @@ -1378,7 +1380,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  	delete_nommu_region(vma->vm_region);
> >  	if (new_below) {
> >  		vma->vm_region->vm_start = vma->vm_start = addr;
> > -		vma->vm_pgoff += npages;
> > +		vma_add_pgoff(vma, npages);
> >  		vma->vm_region->vm_pgoff = vma_start_pgoff(vma);
> >  	} else {
> >  		vma->vm_region->vm_end = vma->vm_end = addr;
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 7aa0149f076c..bdd99ba56b4d 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -517,7 +517,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  		new->vm_end = addr;
> >  	} else {
> >  		new->vm_start = addr;
> > -		new->vm_pgoff += linear_page_delta(vma, addr);
> > +		vma_add_pgoff(new, linear_page_delta(vma, addr));
> >  	}
> >
> >  	err = -ENOMEM;
> > @@ -556,7 +556,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >
> >  	if (new_below) {
> >  		vma->vm_start = addr;
> > -		vma->vm_pgoff += (addr - new->vm_start) >> PAGE_SHIFT;
> > +		vma_add_pgoff(vma, (addr - new->vm_start) >> PAGE_SHIFT);
>
> Hm isn't this also a case for using linear_page_delta(addr, new)?
> (I guess in patch 21/33)
> Would be like the hunk above.

Ah, yeah :) I can always rearrange which commit does what on any respin.

For now, Andrew - could you make a little edit here?

-		vma_add_pgoff(vma, (addr - new->vm_start) >> PAGE_SHIFT);
+		vma_add_pgoff(vma, linear_page_delta(new, addr));

Thanks!

>
> >  	} else {
> >  		vma->vm_end = addr;
> >  	}
> > @@ -3305,7 +3305,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
> >  				vm_stat_account(mm, vma->vm_flags, grow);
> >  				anon_rmap_tree_pre_update_vma(vma);
> >  				vma->vm_start = address;
> > -				vma->vm_pgoff -= grow;
> > +				vma_sub_pgoff(vma, grow);
> >  				/* Overwrite old entry in mtree. */
> >  				vma_iter_store_overwrite(&vmi, vma);
> >  				anon_rmap_tree_post_update_vma(vma);
> > diff --git a/mm/vma.h b/mm/vma.h
> > index 2342516ce00e..47fe35e5307e 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -247,6 +247,18 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
> >  	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
> >  }
> >
> > +static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
> > +{
> > +	vma_assert_can_modify(vma);
> > +	vma->vm_pgoff += delta;
> > +}
> > +
> > +static inline void vma_sub_pgoff(struct vm_area_struct *vma, pgoff_t delta)
> > +{
> > +	vma_assert_can_modify(vma);
> > +	vma->vm_pgoff -= delta;
> > +}
> > +
> >  #define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
> >  	struct vma_merge_struct name = {				\
> >  		.mm = mm_,						\
> >
>

Cheers, Lorenzo
