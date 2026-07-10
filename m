Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E88175A7C;
	Fri, 10 Jul 2026 15:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783696573; cv=none; b=L/KpRLMB5pHoIYmAmJbS1der7CCB84HtD90PQjamatR9KE1LypltaZcLlEfM5ZLg112SGyetW5Zu0sooKlSvjBJ6/WHMJh1I6AT+XNZ42NOgGl9E4BDSOFqtfaZuvpuWxfA0dBmAuwfO8m4jaHCmSvXYDuHQGqlPCcqBnD+vHCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783696573; c=relaxed/simple;
	bh=UikHL7SaRQhcW9jgP94Aas0kJna+z1e/sa7fJz0VgVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SrxYFwK1wtCaWBjMGxzygordwysV8cGmLIYRZKDkZt/7TSGNKaqtW0xZHoPKK7uAbfQ0NibUAt0tanjVONK6fsAqViyyYCneqhCRuer/XsfyBKyg4dDTx7xtIGVRTNLS622F1pdD+xT0AuIm7MgRf6RisHKK6kO0ahFGz/Ld/QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DHGTVQQh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DHGTVQQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39A61F000E9;
	Fri, 10 Jul 2026 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783696570;
	bh=4r0Cc9l2aAmZyRZIk2/aSrghpeZfvwxavhupSZVEeMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DHGTVQQhWaTrPzJXRhL+eOlPh3mjgM3TYm3BACmuvjIRndZXufi/DOhVvVPUUmShz
	 pMaTajqPd2DgQBSgWuLiUyl1vIFajO3tcup29tN2rA+oZElUGBQ1IGgnnzXislM27I
	 7CvnkGOpI5896VQOz3W8Gmxeu3uzmNGoxn7r0l7pBdQ0sONYuYGXeAzxoC3tQ9/wUH
	 UEFxz/qEn3hiXt8kPfwHLqlEerVkyRZiznIxE9j6rS+w6Jb2/IyIAdhgUn87BZzWbP
	 pGVPtXCokUhc0BUp8Nl0bg7ctkDVndBAE1whxwQffv6MbiL/O4PIdb6JwCyyrjCy4K
	 eJhH8u+Rek3lQ==
Date: Fri, 10 Jul 2026 16:15:46 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@armlinux.org.uk>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
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
Subject: Re: [PATCH 17/30] mm: prefer vma_[start,end]_pgoff() to
 vma->vm_pgoff in kernel/
Message-ID: <alEMciQmyQA7wdua@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <ea87349d63205bf4c26ea79854f179a9bf8cfb0b.1782735110.git.ljs@kernel.org>
 <akZCg73F-oGzDp1a@pedro-suse.lan>
 <akZGqclqQ6gS12Vv@lucifer>
 <ak_C_o2ehS17Q5HV@gourry-fedora-PF4VCD3F>
 <alEHy1raICek7imv@lucifer>
 <alELDgm258nhjk3b@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alELDgm258nhjk3b@gourry-fedora-PF4VCD3F>

On Fri, Jul 10, 2026 at 11:09:02AM -0400, Gregory Price wrote:
> On Fri, Jul 10, 2026 at 03:56:33PM +0100, Lorenzo Stoakes wrote:
> > On Thu, Jul 09, 2026 at 11:49:18AM -0400, Gregory Price wrote:
> > >
> > > Silly question:
> >
> > There's no such thing :)
> >
>
> All my questions are silly.  That's my secret :]

Mine too ;)

>
> > >
> > >    What's the purpose of retaining tags in a non-address value?
> >
> > Well if you want to reconstitute an address from it later then that'd be the
> > intent, but I'm being hand wavey here for sure.
> >
> > Main thing is to retain stuff under the page mask
> >
>
> Right, which ...
>
> vvvvvv
> > > That sounds like there's fragility just waiting to be broken.
>
> If that's an actual issue, then our relationship with tags is painful :[

Yeah, I'm just not sure tbh.

But all that is stuf for future masochism^Wfun anyway ;) focusing on the 'respin
the monster series' fun^Wmasochism atm...

>
> ~Gregory

Cheers, Lorenzo
