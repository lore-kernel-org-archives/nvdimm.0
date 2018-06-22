Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6FFA8210D513F
 for <linux-nvdimm@lists.01.org>; Fri, 22 Jun 2018 01:19:17 -0700 (PDT)
Date: Fri, 22 Jun 2018 10:19:15 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: handle layout changes to pinned DAX mappings
Message-ID: <20180622081915.dvqd5sxx7vzoijw3@quack2.suse.cz>
References: <20180620221503.25237-1-ross.zwisler@linux.intel.com>
 <20180620221503.25237-3-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180620221503.25237-3-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 20-06-18 16:15:03, Ross Zwisler wrote:
> Follow the lead of xfs_break_dax_layouts() and add synchronization between
> operations in ext4 which remove blocks from an inode (hole punch, truncate
> down, etc.) and pages which are pinned due to DAX DMA operations.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/ext4/ext4.h     |  1 +
>  fs/ext4/extents.c  | 12 ++++++++++++
>  fs/ext4/inode.c    | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/truncate.h |  1 +
>  4 files changed, 62 insertions(+)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 0b127853c584..34bccd64d83d 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2460,6 +2460,7 @@ extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
>  extern int ext4_inode_attach_jinode(struct inode *inode);
>  extern int ext4_can_truncate(struct inode *inode);
>  extern int ext4_truncate(struct inode *);
> +extern int ext4_break_layouts(struct inode *);
>  extern int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length);
>  extern int ext4_truncate_restart_trans(handle_t *, struct inode *, int nblocks);
>  extern void ext4_set_inode_flags(struct inode *);
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 0057fe3f248d..a6aef06f455b 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4820,6 +4820,13 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  		 * released from page cache.
>  		 */
>  		down_write(&EXT4_I(inode)->i_mmap_sem);
> +
> +		ret = ext4_break_layouts(inode);
> +		if (ret) {
> +			up_write(&EXT4_I(inode)->i_mmap_sem);
> +			goto out_mutex;
> +		}
> +
>  		ret = ext4_update_disksize_before_punch(inode, offset, len);
>  		if (ret) {
>  			up_write(&EXT4_I(inode)->i_mmap_sem);
> @@ -5493,6 +5500,11 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
>  	 * page cache.
>  	 */
>  	down_write(&EXT4_I(inode)->i_mmap_sem);
> +
> +	ret = ext4_break_layouts(inode);
> +	if (ret)
> +		goto out_mmap;
> +
>  	/*
>  	 * Need to round down offset to be aligned with page size boundary
>  	 * for page size > block size.
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 2ea07efbe016..c795e5118745 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4193,6 +4193,41 @@ int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
>  	return 0;
>  }
>  
> +static void ext4_wait_dax_page(struct ext4_inode_info *ei, bool *did_unlock)
> +{
> +	*did_unlock = true;
> +	up_write(&ei->i_mmap_sem);
> +	schedule();
> +	down_write(&ei->i_mmap_sem);
> +}
> +
> +int ext4_break_layouts(struct inode *inode)
> +{
> +	struct ext4_inode_info *ei = EXT4_I(inode);
> +	struct page *page;
> +	bool retry;
> +	int error;
> +
> +	if (unlikely(!rwsem_is_locked(&ei->i_mmap_sem))) {
> +		WARN_ON_ONCE(1);
> +		return -EINVAL;
> +	}

This could be shortened as:

if (WARN_ON_ONCE(!rwsem_is_locked(&ei->i_mmap_sem))) {
}

couldn't it?

Besides that the patch looks to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

And I'm really wondering which protection are we still missing that you are
still able to hit the warning with these patches applied.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
