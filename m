Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmailnode02.adl6.internode.on.net
 (ipmailnode02.adl6.internode.on.net [150.101.137.148])
 by ml01.01.org (Postfix) with ESMTP id 8D1242205BE9B
 for <linux-nvdimm@lists.01.org>; Tue,  2 Jan 2018 13:36:36 -0800 (PST)
Date: Wed, 3 Jan 2018 08:41:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 11/18] fs, dax: introduce DEFINE_FSDAX_AOPS
Message-ID: <20180102214135.GT5858@dastard>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407701943.38751.8997225433943672290.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407701943.38751.8997225433943672290.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Dec 23, 2017 at 04:56:59PM -0800, Dan Williams wrote:
> In preparation for the dax implementation to start associating dax pages
> to inodes via page->mapping, we need to provide a 'struct
> address_space_operations' instance for dax. Otherwise, direct-I/O
> triggers incorrect page cache assumptions and warnings like the
> following:
> 
>  WARNING: CPU: 27 PID: 1783 at fs/xfs/xfs_aops.c:1468
>  xfs_vm_set_page_dirty+0xf3/0x1b0 [xfs]
>  [..]
>  CPU: 27 PID: 1783 Comm: dma-collision Tainted: G           O 4.15.0-rc2+ #984
>  [..]
>  Call Trace:
>   set_page_dirty_lock+0x40/0x60
>   bio_set_pages_dirty+0x37/0x50
>   iomap_dio_actor+0x2b7/0x3b0
>   ? iomap_dio_zero+0x110/0x110
>   iomap_apply+0xa4/0x110
>   iomap_dio_rw+0x29e/0x3b0
>   ? iomap_dio_zero+0x110/0x110
>   ? xfs_file_dio_aio_read+0x7c/0x1a0 [xfs]
>   xfs_file_dio_aio_read+0x7c/0x1a0 [xfs]
>   xfs_file_read_iter+0xa0/0xc0 [xfs]
>   __vfs_read+0xf9/0x170
>   vfs_read+0xa6/0x150
>   SyS_pread64+0x93/0xb0
>   entry_SYSCALL_64_fastpath+0x1f/0x96
> 
> ...where the default set_page_dirty() handler assumes that dirty state
> is being tracked in 'struct page' flags.
> 
> A DEFINE_FSDAX_AOPS macro helper is provided instead of a global 'struct
> address_space_operations fs_dax_aops' instance, because ->writepages
> needs to be an fs-specific implementation.
....
>  static int __init init_dax_wait_table(void)
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 1c6ed44fe9fc..3502abcbea31 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -53,6 +53,34 @@ static inline struct dax_device *fs_dax_get_by_host(const char *host)
>  
>  struct dax_device *fs_dax_claim_bdev(struct block_device *bdev, void *owner);
>  void fs_dax_release(struct dax_device *dax_dev, void *owner);
> +int dax_set_page_dirty(struct page *page);
> +ssize_t dax_direct_IO(struct kiocb *kiocb, struct iov_iter *iter);
> +int dax_writepage(struct page *page, struct writeback_control *wbc);
> +int dax_readpage(struct file *filp, struct page *page);
> +int dax_readpages(struct file *filp, struct address_space *mapping,
> +		struct list_head *pages, unsigned nr_pages);
> +int dax_write_begin(struct file *filp, struct address_space *mapping,
> +		loff_t pos, unsigned len, unsigned flags,
> +		struct page **pagep, void **fsdata);
> +int dax_write_end(struct file *filp, struct address_space *mapping,
> +		loff_t pos, unsigned len, unsigned copied,
> +		struct page *page, void *fsdata);
> +void dax_invalidatepage(struct page *page, unsigned int offset,
> +		unsigned int length);
> +
> +#define DEFINE_FSDAX_AOPS(name, writepages_fn)	\
> +const struct address_space_operations name = {	\
> +	.set_page_dirty = dax_set_page_dirty,	\
> +	.direct_IO = dax_direct_IO,	\
> +	.writepage = dax_writepage,	\
> +	.readpage = dax_readpage,	\
> +	.writepages = writepages_fn,	\
> +	.readpages = dax_readpages,	\
> +	.write_begin = dax_write_begin,	\
> +	.write_end = dax_write_end,	\
> +	.invalidatepage = dax_invalidatepage, \
> +}

Please don't hide ops structure definitions inside macrosi - it goes
completely against the convention used everywhere in filesystems.
i.e. we declare them in full for each filesystem that uses them so
that they can be modified for each individual filesystem as
necessary.

Also, ops structures aren't intended to be debugging aids. If the
filesystem doesn't implement something, the ops method should be
null and hence never called, not stubbed with a function that issues
warnings. If you really want to make sure we don't screw up, add a
debug only-check on the inode's aops vector when the DAX mmap range
is first being set up.

IOWs, this:

const struct address_space_operations xfs_dax_aops = {
	.writepages = xfs_vm_dax_writepage,
};

is all that should be defined for XFS, and similarly for other
filesystems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
