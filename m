Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B6D377544;
	Fri, 10 Jul 2026 13:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783690767; cv=none; b=q4Sd47eeuC/Pr9rX0DQfdHOq+ljWD1gAYy3StiL2oSaEOSaYd1STgDJohmyWs/BC6rUIYJA3XBkKEl+ntCDuB0bn8l90aJL9lK+xnmAdAoLxCIlCIiHJtdpXhe0Ow1IziWtxrtfTn+kBY6j2Zl4ytPkhl/UxE3GXduUcUb7YU4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783690767; c=relaxed/simple;
	bh=1zOgBPuUrXPvOJucK7GyHI1L3i2YRBy6YlCIQgSIRNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uCCCam7JJ+bGLls+yV+6sAzqo+QGyEBBt5ltXIDLZCPAIXGa6TP+wguwbhEQ3fsZq8/319Hgp5pkBF/opR2ou+foI1Mph94u6D91xhLpeOoynPWrdTozYYh2E5C/BZaB7Nwu1YgTZ7JgPh5BOsFiDJ43Zc8XAsGXumIWeXU2nWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fydQPaDx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fydQPaDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F051F000E9;
	Fri, 10 Jul 2026 13:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783690762;
	bh=hWe5y0XfVr4QQQGo0kaEF8UGbBWB4HZz8UbrXKM7Z28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fydQPaDxS/hHGLVdvf977qUXBNSF6t19lqQW/RqVTS+Xk5pgKo0deA+cWIFhyYRvv
	 IeSezmg4COMZrohE1QJ6gnvclo/bOnA8j2IrdEmxinGMPa0Cv9pB6NQzVtyWt96x//
	 6dNWU5GX7waS+2jwE8BVZ3WNZw/wsfy0C0SSKxIKb3QlnIRCNzHVm3c5Ps0q8mrTgW
	 zsWArKYrCmnfDcrebwcipzmYNQ0mhqZJQQZSGHykLDKtejNlCDmPcno/dc/3rjzGeu
	 kuxVdLjqHCE3kyZgIMxt9Re36Qo0mzOOVMmO0ZdfPfAx62l26oANlEaaJo1XHJjjzR
	 MdqLjT6QyxJDg==
Date: Fri, 10 Jul 2026 14:38:58 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
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
	Suren Baghdasaryan <surenb@google.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Matthew Wilcox <willy@infradead.org>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, 
	SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 02/30] mm: add kdoc comments for vma_start/last_pgoff()
Message-ID: <alD1h7kHZdX_0I-0@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>
 <03762de9-c695-4cdd-8c25-4fc31335ea15@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03762de9-c695-4cdd-8c25-4fc31335ea15@kernel.org>

On Tue, Jul 07, 2026 at 04:46:13PM +0200, David Hildenbrand (Arm) wrote:
> On 6/29/26 14:23, Lorenzo Stoakes wrote:
> > Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
> > detail.
> >
> > This is in order that we can differentiate this between functions that will
> > be added in a subsequent patch which provide a different page offset.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  include/linux/mm.h | 26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 059144435729..2f00c75e66bd 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4278,11 +4278,37 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
> >  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> >  }
> >
> > +/**
> > + * vma_start_pgoff() - Get the page offset of the start of @vma
> > + * @vma: The VMA whose page offset is required.
> > + *
> > + * If the VMA is file-backed, this is the page offset into the file.
> > + *
> > + * If the VMA is anonymous, this is the virtual page offset of the start of the
> > + * VMA - if unfaulted, then vma->vm_start >> PAGE_SHIFT, if faulted then the
> > + * virtual page offset at the time of first fault.
> > + *
> > + * Note that if @vma is a MAP_PRIVATE file-backed mapping, then this returns the
> > + * file offset.
>
> There is the ugly case of @vma being a MAP_PRIVATE PFNMAP mapping, where it
> returns something different.

Yup, the pfn  I will update doc to mention this abomination too.

The virt pgoff stuff in the RFC fixes this also.

>
> (remap_pfn_range_prepare_vma() -> vma->vm_pgoff set to PFN)
>
> --
> Cheers,
>
> David

Cheers, Lorenzo
