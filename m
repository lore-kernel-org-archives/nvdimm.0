Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECC738C2DE;
	Mon, 20 Jul 2026 07:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784532046; cv=none; b=NzLa9kO86PAE12Elqmpd2SqXz8QSQerOqRyqDhugtlLopyuiP+lbAzgg6MwwEhZzy8oJCTkhSw9kCfXieTs0d4U/Nrz5qasZKdrNu0Yr+t0W54y8TVcLfUF1VjYkU8YAElqUaBuAchDrgjNOjYEFNCaqRdQsnb77/2yfqs+M1uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784532046; c=relaxed/simple;
	bh=wS3iOjal19hc48fA51Gyg+UKNxQ+naTpbmOlu9ZaCrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HHDxSuwRopir4v3JHnTJLCxaZabmUPw6ZEu5/42/FWk7Ew97ur1fM5ioIJGEep+anuaSJcRBh/lEJ6ncgYVCVt5Aw3x3XaiZH74usYLOCJQs4CepesJWdz1QJmQ+uBn8fTgeEpasJ3Dd/0UqQkP/9/o4DGdReP7GepcOTP+/K48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4SQ5H7p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4SQ5H7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F055C1F00A3A;
	Mon, 20 Jul 2026 07:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784532040;
	bh=gANMU5sOivOjZzaedPM5r16YKmZ48cwI33ZQeohFkKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q4SQ5H7pfr3jaDU2ZnnO+1hHIoXl1iFH5WSqv7jLKEoKzb1W8Q48EBE20IuNZFTUn
	 ixKm0DVIy5OI2nLk58vf2Hjrg7we7B+X4V1GJxyPkSv0+C69K1TUoySPfe3BcFYtS/
	 t7GufXN3+op+50lWLzds22S7AYYtVpeOlcrG/0bZfPer/n9WDDe8GhqIXCV0fWPGUD
	 XmaJPMeyIJugU5z50bBvNZ+bv5B8MYe6yecmFyVa9TEs0150ohb7J9prH1nL+rHsFg
	 Tpa/uQSSoq+PE+oR7BoJwZF5ntDZOzikcQrAbuelm4gJqA+MbVuFWtO9kyaJQf1xJj
	 5Tno9QcBWPfNw==
Date: Mon, 20 Jul 2026 08:20:01 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
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
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
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
Subject: Re: [PATCH v2 08/33] mm/rmap: rename vma_interval_tree_*() to
 mapping_rmap_tree_*()
Message-ID: <al3LpROyiWEBL1wh@lucifer>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-8-2a5aa403d977@kernel.org>
 <DK1CWBDK5J60.3VPRP45IS7L7E@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DK1CWBDK5J60.3VPRP45IS7L7E@nvidia.com>

On Fri, Jul 17, 2026 at 10:54:24PM -0400, Zi Yan wrote:
> On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> > The family of vma_interval_tree_() functions manipulate the
> > address_space (which, of course, is generally referred to as 'mapping')
> > reverse mapping, but are named the 'VMA' interval tree.
> >
> > VMAs may be mapped by an anon_vma, an address_space, or both. Therefore
> > calling the mapping interval tree a 'VMA' interval tree is rather
> > confusing.
> >
> > This is also inconsistent with the anon_vma_interval_tree_*() functions
> > which explicitly reference the rmap object to which they pertain.
> >
> > Rename the vma_interval_tree_*() functions to mapping_rmap_tree_*() to
> > correct this.
> >
> > We will rename the anon rmap functions similarly in a subsequent patch.
> >
> > No functional change intended.
> >
> > Reviewed-by: Gregory Price <gourry@gourry.net>
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  arch/arm/mm/fault-armv.c          |  2 +-
> >  arch/arm/mm/flush.c               |  2 +-
> >  arch/nios2/mm/cacheflush.c        |  2 +-
> >  arch/parisc/kernel/cache.c        |  2 +-
> >  fs/dax.c                          |  2 +-
> >  fs/hugetlbfs/inode.c              |  4 ++--
> >  include/linux/mm.h                | 16 ++++++++--------
> >  kernel/events/uprobes.c           |  2 +-
> >  mm/hugetlb.c                      |  4 ++--
> >  mm/interval_tree.c                | 22 +++++++++++-----------
> >  mm/khugepaged.c                   |  4 ++--
> >  mm/memory-failure.c               |  6 +++---
> >  mm/memory.c                       |  2 +-
> >  mm/mmap.c                         |  2 +-
> >  mm/nommu.c                        |  8 ++++----
> >  mm/pagewalk.c                     |  2 +-
> >  mm/rmap.c                         |  2 +-
> >  mm/vma.c                          | 12 ++++++------
> >  tools/testing/vma/include/stubs.h |  4 ++--
> >  19 files changed, 50 insertions(+), 50 deletions(-)
> >
>
> Just curious, why not file_rmap_tree_*()?

Just to avoid any confusion around address_space objects that are ostensibly
'not files' like devices or whatnot, but moreso for consistency with the rest of
the kernel in referring to this stuff as 'mapping'.

Naming is hard IOW :)

>
> One nice part of this renaming is that the length of each function does
> not chagne. That makes the patch easy to review.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
> --
> Best Regards,
> Yan, Zi
>

Cheers, Lorenzo
