Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1440097210.30197.9.camel@linux.intel.com>
Subject: Re: [PATCH v2] nd_blk: add support for "read flush" DSM flag
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Thu, 20 Aug 2015 13:00:10 -0600
In-Reply-To: <CAPcyv4iSJ8e3mgiMb3cG_NEW4VqmuWhHdL2v4Os_xiPSgGLmCg@mail.gmail.com>
References: <1440024484-26152-1-git-send-email-ross.zwisler@linux.intel.com>
	 <CAPcyv4ifZgaQfskPQFGQNhVtnUfkh-Q2au0GjRDYTO60r4F0-g@mail.gmail.com>
	 <1440089067.30197.3.camel@linux.intel.com>
	 <CAPcyv4itBu=-WSzt03L3C1n+BxcLGtePuEEcdwBxk=kx0Mnqjw@mail.gmail.com>
	 <1440094654.30197.8.camel@linux.intel.com>
	 <CAPcyv4iSJ8e3mgiMb3cG_NEW4VqmuWhHdL2v4Os_xiPSgGLmCg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Luis R. Rodriguez" <mcgrof@suse.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Christoph Hellwig <hch@lst.de>, Christoph Jaeger <cj@linux.com>, Dan Streetman <ddstreet@ieee.org>, Ingo Molnar <mingo@redhat.com>, Juergen Gross <jgross@suse.com>, Len Brown <lenb@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stephen Rothwell <sfr@canb.auug.org.au>, Thierry Reding <treding@nvidia.com>, Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>, Vishal Verma <vishal.l.verma@intel.com>, Will Deacon <will.deacon@arm.com>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2015-08-20 at 11:26 -0700, Dan Williams wrote:
> On Thu, Aug 20, 2015 at 11:17 AM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > On Thu, 2015-08-20 at 10:59 -0700, Dan Williams wrote:
> [..]
> > Ah, I think we're getting confused about the deinterleave part.
> >
> > The aperture is a set of contiguous addresses from the perspective of the
> > DIMM, but when it's interleaved by the iMC it becomes a bunch of segments that
> > are not contiguous in the virtual address space of the kernel.
> >
> > Meaning, say you have an 8k aperture that is interleaved with one other DIMM
> > on a 256 byte granularity - this means that in SPA space you'll end up with a
> > big mesh of 256 byte chunks, half of which belong to you and half which don't:
> >
> > SPA space:
> > +--------------------+
> > |256 bytes (ours)    |
> > +--------------------+
> > |256 bytes (not ours)|
> > +--------------------+
> > |256 bytes (ours)    |
> > +--------------------+
> > |256 bytes (not ours)|
> > +--------------------+
> > ...
> >
> > To be able to flush the entire aperture unconditionally, we have to walk
> > through all the segments that belong to use and flush each one of them.  I
> > don't think we want to blindly flush the entire interleaved space because a)
> > the other chunks are some other DIMMs' apertures, and b) we'd be flushing 2x
> > or more (depending on how many DIMMs are interleaved) the space we need, one
> > cache line at a time.
> 
> I am indeed proposing flushing other DIMMs because those ranges are
> invalidated by the aperture moving.  This is based on the assumption
> that the flushing is cheaper in the case when no dirty-lines are
> found.  The performance gains of doing piecemeal flushes seems not
> worth the complexity.

Why are the segments belonging to other apertures invalidated because we have
moved our aperture?  They are all independent cache lines (segments must be a
multiple of the cache line size), and the other apertures might be in the
middle of some other I/O operation on some other CPU that we know nothing
about.



