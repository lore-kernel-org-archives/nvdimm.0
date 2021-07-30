Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED5F70
	for <nvdimm@lists.linux.dev>; Fri, 30 Jul 2021 09:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627636549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2G6YqzVccvwwc7B9va0puf2bDyrJ3NwGJeOcoTuePQc=;
	b=O29Xnh27ZKSOzUOeyOHRWY1n5pjA13gJIP5nbz2L101OODECrluU7xOxoim6DmWkz8kjbX
	h/9oht7TP/uJpML8mpzdyR4ra2FRskptiJWoTMXMhQ+gnAd4jrnY22tmoKX+rlbyxDMvEg
	KzQTpHFS9PHtN5U/dD9e0T0IZfFLK6k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-n6I_yTNoMDO9ZFFWZHeLHQ-1; Fri, 30 Jul 2021 05:15:48 -0400
X-MC-Unique: n6I_yTNoMDO9ZFFWZHeLHQ-1
Received: by mail-wm1-f71.google.com with SMTP id d72-20020a1c1d4b0000b029025164ff3ebfso3012907wmd.7
        for <nvdimm@lists.linux.dev>; Fri, 30 Jul 2021 02:15:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2G6YqzVccvwwc7B9va0puf2bDyrJ3NwGJeOcoTuePQc=;
        b=T/o/G72tVyQ9NTt9klfRagthZC0CfY/YS53rRVMBND4fX5TSQhZhHLH9UgWf1fQFk1
         fQ06kZIRcRgeDZhyddHDmBPY+WlAehewkj38fhFFaUPaIkqeQe/d7KoFl5kZKR0ZJr80
         rp+8GE0uK3M1qTbj9k5eaorkbIEbOPBVcmBkDkwcZ1HhSEmsE2ay78U4vSZTMqZK0e8B
         Et+LphIoxNy29igW9gWYwgdxGCUDW+f3azZn0OEK07BRAYUHHGd/kX2EE4lf5KPIcXGG
         Af0ezJ6hsazug68FAgRzk6Oj0rtONJEbHSTwIXQ7M3FQqaP89MHU+TezCqSlCDrnb63K
         oSBg==
X-Gm-Message-State: AOAM531lonNTA158glRvPi/IXaQiXHZDrgqMfnNkFaaVRs75MpdBGc/r
	jvY7EPUoabsYOF/vSebMg/ZZrSxOXTUZXmK70MEUiv1bBxvMB94l+LZcl4ljtNhoTrtM6ChA0l7
	rz8Un9MbQCDSBTPOR
X-Received: by 2002:a05:600c:ac4:: with SMTP id c4mr1967693wmr.10.1627636547102;
        Fri, 30 Jul 2021 02:15:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzG+H96dDTWqQcuJ+RbEY9tKITJ8Afuww7GOPOiwc5dZwIDUsqt9sDMj8Sm9FxLdUz+h5MzYQ==
X-Received: by 2002:a05:600c:ac4:: with SMTP id c4mr1967663wmr.10.1627636546757;
        Fri, 30 Jul 2021 02:15:46 -0700 (PDT)
Received: from ?IPv6:2003:d8:2f0a:7f00:fad7:3bc9:69d:31f? (p200300d82f0a7f00fad73bc9069d031f.dip0.t-ipconnect.de. [2003:d8:2f0a:7f00:fad7:3bc9:69d:31f])
        by smtp.gmail.com with ESMTPSA id c204sm1176741wme.15.2021.07.30.02.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 02:15:46 -0700 (PDT)
Subject: Re: [PATCH v6 6/9] xfs: Implement ->corrupted_range() for XFS
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
Cc: djwong@kernel.com, dan.j.williams@intel.com, david@fromorbit.com,
 hch@lst.de, agk@redhat.com, snitzer@redhat.com
References: <20210730085245.3069812-1-ruansy.fnst@fujitsu.com>
 <20210730085245.3069812-7-ruansy.fnst@fujitsu.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <f0037d29-9402-6357-ce91-ef6e2e5b7c04@redhat.com>
Date: Fri, 30 Jul 2021 11:15:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210730085245.3069812-7-ruansy.fnst@fujitsu.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

There is no ocurrence of "corrupted_range" in this patch. Does the patch 
subject need updating?


On 30.07.21 10:52, Shiyang Ruan wrote:
> This function is used to handle errors which may cause data lost in
> filesystem.  Such as memory failure in fsdax mode.
> 
> If the rmap feature of XFS enabled, we can query it to find files and
> metadata which are associated with the corrupt data.  For now all we do
> is kill processes with that file mapped into their address spaces, but
> future patches could actually do something about corrupt metadata.
> 
> After that, the memory failure needs to notify the processes who are
> using those files.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>   drivers/dax/super.c |  12 ++++
>   fs/xfs/xfs_fsops.c  |   5 ++
>   fs/xfs/xfs_mount.h  |   1 +
>   fs/xfs/xfs_super.c  | 135 ++++++++++++++++++++++++++++++++++++++++++++
>   include/linux/dax.h |  13 +++++
>   5 files changed, 166 insertions(+)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 00c32dfa5665..63f7b63d078d 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -65,6 +65,18 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>   	return dax_get_by_host(bdev->bd_disk->disk_name);
>   }
>   EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
> +
> +void fs_dax_set_holder(struct dax_device *dax_dev, void *holder,
> +		const struct dax_holder_operations *ops)
> +{
> +	dax_set_holder(dax_dev, holder, ops);
> +}
> +EXPORT_SYMBOL_GPL(fs_dax_set_holder);
> +void *fs_dax_get_holder(struct dax_device *dax_dev)
> +{
> +	return dax_get_holder(dax_dev);
> +}
> +EXPORT_SYMBOL_GPL(fs_dax_get_holder);
>   #endif
>   
>   bool __generic_fsdax_supported(struct dax_device *dax_dev,
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 6ed29b158312..e96ddb5c28bc 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -549,6 +549,11 @@ xfs_do_force_shutdown(
>   				flags, __return_address, fname, lnnum);
>   		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
>   			xfs_stack_trace();
> +	} else if (flags & SHUTDOWN_CORRUPT_META) {
> +		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
> +"Corruption of on-disk metadata detected.  Shutting down filesystem");
> +		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
> +			xfs_stack_trace();
>   	} else if (logerror) {
>   		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
>   "Log I/O error (0x%x) detected at %pS (%s:%d). Shutting down filesystem",
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index c78b63fe779a..203eb62d16d0 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -277,6 +277,7 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
>   #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
>   #define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
>   #define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structures */
> +#define SHUTDOWN_CORRUPT_META	0x0010  /* corrupt metadata on device */
>   
>   /*
>    * Flags for xfs_mountfs
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 2c9e26a44546..4a362e14318d 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -37,11 +37,19 @@
>   #include "xfs_reflink.h"
>   #include "xfs_pwork.h"
>   #include "xfs_ag.h"
> +#include "xfs_alloc.h"
> +#include "xfs_rmap.h"
> +#include "xfs_rmap_btree.h"
> +#include "xfs_rtalloc.h"
> +#include "xfs_bit.h"
>   
>   #include <linux/magic.h>
>   #include <linux/fs_context.h>
>   #include <linux/fs_parser.h>
> +#include <linux/mm.h>
> +#include <linux/dax.h>
>   
> +static const struct dax_holder_operations xfs_dax_holder_operations;
>   static const struct super_operations xfs_super_operations;
>   
>   static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
> @@ -352,6 +360,7 @@ xfs_close_devices(
>   
>   		xfs_free_buftarg(mp->m_logdev_targp);
>   		xfs_blkdev_put(logdev);
> +		fs_dax_set_holder(dax_logdev, NULL, NULL);
>   		fs_put_dax(dax_logdev);
>   	}
>   	if (mp->m_rtdev_targp) {
> @@ -360,9 +369,11 @@ xfs_close_devices(
>   
>   		xfs_free_buftarg(mp->m_rtdev_targp);
>   		xfs_blkdev_put(rtdev);
> +		fs_dax_set_holder(dax_rtdev, NULL, NULL);
>   		fs_put_dax(dax_rtdev);
>   	}
>   	xfs_free_buftarg(mp->m_ddev_targp);
> +	fs_dax_set_holder(dax_ddev, NULL, NULL);
>   	fs_put_dax(dax_ddev);
>   }
>   
> @@ -386,6 +397,7 @@ xfs_open_devices(
>   	struct block_device	*logdev = NULL, *rtdev = NULL;
>   	int			error;
>   
> +	fs_dax_set_holder(dax_ddev, mp, &xfs_dax_holder_operations);
>   	/*
>   	 * Open real time and log devices - order is important.
>   	 */
> @@ -394,6 +406,9 @@ xfs_open_devices(
>   		if (error)
>   			goto out;
>   		dax_logdev = fs_dax_get_by_bdev(logdev);
> +		if (dax_logdev != dax_ddev)
> +			fs_dax_set_holder(dax_logdev, mp,
> +				       &xfs_dax_holder_operations);
>   	}
>   
>   	if (mp->m_rtname) {
> @@ -408,6 +423,7 @@ xfs_open_devices(
>   			goto out_close_rtdev;
>   		}
>   		dax_rtdev = fs_dax_get_by_bdev(rtdev);
> +		fs_dax_set_holder(dax_rtdev, mp, &xfs_dax_holder_operations);
>   	}
>   
>   	/*
> @@ -1070,6 +1086,125 @@ xfs_fs_free_cached_objects(
>   	return xfs_reclaim_inodes_nr(XFS_M(sb), sc->nr_to_scan);
>   }
>   
> +static int
> +xfs_corrupt_helper(
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_rmap_irec		*rec,
> +	void				*data)
> +{
> +	struct xfs_inode		*ip;
> +	struct address_space		*mapping;
> +	int				error = 0, *flags = data, i;
> +
> +	if (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) ||
> +	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))) {
> +		// TODO check and try to fix metadata
> +		xfs_force_shutdown(cur->bc_mp, SHUTDOWN_CORRUPT_META);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	/* Get files that incore, filter out others that are not in use. */
> +	error = xfs_iget(cur->bc_mp, cur->bc_tp, rec->rm_owner, XFS_IGET_INCORE,
> +			 0, &ip);
> +	if (error)
> +		return error;
> +
> +	mapping = VFS_I(ip)->i_mapping;
> +	if (IS_ENABLED(CONFIG_MEMORY_FAILURE)) {
> +		for (i = 0; i < rec->rm_blockcount; i++) {
> +			error = mf_dax_kill_procs(mapping, rec->rm_offset + i,
> +						  *flags);
> +			if (error)
> +				break;
> +		}
> +	}
> +	// TODO try to fix data
> +	xfs_irele(ip);
> +
> +	return error;
> +}
> +
> +static loff_t
> +xfs_dax_bdev_offset(
> +	struct xfs_mount *mp,
> +	struct dax_device *dax_dev,
> +	loff_t disk_offset)
> +{
> +	struct block_device *bdev;
> +
> +	if (mp->m_ddev_targp->bt_daxdev == dax_dev)
> +		bdev = mp->m_ddev_targp->bt_bdev;
> +	else if (mp->m_logdev_targp->bt_daxdev == dax_dev)
> +		bdev = mp->m_logdev_targp->bt_bdev;
> +	else
> +		bdev = mp->m_rtdev_targp->bt_bdev;
> +
> +	return disk_offset - (get_start_sect(bdev) << SECTOR_SHIFT);
> +}
> +
> +static int
> +xfs_dax_notify_failure(
> +	struct dax_device	*dax_dev,
> +	loff_t			offset,
> +	size_t			len,
> +	void			*data)
> +{
> +	struct xfs_mount	*mp = fs_dax_get_holder(dax_dev);
> +	struct xfs_trans	*tp = NULL;
> +	struct xfs_btree_cur	*cur = NULL;
> +	struct xfs_buf		*agf_bp = NULL;
> +	struct xfs_rmap_irec	rmap_low, rmap_high;
> +	loff_t 			bdev_offset = xfs_dax_bdev_offset(mp, dax_dev,
> +								  offset);
> +	xfs_fsblock_t		fsbno = XFS_B_TO_FSB(mp, bdev_offset);
> +	xfs_filblks_t		bcnt = XFS_B_TO_FSB(mp, len);
> +	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, fsbno);
> +	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
> +	int			error = 0;
> +
> +	if (mp->m_logdev_targp && mp->m_logdev_targp->bt_daxdev == dax_dev &&
> +	    mp->m_logdev_targp != mp->m_ddev_targp) {
> +		xfs_err(mp, "ondisk log corrupt, shutting down fs!");
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_META);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> +		xfs_warn(mp, "notify_failure() needs rmapbt enabled!");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	error = xfs_trans_alloc_empty(mp, &tp);
> +	if (error)
> +		return error;
> +
> +	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agf_bp);
> +	if (error)
> +		goto out_cancel_tp;
> +
> +	cur = xfs_rmapbt_init_cursor(mp, tp, agf_bp, agf_bp->b_pag);
> +
> +	/* Construct a range for rmap query */
> +	memset(&rmap_low, 0, sizeof(rmap_low));
> +	memset(&rmap_high, 0xFF, sizeof(rmap_high));
> +	rmap_low.rm_startblock = rmap_high.rm_startblock = agbno;
> +	rmap_low.rm_blockcount = rmap_high.rm_blockcount = bcnt;
> +
> +	error = xfs_rmap_query_range(cur, &rmap_low, &rmap_high,
> +				     xfs_corrupt_helper, data);
> +
> +	xfs_btree_del_cursor(cur, error);
> +	xfs_trans_brelse(tp, agf_bp);
> +
> +out_cancel_tp:
> +	xfs_trans_cancel(tp);
> +	return error;
> +}
> +
> +static const struct dax_holder_operations xfs_dax_holder_operations = {
> +	.notify_failure = xfs_dax_notify_failure,
> +};
> +
>   static const struct super_operations xfs_super_operations = {
>   	.alloc_inode		= xfs_fs_alloc_inode,
>   	.destroy_inode		= xfs_fs_destroy_inode,
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 359e809516b8..c8a188b76031 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -160,6 +160,9 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
>   }
>   
>   struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
> +void fs_dax_set_holder(struct dax_device *dax_dev, void *holder,
> +		const struct dax_holder_operations *ops);
> +void *fs_dax_get_holder(struct dax_device *dax_dev);
>   int dax_writeback_mapping_range(struct address_space *mapping,
>   		struct dax_device *dax_dev, struct writeback_control *wbc);
>   
> @@ -191,6 +194,16 @@ static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>   	return NULL;
>   }
>   
> +static inline void fs_dax_set_holder(struct dax_device *dax_dev, void *holder,
> +		const struct dax_holder_operations *ops)
> +{
> +}
> +
> +static inline void *fs_dax_get_holder(struct dax_device *dax_dev)
> +{
> +	return NULL;
> +}
> +
>   static inline struct page *dax_layout_busy_page(struct address_space *mapping)
>   {
>   	return NULL;
> 


-- 
Thanks,

David / dhildenb

