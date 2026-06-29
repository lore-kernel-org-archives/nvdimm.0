Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7049C283C93;
	Mon, 29 Jun 2026 17:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782754874; cv=none; b=QSWJd0o1lNkifAqvxo6AZM4s4FkTXEmkNs/OWRTKQ31KIuPYEUM4kUmE+0WB3ncm9rz8FTRgXw7haoXdjckk802ak6DOyHF4Z7Nl0tsCDTFPS1AVKHVnFYmcnWI7O8Hv1c9WrSVgMxfARakGuDULi/Vgh5iJyYKDcjs1cisNoA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782754874; c=relaxed/simple;
	bh=7ogGndBpHueGVWrVa5AFFYzim8+s377QhCGSJtKEE4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqNgkNH63iYbJl//aXWeZhI4qbF9JTi6yeWgRgPboabelH82so8iCclbwZfwjPzGSuGkyeRA+NdwIlyrMD7UjAeOPBPv6zmS2MRo0U73Q15M7hzH4vT9ZPSeJzP79ECU8mqd9TxsMnP0qUNcvnG0VpQ4hVr0pONI0T2cIsRqq1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JwaoyB6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JwaoyB6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA521F000E9;
	Mon, 29 Jun 2026 17:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782754873;
	bh=aQOiijNvdTgOg0ZDAoyrNzD33sjFLDelNYagWZ6KgVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JwaoyB6lWKH7ik47HITJbeTKRuRVfEO/0pfh+FINdeuw0SW8eTRpmytBGps7cxq+S
	 kCNxhF/4sUF9JTuYBPt+gxEficptfxjI4Ts803QKT6eKGg4SzB2GwWxKUWqlCQn0l9
	 8f9cXn9tIT+sPqdX3U0y0w9x3G09VMFKEVU1DGcxCD4GVjIrlUxjbdU0zRQEz8q7QC
	 mcugOs41Y7eE/Nj43NtJtSgVb0EqBim8qmc/DbOOo6P9Tky+uXOtwwn26EwNHq3UCN
	 XCWemy+r6UszZnRM3oT+U8VC1D0qCApuNOrmYwKXCeFmYfWusMxcdVWgEhsuAemzi7
	 qVl/nL+loLawQ==
Date: Mon, 29 Jun 2026 18:40:51 +0100
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
Message-ID: <akKt5S96pJZGzeER@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <80d482a927b2e9862487b812e0ab48ebc1289a70.1782735110.git.ljs@kernel.org>
 <akKWvnU2Ua-8ceSb@gourry-fedora-PF4VCD3F>
 <akKfAl-wdIAbexNR@lucifer>
 <akKnNy64lhNqPtLL@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akKnNy64lhNqPtLL@gourry-fedora-PF4VCD3F>

On Mon, Jun 29, 2026 at 01:11:19PM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 05:41:16PM +0100, Lorenzo Stoakes wrote:
> > On Mon, Jun 29, 2026 at 12:01:02PM -0400, Gregory Price wrote:
> > > On Mon, Jun 29, 2026 at 01:23:16PM +0100, Lorenzo Stoakes wrote:
> > > > Update the file comment to clarify that both file-backed and anonymous
> > > > interval trees are provided, referencing the relevant data types for
> > > > clarity.
> > > >
> > >
> > > Isn't this self-evident by nature of the function definitions?
> > > (one takes a vm_area_struct, the other takes an anon_vma_chain)
> >
> > Well you see you're already hitting up on issues there, they both take an
> > rb_root_cached and the vma_*() ones do not instantly scream 'file-backed' do
> > they? As VMAs are obviously used for buth anon and file-backed...
> >
> > But later patches fix this stuff :)
> >
> > And I feel it's hard visually to see where one set of definitions end and
> > another begins, which was really the motive for this, as trivial as it is!
> >
>
> Fair enough, I scanned the rest initially but trying to wrap my head
> around everything as i go through one by one.  Generally this really
> screams "fix the apis" not "comment the bad ones" - but i suppose that's
> the whole point here.

Yeah intent is to eventually completely remove the anon stuff from here at least
:)

And Pedro I think is looking at the file rmap so we'll get there :)

>
> It's definitely an improvement either way.
>
> Reviewed-by: Gregory Price <gourry@gourry.net>
>
> ~Gregory

Cheers, Lorenzo
