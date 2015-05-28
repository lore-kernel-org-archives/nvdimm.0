Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 28 May 2015 10:51:24 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL v4 00/21] libnd: non-volatile memory device support
Message-ID: <20150528085124.GA26120@lst.de>
References: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@kernel.dk, Boaz Harrosh <boaz@plexistor.com>, neilb@suse.de, Dave Chinner <david@fromorbit.com>, Lv Zheng <lv.zheng@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, hch@lst.de, sfr@canb.auug.org.au, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 27, 2015 at 06:24:42PM -0400, Dan Williams wrote:
> Jens, please pull from...
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm tags/libnd-for-jens

I don't really think it's quite ready.  I don't have time to sort through
the giant steaming pile for now, but there are a few things here:

 - stong NAK for the linker wrapping abuse in the test module
 - you must run the ioctls past the linux-api list at least
 - please make sure the legacy e820 changes are properly tested.  I could
   take of it, but not until Wednesday next week as I'm travelling right
   now.

Also a little nitpick on naming:  why is this still nd instead of the
widely used nvdimm?  Also as very little of it is related to block drivers
and a lot is management it should be under drivers/ not drivers/block/
I think.
