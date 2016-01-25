Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 25 Jan 2016 15:40:57 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 5/5] dax: fix clearing of holes in __dax_pmd_fault()
Message-ID: <20160125144057.GI24938@quack.suse.cz>
References: <1453398364-22537-1-git-send-email-ross.zwisler@linux.intel.com>
 <1453398364-22537-6-git-send-email-ross.zwisler@linux.intel.com>
 <20160122153719.GN16898@quack.suse.cz>
 <20160122161251.GC22112@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160122161251.GC22112@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri 22-01-16 09:12:51, Ross Zwisler wrote:
> On Fri, Jan 22, 2016 at 04:37:19PM +0100, Jan Kara wrote:
> > On Thu 21-01-16 10:46:04, Ross Zwisler wrote:
> > > When the user reads from a DAX hole via a mmap we service page faults using
> > > zero-filled page cache pages.  These zero pages are also placed into the
> > > address_space radix tree.  When we get our first write for that space, we
> > > can allocate a PMD page worth of DAX storage to replace that hole.
> > > 
> > > When this happens we need to unmap the zero pages and remove them from the
> > > radix tree.  Prior to this patch we were unmapping *all* storage in our
> > > PMD's range, which is incorrect because it removed DAX entries as well on
> > > non-allocating page faults.
> > > 
> > > Instead, keep track of when get_block() actually gives us storage so that
> > > we can be sure to only remove zero pages that were covering holes.
> > > 
> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > Reported-by: Jan Kara <jack@suse.cz>
> > 
> > So the get_block() calls below are still racy so your allocation detection
> > doesn't quite work reliably anyway. For that we need a change in the fault
> > locking we were talking about and at that point we'll need to somewhat
> > update __dax_pmd_fault() anyway. So I'm not sure if this intermediate
> > change really makes sense... I'd rather first change the locking in the
> > filesystems and then fixup remaining issues with __dax_pmd_fault().
> 
> Agreed, the fault isolation code that we talked about previously is still
> needed.  I've got an initial version coded up that I will send out as an RFC
> today.  Those patches build directly on this patch.
> 
> My thought behind sending this was that I worried that the fault isolation
> code wouldn't make it into v4.5, as we're already in the merge window.  That
> code by design has to touch both DAX and all the DAX filesystems (ext4, ext2
> and XFS).  Although, I guess a race that could result in data corruption
> probably warrants an -RC timed fix?
> 
> In any case, one way or another we really need this fix for v4.5.  Without it
> each PMD fault we receive will unmap the PMD range - even if that range is in
> use by other threads. So, you can get into the following situation:
> 
> Thread 1				Thread 2
> --------				--------
> PMD fault
>   unmap range for all threads
>   map range for just this thread
> 					PMD fault
> 					  unmap range for all threads
> 					  map range for just this thread
> PMD fault
>   unmap range for all threads
>   map range for just this thread
> 	  				...
> 
> Where two threads that are doing I/O to the same PMD will thrash and cause
> every access to trigger a PMD page fault.

OK, so your patch doesn't really make the locking changes any more
difficult so I don't mind going it in first. So feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> > > ---
> > >  fs/dax.c | 32 ++++++++++++++++++++++----------
> > >  1 file changed, 22 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/fs/dax.c b/fs/dax.c
> > > index afacc30..263aed1 100644
> > > --- a/fs/dax.c
> > > +++ b/fs/dax.c
> > > @@ -790,9 +790,9 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> > >  	bool write = flags & FAULT_FLAG_WRITE;
> > >  	struct block_device *bdev;
> > >  	pgoff_t size, pgoff;
> > > -	loff_t lstart, lend;
> > >  	sector_t block;
> > >  	int error, result = 0;
> > > +	bool alloc = false;
> > >  
> > >  	/* dax pmd mappings require pfn_t_devmap() */
> > >  	if (!IS_ENABLED(CONFIG_FS_DAX_PMD))
> > > @@ -830,10 +830,17 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> > >  	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
> > >  
> > >  	bh.b_size = PMD_SIZE;
> > > -	if (get_block(inode, block, &bh, write) != 0)
> > > +
> > > +	if (get_block(inode, block, &bh, 0) != 0)
> > >  		return VM_FAULT_SIGBUS;
> > > +
> > > +	if (!buffer_mapped(&bh) && write) {
> > > +		if (get_block(inode, block, &bh, 1) != 0)
> > > +			return VM_FAULT_SIGBUS;
> > > +		alloc = true;
> > > +	}
> > > +
> > >  	bdev = bh.b_bdev;
> > > -	i_mmap_lock_read(mapping);
> > >  
> > >  	/*
> > >  	 * If the filesystem isn't willing to tell us the length of a hole,
> > > @@ -842,15 +849,20 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> > >  	 */
> > >  	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE) {
> > >  		dax_pmd_dbg(&bh, address, "allocated block too small");
> > > -		goto fallback;
> > > +		return VM_FAULT_FALLBACK;
> > > +	}
> > > +
> > > +	/*
> > > +	 * If we allocated new storage, make sure no process has any
> > > +	 * zero pages covering this hole
> > > +	 */
> > > +	if (alloc) {
> > > +		loff_t lstart = pgoff << PAGE_SHIFT;
> > > +		loff_t lend = lstart + PMD_SIZE - 1; /* inclusive */
> > > +
> > > +		truncate_pagecache_range(inode, lstart, lend);
> > >  	}
> > >  
> > > -	/* make sure no process has any zero pages covering this hole */
> > > -	lstart = pgoff << PAGE_SHIFT;
> > > -	lend = lstart + PMD_SIZE - 1; /* inclusive */
> > > -	i_mmap_unlock_read(mapping);
> > > -	unmap_mapping_range(mapping, lstart, PMD_SIZE, 0);
> > > -	truncate_inode_pages_range(mapping, lstart, lend);
> > >  	i_mmap_lock_read(mapping);
> > >  
> > >  	/*
> > > -- 
> > > 2.5.0
> > > 
> > > 
> > -- 
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
