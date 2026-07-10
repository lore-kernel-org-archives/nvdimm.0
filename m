Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A639D3803C8
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 18:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783709753; cv=none; b=elSvaN9mt9VUyOSGMmwUmIW1cdUp/CxKKdzrc4op4wvSUND3qazNX5UByDi5w5ad04cKY6OSnHb7QdJV4P+/2kLxHNg0Mfc77WuS6e8jYQuwyc1k6Z4Rhsst2RGI+jqmCACnmD+j+UQtdeu3sLMgfN8Z5vlRiRwqPJkAb7D5j9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783709753; c=relaxed/simple;
	bh=q8904xmXb7eGsUOPUyRn/bldwzD5EC9W3Q3lWVe9IXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NtCJQfw9vqGHgrgRySN8vplRgRsszy7HzjFONAhxgUdp9YVQROkSZBp4MG0k0Dig3g9i8NfCooccDRSu34GXujbQjLQ4LEdAUHbetb42BB99f/eZKVdOWJMVKtmYbWtovi+UcuhGMXeWpj1GSitufpL3riaA+yYWLUKe+wjrgps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Keptb9vs; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Keptb9vs"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51bfb91795eso8305561cf.1
        for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 11:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783709751; x=1784314551; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=35hzoYcsWEd72Qin3ApbTs4xBItRwQ29eotWM9K9y9M=;
        b=Keptb9vsCXdhhFTQhJhT33ohVbOJox1NhScoAhCPQduwA0K6Wx2nsZ2RGeW1hWKZM5
         J0rcp70YOLIvLlA2bpoXPyIQAu8ZrDN9Nl1czzD3hCx8Qtop5DhEnXsSX7mxLWRIkQOw
         2jrrKZ3EOfuL2z72Ip+DiIlKtDQQ2Ys5aLPPoNtHTr/fqXVxq2ueC/AaZDI2NSM5ljBT
         CxN4bD4oGMMJmGYzQsHHvIe4TX+3EbHjulZ3Zq/xpJMS7BX0ga+K/KWvR6bV6ozpsIlD
         4naBCOvDPpJWF8D6wWemDgHeHTdX30zpvyacAso1Pf13MVcma21gAeiiHoQ5qG5dttTF
         doDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783709751; x=1784314551;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=35hzoYcsWEd72Qin3ApbTs4xBItRwQ29eotWM9K9y9M=;
        b=P07oAvNrOHSyfS5KIV1xbsmsyUmoGnM8IkH8RqJcbi/IDOeh1A+DOuBfTiMBKuk1Ix
         C62OYXHAXOe39r5MUI2xoKu2RGyMGREm2jO1KLCDFhwIkCpj4kE6ggV0v491l/Gm8QJ8
         TqpChYXaeBt9rOg/gJSmhbB174Cbbp6nLpC1QiIEFvRyTsw+RyC31pYKl957Cu9d0p6S
         cYEJ84E77SPcw4ZFCOcZRx3UI5ktEvcon+1FmZXnrhqUTU7X+jKYkY7x0x+2mKwaKweI
         fnIptyOEaMXNf3c6gF4dSCPVWsHGq9c4rxWZQnbOG+rzeqFqK8vg8PG4ERXcFb+Lmigj
         bNtw==
X-Forwarded-Encrypted: i=1; AHgh+Rpotce288RhoNRIU+tI6o9hlfzYHJy1kT3V/0SINW4a71xzbnrs0mIAJj7DPrEJqC0FeFBrf3Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPIoyiNKVih8Irp9SiJP8RLlFIwbG9HFD4d24mQp9Hpr4BkgPS
	Bo5hqoElSP18A+jb8iIk4ykAe99ahhaiBGB6ZecTtgjEDDksSoxEJnALjwIUNbqDVfk=
X-Gm-Gg: AfdE7clZzQEaanWqm9AsPcnUiXt6Aqmru7CsBWQQQJsIFWxey0RCLjBny+1lH/5uoiH
	uRcBVM4ev9d4eBETuFo7Iame2gaWGje2tC0kUWkW5gEsLuWu5sqWU8UvfvMCwE9lM2e+0IInlvi
	rqNZfhj0HYj0bQCTqkEn6E3qewnaWGmuqswqYJ/aKH5AkXY+hixMw0DOc1s4FDm5AQc0o/FLyEj
	YQBmxHfnNpPVnFwrxZPY1hD5mthtoALPjq7u91IpmLcjSqmagAinJprrLeQy5pcIVRTOmWiy5Al
	sYzL022MmGP/yL4r/gbnYKCliGiW0dToCtUpQx2/7L/XtDPAyiNzCU/yOjd+0jPQ3n8FQsBdQQj
	0H3gquUg2/xSPiHHx8U5h6oTWbJaxIvuuHP3uJNpQRu0OOPoKvQYW/rPU59RP4UpBccLY7wj7un
	bYcbR1UInagRpoeLK97hZTDrWOsnaAtI8XI7HyuSWXBZvKnlIBEd/wDoabq7FOymQ6KKq4
X-Received: by 2002:ac8:6112:0:b0:51a:f94e:ce51 with SMTP id d75a77b69052e-51cbf1fb386mr1548881cf.50.1783709750657;
        Fri, 10 Jul 2026 11:55:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caace31a4sm22925021cf.12.2026.07.10.11.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 11:55:50 -0700 (PDT)
Date: Fri, 10 Jul 2026 14:55:45 -0400
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
Subject: Re: [PATCH 06/30] mm/rmap: parameterise vma_interval_tree_*() by
 address_space
Message-ID: <alFAMZNiJvxNpzGF@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <43050b10b53cdfc3627440e6b14ae2a9730b2a5c.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43050b10b53cdfc3627440e6b14ae2a9730b2a5c.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:17PM +0100, Lorenzo Stoakes wrote:
> The file-backed mapping interval tree functions vma_interval_tree_*()
> accept a raw rb_root_cached pointer to determine the tree in which they are
> operating.
> 
> However, in each case, this is always associated with an address_space data
> type.
> 
> So simply pass a pointer to that instead to simplify the code, and more
> clearly differentiate between these operations and those concerning
> anonymous mappings.
> 
> While we're here, make the generated interval tree functions static as they
> do not need to be used externally (any previously existing external users
> have now been removed).
> 
> We also rename VMA parameters from 'node' to 'vma' as calling this a node
> is simply confusing, update the input index types to pgoff_t since they
> reference page offsets and rename the parameters to pgoff_start and
> pgoff_last.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

nice

Reviewed-by: Gregory Price <gourry@gourry.net>

