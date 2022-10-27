Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA41146A6
	for <nvdimm@lists.linux.dev>; Thu, 27 Oct 2022 16:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666887506; x=1698423506;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mio/fM7+F8nVUXn2ZcQlynlshnIvyeSjm66BSTRpQzQ=;
  b=bz88LCtxT48j1UcxOUblNRNnBZAo/UwLB2t96JWTwM8nF/E/yRVaUcSC
   TBPDvDfPmiVSXqNKysnbOUGSrZJVSt8qlzgbjTpnnEhnVX1pPYGR7WZc7
   aXZbs2uLZMZ8HT5m93H8p2wO1sKL6XcLlbvJY549KU2VBzrqgZ+Ft+Z5H
   /JeE/GBZqurVTQI0+biBt9OOIFVAicnJowRT4LMBiweIiAJMIUa72oCoQ
   kNJ90aQEXkT8GfkUWUiH/vq81LL84noQSFCSFWi7bfZdLUstnB01nytAR
   HlIJA3TAi/etJYSAfGlQbFZEkV4qPV8mkgerMLwj/7YQf6On7lUNB88ON
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="309965842"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="309965842"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 09:18:16 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="701401909"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="701401909"
Received: from vstelter-mobl.amr.corp.intel.com (HELO [10.212.214.108]) ([10.212.214.108])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 09:18:15 -0700
Message-ID: <3ce6ef93-2f47-eda3-f974-0cfea7f43766@intel.com>
Date: Thu, 27 Oct 2022 09:18:13 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v4] memregion: Add cpu_cache_invalidate_memregion()
 interface
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Davidlohr Bueso <dave@stgolabs.net>, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <166672803035.2801111.9244172033971411169.stgit@dwillia2-xfh.jf.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <166672803035.2801111.9244172033971411169.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/25/22 13:05, Dan Williams wrote:
> Users must first call cpu_cache_has_invalidate_memregion() to know whether
> this functionality is available on the architecture. Only enable it on
> x86-64 via the wbinvd() hammer. Hypervisors are not supported as TDX
> guests may trigger a virtualization exception and may need proper handling
> to recover. See:
That sentence doesn't quite parse correctly.  Does it need to be "and
may trigger..."?

> This global cache invalidation facility,
> cpu_cache_invalidate_memregion(), is exported to modules since NVDIMM
> and CXL support can be built as a module. However, the intent is that
> this facility is not available outside of specific "device-memory" use
> cases. To that end the API is scoped to a new "DEVMEM" module namespace
> that only applies to the NVDIMM and CXL subsystems.

Oh, thank $DEITY you're trying to limit the amount of code that has
access to this thing.

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 67745ceab0db..b68661d0633b 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -69,6 +69,7 @@ config X86
>  	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
>  	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
>  	select ARCH_HAS_CACHE_LINE_SIZE
> +	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION  if X86_64

What is 64-bit only about this?

I don't expect to have a lot of NVDIMMs or CXL devices on 32-bit
kernels, but it would be nice to remove this if it's not strictly
needed.  Or, to add a changelog nugget that says:

	Restrict this to X86_64 kernels.  It would probably work on 32-
	bit, but there is no practical reason to use 32-bit kernels and
	no one is testing them.

>  	select ARCH_HAS_CURRENT_STACK_POINTER
>  	select ARCH_HAS_DEBUG_VIRTUAL
>  	select ARCH_HAS_DEBUG_VM_PGTABLE	if !X86_PAE
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 97342c42dda8..8650bb6481a8 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -330,6 +330,21 @@ void arch_invalidate_pmem(void *addr, size_t size)
>  EXPORT_SYMBOL_GPL(arch_invalidate_pmem);
>  #endif
>  
> +#ifdef CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> +bool cpu_cache_has_invalidate_memregion(void)
> +{
> +	return !cpu_feature_enabled(X86_FEATURE_HYPERVISOR);
> +}
> +EXPORT_SYMBOL_NS_GPL(cpu_cache_has_invalidate_memregion, DEVMEM);
> +
> +int cpu_cache_invalidate_memregion(int res_desc)
> +{
> +	wbinvd_on_all_cpus();
> +	return 0;
> +}

Does this maybe also deserve a:

	WARN_ON_ONCE(!cpu_cache_has_invalidate_memregion());

in case one of the cpu_cache_invalidate_memregion() paths missed a
cpu_cache_has_invalidate_memregion() check?

> +/**
> + * cpu_cache_invalidate_memregion - drop any CPU cached data for
> + *     memregions described by @res_desc
> + * @res_desc: one of the IORES_DESC_* types
> + *
> + * Perform cache maintenance after a memory event / operation that
> + * changes the contents of physical memory in a cache-incoherent manner.
> + * For example, device memory technologies like NVDIMM and CXL have
> + * device secure erase, or dynamic region provision features where such
> + * semantics.

s/where/with/ ?

> + * Limit the functionality to architectures that have an efficient way
> + * to writeback and invalidate potentially terabytes of memory at once.
> + * Note that this routine may or may not write back any dirty contents
> + * while performing the invalidation. It is only exported for the
> + * explicit usage of the NVDIMM and CXL modules in the 'DEVMEM' symbol
> + * namespace.
> + *
> + * Returns 0 on success or negative error code on a failure to perform
> + * the cache maintenance.
> + */

WBINVD is a scary beast.  But, there's also no better alternative in the
architecture.  I don't think any of my comments above are deal breakers,
so from the x86 side:

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
