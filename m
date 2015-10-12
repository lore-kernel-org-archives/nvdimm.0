Return-Path: <linux-ext4-owner@vger.kernel.org>
Date: Tue, 13 Oct 2015 10:02:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] ext2: Add locking for DAX faults
Message-ID: <20151012230237.GG27164@dastard>
References: <1444428128-12200-1-git-send-email-ross.zwisler@linux.intel.com>
 <1444428128-12200-3-git-send-email-ross.zwisler@linux.intel.com>
 <20151011231443.GY27164@dastard>
 <20151012172156.GA19076@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151012172156.GA19076@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 12, 2015 at 11:21:56AM -0600, Ross Zwisler wrote:
> On Mon, Oct 12, 2015 at 10:14:43AM +1100, Dave Chinner wrote:
> > On Fri, Oct 09, 2015 at 04:02:08PM -0600, Ross Zwisler wrote:
> <>
> > > +/*
> > > + * The lock ordering for ext2 DAX fault paths is:
> > > + *
> > > + * mmap_sem (MM)
> > > + *   ext2_inode_info->dax_sem
> > > + *     sb_start_pagefault (vfs, freeze - taken in DAX)
> > > + *       address_space->i_mmap_rwsem or page_lock (mutually exclusive in DAX)
> > > + *         ext2_inode_info->truncate_mutex
> > 
> > This is a different lock order to XFS - it puts the i_mmaplock
> > inside sb_start_pagefault(), not outside it. This ordering means the
> > timestamp updates during the page fault are also under
> > ext2_inode_info->dax_sem...
> 
> Yep - I was trying not not open code dax_fault() yet again, but it looks like
> both XFS and ext4 both open-code dax_fault() and call __dax_fault() directly.
> 
> I assume that when we get an analogous lock to i_mmaplock in the ext4 fault
> path we'll end up with the same locking order that is found in XFS.
> 
> I'll do the same for v2 of this patch and I'll kill the then-unused
> dax_fault().

Great!

I'd suggest that you also then rename __dax_fault() to dax_fault()
in that case, and also document the requirements for callers in
terms of sb_start_pagefault() and timestamp updates...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
