Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 2 Mar 2018 23:54:55 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 09/12] mm, dax: replace IS_DAX() with IS_DEVDAX() or
	IS_FSDAX()
Message-ID: <20180302225455.GD31240@lst.de>
References: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com> <151996286235.28483.2635632878864807577.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151996286235.28483.2635632878864807577.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, stable@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org, hch@lst.de, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 01, 2018 at 07:54:22PM -0800, Dan Williams wrote:
>  static inline bool vma_is_dax(struct vm_area_struct *vma)
>  {
> -	return vma->vm_file && IS_DAX(vma->vm_file->f_mapping->host);
> +	struct inode *inode;
> +
> +	if (!vma->vm_file)
> +		return false;
> +	inode = file_inode(vma->vm_file);
> +	return IS_FSDAX(inode) || IS_DEVDAX(inode);

If you look at the definition of IS_FSDAX and IS_DEVDAX this
is going to evaluate into some bullshit code.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
