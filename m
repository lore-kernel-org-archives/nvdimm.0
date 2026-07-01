Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D496B3B27EE;
	Wed,  1 Jul 2026 09:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782898985; cv=none; b=YA1foMsAWrG8Xryxl9NriODU7LtvqYZPDVYNtjgrY+RYVkUFSUz9+zWSA/yrexiq2jNnSAcbXh5Hxov2xrE/qVUGv8Tr1Q3rFodUU/8QPIkYk+3cfkwlHOU95aNa9T1ib1+cau0Xunj6PBkg8aY8cazb8JuBzhFpWxNCMWDSat0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782898985; c=relaxed/simple;
	bh=EJTWrCholcPIoSl8RFtuUpkQI/cEAyQCVknR64tfFn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M92xdCP275uHH+5fvb+Izen4goeAE9iL/PiykJS/6bqIlNTtlnW/6AiCC8yuSBtN2Cs13JlS6yxiYmfWhec/BYE0gA22MXdf2QBdmdRX1NLYbJ+mLwIqEzoxQOu8guFzFgDnPmq8vvf6DL6PHgkV4f6gpIes+O6k5gHImsfBnbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NMvirreP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NMvirreP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C261F000E9;
	Wed,  1 Jul 2026 09:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782898984;
	bh=yD2RrJDZdDL6RXjT+lWLw24YuDCa/4sSWtW/fyWFcdQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NMvirreP+CX8s1HLyn6zgBtUDz2oDbR9gIrXRS6YaNTcLZcnF2rsBWbQVm+Jl25Sr
	 A8lJ4z61L/giXcR/ptNpe3o3puYpqxx0hsQHO+85EjYqDjCEIO/1lP13eBb0n33jbM
	 UqdM041iHE/nTaNAA42LQ7VXM81xgA3Bi0FchvCuGazRU+YOdfKqe2mJyLfx4J0AJ1
	 B3RyYF4D778BuLdBJm0jXf0mSpjvs1QuEQapPlpQ8TZMICq6soqt5v87zbEEbs2TAJ
	 FdEluByUsfWooss92oIM/tmJ0RAV1NPZbvuLQEU3DJQZvF/ZXYqF3+AFDc5BkN379N
	 fKMeFEDS7Kh+w==
Date: Wed, 1 Jul 2026 10:42:43 +0100
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
Subject: Re: [PATCH 01/30] mm: move vma_start_pgoff() into mm.h and clean up
Message-ID: <akTfDTjDnnZ-8zwE@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <b28b698df4c009e85c4728446ca5863d8e633164.1782735110.git.ljs@kernel.org>
 <akPqIfmQLOs4gI7h@pedro-suse.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPqIfmQLOs4gI7h@pedro-suse.lan>

On Tue, Jun 30, 2026 at 05:10:55PM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:12PM +0100, Lorenzo Stoakes wrote:
> > vma_last_pgoff() already lives there, so it's a bit odd to keep
> > vma_start_pgoff() in mm/interval_tree.c. Move them together.
>
> Hmm, a part of me wonders if this is the part where we should start cleaning
> up mm.h into vma.h or something. Probably not, it would be extra churn right
> now.

Yeah the issue is there's some confusion about vma.h - mm.h should be for
stuff that is used outside of mm, and these helpers are definitely like
that.

vma.h is purely for internal mm vma stuff, and most people should be accessing
that via internal.h (I address that in patch 27).

I do wonder if that could be done more nicely but punt that to another time.

But also probably worth doing a pass over some of the defines, I have a
bunch of series chur^W changing stuff lately so can do a follow up on that
maybe.

>
> >
> > These each return unsigned long, which pgoff_t is typedef'd to. Make this
> > consistent and have these functions return pgoff_t instead.
> >
> > Additionally, express vma_last_pgoff() in terms of vma_start_pgoff(), since
> > we wrap the vma->vm_pgoff access, we may as well use it here.
> >
> > Also while we're here, const-ify the VMA and cleanup a bit.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

>
> > ---
> >  include/linux/mm.h | 9 +++++++--
> >  mm/interval_tree.c | 5 -----
> >  2 files changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 485df9c2dbdd..059144435729 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4278,9 +4278,14 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
> >  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> >  }
> >
> > -static inline unsigned long vma_last_pgoff(struct vm_area_struct *vma)
> > +static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
> >  {
> > -	return vma->vm_pgoff + vma_pages(vma) - 1;
> > +	return vma->vm_pgoff;
> > +}
> > +
> > +static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
> > +{
> > +	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
> >  }
> >
> >  static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
> > diff --git a/mm/interval_tree.c b/mm/interval_tree.c
> > index 32bcfbfcf15f..344d1f5946c7 100644
> > --- a/mm/interval_tree.c
> > +++ b/mm/interval_tree.c
> > @@ -10,11 +10,6 @@
> >  #include <linux/rmap.h>
> >  #include <linux/interval_tree_generic.h>
> >
> > -static inline unsigned long vma_start_pgoff(struct vm_area_struct *v)
> > -{
> > -	return v->vm_pgoff;
> > -}
> > -
> >  INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
> >  		     unsigned long, shared.rb_subtree_last,
> >  		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
> > --
> > 2.54.0
> >
>
> --
> Pedro

Cheers, Lorenzo
