Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3DEF121CEB0F9
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 23:35:44 -0700 (PDT)
Date: Tue, 12 Sep 2017 08:38:38 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/5] ext4: prevent data corruption with inline data +
 DAX
Message-ID: <20170912063838.GA16554@quack2.suse.cz>
References: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
 <20170912050526.7627-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170912050526.7627-2-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 11-09-17 23:05:22, Ross Zwisler wrote:
> If an inode has inline data it is currently prevented from using DAX by a
> check in ext4_set_inode_flags().  When the inode grows inline data via
> ext4_create_inline_data() or removes its inline data via
> ext4_destroy_inline_data_nolock(), the value of S_DAX can change.
> 
> Currently these changes are unsafe because we don't hold off page faults
> and I/O, write back dirty radix tree entries and invalidate all mappings.
> There are also issues with mm-level races when changing the value of S_DAX,
> as well as issues with the VM_MIXEDMAP flag:
> 
> https://www.spinics.net/lists/linux-xfs/msg09859.html
> 
> The unsafe transition of S_DAX can reliably cause data corruption, as shown
> by the following fstest:
> 
> https://patchwork.kernel.org/patch/9948381/
> 
> Fix this issue by preventing the DAX mount option from being used on
> filesystems that were created to support inline data.  Inline data is an
> option given to mkfs.ext4.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> CC: stable@vger.kernel.org

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inline.c | 10 ----------
>  fs/ext4/super.c  |  5 +++++
>  2 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 28c5c3a..fd95019 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -302,11 +302,6 @@ static int ext4_create_inline_data(handle_t *handle,
>  	EXT4_I(inode)->i_inline_size = len + EXT4_MIN_INLINE_DATA_SIZE;
>  	ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
>  	ext4_set_inode_flag(inode, EXT4_INODE_INLINE_DATA);
> -	/*
> -	 * Propagate changes to inode->i_flags as well - e.g. S_DAX may
> -	 * get cleared
> -	 */
> -	ext4_set_inode_flags(inode);
>  	get_bh(is.iloc.bh);
>  	error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
>  
> @@ -451,11 +446,6 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
>  		}
>  	}
>  	ext4_clear_inode_flag(inode, EXT4_INODE_INLINE_DATA);
> -	/*
> -	 * Propagate changes to inode->i_flags as well - e.g. S_DAX may
> -	 * get set.
> -	 */
> -	ext4_set_inode_flags(inode);
>  
>  	get_bh(is.iloc.bh);
>  	error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index c9e7be5..4251e50 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3707,6 +3707,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  
>  	if (sbi->s_mount_opt & EXT4_MOUNT_DAX) {
> +		if (ext4_has_feature_inline_data(sb)) {
> +			ext4_msg(sb, KERN_ERR, "Cannot use DAX on a filesystem"
> +					" that may contain inline data");
> +			goto failed_mount;
> +		}
>  		err = bdev_dax_supported(sb, blocksize);
>  		if (err)
>  			goto failed_mount;
> -- 
> 2.9.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
