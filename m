Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A88400988;
	Wed, 15 Jul 2026 18:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784138830; cv=none; b=PQG9e110S12X4yDp8uaVoqIjdSXbhK9Op+xoBQ0yIy60xYYs0RMWL88BVbVimR6RbzoYeLYLX8rqnaf0IGWPEZng3nYAR5pumzGBJkpC9XSXUd28CcD7W1bhwF6G35cRQ9jp9EvY68qxBUKJ03nsN+Y0QtbWsom+KyA339rUOfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784138830; c=relaxed/simple;
	bh=676EW54ZjlPi1U7mS9yBnZCxtv8/ZyBZqJfh6gJIWHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VHR6BRrb0N9A/x+n5NR8gt4DfK6OvMfqC5DLBse+SBwZzXdpTxL8cgdsKBKxIUeU4Rm9wB+sQJZf3gEbHr83nRUWE9rwAEg1EbugNm3zncI5FP1Q/gOViEBcY4GmEUwWgJX1RIGWMqB8dV4GuB9ozJzaPkvVsj4BPZAcWSQxkXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ep4rwIOo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ep4rwIOo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qngtohDCDGKOAZ2UVf9Yg6jMkSiGUEfIvWoLem96Mp4=; b=ep4rwIOo/ExvDfJmbtyA8cKzMw
	0K/f7VDtaU/DLWnU8uwYuMWewE/dC3S1ac1go5eVbtwF80qPWn5KvA3OvHqfcuRIXpW4OY5odfN5U
	weSzRKDDHCZ2JEhPfQKlDUbJQdhIg5wO+rloHvOBdYg7m1s/mQdTBwtZ0KOy4bDybM+1nE6KlB7Ux
	57bMIakkBMvb4B9//cOXUVMiSdXw67CFBTK9w74YZdPjPkP37w3eKwbO9XcT9HNqvpacpkQaqu1I2
	3hGgEFOXqCguSeUIllYGOWMxmlxPIA4nF3mzmcU+fuz7v4+2Qrd3UJCpm6P357Gsn91/sNfi6dOHa
	ZDhmCkMg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk3zd-0000000FcKu-2dgd;
	Wed, 15 Jul 2026 18:06:01 +0000
Date: Wed, 15 Jul 2026 14:05:42 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
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
Subject: Re: [PATCH v2 01/33] mm: move vma_start_pgoff() into mm.h and clean
 up
Message-ID: <uqfnbb7knn5gs2symluouczdbxehpwuubek3ypziavv776jncb@l7r4zlatslxd>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-1-2a5aa403d977@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-1-2a5aa403d977@kernel.org>

On 26/07/10 09:16PM, Lorenzo Stoakes wrote:
> vma_last_pgoff() already lives there, so it's a bit odd to keep
> vma_start_pgoff() in mm/interval_tree.c. Move them together.
> 
> These each return unsigned long, which pgoff_t is typedef'd to. Make this
> consistent and have these functions return pgoff_t instead.
> 
> Additionally, express vma_last_pgoff() in terms of vma_start_pgoff(), since
> we wrap the vma->vm_pgoff access, we may as well use it here.
> 
> Also while we're here, const-ify the VMA and cleanup a bit.
> 
> Also update the VMA userland tests to reflect the change.

This patch could have been 01/35?  Disappointing, but I will try to get
over it.

> 
> No functional change intended.
> 
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  include/linux/mm.h              | 9 +++++++--
>  mm/interval_tree.c              | 5 -----
>  tools/testing/vma/include/dup.h | 5 +++++
>  3 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 25e669632d2c..09b06d8fea74 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4307,9 +4307,14 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
>  
> -static inline unsigned long vma_last_pgoff(struct vm_area_struct *vma)
> +static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
>  {
> -	return vma->vm_pgoff + vma_pages(vma) - 1;
> +	return vma->vm_pgoff;
> +}
> +
> +static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
> +{
> +	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
>  }
>  
>  static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
> diff --git a/mm/interval_tree.c b/mm/interval_tree.c
> index 32bcfbfcf15f..344d1f5946c7 100644
> --- a/mm/interval_tree.c
> +++ b/mm/interval_tree.c
> @@ -10,11 +10,6 @@
>  #include <linux/rmap.h>
>  #include <linux/interval_tree_generic.h>
>  
> -static inline unsigned long vma_start_pgoff(struct vm_area_struct *v)
> -{
> -	return v->vm_pgoff;
> -}
> -
>  INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
>  		     unsigned long, shared.rb_subtree_last,
>  		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> index bf26b3f48d3a..668650067c7c 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1301,6 +1301,11 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
>  
> +static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
> +{
> +	return vma->vm_pgoff;
> +}
> +
>  static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
>  {
>  	return file->f_op->mmap_prepare(desc);
> 
> -- 
> 2.55.0
> 
