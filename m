Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13820426D38
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 15:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783612170; cv=none; b=CyQb8vRsoSDGFcrFQfqqWdctKBpkzj1bz5Cv/hXUGDvKK8CDA2aPjIgkTxT9I8lx7wzc4320yiP8XP/7dsd6RdBzzgAOX6QpN7wXngGoQJ4zqpfpRH7ZoVjuY2Sy3LyxvbKBkhRZasmW0cFIZEjBmYIi5U9rNA+5jLBYbgEL5xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783612170; c=relaxed/simple;
	bh=0qkqAHRaBHgpB2UR0C6dAMPOVUmsbtzeoEt8MNK67Xo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L8O4X58qGY+DfByCyRaE5Rcxh4PRhJBHPGQxLpHJieXs77N97rak6vywoRxUfg0MCwhfdSAfN1rsSLj4TJuRlOAjgM5SdF6lXjZs6of1fJ8mvIJMRA0PqmLEjsaZMo4I0Eyr25OxTysGCdZ6emO9NjgTSWDSDqakk48V8yyeAU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=oveLNVue; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="oveLNVue"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8f1a8e914a9so450496d6.1
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 08:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783612166; x=1784216966; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hryUWYzOZzjuIh9gJx+Hzg+n+E360+tJZh4R7BZGeLA=;
        b=oveLNVueRXAHGTcDlgTdy/qQx6ZDIATnCjLysooGepeIuANXx4S67ODZhApIiQ/Ltk
         AOKKc/2D6AvLle/QhzDpnlLXUsIIYgzna6xADdJaTmJG0Eq7mev95YVDPDvcDCQ2fdhQ
         rvqdHn21ZTh+D8jQwiCFynMe9TqWR6R5xTJXLgo139SO/MwqvMLAXpBm3jkhhNP2DiV3
         OgZLVstH5zjW+Lm3C06FY1FJ95mE6Zet8bzG3z1DkAe2El3igN+mUbJs8nUJMmZwlwzB
         L1NU3ypzQzcp4zz3LOuA0SCZb8DSPxsSJqg8EEhUaeE6SthM52AX1VX6T2TVRdkWy9Yo
         giSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783612166; x=1784216966;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hryUWYzOZzjuIh9gJx+Hzg+n+E360+tJZh4R7BZGeLA=;
        b=iytgJbdItPU/IWrwftjKAwviyitqdORleUb6RgenMyTYPHHLql5bXwQ0AHgLd34jeO
         kiLiFV8ftzedPVkHQVocON7e2/lCY5i/PexkPfqK/qPmaiHXckbeG3jiqB5I56mj3TqJ
         nZC10nGO1WSiAzp4X8qN0CfRJUUSCviRIFwEtj+U8nI+N9/mqnKcR3w97J7MfbSl5hZs
         9AS73L0K/TpQmSxt0U7UP0+4ZODk27GrLtR+s4K5gsOjKCdlBqyoLq7smIt3Uy41/c4i
         qXwpXq0tg8QfhxGjRBCO7ADL/sHs9xjdGD2+InM2M2WszSRxk45trHYKwlVy9lodGExA
         wvew==
X-Forwarded-Encrypted: i=1; AHgh+RrI5ndfViTSFrhq7gEH1B0x6frCyo6OxzxmrU1/XV/l6QIQyXaIFacHXqTfFaFP3IOxaoX4Zls=@lists.linux.dev
X-Gm-Message-State: AOJu0YwzKgcOh2uz+DWLRz1fS+SjHxnukxKSSc8t7I/ixGy/WqsiaNvF
	9e4pt68t7/pmSyxxy4Tk8nC0wnpBVUBA0Ls440K0WvSUtVekjNEpYhZMVkBXRtEIA20=
X-Gm-Gg: AfdE7cmer6ANvsNSElghD+5uJfHrQUj7VTOoP2Mqy5DXjHgtLvhBaI/rsFbq0KQ9gJ/
	6a++H/X+R02E96Mf8RchUEejIA8KOpb3mEzCjtnry+cvUvUZpEV9zLJrPh/+9HfPFAlQCyKmOSK
	8yqcDCmECX3m7zOpiQjzI+IpzOKOzKDCF7JeFKD6f8R3uasclU9UABBwC1mP43EpN8QDtpp9Ps6
	qjG6kePqX4BtpS1nDmLZUwJUcxnfdbAK4OmPi3qBX2uy5YcvuWQCHK+/I17b/+8Sc0CUFi3P0ZS
	jprp2eNTp8Je3OERjQi2PoWwwrYyR8Ty1/zZ27Ki52Yx76wYMRXjDwRXjTMR57THpw5tcoYuAAE
	Kircy1B8c1GatiNRSApd3dkREuyy1laJMuO+HCL10jIqBmIk8JTJzbw4uyjA+0XEI/uOkGz6YhG
	gaoYCVvxFopUk6DevcscALreH2srO4LtJzqbi7in3OffQKplK8yRB5xHUPfvofU4nIqEy/
X-Received: by 2002:ad4:5c8a:0:b0:8cc:2a92:48e4 with SMTP id 6a1803df08f44-8fec217b8bfmr87997286d6.32.1783612165998;
        Thu, 09 Jul 2026 08:49:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd7c1d9f6sm20164456d6.23.2026.07.09.08.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:49:24 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:49:18 -0400
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
Message-ID: <ak_C_o2ehS17Q5HV@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <ea87349d63205bf4c26ea79854f179a9bf8cfb0b.1782735110.git.ljs@kernel.org>
 <akZCg73F-oGzDp1a@pedro-suse.lan>
 <akZGqclqQ6gS12Vv@lucifer>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZGqclqQ6gS12Vv@lucifer>

On Thu, Jul 02, 2026 at 12:30:59PM +0100, Lorenzo Stoakes wrote:
> 
...
> static inline unsigned long vma_offset(const struct vm_area_struct *vma,
> 				       const unsigned long address)
> {
> 	/* Retains page offset and tags. */
> 	return address - vma->vm_start;
> }
> 
...
> And I'm not sure it's really all that useful. Perhaps retaining vma_offset()
> would be though.
> 

Silly question:

   What's the purpose of retaining tags in a non-address value?

That sounds like there's fragility just waiting to be broken.

(I presume you are talking about things like ARM MTE and such, right?)

> This is one that I think makes more sense.
> 
> But in general, I'd rather hold off from yet more churn here.
> 
> I'm making these changes to establish a basis for virtual page offsets
> introduced in [0], rather than just cleaning up in general.
> 

I agree with this.  If the refactors here suddenly have to think about
corner cases on things like tags, that's better resolved separately.

~Gregory
