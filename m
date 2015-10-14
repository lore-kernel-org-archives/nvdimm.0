Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 14 Oct 2015 10:40:25 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/2] dax: dax_pfn_mkwrite() truncate race check
Message-ID: <20151014084025.GA23758@quack.suse.cz>
References: <1444775137-23685-1-git-send-email-ross.zwisler@linux.intel.com>
 <1444775137-23685-2-git-send-email-ross.zwisler@linux.intel.com>
 <20151014052550.GL31326@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151014052550.GL31326@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 14-10-15 16:25:50, Dave Chinner wrote:
> On Tue, Oct 13, 2015 at 04:25:36PM -0600, Ross Zwisler wrote:
> > Update dax_pfn_mkwrite() so that it validates i_size before returning.
> > This is necessary to ensure that the page fault has not raced with truncate
> > and is now pointing to a region beyond the end of the current file.
> > 
> > This change is based on a similar outstanding patch for XFS from Dave
> > Chinner entitled "xfs: add ->pfn_mkwrite support for DAX".
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Cc: Dave Chinner <david@fromorbit.com>
> > ---
> >  fs/dax.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 131fd35a..82be6e4 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -693,12 +693,21 @@ EXPORT_SYMBOL_GPL(dax_pmd_fault);
> >   */
> >  int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  {
> > -	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
> > +	struct inode *inode = file_inode(vma->vm_file);
> > +	struct super_block *sb = inode->i_sb;
> > +	int ret = VM_FAULT_NOPAGE;
> > +	loff_t size;
> >  
> >  	sb_start_pagefault(sb);
> >  	file_update_time(vma->vm_file);
> > +
> > +	/* check that the faulting page hasn't raced with truncate */
> > +	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > +	if (vmf->pgoff >= size)
> > +		ret = VM_FAULT_SIGBUS;
> > +
> >  	sb_end_pagefault(sb);
> > -	return VM_FAULT_NOPAGE;
> > +	return ret;
> 
> This is still racy, as the read of the inode size is not serialised
> against or ordered by any locks held by truncate. The check in XFS
> is serialised against truncate by the XFS_MMAPLOCK and the generic
> DAX code does not have such a mechanism to rely on. Hence I'd
> suggest that the correct thing to do here is remove
> dax_pfn_mkwrite() and force filesystems to implement their own
> truncate-safe variants of ->pfn_mkwrite.

Well, the i_size check is just an optimization anyway. See below the
discussion regarding the hole punch.

> And on further thought, I'm not sure that what I did with XFS is
> at all correct when considering hole punching. That is, to get a PFN
> based fault, we've already had to guarantee the file offset has
> blocks allocated and mapped them. Then:
> 
> process 1				process 2
> pfn_mkwrite @ X				punch hole @ X
>  xfs_filemap_pfn_mkwrite		XFS_MMAPLOCK_EXCL
>   XFS_MMAPLOCK_SHARED
>     <blocks>
> 					invalidate mapping @ X
> 					remove blocks @ X
> 					....
> 					unlock XFS_MMAPLOCK_EXCL
>    checks file size
>   unlock XFS_MMAPLOCK_SHARED
>   return VM_FAULT_NOPAGE
> 
> And so process 1 continues with an invalid page mapping over the
> hole process 2 just punched in the file. That's a data
> exposure/corruption problem the underlying blocks get reallocated
> to some other file.
> 
> Unless I'm missing something here, this gets ugly real fast.

So how I convinced myself that this is not a problem is:

When process 2 invalidates mapping, it will also modify page tables to
unmap freed pages. Then the pte_same() check in mm/memory.c:wp_pfn_shared()
will fail, we bail out, CPU will retry the memory access which faults again
and now we go the right path. So ->pfn_mkwrite() has to be prepared that
the pfn under it actually isn't there anymore and current implementations
don't really care so we are fine.

Trying to generalize when we are safe against such races: Unless we modify
page tables or inode allocation information, we don't care about races with
truncate() / punch_hole() so even the original dax_pfn_mkwrite() code was
actually correct. But it's really subtle...

I have this written down before ext4_dax_pfn_mkwrite() handler so that I
don't forget but it would be good to add the comment also to some generic
code.

> If we treat ->pfn_mkwrite like ->page_mkwrite() and allocate blocks
> under the pfn that was invalidated and punched out by the hole punch
> operation, then *the physical pfn that maps to the file offset that
> the page fault occurred for changes*.
> 
> So, we can't allocate new blocks during ->pfn_mkwrite. All we can
> do is check the pfn mapping is still valid when we have serialised
> against hole punch/truncate, and if it isn't we need to return
> VM_FAULT_RETRY so that the page fault is restarted to find the new
> mapping which can then have ->page_mkwrite/->pfn_mkwrite called
> on it.
> 
> The biggest problem here is that VM_FAULT_RETRY will only allow one
> retry of the page fault - if the page fault races twice in a row
> with a hole punch (need 3 processes, two doing write faults at the
> same offset, and the other repeatedly hole punching the same offset)
> then we'll SIGBUS the process on the second VM_FAULT_RETRY in a row
> from ->pfn_mkwrite....
> 
> And because I don't have all day to work out all the twisty paths of
> the page fault code, where is a pfn-based read fault validated
> against racing truncate/holepunch operations freeing the
> underlying storage?

Do you mean a fault which ends up in dax_fault()? There we use that:

a) we hold fs specific i_mmap_lock in exclusive mode in truncate / punch
   hole over complete sequence of "invalidate mappings, remove blocks from
   inode".

b) we hold fs specific i_mmap_lock in shared mode in fault over the
   sequence "lookup block, install into page tables".

So I don't see a way how we could end up with page tables referencing freed
blocks - either fault finds a hole which it instantiates in page tables or
it finds a block, instantiates it in page tables, and subsequent truncate
will remove the block from page tables again. But I guess you are well
aware of this so maybe I misunderstood your question.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
