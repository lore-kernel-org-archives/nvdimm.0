Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5745C466B77
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 15:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782834921; cv=none; b=cWT30mu5h1IvE7g0QjTzxMMu/amxMq2E/cYHWdnnmI0jq3KQOVcac4kYIEbz8AYz2cPBbZzC8kA2zUfkP+mI6eZF1y+uMOW9+0WZZjJaSH/fw0IeBOiztmtfW/c4PpJahVLDkmfs8kJ9LVTH0ptSBqzBBmkmVTyTe61d0P3/mAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782834921; c=relaxed/simple;
	bh=q/CdBZIJ6A6qBJyymYNRI6oVTAoCPywZ7vcualAVIBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T9PKZvwPuK9327aTMIugPYnbquhK4EsE6HqDs51Tr9t8LgOJ0YUTu7IhAPluph2RvaJDpL7vKhC7f+kYe/+7M1XaOj8sKN+KTRKMF9ps6LOz4gYMd7fyiAof2mHs9onE/3rzS/duE/IfH6fh3uJIRmtHe0UbbOKuvsdMnwv9XsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=bnvq4kWw; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="bnvq4kWw"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51af8fda431so35018141cf.0
        for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 08:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782834918; x=1783439718; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BHpENWZilS5aqo8aP9kraE35F/fs2tmonTK7cFttpS4=;
        b=bnvq4kWwRBO8gDP1Pq0UhShVlFL47txC9PRF3ADiKiv67i058CXuYnwj91DK0kgTnr
         mdE18dvO+2ZgqtimAUBIK20kIIiJMPHy1Ihd19L3hxBPpWaX2WGu2IufeggrbW3tUNFO
         kdp2jovkTDlFq/xqlK9hKdeD8tVTJje6JW0PNNQb6o3HuMtsPBseBRiuuaU32VKM7D/6
         gCBAIx/jBcwRzORagr5rAQwGyhJvdO4e5oM7Ejf5G7+v9qqwVtWXUHsgYwS5V60pVJPh
         Envc2z/rmS1Pi7VZ5uwmWBQc/Wlqp299nfmpy1AStjpW3sbsXQi+ELhYvtWHK9EeHDO4
         91Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782834918; x=1783439718;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BHpENWZilS5aqo8aP9kraE35F/fs2tmonTK7cFttpS4=;
        b=Y2DeFdY8fYPON1m334S4ckYNA1Y1vxk8Y6NyhEm3jfqnbzphVs23rnEMK8KKVWXS8J
         9R7DOb+GUKE/7CwK3U4+rdL03WREJkEc9stizNpGT7S83KBffR2cwNv7UJ0p68S+yuR7
         G9RcmM1iFpzj/v+KZdZHiHdKV7JdMdognLqMqVTERrkfJJoDVsRR8d4y/ZjvEbeirGod
         bfObRQ4L7CrF26uc5BR58Kam3LZLDNW0MCGbGvnhlXuitVnZPn+uG+dPpPSXW3yNDfXG
         LDLuUuOIdJPHrko1ukeyiNJRlCayhwntYy7HAqVtPdgaw07Nhz+tiWgP1HIJem4H5gC7
         1hxQ==
X-Forwarded-Encrypted: i=1; AFNElJ8+LpypSD1XN7gZMLBcdF5Shyz4l6d1yzLmgo1xMvp2vQzQqZDaiBNfjzmkRbbF4gT7dyoKUBA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwryDrRF0wH1QJtT2c9XzylXzJVPmr9UaB+XUs7aznFYtus6hSm
	xkfsd+r4giigntnkYEVf2iJn0+vIcO3rEw09qSbh5WIzECQWIcLng8HJUnu+yN/hydQ=
X-Gm-Gg: AfdE7cn/+W1l3HbDpcKrB+rKpBoa0RYk3Vvb/wvLzkWdsEpWBx+5v6s1Ov2OR3u//vi
	hfkNNbVfrzXKXbYQWB7bCf3J/rdJPgMilCc9AYEJtSFUIsdLlbRsk8v1FUAxEMFZ11OFOhNBkDy
	G0WZvgnSGK672YZXiz8i8x17aPkDcKkdFWCnahov9C8z7RpNrarRv9DEItOWxcvqP6/xumwE2QC
	BJcjIfpqeSeQbpbHHMXEKSZUJjp460vcwiKRTrozcvoacdBj2ubGrOd8bgs3pgr/CvJ0D+Z24cG
	N/FWP30N4MHREug9Yrs6cn4pr7FGlNjlr1G70CAMCKwpJEb70PhsUm/NBPmPhiKhF+Wkn6Sbqso
	KmvaE8D3etYUE7cdnUdK+oKWOI9BKrZkphguOp4TJFLyxtvSx7BaMCMLAISnQOUZU1R1ca4hVvh
	ulW60hIGi5e2mZqHvuRj/u/aAS30TvAOhqv4zkdxU/bfDCUPTmTLgcN+a7ZkTd5BCKiPry
X-Received: by 2002:a05:622a:586:b0:51a:8c97:fb94 with SMTP id d75a77b69052e-51c10911601mr53620781cf.61.1782834918282;
        Tue, 30 Jun 2026 08:55:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c1080d149sm23102481cf.1.2026.06.30.08.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:55:17 -0700 (PDT)
Date: Tue, 30 Jun 2026 11:55:12 -0400
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
Subject: Re: [PATCH 09/30] mm/rmap: parameterise anon_vma_interval_tree_*()
 by anon_vma
Message-ID: <akPm4FlwTj0FsZU9@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <1c1df7b905ef340cbf2effef769a4e770a8e0eb1.1782735110.git.ljs@kernel.org>
 <akPk5o_gHD1SxX_0@gourry-fedora-PF4VCD3F>
 <akPlUrNWzl1ZPw1S@lucifer>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPlUrNWzl1ZPw1S@lucifer>

On Tue, Jun 30, 2026 at 04:49:45PM +0100, Lorenzo Stoakes wrote:
> On Tue, Jun 30, 2026 at 11:46:46AM -0400, Gregory Price wrote:
> > On Mon, Jun 29, 2026 at 01:23:20PM +0100, Lorenzo Stoakes wrote:
> > > Similar to what we did with mapping_interval_tree*(), let's declare
> > > anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.
> > >
> > > In each case the rb tree referenced is &anon_vma->rb_root, so just pass
> > > anon_vma and the functions can figure this out themselves.
> > >
> > > Additionally, rename 'node' to 'avc', 'index' to 'pgoff_start', and 'last'
> > > to 'pgoff_last' to make clear what is being passed.
> > >
> >
> > would it be possible to split the pure rename changes out from the
> > changed function declarations?  It's hard to pick out this as something
> > that needs to be looked at as more than just a %s/x/y/
> 
> Hmmm do I have to? :P 

I mean, no :]

> I mean sure I can on a respin potentially, but it is a
> pretty trivial change? Just mechnically as above.
> 

And yeah certainly not worth a respin.  Just learning some of the
friction points of reviewing as I spend a little more time doing it
every day.

~Gregory
