Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1440105339.30197.11.camel@linux.intel.com>
Subject: Re: [PATCH v2] nd_blk: add support for "read flush" DSM flag
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Thu, 20 Aug 2015 15:15:39 -0600
In-Reply-To: <CAPcyv4iZb4ot2nEn5DJ+19wF-ZiWk=fKb41mehd6Pv0buGRxJQ@mail.gmail.com>
References: <1440024484-26152-1-git-send-email-ross.zwisler@linux.intel.com>
	 <CAPcyv4ifZgaQfskPQFGQNhVtnUfkh-Q2au0GjRDYTO60r4F0-g@mail.gmail.com>
	 <1440089067.30197.3.camel@linux.intel.com>
	 <CAPcyv4itBu=-WSzt03L3C1n+BxcLGtePuEEcdwBxk=kx0Mnqjw@mail.gmail.com>
	 <1440094654.30197.8.camel@linux.intel.com>
	 <CAPcyv4iSJ8e3mgiMb3cG_NEW4VqmuWhHdL2v4Os_xiPSgGLmCg@mail.gmail.com>
	 <1440097210.30197.9.camel@linux.intel.com>
	 <CAPcyv4iZb4ot2nEn5DJ+19wF-ZiWk=fKb41mehd6Pv0buGRxJQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Luis R. Rodriguez" <mcgrof@suse.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Christoph Hellwig <hch@lst.de>, Christoph Jaeger <cj@linux.com>, Dan Streetman <ddstreet@ieee.org>, Ingo Molnar <mingo@redhat.com>, Juergen Gross <jgross@suse.com>, Len Brown <lenb@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stephen Rothwell <sfr@canb.auug.org.au>, Thierry Reding <treding@nvidia.com>, Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>, Vishal Verma <vishal.l.verma@intel.com>, Will Deacon <will.deacon@arm.com>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2015-08-20 at 13:27 -0700, Dan Williams wrote:
[...]
> With regards to the fencing, since we already take care to flush
> writes we don't need to fence at all for the flush, right?  All we
> care about is that reads see valid data.

We were careful to flush writes, but we could still have (now stale) data in
the cache either due to a previous read or because of prefetching.  So we
need to flush, and we need to fence to make sure that our flushing stays
correctly ordered with respect to our reads.

So, to recap, I think are options are:

a)
	loop through aperture segments, flushing each without any fencing
	mb() to order all the flushes
	loop through aperture segments, doing the reads

b)
	loop through aperture segments
		flushing segment with mb() fencing
		read the new data for this segment from the DIMM
	
Option b) is what is already implemented and is cleaner, but option a) has the
benefit of having many fewer fences.


