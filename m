Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 11 Aug 2015 14:55:56 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 08/10] pmem: convert to generic memremap
Message-ID: <20150811125556.GD3402@lst.de>
References: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com> <20150811033833.4987.62222.stgit@otcpl-bsw-rvp-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150811033833.4987.62222.stgit@otcpl-bsw-rvp-2.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, ross.zwisler@linux.intel.com, mcgrof@suse.com, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 10, 2015 at 11:38:33PM -0400, Dan Williams wrote:
> Update memremap_pmem() to query the architecture for the mapping type of
> the given persistent memory range  and then pass those flags to generic
> memremap().  arch_memremap_pmem_flags() is provided an address range to
> evaluate in the event an arch has a need for different mapping types by
> address range.  For example the ACPI NFIT carries EFI mapping types in
> its memory range description table.
> 
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks generally good, but a little nipick related to my comment
from two patches ago:

> +unsigned long arch_memremap_pmem_flags(resource_size_t offset, size_t size)
> +{
> +	/*
> +	 * The expectation is that pmem is always WB capable range on
> +	 * x86, i.e. no need to walk the range.
> +	 */
> +	return MEMREMAP_WB;
> +}
> +EXPORT_SYMBOL(arch_memremap_pmem_flags);

Why not just add a 

/*
 * The expectation is that pmem is always WB capable range on x86, i.e. no
 * need to walk the range.
 */
#define ARCH_MEMREMAP_PMEM	MEMREMAP_WB

in io.h, and then kill all these little pmem wrappers and:

>  static inline void __pmem *memremap_pmem(resource_size_t offset,
>  		unsigned long size)
>  {
> +	unsigned long flags;
> +
>  	if (arch_has_pmem_api())
> -		return arch_memremap_pmem(offset, size);
> -	return default_memremap_pmem(offset, size);
> +		flags = arch_memremap_pmem_flags(offset, size);
> +	else
> +		flags = default_memremap_pmem_flags();
> +
> +	return (void __pmem *) memremap(offset, size, flags);

#ifdef ARCH_MEMREMAP_PMEM
	return (void __pmem *) memremap(offset, size, ARCH_MEMREMAP_PMEM);
#else
	return (void __pmem *) memremap(offset, size, MEMREMAP_WT);
#endif

