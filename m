Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0649039A048;
	Fri, 10 Jul 2026 20:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783715174; cv=none; b=uJs9Sc6i1ZZeGWyRRIY3umtD6rn4VQ3O8bCrISrMzdFsd0ShN1M0mcCrSCPiKKIhmnZ5bAtrM2ZeiaGdMBlqA+4KLGH1qE+m7uMRYTckwweXSiZ3buMCcLtdwqtTK9wjZkFxMBmrzHha3FTC27Eu62Cam66pBsxtwR4wHnpJSGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783715174; c=relaxed/simple;
	bh=tvL+MaL12eeA7d5mggypk6vRzguHxh6VWopq+u01ZHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kXD3zmDFUHNQ9nVsy5pIuC28qjdHfI3uQU/kKftKqN/8B9ITDHWaOpGvZIjElqTi5xbWKMnuS0gm3Hf9sTc9INPYR97FcadVD3L46ZaVmUOG6GXI6aD74oJcJLlkLaWR8UJeZZJxKFdTII/EfyF+16IHtdD9MGnKosMcdozUt4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V2b4QNsr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V2b4QNsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180A71F00A3D;
	Fri, 10 Jul 2026 20:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715172;
	bh=n6273CuNOciMTKCjXSxMrvgGm9l+epwLM6e4G6yOjIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V2b4QNsrlF0LdXzO3awhRO40eRtQvfaV/HOjdbw5a9ThC5CaV62SRPS+o0Q+YfyWf
	 1FVCx1Os6a192C2l5SnQMCn0D7RrdCz2ViuE7eCtMLxvcfkCQHjC0nn0igDYgx/lEK
	 8v8I7ByoNOMMbCUdWAR7qOt4PyHUnaVpBakMgQLbjRjpNsRE73xOFL/wPzBQ/rOSV6
	 tkllPYfbAzDgQ0XGhYYzZc28UxmgDagjeYwNH6ql4CD6zU4oFDuJT/UxPIWqXHJJR5
	 Og/JsMmeP3J2/oqnYpv5pL/Ia81wK2Bfj0r5G7e5AmI+G7yexlxowXi92aVVdo47u/
	 UbXYnmBP/FRjQ==
Date: Fri, 10 Jul 2026 21:25:47 +0100
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
Subject: Re: [PATCH 29/30] tools/testing/vma: default VMA flag bits to 64-bit
Message-ID: <alFUVjk7yP8VoBGp@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <27cd07f6dd862d92410cf9db03f7c11e5f66854d.1782735110.git.ljs@kernel.org>
 <alFT7lx8F04rN01D@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alFT7lx8F04rN01D@gourry-fedora-PF4VCD3F>

On Fri, Jul 10, 2026 at 04:19:58PM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 01:23:40PM +0100, Lorenzo Stoakes wrote:
> > With all of the sanitisers turned on, setting the VMA flag bits depth to
> > 128 by default results in overly long build times.
> >
> > Reduce this to 64 - we can always manipulate these later for testing of
> > larger bitmaps as needed.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Seems like this causes instrumented inlining to go crazy.
>
> static inline void bitmap_or(...) {
> 	if (small_const_nbits(nbits))
> 		*dst = *src1 | *src2;
> 	else
> 		__bitmap_or(dst, src1, src2, nbits);
> 	        ^^^^ this branch is being hit ^^^^
> }
>
> tl;dr: __bitmap_or() gets emitted and then the sanitizers have to
> instrument a ton of inlined functions instead of the compiler simply
> injecting a couple 'or' instructions.
>
> if you wanted to keep the coverage you could do something like
>
> # These can be varied to test different sizes.
> NUM_VMA_FLAG_BITS ?= 64
> NUM_MM_FLAG_BITS  ?= 64
> CFLAGS += -DNUM_VMA_FLAG_BITS=$(NUM_VMA_FLAG_BITS) -DNUM_MM_FLAG_BITS=$(NUM_MM_FLAG_BITS)
>
> w/
>
> make NUM_VMA_FLAG_BITS=128
>
> would let you still test the branch but not by default.

Yeah I need to make it easier to set.

And that's a pity re: the sanitisers, the generated code should still be
efficient (will investigate some more over time) but yeah puts a lot more
pressure on the sanitisers for sure.

Is there a way maybe to configure the compiler to not instrument like that or
somehow derive things? Or maybe it's inherent... I am kinda fine with assuming
the bitmap stuff is OK!

>
> anyway:
>
> Reviewed-by: Gregory Price <gourry@gourry.net>

Sorry but I'm sending out the v2 I thought maybe you were done :|| and I'm so
tired with this heatwave + UK houses being like ovens in the summer (cold in the
winter!) that I just needed to get it sending.

Could you pop it over on the relevant patch on the v2? Once the sending stops,
b4 went crazy and added half the kernel so it's taking a while ;)

>
> ~Gregory

Cheers, Lorenzo
