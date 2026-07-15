Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5935512D1F1;
	Wed, 15 Jul 2026 19:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784145119; cv=none; b=gliM8ZRWgsDRTyeU4eOWG35l6qmG64tP01eLvdMpdSjr1c4z+5/LtNfw/G7JyFM+AgvuH0cg+4EbAYlBsyZlgztJlFcq1QnOjxS/1fdeHr811Bg4pQB1SXaQ2TxnEgPcm0F6zTfqTy0AFCAW3aXOoM9eWHZ0wet3J/vR+I6Jl78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784145119; c=relaxed/simple;
	bh=3uP8bgU1we/Dtxq3O0dFdAVY4cBPySZLkiqm4nKQMWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j3S/vuozI5wi3UaLPPcGT6kxPi1/EYGPaOjSL5Lwf+0LDRoN/e6VbE90pCvXmhYFQR0w4vixUMQv3qQDDivlPprQT0Z51i/aTwm0ScCeFmdR3U4cA7oiDt6DkB2qA2XjVKAk/+SU0FiuD3LFV0Dr68N9Fn2pkkzuXBR+Ef5Ri1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lJgKKfhl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lJgKKfhl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qECPUV5KWvny4esgaF2Vf7PlyZR+bR1BGzMVUFeolqU=; b=lJgKKfhlIrhdAC1jyT5Hf3uPxE
	l7vnGovceMuPLVWPqgV9wNKl/gQuYIaCna2P59iOxwIjz8TgnSZxKIXp5GeAqkWZQaTeT3+cubzjK
	HGiNQpMygZIeOjVTO50mffhkjlNpKQVqpAAM1eEVW8Hs3fCuJZ+uAhYmyDBNCwh9jTJS9/Q5Y3LVu
	ywLG36QvrGrHdJQUhM57vSlVQ7DI/PmUKWzLTbToYJXiR4beiet5xPyeJKLkIRtK7Wmpn2r5twtYX
	SVWE+upv4jajftjr+NcrbxoQcLUUOncC03VumZY0PwcxCLxWxWB2Ce3O/uWL9GgzwaAmWuf5JkTOn
	i46gZwWQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk5dP-0000000Fp73-3ueX;
	Wed, 15 Jul 2026 19:51:12 +0000
Date: Wed, 15 Jul 2026 15:51:01 -0400
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
Subject: Re: [PATCH v2 02/33] mm: add kdoc comments for vma_start/last_pgoff()
Message-ID: <jwtocg3yekest4xrda4fhzck5tcrcib2mmzjztvi3jk6i4oin7@xcvem5gdkwa7>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-2-2a5aa403d977@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-2-2a5aa403d977@kernel.org>

On 26/07/10 09:16PM, Lorenzo Stoakes wrote:
> Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
> detail.
> 
> This is in order that we can differentiate this between functions that will
> be added in a subsequent patch which provide a different page offset.
> 
> We go to lengths to describe the edge cases that can be run into here.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  include/linux/mm.h | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 09b06d8fea74..abac72785277 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4307,11 +4307,41 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
>  
> +/**
> + * vma_start_pgoff() - Get the page offset of the start of @vma
> + * @vma: The VMA whose page offset is required.
> + *
> + * If the VMA is file-backed, this is the page offset into the file.
> + *
> + * If @vma is anonymous, this is the virtual page offset of the start of the
> + * VMA - if unfaulted, then vma->vm_start >> PAGE_SHIFT, if faulted then the
> + * virtual page offset at the time of first fault.
> + *
> + * If @vma is a MAP_PRIVATE file-backed mapping, then this returns the
> + * page offset within the file.
> + *
> + * Edge cases: nommu does not abide by these, MAP_PRIVATE-/dev/zero satisfies
> + * vma_is_anonymous() but has file-backed page offset, and MAP_PRIVATE-pfnmap
> + * regions have their page offset set to the first PFN in the range.
> + *
> + * Returns: The page offset of the start of @vma.
> + */
>  static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
>  {
>  	return vma->vm_pgoff;
>  }
>  
> +/**
> + * vma_last_pgoff() - Get the page offset of the last page in @vma
> + * @vma: The VMA whose last page offset is required.
> + *
> + * This returns the last page offset contained within @vma.
> + *
> + * See the description of vma_start_pgoff() for a description of VMA page
> + * offsets.
> + *
> + * Returns: The last page offset of @vma.
> + */
>  static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
>  {
>  	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
> 
> -- 
> 2.55.0
> 
