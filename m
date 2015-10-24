Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sat, 24 Oct 2015 16:49:38 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/5] block: enable dax for raw block devices
Message-ID: <20151024144938.GA14231@quack.suse.cz>
References: <20151022064142.12700.11849.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151022064211.12700.77105.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151022093549.GE14445@quack.suse.cz>
 <1445529945.17208.4.camel@intel.com>
 <20151022210818.GC8670@quack.suse.cz>
 <CAPcyv4iRz=+11PHxaNMuWGiC67C5C1GKaq=0sUfqZ9xO5eHSUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iRz=+11PHxaNMuWGiC67C5C1GKaq=0sUfqZ9xO5eHSUA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "willy@linux.intel.com" <willy@linux.intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "david@fromorbit.com" <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 23-10-15 16:32:57, Dan Williams wrote:
> On Thu, Oct 22, 2015 at 2:08 PM, Jan Kara <jack@suse.cz> wrote:
> > On Thu 22-10-15 16:05:46, Williams, Dan J wrote:
> [..]
> >> This text was aimed at the request from Ross to document the differences
> >> vs the generic_file_mmap() path.  Is the following incremental change
> >> more clear?
> >
> > Well, not really. I thought you'd just delete that paragraph :) The thing
> > is: When doing IO directly to the block device, it makes no sense to look
> > at a filesystem on top of it - hopefully there is none since you'd be
> > corrupting it. So the paragraph that would make sense to me would be:
> >
> >  * Finally, in contrast to filemap_page_mkwrite(), we don't bother calling
> >  * sb_start_pagefault(). There is no filesystem which could be frozen here
> >  * and when bdev gets frozen, IO gets blocked in the request queue.
> 
> I'm not following this assertion that "IO gets blocked in the request
> queue" when the device is frozen in the code.  As far as I can see
> outside of tracking the freeze depth count the request_queue does not
> check if the device is frozen.   freeze_bdev() is moot when no
> filesystem is a present.

Yes, how e.g. dm freezes devices when it wants to do a snapshot is that it
first calls freeze_bdev() (to stop fs when there is one) and then calls
blk_stop_queue() to block all the IO requests in the request queue. In this
sense freeze_bdev() is somewhat a misnomer since it doesn't make sure no IO
is submitted to the bdev.

> > But when spelled out like this, I've realized that with DAX, this blocking
> > of requests in the request queue doesn't really block the IO to the device.
> > So block device freezing (aka blk_queue_stop()) doesn't work reliably with
> > DAX. That should be fixed but it's not easy as the only way to do that
> > would be to hook into blk_stop_queue() and unmap (or at least
> > write-protect) all the mappings of the device. Ugh...
> 
> Again I'm missing how this is guaranteed in the non-DAX case.
> freeze_bdev() will sync_blockdev(), but it does nothing to prevent
> re-dirtying through raw device mmaps while the fs in frozen.  Should
> it?  That's at least a separate patch.

It doesn't have to - after blk_stop_queue() is called no IO is submitted to
the device and snapshotting happens in the level below bdev page cache so
we don't care about modifications happening there. But with DAX things are
different as we directly map device pages into page cache so we have to
make sure no modifications of page cache happen.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
