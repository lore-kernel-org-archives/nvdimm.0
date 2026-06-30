Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0BF1A7264;
	Tue, 30 Jun 2026 15:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782835190; cv=none; b=fsKdlWTsAkANw3XhcEiBrEVlvKboBZVQ5z6oSkzcwOgs7nAGbDprwj5Mi+0PPeuLOHZbllWyETKjYFKl9FD07/r5yt55IxVUbu9v+BtLvRsBEE2xO3YQ4dEZvbxlfKscEysfuoaoooAaCTn3SSE6kCUemDXa2IiaMp84DZ8WVHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782835190; c=relaxed/simple;
	bh=Jpqlio7c6IwdURKLwRpFgqWlGfFzVK3YBZ3R69sS8Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JQm4u9/V63FwacKtz1IK1L5YY/IKF6dST8qizWSPYHmeZeF6+g6fScbqZjaJC4fthizbo4vDn/h/ysRUJTe24AMhm5Y53lY66yHsLlMCY9lQohwO3B3tu78yGiNKQ7LornYrDopeFN4FLLGjhtFPsk0NtV2x3WuAgzGjLDtWQrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ci9AAqdO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ci9AAqdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B121F000E9;
	Tue, 30 Jun 2026 15:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782835189;
	bh=djpiGDB5pDyZxxVDzk8Ai71BtRGChWWd/YRJODi7goY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ci9AAqdOLAohpCehoyGUTmmcFqfPa2oLGOqbZA9HwlKfiaK/2p+dH9vORoffpCm86
	 q8leL4Dlsp1qy9Yr94qQi7IzIRGWwUp03Ox/TCewfjXjcvq8BGq/g74kymFs9rHjA5
	 MrW1vu5+Lfkqui3LnQKB/7BAsBT57d2t8ggydNB9+a5PQ570qdOVWQBGkR3rpMUr1z
	 JR1FOW8X2W4fY5MIuIHaayJTXpVa54bwLi465HUMNq3LdKWZJ3bAmB/5zZjweWZmk3
	 TM+KPanljb5plGckEArrF2iME4cvjeiarlcd3PZEyevECQ2zF5DwH5Jlh1E+7SjwTb
	 ITPrvbrgepgTg==
Date: Tue, 30 Jun 2026 16:59:27 +0100
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
Subject: Re: [PATCH 09/30] mm/rmap: parameterise anon_vma_interval_tree_*()
 by anon_vma
Message-ID: <akPnjlGP9EDhrIrw@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <1c1df7b905ef340cbf2effef769a4e770a8e0eb1.1782735110.git.ljs@kernel.org>
 <akPk5o_gHD1SxX_0@gourry-fedora-PF4VCD3F>
 <akPlUrNWzl1ZPw1S@lucifer>
 <akPm4FlwTj0FsZU9@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPm4FlwTj0FsZU9@gourry-fedora-PF4VCD3F>

On Tue, Jun 30, 2026 at 11:55:12AM -0400, Gregory Price wrote:
> On Tue, Jun 30, 2026 at 04:49:45PM +0100, Lorenzo Stoakes wrote:
> > On Tue, Jun 30, 2026 at 11:46:46AM -0400, Gregory Price wrote:
> > > On Mon, Jun 29, 2026 at 01:23:20PM +0100, Lorenzo Stoakes wrote:
> > > > Similar to what we did with mapping_interval_tree*(), let's declare
> > > > anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.
> > > >
> > > > In each case the rb tree referenced is &anon_vma->rb_root, so just pass
> > > > anon_vma and the functions can figure this out themselves.
> > > >
> > > > Additionally, rename 'node' to 'avc', 'index' to 'pgoff_start', and 'last'
> > > > to 'pgoff_last' to make clear what is being passed.
> > > >
> > >
> > > would it be possible to split the pure rename changes out from the
> > > changed function declarations?  It's hard to pick out this as something
> > > that needs to be looked at as more than just a %s/x/y/
> >
> > Hmmm do I have to? :P
>
> I mean, no :]
>
> > I mean sure I can on a respin potentially, but it is a
> > pretty trivial change? Just mechnically as above.
> >
>
> And yeah certainly not worth a respin.  Just learning some of the
> friction points of reviewing as I spend a little more time doing it
> every day.

Oh in the end you will be driven absolutely insane, David and I are already
there and soon you will join us! :) <- nervous smiley

But yeah, sorry if that made it harder to track what I'm doing here! Usually I
really try to split up to make each patch as easy as possibel to review, but
this one I thought 'why not at the same time' :P

>
> ~Gregory

Cheers, Lorenzo
