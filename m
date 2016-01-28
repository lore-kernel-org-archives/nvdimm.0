Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 28 Jan 2016 09:32:11 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] ext2, ext4: Fix issue with missing journal entry
Message-ID: <20160128163211.GA19770@linux.intel.com>
References: <1453921308-5544-1-git-send-email-ross.zwisler@linux.intel.com>
 <20160128131630.GI7726@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160128131630.GI7726@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 28, 2016 at 02:16:30PM +0100, Jan Kara wrote:
> On Wed 27-01-16 12:01:48, Ross Zwisler wrote:
> > As it is currently written ext4_dax_mkwrite() assumes that the call into
> > __dax_mkwrite() will not have to do a block allocation so it doesn't create
> > a journal entry.  For a read that creates a zero page to cover a hole
> > followed by a write that actually allocates storage this is incorrect.  The
> > ext4_dax_mkwrite() -> __dax_mkwrite() -> __dax_fault() path calls
> > get_blocks() to allocate storage.
> > 
> > Fix this by having the ->page_mkwrite fault handler call ext4_dax_fault()
> > as this function already has all the logic needed to allocate a journal
> > entry and call __dax_fault().
> > 
> > Also update the ext2 fault handlers in this same way to remove duplicate
> > code and keep the logic between ext2 and ext4 the same.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> Ah, ok, you are right. The patch looks good but Matthew is reworking the
> area more (so ext4_da_mkwrite() is likely to return) so it this worth it?
> Or do you expect Matthew's patches to land much later?

Yep, Matthew is in the process of reworking all of the DAX fault handling.

I was thinking that we might want to take this patch for v4.5, since it fixes
a bug that I'm guessing could lead to some sort of corruption (lack of a
journal entry entry for an allocating write), and then Matthew's reworks would
land in v4.6?

> > ---
> >  fs/ext2/file.c | 19 +------------------
> >  fs/ext4/file.c | 19 ++-----------------
> >  2 files changed, 3 insertions(+), 35 deletions(-)
> > 
> > diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> > index 2c88d68..c1400b1 100644
> > --- a/fs/ext2/file.c
> > +++ b/fs/ext2/file.c
> > @@ -80,23 +80,6 @@ static int ext2_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
> >  	return ret;
> >  }
> >  
> > -static int ext2_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> > -{
> > -	struct inode *inode = file_inode(vma->vm_file);
> > -	struct ext2_inode_info *ei = EXT2_I(inode);
> > -	int ret;
> > -
> > -	sb_start_pagefault(inode->i_sb);
> > -	file_update_time(vma->vm_file);
> > -	down_read(&ei->dax_sem);
> > -
> > -	ret = __dax_mkwrite(vma, vmf, ext2_get_block, NULL);
> > -
> > -	up_read(&ei->dax_sem);
> > -	sb_end_pagefault(inode->i_sb);
> > -	return ret;
> > -}
> > -
> >  static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
> >  		struct vm_fault *vmf)
> >  {
> > @@ -124,7 +107,7 @@ static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
> >  static const struct vm_operations_struct ext2_dax_vm_ops = {
> >  	.fault		= ext2_dax_fault,
> >  	.pmd_fault	= ext2_dax_pmd_fault,
> > -	.page_mkwrite	= ext2_dax_mkwrite,
> > +	.page_mkwrite	= ext2_dax_fault,
> >  	.pfn_mkwrite	= ext2_dax_pfn_mkwrite,
> >  };
> >  
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index 1126436..d2e8500 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -262,23 +262,8 @@ static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
> >  	return result;
> >  }
> >  
> > -static int ext4_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> > -{
> > -	int err;
> > -	struct inode *inode = file_inode(vma->vm_file);
> > -
> > -	sb_start_pagefault(inode->i_sb);
> > -	file_update_time(vma->vm_file);
> > -	down_read(&EXT4_I(inode)->i_mmap_sem);
> > -	err = __dax_mkwrite(vma, vmf, ext4_dax_mmap_get_block, NULL);
> > -	up_read(&EXT4_I(inode)->i_mmap_sem);
> > -	sb_end_pagefault(inode->i_sb);
> > -
> > -	return err;
> > -}
> > -
> >  /*
> > - * Handle write fault for VM_MIXEDMAP mappings. Similarly to ext4_dax_mkwrite()
> > + * Handle write fault for VM_MIXEDMAP mappings. Similarly to ext4_dax_fault()
> >   * handler we check for races agaist truncate. Note that since we cycle through
> >   * i_mmap_sem, we are sure that also any hole punching that began before we
> >   * were called is finished by now and so if it included part of the file we
> > @@ -311,7 +296,7 @@ static int ext4_dax_pfn_mkwrite(struct vm_area_struct *vma,
> >  static const struct vm_operations_struct ext4_dax_vm_ops = {
> >  	.fault		= ext4_dax_fault,
> >  	.pmd_fault	= ext4_dax_pmd_fault,
> > -	.page_mkwrite	= ext4_dax_mkwrite,
> > +	.page_mkwrite	= ext4_dax_fault,
> >  	.pfn_mkwrite	= ext4_dax_pfn_mkwrite,
> >  };
> >  #else
> > -- 
> > 2.5.0
> > 
> > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
