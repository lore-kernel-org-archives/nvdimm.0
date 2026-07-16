Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E963A7F6D;
	Thu, 16 Jul 2026 09:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784195042; cv=none; b=QKj2Jv/xL7lXEHVQwRfTk89QX94G3QHf+8L9XctR2zSB1mcWZfH5ntIK11Qz8ddFMNqk93ZFUoAaTDHbljMfSK6r2sgeuH004N0j/liFzn4/Hy/dj6Fv7IQJsuCxocoqJtabO1IUbtE62MsbRGTWqYTplJrfYAcat2MjCoYQRUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784195042; c=relaxed/simple;
	bh=phxx4hR9qJ6FTvYLWGmvTIyNN+0zUu9BLWMdw0cqKKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DgyzHjk9+VvPXC86mz9BgWqVWOqdu8xAVMegCdetroOZp4usf87k1b74J37szzZ5NZhCYs22nNFw0UmY9lUZE13hcpJaLCKPdhABvkwylYaKkXVYohhU8YnQHWu+nrtTRiXg/AicrQu+LxPJin7I3yUPlPFnzHtxvA/RoQBraTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iu8EKOiI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iu8EKOiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6ED91F000E9;
	Thu, 16 Jul 2026 09:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784195039;
	bh=CPJ+pW2aokXKg9H0QF6n2buWLq97N6oV6j+X1iL7PAw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Iu8EKOiIAi2erBIl2I5xXgq6Bz7w63MaAR9P3VHudd2ydfM1/8G3fepp8TXP4vd3c
	 Porhtp9oIByTUxLuWNkd3ZScSWmhoE9YJimmVgeN8hfJDBNXQOrtO5/14qOT8MJ/EU
	 nFpSGANK1jTulsUypVcADIvlmNHaIyx0/OIJQd/Azc/BO06j4QVlVe7RWoBG9Eu6sp
	 Ad02+fKMp+Zf3EqHXMLebI9zP50U6lz2rlkfHwCExqzmxhxr5+zA/N221RP8CAmaGb
	 zVYp3oZbXyNMj1fS5EAvDVfb5QYx9+nXyAoQHPBO7II6mCFrcqHW0nuohBzIQCrr+J
	 0X6WG3jWkxqvA==
Message-ID: <9469d484-f736-4a2d-b1e9-a7ba1c381d18@kernel.org>
Date: Thu, 16 Jul 2026 11:43:35 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/33] mm/vma: use vma_start_pgoff(),
 linear_page_index() in mm code
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Russell King <linux@armlinux.org.uk>,
 Dinh Nguyen <dinguyen@kernel.org>,
 Simon Schuster <schuster.simon@siemens-energy.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>,
 Peter Xu <peterx@redhat.com>, Kees Cook <kees@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Andrey Konovalov
 <andreyknvl@gmail.com>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
 <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Lucas Stach <l.stach@pengutronix.de>,
 Christian Gmeiner <christian.gmeiner@gmail.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov
 <lumag@kernel.org>, Abhinav Kumar <abhinav.kumar@linux.dev>,
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>,
 Marijn Suijten <marijn.suijten@somainline.org>,
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
 <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 damon@lists.linux.dev, iommu@lists.linux.dev, kasan-dev@googlegroups.com,
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-18-2a5aa403d977@kernel.org>
 <e98110da-f26a-46ca-8360-fc84fc159bd8@kernel.org> <aligtF3WwRam1rMd@lucifer>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <aligtF3WwRam1rMd@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/16/26 11:27, Lorenzo Stoakes (ARM) wrote:
> On Wed, Jul 15, 2026 at 05:23:09PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 7/10/26 22:16, Lorenzo Stoakes wrote:
>> > There are many instances in which linear_page_index() (as well as
>> > linear_page_delta()) is open-coded, which is confusing and inconsistent.
>> >
>> > Additionally, vma->vm_pgoff doesn't necessarily make it clear that this is
>> > the page offset of the start of the VMA range.
>> >
>> > Doing so also aids greppability.
>> >
>> > So use vma_start_pgoff() in favour of directly accessing vma->vm_pgoff, and
>> > linear_page_index() where we can.
>> >
>> > This also lays the ground for future changes which will add an anonymous
>> > page offset in order to be able to index MAP_PRIVATE-file backed anon
>> > folios in terms of their virtual page offset.
>> >
>> > No functional change intended.
>> >
>> > Reviewed-by: Gregory Price <gourry@gourry.net>
>> > Reviewed-by: SJ Park <sj@kernel.org>
>> > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>>
>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Thanks!
> 
>>
>> Nit:
>>
>> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
>> > index 2058db9c01d5..d10b8042adb5 100644
>> > --- a/mm/damon/vaddr.c
>> > +++ b/mm/damon/vaddr.c
>> > @@ -10,6 +10,7 @@
>> >  #include <linux/mman.h>
>> >  #include <linux/mmu_notifier.h>
>> >  #include <linux/page_idle.h>
>> > +#include <linux/pagemap.h>
>> >  #include <linux/pagewalk.h>
>> >  #include <linux/sched/mm.h>
>> >
>> > @@ -623,8 +624,8 @@ static void damos_va_migrate_dests_add(struct folio *folio,
>> >  	}
>> >
>> >  	order = folio_order(folio);
>> > -	ilx = vma->vm_pgoff >> order;
>> > -	ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
>> > +	ilx = vma_start_pgoff(vma) >> order;
>> > +	ilx += linear_page_delta(vma, addr) >> order;
>>
>> Could these be combined to linear_page_index(vma, addr) >> order?
> 
> So this is:
> 
> 	(x >> order) + (y >> order)
> 
> And linear_page_index(vma, addr) >> order is:
> 
> 	(x + y) >> order
> 
> Consider:
> 
> 	order = 1, x = 0b11, y = 0b01
> 
> 	(x    >> order) + (y    >> order) =
> 	(0b11 >> 1    ) + (0b01 >> 1    ) =
> 	0b1             + 0               =
> 	1
> 
> 	(x    + y   ) >> order =
> 	(0b11 + 0b01) >> 1     =
> 	(0b100      ) >> 1     =
> 	2
> 
> They are not equivalent - the carry bit changes the result.

Right, thanks. Didn't consider it would be actually working with unaligned
addresses but seems like it can.

>>
>> >
>> >  	for (i = 0; i < dests->nr_dests; i++)
>> >  		weight_total += dests->weight_arr[i];
>>
>> > diff --git a/mm/filemap.c b/mm/filemap.c
>> > index b39111abdc4b..1dbb4c6f824e 100644
>> > --- a/mm/filemap.c
>> > +++ b/mm/filemap.c
>> > @@ -3411,8 +3411,8 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>> >  		 * of memory.
>> >  		 */
>> >  		struct vm_area_struct *vma = vmf->vma;
>> > -		unsigned long start = vma->vm_pgoff;
>> > -		unsigned long end = start + vma_pages(vma);
>> > +		const unsigned long start = vma_start_pgoff(vma);
>> > +		const unsigned long end = vma_end_pgoff(vma);
>> >  		unsigned long ra_end;
>> >
>> >  		ra->order = exec_folio_order();
>> > @@ -3930,7 +3930,8 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>> >  		goto out;
>> >  	}
>> >
>> > -	addr = vma->vm_start + ((start_pgoff - vma->vm_pgoff) << PAGE_SHIFT);
>> > +	addr = vma->vm_start +
>> > +		((start_pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
>>
>> This could be linear_page_index(vma, start_pgoff) <<

Thanks for pretending you didn't notice this one, which was even more
obviously incorrect :)

>> >  	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, addr, &vmf->ptl);
>> >  	if (!vmf->pte) {
>> >  		folio_unlock(folio);
>>
>> > --- a/mm/mempolicy.c
>> > +++ b/mm/mempolicy.c
>> > @@ -2049,8 +2049,8 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
>> >  		pol = get_task_policy(current);
>> >  	if (pol->mode == MPOL_INTERLEAVE ||
>> >  	    pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
>> > -		*ilx += vma->vm_pgoff >> order;
>> > -		*ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
>> > +		*ilx += vma_start_pgoff(vma) >> order;
>> > +		*ilx += linear_page_delta(vma, addr) >> order;
>>
>> Also?
> 
> See above.
> 
>>
>> >  	}
>> >  	return pol;
>> >  }
>>
>> > --- a/mm/nommu.c
>> > +++ b/mm/nommu.c
>> > @@ -975,7 +975,7 @@ static int do_mmap_private(struct vm_area_struct *vma,
>> >  		/* read the contents of a file into the copy */
>> >  		loff_t fpos;
>> >
>> > -		fpos = vma->vm_pgoff;
>> > +		fpos = vma_start_pgoff(vma);
>> >  		fpos <<= PAGE_SHIFT;
>> >
>> >  		ret = kernel_read(vma->vm_file, base, len, &fpos);
>> > @@ -1378,7 +1378,8 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>> >  	delete_nommu_region(vma->vm_region);
>> >  	if (new_below) {
>> >  		vma->vm_region->vm_start = vma->vm_start = addr;
>> > -		vma->vm_region->vm_pgoff = vma->vm_pgoff += npages;
>>
>> yuck, good to remove that ugly construct
>> it's not the only occurence in this function
>> oh well
> 
> Yup at least improved it here :)

And a later patch removes the other occurence.

>>
>> > +		vma->vm_pgoff += npages;
>> > +		vma->vm_region->vm_pgoff = vma_start_pgoff(vma);
>> >  	} else {
>> >  		vma->vm_region->vm_end = vma->vm_end = addr;
>> >  		vma->vm_region->vm_top = addr;
> 
> Cheers, Lorenzo

