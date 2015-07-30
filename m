Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 30 Jul 2015 23:02:04 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v3 05/24] arch: introduce memremap()
Message-ID: <20150730210204.GQ30479@wotan.suse.de>
References: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150730165407.33962.79603.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150730165407.33962.79603.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com, linux-arch@vger.kernel.org, toshi.kani@hp.com, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 30, 2015 at 12:54:07PM -0400, Dan Williams wrote:
> diff --git a/include/linux/io.h b/include/linux/io.h
> index fb5a99800e77..3fcf6256c088 100644
> --- a/include/linux/io.h
> +++ b/include/linux/io.h
> @@ -121,4 +121,13 @@ static inline int arch_phys_wc_index(int handle)
>  #endif
>  #endif
>  
> +enum {
> +	/* See memremap() kernel-doc for usage description... */
> +	MEMREMAP_WB = 1 << 0,
> +	MEMREMAP_WT = 1 << 1,
> +};

Same feedback for enum nameing and also kdoc style.

> diff --git a/kernel/memremap.c b/kernel/memremap.c
> new file mode 100644
> index 000000000000..27637f42f30d
> --- /dev/null
> +++ b/kernel/memremap.c

<-- ... -->

> +/**
> + * memremap() - remap an iomem_resource as cacheable memory
> + * @offset: iomem resource start address
> + * @size: size of remap
> + * @flags: either MEMREMAP_WB or MEMREMAP_WT
> + *
> + * memremap() is "ioremap" for cases where it is known that the resource
> + * being mapped does not have i/o side effects and the __iomem
> + * annotation is not applicable.
> + *
> + * MEMREMAP_WB - matches the default mapping for "System RAM" on
> + * the architecture.  This is usually a read-allocate write-back cache.
> + * Morever, if MEMREMAP_WB is specified and the requested remap region is RAM
> + * memremap() will bypass establishing a new mapping and instead return
> + * a pointer into the direct map.
> + *
> + * MEMREMAP_WT - establish a mapping whereby writes either bypass the
> + * cache or are written through to memory and never exist in a
> + * cache-dirty state with respect to program visibility.  Attempts to
> + * map "System RAM" with this mapping type will fail.

Then you can extrend all this on kdoc on the enum.

> + */
> +void *memremap(resource_size_t offset, size_t size, unsigned long flags)
> +{
> +	int is_ram = region_intersects(offset, size, "System RAM");

This could be the enum region_intersect_type, then if the region enum is
extended you'd get a compiler error if one type was not handled.

  Luis
