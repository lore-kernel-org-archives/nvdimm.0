Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34383F1AC8;
	Tue,  7 Jul 2026 10:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783421262; cv=none; b=TclHGrPec0fHZ6cX74uAPHfe5JZqnItT9SsbFDNvdnrgM3zPHc/vZOmxjzTXSoURRezGSYwxWAGRZrdJtKqIiYu64joC/dmGHxVMNd04ZtXQx2lO5vmfEjk/Au0drFE+e6OKr+Jp1KqRyP6aff0nc7l/E4ETYdLGcVgRXBp9fds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783421262; c=relaxed/simple;
	bh=K6XhXZvdxeZA7r5A4Qd3KUVGcGcAP3v98yAItEXMLbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3GkjkvKE2epH65fvIw5FZ+E6RFNPL8iz04hICiL7ObezhLBrCNJ2d311ro1qGxVDyKnZ86MlSPVNZKGrziXH8LBC+osOwoOPoslMPJC/WZBMxowro/la17oXWhN+X21tCSP3wMz+3ji3RaAQC0i0lbj7rRVmWESvfCkm9rfQmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nAwcbqQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nAwcbqQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA301F000E9;
	Tue,  7 Jul 2026 10:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783421260;
	bh=LLhzkk/JgHcYgAhLZKjLeN62LByel6fmISiRV1ITuB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nAwcbqQZ6EYWFhU6Pa79F4DwZWj+s50w7KhSPUgAeSGSsvopOpj4c3CR6Dc4BvSKY
	 UI/T4Y1V/RDDoyeFB8sXD2vSc8XMgX7PuHapXBY0cr7IWraSANQSAw1tuqycqvya7H
	 EOLCy/nYmsu9fsBZZUMJw29VxKcXmmkS6wgUhpYDSoopqSIeazhcGwCvu+qGCZzZfm
	 i6rrFcDrq00hFMpsTT5W6KK6td/K2YCAI1AB22h3luD//ahG1ub28FDnVRKZXh9KJy
	 yczJHuo2utfhmEijYANtSxrq9T9w4QGeuL41lVe4jp1n6hobidMgbC6xXylCzlyKTK
	 rSE3IBUcHgXTg==
Date: Tue, 7 Jul 2026 11:47:16 +0100
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
Subject: Re: [PATCH 29/30] tools/testing/vma: default VMA flag bits to 64-bit
Message-ID: <akzZBrZC_ja-R-nJ@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <27cd07f6dd862d92410cf9db03f7c11e5f66854d.1782735110.git.ljs@kernel.org>
 <akZO3xI4Lt1iSbms@pedro-suse.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZO3xI4Lt1iSbms@pedro-suse.lan>

On Thu, Jul 02, 2026 at 12:44:21PM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:40PM +0100, Lorenzo Stoakes wrote:
> > With all of the sanitisers turned on, setting the VMA flag bits depth to
> > 128 by default results in overly long build times.
> >
> > Reduce this to 64 - we can always manipulate these later for testing of
> > larger bitmaps as needed.
> >
>
> Hmm, what's the problem with the sanitizers? Shouldn't this just result in
> slightly different codegen?

I'm not sure but it results in vastly longer build times. It was a fun idea but
it partly defeats the point of the VMA userland tests.

Rather than spend too long investigating I'd rather we move to a sane default.

>
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  tools/testing/vma/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/vma/Makefile b/tools/testing/vma/Makefile
> > index e72b45dedda5..ef6cc558afe1 100644
> > --- a/tools/testing/vma/Makefile
> > +++ b/tools/testing/vma/Makefile
> > @@ -10,7 +10,7 @@ OFILES = $(SHARED_OFILES) main.o shared.o maple-shim.o
> >  TARGETS = vma
> >
> >  # These can be varied to test different sizes.
> > -CFLAGS += -DNUM_VMA_FLAG_BITS=128 -DNUM_MM_FLAG_BITS=128
> > +CFLAGS += -DNUM_VMA_FLAG_BITS=64 -DNUM_MM_FLAG_BITS=64
> >
> >  main.o: main.c shared.c shared.h vma_internal.h tests/merge.c tests/mmap.c tests/vma.c ../../../mm/vma.c ../../../mm/vma_init.c ../../../mm/vma_exec.c ../../../mm/vma.h include/custom.h include/dup.h include/stubs.h
> >
> > --
> > 2.54.0
> >
>
> --
> Pedro

Thanks, Lorenzo
