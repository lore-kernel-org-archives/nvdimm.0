Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D6AE91A1E77
 for <linux-nvdimm@lists.01.org>; Tue, 11 Oct 2016 11:42:31 -0700 (PDT)
Date: Tue, 11 Oct 2016 08:48:01 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 05/17] ext2: return -EIO on ext2_iomap_end() failure
Message-ID: <20161011064801.GA6952@quack2.suse.cz>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475874544-24842-6-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1475874544-24842-6-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 07-10-16 15:08:52, Ross Zwisler wrote:
> Right now we just return 0 for success, but we really want to let callers
> know about this failure.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/ext2/inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index c7dbb46..368913c 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -830,8 +830,10 @@ ext2_iomap_end(struct inode *inode, loff_t offset, loff_t length,
>  {
>  	if (iomap->type == IOMAP_MAPPED &&
>  	    written < length &&
> -	    (flags & IOMAP_WRITE))
> +	    (flags & IOMAP_WRITE)) {
>  		ext2_write_failed(inode->i_mapping, offset + length);
> +		return -EIO;
> +	}

So this is wrong. This (written < length) happens when we fail to copy data
to / from userspace buffer into pagecache pages / DAX blocks. It may be
because the passed buffer pointer is just wrong, or just because the page
got swapped out and we have to swap it back in. It is a role of upper
layers to decide what went wrong and proceed accordingly but from filesystem
point of view we just have to cancel the operation we have prepared and
return to upper layers. So returning 0 in this case is correct.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
