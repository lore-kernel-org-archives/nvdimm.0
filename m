Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150603065510.GB11344@lst.de>
References: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150528085124.GA26120@lst.de>
	<CAPcyv4ieTpdTdH=X9o0+YQ4B+fk9Wp85a55yWKReFAXpdVnSVg@mail.gmail.com>
	<20150603065510.GB11344@lst.de>
Date: Wed, 3 Jun 2015 00:02:53 -0700
Message-ID: <CAPcyv4j6UtkZ6i9Zp8ptiadNw2ZrTNp8t8q6Xap52_3zw5ypkg@mail.gmail.com>
Subject: Re: [GIT PULL v4 00/21] libnd: non-volatile memory device support
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <boaz@plexistor.com>, Neil Brown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>, Lv Zheng <lv.zheng@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, Ingo Molnar <mingo@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 2, 2015 at 11:55 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, May 28, 2015 at 07:55:47AM -0700, Dan Williams wrote:
>> >  - stong NAK for the linker wrapping abuse in the test module
>>
>> This capability has been our single largest generator of bug fixes and
>> regression prevention.  Please tell me you have a non-bikeshed
>> argument why this test approach must die?  We need more tests in tree,
>> not less.  That said, it's at the end of the series ready to be lopped
>> off like a spent booster rocket if it's really a blocker.
>
> No - you're overloading general functionality to go to something much
> slower, with locking implications etc totally invisible to someone reading
> the code.  I could be persuaded that a test module makes sense if you
> make it an explicit opt-in at the source code level, e.g. a version
> of a the pmem driver that needs to be explicitly loaded.

I slowly came to the same realization, see v5.

> Then again I really don't see the point - if you already need a VM with
> ACPI / EFI tables to claim that you have pmem support you might as well
> do the pmem emulation in that same virtualіzation environment.

The problem is that PMEM is easy to emulate, BLK, is more involved.
No one really wants BLK mode in a VM compared to a virtio passthrough
to BLK mode on the bare metal side.

>> It makes the identifier prefixes shorter is the bulk of the reasoning
>> and a hardware memory resource need not always be a "dimm".  If it's
>> just the top-level directory I'm fine with 'nvdimm' or are you looking
>> for a rename throughout?
>
> That's the most important part.

Ok, have a look at v5 and see if that seems like the right set of
identifier names.
