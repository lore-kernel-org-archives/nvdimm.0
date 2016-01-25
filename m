Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 25 Jan 2016 15:46:36 -0500
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC PATCH] dax, ext2, ext4, XFS: fix data corruption race
Message-ID: <20160125204636.GI2948@linux.intel.com>
References: <1453503971-5319-1-git-send-email-ross.zwisler@linux.intel.com>
 <20160124220107.GI20456@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160124220107.GI20456@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, xfs@oss.sgi.com
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 25, 2016 at 09:01:07AM +1100, Dave Chinner wrote:
> On Fri, Jan 22, 2016 at 04:06:11PM -0700, Ross Zwisler wrote:
> > With the current DAX code the following race exists:
> > 
> > Process 1                	Process 2
> > ---------			---------
> > 
> > __dax_fault() - read file f, index 0
> >   get_block() -> returns hole
> >                              	__dax_fault() - write file f, index 0
> >                                   get_block() -> allocates blocks
> >                                   dax_insert_mapping()
> >   dax_load_hole()
> >   *data corruption*
> > 
> > An analogous race exists between __dax_fault() loading a hole and
> > __dax_pmd_fault() allocating a PMD DAX page and trying to insert it, and
> > that race also ends in data corruption.
> 
> Ok, so why doesn't this problem exist for the normal page cache
> insertion case with concurrent read vs write faults?  It's because
> the write fault first does a read fault and so always the write
> fault always has a page in the radix tree for the get_block call
> that allocates the extents, right?

No, it's because allocation of blocks is separated from allocation of
struct page.

> And DAX has an optimisation in the page fault part where it skips
> the read fault part of the write fault?  And so essentially the DAX
> write fault is missing the object (page lock of page in the radix
> tree) that the non-DAX write fault uses to avoid this problem?
>
> What happens if we get rid of that DAX write fault optimisation that
> skips the initial read fault? The write fault will always run on a
> mapping that has a hole loaded, right?, so the race between
> dax_load_hole() and dax_insert_mapping() goes away, because nothing
> will be calling dax_load_hole() once the write fault is allocating
> blocks....

So in your proposal, we'd look in the radix tree, find nothing,
call get_block(..., 0).  If we get something back, we can insert it.
If we hit a hole, we allocate a struct page, put it in the radix tree
and return to user space.  If that was a write fault after all, it'll
come back to us through the ->page_mkwrite handler where we can take the
page lock on the allocated struct page, then call down to DAX which calls
back through get_block to allocate?  Then DAX kicks the struct page out
of the page cache and frees it.

That seems to work to me.  And we can get rid of pfn_mkwrite at the same
time which seems like a win to me.

