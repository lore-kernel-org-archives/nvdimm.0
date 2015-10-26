Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 26 Oct 2015 08:20:57 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/5] block: enable dax for raw block devices
Message-ID: <20151026072057.GA11450@quack.suse.cz>
References: <20151022064142.12700.11849.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151022064211.12700.77105.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151022093549.GE14445@quack.suse.cz>
 <1445529945.17208.4.camel@intel.com>
 <20151022210818.GC8670@quack.suse.cz>
 <20151025212247.GI19199@dastard>
 <CAPcyv4hjGYYPRyPjZc3CymmnSObB7mULRbeMZFjnKdoCD_m7pw@mail.gmail.com>
 <20151026062319.GJ19199@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151026062319.GJ19199@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "willy@linux.intel.com" <willy@linux.intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 26-10-15 17:23:19, Dave Chinner wrote:
> On Mon, Oct 26, 2015 at 11:48:06AM +0900, Dan Williams wrote:
> > 2/ Even if we get a new flag that lets the kernel know the app
> > understands DAX mappings, we shouldn't leave fsync broken.  Can we
> > instead get by with a simple / big hammer solution?  I.e.
> 
> Because we don't physically have to write back data the problem is
> both simpler and more complex. The simplest solution is for the
> underlying block device to implement blkdev_issue_flush() correctly.
> 
> i.e. if blkdev_issue_flush() behaves according to it's required
> semantics - that all volatile cached data is flushed to stable
> storage - then fsync-on-DAX will work appropriately. As it is, this is
> needed for journal based filesystems to work correctly, as they are
> assuming that their journal writes are being treated correctly as
> REQ_FLUSH | REQ_FUA to ensure correct data/metadata/journal
> ordering is maintained....
> 
> So, to begin with, this problem needs to be solved at the block
> device level. That's the simple, brute-force, big hammer solution to
> the problem, and it requires no changes at the filesystem level at
> all.

Completely agreed. Just make sure REQ_FLUSH, REQ_FUA works correctly for
pmem and fsync(2) / sync(2) issues go away. Fs freezing stuff is a
different story, that will likely need some coordination from the
filesystem layer (although with some luck we could keep it hidden in
fs/super.c and fs/block_dev.c). I can have a look at that once ext4 dax
support works unless someone beats me to it...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
