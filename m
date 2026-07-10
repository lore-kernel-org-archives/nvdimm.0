Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE363191BA;
	Fri, 10 Jul 2026 14:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783695073; cv=none; b=RMaVUAQHdBWKp8KL4IbEN6rl9kxd8jydu6p4ABIKgq0hn9j+aLW4FwhEkGJFSj2fin2hUTK8gdp6xeKuGmwgwwjFJ1R6cMVKT2PcoqsDicsf39y2HhYoKIcIjp+l0DAOkuPh1yJIS0yFVWxURvTPfbZoOBQpbUOkbDtH/MfOqEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783695073; c=relaxed/simple;
	bh=HVCHZJFQAGlkuskJ7SayMhosIqfStBiyOTKFtFT5fdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JdowGOYA6kcqCoWBOaON0YBx4rGBqhH6UgACOr9zrM43N9YtsQsTqBcgukxWI1OuPkZNj2rsL6I33CQG4qT8CxfgoxZv9bvsXmZ+p/VDk3HnNFlv+2182xYfwpFaEfKqNx9YqsYlwjJkidiqa9tySqhuNk7/6YuDFQaRVSoOk3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GV0G1PCd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GV0G1PCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13DE1F00A3A;
	Fri, 10 Jul 2026 14:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783695069;
	bh=/adl28F1RG11+xFCTzjhiMT3/quSA/55SrYHe5Xl+as=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GV0G1PCdVWL/17cPDVZfz86GmBO0VpAcpElRSgqzkFaZnFKsDK6rIw+lxzMvM7oyM
	 gOb7BmlLZV+r7XfvVToV0An5vS3DWoiRNZEtakP1kgKdd/pwAzK/AhJrUnpZlFH/ma
	 IDgVC6vlNuOfwFAEke1UlfCP3mMcmRNqv1rAQF1Ta5n8CDc7P/kP23VMlYUdFRkbMx
	 btXD63gJA5fhI4bndbOxrinkAQhHaNvBor7RN1UECzz5h5BotHDkxdGHR0ZdFn1Wle
	 sxRRlN3kLf8W7g8Lmmkim9s7ySe4W1NlivrC5VU8viOWzvoYYPKNt7/4lb6lTsMCz8
	 i1PWPp9WBYC/w==
Date: Fri, 10 Jul 2026 15:50:44 +0100
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
Subject: Re: [PATCH 13/30] mm/vma: refactor vmg_adjust_set_range() for clarity
Message-ID: <alEGqHY5GPhT30Ty@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <ada7972f49ea7f1ff1df6d11e4651f270444f8fd.1782735110.git.ljs@kernel.org>
 <ak-70CHGujkI5jJI@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak-70CHGujkI5jJI@gourry-fedora-PF4VCD3F>

On Thu, Jul 09, 2026 at 11:18:40AM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 01:23:24PM +0100, Lorenzo Stoakes wrote:
> > Add comments with ASCII diagrams to describe what we're doing, avoid
> > dubious use of PHYS_PFN(), and use vma_start_pgoff().
> >
> > The most complicated scenario represented here is vmg->__adjust_next_start
> > - when this is set, vmg->[start, end] actually indicate the range to be
> > retained, so take special care to describe this accurately.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Reviewed-by: Gregory Price <gourry@gourry.net>
>
> > +		/*
> > +		 * vmg->start    vmg->end
> > +		 * |             |
> > +		 * v    merge    v
> > +		 * <------------->
> > +		 *         delta
> > +		 *        <------>
> > +		 * |------|----------------|
> > +		 * | prev |    middle      |
> > +		 * |------|----------------|
> > +		 *        ^
> > +		 *        |
> > +		 *        middle->vm_start
> > +		 */
>
> Even with these diagrams, it's a bit difficult to understand what the
> actual intent/result of this chunk is (but that may be a limitation of
> me not spending enough time reading the surrounding code, not a comment
> of your work here).

Yeah I know, I do hope to refactor all this at some point to make it simpler,
but for the time being tried to make the confusing thing at least _slightly_
less confusing :)

>
> ~Gregory

Cheers, Lorenzo

>
> > +		/*
> > +		 *                Originally:
> > +		 *
> > +		 *            vmg->start   vmg->end
> > +		 *            |            |
> > +		 *            v    merge   v
> > +		 *            <------------>
> > +		 *            .            .
> > +		 * merge_existing_range() updates to:
> > +		 *            .            .
> > +		 * vmg->start vmg->end     .
> > +		 * |          |            .
> > +		 * v  retain  v            .
> > +		 * <---------->            .
> > +		 *             delta       .
> > +		 *            <----->      .
> > +		 * |----------------|------|
> > +		 * |    middle      | next |
> > +		 * |----------------|------|
> > +		 *                  ^
> > +		 *                  |
> > +		 *                  next->vm_start
> > +		 */
