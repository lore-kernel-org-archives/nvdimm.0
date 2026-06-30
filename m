Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66494466B55;
	Tue, 30 Jun 2026 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782834611; cv=none; b=Y0cKZlu48KbhsTfHG948kHbSoRMsA3NJLkNb5Fiy9gBK8jguOALaII6ZCjRTmIk+sFzmsFhr7r80XMgQrq5C35cPwCPLIm3MYQEe5KBOjovWWJCHszwXLxICR9CzHN4QhhqYypVgRlgusZS9fX+hgS2Ap7XKWjoUZHEPBMkg7e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782834611; c=relaxed/simple;
	bh=rRb5hh+X+XTXMExHBUaeesLQqMTZAWb/6638JVstGzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pJrE43nppkHltxQsO/AiYO2G6Ow1U+20QtAlFgZmpzuicm3Z9RIS73XIX41BTUDuuo4zS0oUQDHtkfDd5c5oAmZQy7Jz7i6G2ybnGs9QeRpOFdhY/1rMvekzNJdWvOka0j1M6tiGEQdNljuh0I4bOiusJJkrXXK1wz1UEQ8Y2Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hxSdKdn5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hxSdKdn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0901F000E9;
	Tue, 30 Jun 2026 15:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782834607;
	bh=miS3eC+cFOKuQvparEB9vcuI1B25HnurX/vUMM3/hkk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hxSdKdn5tYWxzQMiSUZWtXeXixz28n8frcvHVVdAhflb0/y6u10yg1vqQp7dOLC/s
	 mkeAwgMLSjMZ1Gzx9I8Mby4w95CO8nSoPAPdQC2YjgnJWXbQa2Tj21eAsgsTQentQM
	 Mr6XemUKwyK+8KVvXA0JS/C9LKF0Sj7JGqJXDPvByor5pxopRci3aGfdPqf+sJ0XGL
	 rs380OMcwCwjE2LAtsEp30AZ4eX+KEAL/mQEVmPqt3GCfEUWYAZjglbKpir8HNgBUC
	 +gJ9lgc97IlCfR33+GgtUkBX0Ami8XQs3TNIWsr6vl/cNBIcISNLkD1Ly4+lJR3OMg
	 N6odwJyxTP+ug==
Date: Tue, 30 Jun 2026 16:49:45 +0100
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
Message-ID: <akPlUrNWzl1ZPw1S@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <1c1df7b905ef340cbf2effef769a4e770a8e0eb1.1782735110.git.ljs@kernel.org>
 <akPk5o_gHD1SxX_0@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPk5o_gHD1SxX_0@gourry-fedora-PF4VCD3F>

On Tue, Jun 30, 2026 at 11:46:46AM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 01:23:20PM +0100, Lorenzo Stoakes wrote:
> > Similar to what we did with mapping_interval_tree*(), let's declare
> > anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.
> >
> > In each case the rb tree referenced is &anon_vma->rb_root, so just pass
> > anon_vma and the functions can figure this out themselves.
> >
> > Additionally, rename 'node' to 'avc', 'index' to 'pgoff_start', and 'last'
> > to 'pgoff_last' to make clear what is being passed.
> >
>
> would it be possible to split the pure rename changes out from the
> changed function declarations?  It's hard to pick out this as something
> that needs to be looked at as more than just a %s/x/y/

Hmmm do I have to? :P I mean sure I can on a respin potentially, but it is a
pretty trivial change? Just mechnically as above.

>
> > +void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
> > +				   struct anon_vma *anon_vma)
> ...
> > -	__anon_vma_interval_tree_insert(node, root);
> > +	__anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
>
> an annoying request, sorry

:)) well it's ok I've made enough annoying requests of my own on review :)

>
> ~Gregory

Cheers, Lorenzo
