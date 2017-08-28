Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE5A821DF8074
 for <linux-nvdimm@lists.01.org>; Mon, 28 Aug 2017 01:29:03 -0700 (PDT)
Date: Mon, 28 Aug 2017 10:31:40 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/2] fs, xfs: perform dax_device lookup at mount
Message-ID: <20170828083140.GB12609@quack2.suse.cz>
References: <150389211501.25151.6477753201827914462.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150389212075.25151.17146973298430877023.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150389212075.25151.17146973298430877023.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Sun 27-08-17 20:48:40, Dan Williams wrote:
> The ->iomap_begin() operation is a hot path, so cache the
> fs_dax_get_by_host() result at mount time to avoid the incurring the
> hash lookup overhead on a per-i/o basis.
> 
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Reported-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me. For the generic parts:

Reviewed-by: Jan Kara <jack@suse.cz>

[XFS part looks correct to me as well but I don't feel expert enough to
give any tags there].

								Honza

> ---
>  drivers/dax/super.c |   10 ++++++++++
>  fs/super.c          |   26 +++++++++++++++++++++++---
>  fs/xfs/xfs_aops.c   |   13 +++++++++++++
>  fs/xfs/xfs_aops.h   |    1 +
>  fs/xfs/xfs_buf.c    |    4 +++-
>  fs/xfs/xfs_buf.h    |    3 ++-
>  fs/xfs/xfs_iomap.c  |   10 +---------
>  fs/xfs/xfs_super.c  |   21 +++++++++++++++++----
>  include/linux/dax.h |    6 ++++++
>  include/linux/fs.h  |    1 +
>  10 files changed, 77 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 938eb4868f7f..b699aac268a6 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -46,6 +46,8 @@ void dax_read_unlock(int id)
>  EXPORT_SYMBOL_GPL(dax_read_unlock);
>  
>  #ifdef CONFIG_BLOCK
> +#include <linux/blkdev.h>
> +
>  int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
>  		pgoff_t *pgoff)
>  {
> @@ -59,6 +61,14 @@ int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
>  }
>  EXPORT_SYMBOL(bdev_dax_pgoff);
>  
> +struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
> +{
> +	if (!blk_queue_dax(bdev->bd_queue))
> +		return NULL;
> +	return fs_dax_get_by_host(bdev->bd_disk->disk_name);
> +}
> +EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
> +
>  /**
>   * __bdev_dax_supported() - Check if the device supports dax for filesystem
>   * @sb: The superblock of the device
> diff --git a/fs/super.c b/fs/super.c
> index 6bc3352adcf3..671889b02bed 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -23,6 +23,7 @@
>  #include <linux/export.h>
>  #include <linux/slab.h>
>  #include <linux/blkdev.h>
> +#include <linux/dax.h>
>  #include <linux/mount.h>
>  #include <linux/security.h>
>  #include <linux/writeback.h>		/* for the emergency remount stuff */
> @@ -1048,9 +1049,17 @@ struct dentry *mount_ns(struct file_system_type *fs_type,
>  EXPORT_SYMBOL(mount_ns);
>  
>  #ifdef CONFIG_BLOCK
> +struct sget_devs {
> +	struct block_device *bdev;
> +	struct dax_device *dax_dev;
> +};
> +
>  static int set_bdev_super(struct super_block *s, void *data)
>  {
> -	s->s_bdev = data;
> +	struct sget_devs *devs = data;
> +
> +	s->s_bdev = devs->bdev;
> +	s->s_daxdev = devs->dax_dev;
>  	s->s_dev = s->s_bdev->bd_dev;
>  	s->s_bdi = bdi_get(s->s_bdev->bd_bdi);
>  
> @@ -1059,14 +1068,18 @@ static int set_bdev_super(struct super_block *s, void *data)
>  
>  static int test_bdev_super(struct super_block *s, void *data)
>  {
> -	return (void *)s->s_bdev == data;
> +	struct sget_devs *devs = data;
> +
> +	return s->s_bdev == devs->bdev;
>  }
>  
>  struct dentry *mount_bdev(struct file_system_type *fs_type,
>  	int flags, const char *dev_name, void *data,
>  	int (*fill_super)(struct super_block *, void *, int))
>  {
> +	struct sget_devs devs;
>  	struct block_device *bdev;
> +	struct dax_device *dax_dev;
>  	struct super_block *s;
>  	fmode_t mode = FMODE_READ | FMODE_EXCL;
>  	int error = 0;
> @@ -1077,6 +1090,7 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
>  	bdev = blkdev_get_by_path(dev_name, mode, fs_type);
>  	if (IS_ERR(bdev))
>  		return ERR_CAST(bdev);
> +	dax_dev = fs_dax_get_by_bdev(bdev);
>  
>  	/*
>  	 * once the super is inserted into the list by sget, s_umount
> @@ -1089,8 +1103,10 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
>  		error = -EBUSY;
>  		goto error_bdev;
>  	}
> +	devs.bdev = bdev;
> +	devs.dax_dev = dax_dev;
>  	s = sget(fs_type, test_bdev_super, set_bdev_super, flags | MS_NOSEC,
> -		 bdev);
> +		 &devs);
>  	mutex_unlock(&bdev->bd_fsfreeze_mutex);
>  	if (IS_ERR(s))
>  		goto error_s;
> @@ -1111,6 +1127,7 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
>  		 */
>  		up_write(&s->s_umount);
>  		blkdev_put(bdev, mode);
> +		fs_put_dax(dax_dev);
>  		down_write(&s->s_umount);
>  	} else {
>  		s->s_mode = mode;
> @@ -1132,6 +1149,7 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
>  	error = PTR_ERR(s);
>  error_bdev:
>  	blkdev_put(bdev, mode);
> +	fs_put_dax(dax_dev);
>  error:
>  	return ERR_PTR(error);
>  }
> @@ -1140,6 +1158,7 @@ EXPORT_SYMBOL(mount_bdev);
>  void kill_block_super(struct super_block *sb)
>  {
>  	struct block_device *bdev = sb->s_bdev;
> +	struct dax_device *dax_dev = sb->s_daxdev;
>  	fmode_t mode = sb->s_mode;
>  
>  	bdev->bd_super = NULL;
> @@ -1147,6 +1166,7 @@ void kill_block_super(struct super_block *sb)
>  	sync_blockdev(bdev);
>  	WARN_ON_ONCE(!(mode & FMODE_EXCL));
>  	blkdev_put(bdev, mode | FMODE_EXCL);
> +	fs_put_dax(dax_dev);
>  }
>  
>  EXPORT_SYMBOL(kill_block_super);
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 6bf120bb1a17..78185f3b10b2 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -80,6 +80,19 @@ xfs_find_bdev_for_inode(
>  		return mp->m_ddev_targp->bt_bdev;
>  }
>  
> +struct dax_device *
> +xfs_find_daxdev_for_inode(
> +	struct inode		*inode)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +
> +	if (XFS_IS_REALTIME_INODE(ip))
> +		return mp->m_rtdev_targp->bt_daxdev;
> +	else
> +		return mp->m_ddev_targp->bt_daxdev;
> +}
> +
>  /*
>   * We're now finished for good with this page.  Update the page state via the
>   * associated buffer_heads, paying attention to the start and end offsets that
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index cc174ec6c2fd..88c85ea63da0 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -59,5 +59,6 @@ int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
>  
>  extern void xfs_count_page_state(struct page *, int *, int *);
>  extern struct block_device *xfs_find_bdev_for_inode(struct inode *);
> +extern struct dax_device *xfs_find_daxdev_for_inode(struct inode *);
>  
>  #endif /* __XFS_AOPS_H__ */
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 72f038492ba8..6deb86c845d1 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1802,7 +1802,8 @@ xfs_setsize_buftarg_early(
>  xfs_buftarg_t *
>  xfs_alloc_buftarg(
>  	struct xfs_mount	*mp,
> -	struct block_device	*bdev)
> +	struct block_device	*bdev,
> +	struct dax_device	*dax_dev)
>  {
>  	xfs_buftarg_t		*btp;
>  
> @@ -1811,6 +1812,7 @@ xfs_alloc_buftarg(
>  	btp->bt_mount = mp;
>  	btp->bt_dev =  bdev->bd_dev;
>  	btp->bt_bdev = bdev;
> +	btp->bt_daxdev = dax_dev;
>  
>  	if (xfs_setsize_buftarg_early(btp, bdev))
>  		goto error;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 20721261dae5..bf71507ddb16 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -108,6 +108,7 @@ typedef unsigned int xfs_buf_flags_t;
>  typedef struct xfs_buftarg {
>  	dev_t			bt_dev;
>  	struct block_device	*bt_bdev;
> +	struct dax_device	*bt_daxdev;
>  	struct xfs_mount	*bt_mount;
>  	unsigned int		bt_meta_sectorsize;
>  	size_t			bt_meta_sectormask;
> @@ -385,7 +386,7 @@ xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
>   *	Handling of buftargs.
>   */
>  extern xfs_buftarg_t *xfs_alloc_buftarg(struct xfs_mount *,
> -			struct block_device *);
> +			struct block_device *, struct dax_device *);
>  extern void xfs_free_buftarg(struct xfs_mount *, struct xfs_buftarg *);
>  extern void xfs_wait_buftarg(xfs_buftarg_t *);
>  extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 813394c62849..7c934e407332 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -69,6 +69,7 @@ xfs_bmbt_to_iomap(
>  	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
>  	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
>  	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
> +	iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));
>  }
>  
>  xfs_extlen_t
> @@ -976,7 +977,6 @@ xfs_file_iomap_begin(
>  	int			nimaps = 1, error = 0;
>  	bool			shared = false, trimmed = false;
>  	unsigned		lockmode;
> -	struct block_device	*bdev;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
> @@ -1087,13 +1087,6 @@ xfs_file_iomap_begin(
>  
>  	xfs_bmbt_to_iomap(ip, iomap, &imap);
>  
> -	/* optionally associate a dax device with the iomap bdev */
> -	bdev = iomap->bdev;
> -	if (blk_queue_dax(bdev->bd_queue))
> -		iomap->dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
> -	else
> -		iomap->dax_dev = NULL;
> -
>  	if (shared)
>  		iomap->flags |= IOMAP_F_SHARED;
>  	return 0;
> @@ -1171,7 +1164,6 @@ xfs_file_iomap_end(
>  	unsigned		flags,
>  	struct iomap		*iomap)
>  {
> -	fs_put_dax(iomap->dax_dev);
>  	if ((flags & IOMAP_WRITE) && iomap->type == IOMAP_DELALLOC)
>  		return xfs_file_iomap_end_delalloc(XFS_I(inode), offset,
>  				length, written, iomap);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 38aaacdbb8b3..d863f96b16e2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -716,13 +716,19 @@ xfs_close_devices(
>  {
>  	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
>  		struct block_device *logdev = mp->m_logdev_targp->bt_bdev;
> +		struct dax_device *dax_logdev = mp->m_logdev_targp->bt_daxdev;
> +
>  		xfs_free_buftarg(mp, mp->m_logdev_targp);
>  		xfs_blkdev_put(logdev);
> +		fs_put_dax(dax_logdev);
>  	}
>  	if (mp->m_rtdev_targp) {
>  		struct block_device *rtdev = mp->m_rtdev_targp->bt_bdev;
> +		struct dax_device *dax_rtdev = mp->m_rtdev_targp->bt_daxdev;
> +
>  		xfs_free_buftarg(mp, mp->m_rtdev_targp);
>  		xfs_blkdev_put(rtdev);
> +		fs_put_dax(dax_rtdev);
>  	}
>  	xfs_free_buftarg(mp, mp->m_ddev_targp);
>  }
> @@ -742,7 +748,9 @@ xfs_open_devices(
>  	struct xfs_mount	*mp)
>  {
>  	struct block_device	*ddev = mp->m_super->s_bdev;
> +	struct dax_device	*dax_ddev = mp->m_super->s_daxdev;
>  	struct block_device	*logdev = NULL, *rtdev = NULL;
> +	struct dax_device	*dax_logdev = NULL, *dax_rtdev = NULL;
>  	int			error;
>  
>  	/*
> @@ -752,6 +760,7 @@ xfs_open_devices(
>  		error = xfs_blkdev_get(mp, mp->m_logname, &logdev);
>  		if (error)
>  			goto out;
> +		dax_logdev = fs_dax_get_by_bdev(logdev);
>  	}
>  
>  	if (mp->m_rtname) {
> @@ -765,24 +774,25 @@ xfs_open_devices(
>  			error = -EINVAL;
>  			goto out_close_rtdev;
>  		}
> +		dax_rtdev = fs_dax_get_by_bdev(rtdev);
>  	}
>  
>  	/*
>  	 * Setup xfs_mount buffer target pointers
>  	 */
>  	error = -ENOMEM;
> -	mp->m_ddev_targp = xfs_alloc_buftarg(mp, ddev);
> +	mp->m_ddev_targp = xfs_alloc_buftarg(mp, ddev, dax_ddev);
>  	if (!mp->m_ddev_targp)
>  		goto out_close_rtdev;
>  
>  	if (rtdev) {
> -		mp->m_rtdev_targp = xfs_alloc_buftarg(mp, rtdev);
> +		mp->m_rtdev_targp = xfs_alloc_buftarg(mp, rtdev, dax_rtdev);
>  		if (!mp->m_rtdev_targp)
>  			goto out_free_ddev_targ;
>  	}
>  
>  	if (logdev && logdev != ddev) {
> -		mp->m_logdev_targp = xfs_alloc_buftarg(mp, logdev);
> +		mp->m_logdev_targp = xfs_alloc_buftarg(mp, logdev, dax_logdev);
>  		if (!mp->m_logdev_targp)
>  			goto out_free_rtdev_targ;
>  	} else {
> @@ -798,9 +808,12 @@ xfs_open_devices(
>  	xfs_free_buftarg(mp, mp->m_ddev_targp);
>   out_close_rtdev:
>  	xfs_blkdev_put(rtdev);
> +	fs_put_dax(dax_rtdev);
>   out_close_logdev:
> -	if (logdev && logdev != ddev)
> +	if (logdev && logdev != ddev) {
>  		xfs_blkdev_put(logdev);
> +		fs_put_dax(dax_logdev);
> +	}
>   out:
>  	return error;
>  }
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index df97b7af7e2c..6e32be3badec 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -57,6 +57,7 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
>  	put_dax(dax_dev);
>  }
>  
> +struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
>  #else
>  static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
>  {
> @@ -71,6 +72,11 @@ static inline struct dax_device *fs_dax_get_by_host(const char *host)
>  static inline void fs_put_dax(struct dax_device *dax_dev)
>  {
>  }
> +
> +struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
> +{
> +	return NULL;
> +}
>  #endif
>  
>  int dax_read_lock(void);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 6e1fd5d21248..d0e3234a1fae 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1334,6 +1334,7 @@ struct super_block {
>  	struct hlist_bl_head	s_anon;		/* anonymous dentries for (nfs) exporting */
>  	struct list_head	s_mounts;	/* list of mounts; _not_ for fs use */
>  	struct block_device	*s_bdev;
> +	struct dax_device	*s_daxdev;
>  	struct backing_dev_info *s_bdi;
>  	struct mtd_info		*s_mtd;
>  	struct hlist_node	s_instances;
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
