Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6B62DF156
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783696154; cv=none; b=qvdBlWb8YUf7nTQgyC+1D6JXctLd3O8VkCu4zPUs8/2wGP1XgTeaK87vax+N94n5Q5XVP0jP7iW4d9hpCzPGiVWcTjtKBwoOPKlhdkIvSBnju/jTwSjZq5xEoIDhc6vCXIgieYT/DdgCceC4clv7abrCeRKu/kKpAmUXB96gg0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783696154; c=relaxed/simple;
	bh=EYnEp1we9gIclXQGcrALFhmvzaRn2auF8TgNETsfUuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jUCUyC1tIaiQbuB2MLef5FCGJ/K5iG54+1PSVQpnADDz8jFI39YBtIt0dv0+gqfGH8eGYOn30DdyT7cd9/z7tX8HIgk96enzbgzVBY/ZGy3XkOkHDFOHHl5TfxaRg2/hDHXcc8ncxXSPrPnCQiyTe0Of0jMZsP8td/7ggWFmPeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=thZS8Iq0; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="thZS8Iq0"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92eafc94c9cso52077785a.0
        for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 08:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783696148; x=1784300948; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kfeOD7p/qxHHEIV6dN3ojdA17bZ6I64Gd2Z+QpoWxkg=;
        b=thZS8Iq0ZM6bXuETDaYwbr+PD3Szx1Q3YjpYVZpbHeyWd1ARxDttcmUQrYMRMmMhIl
         Pcffhzei/HLjAUQfnh+/r1K2W0gn9EYz7TX+Jl7MYjaI4vIB1B5BazuJwuQelqjFcWly
         NO54Titj77dmgXJhv5isxyJPITqQHUlx+Y6LoygWV/wu1OCWLinNpgiTtmifVwr/ds6+
         2W29kiDDhHj0sl1PvC+0NWAWkeWxejnFpzBSVE7TXQovXKWAdo6HRmG91MsBbcGQCxO/
         mCLi5rgjicL5gnK1Ith4zBkxZiduq0Hx2arO7yY9qXBnaiYE96MqTRMakPTEXl1lFEo9
         0ecg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783696148; x=1784300948;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kfeOD7p/qxHHEIV6dN3ojdA17bZ6I64Gd2Z+QpoWxkg=;
        b=E1smSj1jUyljTN1nR70buaU0Jit2JK9I3QagsrAWNPCSBRmKcmdsskmIVmkF5ap908
         pcRLQoyzjgd87K71KrKNySlJEDfUP31sEm0u7BNmM+ByuJ56d8/oFEidqDuEkW/tc590
         TdRnYv2rx7CAfzEZuqdJZV/mTBufwkKiYUcZuYL5Ur5lDod+7lcLPPEY0HsgXdFEAbkd
         R1LnBSf15YMJ1b5SdnrH8/dMyCXUFq+2rWGLCWCdjMaccVZq2uVUsAYVOCju+hH6k9hz
         5fQuyst6Vx25j+u5Bg4CDaByHyctoMKTE2Zo0QyFqj+v9YXyD2dbWnGcVULUK5VSOs2h
         MF2g==
X-Forwarded-Encrypted: i=1; AHgh+Rp8FKe9IujMKBE7h2JSznIBJad56Fh9PeXe0xac/JuOuci8ytLifNJfA+D9vkkQjmPVVmsndCI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyOF5Q5ovEcn4xmXk3h9FNZKZ1ypDjR3piO1e6FYS2f5zQ8Tkiu
	evu1c7yfMqFbH8tTwFAmbNTRaG4wVr6y7tiNgCQgnDY9pe12uqMwTWKNzNqATAxJglQ=
X-Gm-Gg: AfdE7clj48m3e07U1Uo37ewUONsvRhTn8BKd6c+OQ05lZRFbrQEVK2bdr0FeHEeFH4G
	z57tHIgth+E7zwlDVtgd2N0bAwJnrhaPQTixMa9h5hm4cxiV4SyB9OGAfuVwA9TTsiG+RfDq8Bh
	wOoRoq9kp+VzRBNDhAgCHjX6S+ID0sbg20pt0Cc1DcbpHyKLvJhNsmAO0llhbZG+2Wp0Td1aZFZ
	Nigq87G+bWqQD/OXCg4ivD6s4FG/YGqP4SB8EZD4kQqf5/HoUnVP5QRPwuPpp9SukBX1hY+o0qV
	DYK5JSllpLldNyAQIoKtF6FfPCqma1lvVR1hYaeLVWiGe5ZuNy7ZvnJE6u4oP5GrOVE3ADqUqRa
	vN1gBZBRXtns0NQaZ3m0wzMfNaBwddq2TyqSWcyU1dGSW6V/VBLhXpkqVQfoAXT5wthdbOrJDe+
	iL4jUmlY0eh7XDh9+ALCwSU/3EhKzFcbfikeJFW9Xs1AnY0/iDfZWoUw7LcOu88+DIAVOl
X-Received: by 2002:a05:620a:4414:b0:92e:7d53:8e8d with SMTP id af79cd13be357-92ecf55964cmr1359477885a.27.1783696148308;
        Fri, 10 Jul 2026 08:09:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d34f76sm213283985a.35.2026.07.10.08.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 08:09:07 -0700 (PDT)
Date: Fri, 10 Jul 2026 11:09:02 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 17/30] mm: prefer vma_[start,end]_pgoff() to
 vma->vm_pgoff in kernel/
Message-ID: <alELDgm258nhjk3b@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <ea87349d63205bf4c26ea79854f179a9bf8cfb0b.1782735110.git.ljs@kernel.org>
 <akZCg73F-oGzDp1a@pedro-suse.lan>
 <akZGqclqQ6gS12Vv@lucifer>
 <ak_C_o2ehS17Q5HV@gourry-fedora-PF4VCD3F>
 <alEHy1raICek7imv@lucifer>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alEHy1raICek7imv@lucifer>

On Fri, Jul 10, 2026 at 03:56:33PM +0100, Lorenzo Stoakes wrote:
> On Thu, Jul 09, 2026 at 11:49:18AM -0400, Gregory Price wrote:
> >
> > Silly question:
> 
> There's no such thing :)
>

All my questions are silly.  That's my secret :]

> >
> >    What's the purpose of retaining tags in a non-address value?
> 
> Well if you want to reconstitute an address from it later then that'd be the
> intent, but I'm being hand wavey here for sure.
> 
> Main thing is to retain stuff under the page mask
> 

Right, which ... 

vvvvvv
> > That sounds like there's fragility just waiting to be broken.

If that's an actual issue, then our relationship with tags is painful :[

~Gregory
