Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3AC39D6FA
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 21:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783717447; cv=none; b=p5RNQU5L//glu7fhvxvI0fjFgeVAel3hgMQEwau3mnu4kbuYHYjuRwaNXy9pGrDBHWfm3wMO2gQI/1JgFzLrRNEs+G+2vQvB5VJIVmemC0EF1MU3fDmMsPFW8dVxJ4GVkbV1nIzcuFA8yXFhVY23eV6ykIMHEH/IQhCDuSfbq6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783717447; c=relaxed/simple;
	bh=2Gu7794NM37tAeRC1T+cOMES75vIKzE7urqHPy3L3qo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQbqiU1ntMCBPl1RWx49c3LEGryhSmdC/7w6cD2/XR5AEh9PwRvYORk4nXtDEKAu/QdWuSnrFQXoBDUR16BPoVawH9AkVXToQshhvoR9E+0iuJJEoyjTOeALni0WzSB4NiXxQgMVmIgX6PASdRJP0G0Asq9FVfUFfuRDDAmvk28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=qVwKoYf1; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="qVwKoYf1"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8ff20870ac7so10217006d6.1
        for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 14:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783717444; x=1784322244; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OhI7UcJVN9EaMSo9cM31eWAmb7Tf3pcvHFHtAkV4RLE=;
        b=qVwKoYf16zJiSwFNo/568RD84cs/Kgua/RemFiVF26GdYHKAlatTPJlgTIS053v0Z4
         86nGgXzaJDcjdITV+tFD4624y45jFBU3ZL9vs1DWiP1D+ojU1jwVmRA/wxnNwdZSeuJ1
         A3ZqdV1Fsf4XUtLMzJxfzuKjRHOn8YCwDn2sekESHl9azeRd/vt/YT9VJWSIIH0BJcUL
         xh4CI04SBpavEdTVsZyOJTsnj0+eyEXGGuNCmf/6G2GGDT6y13IUMxM+Bl7U1rkyudDF
         GtrFVvN9OObw9ZP10u5UNlgeXbu70bA5OVGCu7nQT8xI5HXSSJeYTTWVMid6mviGAlV4
         BIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783717444; x=1784322244;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OhI7UcJVN9EaMSo9cM31eWAmb7Tf3pcvHFHtAkV4RLE=;
        b=UP8IeecrMZTEROkLfRg+Eon7ntBt9TV5nwLYZvwG6Rj/O+1omDlI37MJWFeswHlJk8
         5LjmtQIdH1x56q6pv1cCnwQBXoJ37yG87uWqWgwG/riYcrWb4S3wRG3hk/7cG4fOSxOj
         AYqaWJ+gn4o6ApdaDDjFeTrBIFz4NToapxiIIg2rMhAz239VsjMDbLN2Y7dsEa6bGKwz
         o66K4oXaCzZBNS+ji64ffkiUNA/+rXw446DL9XAqFqVFN1bFuXIwHzkjFwElkosxBgiN
         /vJt58j3xmEvjOGnlaVBi0CcGQNIOS3kEy9O2iK/Vxr/9rbZ96EOWJDnU58/iRW1H1Vx
         rG8g==
X-Forwarded-Encrypted: i=1; AHgh+RqXGgiBEgjwn/UDTpyaNfOkdRAHrF3utlpFZA6SZ1sIfCUakKIgVcxfsmeg8EJJNEaHiulmOOo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+QBpdPDscrRu4KNXIV8tJRknKqyAS3m6nUGU4K/sKcr1XDiVE
	WU3ij4TcCG6FwCkJHmk9mllkzBP/ZLZfd8y8NsUQSRrWuYnxgQg0rY1sfz4SrJChd40=
X-Gm-Gg: AfdE7cnINRgbbO2rjkklW71SRXxVBKg0+eZcaivzJ0GdH1a3gUvynAhaFGu3cFsSz1g
	PUtdQGERjT4WOgcFhqZAii03DJhC/ceiSblNmTjzzZOXHGRmCfQ8LWz4fr69UNkYof+E4pGqvcS
	Lzg+QvYZbQ4jvJhsaBF21OhegDXsrtFtSxim8F6FH2OTB2R2nE9gLO42OQBQmM6VSCjSiZdQaw+
	hkHFpBEngjqgBi7lCpbbV51gNkl1YQ2aAhDO1pCZ8jgKJTi0KcDzBRkhJDF7RIlZoCieuC7Gtno
	PQjYuBbYqR7qz69DsvZm5wQTRV1/bvASN8pi4BJeGFc/pwBdLYKRcp5GitRX+yPBCGPmzgxJSvs
	CHgXvl5vhIWvUUYj9sbiZI707xU6eJVL1zBaILKrc6AaQiJcgFSJQ4+rb/9nPN8mgUFhJP/IcuW
	lhYlA6MLwNLYv7Gloaj5DWYyBFkjyootStPS7ghuo2rhLvZy5OK9diNSXXRYtnQNreqXja
X-Received: by 2002:a05:6214:3bc7:b0:8ea:10f8:ae87 with SMTP id 6a1803df08f44-903fe450f77mr10485176d6.11.1783717444207;
        Fri, 10 Jul 2026 14:04:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd50df5e2sm50655596d6.4.2026.07.10.14.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:04:03 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:03:58 -0400
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
Subject: Re: [PATCH 27/30] mm/vma: correct incorrect vma.h inclusion
Message-ID: <alFePgFUR52GgBS7@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <22d0f4e3fe11f6fd1312734e242d008267ad142c.1782735110.git.ljs@kernel.org>
 <alFHR3fg8K1-SITK@gourry-fedora-PF4VCD3F>
 <alFJUfaGHVnKd-Nb@lucifer>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alFJUfaGHVnKd-Nb@lucifer>

On Fri, Jul 10, 2026 at 08:35:43PM +0100, Lorenzo Stoakes wrote:
> >
> > Do you actually need 3 copies of this comment or just one copy in
> > vma_internal.h?
> 
> I'd rather have it at a glance, it's a bit silly but C headers are silly :P
> 
> BTW you're kinda racing against time here as I'm on the verge of sending v2
> :P

:[ i don't refresh my inbox when i get hyperfocused and now i am sad
