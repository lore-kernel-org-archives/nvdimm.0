Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0163335CB6B;
	Mon, 29 Jun 2026 16:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782750940; cv=none; b=B3ICgxWPehMgt0TUtVZqHH4Ua3NOBeyH0ORu9TWWKKSyX+xtMLuv0TdI4AJbS20hXsOLeWbQ8J56zc/q72Wv5dlcDZ4HQnM7eDfQTN5s/SonDICpTUHiNdUcbsSznLKfVNoQ7N8R/u0TiwEm+UCXokmhCZvJAOpzMGfylBYmtT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782750940; c=relaxed/simple;
	bh=tqvibWEtQh2T48OiewXhNx0S0zqLKa3gex5DVvzFGOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XxUgGjIv/sBzujxBoeW+rrSISZ7AEhGYuwOxSeryej9d3HehzOy172UMpuK3T4nR81r05uGy++y68m7t+qlT8GG6U2FXGoARBdQNzQkLwF4zRdstrh+i6hk2CMxI6jfUFGccU7gt4ZYdJH0om+vFYl7ZeqUh196HsHL2PYBvp/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PfDXIPAD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PfDXIPAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5B21F000E9;
	Mon, 29 Jun 2026 16:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782750938;
	bh=tqvibWEtQh2T48OiewXhNx0S0zqLKa3gex5DVvzFGOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PfDXIPADcSrUOwdTRGhDf130tTlUjzfb55asHDeokcwn4q2fFY7uD5zpTbQijKU2j
	 A3h6LyrgBRhD8vjv/PCOQbIS0x10wNp15U53uZUeJSa+ZUUtNYjmvMkaFTX0FdsPtY
	 5VFsbeAwARiOlYL96AR5bc/UJx13BAZgTchhOZXOoq884yT683+Ba+UY0kenSbPQ5G
	 /9Y3STPVYFUZGbaD/nfway1UOiEmxiypL1sfzIHXjp28wqpXFD1BkVYOwnVTwzjxBO
	 T6iDd2rL+GJ7Oq4z7lXn+Gf9jPYSMojIl9QVfBm4ugrQ3F58b1YoFt3gxDwWn1rh48
	 BJyQRg2g8eDBw==
Date: Mon, 29 Jun 2026 17:35:16 +0100
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
Subject: Re: [PATCH 03/30] tools/testing/vma: use vma_start_pgoff() in merge
 tests
Message-ID: <akKeKSnWlc416OIP@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <b501eca378b9d9734e83838102aadc9276590fba.1782735110.git.ljs@kernel.org>
 <akKR3bFV7393yOUs@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akKR3bFV7393yOUs@gourry-fedora-PF4VCD3F>

On Mon, Jun 29, 2026 at 11:40:13AM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 01:23:14PM +0100, Lorenzo Stoakes wrote:
> > Now we have the vma_start_pgoff() helper, update the merge tests to make
> > use of it for consistency.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Question: Should we have primitive tests for vma_*_pgoff() since
> the behavior changes depending on file/anon?
>
> Nice to have the cleanup and clarity. Maybe worth asserting no
> one ever breaks this.

Well funny you should mention that :) I do add some asserts as I go.

In my RFC series which this series is the predicate for, I add more as then
we track virtal page off separately (see [0]).

Amusingly (or not) /dev/zero breaks assumptions a bit (anonymous VMA with
vma->vm_file that tracks by file index, just glroious). But I plan to fix
that later!

>
> for this patch though
>
> Reviewed-by: Gregory Price <gourry@gourry.net>

Thanks!

Cheers, Lorenzo

[0]:https://lore.kernel.org/linux-mm/cover.1782745153.git.ljs@kernel.org/
