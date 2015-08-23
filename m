Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1440105339.30197.11.camel@linux.intel.com>
References: <1440024484-26152-1-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4ifZgaQfskPQFGQNhVtnUfkh-Q2au0GjRDYTO60r4F0-g@mail.gmail.com>
	<1440089067.30197.3.camel@linux.intel.com>
	<CAPcyv4itBu=-WSzt03L3C1n+BxcLGtePuEEcdwBxk=kx0Mnqjw@mail.gmail.com>
	<1440094654.30197.8.camel@linux.intel.com>
	<CAPcyv4iSJ8e3mgiMb3cG_NEW4VqmuWhHdL2v4Os_xiPSgGLmCg@mail.gmail.com>
	<1440097210.30197.9.camel@linux.intel.com>
	<CAPcyv4iZb4ot2nEn5DJ+19wF-ZiWk=fKb41mehd6Pv0buGRxJQ@mail.gmail.com>
	<1440105339.30197.11.camel@linux.intel.com>
Date: Sat, 22 Aug 2015 18:59:50 -0700
Message-ID: <CAPcyv4hVMGmtc_OU5kj=Hqh=ySr_48XFhkfxUhvfh9jEH5HOXA@mail.gmail.com>
Subject: Re: [PATCH v2] nd_blk: add support for "read flush" DSM flag
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Luis R. Rodriguez" <mcgrof@suse.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Christoph Hellwig <hch@lst.de>, Christoph Jaeger <cj@linux.com>, Dan Streetman <ddstreet@ieee.org>, Ingo Molnar <mingo@redhat.com>, Juergen Gross <jgross@suse.com>, Len Brown <lenb@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stephen Rothwell <sfr@canb.auug.org.au>, Thierry Reding <treding@nvidia.com>, Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>, Vishal Verma <vishal.l.verma@intel.com>, Will Deacon <will.deacon@arm.com>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 20, 2015 at 2:15 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Thu, 2015-08-20 at 13:27 -0700, Dan Williams wrote:
> [...]
>> With regards to the fencing, since we already take care to flush
>> writes we don't need to fence at all for the flush, right?  All we
>> care about is that reads see valid data.
>
> We were careful to flush writes, but we could still have (now stale) data in
> the cache either due to a previous read or because of prefetching.  So we
> need to flush, and we need to fence to make sure that our flushing stays
> correctly ordered with respect to our reads.

Hmm, so clflushopt does not guarantee that a read in program order
after a clflushopt sees the invalidate?  It seems like we're not
getting any advantage of using clfushopt vs clflush.

Let's go with this for now, but anything further should be guided by
performance numbers.
