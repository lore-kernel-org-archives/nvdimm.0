Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E93035F5E4;
	Fri, 10 Jul 2026 19:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783712169; cv=none; b=aT16SYw4LVBoMSjbI4AEpXQ9GQL9E39XNr2ybOIiaDSgbuYAO30HEJqNeE0n+rVOk2R7RLGJkOqX3KisSzjZ1lxUEZisui/y5aA7bp4gGMMswi3dfbH2TzDOTHrlilOXbHoD4WljGSifW9lizRTT5BECVZE43e9jM68PUqoFxM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783712169; c=relaxed/simple;
	bh=FfLPpKhOWsC/sVsNuiGUTkxCqQvuOvc9PrMkV9J6Kkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kx8zZV+iKjEOqJDBgoCQvAjvS/QqNLYPDV6QRyzFyHeTgGUgiPsNkxS5uFVl4klRUoOXpjLaAFLDq+xYmxADzp8XEHAt6ohsI2Bz4WWchm+aOeOQSDDheCCvP9xQ/MMe3oeSHY9EsmDCRPeg3wcHBZxxG5R5cLWN2Y8gBgE6tOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GMSJQzHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMSJQzHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EA21F000E9;
	Fri, 10 Jul 2026 19:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783712168;
	bh=FfLPpKhOWsC/sVsNuiGUTkxCqQvuOvc9PrMkV9J6Kkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GMSJQzHYzzqQWm9PYMzUnrJgvzs2G9TH47wDGMDemvUAcIBLvWbRt6SIta8fNBwpk
	 4I1KzrcwinweqkCs0PIx0LTM6cTuB1EbRcqAQa1jYKzjr9JQ5Wtcz35zBJE5VHsTO2
	 cG9UL0/p5mQIf6dJdIDATgnZoBwiS18qqWXfRPN1X9YuCai4Sxlbmwyp1iHn5oqaVT
	 dYn1B2V/Mcdasv1lXZW09wtL6Km0Wa4YkT0iudkguHEDJPY6VHY2zx2FH0me1qiUli
	 FT7YTboRx/zld4NxRHycYg9RobUPctsDzxrL3Ch4bqyHkHMgOJIWg31b9WaLtB1aK1
	 q5GlLYmUSufqg==
Date: Fri, 10 Jul 2026 20:35:43 +0100
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
Subject: Re: [PATCH 27/30] mm/vma: correct incorrect vma.h inclusion
Message-ID: <alFJUfaGHVnKd-Nb@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <22d0f4e3fe11f6fd1312734e242d008267ad142c.1782735110.git.ljs@kernel.org>
 <alFHR3fg8K1-SITK@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alFHR3fg8K1-SITK@gourry-fedora-PF4VCD3F>

On Fri, Jul 10, 2026 at 03:25:59PM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 01:23:38PM +0100, Lorenzo Stoakes wrote:
> > The only files which should be including vma.h are the implementation files
> > for the core VMA logic - vma.c, vma_init.c, and vma_exec.c.
> >
> > This is in order to allow for userland testing of core VMA logic. In this
> > cases, vma_internal.h and vma.h are included, providing both the
> > dependencies upon which the core VMA logic requires and its declarations.
> >
> > Userland testable VMA logic is achieved by having separate vma_internal.h
> > implementations for userland and kernel.
> >
> > Callers other than the core VMA implementation should include internal.h
> > instead. This header does not need to include vma_internal.h as it only
> > contains the vma.h declarations, for which the includes already present
> > suffice.
> >
> > Update code to reflect this, update comments to reflect the fact there are
> > 3 VMA implementation files and document things more clearly.
> >
> > While we're here, slightly improve the language of the comment describing
> > vma_exec.c.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Reviewed-by: Gregory Price <gourry@gourry.net>
>
> > +/*
> > + * To allow for userland testing we place internal dependencies in
> > + * vma_internal.h and external VMA API declarations in vma.h.
> > + */
> ...
> > +/*
> > + * To allow for userland testing we place internal dependencies in
> > + * vma_internal.h and external VMA API declarations in vma.h.
> > + */
> ...
> > +/*
> > + * To allow for userland testing we place internal dependencies in
> > + * vma_internal.h and external VMA API declarations in vma.h.
> > + */
>
> Do you actually need 3 copies of this comment or just one copy in
> vma_internal.h?

I'd rather have it at a glance, it's a bit silly but C headers are silly :P

BTW you're kinda racing against time here as I'm on the verge of sending v2
:P
