Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1083A48F4;
	Wed,  1 Jul 2026 09:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782899817; cv=none; b=eUZWCR/gcdY8xLVdmKFV9DL3OcNHAIz0pMH41Uf/ARUS3pk9a0ym5BqXmtaPY68j7Gq+TWImnaRG4DkZQ6vFm6c5OIEzjppeKm4HxzGD6Os6vjYePpe3i7ulovmzCjtig4Hu4OM1DvXkITcTzjtML53cq26QDwks+Pt6To+8YXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782899817; c=relaxed/simple;
	bh=ce5x8VsOSihGimDX+E2xZ9QKUoBE10Bad77hJiyAQ1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OOUusOOVqGWGud1hYAOGawQE0KXThOb3pfE20d4gzEppPqRhUvAi1hTwMsw0lOcLX0t+L18ksT6EBGRV0TqZ6fTT8BCTfdodZc/vtdIzXUv0Z5mXPTVdHL6ERsrH1Zcs/8dZ65+T0MNxa7ZnItCsWAzb3668d5VQN0SBrGlPEeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZVMXwNQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZVMXwNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3460C1F000E9;
	Wed,  1 Jul 2026 09:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782899816;
	bh=ce5x8VsOSihGimDX+E2xZ9QKUoBE10Bad77hJiyAQ1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DZVMXwNQ7Qas5su8LVUpZ9nJZzyP2uBxeA7y69zzPN45RtVQlQlUbn6BqoVClF8OQ
	 cdNO1iGygY8gO12qIOso81h2/ovQrZtecs/m5aFsflX56hjaVdJn1UW1oDVl1Yio6K
	 KRPnQX2cEF4iykCZPLFviJvZsj0dccJ/OtNrkWrmrDfd+Zc2DCw82CITQK1lp0tyWe
	 FVO7hLYRhosCJheK7GEd0ZzB4RBxZA6em2G+SdpL6ItiqRo5WAo8LiBboh0bVEWu86
	 sAwvz0MgMFy71FvJ0/B44EaogV7h2VMnc/A+pYGBJOKud9YpmG/8lNeNdIQphF8zxv
	 fOupSSuKidQxA==
Date: Wed, 1 Jul 2026 10:56:34 +0100
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
Subject: Re: [PATCH 06/30] mm/rmap: parameterise vma_interval_tree_*() by
 address_space
Message-ID: <akTkRC7gPzdibXhU@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <43050b10b53cdfc3627440e6b14ae2a9730b2a5c.1782735110.git.ljs@kernel.org>
 <akPsGrmaOd3JMlC2@pedro-suse.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPsGrmaOd3JMlC2@pedro-suse.lan>

On Tue, Jun 30, 2026 at 05:19:16PM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:17PM +0100, Lorenzo Stoakes wrote:
> > The file-backed mapping interval tree functions vma_interval_tree_*()
> > accept a raw rb_root_cached pointer to determine the tree in which they are
> > operating.
> >
> > However, in each case, this is always associated with an address_space data
> > type.
> >
> > So simply pass a pointer to that instead to simplify the code, and more
> > clearly differentiate between these operations and those concerning
> > anonymous mappings.
> >
> > While we're here, make the generated interval tree functions static as they
> > do not need to be used externally (any previously existing external users
> > have now been removed).
> >
> > We also rename VMA parameters from 'node' to 'vma' as calling this a node
> > is simply confusing, update the input index types to pgoff_t since they
> > reference page offsets and rename the parameters to pgoff_start and
> > pgoff_last.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> 1) This is fantastic
> 2) I need to rebase my local work :)
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>
> --
> Pedro

1) thanks :)
2) sorry :P

Cheers, Lorenzo
