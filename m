Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18243C2788
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 21:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783718830; cv=none; b=CxjTrAIgLFwWeoG0YyrJTM8a521d75bLwOAtU4Fjgc+VigXtJNZyDJfp5XnD8fgqAsa5+vgcD18hXKYfo44XKevodPJOMtpT+Rtm5wdez0rWQddGIXLs3AiwpJn+lCmYXKZ7PP1MlUjk/Fewx72ntfsXSIpYu08mpKIdMdFIC3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783718830; c=relaxed/simple;
	bh=WA59mEPQS2KZpz5hwZRIhAuqwWCApokXv9AsxSKOvQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RxCtuLQSoRl6lZbhx/chzm8Ln5E0OGQYQJJ1PBbiYmGar+hmqEu/PVoIr76hSb1mc0KRoOgUUWy1+VxisM3thbjlcOYwTVbY43bkgaULWRqyDb398SryYCr7+DYj6PfKgFJy410DXvQtb8Irflaf644xPfHWrB0Y/HmycgoCu7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Wg/5s2lx; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Wg/5s2lx"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e65e18969so106586585a.1
        for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 14:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783718826; x=1784323626; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oXHpiDgBaIEeQKnuJdWSZ8rFz2G2XIdWbRFpuwAJIiw=;
        b=Wg/5s2lxes4AlTYbu5iUWSKgPAx3F9HS7b+TfvNunsQxsGWR6Yu8tWOKEdPDcBDEVK
         lsMKM8gIg5qYN5TVTNXqjQ8Id1Uce6L5C2xeh+xs6cdYTM/pdYuiDR7i7ZKzKWHxAwwm
         KTIDvHObG3jUshe7SLZ5mig8TpqkccP5XiQcCJHntNIzc2XKcyiFQPO4XSUnUzN5Tt/V
         d/LNJPcDAN4u1ucauDrqrCb0QBMS01LDT3B9wdKZkGLI3kWFXpaWrxU5CtezhD2PTgVH
         Zt9s1h83mZtGUkj9ysLudlLiILHPhWfbjuSBeejUGD/Xrd0DfOfkyjxMJt0MrgMxGRWW
         7Kxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718826; x=1784323626;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oXHpiDgBaIEeQKnuJdWSZ8rFz2G2XIdWbRFpuwAJIiw=;
        b=A3bVL5rNc5P21vjFkSLtQ6MeBrENcPRPN3qdn+IING5+ZqRDm07QCT1Ev9dOlwXdSW
         uhp9m5vId2Yx8kRERlfv5KtChmEWVvIY897na3/iMgScyX66NPnT/jRkj6IrekEABVGT
         I19f5Ugl4FoLaHN1LM+VQXBIMxz4Dig7XTuvhf527pM0gTe9cc8iYkjHtZ0NHkX3+D00
         mY85ARzHyANQANlJK3xAQpl6AbLcEDRJ/Nqq5YR37C5cDvfNqbmCwQPRXqxTvpURVGep
         s+KafWTu9zTiKCha+RrMfbIbJy9+2zk21QbhJyL7gl2H739G/8W00e/GM+GmUQcS9wC0
         dVaA==
X-Forwarded-Encrypted: i=1; AHgh+Rrvb/2cMiI4Xo1jBTeb8UpKldhK3+QOFmAafRt+5i09eY5ogrrbRrcDQ+b+INVCZhwVrZrrw50=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDk9qw9cloAd9ypRy+ZdAlLXpst3+6r8vzy7gUaDes4PCh44S6
	qlxcXMrxpL4FhS+iDIp1vCVUAGtYujybZb9msP/vLq7wfnDFlQ9hurgJ59VEyHgIFaI=
X-Gm-Gg: AfdE7cnOO/IR3d5JUoLnu0ivssi4meTMcO4C1uYgTHHJwXm6mQKwOuibH8dbA77dkh9
	XmQzvTSJiwxkYyX5w26rTDrcFe1ndSv4mbsy0FReWMKx3EOWtZrJeTmpyrRQiuT3nvO8+RW9PzI
	xbsEwV/2QDwPgsUQCD8v/lragcl9i7flH8Pul4giRxo/xWDJ8JHRW5/4MQ10pzr8j3Sg5Zff+9l
	kaYjgptGPGSgghsHKWxxFB/BK1LgP1vl7u2ADPhYZXE/de2LzubDVSpXibPhj0e1/z6CpLzx2kl
	+vlpxmBmFy8kmbwRTo51TncMjc2HaHiarjlOV0otYX45HLY2TKFJcZMqDH4EJPemyyPLLkzb8hp
	nUihtO+L4G7qp9LMdnJNsd8prReuZ7TNsZCcAIDiqXo4MUXeA17vO2za0mPl8vwbpgvY3A81n0Y
	uAYzDXMCTNNMyUZsnRFSYGzurEpu5BwVV4q4sE9xRB1UWDZyiSZoQweZ9pk0a6PRuvCeh2
X-Received: by 2002:a05:620a:4008:b0:92b:856f:3c14 with SMTP id af79cd13be357-92ef3d1792cmr55468485a.11.1783718825767;
        Fri, 10 Jul 2026 14:27:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d2d68bsm289148485a.33.2026.07.10.14.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:27:04 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:26:59 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	iommu@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 29/33] mm/vma: introduce and use vma_set_pgoff()
Message-ID: <alFjoytGnkjJs7zR@gourry-fedora-PF4VCD3F>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-29-2a5aa403d977@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-29-2a5aa403d977@kernel.org>

On Fri, Jul 10, 2026 at 09:17:10PM +0100, Lorenzo Stoakes wrote:
> In order to lay the foundation for work that permits us to track the
> virtual page offset of MAP_PRIVATE file-backed mappings, we abstract the
> assignment of vma->vm_pgoff to vma_set_pgoff().
> 
> We additionally add a lock check here using the newly introduced
> vma_assert_can_modify(). This asserts the VMA write lock if the VMA is
> attached.
> 
> We also assert that, if this is an anonymous VMA and unfaulted, that its
> (virtual) page offset is equal to the page offset of the VMA's address.
> 
> We must be careful about MAP_PRIVATE-/dev/zero which violates fundamental
> assumptions about anonymous memory, so we check for !vma->vm_file after
> using vma_is_anonymous() which these mappings satisfy.
> 
> Additionally, we only perform the assert if CONFIG_MMU is defined, as nommu
> does not set vma->vm_pgoff = addr >> PAGE_SHIFT. This isn't really relevant
> to rmap as it has no anon rmap (nor needs it), but we must avoid it
> asserting falsely.
> 
> All of this logic is kept in assert_sane_pgoff() to keep things clear.
> 
> In order to maintain correctness given this assert, we also update
> __install_special_mapping() to invoke vma_set_range() after it's set
> vma->vm_ops (which determine whether the VMA is anonymous or not).
> 
> We do not use vma_set_pgoff() in vm_area_init_from(), as at the point of
> forking, we don't necessarily have correct locking state.
> 
> Updating vma_set_range() covers most cases, but in addition to this we also
> update insert_vm_struct(), compat_set_vma_from_desc() and nommu callers.
> 
> We also update vma_add_pgoff() and vma_sub_pgoff() to use vma_set_pgoff().
> 
> While we're here, we drop a BUG_ON() and update insert_vm_struct()'s
> comment to reflect the fact anonymous mappings can be added here.
> 
> Finally, we update the CONFIG_MMU, CONFIG_PER_VMA_LOCK defines in the VMA
> userland tests so IS_ENABLED() will work correctly with them.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

carry-over from v1

Reviewed-by: Gregory Price <gourry@gourry.net>
