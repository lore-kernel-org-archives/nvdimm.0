Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2E3DB21F0DB0E
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 08:22:08 -0700 (PDT)
Date: Thu, 29 Mar 2018 17:28:45 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v7 02/14] fs, dax: prepare for dax-specific
 address_space_operations
Message-ID: <20180329152845.wvskcbhremndtuzg@quack2.suse.cz>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167304153.5268.5998667213622821211.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152167304153.5268.5998667213622821211.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 21-03-18 15:57:21, Dan Williams wrote:
> In preparation for the dax implementation to start associating dax pages
> to inodes via page->mapping, we need to provide a 'struct
> address_space_operations' instance for dax. Define some generic VFS aops
> helpers for dax. These noop implementations are there in the dax case to
> prevent the VFS from falling back to operations with page-cache
> assumptions, dax_writeback_mapping_range() may not be referenced in the
> FS_DAX=n case.
> 
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Matthew Wilcox <mawilcox@microsoft.com>
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me. I'm just wondering whether we should not add also some
stubs calling WARN_ON() and bailing out for stuff like ->migratepage(),
->releasepage(). But probably it is very unlikely we'll introduce bugs that
would trigger those paths so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/libfs.c          |   27 +++++++++++++++++++++++++++
>  include/linux/dax.h |   12 +++++++++---
>  include/linux/fs.h  |    3 +++
>  3 files changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 7ff3cb904acd..e49d0ac6f800 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -1060,6 +1060,33 @@ int noop_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  }
>  EXPORT_SYMBOL(noop_fsync);
>  
> +int noop_set_page_dirty(struct page *page)
> +{
> +	/*
> +	 * Unlike __set_page_dirty_no_writeback that handles dirty page
> +	 * tracking in the page object, dax does all dirty tracking in
> +	 * the inode address_space in response to mkwrite faults. In the
> +	 * dax case we only need to worry about potentially dirty CPU
> +	 * caches, not dirty page cache pages to write back.
> +	 *
> +	 * This callback is defined to prevent fallback to
> +	 * __set_page_dirty_buffers() in set_page_dirty().
> +	 */
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(noop_set_page_dirty);
> +
> +void noop_invalidatepage(struct page *page, unsigned int offset,
> +		unsigned int length)
> +{
> +	/*
> +	 * There is no page cache to invalidate in the dax case, however
> +	 * we need this callback defined to prevent falling back to
> +	 * block_invalidatepage() in do_invalidatepage().
> +	 */
> +}
> +EXPORT_SYMBOL_GPL(noop_invalidatepage);
> +
>  /* Because kfree isn't assignment-compatible with void(void*) ;-/ */
>  void kfree_link(void *p)
>  {
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 0185ecdae135..ae27a7efe7ab 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -38,6 +38,7 @@ static inline void put_dax(struct dax_device *dax_dev)
>  }
>  #endif
>  
> +struct writeback_control;
>  int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
>  #if IS_ENABLED(CONFIG_FS_DAX)
>  int __bdev_dax_supported(struct super_block *sb, int blocksize);
> @@ -57,6 +58,8 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
>  }
>  
>  struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
> +int dax_writeback_mapping_range(struct address_space *mapping,
> +		struct block_device *bdev, struct writeback_control *wbc);
>  #else
>  static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
>  {
> @@ -76,6 +79,12 @@ static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>  {
>  	return NULL;
>  }
> +
> +static inline int dax_writeback_mapping_range(struct address_space *mapping,
> +		struct block_device *bdev, struct writeback_control *wbc)
> +{
> +	return -EOPNOTSUPP;
> +}
>  #endif
>  
>  int dax_read_lock(void);
> @@ -121,7 +130,4 @@ static inline bool dax_mapping(struct address_space *mapping)
>  	return mapping->host && IS_DAX(mapping->host);
>  }
>  
> -struct writeback_control;
> -int dax_writeback_mapping_range(struct address_space *mapping,
> -		struct block_device *bdev, struct writeback_control *wbc);
>  #endif
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 79c413985305..b57db31d294d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3129,6 +3129,9 @@ extern int simple_rmdir(struct inode *, struct dentry *);
>  extern int simple_rename(struct inode *, struct dentry *,
>  			 struct inode *, struct dentry *, unsigned int);
>  extern int noop_fsync(struct file *, loff_t, loff_t, int);
> +extern int noop_set_page_dirty(struct page *page);
> +extern void noop_invalidatepage(struct page *page, unsigned int offset,
> +		unsigned int length);
>  extern int simple_empty(struct dentry *);
>  extern int simple_readpage(struct file *file, struct page *page);
>  extern int simple_write_begin(struct file *file, struct address_space *mapping,
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
