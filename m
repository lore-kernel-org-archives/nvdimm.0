Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C8D921F0DB3E
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 09:30:13 -0700 (PDT)
Date: Thu, 29 Mar 2018 18:36:51 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v7 08/14] mm, dax: enable filesystems to trigger
 dev_pagemap ->page_free callbacks
Message-ID: <20180329163651.laz5smducdjgkk2e@quack2.suse.cz>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167307372.5268.6763116136733564047.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152167307372.5268.6763116136733564047.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>, jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 21-03-18 15:57:53, Dan Williams wrote:
> In order to resolve collisions between filesystem operations and DMA to
> DAX mapped pages we need a callback when DMA completes. With a callback
> we can hold off filesystem operations while DMA is in-flight and then
> resume those operations when the last put_page() occurs on a DMA page.
> =

> Recall that the 'struct page' entries for DAX memory are created with
> devm_memremap_pages(). That routine arranges for the pages to be
> allocated, but never onlined, so a DAX page is DMA-idle when its
> reference count reaches one.
> =

> Also recall that the HMM sub-system added infrastructure to trap the
> page-idle (2-to-1 reference count) transition of the pages allocated by
> devm_memremap_pages() and trigger a callback via the 'struct
> dev_pagemap' associated with the page range. Whereas the HMM callbacks
> are going to a device driver to manage bounce pages in device-memory in
> the filesystem-dax case we will call back to filesystem specified
> callback.
> =

> Since the callback is not known at devm_memremap_pages() time we arrange
> for the filesystem to install it at mount time. No functional changes
> are expected as this only registers a nop handler for the ->page_free()
> event for device-mapped pages.
> =

> Cc: Michal Hocko <mhocko@suse.com>
> Reviewed-by: "J=E9r=F4me Glisse" <jglisse@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/dax/super.c      |   79 ++++++++++++++++++++++++++++++++++++++++=
------
>  drivers/nvdimm/pmem.c    |    3 +-
>  fs/ext2/super.c          |    6 ++-
>  fs/ext4/super.c          |    6 ++-
>  fs/xfs/xfs_super.c       |   20 ++++++------
>  include/linux/dax.h      |   17 +++++-----
>  include/linux/memremap.h |    8 +++++
>  7 files changed, 103 insertions(+), 36 deletions(-)
> =

> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 2b2332b605e4..ecefe9f7eb60 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -29,6 +29,7 @@ static struct vfsmount *dax_mnt;
>  static DEFINE_IDA(dax_minor_ida);
>  static struct kmem_cache *dax_cache __read_mostly;
>  static struct super_block *dax_superblock __read_mostly;
> +static DEFINE_MUTEX(devmap_lock);
>  =

>  #define DAX_HASH_SIZE (PAGE_SIZE / sizeof(struct hlist_head))
>  static struct hlist_head dax_host_list[DAX_HASH_SIZE];
> @@ -62,16 +63,6 @@ int bdev_dax_pgoff(struct block_device *bdev, sector_t=
 sector, size_t size,
>  }
>  EXPORT_SYMBOL(bdev_dax_pgoff);
>  =

> -#if IS_ENABLED(CONFIG_FS_DAX)
> -struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
> -{
> -	if (!blk_queue_dax(bdev->bd_queue))
> -		return NULL;
> -	return fs_dax_get_by_host(bdev->bd_disk->disk_name);
> -}
> -EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
> -#endif
> -
>  /**
>   * __bdev_dax_supported() - Check if the device supports dax for filesys=
tem
>   * @sb: The superblock of the device
> @@ -169,9 +160,66 @@ struct dax_device {
>  	const char *host;
>  	void *private;
>  	unsigned long flags;
> +	struct dev_pagemap *pgmap;
>  	const struct dax_operations *ops;
>  };
>  =

> +#if IS_ENABLED(CONFIG_FS_DAX)
> +static void generic_dax_pagefree(struct page *page, void *data)
> +{
> +	/* TODO: wakeup page-idle waiters */
> +}
> +
> +struct dax_device *fs_dax_claim_bdev(struct block_device *bdev, void *ow=
ner)
> +{
> +	struct dax_device *dax_dev;
> +	struct dev_pagemap *pgmap;
> +
> +	if (!blk_queue_dax(bdev->bd_queue))
> +		return NULL;
> +	dax_dev =3D fs_dax_get_by_host(bdev->bd_disk->disk_name);
> +	if (!dax_dev->pgmap)
> +		return dax_dev;
> +	pgmap =3D dax_dev->pgmap;
> +
> +	mutex_lock(&devmap_lock);
> +	if ((pgmap->data && pgmap->data !=3D owner) || pgmap->page_free
> +			|| pgmap->page_fault
> +			|| pgmap->type !=3D MEMORY_DEVICE_HOST) {
> +		put_dax(dax_dev);
> +		mutex_unlock(&devmap_lock);
> +		return NULL;
> +	}
> +
> +	pgmap->type =3D MEMORY_DEVICE_FS_DAX;
> +	pgmap->page_free =3D generic_dax_pagefree;
> +	pgmap->data =3D owner;
> +	mutex_unlock(&devmap_lock);
> +
> +	return dax_dev;
> +}
> +EXPORT_SYMBOL_GPL(fs_dax_claim_bdev);
> +
> +void fs_dax_release(struct dax_device *dax_dev, void *owner)
> +{
> +	struct dev_pagemap *pgmap =3D dax_dev ? dax_dev->pgmap : NULL;
> +
> +	put_dax(dax_dev);
> +	if (!pgmap)
> +		return;
> +	if (!pgmap->data)
> +		return;
> +
> +	mutex_lock(&devmap_lock);
> +	WARN_ON(pgmap->data !=3D owner);
> +	pgmap->type =3D MEMORY_DEVICE_HOST;
> +	pgmap->page_free =3D NULL;
> +	pgmap->data =3D NULL;
> +	mutex_unlock(&devmap_lock);
> +}
> +EXPORT_SYMBOL_GPL(fs_dax_release);
> +#endif
> +
>  static ssize_t write_cache_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
> @@ -499,6 +547,17 @@ struct dax_device *alloc_dax(void *private, const ch=
ar *__host,
>  }
>  EXPORT_SYMBOL_GPL(alloc_dax);
>  =

> +struct dax_device *alloc_dax_devmap(void *private, const char *host,
> +		const struct dax_operations *ops, struct dev_pagemap *pgmap)
> +{
> +	struct dax_device *dax_dev =3D alloc_dax(private, host, ops);
> +
> +	if (dax_dev)
> +		dax_dev->pgmap =3D pgmap;
> +	return dax_dev;
> +}
> +EXPORT_SYMBOL_GPL(alloc_dax_devmap);
> +
>  void put_dax(struct dax_device *dax_dev)
>  {
>  	if (!dax_dev)
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 06f8dcc52ca6..e6d7351f3379 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -408,7 +408,8 @@ static int pmem_attach_disk(struct device *dev,
>  	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_res);
>  	disk->bb =3D &pmem->bb;
>  =

> -	dax_dev =3D alloc_dax(pmem, disk->disk_name, &pmem_dax_ops);
> +	dax_dev =3D alloc_dax_devmap(pmem, disk->disk_name, &pmem_dax_ops,
> +			&pmem->pgmap);
>  	if (!dax_dev) {
>  		put_disk(disk);
>  		return -ENOMEM;
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 7666c065b96f..6ae20e319bc4 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -172,7 +172,7 @@ static void ext2_put_super (struct super_block * sb)
>  	brelse (sbi->s_sbh);
>  	sb->s_fs_info =3D NULL;
>  	kfree(sbi->s_blockgroup_lock);
> -	fs_put_dax(sbi->s_daxdev);
> +	fs_dax_release(sbi->s_daxdev, sb);
>  	kfree(sbi);
>  }
>  =

> @@ -817,7 +817,7 @@ static unsigned long descriptor_loc(struct super_bloc=
k *sb,
>  =

>  static int ext2_fill_super(struct super_block *sb, void *data, int silen=
t)
>  {
> -	struct dax_device *dax_dev =3D fs_dax_get_by_bdev(sb->s_bdev);
> +	struct dax_device *dax_dev =3D fs_dax_claim_bdev(sb->s_bdev, sb);
>  	struct buffer_head * bh;
>  	struct ext2_sb_info * sbi;
>  	struct ext2_super_block * es;
> @@ -1213,7 +1213,7 @@ static int ext2_fill_super(struct super_block *sb, =
void *data, int silent)
>  	kfree(sbi->s_blockgroup_lock);
>  	kfree(sbi);
>  failed:
> -	fs_put_dax(dax_dev);
> +	fs_dax_release(dax_dev, sb);
>  	return ret;
>  }
>  =

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 39bf464c35f1..315a323729e3 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -952,7 +952,7 @@ static void ext4_put_super(struct super_block *sb)
>  	if (sbi->s_chksum_driver)
>  		crypto_free_shash(sbi->s_chksum_driver);
>  	kfree(sbi->s_blockgroup_lock);
> -	fs_put_dax(sbi->s_daxdev);
> +	fs_dax_release(sbi->s_daxdev, sb);
>  	kfree(sbi);
>  }
>  =

> @@ -3398,7 +3398,7 @@ static void ext4_set_resv_clusters(struct super_blo=
ck *sb)
>  =

>  static int ext4_fill_super(struct super_block *sb, void *data, int silen=
t)
>  {
> -	struct dax_device *dax_dev =3D fs_dax_get_by_bdev(sb->s_bdev);
> +	struct dax_device *dax_dev =3D fs_dax_claim_bdev(sb->s_bdev, sb);
>  	char *orig_data =3D kstrdup(data, GFP_KERNEL);
>  	struct buffer_head *bh;
>  	struct ext4_super_block *es =3D NULL;
> @@ -4408,7 +4408,7 @@ static int ext4_fill_super(struct super_block *sb, =
void *data, int silent)
>  out_free_base:
>  	kfree(sbi);
>  	kfree(orig_data);
> -	fs_put_dax(dax_dev);
> +	fs_dax_release(dax_dev, sb);
>  	return err ? err : ret;
>  }
>  =

> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 93588ea3d3d2..ef7dd7148c0b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -724,7 +724,7 @@ xfs_close_devices(
>  =

>  		xfs_free_buftarg(mp, mp->m_logdev_targp);
>  		xfs_blkdev_put(logdev);
> -		fs_put_dax(dax_logdev);
> +		fs_dax_release(dax_logdev, mp);
>  	}
>  	if (mp->m_rtdev_targp) {
>  		struct block_device *rtdev =3D mp->m_rtdev_targp->bt_bdev;
> @@ -732,10 +732,10 @@ xfs_close_devices(
>  =

>  		xfs_free_buftarg(mp, mp->m_rtdev_targp);
>  		xfs_blkdev_put(rtdev);
> -		fs_put_dax(dax_rtdev);
> +		fs_dax_release(dax_rtdev, mp);
>  	}
>  	xfs_free_buftarg(mp, mp->m_ddev_targp);
> -	fs_put_dax(dax_ddev);
> +	fs_dax_release(dax_ddev, mp);
>  }
>  =

>  /*
> @@ -753,9 +753,9 @@ xfs_open_devices(
>  	struct xfs_mount	*mp)
>  {
>  	struct block_device	*ddev =3D mp->m_super->s_bdev;
> -	struct dax_device	*dax_ddev =3D fs_dax_get_by_bdev(ddev);
> -	struct dax_device	*dax_logdev =3D NULL, *dax_rtdev =3D NULL;
> +	struct dax_device	*dax_ddev =3D fs_dax_claim_bdev(ddev, mp);
>  	struct block_device	*logdev =3D NULL, *rtdev =3D NULL;
> +	struct dax_device	*dax_logdev =3D NULL, *dax_rtdev =3D NULL;
>  	int			error;
>  =

>  	/*
> @@ -765,7 +765,7 @@ xfs_open_devices(
>  		error =3D xfs_blkdev_get(mp, mp->m_logname, &logdev);
>  		if (error)
>  			goto out;
> -		dax_logdev =3D fs_dax_get_by_bdev(logdev);
> +		dax_logdev =3D fs_dax_claim_bdev(logdev, mp);
>  	}
>  =

>  	if (mp->m_rtname) {
> @@ -779,7 +779,7 @@ xfs_open_devices(
>  			error =3D -EINVAL;
>  			goto out_close_rtdev;
>  		}
> -		dax_rtdev =3D fs_dax_get_by_bdev(rtdev);
> +		dax_rtdev =3D fs_dax_claim_bdev(rtdev, mp);
>  	}
>  =

>  	/*
> @@ -813,14 +813,14 @@ xfs_open_devices(
>  	xfs_free_buftarg(mp, mp->m_ddev_targp);
>   out_close_rtdev:
>  	xfs_blkdev_put(rtdev);
> -	fs_put_dax(dax_rtdev);
> +	fs_dax_release(dax_rtdev, mp);
>   out_close_logdev:
>  	if (logdev && logdev !=3D ddev) {
>  		xfs_blkdev_put(logdev);
> -		fs_put_dax(dax_logdev);
> +		fs_dax_release(dax_logdev, mp);
>  	}
>   out:
> -	fs_put_dax(dax_ddev);
> +	fs_dax_release(dax_ddev, mp);
>  	return error;
>  }
>  =

> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index ae27a7efe7ab..92a1d3ee1615 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -52,12 +52,8 @@ static inline struct dax_device *fs_dax_get_by_host(co=
nst char *host)
>  	return dax_get_by_host(host);
>  }
>  =

> -static inline void fs_put_dax(struct dax_device *dax_dev)
> -{
> -	put_dax(dax_dev);
> -}
> -
> -struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
> +struct dax_device *fs_dax_claim_bdev(struct block_device *bdev, void *ow=
ner);
> +void fs_dax_release(struct dax_device *dax_dev, void *owner);
>  int dax_writeback_mapping_range(struct address_space *mapping,
>  		struct block_device *bdev, struct writeback_control *wbc);
>  #else
> @@ -71,13 +67,14 @@ static inline struct dax_device *fs_dax_get_by_host(c=
onst char *host)
>  	return NULL;
>  }
>  =

> -static inline void fs_put_dax(struct dax_device *dax_dev)
> +static inline struct dax_device *fs_dax_claim_bdev(struct block_device *=
bdev,
> +		void *owner)
>  {
> +	return NULL;
>  }
>  =

> -static inline struct dax_device *fs_dax_get_by_bdev(struct block_device =
*bdev)
> +static inline void fs_dax_release(struct dax_device *dax_dev, void *owne=
r)
>  {
> -	return NULL;
>  }
>  =

>  static inline int dax_writeback_mapping_range(struct address_space *mapp=
ing,
> @@ -91,6 +88,8 @@ int dax_read_lock(void);
>  void dax_read_unlock(int id);
>  struct dax_device *alloc_dax(void *private, const char *host,
>  		const struct dax_operations *ops);
> +struct dax_device *alloc_dax_devmap(void *private, const char *host,
> +		const struct dax_operations *ops, struct dev_pagemap *pgmap);
>  bool dax_alive(struct dax_device *dax_dev);
>  void kill_dax(struct dax_device *dax_dev);
>  void *dax_get_private(struct dax_device *dax_dev);
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 7b4899c06f49..02d6d042ee7f 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -53,11 +53,19 @@ struct vmem_altmap {
>   * driver can hotplug the device memory using ZONE_DEVICE and with that =
memory
>   * type. Any page of a process can be migrated to such memory. However n=
o one
>   * should be allow to pin such memory so that it can always be evicted.
> + *
> + * MEMORY_DEVICE_FS_DAX:
> + * When MEMORY_DEVICE_HOST memory is represented by a device that can
> + * host a filesystem, for example /dev/pmem0, that filesystem can
> + * register for a callback when a page is idled. For the filesystem-dax
> + * case page idle callbacks are used to coordinate DMA vs
> + * hole-punch/truncate.
>   */
>  enum memory_type {
>  	MEMORY_DEVICE_HOST =3D 0,
>  	MEMORY_DEVICE_PRIVATE,
>  	MEMORY_DEVICE_PUBLIC,
> +	MEMORY_DEVICE_FS_DAX,
>  };
>  =

>  /*
> =

-- =

Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
