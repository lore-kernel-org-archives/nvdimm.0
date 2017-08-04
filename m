Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
 [150.101.137.136])
 by ml01.01.org (Postfix) with ESMTP id 9595F21E1DAD0
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 16:29:30 -0700 (PDT)
Date: Sat, 5 Aug 2017 09:31:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/5] fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
Message-ID: <20170804233140.GF21024@dastard>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150181369754.32119.7390149918955188408.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150181369754.32119.7390149918955188408.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 03, 2017 at 07:28:17PM -0700, Dan Williams wrote:
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index fe0f8f7f4bb7..46d8eb9e19fc 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1393,6 +1393,107 @@ xfs_zero_file_space(
>  
>  }
>  
> +/* Return 1 if hole detected, 0 if not, and < 0 if fail to determine */
> +STATIC int
> +xfs_file_has_holes(
> +	struct xfs_inode	*ip)
> +{

Why do we need this function?

We've just run xfs_alloc_file_space() across the entire range we
are sealing, so we've already guaranteed that it won't have holes
in it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
