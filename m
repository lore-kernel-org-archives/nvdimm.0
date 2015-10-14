Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 14 Oct 2015 11:26:26 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 1/2] dax: dax_pfn_mkwrite() truncate race check
Message-ID: <20151014172626.GA14123@linux.intel.com>
References: <1444775137-23685-1-git-send-email-ross.zwisler@linux.intel.com>
 <1444775137-23685-2-git-send-email-ross.zwisler@linux.intel.com>
 <20151014052550.GL31326@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151014052550.GL31326@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 14, 2015 at 04:25:50PM +1100, Dave Chinner wrote:
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

Agreed, let's just drop this patch and remove dax_pfn_mkwrite().  The last
user of this function was ext4, and that usage goes away with Jan's latest
patch set.
