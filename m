Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 63E2E2095AE63
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 12:23:50 -0700 (PDT)
Date: Thu, 24 Aug 2017 13:26:24 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/3] iomap: return VM_FAULT_* codes from iomap_page_mkwrite
Message-ID: <20170824192624.GA20489@linux.intel.com>
References: <20170824152207.30729-1-hch@lst.de>
 <20170824152207.30729-2-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170824152207.30729-2-hch@lst.de>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 05:22:05PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This is obviously correct, but the lack of changelog makes it unclear why the
change is being made.  Does a later patch in the series depend on
iomap_page_mkwrite() returning VM_FAULT_* codes?  Is this just cleanup so you
can hide the block_page_mkwrite_return() call inside of iomap_page_mkwrite()?

I think it's the former, so the logic in __xfs_filemap_fault() is simpler?

Anyway, the code is correct, so you can add:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

> ---
>  fs/iomap.c        | 4 ++--
>  fs/xfs/xfs_file.c | 1 -
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 039266128b7f..22ffdfeabeda 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -477,10 +477,10 @@ int iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops)
>  
>  	set_page_dirty(page);
>  	wait_for_stable_page(page);
> -	return 0;
> +	return VM_FAULT_LOCKED;
>  out_unlock:
>  	unlock_page(page);
> -	return ret;
> +	return block_page_mkwrite_return(ret);
>  }
>  EXPORT_SYMBOL_GPL(iomap_page_mkwrite);
>  
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index afa226b8c290..4213f02325a2 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1035,7 +1035,6 @@ xfs_filemap_page_mkwrite(
>  		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, NULL, &xfs_iomap_ops);
>  	} else {
>  		ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
> -		ret = block_page_mkwrite_return(ret);
>  	}
>  
>  	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -- 
> 2.11.0
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
