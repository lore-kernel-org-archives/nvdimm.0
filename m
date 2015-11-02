Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1446481854.24485.36.camel@perches.com>
Subject: Re: [PATCH v3 08/15] mm, dax, pmem: introduce pfn_t
From: Joe Perches <joe@perches.com>
Date: Mon, 02 Nov 2015 08:30:54 -0800
In-Reply-To: <20151102043025.6610.24022.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20151102043025.6610.24022.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@fb.com, Dave Hansen <dave@sr71.net>, jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, ross.zwisler@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Sun, 2015-11-01 at 23:30 -0500, Dan Williams wrote:
> For the purpose of communicating the optional presence of a 'struct
> page' for the pfn returned from ->direct_access(), introduce a type that
> encapsulates a page-frame-number plus flags.  These flags contain the
> historical "page_link" encoding for a scatterlist entry, but can also
> denote "device memory".  Where "device memory" is a set of pfns that are
> not part of the kernel's linear mapping by default, but are accessed via
> the same memory controller as ram.
> 
> The motivation for this new type is large capacity persistent memory
> that needs struct page entries in the 'memmap' to support 3rd party DMA
> (i.e. O_DIRECT I/O with a persistent memory source/target).  However, we
> also need it in support of maintaining a list of mapped inodes which
> need to be unmapped at driver teardown or freeze_bdev() time.
[]
> diff --git a/include/linux/mm.h b/include/linux/mm.h
[]
> +#define PFN_FLAGS_MASK (~PAGE_MASK << (BITS_PER_LONG - PAGE_SHIFT))
> +#define PFN_SG_CHAIN (1UL << (BITS_PER_LONG - 1))
> +#define PFN_SG_LAST (1UL << (BITS_PER_LONG - 2))
> +#define PFN_DEV (1UL << (BITS_PER_LONG - 3))
> +#define PFN_MAP (1UL << (BITS_PER_LONG - 4))
[]
> diff --git a/include/linux/pfn.h b/include/linux/pfn.h
[]
> @@ -3,6 +3,15 @@
[]
> + * pfn_t: encapsulates a page-frame number that is optionally backed
> + * by memmap (struct page).  Whether a pfn_t has a 'struct page'
> + * backing is indicated by flags in the high bits of the value.
> + */
> +typedef struct {
> +	unsigned long val;
> +} pfn_t;
>  #endif

Perhaps this would be more intelligible as an
anonymous union of bit-fields and unsigned long.


