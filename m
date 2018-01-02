Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3682F21F9B698
 for <linux-nvdimm@lists.01.org>; Tue,  2 Jan 2018 13:11:43 -0800 (PST)
Date: Tue, 2 Jan 2018 13:15:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v4 12/18] xfs: use DEFINE_FSDAX_AOPS
Message-ID: <20180102211539.GH4857@magnolia>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407702457.38751.9874209243918617373.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407702457.38751.9874209243918617373.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Dec 23, 2017 at 04:57:04PM -0800, Dan Williams wrote:
> In preparation for the dax implementation to start associating dax pages
> to inodes via page->mapping, we need to provide a 'struct
> address_space_operations' instance for dax. Otherwise, direct-I/O
> triggers incorrect page cache assumptions and warnings.
> 
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: linux-xfs@vger.kernel.org
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/xfs/xfs_aops.c |    2 ++
>  fs/xfs/xfs_aops.h |    1 +
>  fs/xfs/xfs_iops.c |    5 ++++-
>  3 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 21e2d70884e1..361915d53cef 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1492,3 +1492,5 @@ const struct address_space_operations xfs_address_space_operations = {
>  	.is_partially_uptodate  = block_is_partially_uptodate,
>  	.error_remove_page	= generic_error_remove_page,
>  };
> +
> +DEFINE_FSDAX_AOPS(xfs_dax_address_space_operations, xfs_vm_writepages);

Hmm, if we ever re-enable changing the DAX flag on the fly, will
mapping->a_ops have to change dynamically too?

How sure are we that we'll never have to set anything in the dax aops
other than ->writepages?

(I also kinda wonder why not just make the callers savvy vs. a bunch of
dummy aops, but maybe that's been tried in a previous iteration?)

--D

> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index 88c85ea63da0..a6ffbb5fe379 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -54,6 +54,7 @@ struct xfs_ioend {
>  };
>  
>  extern const struct address_space_operations xfs_address_space_operations;
> +extern const struct address_space_operations xfs_dax_address_space_operations;
>  
>  int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 56475fcd76f2..67bd97edc73b 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1272,7 +1272,10 @@ xfs_setup_iops(
>  	case S_IFREG:
>  		inode->i_op = &xfs_inode_operations;
>  		inode->i_fop = &xfs_file_operations;
> -		inode->i_mapping->a_ops = &xfs_address_space_operations;
> +		if (IS_DAX(inode))
> +			inode->i_mapping->a_ops = &xfs_dax_address_space_operations;
> +		else
> +			inode->i_mapping->a_ops = &xfs_address_space_operations;
>  		break;
>  	case S_IFDIR:
>  		if (xfs_sb_version_hasasciici(&XFS_M(inode->i_sb)->m_sb))
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
