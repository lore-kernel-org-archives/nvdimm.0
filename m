Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6C46921E8796F
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 23:42:05 -0700 (PDT)
Date: Tue, 12 Sep 2017 08:45:00 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 3/5] ext4: add sanity check for encryption + DAX
Message-ID: <20170912064500.GC16554@quack2.suse.cz>
References: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
 <20170912050526.7627-4-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170912050526.7627-4-ross.zwisler@linux.intel.com>
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

On Mon 11-09-17 23:05:24, Ross Zwisler wrote:
> We prevent DAX from being used on inodes which are using ext4's built in
> encryption via a check in ext4_set_inode_flags().  We do have what appears
> to be an unsafe transition of S_DAX in ext4_set_context(), though, where
> S_DAX can get disabled without us doing a proper writeback + invalidate.
> 
> There are also issues with mm-level races when changing the value of S_DAX,
> as well as issues with the VM_MIXEDMAP flag:
> 
> https://www.spinics.net/lists/linux-xfs/msg09859.html
> 
> I actually think we are safe in this case because of the following:
> 
> 1) You can't encrypt an existing file.  Encryption can only be set on an
> empty directory, with new inodes in that directory being created with
> encryption turned on, so I don't think it's possible to turn encryption on
> for a file that has open DAX mmaps or outstanding I/Os.
> 
> 2) There is no way to turn encryption off on a given file.  Once an inode
> is encrypted, it stays encrypted for the life of that inode, so we don't
> have to worry about the case where we turn encryption off and S_DAX
> suddenly turns on.
> 
> 3) The only way we end up in ext4_set_context() to turn on encryption is
> when we are creating a new file in the encrypted directory.  This happens
> as part of ext4_create() before the inode has been allowed to do any I/O.
> Here's the call tree:
> 
>  ext4_create()
>    __ext4_new_inode()
> 	 ext4_set_inode_flags() // sets S_DAX
> 	 fscrypt_inherit_context()
> 		fscrypt_get_encryption_info();
> 		ext4_set_context() // sets EXT4_INODE_ENCRYPT, clears S_DAX
> 
> So, I actually think it's safe to transition S_DAX in ext4_set_context()
> without any locking, writebacks or invalidations.  I've added a
> WARN_ON_ONCE() sanity check to make sure that we are notified if we ever
> encounter a case where we are encrypting an inode that already has data,
> in which case we need to add code to safely transition S_DAX.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> CC: stable@vger.kernel.org

Looks good to me - and frankly I think we can drop the stable CC here...
Anyway, you can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 4251e50..c090780 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1159,6 +1159,9 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>  	if (inode->i_ino == EXT4_ROOT_INO)
>  		return -EPERM;
>  
> +	if (WARN_ON_ONCE(IS_DAX(inode) && i_size_read(inode)))
> +		return -EINVAL;
> +
>  	res = ext4_convert_inline_data(inode);
>  	if (res)
>  		return res;
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
