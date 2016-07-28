Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E0E4F1A1DFC
 for <linux-nvdimm@lists.01.org>; Thu, 28 Jul 2016 01:10:37 -0700 (PDT)
Date: Thu, 28 Jul 2016 10:10:33 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Subtle races between DAX mmap fault and write path
Message-ID: <20160728081033.GC4094@quack2.suse.cz>
References: <20160727120745.GI6860@quack2.suse.cz>
 <20160727211039.GA20278@linux.intel.com>
 <20160727221949.GU16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160727221949.GU16044@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu 28-07-16 08:19:49, Dave Chinner wrote:
> On Wed, Jul 27, 2016 at 03:10:39PM -0600, Ross Zwisler wrote:
> > On Wed, Jul 27, 2016 at 02:07:45PM +0200, Jan Kara wrote:
> > > Hi,
> > > 
> > > when testing my latest changes to DXA fault handling code I have hit the
> > > following interesting race between the fault and write path (I'll show
> > > function names for ext4 but xfs has the same issue AFAICT).
> 
> The XFS update I just pushed to Linus contains a rework of the XFS
> DAX IO path. It no longer shares the XFS direct IO path, so it
> doesn't contain any of the direct IO warts anymore.

Ah, OK. I knew Christoph rewrote it but forgot to check your tree when
looking into this bug.

> > > We have a file 'f' which has a hole at offset 0.
> > > 
> > > Process 0				Process 1
> > > 
> > > data = mmap('f');
> > > read data[0]
> > >   -> fault, we map a hole page
> > > 
> > > 					pwrite('f', buf, len, 0)
> > > 					  -> ext4_file_write_iter
> > > 					    inode_lock(inode);
> > > 					    __generic_file_write_iter()
> > > 					      generic_file_direct_write()
> > > 						invalidate_inode_pages2_range()
> > > 						  - drops hole page from
> > > 						    the radix tree
> > > 						ext4_direct_IO()
> > > 						  dax_do_io()
> > > 						    - allocates block for
> > > 						      offset 0
> > > data[0] = 1
> > >   -> page_mkwrite fault
> > >     -> ext4_dax_fault()
> > >       down_read(&EXT4_I(inode)->i_mmap_sem);
> > >       __dax_fault()
> > > 	grab_mapping_entry()
> > > 	  - creates locked radix tree entry
> > > 	- maps block into PTE
> > > 	put_locked_mapping_entry()
> > > 
> > > 						invalidate_inode_pages2_range()
> > > 						  - removes dax entry from
> > > 						    the radix tree
> 
> In XFS, we don't call __generic_file_write_iter or
> generic_file_direct_write(), and xfs_file_dax_write() does not have
> this trailing call to invalidate_inode_pages2_range() anymore. It's
> DAX - there's nothing to invalidate, right?
> 
> So I think Christoph just (accidentally) removed this race condition
> from XFS....

So with current XFS code what prevents the following:

Process 0				Process 1

data = mmap('f');
					pwrite('f', buf, len, 0)
					  -> xfs_file_dax_write
					    xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
					    invalidate_inode_pages2()
					      - drops hole page from the
					        radix tree
					    xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
read data[0]
  -> fault
    -> xfs_filemap_fault
      xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
      dax_fault()
	- installs hole in the radix tree and PTE

					    dax_do_io()
					      - allocates block for offset 0

And now Process 0 doesn't see the data Process 1 has written until fault on
that address is triggered again for some reason.

Heck, looking at the code in xfs_file_dax_write() you call
invalidate_inode_pages2() which clears the *whole* radix tree. So you have
just lost the dirtiness information for the whole file and thus fsync(2)
will not flush any data written via mmap.

> > > So we have just lost information that block 0 is mapped and needs flushing
> > > caches.
> > > 
> > > Also the fact that the consistency of data as viewed by mmap and
> > > dax_do_io() relies on invalidate_inode_pages2_range() is somewhat
> > > unexpected to me and we should document it somewhere.
> 
> I don't think it does - what, in DAX, is incoherent? If anything,
> it's the data in the direct IO buffer, not the view the mmap will
> see. i.e. the post-write invalidate is to ensure that applications
> that have mmapped the file see the data written by direct IO. That's
> not necessary with DAX.

The coherency issues are very similar to direct IO because of hole pages.
Generally we need to maintain coherency between what is pointed to from page
tables and what is really backing file data (as viewed by inode's extent
tree). So whenever block allocation / deallocation happens for the file, we
may need to update page tables which map this offset as well. For
deallocation (truncate, punch hole, ...) we take care of this under
protection of MMAPLOCK so things are fine. For allocation we currently
don't use this serialization mechanism.

> > > The question is how to best fix this. I see three options:
> > > 
> > > 1) Lock out faults during writes via exclusive i_mmap_sem. That is rather
> > > harsh but should work - we call filemap_write_and_wait() in
> > > generic_file_direct_write() so we flush out all caches for the relevant
> > > area before dropping radix tree entries.
> 
> We don't call filemap_write_and_wait() in xfs_file_dax_write()
> anymore, either. It's DAX - we don't need to flush anything to read
> the correct data, and there's nothing cached that becomes stale when
> we overwrite the destination memory.

So DAX doesn't need flushing to maintain consistent view of the data but it
does need flushing to make sure fsync(2) results in data written via mmap
to reach persistent storage. Look at the following example: Assume you
write via mmap to offsets 0-1023 in the page and via write(2) to offsets
1024-2048 in the page. Then after write(2) you still may have data in
volatile caches for the page for offsets 0-1023. So your write(2) either
has to keep the corresponding entry in the radix tree dirty (and currently
XFS's call to invalidate_inode_pages2() in xfs_file_dax_write() doesn't do
this) or you have to flush the page via filemap_write_and_wait().

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
