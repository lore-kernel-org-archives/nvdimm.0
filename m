Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC64044E052
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 15:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782834147; cv=none; b=J4nGWDLm2B7osEDwU7FG99eV9SjVUUVHmCBEeEJW3mfJDAAK9igKYP3UE3jZTq72ca2USAcQx3jfz3bywKUfU2gCl/RIuBB+TNOxlmXcY18YnMX7fdhfaYMaCHZVuBEheo21icQxF7hA418VFBW0ed/bcisjp8YEItVvxdtaCRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782834147; c=relaxed/simple;
	bh=G7yBa9qRXwqvk5O66eyJS/F0IvVRBRnFUCu+8taoCIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gt1SfAc2ZJ1AENM6V3/V9GPENrcXpRkOEWn3xErWyd+xD/UpjCKiYBkqiklZ8lsIXAkwd9uT6aUCS5FOSgVF/Vl5diPw0fIlULw1/5M8km6cO6D5gDWWpjfHZU0cBWfMBwKxmVCItn2h9QLE/pWsKh403aRimZDz1reJ6WNQ8bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=jf1e0vbX; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="jf1e0vbX"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e65e18969so87345285a.1
        for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 08:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782834144; x=1783438944; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QB3LlP562wM9vhAInyZtqjaYedctMNHlJgLHcqpXNiE=;
        b=jf1e0vbXN9WHA75z7y2uYxs71+5ddmPHth4etxgt04k/1p5i7sLLhabahl3YdJtTvp
         rpc+uGW61RRmBWNp8kDuAOd2ZljKbGChcSgOr7iTvO5IPCs9yc3HuuwSzuhXSF33M86i
         DVaxf0P7Cjh4eZbpElqnurfthpg04+ty0kMBt8XAIKCzHcOp0EYu1IlpbwB5CfpW6QwJ
         Ovp00MLwt4ucDo/iKwAOVSoQnID0L03RYBC/zp2IdG1DJti4RAkjf82k8S9tawFOne8g
         1/TfBGX9+nniM2SBdZS8qzOMl2OcOjtBriP5OM1eHHukvyotZm7NVjUZuduid54TYmp3
         Stxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782834144; x=1783438944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QB3LlP562wM9vhAInyZtqjaYedctMNHlJgLHcqpXNiE=;
        b=hQDzya3hWONOoDINZ9V/Y8uT83zCno0Vt6VKu7yN1lfnpaq8gzSAWURPwFLlsZIq7L
         f/T5LWnt1Nj1kNPrG5TYVsb2rejO9e1Nqa3hl+E1wZ60OYbuQs8N75LWVfhP4d4zUl0V
         H3vsqEHESaR39JFBlzgIkkqT9A2fNR7TtcBaG/CHi6D5cQnfERx2T+XLYgkppJz3mL15
         e24zK2HITVPMmbCATiJK1drKWsggmTvmZTjBfxE7M8imu1eDuVfZDGjL+Tw+l2qG+IHm
         xA63VEA8lxbTe3Roq/DOyRfnC7+DTzXL5iu/vPWWNhHf2DxNtkuZVf2oeGs3ulYtGVnU
         kMsQ==
X-Forwarded-Encrypted: i=1; AFNElJ8S/z1y0QGb7oZMukXmAzPeHugyJxKQ22mL5CoJWeAmd9QyPoNIDSCTvRF1keKdYoEIVrU0OCg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyOoGDNmzxIhrta33P7vvHWU32Xm8+Ojs1jOtT6HHFnL6UcPqTF
	OhkD23tWkv0UzRQWi71NoDBiHQmpQ01fjcjchZ1nstzMeU0GFyIvpm5RKfXNjh7N0Cc=
X-Gm-Gg: AfdE7clY2hVvCPnBDL2JzvfXaU93ixMTdo3oixtCZ8CZRGEZncBcjxqaaRatgyDVly6
	cY0zql759CPMJI9j8Nw+KtXwV6Cx0HXewuAPXqzvUxsoypazhW0MeYXuV2x1nn4MrJBdkhDKr1R
	7HBwouQyrH3EDV04vDzNM93jxqqkKiDDrlfDA+9e1NErGzZKiW6EtNFqRDk+vPgmZZMS3Pd7/vA
	Y1wVYtQW+F9PAaCOecHMly/+mt9sWkAGrxdfCgBkQCApkErFvNcClMzj2dWdYTK+GLRKsCufvGx
	ZoMJIw7UTnlM4cqqQCCfzr3Nk+Ybwra7zDZOWW6o6ZQYnU4HOEHRUtUxs33phgVrDYoywLTusOM
	adApCAKJUTOg3XRE/YsxTvSQ3vmKJiY6kf7egWqEtBu8wf6zEHY7FZ7EdTwIof2FkBrKptZnQHm
	aIKZbuDZI4YDbAaxd3miTJWDUITl7r+BzrcNgBij4EttYvu8RXk2Csa3cFf5ybHqc4NkEA
X-Received: by 2002:a05:620a:271d:b0:91e:712d:f79d with SMTP id af79cd13be357-92e6984d3d1mr270456885a.40.1782834143842;
        Tue, 30 Jun 2026 08:42:23 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e6234dc50sm263249085a.39.2026.06.30.08.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:42:23 -0700 (PDT)
Date: Tue, 30 Jun 2026 11:42:18 -0400
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
Subject: Re: [PATCH 08/30] mm/rmap: rename vma_interval_tree_*() to
 mapping_interval_tree_*()
Message-ID: <akPj2snngOp5nOYq@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <f95462457025370efd047b9dfb039e76bbddf58b.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f95462457025370efd047b9dfb039e76bbddf58b.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:19PM +0100, Lorenzo Stoakes wrote:
> The family of vma_interval_tree_() functions manipulate the
> address_space (which, of course, is generally referred to as 'mapping')
> reverse mapping, but are named the 'VMA' interval tree.
> 
> VMAs may be mapped by an anon_vma, an address_space, or both. Therefore
> calling the mapping interval tree a 'VMA' interval tree is rather
> confusing.
> 
> This is also inconsistent with the anon_vma_interval_tree_*() functions
> which explicitly reference the rmap object to which they pertain.
> 
> Rename the vma_interval_tree_*() functions to mapping_interval_tree_*() to
> correct this.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

obligatory "naming is hard", this patch helps, thank you.

Reviewed-by: Gregory Price <gourry@gourry.net>
