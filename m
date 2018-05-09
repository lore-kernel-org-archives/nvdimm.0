Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ABCF920945D8C
 for <linux-nvdimm@lists.01.org>; Wed,  9 May 2018 03:56:21 -0700 (PDT)
Date: Wed, 9 May 2018 12:56:19 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v9 6/9] mm, fs, dax: handle layout changes to pinned dax
 mappings
Message-ID: <20180509105619.e3go5wj63wmnvcxo@quack2.suse.cz>
References: <152461278149.17530.2867511144531572045.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152461281488.17530.18202569789906788866.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152461281488.17530.18202569789906788866.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 24-04-18 16:33:35, Dan Williams wrote:
> Background:
> 
> get_user_pages() in the filesystem pins file backed memory pages for
> access by devices performing dma. However, it only pins the memory pages
> not the page-to-file offset association. If a file is truncated the
> pages are mapped out of the file and dma may continue indefinitely into
> a page that is owned by a device driver. This breaks coherency of the
> file vs dma, but the assumption is that if userspace wants the
> file-space truncated it does not matter what data is inbound from the
> device, it is not relevant anymore. The only expectation is that dma can
> safely continue while the filesystem reallocates the block(s).
> 
> Problem:
> 
> This expectation that dma can safely continue while the filesystem
> changes the block map is broken by dax. With dax the target dma page
> *is* the filesystem block. The model of leaving the page pinned for dma,
> but truncating the file block out of the file, means that the filesytem
> is free to reallocate a block under active dma to another file and now
> the expected data-incoherency situation has turned into active
> data-corruption.
> 
> Solution:
> 
> Defer all filesystem operations (fallocate(), truncate()) on a dax mode
> file while any page/block in the file is under active dma. This solution
> assumes that dma is transient. Cases where dma operations are known to
> not be transient, like RDMA, have been explicitly disabled via
> commits like 5f1d43de5416 "IB/core: disable memory registration of
> filesystem-dax vmas".
> 
> The dax_layout_busy_page() routine is called by filesystems with a lock
> held against mm faults (i_mmap_lock) to find pinned / busy dax pages.
> The process of looking up a busy page invalidates all mappings
> to trigger any subsequent get_user_pages() to block on i_mmap_lock.
> The filesystem continues to call dax_layout_busy_page() until it finally
> returns no more active pages. This approach assumes that the page
> pinning is transient, if that assumption is violated the system would
> have likely hung from the uncompleted I/O.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

A few nits below. After fixing those feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 86b3806ea35b..89f21bd9da10 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -167,7 +167,7 @@ struct dax_device {
>  #if IS_ENABLED(CONFIG_FS_DAX) && IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS)
>  static void generic_dax_pagefree(struct page *page, void *data)
>  {
> -	/* TODO: wakeup page-idle waiters */
> +	wake_up_var(&page->_refcount);
>  }
>  
>  static struct dax_device *__fs_dax_claim(struct dax_device *dax_dev,

Why is this hunk in this patch? We don't wait for page refcount here. OTOH
I agree I don't see much better patch to fold this into.

> diff --git a/fs/Kconfig b/fs/Kconfig
> index 1e050e012eb9..c9acbf695ddd 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -40,6 +40,7 @@ config FS_DAX
>  	depends on !(ARM || MIPS || SPARC)
>  	select DEV_PAGEMAP_OPS if (ZONE_DEVICE && !FS_DAX_LIMITED)
>  	select FS_IOMAP
> +	select SRCU

No need for this anymore I guess.

> diff --git a/mm/gup.c b/mm/gup.c
> index 84dd2063ca3d..75ade7ebddb2 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -13,6 +13,7 @@
>  #include <linux/sched/signal.h>
>  #include <linux/rwsem.h>
>  #include <linux/hugetlb.h>
> +#include <linux/dax.h>
>  
>  #include <asm/mmu_context.h>
>  #include <asm/pgtable.h>

Why is this hunk here?

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
