Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6637021CE748E
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 15:55:36 -0700 (PDT)
Date: Thu, 27 Jul 2017 16:57:39 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 7/7] ext4: Support for synchronous DAX faults
Message-ID: <20170727225739.GH22000@linux.intel.com>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-8-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170727131245.28279-8-jack@suse.cz>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 27, 2017 at 03:12:45PM +0200, Jan Kara wrote:
> We return IOMAP_F_NEEDDSYNC flag from ext4_iomap_begin() for a
> synchronous write fault when inode has some uncommitted metadata
> changes. In the fault handler ext4_dax_fault() we then detect this case,
> call vfs_fsync_range() to make sure all metadata is committed, and call
> dax_pfn_mkwrite() to mark PTE as writeable. Note that this will also
> dirty corresponding radix tree entry which is what we want - fsync(2)
> will still provide data integrity guarantees for applications not using
> userspace flushing. And applications using userspace flushing can avoid
> calling fsync(2) and thus avoid the performance overhead.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c       | 35 +++++++++++++++++++++++++++++------
>  fs/ext4/inode.c      |  4 ++++
>  fs/jbd2/journal.c    | 16 ++++++++++++++++
>  include/linux/jbd2.h |  1 +
>  4 files changed, 50 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index d401403e5095..b221d0b546b0 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -287,16 +287,39 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
>  		down_read(&EXT4_I(inode)->i_mmap_sem);
>  		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
>  					       EXT4_DATA_TRANS_BLOCKS(sb));
> +		if (IS_ERR(handle)) {
> +			up_read(&EXT4_I(inode)->i_mmap_sem);
> +			sb_end_pagefault(sb);
> +			return VM_FAULT_SIGBUS;
> +		}

Yay, this error handling seems cleaner to me anyway.

>  	} else {
>  		down_read(&EXT4_I(inode)->i_mmap_sem);
>  	}
> -	if (!IS_ERR(handle))
> -		result = dax_iomap_fault(vmf, pe_size, false, &ext4_iomap_ops);
> -	else
> -		result = VM_FAULT_SIGBUS;
> +	result = dax_iomap_fault(vmf, pe_size, IS_SYNC(inode), &ext4_iomap_ops);
>  	if (write) {
> -		if (!IS_ERR(handle))
> -			ext4_journal_stop(handle);
> +		ext4_journal_stop(handle);
> +		/* Write fault but PFN mapped only RO? */
> +		if (result & VM_FAULT_RO) {
> +			int err;
> +			loff_t start = ((loff_t)vmf->pgoff) << PAGE_SHIFT;
> +			size_t len = 0;
> +
> +			if (pe_size == PE_SIZE_PTE)
> +				len = PAGE_SIZE;
> +#ifdef CONFIG_FS_DAX_PMD
> +			else if (pe_size == PE_SIZE_PMD)
> +				len = HPAGE_PMD_SIZE;
> +			else
> +				WARN_ON_ONCE(1);

I think this "else WARN_ON_ONCE(1);" should live outside of the
CONFIG_FS_DAX_PMD so that we get warned in all configs if we get an
unsupported pe_size.

> +#endif
> +			WARN_ON_ONCE(!IS_SYNC(inode));
> +			err = vfs_fsync_range(vmf->vma->vm_file, start,
> +					      start + len - 1, 1);
> +			if (err)
> +				result = VM_FAULT_SIGBUS;
> +			else
> +				result = dax_pfn_mkwrite(vmf, pe_size);
> +		}
>  		up_read(&EXT4_I(inode)->i_mmap_sem);
>  		sb_end_pagefault(sb);
>  	} else {
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3c600f02673f..e68231bb227c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3429,6 +3429,10 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	}
>  
>  	iomap->flags = 0;
> +	if ((flags & IOMAP_FAULT) && (flags & IOMAP_WRITE) && IS_SYNC(inode) &&
> +	    !jbd2_transaction_committed(EXT4_SB(inode->i_sb)->s_journal,
> +					EXT4_I(inode)->i_datasync_tid))
> +		iomap->flags |= IOMAP_F_NEEDDSYNC;

Do we need to check for (flags & IOMAP_FAULT), or can we rely on the fact that
we are in ext4_iomap_begin()?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
