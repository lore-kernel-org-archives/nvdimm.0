Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
 [150.101.137.141]) by ml01.01.org (Postfix) with ESMTP id E24651A1DF1
 for <linux-nvdimm@lists.01.org>; Thu, 28 Jul 2016 19:22:04 -0700 (PDT)
Date: Fri, 29 Jul 2016 12:21:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Subtle races between DAX mmap fault and write path
Message-ID: <20160729022152.GZ16044@dastard>
References: <20160727120745.GI6860@quack2.suse.cz>
 <20160727211039.GA20278@linux.intel.com>
 <20160727221949.GU16044@dastard>
 <20160728081033.GC4094@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160728081033.GC4094@quack2.suse.cz>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 28, 2016 at 10:10:33AM +0200, Jan Kara wrote:
> On Thu 28-07-16 08:19:49, Dave Chinner wrote:
> > On Wed, Jul 27, 2016 at 03:10:39PM -0600, Ross Zwisler wrote:
> > > On Wed, Jul 27, 2016 at 02:07:45PM +0200, Jan Kara wrote:
> > > > Hi,
> > > > 
> > > > when testing my latest changes to DXA fault handling code I have hit the
> > > > following interesting race between the fault and write path (I'll show
> > > > function names for ext4 but xfs has the same issue AFAICT).
> > 
> > The XFS update I just pushed to Linus contains a rework of the XFS
> > DAX IO path. It no longer shares the XFS direct IO path, so it
> > doesn't contain any of the direct IO warts anymore.
> 
> Ah, OK. I knew Christoph rewrote it but forgot to check your tree when
> looking into this bug.
> 
> > > > We have a file 'f' which has a hole at offset 0.
> > > > 
> > > > Process 0				Process 1
> > > > 
> > > > data = mmap('f');
> > > > read data[0]
> > > >   -> fault, we map a hole page
> > > > 
> > > > 					pwrite('f', buf, len, 0)
> > > > 					  -> ext4_file_write_iter
> > > > 					    inode_lock(inode);
> > > > 					    __generic_file_write_iter()
> > > > 					      generic_file_direct_write()
> > > > 						invalidate_inode_pages2_range()
> > > > 						  - drops hole page from
> > > > 						    the radix tree
> > > > 						ext4_direct_IO()
> > > > 						  dax_do_io()
> > > > 						    - allocates block for
> > > > 						      offset 0
> > > > data[0] = 1
> > > >   -> page_mkwrite fault
> > > >     -> ext4_dax_fault()
> > > >       down_read(&EXT4_I(inode)->i_mmap_sem);
> > > >       __dax_fault()
> > > > 	grab_mapping_entry()
> > > > 	  - creates locked radix tree entry
> > > > 	- maps block into PTE
> > > > 	put_locked_mapping_entry()
> > > > 
> > > > 						invalidate_inode_pages2_range()
> > > > 						  - removes dax entry from
> > > > 						    the radix tree
> > 
> > In XFS, we don't call __generic_file_write_iter or
> > generic_file_direct_write(), and xfs_file_dax_write() does not have
> > this trailing call to invalidate_inode_pages2_range() anymore. It's
> > DAX - there's nothing to invalidate, right?
> > 
> > So I think Christoph just (accidentally) removed this race condition
> > from XFS....
> 
> So with current XFS code what prevents the following:
> 
> Process 0				Process 1
> 
> data = mmap('f');
> 					pwrite('f', buf, len, 0)
> 					  -> xfs_file_dax_write
> 					    xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
> 					    invalidate_inode_pages2()
> 					      - drops hole page from the
> 					        radix tree
> 					    xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
> read data[0]
>   -> fault
>     -> xfs_filemap_fault
>       xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>       dax_fault()
> 	- installs hole in the radix tree and PTE
> 
> 					    dax_do_io()
> 					      - allocates block for offset 0
> 
> And now Process 0 doesn't see the data Process 1 has written until fault on
> that address is triggered again for some reason.

IMO, that's a problem internal to dax_do_io(), not an XFS problem.
XFS has serialised everything it can (the block lookup/allocation)
between mmap and the IO path, yet the internal DAX radix tree and
mappings is now inconsistent.

If dax_do_io() allocates a new block, it clearly makes the existing
mapping tree contents for that block invalid.  Hence it needs to be
invalidating mappings and PTEs over a physical offset that it knows
it just changed. The filesystem shouldn't do this - it would be a
horrible layering violation to require get_block() to invalidate
PTEs....

> Heck, looking at the code in xfs_file_dax_write() you call
> invalidate_inode_pages2() which clears the *whole* radix tree. So you have
> just lost the dirtiness information for the whole file and thus fsync(2)
> will not flush any data written via mmap.

Ok, so that's a bug, but it has no impact on what is being discussed
here. It's also not something any of the regression test we have
picked up....

> > > > So we have just lost information that block 0 is mapped and needs flushing
> > > > caches.
> > > > 
> > > > Also the fact that the consistency of data as viewed by mmap and
> > > > dax_do_io() relies on invalidate_inode_pages2_range() is somewhat
> > > > unexpected to me and we should document it somewhere.
> > 
> > I don't think it does - what, in DAX, is incoherent? If anything,
> > it's the data in the direct IO buffer, not the view the mmap will
> > see. i.e. the post-write invalidate is to ensure that applications
> > that have mmapped the file see the data written by direct IO. That's
> > not necessary with DAX.
> 
> The coherency issues are very similar to direct IO because of hole pages.
> Generally we need to maintain coherency between what is pointed to from page
> tables and what is really backing file data (as viewed by inode's extent
> tree). So whenever block allocation / deallocation happens for the file, we
> may need to update page tables which map this offset as well. For
> deallocation (truncate, punch hole, ...) we take care of this under
> protection of MMAPLOCK so things are fine. For allocation we currently
> don't use this serialization mechanism.

And that's because we can't take locks in the IO path that might be
taken in the page fault path because of page fault recursion
deadlocks during copy operations.

We do, however, return buffer_new() when allocations occur, which
tells the dax_do_io() code it needs to do something special with the
buffer....

> > > > The question is how to best fix this. I see three options:
> > > > 
> > > > 1) Lock out faults during writes via exclusive i_mmap_sem. That is rather
> > > > harsh but should work - we call filemap_write_and_wait() in
> > > > generic_file_direct_write() so we flush out all caches for the relevant
> > > > area before dropping radix tree entries.
> > 
> > We don't call filemap_write_and_wait() in xfs_file_dax_write()
> > anymore, either. It's DAX - we don't need to flush anything to read
> > the correct data, and there's nothing cached that becomes stale when
> > we overwrite the destination memory.
> 
> So DAX doesn't need flushing to maintain consistent view of the data but it
> does need flushing to make sure fsync(2) results in data written via mmap
> to reach persistent storage.

I thought this all changed with the removal of the pcommit
instruction and wmb_pmem() going away.  Isn't it now a platform
requirement now that dirty cache lines over persistent memory ranges
are either guaranteed to be flushed to persistent storage on power
fail or when required by REQ_FLUSH?

https://lkml.org/lkml/2016/7/9/131

And part of that is the wmb_pmem() calls are going away?

https://lkml.org/lkml/2016/7/9/136
https://lkml.org/lkml/2016/7/9/140

i.e. fsync on pmem only needs to take care of writing filesystem
metadata now, and the pmem driver handles the rest when it gets a
REQ_FLUSH bio from fsync?

https://lkml.org/lkml/2016/7/9/134

Or have we somehow ended up with the fucked up situation where
dax_do_io() writes are (effectively) immediately persistent and
untracked by internal infrastructure, whilst mmap() writes
require internal dirty tracking and fsync() to flush caches via
writeback?

Seriously: everything inside DAX needs to operate the same way and
use the same tracking infrastructure, otherwise we are going to
always have fucked up coherency problems and races like this. If
mmap writes are volatile, then dax_do_io writes should be volatile,
too. And both should maintain that dirty state and mapping coherency
via the internal mapping infrastructure, just like the page cache
does for mmap vs buffered IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
