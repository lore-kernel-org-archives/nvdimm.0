Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 923E121F322AA
 for <linux-nvdimm@lists.01.org>; Tue,  3 Oct 2017 01:09:41 -0700 (PDT)
Date: Tue, 3 Oct 2017 10:12:59 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 4/4] dax: stop using VM_HUGEPAGE for dax
Message-ID: <20171003081259.GE11879@quack2.suse.cz>
References: <150664806143.36094.11882924009668860273.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150664808322.36094.377701515526275078.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150664808322.36094.377701515526275078.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu 28-09-17 18:21:23, Dan Williams wrote:
> This flag is deprecated in favor of the vma_is_dax() check in
> transparent_hugepage_enabled() added in commit baabda261424 "mm: always
> enable thp for dax mappings"
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I like this! You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/dax/device.c |    1 -
>  fs/ext4/file.c       |    1 -
>  fs/xfs/xfs_file.c    |    2 --
>  3 files changed, 4 deletions(-)
> 
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index ed79d006026e..74a35eb5e6d3 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -450,7 +450,6 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
>  		return rc;
>  
>  	vma->vm_ops = &dax_vm_ops;
> -	vma->vm_flags |= VM_HUGEPAGE;
>  	return 0;
>  }
>  
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 0cc9d205bd96..a54e1b4c49f9 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -352,7 +352,6 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
>  	file_accessed(file);
>  	if (IS_DAX(file_inode(file))) {
>  		vma->vm_ops = &ext4_dax_vm_ops;
> -		vma->vm_flags |= VM_HUGEPAGE;
>  	} else {
>  		vma->vm_ops = &ext4_file_vm_ops;
>  	}
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index dece8fe937f5..c0e0fcbe1bd3 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1130,8 +1130,6 @@ xfs_file_mmap(
>  {
>  	file_accessed(filp);
>  	vma->vm_ops = &xfs_file_vm_ops;
> -	if (IS_DAX(file_inode(filp)))
> -		vma->vm_flags |= VM_HUGEPAGE;
>  	return 0;
>  }
>  
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
