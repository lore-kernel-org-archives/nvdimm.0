Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 911582095B9DD
 for <linux-nvdimm@lists.01.org>; Mon, 21 Aug 2017 12:17:18 -0700 (PDT)
Date: Mon, 21 Aug 2017 13:19:48 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 13/13] ext4: Support for synchronous DAX faults
Message-ID: <20170821191948.GD26220@linux.intel.com>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-14-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-14-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 17, 2017 at 06:08:15PM +0200, Jan Kara wrote:
> We return IOMAP_F_NEEDDSYNC flag from ext4_iomap_begin() for a
> synchronous write fault when inode has some uncommitted metadata
> changes. In the fault handler ext4_dax_fault() we then detect this case,
> call vfs_fsync_range() to make sure all metadata is committed, and call
> dax_pfn_mkwrite() to mark PTE as writeable. Note that this will also

Need to fix up the above line a little -
s/dax_pfn_mkwrite/dax_insert_pfn_mkwrite/, and we insert the PTE as well as
make it writeable.

> dirty corresponding radix tree entry which is what we want - fsync(2)
> will still provide data integrity guarantees for applications not using
> userspace flushing. And applications using userspace flushing can avoid
> calling fsync(2) and thus avoid the performance overhead.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c       | 36 ++++++++++++++++++++++++++++++------
>  fs/ext4/inode.c      |  4 ++++
>  fs/jbd2/journal.c    | 17 +++++++++++++++++
>  include/linux/jbd2.h |  1 +
>  4 files changed, 52 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 850037e140d7..3765c4ed1368 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -280,6 +280,7 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
>  	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	struct super_block *sb = inode->i_sb;
>  	bool write = vmf->flags & FAULT_FLAG_WRITE;
> +	pfn_t pfn;
>  
>  	if (write) {
>  		sb_start_pagefault(sb);
> @@ -287,16 +288,39 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
>  		down_read(&EXT4_I(inode)->i_mmap_sem);
>  		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
>  					       EXT4_DATA_TRANS_BLOCKS(sb));
> +		if (IS_ERR(handle)) {
> +			up_read(&EXT4_I(inode)->i_mmap_sem);
> +			sb_end_pagefault(sb);
> +			return VM_FAULT_SIGBUS;
> +		}
>  	} else {
>  		down_read(&EXT4_I(inode)->i_mmap_sem);
>  	}
> -	if (!IS_ERR(handle))
> -		result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops, NULL);
> -	else
> -		result = VM_FAULT_SIGBUS;
> +	result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops, &pfn);
>  	if (write) {
> -		if (!IS_ERR(handle))
> -			ext4_journal_stop(handle);
> +		ext4_journal_stop(handle);
> +		/* Write fault but PFN mapped only RO? */

The above comment is out of date.

> +		if (result & VM_FAULT_NEEDDSYNC) {
> +			int err;
> +			loff_t start = ((loff_t)vmf->pgoff) << PAGE_SHIFT;
> +			size_t len = 0;
> +
> +			if (pe_size == PE_SIZE_PTE)
> +				len = PAGE_SIZE;
> +#ifdef CONFIG_FS_DAX_PMD
> +			else if (pe_size == PE_SIZE_PMD)
> +				len = HPAGE_PMD_SIZE;

In fs/dax.c we always use PMD_SIZE.  It looks like HPAGE_PMD_SIZE and PMD_SIZE
are always the same (from include/linux/huge_mm.h, the only defintion of
HPAGE_PMD_SIZE):

#define HPAGE_PMD_SHIFT PMD_SHIFT
#define HPAGE_PMD_SIZE	((1UL) << HPAGE_PMD_SHIFT)

and AFAICT PMD_SIZE is defined to be 1<<PMD_SHIFT for all architectures as
well.  I don't understand why we have both?

In any case, neither HPAGE_PMD_SIZE nor PMD_SIZE are used anywhere else in the
ext4 code, so can we use PMD_SIZE here for consistency?  If they ever did
manage to be different, I think we'd want PMD_SIZE anyway.

With those nits and an updated changelog:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
