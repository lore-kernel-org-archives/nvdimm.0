Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4249281B5B
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jan 2017 01:02:58 -0800 (PST)
Date: Wed, 11 Jan 2017 10:02:50 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] dax: assert that i_rwsem is held exclusive for writes
Message-ID: <20170111090250.GF16116@quack2.suse.cz>
References: <1484063288-18255-1-git-send-email-hch@lst.de>
 <1484063288-18255-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1484063288-18255-3-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 10-01-17 16:48:08, Christoph Hellwig wrote:
> Make sure all callers follow the same locking protocol, given that DAX
> transparantly replaced the normal buffered I/O path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

Probably also for Ted since it depends on the ext4 fix...

								Honza
> ---
>  fs/dax.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 5c74f60..04734da 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1061,8 +1061,12 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	loff_t pos = iocb->ki_pos, ret = 0, done = 0;
>  	unsigned flags = 0;
>  
> -	if (iov_iter_rw(iter) == WRITE)
> +	if (iov_iter_rw(iter) == WRITE) {
> +		lockdep_assert_held_exclusive(&inode->i_rwsem);
>  		flags |= IOMAP_WRITE;
> +	} else {
> +		lockdep_assert_held(&inode->i_rwsem);
> +	}
>  
>  	while (iov_iter_count(iter)) {
>  		ret = iomap_apply(inode, pos, iov_iter_count(iter), flags, ops,
> -- 
> 2.1.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
