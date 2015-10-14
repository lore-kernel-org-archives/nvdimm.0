Return-Path: <linux-ext4-owner@vger.kernel.org>
Date: Wed, 14 Oct 2015 16:25:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/2] dax: dax_pfn_mkwrite() truncate race check
Message-ID: <20151014052550.GL31326@dastard>
References: <1444775137-23685-1-git-send-email-ross.zwisler@linux.intel.com>
 <1444775137-23685-2-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1444775137-23685-2-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 13, 2015 at 04:25:36PM -0600, Ross Zwisler wrote:
> Update dax_pfn_mkwrite() so that it validates i_size before returning.
> This is necessary to ensure that the page fault has not raced with truncate
> and is now pointing to a region beyond the end of the current file.
> 
> This change is based on a similar outstanding patch for XFS from Dave
> Chinner entitled "xfs: add ->pfn_mkwrite support for DAX".
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Dave Chinner <david@fromorbit.com>
> ---
>  fs/dax.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 131fd35a..82be6e4 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -693,12 +693,21 @@ EXPORT_SYMBOL_GPL(dax_pmd_fault);
>   */
>  int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
> -	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
> +	struct inode *inode = file_inode(vma->vm_file);
> +	struct super_block *sb = inode->i_sb;
> +	int ret = VM_FAULT_NOPAGE;
> +	loff_t size;
>  
>  	sb_start_pagefault(sb);
>  	file_update_time(vma->vm_file);
> +
> +	/* check that the faulting page hasn't raced with truncate */
> +	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	if (vmf->pgoff >= size)
> +		ret = VM_FAULT_SIGBUS;
> +
>  	sb_end_pagefault(sb);
> -	return VM_FAULT_NOPAGE;
> +	return ret;

This is still racy, as the read of the inode size is not serialised
against or ordered by any locks held by truncate. The check in XFS
is serialised against truncate by the XFS_MMAPLOCK and the generic
DAX code does not have such a mechanism to rely on. Hence I'd
suggest that the correct thing to do here is remove
dax_pfn_mkwrite() and force filesystems to implement their own
truncate-safe variants of ->pfn_mkwrite.

And on further thought, I'm not sure that what I did with XFS is
at all correct when considering hole punching. That is, to get a PFN
based fault, we've already had to guarantee the file offset has
blocks allocated and mapped them. Then:

process 1				process 2
pfn_mkwrite @ X				punch hole @ X
 xfs_filemap_pfn_mkwrite		XFS_MMAPLOCK_EXCL
  XFS_MMAPLOCK_SHARED
    <blocks>
					invalidate mapping @ X
					remove blocks @ X
					....
					unlock XFS_MMAPLOCK_EXCL
   checks file size
  unlock XFS_MMAPLOCK_SHARED
  return VM_FAULT_NOPAGE

And so process 1 continues with an invalid page mapping over the
hole process 2 just punched in the file. That's a data
exposure/corruption problem the underlying blocks get reallocated
to some other file.

Unless I'm missing something here, this gets ugly real fast.

If we treat ->pfn_mkwrite like ->page_mkwrite() and allocate blocks
under the pfn that was invalidated and punched out by the hole punch
operation, then *the physical pfn that maps to the file offset that
the page fault occurred for changes*.

So, we can't allocate new blocks during ->pfn_mkwrite. All we can
do is check the pfn mapping is still valid when we have serialised
against hole punch/truncate, and if it isn't we need to return
VM_FAULT_RETRY so that the page fault is restarted to find the new
mapping which can then have ->page_mkwrite/->pfn_mkwrite called
on it.

The biggest problem here is that VM_FAULT_RETRY will only allow one
retry of the page fault - if the page fault races twice in a row
with a hole punch (need 3 processes, two doing write faults at the
same offset, and the other repeatedly hole punching the same offset)
then we'll SIGBUS the process on the second VM_FAULT_RETRY in a row
from ->pfn_mkwrite....

And because I don't have all day to work out all the twisty paths of
the page fault code, where is a pfn-based read fault validated
against racing truncate/holepunch operations freeing the
underlying storage?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
