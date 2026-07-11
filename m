Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B301BEEC0;
	Sat, 11 Jul 2026 06:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783750929; cv=none; b=DtNKPFWpqxCdYqmVqMfK6OLWlrqUcjlI8O+4aqEyt7K1EvIdqgICLw5WcPrkO5uNxMpogGmxEALRC7aXKVYuMcv9/t2+zM3yS/2DfJxxjwPQzb8BWKRitoIAg+qowIfZ24VfX8PEb86/eLwad1xGXddJY8qSXv1yoRbkNB3dbco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783750929; c=relaxed/simple;
	bh=WbIgITf+aHGNMFdZM2hnYV5tmAqGANAREaGRZ4MOOuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iZP3YoTGP7NrVFDSlaGYgCGFgprRK90nxnmdfmiANs3wTe0zh4nDZ3igLEn7sbhIdPnT2PM7j/eFb3x2iswzCzso6ta+gjVBxkh2SBQhXbPxFwvbnqhnSTzmXTdeBentzKPmyFAleJmvfHDKxeMi5lLgrf58i+Yr9l5gOQdOfXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=coo0niBU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="coo0niBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88FC1F00A3A;
	Sat, 11 Jul 2026 06:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783750928;
	bh=WbIgITf+aHGNMFdZM2hnYV5tmAqGANAREaGRZ4MOOuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=coo0niBUkp/gUkbRSatT5EJ6NfiQ7ezfzQNFFEka9gd//4UjxtBzc7RBi4OLd8CJp
	 zhITxjhwTqPhMy21VbSNO5jlWP62czybhR05pJZTJTb3iv0IdJ+TlpfkpIyIm/4CeK
	 +n6PGnXcW/v4qnadjp5ztDaRzxkkltVfID9+KdWba4BSS6I4vpCR+8z1NGu7pVTOYK
	 3SWYJRt3520w13mZ0szu/3x63YnNWVCUI7AtJTClfOv5gpw/pdE0wkv/FwletvuCgz
	 VSb31m3ojblPokIyzlMhDyaw755+CWsZBp7wZoYS2xjQCz/QLSkvrDwTE0v7OEpi+A
	 fef8MnSSiqRUg==
Date: Sat, 11 Jul 2026 07:21:43 +0100
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
Subject: Re: [PATCH 27/30] mm/vma: correct incorrect vma.h inclusion
Message-ID: <alHgvYH3F9FkObri@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <22d0f4e3fe11f6fd1312734e242d008267ad142c.1782735110.git.ljs@kernel.org>
 <alFHR3fg8K1-SITK@gourry-fedora-PF4VCD3F>
 <alFJUfaGHVnKd-Nb@lucifer>
 <alFePgFUR52GgBS7@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alFePgFUR52GgBS7@gourry-fedora-PF4VCD3F>

On Fri, Jul 10, 2026 at 05:03:58PM -0400, Gregory Price wrote:
> On Fri, Jul 10, 2026 at 08:35:43PM +0100, Lorenzo Stoakes wrote:
> > >
> > > Do you actually need 3 copies of this comment or just one copy in
> > > vma_internal.h?
> >
> > I'd rather have it at a glance, it's a bit silly but C headers are silly :P
> >
> > BTW you're kinda racing against time here as I'm on the verge of sending v2
> > :P
>
> :[ i don't refresh my inbox when i get hyperfocused and now i am sad

Oh no! But that hyperfocus sounds familiar ;)

Apologies for that, I did hold off some hours. But you can at least see that I
did all you asked in v1 :)

Cheers, Lorenzo
