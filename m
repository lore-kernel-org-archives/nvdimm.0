Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1440089067.30197.3.camel@linux.intel.com>
Subject: Re: [PATCH v2] nd_blk: add support for "read flush" DSM flag
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Thu, 20 Aug 2015 10:44:27 -0600
In-Reply-To: <CAPcyv4ifZgaQfskPQFGQNhVtnUfkh-Q2au0GjRDYTO60r4F0-g@mail.gmail.com>
References: <1440024484-26152-1-git-send-email-ross.zwisler@linux.intel.com>
	 <CAPcyv4ifZgaQfskPQFGQNhVtnUfkh-Q2au0GjRDYTO60r4F0-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Luis R. Rodriguez" <mcgrof@suse.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Christoph Hellwig <hch@lst.de>, Christoph Jaeger <cj@linux.com>, Dan Streetman <ddstreet@ieee.org>, Ingo Molnar <mingo@redhat.com>, Juergen Gross <jgross@suse.com>, Len Brown <lenb@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stephen Rothwell <sfr@canb.auug.org.au>, Thierry Reding <treding@nvidia.com>, Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>, Vishal Verma <vishal.l.verma@intel.com>, Will Deacon <will.deacon@arm.com>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2015-08-19 at 16:06 -0700, Dan Williams wrote:
> On Wed, Aug 19, 2015 at 3:48 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > Add support for the "read flush" _DSM flag, as outlined in the DSM spec:
> >
> > http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf
> >
> > This flag tells the ND BLK driver that it needs to flush the cache lines
> > associated with the aperture after the aperture is moved but before any
> > new data is read.  This ensures that any stale cache lines from the
> > previous contents of the aperture will be discarded from the processor
> > cache, and the new data will be read properly from the DIMM.  We know
> > that the cache lines are clean and will be discarded without any
> > writeback because either a) the previous aperture operation was a read,
> > and we never modified the contents of the aperture, or b) the previous
> > aperture operation was a write and we must have written back the dirtied
> > contents of the aperture to the DIMM before the I/O was completed.
> >
> > By supporting the "read flush" flag we can also change the ND BLK
> > aperture mapping from write-combining to write-back via memremap().
> >
> > In order to add support for the "read flush" flag I needed to add a
> > generic routine to invalidate cache lines, mmio_flush_range().  This is
> > protected by the ARCH_HAS_MMIO_FLUSH Kconfig variable, and is currently
> > only supported on x86.
> >
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> [..]
> > diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> > index 7c2638f..56fff01 100644
> > --- a/drivers/acpi/nfit.c
> > +++ b/drivers/acpi/nfit.c
> [..]
> >  static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
> > @@ -1078,11 +1078,16 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
> >                 }
> >
> >                 if (rw)
> > -                       memcpy_to_pmem(mmio->aperture + offset,
> > +                       memcpy_to_pmem(mmio->addr.aperture + offset,
> >                                         iobuf + copied, c);
> > -               else
> > +               else {
> > +                       if (nfit_blk->dimm_flags & ND_BLK_READ_FLUSH)
> > +                               mmio_flush_range((void __force *)
> > +                                       mmio->addr.aperture + offset, c);
> > +
> >                         memcpy_from_pmem(iobuf + copied,
> > -                                       mmio->aperture + offset, c);
> > +                                       mmio->addr.aperture + offset, c);
> > +               }
> 
> Why is the flush inside the "while (len)" loop?  I think it should be
> done immediately after the call to write_blk_ctl() since that is the
> point at which the aperture becomes invalidated, and not prior to each
> read within a given aperture position.  Taking it a bit further, we
> may be writing the same address into the control register as was there
> previously so we wouldn't need to flush in that case.

The reason I was doing it in the "while (len)" loop is that you have to walk
through the interleave tables, reading each segment until you have read 'len'
bytes.  If we were to invalidate right after the write_blk_ctl(), we would
essentially have to re-create the "while (len)" loop, hop through all the
segments doing the invalidation, then run through the segments again doing the
actual I/O.

It seemed a lot cleaner to just run through the segments once, invalidating
and reading each segment individually.

The bad news about the current approach is that we end up doing a bunch of
extra mb() fencing, twice per segment via clflush_cache_range().

The other option would be to do the double pass, but on the first pass to just
do the flushing without fencing, then fence everything, then do the reads.

I don't have a good feel for how much overhead all this extra fencing will be
vs the cost of traversing the segments twice.  The code is certainly simpler
with the way its implemented now.  If you feel that the extra fencing is too
expensive I'll implement it as a double-pass.  Otherwise we may want to wait
for performance data to justify the change.

Regarding skipping the flush if the control register is unchanged - sure, that
seems like a good idea.


