Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 21 Oct 2015 11:08:00 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: what's in nvdimm.git for v4.4?
Message-ID: <20151021090800.GA2939@quack.suse.cz>
References: <1445383903.6611.39.camel@intel.com>
 <20151021000103.GA19199@dastard>
 <CAPcyv4hBV=tsEmNajuMXr8Jj7-+ovT7FP3yWrfDLZVWejgA2ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hBV=tsEmNajuMXr8Jj7-+ovT7FP3yWrfDLZVWejgA2ig@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, "axboe@fb.com" <axboe@fb.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Sorry for replying to this email and not to patch posting directly but I
didn't find the original mail in any of my mailboxes...

On Tue 20-10-15 17:31:18, Dan Williams wrote:
> On Tue, Oct 20, 2015 at 5:01 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Oct 20, 2015 at 11:31:45PM +0000, Williams, Dan J wrote:
> >> Here is a status summary of the topic-branches nvdimm.git is tracking
> >> for v4.4.  Unless indicated these branches are not present in -next.
> >> Please ACK, NAK, or ask for a re-post of any of the below to disposition
> >> it for the merge window.
> >>
> >> ===
> >> for-4.4/dax-fixes:
> >> ===
> > ...
> >>         Dave Chinner (5):
> >>               xfs: fix inode size update overflow in xfs_map_direct()
> >>               xfs: introduce BMAPI_ZERO for allocating zeroed extents
> >>               xfs: Don't use unwritten extents for DAX
> >>               xfs: DAX does not use IO completion callbacks
> >>               xfs: add ->pfn_mkwrite support for DAX
> >
> > Please drop these. They have not been reviewed yet, and because
> > the changes affect more than just DAX (core XFS allocator
> > functionality was changed) these need to go through the XFS tree.
> >
> 
> Ok, thanks for the heads up.  For the get_user_pages() patches that
> build on these fixes I'm assuming your review bandwidth is in short
> supply to also give an XFS sign-off on those changes for 4.4?
> 
> I'm wondering if we can take a conservative step forward with those
> patches for 4.4.  if XFS and EXT4 interactions need more time to get
> worked out, which I believe they do, I can conceive just turning on
> get_user_pages() support for DAX-mappings of the raw block device.
> This would be via the new facility I posted yesterday:
> https://lists.01.org/pipermail/linux-nvdimm/2015-October/002512.html.
> While not very functional for applications it makes testing base DAX
> mechanisms straightforward.

I had a look at the patch and I miss one thing: Why do we need bd_mutex
to protect faults? I see a comment there:

/* check that the faulting page hasn't raced with bdev resize */

Is it really possible that bdev gets shrunk under us? Hum, looking into
fs/block_dev.c, probably it is. But there are other places - like DIO path
- assuming that block device mapping cannot just disappear from under us. I
wonder how that would cope with bdev size change...

Also we only call invalidate_bdev() to invalidate page cache pages of the
bdev after resize which specifically skips any mmaped pages so bdev resizing
in presence of mmap is unreliable to say the least.

Anyway, bd_mutex seems like a big hammer in the fast path to protect against
rare size changes. Also nesting of bd_mutex under mmap_sem makes me
somewhat uneasy (I'd definitely wonder whether lockdep would not complain
about that)...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
