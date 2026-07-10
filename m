Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C732EBDE9;
	Fri, 10 Jul 2026 15:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783695718; cv=none; b=GPorsR+9vHpgsv4oAf+IuZ6/NRWBMZEdRaOpi946vEueLdeh5nUdUe+qjWm06SqyJfRJozn3utprAHLmdJg2E0awNFGrNMxVVTRNzBFRU3U7ultt6Zk+TOLk5zY6avp6wsqLsuSd2j1u0QjO8d0DkrLVE9FhewLSxkSqdqoy3As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783695718; c=relaxed/simple;
	bh=Ci3fdpehI4rOiqy+LhAnJgJDnpCt62MiEiqcY4h5Diw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rYPBYUg26C8Mg+2vSV55/FsB8oz+5P2+yicW18cEqJZ102l5w9HAjDAh2srH5nCUl6C5zoFQMKcrSzYd4ovxR85B0Ha3Ts9mgZBiopQ4QG/dN+Z/HW4CHylVhGx7uRj5wrAv8ZRB9BNqOQWpLtDPkJldOdgrf8SfB/QBaf+/X5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aezvcf2o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aezvcf2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E8A1F000E9;
	Fri, 10 Jul 2026 15:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783695717;
	bh=Nv6v5Gy5ZQKCjEDZ1CZd677nx3NlM5I4XdPHxBdo5us=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Aezvcf2oBz8R5O/JgeqQKn1Iv07D3k4kEuvwCc1b7Uv9q44jdZfUS20v8wyrCa/9F
	 sFEfI7dW7gs9z+SsSfhJ8kA/ge/LrGSSz9zC3Je135DOXWvwgHKHjr0HNZUKiB8R0Z
	 6ZFI5o7wwOhve66iKnNqXpiMhf7SJFuqNWUQojN72CN7vt9E+8N+ylqWmq1V8VELbe
	 6ISmJ6bIDd6gomwGV7FsmpP5iGhPAK7B4N+ljOCC/csygDMZAkTZJGZNY4oR569umI
	 ng8odBspjBH26Pq4TIGI6qDk3zs12pR3kiMN2IWrXV9IPeu4GxV8o5adjm1flT9Viv
	 C2o6tJaaVjqqw==
Date: Fri, 10 Jul 2026 16:01:32 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
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
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 19/30] mm: use linear_page_[index, delta]() consistently
Message-ID: <alEJP-qEgSIUOp38@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <bf56e2e98b512962a2fb88900d535a0e9e6769d8.1782735110.git.ljs@kernel.org>
 <ak_EivwcDDdn1Xvp@gourry-fedora-PF4VCD3F>
 <ak_E1Y-D2Twykusr@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak_E1Y-D2Twykusr@gourry-fedora-PF4VCD3F>

On Thu, Jul 09, 2026 at 11:57:09AM -0400, Gregory Price wrote:
> On Thu, Jul 09, 2026 at 11:55:54AM -0400, Gregory Price wrote:
> > > @@ -2462,7 +2463,7 @@ static int comedi_vm_access(struct vm_area_struct *vma, unsigned long addr,
> > >  {
> > >  	struct comedi_buf_map *bm = vma->vm_private_data;
> > >  	unsigned long offset =
> > > -	    addr - vma->vm_start + (vma->vm_pgoff << PAGE_SHIFT);
> > > +	    addr - vma->vm_start + (vma_start_pgoff(vma) << PAGE_SHIFT);
> > >
> >
> > Obviously correct, but was this intended for a different patch?
> >
> > ~Gregory
>
> bleh already caught, sorry for the noise :]

Haha no thanks for picking it up, many eyes bugs etc. etc. ;)

Cheers, Lorenzo
