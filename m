Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 30 Jan 2017 13:32:26 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 10/17] block: introduce bdev_dax_direct_access()
Message-ID: <20170130123226.GD9043@lst.de>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com> <148559261791.11180.12085685820239925499.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148559261791.11180.12085685820239925499.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, snitzer@redhat.com, toshi.kani@hpe.com, mawilcox@microsoft.com, linux-block@vger.kernel.org, jmoyer@redhat.com, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jan 28, 2017 at 12:36:58AM -0800, Dan Williams wrote:
> Provide a replacement for bdev_direct_access() that uses
> dax_operations.direct_access() instead of
> block_device_operations.direct_access(). Once all consumers of the old
> api have been converted bdev_direct_access() will be deleted.
> 
> Given that block device partitioning decisions can cause dax page
> alignment constraints to be violated we still need to validate the
> block_device before calling the dax ->direct_access method.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  block/Kconfig          |    1 +
>  drivers/dax/super.c    |   33 +++++++++++++++++++++++++++++++++
>  fs/block_dev.c         |   28 ++++++++++++++++++++++++++++
>  include/linux/blkdev.h |    3 +++
>  include/linux/dax.h    |    2 ++
>  5 files changed, 67 insertions(+)
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index 8bf114a3858a..9be785173280 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -6,6 +6,7 @@ menuconfig BLOCK
>         default y
>         select SBITMAP
>         select SRCU
> +       select DAX
>         help
>  	 Provide block layer support for the kernel.
>  
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index eb844ffea3cf..ab5b082df5dd 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -65,6 +65,39 @@ struct dax_inode {
>  	const struct dax_operations *ops;
>  };
>  
> +long dax_direct_access(struct dax_inode *dax_inode, phys_addr_t dev_addr,
> +		void **kaddr, pfn_t *pfn, long size)
> +{
> +	long avail;
> +
> +	/*
> +	 * The device driver is allowed to sleep, in order to make the
> +	 * memory directly accessible.
> +	 */
> +	might_sleep();
> +
> +	if (!dax_inode)
> +		return -EOPNOTSUPP;
> +
> +	if (!dax_inode_alive(dax_inode))
> +		return -ENXIO;
> +
> +	if (size < 0)
> +		return size;
> +
> +	if (dev_addr % PAGE_SIZE)
> +		return -EINVAL;
> +
> +	avail = dax_inode->ops->direct_access(dax_inode, dev_addr, kaddr, pfn,
> +			size);
> +	if (!avail)
> +		return -ERANGE;
> +	if (avail > 0 && avail & ~PAGE_MASK)
> +		return -ENXIO;
> +	return min(avail, size);
> +}
> +EXPORT_SYMBOL_GPL(dax_direct_access);
> +
>  bool dax_inode_alive(struct dax_inode *dax_inode)
>  {
>  	lockdep_assert_held(&dax_srcu);
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index edb1d2b16b8f..bf4b51a3a412 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -18,6 +18,7 @@
>  #include <linux/module.h>
>  #include <linux/blkpg.h>
>  #include <linux/magic.h>
> +#include <linux/dax.h>
>  #include <linux/buffer_head.h>
>  #include <linux/swap.h>
>  #include <linux/pagevec.h>
> @@ -763,6 +764,33 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
>  EXPORT_SYMBOL_GPL(bdev_direct_access);
>  
>  /**
> + * bdev_dax_direct_access() - bdev-sector to pfn_t and kernel virtual address
> + * @bdev: host block device for @dax_inode
> + * @dax_inode: interface data and operations for a memory device
> + * @dax: control and output parameters for ->direct_access
> + *
> + * Return: negative errno if an error occurs, otherwise the number of bytes
> + * accessible at this address.
> + *
> + * Locking: must be called with dax_read_lock() held
> + */
> +long bdev_dax_direct_access(struct block_device *bdev,
> +		struct dax_inode *dax_inode, struct blk_dax_ctl *dax)
> +{
> +	sector_t sector = dax->sector;
> +
> +	if (!blk_queue_dax(bdev->bd_queue))
> +		return -EOPNOTSUPP;

I don't think this should take a bdev - the caller should know if
it has a dax_inode.  Also if you touch this anyway can we kill
the annoying struct blk_dax_ctl calling convention?  Passing the
four arguments explicitly is just a lot more readable and understandable.

> +	if ((sector + DIV_ROUND_UP(dax->size, 512))
> +			> part_nr_sects_read(bdev->bd_part))
> +		return -ERANGE;
> +	sector += get_start_sect(bdev);
> +	return dax_direct_access(dax_inode, sector * 512, &dax->addr,
> +			&dax->pfn, dax->size);

And please switch to using bytes as the granularity given that we're
deadling with byte addressable memory.
