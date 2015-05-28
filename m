Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150528085124.GA26120@lst.de>
References: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150528085124.GA26120@lst.de>
Date: Thu, 28 May 2015 07:55:47 -0700
Message-ID: <CAPcyv4ieTpdTdH=X9o0+YQ4B+fk9Wp85a55yWKReFAXpdVnSVg@mail.gmail.com>
Subject: Re: [GIT PULL v4 00/21] libnd: non-volatile memory device support
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <boaz@plexistor.com>, Neil Brown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>, Lv Zheng <lv.zheng@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, Ingo Molnar <mingo@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 28, 2015 at 1:51 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Wed, May 27, 2015 at 06:24:42PM -0400, Dan Williams wrote:
>> Jens, please pull from...
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm tags/libnd-for-jens
>
> I don't really think it's quite ready.  I don't have time to sort through
> the giant steaming pile for now, but there are a few things here:

If it weren't for the fact that I almost always like the new state of
the code after an hch review I'd take offense at that steaming pile
remark ;-).

>  - stong NAK for the linker wrapping abuse in the test module

This capability has been our single largest generator of bug fixes and
regression prevention.  Please tell me you have a non-bikeshed
argument why this test approach must die?  We need more tests in tree,
not less.  That said, it's at the end of the series ready to be lopped
off like a spent booster rocket if it's really a blocker.

>  - you must run the ioctls past the linux-api list at least

Ok.

>  - please make sure the legacy e820 changes are properly tested.  I could
>    take of it, but not until Wednesday next week as I'm travelling right
>    now.

We regularly test the pmem driver, but I'll put an e820 config through
some extra paces.  In fact it's already better than the in-tree
version which fails to autoload the driver module (missing module
alias).

# grep -o memmap.* /proc/cmdline
memmap=1G!4G libnd.dyndbg rw

# cat /proc/partitions | grep pmem
 259        0    1048576 pmem0

# readlink -f /sys/block/pmem0/device
/sys/devices/platform/e820_pmem/ndbus0/region0/namespace0.0

> Also a little nitpick on naming:  why is this still nd instead of the
> widely used nvdimm?

It makes the identifier prefixes shorter is the bulk of the reasoning
and a hardware memory resource need not always be a "dimm".  If it's
just the top-level directory I'm fine with 'nvdimm' or are you looking
for a rename throughout?

> Also as very little of it is related to block drivers
> and a lot is management it should be under drivers/ not drivers/block/
> I think.

Fine with me.
