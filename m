Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82125305667;
	Fri, 10 Jul 2026 15:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783696466; cv=none; b=jN2qmXJuXMBQ+eVT62l3eQlSccqWG6a5yZchLGD+ag1k5PJ6Eh93MC2AKQod6Vb6ZgTJoKHL4l/QG2+EaxUCrs70yhyXwwu30MUjxM+SES5AFh4/oHWawGBCyqYxQ1mof8KAw6C7LHh/dveMWt9QqbUfeGUcFtw/zd/FSXmakTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783696466; c=relaxed/simple;
	bh=X27acRwAdtTXFKPxbIFmrw/jC4hzH+Hp8I2QhCUZeG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LnJ6uDwvub6MMbjAqecRdQVKhUViUrJk9p/vP63PEfIBn84zFWuPJZaClTL2vJBn91A290WTRBXYp7XZ+Ao79geooZ9FlKSOvTJGPgkjsba0jZsZ17pX8hdkdgkQjCPXFjxG6eOS7L659bb2DFt9cc5zFlZa9sdlLYYGqwl+9X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWp/YfV2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWp/YfV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E901F000E9;
	Fri, 10 Jul 2026 15:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783696463;
	bh=X27acRwAdtTXFKPxbIFmrw/jC4hzH+Hp8I2QhCUZeG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jWp/YfV269fwuE/A0DGNv+QkUPkoVUKqSC58r/6dTFMtbAarFJcpkg7eJhEKhOYap
	 t81kzQLW6NrlPB0JMDr7H0UXeyHExQPBmSYxigZJrnSRSbLkruaye9f9wkhzjtq2xU
	 G4lKaQN//gFPfHyUlzpqN6PdzS6B5IpaPmAha+7G6eBCcjyEbo6mnkOdPR5gmcV1zp
	 SeT40ZJE+ZN7mwKT361/xbZwxgR0fnlC/lIRtIa+Nt3raxrbwrfQCAlTLH4fQ6A25x
	 ZE0HtZx8YJmgD3kt1TllDvu1WflSd0c7RpQgtW35wc26F3JTWTwOwmft6JhkOtvQZG
	 Bg78M+rxmr0Tg==
Date: Fri, 10 Jul 2026 16:14:00 +0100
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
Subject: Re: [PATCH 28/30] mm/vma: use guard clauses in
 can_vma_merge_[before, after]()
Message-ID: <alEMKRdOLNiNYIGm@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <213918ef85ed427d29d0635db6b07b15280d3bb0.1782735110.git.ljs@kernel.org>
 <akZOPG6fxr98Ycl_@pedro-suse.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZOPG6fxr98Ycl_@pedro-suse.lan>

On Thu, Jul 02, 2026 at 12:41:51PM +0100, Pedro Falcato wrote:
> Looks nicer, thanks.

Thanks!

>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Also thanks! :)

>
> --
> Pedro

Cheers, Lorenzo
