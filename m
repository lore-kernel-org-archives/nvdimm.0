Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 15 Oct 2015 09:53:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/2] dax: dax_pfn_mkwrite() truncate race check
Message-ID: <20151014225316.GQ31326@dastard>
References: <1444775137-23685-1-git-send-email-ross.zwisler@linux.intel.com>
 <1444775137-23685-2-git-send-email-ross.zwisler@linux.intel.com>
 <20151014052550.GL31326@dastard>
 <20151014084025.GA23758@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151014084025.GA23758@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 14, 2015 at 10:40:25AM +0200, Jan Kara wrote:
> On Wed 14-10-15 16:25:50, Dave Chinner wrote:
> > On Tue, Oct 13, 2015 at 04:25:36PM -0600, Ross Zwisler wrote:
> > > Update dax_pfn_mkwrite() so that it validates i_size before returning.
> > > This is necessary to ensure that the page fault has not raced with truncate
> > > and is now pointing to a region beyond the end of the current file.
> > > 
> > > This change is based on a similar outstanding patch for XFS from Dave
> > > Chinner entitled "xfs: add ->pfn_mkwrite support for DAX".
> > > 
> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > Cc: Dave Chinner <david@fromorbit.com>
> > > ---
> > >  fs/dax.c | 13 +++++++++++--
> > >  1 file changed, 11 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/dax.c b/fs/dax.c
> > > index 131fd35a..82be6e4 100644
> > > --- a/fs/dax.c
> > > +++ b/fs/dax.c
> > > @@ -693,12 +693,21 @@ EXPORT_SYMBOL_GPL(dax_pmd_fault);
> > >   */
> > >  int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> > >  {
> > > -	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
> > > +	struct inode *inode = file_inode(vma->vm_file);
> > > +	struct super_block *sb = inode->i_sb;
> > > +	int ret = VM_FAULT_NOPAGE;
> > > +	loff_t size;
> > >  
> > >  	sb_start_pagefault(sb);
> > >  	file_update_time(vma->vm_file);
> > > +
> > > +	/* check that the faulting page hasn't raced with truncate */
> > > +	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > > +	if (vmf->pgoff >= size)
> > > +		ret = VM_FAULT_SIGBUS;
> > > +
> > >  	sb_end_pagefault(sb);
> > > -	return VM_FAULT_NOPAGE;
> > > +	return ret;
> > 
> > This is still racy, as the read of the inode size is not serialised
> > against or ordered by any locks held by truncate. The check in XFS
> > is serialised against truncate by the XFS_MMAPLOCK and the generic
> > DAX code does not have such a mechanism to rely on. Hence I'd
> > suggest that the correct thing to do here is remove
> > dax_pfn_mkwrite() and force filesystems to implement their own
> > truncate-safe variants of ->pfn_mkwrite.
> 
> Well, the i_size check is just an optimization anyway. See below the
> discussion regarding the hole punch.
> 
> > And on further thought, I'm not sure that what I did with XFS is
> > at all correct when considering hole punching. That is, to get a PFN
> > based fault, we've already had to guarantee the file offset has
> > blocks allocated and mapped them. Then:
> > 
> > process 1				process 2
> > pfn_mkwrite @ X				punch hole @ X
> >  xfs_filemap_pfn_mkwrite		XFS_MMAPLOCK_EXCL
> >   XFS_MMAPLOCK_SHARED
> >     <blocks>
> > 					invalidate mapping @ X
> > 					remove blocks @ X
> > 					....
> > 					unlock XFS_MMAPLOCK_EXCL
> >    checks file size
> >   unlock XFS_MMAPLOCK_SHARED
> >   return VM_FAULT_NOPAGE
> > 
> > And so process 1 continues with an invalid page mapping over the
> > hole process 2 just punched in the file. That's a data
> > exposure/corruption problem the underlying blocks get reallocated
> > to some other file.
> > 
> > Unless I'm missing something here, this gets ugly real fast.
> 
> So how I convinced myself that this is not a problem is:
> 
> When process 2 invalidates mapping, it will also modify page tables to
> unmap freed pages. Then the pte_same() check in mm/memory.c:wp_pfn_shared()
> will fail, we bail out,

So this comes in through handle_pte_fault()? And if !pte_same(),
we return 0:

__handle_mm_fault
  handle_pte_fault
    do_wp_page
      wp_pfn_shared()
        ->pfn_mkwrite
          xfs_filemap_pfn_mkwrite
	    return VM_FAULT_NOPAGE
        !pte_same
        return 0;
      return 0;
    return 0;
  return 0;
return 0;

and so we return all the way back out to __do_page_fault() with a
return value of zero, which then thinks the page fault succeeded...

> CPU will retry the memory access which faults again
> and now we go the right path. So ->pfn_mkwrite() has to be prepared that
> the pfn under it actually isn't there anymore and current implementations
> don't really care so we are fine.

Ok, that's what I was missing - the CPU refaulting when retrying the
write and that provides the retry path.

IOWs, we're relying on pte_same() to catch the truncate/hole
punch invalidation of the pfn mapping, but that can only work if the
filesystem ->pfn_mkwrite implementation first serialises the page
fault against the pte invalidation that the hole punch/truncation
does.

Right?

My head hurts now.

> Trying to generalize when we are safe against such races: Unless we modify
> page tables or inode allocation information, we don't care about races with
> truncate() / punch_hole() so even the original dax_pfn_mkwrite() code was
> actually correct. But it's really subtle...

I'd call it "completely undocumented", not "subtle". :/

> I have this written down before ext4_dax_pfn_mkwrite() handler so that I
> don't forget but it would be good to add the comment also to some generic
> code.

It needs to go somewhere that people looking to implement
->pfn_mkwrite() will see.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
