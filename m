Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16025CA6
	for <nvdimm@lists.linux.dev>; Wed,  7 Sep 2022 16:05:28 +0000 (UTC)
Received: from nazgul.tnic (unknown [84.201.196.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E5A681EC068D;
	Wed,  7 Sep 2022 18:05:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1662566722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=jgNWsBoBSXWNUzswLsLjK+/VN0ef25YJ6b11A0o0dh0=;
	b=ANOb/YoU74sl6o8ATWokQlofsEAbLbhiPYAeFjTUgsqLPpTTN+Xg7YTj/sbMwziDtlHiLj
	zkyzmsYH9Cf717QwJJ+jyGCZR1VrjQR5xhii4Q+XC2+xR9XraxBXtETsVI7ZOGqDBv4i+T
	Vl4QrqyPsIM/ZmCvg2Dxrtx6hXRKJuU=
Date: Wed, 7 Sep 2022 18:05:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: dan.j.williams@intel.com, x86@kernel.org, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, peterz@infradead.org,
	akpm@linux-foundation.org, dave.jiang@intel.com,
	Jonathan.Cameron@huawei.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, a.manzanares@samsung.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] memregion: Add arch_flush_memregion() interface
Message-ID: <YxjBSxtoav7PQVei@nazgul.tnic>
References: <20220829212918.4039240-1-dave@stgolabs.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220829212918.4039240-1-dave@stgolabs.net>

On Mon, Aug 29, 2022 at 02:29:18PM -0700, Davidlohr Bueso wrote:
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 1abd5438f126..18463cb704fb 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -330,6 +330,20 @@ void arch_invalidate_pmem(void *addr, size_t size)
>  EXPORT_SYMBOL_GPL(arch_invalidate_pmem);
>  #endif
>  
> +#ifdef CONFIG_ARCH_HAS_MEMREGION_INVALIDATE
> +bool arch_has_flush_memregion(void)
> +{
> +	return !cpu_feature_enabled(X86_FEATURE_HYPERVISOR);

This looks really weird. Why does this need to care about HV at all?

Does that nfit stuff even run in guests?

> +EXPORT_SYMBOL(arch_has_flush_memregion);

...

> +EXPORT_SYMBOL(arch_flush_memregion);

Why aren't those exports _GPL?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
