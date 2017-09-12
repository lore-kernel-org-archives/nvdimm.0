Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C25921E8796F
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 23:43:18 -0700 (PDT)
Date: Tue, 12 Sep 2017 08:46:12 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 4/5] ext4: add ext4_should_use_dax()
Message-ID: <20170912064612.GD16554@quack2.suse.cz>
References: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
 <20170912050526.7627-5-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170912050526.7627-5-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 11-09-17 23:05:25, Ross Zwisler wrote:
> This helper, in the spirit of ext4_should_dioread_nolock() et al., replaces
> the complex conditional in ext4_set_inode_flags().
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Yeah, makes sense to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3207333..525dd63 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4577,6 +4577,21 @@ int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
>  		!ext4_test_inode_state(inode, EXT4_STATE_XATTR));
>  }
>  
> +static bool ext4_should_use_dax(struct inode *inode)
> +{
> +	if (!test_opt(inode->i_sb, DAX))
> +		return false;
> +	if (!S_ISREG(inode->i_mode))
> +		return false;
> +	if (ext4_should_journal_data(inode))
> +		return false;
> +	if (ext4_has_inline_data(inode))
> +		return false;
> +	if (ext4_encrypted_inode(inode))
> +		return false;
> +	return true;
> +}
> +
>  void ext4_set_inode_flags(struct inode *inode)
>  {
>  	unsigned int flags = EXT4_I(inode)->i_flags;
> @@ -4592,9 +4607,7 @@ void ext4_set_inode_flags(struct inode *inode)
>  		new_fl |= S_NOATIME;
>  	if (flags & EXT4_DIRSYNC_FL)
>  		new_fl |= S_DIRSYNC;
> -	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode) &&
> -	    !ext4_should_journal_data(inode) && !ext4_has_inline_data(inode) &&
> -	    !ext4_encrypted_inode(inode))
> +	if (ext4_should_use_dax(inode))
>  		new_fl |= S_DAX;
>  	inode_set_flags(inode, new_fl,
>  			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX);
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
