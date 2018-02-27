Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C3CDD22352282
 for <linux-nvdimm@lists.01.org>; Tue, 27 Feb 2018 08:59:54 -0800 (PST)
Date: Tue, 27 Feb 2018 18:05:59 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 09/12] mm, dax: replace IS_DAX() with IS_DEVDAX() or
 IS_FSDAX()
Message-ID: <20180227170559.o2uldn4t6wypfgic@quack2.suse.cz>
References: <151970519370.26729.1011551137381425076.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151970524289.26729.18096955322602992171.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151970524289.26729.18096955322602992171.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 26-02-18 20:20:42, Dan Williams wrote:
> In preparation for fixing the broken definition of S_DAX in the
> CONFIG_FS_DAX=n + CONFIG_DEV_DAX=y case, convert all IS_DAX() usages to
> use explicit tests for the DEVDAX and FSDAX sub-cases of DAX
> functionality.
> 
> Cc: Jan Kara <jack@suse.com>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: <stable@vger.kernel.org>
> Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Just one nit below. With that fixed you can add:

Reviewed-by: Jan Kara <jack@suse.cz>

> @@ -3208,21 +3208,19 @@ static inline bool io_is_direct(struct file *filp)
>  
>  static inline bool vma_is_dax(struct vm_area_struct *vma)
>  {
> -	return vma->vm_file && IS_DAX(vma->vm_file->f_mapping->host);
> +	struct inode *inode;
> +
> +	if (!vma->vm_file)
> +		return false;
> +	inode = vma->vm_file->f_mapping->host;

When changing this, use file_inode() here as well?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
