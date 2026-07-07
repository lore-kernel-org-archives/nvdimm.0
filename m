Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5283DBD77;
	Tue,  7 Jul 2026 10:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783420885; cv=none; b=gsfwuHd0VZ7pNgyx+zLrNIJVudQzoZvcyuwZwKcskNlTCtP35li0U6IohLr7l1J1TX35XXDIvGcXyf7fGztV0SobrxZPxSgpVJ1KT+dkN92LWA4RjKbmNya+ho695okUVLTH35Vc1bUwF6Vqsjysssy3X44A+tfTMdgKZcv24w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783420885; c=relaxed/simple;
	bh=Xw6iul3GAEVFXG85MeigwE1P9l/tr49Q8V+TfN4+fXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iUDXuab3gEAT6jgyYfp2qYPHZhPKfaGItMAXmxZUgQVDH192qigg6TPv97+yub9wbNPPgeZW78zpobmV9En3SaH4ANaLQ34h3lJfyazfCIty5cZDkurGC6AMyuD8o0/G9Vg363cd8Zg6Qp197rLt/XqybbwXt0nH2LXd6gMN0as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C4xQ1MLY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C4xQ1MLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBB51F000E9;
	Tue,  7 Jul 2026 10:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783420884;
	bh=oJf9TD7SQDB5FPJJW2/ET84adS4IbuPC7yAGQona0w4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C4xQ1MLYDSpZyJ9vErhP7qHq91i9ikXGv0t5hCWrCl9eUTArSekW8IgLF8XGmtWKd
	 xTIGCAyh1qfIlIufd5l17Cgwg4WqZiF4dc+/TCPc8HvDG1fNFYGWBlF0ToYxYrqjvN
	 YneV9/r2ute74xY+Q+roObPcxwoMMhJLENuNjhLyPISKLBSurogQ/rIw6E73c+hLlm
	 hTTkc75Ea9WO07vhZSUrk0zIjjA/Vuj7oO0Rk/wliB+L2u0OvPNR67ir9nUGC/aRRp
	 HRIxrduui2kRQb/MqDuhLQSFwpD8S/oxg/5H6IXHtt0/ADede4e0LeTLhY0Ts2D2mS
	 8/Zlwql9MxhGA==
Date: Tue, 7 Jul 2026 11:41:00 +0100
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
Subject: Re: [PATCH 27/30] mm/vma: correct incorrect vma.h inclusion
Message-ID: <akzWq08xwXKqwwtq@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <22d0f4e3fe11f6fd1312734e242d008267ad142c.1782735110.git.ljs@kernel.org>
 <akZNiN5Y9fPk8bZH@pedro-suse.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZNiN5Y9fPk8bZH@pedro-suse.lan>

On Thu, Jul 02, 2026 at 12:40:30PM +0100, Pedro Falcato wrote:
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
>
> Two random thoughts:
> 1) perhaps vma.h -> vma_private.h

Not a bad idea thanks!

> 2) https://lore.kernel.org/all/CAHk-=wghMm2c+AYEcwYY7drSVXB27DYqc-ZXpFiq=XFs-w59wA@mail.gmail.com/
>    mm/vma/whatever.c :) would PROBABLY solve the issue of people snooping vma.h

I think a vma/ subdir would probably confuse things further, I think renaming to
vma_private.h neatly solves it actually, along with a comment maybe in the
header itself?

Then again mm/vma/{vma.c,init.c, exec.c, private.h} isn't too crazy
either. Though vma.h is the actual 'shared' bit, and vma_internal.h is the
private bit that the userland changes. But could switch things around vma.h ->
mm/vma/internal.h that mm/internal.h imports, and mm/vma_internal.h becomes
mm/vma/private.h.

I think that could work but definitely a follow-up!

>
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

Cheers, Lorenzo
