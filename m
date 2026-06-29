Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685AE3E9C06
	for <nvdimm@lists.linux.dev>; Mon, 29 Jun 2026 15:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782747080; cv=none; b=bPgk/4H+/C55EmTqxCYmpT+Kt7qZCWgDH0xr7XfWS7r2fBHKA76STgOC3dVPDe0aImyJRMmO2z0inBRz1+6o2ZiLo8wT+dxY1jgovwE/H1f1HqBklwjEHP64VXU3CqJiJOJ70NpPAONTUZ0Sa2YuEh7ld9Z3y32dO68WUnIiYeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782747080; c=relaxed/simple;
	bh=eSLebA2K6K0JqwA20gSpIaLBxceDZU1DyvE+HEyhHoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dmSr0KxdSJiC4qLf8uFC4EAf3vEa+eD+iDa4oxCkILUrXKvRWLCGnaTDzhcQqzN8IlVXtpg0WLFnl7vj1YiImUvm0xWBpf+FDWoLHNZ6WJWXqDCw4C8L+nKm7mVEAO8Vwnq7Q3BR9foPfSSw2oVyF7PTdPxfiTZg0eC0bqsA/lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=ixk/6iiM; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="ixk/6iiM"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-69de16f5f79so1731161eaf.0
        for <nvdimm@lists.linux.dev>; Mon, 29 Jun 2026 08:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782747077; x=1783351877; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TtnRVAeDbe2jCD/DHkmGFKsvQqrt7nLFRBhYCay7qN4=;
        b=ixk/6iiMBqEtYZ1TFLxzipN2MI1SDz5m+sdkHlRgPpGJSNl/NKtFPtNjRJUFWOy9vE
         3Emx16WDSvd+Eqe9/xGpPUfpGrmpPFMkPM863hEKBrsTHFmkHrYf+UZ2MVQqF7PGoLeB
         549LflqTcyZAu/qLFbmCYzCftSvnLSlqPILlpCfkTqz5Nb5tB1PbDCenBOHJ1lTdWoC4
         modxbuMzK2o1L7CwDVJM3F7dQ05XYMZaQe011BMwVYF7Yfap62N+uU/bZOX7SA3kjQCI
         hHnZ9B89RuKjdEzVvyPxlbXM3Z7NZaMdyYN0SBX82HaqcAzxRBkAUkIbm3/QrB9zkN33
         FlbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782747077; x=1783351877;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TtnRVAeDbe2jCD/DHkmGFKsvQqrt7nLFRBhYCay7qN4=;
        b=CYUjhKqxnrFcz0j0KyqY7TnFA10/2eyPXu1RwjaN9DKdndUk90cQ/f9yJ1nviuC8Mv
         zFFopzqg45Yd+d76huJp/Jwp2lLi8VxDqLlobhVPg0bHmXX5vkG/j3mbihOwrGper02u
         bD6+J//vnCbeAQsEqs8vRcD/pkTBGOgqofBZlordb8HDnVjEc3OJ4RRZ0VVWqshlIWl/
         gtjo9RQIKTtiKBMJN3mYJEMfmUv0EGGekK1X513mwCRt/B9kd7ym0wTJdUk6si5IjqqW
         IsQ2QlzgfbzKoXE2UPGvl/0s4raXP1ytIMORjltDbbiaQWScAkMtLCJRDZoojHXY9Nto
         +jvQ==
X-Forwarded-Encrypted: i=1; AFNElJ8by0SNKFdblgd6t+KlrRvFbilS5HFpOWI1NjNzJfZlxA4VaO3QOEQFPajAPrQ2caH0Oj7iDuQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVgZ6TOWHPdd0f2WaDXYlb17pI6DBL+xuyg1YMsP1FKq+H0pAF
	WOJtY5pjrdBo9/atZ5IVayOvAmjBkWC7JG3w+czxnajctWHffLOqhXhvXHoGQRB5THU=
X-Gm-Gg: AfdE7clxwJ+w78HQoGkYsr8hXEqSFE9v6YzZWq8vX5DYw5X9ZO2CIPA9C+eH5imkePo
	AhthbP6DMfTY/U/ySraigxEbR4BWl5AI7/co/xD1T6jKGIO7FP1qXNsGk8/Os9F6Y0cYuP/R5KD
	tc6lPVw5NdGbdNUvfsN2Nux+xh61Z0URsz2tPO9Um6QYNMZCCnlRHMdH58VF/OwOVpvkS+ILiyB
	HeWb2MZpLVUHJNWKOWrbqlu93q1eGGut6I1fTMt3XtI355RCM1cJuD13s9vU6yQN5XbBAbI1noH
	e9bqjuvP0bbUqULCN3Vf5cNxjnVgbJgS1rZyr7qPgoY2x8NEEC/rI9Aifi567oY8cxKTUoWSgaR
	ZO1WTbv6XtQiejEMBBJHyd9c4uQ3cI/XtaXdMsPqpAW+m5VhnsY+rMLAMFZBKS7By0tk8z81G8B
	2cjRtLZE5p0AxXgyUlaM+xnfKAYX7kMKSY+yco1H6xXPkKljYoGcuH6B1rZkrxvVNT1WjPVPGyC
	6shAEo=
X-Received: by 2002:a4a:e914:0:b0:6a1:524b:1f5 with SMTP id 006d021491bc7-6a1891b6f09mr98038eaf.42.1782747077395;
        Mon, 29 Jun 2026 08:31:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e6213b95esm9184285a.5.2026.06.29.08.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 08:31:16 -0700 (PDT)
Date: Mon, 29 Jun 2026 11:31:11 -0400
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
Subject: Re: [PATCH 02/30] mm: add kdoc comments for vma_start/last_pgoff()
Message-ID: <akKPvwYs-4TwYwKO@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:13PM +0100, Lorenzo Stoakes wrote:
> Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
> detail.
> 
> This is in order that we can differentiate this between functions that will
> be added in a subsequent patch which provide a different page offset.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

