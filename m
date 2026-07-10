Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4E43B52E1
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 21:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783718276; cv=none; b=P6P6ktrmeo9W8gXku8QeAqVIllNuW81XFtztfAHcyuHmJR68Hl8/tKZolO2ufrrWgY235Spv0SxtS4yVjHXaSNAVB9qO18y4xEcJhIzej+BSQrTG5MSjMDIE/UwClN1eBDORxOqhnL1Hkp3eiNH2thQHATrRSUJo4N+epFSihUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783718276; c=relaxed/simple;
	bh=SIhLOUaxsH6uNqg5w5fr4DNuZv6zf1h5UML6naETP3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lwt4qT2Ek8RHHgsfs+c2L+rEObT5W3Qhwzgt7DWLZJJwuj480SyRDlLmQshh9+azWDj0f/Crux7tENETh54OcxLewF97Q/orlZVyyruQGw8REAUF5JZPLLpK4NbgYlE2XMBsRfAl+1tnKe2GRWseGkQDfXgyaKLN0xt7z8lNXqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Y1nEYFey; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Y1nEYFey"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e855da580so110946385a.1
        for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 14:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783718273; x=1784323073; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3ZedB0VQ1AWAm53tDDWxHLVghH418fWVIB0lX7U1LiE=;
        b=Y1nEYFey/kqyULPg9At9aiXklXR4uGDGtcqndq97XEb0Td4ntzB8Q5XyCETMcjtrK5
         aH6zd+cyue7jsUkORDXZCYmBgHGu1+xuyrp8uipWqpLnWleSI/FgertbNbNWmblJ/fw0
         MbTbH1cRTONZ8q6L1dKhtpSepFvol3AZraHxaDnR3p1EP8Q1MoamyHhK3oW0YacfgQj8
         rGOEDPUFnVKrpdfPOGpoBoU8LCcW2eXtgkRH+T5V2Hy/cKLVCXj5D0HR8ExuAaIHTLrl
         D4mnkdtbUifk0A5+HCHVMN43Z44gh8iPCXuhpPx8N9Axcmp1vLE8nnZ2L0iID8KogdLL
         SjVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718273; x=1784323073;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3ZedB0VQ1AWAm53tDDWxHLVghH418fWVIB0lX7U1LiE=;
        b=UT1+Vo/oNDlIZIQzEulMYjvSret/pNiDdVbIdK+VQKR6zT8ujbEZO8sp/KpNnR3yR5
         qiyYwPgugnmrZ5TRGSglcWiTeM4VnPEHnEnQObqvswdu4srYPVXR/lq3IsuIvRd6qEaR
         qWFMEIwzxj8B90AJnwJkHJ4zmaV+KjzzEgZwQ0FOQUkyxZ43mRkfmuNTTQUX3vZ7/C1E
         TZK/RAC3EAkuVcEYMyetS96A/P0rhJc6bBRHtNuJOxRRXskapEKGD6h2fopsdqVLT/RG
         LuNreSz/Ot5nMLO1gv+Mtmtf/jWj2Px6XjiKEtXdxW2XioYCVnkeo6OVvngz3XmFnjnd
         F4Kw==
X-Forwarded-Encrypted: i=1; AHgh+RpxaN7tCYJfUIQdyV2Hluvxgujb0829qdLGlWiyYTndXPqLl+Z29x0WznHu+ys0xOs3fxB+VoU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwG4kL1Snp9CDRS2LZA821Tyoaw/PY9mMrn8ZoQ4az4aWSPn5QI
	Xd5ERfA98xHOBOgJ3THi9SWLG1xuP0iW/XLEFkzrePuKHuF0S68f0WPjtNau/R3nybY=
X-Gm-Gg: AfdE7cmPWDbiHP2NDtaeXah66pu8W+cvoENgrNM9rXX2ssl9cjSjAYf5PTpjC7bEs2p
	O3v/5767pvwgjkbKjXDWvyX97ELwBEwsGiCvGUCAecwcpZAxAC670tRbyDu272BL2htOswuZtr8
	5H109uTT+EVxsicjTdcHqpLvPlTu/K5Z0VYVBQcKrnZj4Duri0b2guWU5pSpJxIUMehTzJHx0j3
	r0UI1rUDQ+BRapRXrsk1cprNdjywVoE6n9q+okt0RmaCBLbymPl28Ihb1EAvbQbRX/t6m3CEp5k
	R2suZ+qtd/Z8qygJH3vQV8H0jpQtoS0129SlXeN9LlQZ07A6KjiniPIkbk7ppqvRz151hKeYAQF
	f3stOLqPi5p9Q/MKyaJWHT2OsOKTahbPpJJjcPXvnu0J12WoL1lxiRA4cYq/a2eH30VxceQ0dHE
	jroDTJsfa//nkDe637qGAEvia61NXNrFqBXh7W8H5ER+fo/Zequ/Qd3e0f4pCGj/vFd/0UmVai0
	63nanE=
X-Received: by 2002:a05:620a:40d3:b0:92e:7afc:93ed with SMTP id af79cd13be357-92ef2d03c09mr108964985a.71.1783718273295;
        Fri, 10 Jul 2026 14:17:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5b4b1bbsm292932185a.2.2026.07.10.14.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:17:51 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:17:45 -0400
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
	James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	iommu@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 23/33] mm/vma: add and use vma_[add/sub]_pgoff()
Message-ID: <alFheaAGWCIAjom-@gourry-fedora-PF4VCD3F>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-23-2a5aa403d977@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-23-2a5aa403d977@kernel.org>

On Fri, Jul 10, 2026 at 09:17:04PM +0100, Lorenzo Stoakes wrote:
> Add helpers for adding or subtracting to a VMA's page offset, exposed
> internally for VMA users within mm in mm/vma.h.
> 
> This is to lay the foundations for tracking anonymous page offset for
> MAP_PRIVATE file-backed mappings, where adding and subtracting from this
> value must be reflected in both the file and anonymous offsets.
> 
> These are used on VMA split and downward stack expansion.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Carrying over from v1

Reviewed-by: Gregory Price <gourry@gourry.net>
