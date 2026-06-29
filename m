Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5565C428839
	for <nvdimm@lists.linux.dev>; Mon, 29 Jun 2026 16:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782748870; cv=none; b=DeNGDf33yRHQs+KRvjSY0shk8oxNy5R1OjEluJ3oGNMiBAdw9LrZoF5f4Z09weO8fFA8sJJkuTNc44ctOrl5EAN/Y3iA7Y7W35fn8RSgx9IInKfTHlGy66gqAweHP9d+0hXj5sjWu6kbb0Oug4FCwWgCDo7e5ppcNsgvVFpzuvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782748870; c=relaxed/simple;
	bh=z4dmX8dXcX6a8GqR+YBU+JEoYI0/LpvWh746yKHnt/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NU+Qqty2jbO041WCOU9soXuii6bojkhUgx5rUArxz0GUQPOc7yHCAqM289ifeOTHEsimSTeoRjqSgrxO+Jvzi+czLx6tjvM9dpT895wgWC+tuseSdP9kjBN/w5kzJhhmJbY7MIfD90+Bks41BwlE4VHPV2VKSvW07/wJIRSy8Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Ie1cm6V9; arc=none smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Ie1cm6V9"
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-664c6304683so1600421d50.2
        for <nvdimm@lists.linux.dev>; Mon, 29 Jun 2026 09:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782748868; x=1783353668; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4iCXvcvVpnsYDr5kbvWXbUhbyvnE3mHOMHboZJmxShw=;
        b=Ie1cm6V9kh//i8i/M5/thLew53lRrmLlqwW2MjLivpulJ6p5cFT8mBRkf+iMpjMUfb
         54So9HZqyEfzgHPKvAU01XyXhB61mJ/qOBWdci99/9s1qTq+ENG7yeUqJ0GYMnDWw0Yu
         b+gQm+SDU899nBGK118x6P0wiH4XzKRI2EHWN1L38A1wBLrDxJvhxb3QX6OgTgCXgsfL
         nTow8e91NcEcWnnRh+ifzTpV2ch8wFA+9S4ZV1hs+1gA4aKqnERLIfzQSHubSeDyStDa
         335vBkEBkXvkLccXYumhPcSkovU3Qx/kBi5b+mZTQxcOJB36r/oa1jiXpcsGFgF7c2JQ
         SDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782748868; x=1783353668;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4iCXvcvVpnsYDr5kbvWXbUhbyvnE3mHOMHboZJmxShw=;
        b=SNW5JeaNqL8tETyLaem5F8jVZPX7jGaetEeEMmmhTqTXvz1AmmKM1OYxnnlGTm4aR2
         0jAr1q2jTU6Pc0LskitBUvi37nrfb1a+2JejO2IyuzNsMRf8CLMXf3sAHbDp+4HV7FU4
         wMeuy0ibBCTMTKhSMjSGvEnGnwXN8ks931c8gB8MNUwu2r4+K3O6icncKb4rvK3kNn/I
         SG94z10TgaytcZ4ZcoRry89oQhUA4yFAD28kVDqS18szRsmIb6XeIsFvrpwRwayY0bEG
         oZg9QTTIi55J2JBbFEujeZIXjIjSL+B+rl6tz6x8EgxBUyxiIXuolMkG/Wnuy1HdmrUi
         nm3Q==
X-Forwarded-Encrypted: i=1; AHgh+Rq8zrcWrHaEl1tYLz4j9GiXl0Gz+PHPuVaLD9W4pXcxZMUfd/DqvxkoaWZlFC496cUJmPXGcRE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwjJME7q/BHF2M/skukVot9JSmD5GVKQONm8A26n42eXiD5A8m5
	hYBS8gxPplrdTCYDfZYqIqxvDQJkA7XO/HjGRttK6AmmfTfgCwyGEh8U8jp+NTv5aZ8=
X-Gm-Gg: AfdE7cncLmH6hPzNW0+BFsrmbAOp8DzvxdwlJYaM82VNCbYx2q3RB+j2jHk1wso3IuT
	VuNeDf6Gk2lRLN41TI7x2vYHq2T2qABpkqO4xmRlW0hCIKpf4z3evpnbiIkOhKxh59P1C4wU7BV
	kntoFiQRGbAw7PFbqhmc/FiIow+ZgoNRTbKFhkKyOfbTJ92FOl9sOb28c0bbhV1hN/VbSFFkqxG
	ebAwuqrmmfSuV/NxCpz4UcLYdAKyhXbi+tMsWvYIhFlAUR5hbV+K26uKH9yrIelXuGYkInxZOxJ
	kDYkNN0bn/72KWLUh1m04ytTEi/Q2iGn86c/5hEADUmvarbsNv3Gh5D8kHhNWszT04yrYv+5obm
	ENvM9Ttu47pXzj9YzYJKUaSZ6uWigneZOYX62dHy2MoSWI2nGUheLQUpKn9W9/IAq1llju0F/PX
	McjI/8kitqcfO4LZtoZ6YiaVGibUi0dOcnPrx2gar/ZbMRAT8MD/EHnwVQ+nDFReSfTYt13LhKs
	UeVOP4=
X-Received: by 2002:a05:690e:d8c:b0:664:e66e:f965 with SMTP id 956f58d0204a3-664f974638cmr245066d50.7.1782748868214;
        Mon, 29 Jun 2026 09:01:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a717edc7sm1112836d6.36.2026.06.29.09.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:01:07 -0700 (PDT)
Date: Mon, 29 Jun 2026 12:01:02 -0400
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
Subject: Re: [PATCH 05/30] mm/rmap: update mm/interval_tree.c comments
Message-ID: <akKWvnU2Ua-8ceSb@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <80d482a927b2e9862487b812e0ab48ebc1289a70.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80d482a927b2e9862487b812e0ab48ebc1289a70.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:16PM +0100, Lorenzo Stoakes wrote:
> Update the file comment to clarify that both file-backed and anonymous
> interval trees are provided, referencing the relevant data types for
> clarity.
>

Isn't this self-evident by nature of the function definitions?
(one takes a vm_area_struct, the other takes an anon_vma_chain)

> -	VM_BUG_ON_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
> +	VM_WARN_ON_ONCE_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
>  

For my own edification - I know not to add new BUG(), should I be
converting BUG->WARN/something when i find them in areas i happen to be
working in?

~Gregory
