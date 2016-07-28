Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 194B31A1DFC
 for <linux-nvdimm@lists.01.org>; Thu, 28 Jul 2016 01:47:58 -0700 (PDT)
Date: Thu, 28 Jul 2016 10:47:54 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Subtle races between DAX mmap fault and write path
Message-ID: <20160728084754.GD4094@quack2.suse.cz>
References: <20160727120745.GI6860@quack2.suse.cz>
 <20160727211039.GA20278@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160727211039.GA20278@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 27-07-16 15:10:39, Ross Zwisler wrote:
> On Wed, Jul 27, 2016 at 02:07:45PM +0200, Jan Kara wrote:
> > Hi,
> > 
> > when testing my latest changes to DXA fault handling code I have hit the
> > following interesting race between the fault and write path (I'll show
> > function names for ext4 but xfs has the same issue AFAICT).
> > 
> > We have a file 'f' which has a hole at offset 0.
> > 
> > Process 0				Process 1
> > 
> > data = mmap('f');
> > read data[0]
> >   -> fault, we map a hole page
> > 
> > 					pwrite('f', buf, len, 0)
> > 					  -> ext4_file_write_iter
> > 					    inode_lock(inode);
> > 					    __generic_file_write_iter()
> > 					      generic_file_direct_write()
> > 						invalidate_inode_pages2_range()
> > 						  - drops hole page from
> > 						    the radix tree
> > 						ext4_direct_IO()
> > 						  dax_do_io()
> > 						    - allocates block for
> > 						      offset 0
> > data[0] = 1
> >   -> page_mkwrite fault
> >     -> ext4_dax_fault()
> >       down_read(&EXT4_I(inode)->i_mmap_sem);
> >       __dax_fault()
> > 	grab_mapping_entry()
> > 	  - creates locked radix tree entry
> > 	- maps block into PTE
> > 	put_locked_mapping_entry()
> > 
> > 						invalidate_inode_pages2_range()
> > 						  - removes dax entry from
> > 						    the radix tree
> > 
> > So we have just lost information that block 0 is mapped and needs flushing
> > caches.
> > 
> > Also the fact that the consistency of data as viewed by mmap and
> > dax_do_io() relies on invalidate_inode_pages2_range() is somewhat
> > unexpected to me and we should document it somewhere.
> > 
> > The question is how to best fix this. I see three options:
> > 
> > 1) Lock out faults during writes via exclusive i_mmap_sem. That is rather
> > harsh but should work - we call filemap_write_and_wait() in
> > generic_file_direct_write() so we flush out all caches for the relevant
> > area before dropping radix tree entries.
> > 
> > 2) Call filemap_write_and_wait() after we return from ->direct_IO before we
> > call invalidate_inode_pages2_range() and hold i_mmap_sem exclusively only
> > for those two calls. Lock hold time will be shorter than 1) but it will
> > require additional flush and we'd probably have to stop using
> > generic_file_direct_write() for DAX writes to allow for all this special
> > hackery.
> > 
> > 3) Remodel dax_do_io() to work more like buffered IO and use radix tree
> > entry locks to protect against similar races. That has likely better
> > scalability than 1) but may be actually slower in the uncontended case (due
> > to all the radix tree operations).
> > 
> > Any opinions on this?
> 
> Can we just skip the two calls to invalidate_inode_pages2_range() in
> generic_file_direct_write() for DAX I/O?
> 
> These calls are there for the direct I/O path because for direct I/O there is
> a failure scenario where we have clean pages in the page cache which are stale
> compared to the newly written data on media.  If we read from these clean
> pages instead of reading from media, we get data corruption.
> 
> This failure case doesn't exist for DAX - we don't care if there are radix
> tree entries for the data region that the ->direct_IO() call is about to
> write.
> 
> Similarly, for DAX I don't think we actually need to do the
> filemap_write_and_wait_range() call in generic_file_direct_write() either.
> It's a similar scenario - for direct I/O we are trying to make sure that any
> dirty data in the page cache is written out to media before the ->direct_IO()
> call happens.  For DAX I don't think we care.  If a user does an mmap() write
> which creates a dirty radix tree entry, then does a write(), we should be able
> to happily overwrite the old data with the new without flushing, and just
> leave the dirty radix tree entry in place.

See my email to Dave for details but to put it shortly, write(2) which
allocates block has to make sure hole page for that offset is unmapped from
page tables and freed so at least one invalidate_inode_pages2_range() call
is necessary even for DAX. And because that call will currently remove also
dirty radix tree entries, flushing is currently necessary as well. If we
modified invalidate_inode_pages2_range() to keep dirty radix tree entries
(which makes sense because invalidate_inode_pages2_range() does not discard
dirty pages in the first place), flushing won't be necessary. That is true.

> I realize this adds even more special case DAX code to mm/filemap.c, but
> if we can avoid the race without adding any more locking (and by
> simplifying our logic), it seems like it's worth it to me.

Well, we could always decouple DAX write path from the direct IO write
path. XFS already did this and if the generic DIO path won't be suitable for
DAX on ext4, we can do the same for it.

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
