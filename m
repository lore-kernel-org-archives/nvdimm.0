Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1439585008-30192-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1439585008-30192-1-git-send-email-ross.zwisler@linux.intel.com>
Date: Fri, 14 Aug 2015 14:05:23 -0700
Message-ID: <CAPcyv4jxw5rP2UoBF5gKW4tWtcKCj6Z0iXqwbWSCNv9TpjRGEQ@mail.gmail.com>
Subject: Re: [PATCH] nd_blk: add support for "read flush" DSM flag
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Jaeger <cj@linux.com>, Juergen Gross <jgross@suse.com>, X86 ML <x86@kernel.org>, Yalin Wang <Yalin.Wang@sonymobile.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Will Deacon <will.deacon@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux ACPI <linux-acpi@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Russell King <rmk+kernel@arm.linux.org.uk>, Borislav Petkov <bp@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Dan Streetman <ddstreet@ieee.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 14, 2015 at 1:43 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Add support for the "read flush" _DSM flag, as outlined in the DSM spec:
>
> http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf
>
> This flag tells the ND BLK driver that it needs to flush the cache lines
> associated with the aperture after the aperture is moved but before any
> new data is read.  This ensures that any stale cache lines from the
> previous contents of the aperture will be discarded from the processor
> cache, and the new data will be read properly from the DIMM.  We know
> that the cache lines are clean and will be discarded without any
> writeback because either a) the previous aperture operation was a read,
> and we never modified the contents of the aperture, or b) the previous
> aperture operation was a write and we must have written back the dirtied
> contents of the aperture to the DIMM before the I/O was completed.
>
> By supporting the "read flush" flag we can also change the ND BLK
> aperture mapping from write-combining to write-back via memremap().
>
> In order to add support for the "read flush" flag I needed to add a
> generic routine to invalidate cache lines, mmio_flush_range().  This is
> protected by the ARCH_HAS_MMIO_FLUSH Kconfig variable, and is currently
> only supported on x86.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  arch/x86/Kconfig                  |  1 +
>  arch/x86/include/asm/cacheflush.h |  2 ++
>  drivers/acpi/Kconfig              |  1 +
>  drivers/acpi/nfit.c               | 55 ++++++++++++++++++++++-----------------
>  drivers/acpi/nfit.h               | 16 ++++++++----
>  lib/Kconfig                       |  3 +++
>  6 files changed, 49 insertions(+), 29 deletions(-)
>
[..]
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index 628a42c..816c778 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
[..]
> @@ -1206,20 +1214,19 @@ static void __iomem *__nfit_spa_map(struct acpi_nfit_desc *acpi_desc,
>         if (!res)
>                 goto err_mem;
>
> -       if (type == SPA_MAP_APERTURE) {
> -               /*
> -                * TODO: memremap_pmem() support, but that requires cache
> -                * flushing when the aperture is moved.
> -                */
> -               spa_map->iomem = ioremap_wc(start, n);
> -       } else
> -               spa_map->iomem = ioremap_nocache(start, n);
> +       spa_map->type = type;
> +       if (type == SPA_MAP_APERTURE)
> +               spa_map->addr.aperture = (void __pmem *)memremap(start, n,
> +                                                               MEMREMAP_WB);

This should be s/MEMREMAP_WB/ARCH_MEMREMAP_PMEM/, but other than that
looks good to me.

I also should go move ARCH_MEMREMAP_PMEM over to
arch/x86/include/asm/pmem.h and fold it in to your other pending
pmem-api cleanups.
