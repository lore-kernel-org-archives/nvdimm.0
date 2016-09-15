Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1733E1A1F03
 for <linux-nvdimm@lists.01.org>; Thu, 15 Sep 2016 13:09:30 -0700 (PDT)
Date: Thu, 15 Sep 2016 14:09:28 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 2/9] ext2: tell DAX the size of allocation holes
Message-ID: <20160915200928.GA8200@linux.intel.com>
References: <20160823220419.11717-1-ross.zwisler@linux.intel.com>
 <20160823220419.11717-3-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160823220419.11717-3-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 23, 2016 at 04:04:12PM -0600, Ross Zwisler wrote:
> When DAX calls ext2_get_block() and the file offset points to a hole we
> currently don't set bh_result->b_size.  When we re-enable PMD faults DAX
> will need bh_result->b_size to tell it the size of the hole so it can
> decide whether to fault in a 4 KiB zero page or a 2 MiB zero page.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/ext2/inode.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index d5c7d09..dd55d74 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -773,6 +773,9 @@ int ext2_get_block(struct inode *inode, sector_t iblock, struct buffer_head *bh_
>  	if (ret > 0) {
>  		bh_result->b_size = (ret << inode->i_blkbits);
>  		ret = 0;
> +	} else if (ret == 0) {
> +		/* hole case, need to fill in bh_result->b_size */
> +		bh_result->b_size = 1 << inode->i_blkbits;
>  	}
>  	return ret;
>  
> -- 
> 2.9.0
> 

Jan, is it possible for ext2 to return 2 MiB of contiguous space to us via
ext2_get_block()?

I ask because we have all the infrastructure in place for ext2 to handle PMD
faults (ext2_dax_pmd_fault(), etc.), but I don't think in my testing I've ever
seen this actually happen.

ext2 can obviously return multiple blocks from ext2_get_block(), but can it
actually satisfy a whole PMD's worth (512 contiguous blocks)?  If so, what
steps do I need to take to get this to work in my testing?

If it can't happen, we should probably rip out ext2_dax_pmd_fault() so that we
don't have to keep falling back to PTEs via the PMD path.

Thanks,
- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
