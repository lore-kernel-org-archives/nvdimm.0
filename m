Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2455181FD1
 for <linux-nvdimm@lists.01.org>; Thu, 15 Dec 2016 15:23:22 -0800 (PST)
Date: Thu, 15 Dec 2016 16:23:21 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 2/3] mm, dax: make pmd_fault() and friends to be the
 same as fault()
Message-ID: <20161215232321.GA10460@linux.intel.com>
References: <148183505925.96369.9987658623875784437.stgit@djiang5-desk3.ch.intel.com>
 <148183506511.96369.3577733318086932161.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <148183506511.96369.3577733318086932161.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-mm@kvack.org, tytso@mit.edu, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 15, 2016 at 01:51:05PM -0700, Dave Jiang wrote:
> Instead of passing in multiple parameters in the pmd_fault() handler,
> a vmf can be passed in just like a fault() handler. This will simplify
> code and remove the need for the actual pmd fault handlers to allocate a
> vmf. Related functions are also modified to do the same.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---

> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index a3f2bf0..e6cdb78 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -278,22 +278,26 @@ static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	return result;
>  }
>  
> -static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
> -						pmd_t *pmd, unsigned int flags)
> +static int
> +ext4_dax_pmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
>  	int result;
>  	struct inode *inode = file_inode(vma->vm_file);
>  	struct super_block *sb = inode->i_sb;
> -	bool write = flags & FAULT_FLAG_WRITE;
> +	bool write = vmf->flags & FAULT_FLAG_WRITE;
> +	gfp_t old_mask;
>  
>  	if (write) {
>  		sb_start_pagefault(sb);
>  		file_update_time(vma->vm_file);
>  	}
> +
> +	old_mask = vmf->gfp_mask;
> +	vmf->gfp_mask &= ~__GFP_FS;
>  	down_read(&EXT4_I(inode)->i_mmap_sem);
> -	result = dax_iomap_pmd_fault(vma, addr, pmd, flags,
> -				     &ext4_iomap_ops);
> +	result = dax_iomap_pmd_fault(vma, vmf, &ext4_iomap_ops);
>  	up_read(&EXT4_I(inode)->i_mmap_sem);
> +	vmf->gfp_mask = old_mask;
>  	if (write)
>  		sb_end_pagefault(sb);
>  
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 52202b4..b1b8524 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1533,29 +1533,31 @@ xfs_filemap_fault(
>  STATIC int
>  xfs_filemap_pmd_fault(
>  	struct vm_area_struct	*vma,
> -	unsigned long		addr,
> -	pmd_t			*pmd,
> -	unsigned int		flags)
> +	struct vm_fault *vmf)
>  {
>  	struct inode		*inode = file_inode(vma->vm_file);
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	int			ret;
> +	gfp_t			old_mask;
>  
>  	if (!IS_DAX(inode))
>  		return VM_FAULT_FALLBACK;
>  
>  	trace_xfs_filemap_pmd_fault(ip);
>  
> -	if (flags & FAULT_FLAG_WRITE) {
> +	if (vmf->flags & FAULT_FLAG_WRITE) {
>  		sb_start_pagefault(inode->i_sb);
>  		file_update_time(vma->vm_file);
>  	}
>  
> +	old_mask = vmf->gfp_mask;

One small nit for both xfs and ext4 - in patch 1 you named your local
'old_gfp' and set it when it was defined, but in this patch it's 'old_mask'
and it's set later.  Probably best to keep this patch consistent with the
first one.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
