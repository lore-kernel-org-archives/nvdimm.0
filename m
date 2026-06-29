Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6303D2D3A7C;
	Mon, 29 Jun 2026 16:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782751300; cv=none; b=koSUHby8zUQFSqcjCeW+76yEam6DRu5el4+bx3YmWkiJo3cMKhAcE5cjTOdHLloAD7ivBNz04+TkHX2jBowjA3j65mGsAu6rAWOxzvuydTeyA5kvVJl2AqOMGjixRkJJeYNE51fnT6bImddHe6+sTKSgrIOx9NVcb1LP8nYCRhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782751300; c=relaxed/simple;
	bh=CFEM9BgDLXz04FkWaVKAh5iws54Pp4c6vKoWw6aTPlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OZQ1IHqYT9yZcLnSh4AFO3sHBs75UsLAOG30u8eilW7biqsa/SlglBSccYaK2C9LHccp5UrZM3IVrthY7uD4h+5z/o0IY/khah4AbagZkB+FeAA6RLCm0qmYX6cV9LwQu46e5XWKk1wYL9/xxwSMnWoU/yuOhcm0nAt2SxmibVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hJmAai/5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hJmAai/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027B21F000E9;
	Mon, 29 Jun 2026 16:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782751299;
	bh=ch5CI1toUlORlovajdCC+YMRoe+PpJQnl8a5VV79Qi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hJmAai/5vkibkmO6VFkWSq/Ll1y5jE3j/DzaeyyPFKyq6xwAWxIjO79R0qGEP4vSC
	 dscAlrX5ctbgTMNUAbj21/JNqvHk3lRwZZOF6r/Ta4FjjCdP3/PBnSN/C4tlpR5j9j
	 HSF7Dlc0aoj7gsDTbePMQtjCP/xBpH87s7MdWxQs9Zuf/RhQ5LBVu/X3uV1WM1uMla
	 uNw5QZ+z1TPY33Q7kIG03f2R4Eax2CqGoQK5L9fO6gf9Y0pff5oJ8krKULZnitJWl+
	 HfINykNpBBlOytN9AKxyPcJqJfMwdZgfi0f/ZXCpWHSG44+9HDMHmBql5baxz3zYvY
	 zey7OMeB60fnA==
Date: Mon, 29 Jun 2026 17:41:16 +0100
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
Subject: Re: [PATCH 05/30] mm/rmap: update mm/interval_tree.c comments
Message-ID: <akKfAl-wdIAbexNR@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <80d482a927b2e9862487b812e0ab48ebc1289a70.1782735110.git.ljs@kernel.org>
 <akKWvnU2Ua-8ceSb@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akKWvnU2Ua-8ceSb@gourry-fedora-PF4VCD3F>

On Mon, Jun 29, 2026 at 12:01:02PM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 01:23:16PM +0100, Lorenzo Stoakes wrote:
> > Update the file comment to clarify that both file-backed and anonymous
> > interval trees are provided, referencing the relevant data types for
> > clarity.
> >
>
> Isn't this self-evident by nature of the function definitions?
> (one takes a vm_area_struct, the other takes an anon_vma_chain)

Well you see you're already hitting up on issues there, they both take an
rb_root_cached and the vma_*() ones do not instantly scream 'file-backed' do
they? As VMAs are obviously used for buth anon and file-backed...

But later patches fix this stuff :)

And I feel it's hard visually to see where one set of definitions end and
another begins, which was really the motive for this, as trivial as it is!

>
> > -	VM_BUG_ON_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
> > +	VM_WARN_ON_ONCE_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
> >
>
> For my own edification - I know not to add new BUG(), should I be
> converting BUG->WARN/something when i find them in areas i happen to be
> working in?

Yeah pretty much in all cases.

It's very rare that you'd want the kernel to definitely oops, and I can't think
of any circumstance where you'd only what that if CONFIG_DEBUG_VM was set :))

>
> ~Gregory

Cheers, Lorenzo
