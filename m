Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
 [150.101.137.145]) by ml01.01.org (Postfix) with ESMTP id 1188E1A1E14
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jul 2016 15:20:06 -0700 (PDT)
Date: Thu, 28 Jul 2016 08:19:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Subtle races between DAX mmap fault and write path
Message-ID: <20160727221949.GU16044@dastard>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 27, 2016 at 03:10:39PM -0600, Ross Zwisler wrote:
> On Wed, Jul 27, 2016 at 02:07:45PM +0200, Jan Kara wrote:
> > Hi,
> > 
> > when testing my latest changes to DXA fault handling code I have hit the
> > following interesting race between the fault and write path (I'll show
> > function names for ext4 but xfs has the same issue AFAICT).

The XFS update I just pushed to Linus contains a rework of the XFS
DAX IO path. It no longer shares the XFS direct IO path, so it
doesn't contain any of the direct IO warts anymore.

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

In XFS, we don't call __generic_file_write_iter or
generic_file_direct_write(), and xfs_file_dax_write() does not have
this trailing call to invalidate_inode_pages2_range() anymore. It's
DAX - there's nothing to invalidate, right?

So I think Christoph just (accidentally) removed this race condition
from XFS....

> > So we have just lost information that block 0 is mapped and needs flushing
> > caches.
> > 
> > Also the fact that the consistency of data as viewed by mmap and
> > dax_do_io() relies on invalidate_inode_pages2_range() is somewhat
> > unexpected to me and we should document it somewhere.

I don't think it does - what, in DAX, is incoherent? If anything,
it's the data in the direct IO buffer, not the view the mmap will
see. i.e. the post-write invalidate is to ensure that applications
that have mmapped the file see the data written by direct IO. That's
not necessary with DAX.

> > The question is how to best fix this. I see three options:
> > 
> > 1) Lock out faults during writes via exclusive i_mmap_sem. That is rather
> > harsh but should work - we call filemap_write_and_wait() in
> > generic_file_direct_write() so we flush out all caches for the relevant
> > area before dropping radix tree entries.

We don't call filemap_write_and_wait() in xfs_file_dax_write()
anymore, either. It's DAX - we don't need to flush anything to read
the correct data, and there's nothing cached that becomes stale when
we overwrite the destination memory.

[snip]

> > Any opinions on this?
> 
> Can we just skip the two calls to invalidate_inode_pages2_range() in
> generic_file_direct_write() for DAX I/O?

The first invalidate is still there in XFS. The comment above it
in the new XFS code says:

	/*
	 * Yes, even DAX files can have page cache attached to them:  A zeroed
	 * page is inserted into the pagecache when we have to serve a write
	 * fault on a hole.  It should never be dirtied and can simply be
	 * dropped from the pagecache once we get real data for the page.
	 */
	if (mapping->nrpages) {
		ret = invalidate_inode_pages2(mapping);
		WARN_ON_ONCE(ret);
	}


> Similarly, for DAX I don't think we actually need to do the
> filemap_write_and_wait_range() call in generic_file_direct_write() either.
> It's a similar scenario - for direct I/O we are trying to make sure that any
> dirty data in the page cache is written out to media before the ->direct_IO()
> call happens.  For DAX I don't think we care.  If a user does an mmap() write
> which creates a dirty radix tree entry, then does a write(), we should be able
> to happily overwrite the old data with the new without flushing, and just
> leave the dirty radix tree entry in place.

Yup, that's pretty much how XFS treats DAX now - it's not direct IO,
but it's not buffered IO, either...

I don't think there's a problem that needs to be fixed in the DAX
code - the issue is all about the surrounding IO context. i.e
whether do_dax_io() is automatically coherent with mmap or not
because mmap directly exposes the CPU cache coherent memory
do_dax_io() modifies.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
