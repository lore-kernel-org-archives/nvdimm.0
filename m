Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F0381A1E11
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 02:12:40 -0700 (PDT)
Date: Tue, 16 Aug 2016 11:12:38 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/7] ext4: tell DAX the size of allocation holes
Message-ID: <20160816091238.GB27284@quack2.suse.cz>
References: <20160815190918.20672-1-ross.zwisler@linux.intel.com>
 <20160815190918.20672-3-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160815190918.20672-3-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 15-08-16 13:09:13, Ross Zwisler wrote:
> When DAX calls _ext4_get_block() and the file offset points to a hole we
> currently don't set bh->b_size.  When we re-enable PMD faults DAX will
> need bh->b_size to tell it the size of the hole so it can decide whether to
> fault in a 4 KiB zero page or a 2 MiB zero page.
> 
> _ext4_get_block() has the hole size information from ext4_map_blocks(), so
> populate bh->b_size.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3131747..1808013 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -759,6 +759,9 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
>  		ext4_update_bh_state(bh, map.m_flags);
>  		bh->b_size = inode->i_sb->s_blocksize * map.m_len;
>  		ret = 0;
> +	} else if (ret == 0) {
> +		/* hole case, need to fill in bh->b_size */
> +		bh->b_size = inode->i_sb->s_blocksize * map.m_len;
>  	}
>  	return ret;
>  }
> -- 
> 2.9.0
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
