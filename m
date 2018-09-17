Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D6C921A07A82
 for <linux-nvdimm@lists.01.org>; Mon, 17 Sep 2018 09:37:13 -0700 (PDT)
Date: Mon, 17 Sep 2018 18:37:09 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 3/3] ext2, dax: set ext2_dax_aops for dax files
Message-ID: <20180917163709.GA10257@quack2.suse.cz>
References: <20180914145114.11122-1-toshi.kani@hpe.com>
 <20180914145114.11122-4-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180914145114.11122-4-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: tytso@mit.edu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, adilger.kernel@dilger.ca, jack@suse.cz, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri 14-09-18 08:51:14, Toshi Kani wrote:
> Sync syscall to DAX file needs to flush processor cache, but it
> currently does not flush to existing DAX files.  This is because
> 'ext2_da_aops' is set to address_space_operations of existing DAX
> files, instead of 'ext2_dax_aops', since S_DAX flag is set after
> ext2_set_aops() in the open path.
> 
> Similar to ext4, change ext2_iget() to initialize i_flags before
> ext2_set_aops().
> 
> Fixes: fb094c90748f ("ext2, dax: introduce ext2_dax_aops")
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: <stable@vger.kernel.org>

Thanks. I'll take the patch through my tree.

								Honza

> ---
>  fs/ext2/inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 7f7ee18fe179..e4bb9386c045 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1448,6 +1448,7 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
>  	}
>  	inode->i_blocks = le32_to_cpu(raw_inode->i_blocks);
>  	ei->i_flags = le32_to_cpu(raw_inode->i_flags);
> +	ext2_set_inode_flags(inode);
>  	ei->i_faddr = le32_to_cpu(raw_inode->i_faddr);
>  	ei->i_frag_no = raw_inode->i_frag;
>  	ei->i_frag_size = raw_inode->i_fsize;
> @@ -1517,7 +1518,6 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
>  			   new_decode_dev(le32_to_cpu(raw_inode->i_block[1])));
>  	}
>  	brelse (bh);
> -	ext2_set_inode_flags(inode);
>  	unlock_new_inode(inode);
>  	return inode;
>  	
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
