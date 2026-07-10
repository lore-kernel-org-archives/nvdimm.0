Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48C13803F7
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 18:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783709850; cv=none; b=Y1muW3c/Fe3PDCuUgRrqoqYuN/19cHb4SFcHGAlSCOYNTDQlTOLOA7Ci6aKAWq8RRWW6KPgSuCt3PQZTyDP0aPGX+G6I+2WZyeArZ8p6YHwW2fg7yyHhSFq3B25r+5md7/xWEusdKGNlKoh80VHbOqzAWiB9dWzGZweS4/dH4pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783709850; c=relaxed/simple;
	bh=mfAQ6U6Pagde6/OTMZV/3pa3xVR9imBJSf9e6QtJA6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i/HIL/rR0bxjGukZNyno6JbVL2XWR/voxRT7Pc/wKCFuYxFLI4GwRSRUA65vKEpkxcGhHoPCVrL5i/SUH35UPKzS4ttAkgkrHBw0Ta2GN1j/2GyGebjSOpGjNCanmwqgZ724VmmLVsWdR/TlwettHaSUKNS55h3HimR/5rX48b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=f01Mp37R; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="f01Mp37R"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e99ef0902so67512185a.2
        for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 11:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783709847; x=1784314647; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kUriDsQ9XZtRyYKZZfoXUueFFJuZPgSg6lCZHNic6sM=;
        b=f01Mp37Rvqx+Y5DQaHEiRaHGaE3CXSciZUFtTOLy89uy2S9wF3zm/kJ/11ZiwtJ/Qt
         /V933YFidtQTmYGlyIo0x+hFsGW+uTYvyaIvsY8apT1lv+CIPNi/i65kcqC+PFL11a4R
         bMJRJIpHsXnPZOQy8OFkDYdHGAzErqakPqsdD8amfm0+a0auRH594/3VMKjoah5JgCfk
         eX+3njX0/Gt+GuN0+COYdzLkBohoNFResqTw50DPEnVDWrUl7NIgmhm0MRMePO4x4yNY
         yxbBxjGtDu3CSAvQp/7eqd8QTfleGdV9EQg9by2+lhFCoYCTrVUt69REpm83AL2PP7au
         HG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783709847; x=1784314647;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kUriDsQ9XZtRyYKZZfoXUueFFJuZPgSg6lCZHNic6sM=;
        b=Py2ZE1AE0cRq/7FGtg64pqFBCrQUmra/Qbh26PV5YsfSj12dyWW3KC6ZpyvvmYbb8s
         RB3jjwLWlr2AfDFgNlUA8eW/1MNgxeXekuFsYTMLTtSxdHhtwKdg9ZRWntCcIWHAoTRe
         u4cVyGkTheJ13fPoWjRbgEfiYZDzqWPZD0y7PMfh80dRMGZqdIpPSdS9LJSg3Htumw3T
         n3yeql+KYCy0JaOJt+x0DPSlZcZMTrdJDVZiGRNAsc41Xo9gsOXdlS3QHXL1StZrGYMw
         /NBWaDSzkFQGzua/ADRwHAyogSpUd0SA+mSinTQQdM/pgLRxJOy0ObAdR+xeja0acllY
         ESOg==
X-Forwarded-Encrypted: i=1; AHgh+RrXps9yR+RZXebUI1fkhafeyjEfFwQI2EKKeZPUMcqdemERGFK35rUi3T/EPnKgw7aEQkyZ4yA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwM3TR6s2rsGROIaeGgoTvlsX1HGoIts5LrmyrNN5FPWs8KSF5J
	SHMTzw2lqNSg+Muk/G0TJKGKFWsyXexA7WIG8yPLGNn3h2euysJy1GrJVK8l4XwxnUI=
X-Gm-Gg: AfdE7cnFzWO+x1YAAXxhKW30QcyK/HU14mMG0g0lJTUA0+kx8JiPW2g7rsAa4HjwrAH
	/lfpRg+RVtMFaeya7jvbgJ4wpbmxRtk5U4GHCf0QdxdUOgpxfx7GTwLNCpKos8x1oRIBmHJpp+2
	7CVhC4BeLmlCjZU1BqvwAi6ZbqAcFCEKtXvkIeLITGePTOyZNwS7HCWrCgXd7NYZVfaHyGud0VH
	VCO7PeHn8lh3lTkuY38sGG/VKh/P3cV//oCcTPS3ECdXU/kJqLDhhdeBGgLlhQgA9EtpJGoxVjt
	QPqzSkOM6Mdm3zzWPADAzqujGMWbklOBwy2E9d4N9YPqMaP024L9SUmKecD1t1qng+KmxsX3C2z
	93vD/8ykUy9P0oZJ1xwVUlb78dnhVg+z/YjDuunMTVB8fh2dWwsA1JvLDouR7yNLOPiaYD+Q8er
	826oiBgsB474qLBmzcLDeg+Do/nNJE6fwIgKLhlsR1vQnpxf3NxPCKoEF0zsyX8tOQvej7
X-Received: by 2002:a05:620a:d8e:b0:92e:9d63:a6f2 with SMTP id af79cd13be357-92ef2c1ab7bmr45629785a.70.1783709846741;
        Fri, 10 Jul 2026 11:57:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5cfdf6fsm275995385a.24.2026.07.10.11.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 11:57:26 -0700 (PDT)
Date: Fri, 10 Jul 2026 14:57:21 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 23/30] mm/vma: make vma_set_range() static, drop
 insert_vm_struct() decl
Message-ID: <alFAkWCnkYv--Us0@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <62efd70f9f39570724c9552cc7f2aeb5c322b2ff.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62efd70f9f39570724c9552cc7f2aeb5c322b2ff.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:34PM +0100, Lorenzo Stoakes wrote:
> With __install_special_mapping() moved to vma.c, vma_set_range() can be
> made into a static function there and is now completely isolated from the
> rest of mm.
> 
> While we're here, we can also remove the insert_vm_struct() declaration
> from mm.h - the function is implemented in vma.c and already declared in
> vma.h, and has no users outside of mm.
> 
> Also update the VMA userland tests to reflect this change.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  5 files changed, 8 insertions(+), 24 deletions(-)

Net negative lines of code, the best kind of commit

Reviewed-by: Gregory Price <gourry@gourry.net>
