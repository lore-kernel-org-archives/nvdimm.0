Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1440094654.30197.8.camel@linux.intel.com>
Subject: Re: [PATCH v2] nd_blk: add support for "read flush" DSM flag
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Thu, 20 Aug 2015 12:17:34 -0600
In-Reply-To: <CAPcyv4itBu=-WSzt03L3C1n+BxcLGtePuEEcdwBxk=kx0Mnqjw@mail.gmail.com>
References: <1440024484-26152-1-git-send-email-ross.zwisler@linux.intel.com>
	 <CAPcyv4ifZgaQfskPQFGQNhVtnUfkh-Q2au0GjRDYTO60r4F0-g@mail.gmail.com>
	 <1440089067.30197.3.camel@linux.intel.com>
	 <CAPcyv4itBu=-WSzt03L3C1n+BxcLGtePuEEcdwBxk=kx0Mnqjw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Luis R. Rodriguez" <mcgrof@suse.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Christoph Hellwig <hch@lst.de>, Christoph Jaeger <cj@linux.com>, Dan Streetman <ddstreet@ieee.org>, Ingo Molnar <mingo@redhat.com>, Juergen Gross <jgross@suse.com>, Len Brown <lenb@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stephen Rothwell <sfr@canb.auug.org.au>, Thierry Reding <treding@nvidia.com>, Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>, Vishal Verma <vishal.l.verma@intel.com>, Will Deacon <will.deacon@arm.com>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2015-08-20 at 10:59 -0700, Dan Williams wrote:
> On Thu, Aug 20, 2015 at 9:44 AM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > On Wed, 2015-08-19 at 16:06 -0700, Dan Williams wrote:
> >> On Wed, Aug 19, 2015 at 3:48 PM, Ross Zwisler
> >> <ross.zwisler@linux.intel.com> wrote:
> >> > Add support for the "read flush" _DSM flag, as outlined in the DSM spec:
> >> >
> >> > http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf
> >> >
> >> > This flag tells the ND BLK driver that it needs to flush the cache lines
> >> > associated with the aperture after the aperture is moved but before any
> >> > new data is read.  This ensures that any stale cache lines from the
> >> > previous contents of the aperture will be discarded from the processor
> >> > cache, and the new data will be read properly from the DIMM.  We know
> >> > that the cache lines are clean and will be discarded without any
> >> > writeback because either a) the previous aperture operation was a read,
> >> > and we never modified the contents of the aperture, or b) the previous
> >> > aperture operation was a write and we must have written back the dirtied
> >> > contents of the aperture to the DIMM before the I/O was completed.
> >> >
> >> > By supporting the "read flush" flag we can also change the ND BLK
> >> > aperture mapping from write-combining to write-back via memremap().
> >> >
> >> > In order to add support for the "read flush" flag I needed to add a
> >> > generic routine to invalidate cache lines, mmio_flush_range().  This is
> >> > protected by the ARCH_HAS_MMIO_FLUSH Kconfig variable, and is currently
> >> > only supported on x86.
> >> >
> >> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> >> > Cc: Dan Williams <dan.j.williams@intel.com>
> >> [..]
> >> > diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> >> > index 7c2638f..56fff01 100644
> >> > --- a/drivers/acpi/nfit.c
> >> > +++ b/drivers/acpi/nfit.c
> >> [..]
> >> >  static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
> >> > @@ -1078,11 +1078,16 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
> >> >                 }
> >> >
> >> >                 if (rw)
> >> > -                       memcpy_to_pmem(mmio->aperture + offset,
> >> > +                       memcpy_to_pmem(mmio->addr.aperture + offset,
> >> >                                         iobuf + copied, c);
> >> > -               else
> >> > +               else {
> >> > +                       if (nfit_blk->dimm_flags & ND_BLK_READ_FLUSH)
> >> > +                               mmio_flush_range((void __force *)
> >> > +                                       mmio->addr.aperture + offset, c);
> >> > +
> >> >                         memcpy_from_pmem(iobuf + copied,
> >> > -                                       mmio->aperture + offset, c);
> >> > +                                       mmio->addr.aperture + offset, c);
> >> > +               }
> >>
> >> Why is the flush inside the "while (len)" loop?  I think it should be
> >> done immediately after the call to write_blk_ctl() since that is the
> >> point at which the aperture becomes invalidated, and not prior to each
> >> read within a given aperture position.  Taking it a bit further, we
> >> may be writing the same address into the control register as was there
> >> previously so we wouldn't need to flush in that case.
> >
> > The reason I was doing it in the "while (len)" loop is that you have to walk
> > through the interleave tables, reading each segment until you have read 'len'
> > bytes.  If we were to invalidate right after the write_blk_ctl(), we would
> > essentially have to re-create the "while (len)" loop, hop through all the
> > segments doing the invalidation, then run through the segments again doing the
> > actual I/O.
> >
> > It seemed a lot cleaner to just run through the segments once, invalidating
> > and reading each segment individually.
> 
> I agree it's cleaner if it is considering the de-interleave, but why
> consider interleave at all?  In other words just flush the entire
> aperture unconditionally.  Regardless of whether it reads all of the
> aperture it is indeed invalid because the aperture has moved.  I'm not
> seeing the benefit of being careful to let stale data stay in the
> cache a bit longer.

Ah, I think we're getting confused about the deinterleave part.

The aperture is a set of contiguous addresses from the perspective of the
DIMM, but when it's interleaved by the iMC it becomes a bunch of segments that
are not contiguous in the virtual address space of the kernel.

Meaning, say you have an 8k aperture that is interleaved with one other DIMM
on a 256 byte granularity - this means that in SPA space you'll end up with a
big mesh of 256 byte chunks, half of which belong to you and half which don't:

SPA space:
+--------------------+
|256 bytes (ours)    |
+--------------------+
|256 bytes (not ours)|
+--------------------+
|256 bytes (ours)    |
+--------------------+
|256 bytes (not ours)|
+--------------------+
...

To be able to flush the entire aperture unconditionally, we have to walk
through all the segments that belong to use and flush each one of them.  I
don't think we want to blindly flush the entire interleaved space because a)
the other chunks are some other DIMMs' apertures, and b) we'd be flushing 2x
or more (depending on how many DIMMs are interleaved) the space we need, one
cache line at a time.

I really think we do need to walk through the chunks and to targeted flushing
- the only question is whether we do a single pass and live with extra
intermediate memory barriers, or whether we do 2 passes and have a memory
barrier in between.


