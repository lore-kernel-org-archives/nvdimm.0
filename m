Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1440024484-26152-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1440024484-26152-1-git-send-email-ross.zwisler@linux.intel.com>
Date: Wed, 19 Aug 2015 16:06:51 -0700
Message-ID: <CAPcyv4ifZgaQfskPQFGQNhVtnUfkh-Q2au0GjRDYTO60r4F0-g@mail.gmail.com>
Subject: Re: [PATCH v2] nd_blk: add support for "read flush" DSM flag
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Luis R. Rodriguez" <mcgrof@suse.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Christoph Hellwig <hch@lst.de>, Christoph Jaeger <cj@linux.com>, Dan Streetman <ddstreet@ieee.org>, Ingo Molnar <mingo@redhat.com>, Juergen Gross <jgross@suse.com>, Len Brown <lenb@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stephen Rothwell <sfr@canb.auug.org.au>, Thierry Reding <treding@nvidia.com>, Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>, Vishal Verma <vishal.l.verma@intel.com>, Will Deacon <will.deacon@arm.com>, Yalin Wang <Yalin.Wang@sonymobile.com>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 19, 2015 at 3:48 PM, Ross Zwisler
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
> Cc: Dan Williams <dan.j.williams@intel.com>
[..]
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index 7c2638f..56fff01 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
[..]
>  static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
> @@ -1078,11 +1078,16 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
>                 }
>
>                 if (rw)
> -                       memcpy_to_pmem(mmio->aperture + offset,
> +                       memcpy_to_pmem(mmio->addr.aperture + offset,
>                                         iobuf + copied, c);
> -               else
> +               else {
> +                       if (nfit_blk->dimm_flags & ND_BLK_READ_FLUSH)
> +                               mmio_flush_range((void __force *)
> +                                       mmio->addr.aperture + offset, c);
> +
>                         memcpy_from_pmem(iobuf + copied,
> -                                       mmio->aperture + offset, c);
> +                                       mmio->addr.aperture + offset, c);
> +               }

Why is the flush inside the "while (len)" loop?  I think it should be
done immediately after the call to write_blk_ctl() since that is the
point at which the aperture becomes invalidated, and not prior to each
read within a given aperture position.  Taking it a bit further, we
may be writing the same address into the control register as was there
previously so we wouldn't need to flush in that case.
