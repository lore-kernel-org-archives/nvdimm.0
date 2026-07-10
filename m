Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0C0373C1A
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 19:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783711252; cv=none; b=dMGYlaFTA6jbaHO2XmTcoJ34mj4KE6jeh6tpQmAoRcS83047SKDwzjEhb+Z4pRyYnnb71qHXu4OQYqvtFtnIWpT3tnhKLBNQhkQzMsKOxt0Pdw4inOYtEYVTxdACte+0FBgCf0qHW5oFA8T/LQsvN3AYa4SwvJwg1HzBFfV2m1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783711252; c=relaxed/simple;
	bh=bX34iOgCjAyoyd0wtccoyCGEJ+0E8xtv6sAci2MgTt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NEqom7yhwacM6lJnYeDMsGltiChB+DS3WI8OLVMVx0yfiyE4Dp/Bd7VlPZYprM9p7CxBgXApkNQ2aB86q1sNpT5oiP4qeOv9usO638gYHALVXx0MH+dR5MOm1rpHUugEcME4pnigNL+iG+DhWc7x0UhiQYtSoFkvKasNctnnldA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=iBua4TSA; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="iBua4TSA"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e512a9a6bso63802685a.2
        for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 12:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783711249; x=1784316049; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xFW+QIJ4JFkYmnZudtxzUHG1gsom4gRJfGrSXFnz7n8=;
        b=iBua4TSAS//wSNT/iYnNkLO/R8RrfNspElN4wF9WqY7qT0Mpx3rwmxCpderOJo0fT5
         in5SO2XdyIF5baAh0PX8+4IeJk1EKemhFGKMv9TdPaJyqQs7w/yKccDmyyllgAsnEzET
         Ef6WO55pFhOiotVkqhAdigkmExMnjhCRrQgZRHM05tJggaCs4p7wfZK7fS22CxzNEJOg
         uVmWnITGWQo01MWJKram5xcePUPd8RVgJ1oMMulkxs1wHvJyPEWIAePmR6dtQuj3kxqN
         Xq/iVZMjcM15zIhZhUpo0miSAVZxnCzG7iIPs9WXCRPBSnsoXDDg12Y1JF0bLCb5RAD+
         /7Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783711249; x=1784316049;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xFW+QIJ4JFkYmnZudtxzUHG1gsom4gRJfGrSXFnz7n8=;
        b=Lcsd4+SmY3Yjkpa45LKwGj0iWwNQHwbuOfpp9hvbvakQmLEEBbs7jVAe/3KiIr2JlJ
         +WaP9jT7X5DEJ8d8gUf7tEWq7bM/HH+op0yEGjihP7GZsf7OVqFIjrvl9YnKNI8cQdSg
         lmZFOmhwN7vRNftd8Ce3v/ZSHxUinpiAPeWZuQjIaQtEz6Hxtfo+nLFxBnfnr873GulI
         uM8b7Zeaz3AKsb61Ruazm53HXlA9K5Scv9ZClEH3VB9azX4gpe3opgw0DpF08tMEvI0D
         JiQB1cfgtfdtGS7+7vvcbqchey6tN1ep3Gs4ckCqjOB/fPPsZMjcY2ygh3PpVSjjQXWL
         qDLQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr54EpIzorp8ouVFrg44HV7al0Sw6c5Dz5IVrlut2kcjeEUK+uzJ8UhZ+7QGhQ+4xHi+7QD3ZM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyD3m3Wh02r1mOkPSip9RXTtfD5dEYJlQgSlyG3xREbxaJULtp4
	dIqUXeihxw9cBniqeqS6dh97H4wenUcaguvnd5xQeGNMLXM3F0R7U+Qg0iTgT2Bwozc=
X-Gm-Gg: AfdE7cnJUipFN2+uedBYl0RO7egEbgHeC6poxbqGQrs/nV+pct66uQNGY1R4KDGUVAX
	1Ry/nSJVHd4fHpWSmGwWgGcmgQDwwjIXmg9nUAa2tEz8CXblXRKjGbWOrn/5jnj+SU3yL0uC2ji
	9ocH+zgctw/mGfFYiIbah9BQSpcYnQ8ZbKyVtCgFANlv4kOyCNRIfumElQ1AAXzoCq5+7XygV18
	yK66vZQCe1YKksMLDzGSs20ZNk33a6WGvPSmFUBpNCKdT9Xqhvn3fyknd3dTjiXXbjq1Pf3gfXv
	dBT9zizmy1XgaA3zEyyRFTt3rfeQC4UhcOKzCrt/des1KOrOYQ87zGnoZAcBjBaunMCG771w2FM
	Q9y6Ck/9S8pJcCj7oG4uwEi+sscrY6JK2YPX9yNhF5kDQPlsYiku5/KXZ6lWXiCdXlXdBcdfQ4x
	6xvnNQrXutCRvFGUAEDMkCanmg2Jx7AMS53FWSIzmd8tdXUh8TiRAypxh8skDmfPu8ydGi
X-Received: by 2002:a05:620a:44c3:b0:92e:c117:5ecd with SMTP id af79cd13be357-92ef2d107efmr56266185a.77.1783711249227;
        Fri, 10 Jul 2026 12:20:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5b8b3f2sm268883885a.13.2026.07.10.12.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 12:20:48 -0700 (PDT)
Date: Fri, 10 Jul 2026 15:20:43 -0400
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
Subject: Re: [PATCH 26/30] mm/vma: introduce and use vma_set_pgoff()
Message-ID: <alFGC3Vq-sbf56lV@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <37f4d951897641f304dba26f6f91ade03a50eb01.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37f4d951897641f304dba26f6f91ade03a50eb01.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:37PM +0100, Lorenzo Stoakes wrote:
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
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

