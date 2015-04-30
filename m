Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1430427390.23785.1.camel@theros.lm.intel.com>
Subject: Re: [PATCH v2 00/20] libnd: non-volatile memory device support
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Thu, 30 Apr 2015 14:56:30 -0600
In-Reply-To: <CALCETrVno_bWKzfzfEa_gQSCaS-u8QpgdeFCmvEvnxR-4L6HoQ@mail.gmail.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <CALCETrV0gE7j+OaJ+UrV=rANrTpALKX6MXFQs6GKAMe0rSxRRw@mail.gmail.com>
	 <CAPcyv4hMfTD9eEVD9NSG3DDT-_5d+BZHL=RHNMR8kh+iBd6FuQ@mail.gmail.com>
	 <CALCETrVJafaxJwZi1C8cAsQs51nvGFywAkNTNbc=BjE+bjBgnQ@mail.gmail.com>
	 <CAPcyv4jeV-4D+uJyjmBa8Zn5VC8LmTf2+eWj_CdVzcAWZvRrKg@mail.gmail.com>
	 <CALCETrVno_bWKzfzfEa_gQSCaS-u8QpgdeFCmvEvnxR-4L6HoQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, Neil Brown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, Christoph Hellwig <hch@lst.de>, Linux ACPI <linux-acpi@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2015-04-28 at 16:05 -0700, Andy Lutomirski wrote:
> On Tue, Apr 28, 2015 at 3:28 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On Tue, Apr 28, 2015 at 2:06 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >> On Tue, Apr 28, 2015 at 1:59 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> >>> On Tue, Apr 28, 2015 at 1:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >>>> On Tue, Apr 28, 2015 at 11:24 AM, Dan Williams <dan.j.williams@intel.com> wrote:

> >>>> Mostly for my understanding: is there a name for "address relative to
> >>>> the address lines on the DIMM"?  That is, a DIMM that exposes 8 GB of
> >>>> apparent physical memory, possibly interleaved, broken up, or weirdly
> >>>> remapped by the memory controller, would still have addresses between
> >>>> 0 and 8 GB.  Some of those might be PMEM windows, some might be MMIO,
> >>>> some might be BLK apertures, etc.
> >>>>
> >>>> IIUC "DPA" refers to actual addressable storage, not this type of address?
> >>>
> >>> No, DPA is exactly as you describe above.  You can't directly access
> >>> it except through a PMEM mapping (possibly interleaved with DPA from
> >>> other DIMMs) or a BLK aperture (mmio window into DPA).
> >>
> >> So the thing I'm describing has no name, then?  Oh, well.
> >
> > What?  The thing you are describing *is* DPA.
> 
> I'm confused.  Here are the two things I have in mind:
> 
> 1. An address into on-DIMM storage.  If I have a DIMM that is mapped
> to 8 GB of SPA but has 64 GB of usable storage (accessed through BLK
> apertures, say), then this address runs from 0 to 64 GB.
> 
> 2. An address into the DIMM's view of physical address space.  If I
> have a DIMM that is mapped to 8 GB of SPA but has 64 GB of usable
> storage (accessed through BLK apertures, say), then this address runs
> from 0 to 8 GB.  There's a one-to-one mapping between SPA and this
> type of address.
> 
> Since you said "a dimm may provide both PMEM-mode and BLK-mode access
> to a range of DPA.," I thought that DPA was #1.
> 
> --Andy

I think that you've got the right definition, #1 above, for DPA.  The DPA is
relative to the DIMM, knows nothing about interleaving or SPA or anything else
in the system, and is basically equivalent to the idea of an LBA on a disk.  A
DIMM that has 64 GiB of storage could have a DPA space ranging from 0 to 64
GiB.

The second concept is a little trickier - we've been talking about this by
using the term "N-way interleave set".  Say you have your 64 GiB DIMM and only
the first 8 GiB are given to the OS in an SPA, and that DIMM isn't interleaved
with any other DIMMs.  This would be a 1-way interleave set, ranging from DPA
0 - 8GiB on the DIMM.

If you have 2 DIMMs of size 64 GiB, and they each have a 8 GiB region given to
the SPA space, those two regions could be interleaved together.  The OS would
then see a 16 GiB 2-way interleave set, made up of DPAs 0 -> 8 GiB on each of
the two DIMMs.

You can figure out exactly how all the interleaving works by looking at the
SPA tables, the Memory Device tables and the Interleave Tables.

These are in sections 5.2.25.1 - 5.2.25.3 in ACPI 6, and are in our code as
struct acpi_nfit_spa, struct acpi_nfit_memdev and struct acpi_nfit_idt.

- Ross


