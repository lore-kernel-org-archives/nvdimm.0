Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628483FCB32
	for <nvdimm@lists.linux.dev>; Mon, 29 Jun 2026 15:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782747622; cv=none; b=AxYqmJVR+iIGqdsdjSVgE2dMxFlMY/HO8jwlkKLgzYzx8bYhU4wlBxKpbZZ/IQtwkjFidst9yikJ1/LFIK6LGS0E2eHtrjyW/SZEse70POVv2sjIVsVq0jdGGXBkMOURz8Xrj1QPIOT42BVN6nyN2KP0zVPU7uoz/vfV4/8PW78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782747622; c=relaxed/simple;
	bh=wTZ867cLvl3NEk7csUy7NtkIFljCREofjieQ4f4eY6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WzVs6Th0WRQ296ciSwFOevfolpxPOKpfYTSzdfr/f6wkAxg+l9JnkX45Kh0g2p5x0lSpqXQd2NNO7NvlvbxHheyXsux61TOPOgOqBJbbOKyD7eJ9V917VhLNrzbnYNZr26BHwQiNC8uQRWBNzf+QNtZcZtJW8U39IoFRi2St5G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=dZT4vYGK; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="dZT4vYGK"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-519ff1c8b8bso41920351cf.3
        for <nvdimm@lists.linux.dev>; Mon, 29 Jun 2026 08:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782747619; x=1783352419; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VwgemlAWVZOfyfvrJ+7cyHmQGRLai3JgFnH6EFj5//k=;
        b=dZT4vYGKcz19n0TwwHG1zDIsyBQ5YZSd90fIQcZJrGVdUJPF1A78XW5JJHpIAcJdDp
         RMRd7gFoZmDvu99N/EK8T4i5uVPPDczSxv+bFB7yaMi/e7bJPJTw5TJgAI/ieilxgFvS
         pq7q/gy/wuUOWKlFozYd8cnQ6rxnSkwwXyaS4BNuzvIIydhBqM1cQ+foSDbTz59ecL+b
         Oh7NeTvw/u+aL/BNYEA635pa1KDy13LfdHVFXCAFJGIB3/bXDDHBAAb1yiTpBjglwlGj
         X7U1nDQ4cKGkNusLIDSyqWROgZLCQ0/Q1h3tqxkSIqLHM/eBIXSeglzxUoYCymZv+Ge6
         aIeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782747619; x=1783352419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VwgemlAWVZOfyfvrJ+7cyHmQGRLai3JgFnH6EFj5//k=;
        b=fDEqDeMRCu8gRFizreHbwu7MAM0AKcUHCQlqruPOMCgLDCWHt8SNI/3Ks6U0c19v1z
         fab8NsIZVRavd1TpAw9M1CfrJsUGwXRuoY/Scc0bn9bSXxAcOD1EnrzkNbfWPx4cuk/l
         u/oQKo8mo3sxkO5hHMWvsK/F+Pmh3IrGqnXKswTVPBIBlJ3rMUWO3bT88B8uoMcSlIzv
         d6E3tj6eopPq+wgAconrBjf/SCwpW1l9G7wBsU+L4/OzkxAfxpHotyNCOCXB/+aqPkOd
         L8PDIX6GH7CzIWKvLN6kS6LWaplkiuKoYlwUUB42s4abErsjQLumSv214Pb89nm+VhAP
         ax0w==
X-Forwarded-Encrypted: i=1; AFNElJ9arrvdLRW5jyw5VnqGtspV/a0WxYLD7PNKsPNcZEx3KZKXxOnyo0U6VUuPNyCQH+/lPIPDp6s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxt26PIywf3LFwQAb1fgans9zw+x0NnuGPLQ6BUfImcBRLfG25b
	EWsc4+WszrA1oPZXnKHTlGYbtRZPi/gAp34Br+dNby3L/779EIVjt8xIhKyzfcyuqIw=
X-Gm-Gg: AfdE7ckqVKQpu3gKq23K1OgCvi5wdSmpkafqYZuP05DKhaxrdn82v0BBqkJaV+eMrlc
	eb/uIwcqvsLaBrTjCY4pjTBGOyuMPmdgZd+cmgNtfLh6e2R2UQwBE59UtnBvIN3LAGNMcXp9jpx
	sQcqUK8DSlA38HMqF7zsa13xxc3bmgbj698yrV91hKoF24FUYHOIb77HdiHzzB++K/vX5DOfKTZ
	ARkBgLmaSOilIeyvR6gEZ2D1t1d+Bcq+i3S9qoDteVh7IQ4KAXXjFAjkrXSkMPwnPOZyyhU7Ea7
	zN479QxxLUlgjDg389pWJa8pw+vqSL7MWBl0WDrqC+gz53xwTB3ZCRlcpTvx+ZzN2egxY5nsk/I
	dPFS77a1CRoLE2oQ96uIxb8AnK4qAnxHd5E8asPGDXJGSuScknHMhNN+8M3wJQ4yte5w5h6FUNU
	eMjIohQ+u+w4jelxikUc86GcBqsvIBFzyFjWFgglxygDqt1i47tX2f8iaJYXY4gGi06qEa
X-Received: by 2002:a05:622a:5987:b0:51b:f635:9aa1 with SMTP id d75a77b69052e-51bf6359eadmr68650541cf.48.1782747619393;
        Mon, 29 Jun 2026 08:40:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a876c888bsm78114501cf.9.2026.06.29.08.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 08:40:18 -0700 (PDT)
Date: Mon, 29 Jun 2026 11:40:13 -0400
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
Subject: Re: [PATCH 03/30] tools/testing/vma: use vma_start_pgoff() in merge
 tests
Message-ID: <akKR3bFV7393yOUs@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <b501eca378b9d9734e83838102aadc9276590fba.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b501eca378b9d9734e83838102aadc9276590fba.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:14PM +0100, Lorenzo Stoakes wrote:
> Now we have the vma_start_pgoff() helper, update the merge tests to make
> use of it for consistency.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Question: Should we have primitive tests for vma_*_pgoff() since
the behavior changes depending on file/anon?

Nice to have the cleanup and clarity. Maybe worth asserting no
one ever breaks this.

for this patch though

Reviewed-by: Gregory Price <gourry@gourry.net>
