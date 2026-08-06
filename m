Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091416BB5B;
	Thu,  6 Aug 2026 05:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785994383; cv=none; b=mViUvKJxuEKxFyt5wS9ndZhCDF/EOCYbBClt1SYtX0q255FNts8yjySBeH9wxIQYoBkwdNnWUvL8SW0T98dXRdQBXjFj8z9LEVr7wyGcN4xp9lFBYMOdwSUZJ7g+5M34zVoE6OZt8e8chyDo7N9+iTN5QfYXfSh5ncFGZnUo1E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785994383; c=relaxed/simple;
	bh=xenIw2VnggLcXEKvYbPAjSiRhGMWranU1723zvHF5ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fq2Ee2iUC1uRxewpWVrim4TV+LeT5HWHfEHwARMCTKeV69qQWIPkfV1viAZyi7hg4EIoHav8Dfap13rEWblsVkjec4WPB61/39KU/v6AV6BHPdzW7W8gl3A2g2ppLIN1c+PUrT4NUrY70w95Ckd0FlwzqDUb/2ERHQBgriE8lPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NSBqqXAs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NSBqqXAs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5D2951F000E9;
	Thu,  6 Aug 2026 05:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785994381;
	bh=APg6zvsIeP5Q9qis3HQlEeHIKGdRHB8bY7cqy5avJsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NSBqqXAsvNEvOPKuGaTpuIUGqis8T/GTeAJEoEfUeOmvql1uGaH2TyfIHYcOwycY3
	 yt2HEXYHJUg+8Tc7OIaST83HJ4erCfTuUq4Y1WbWw81gaT7lmZM/u4QgL2mDr3txfV
	 Tsu9Vtj4HhXg0eiY81mokzeaWqSl/xbzL5w5OzyLQn5fzDdG5wHDUaLtolG9XDunWy
	 u4+QRDsgscgsNxO6NE6lGn47RYnoL6nX9gstGa0p0IC4OEog6Cnwrm1yrNtza1PuRI
	 7hE+7unysZLn4ozg+eDSR5Ockdy+NrQzx9G70/aSf4h8zrMrnEBelNqagiTj4NAjNi
	 fEguAm8mCVrQA==
Date: Wed, 5 Aug 2026 22:33:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Groves <john@jagalactic.com>
Cc: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ira Weiny <iweiny@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Haren Myneni <haren@linux.ibm.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Gabriel Whigham <gabewhigham@gmail.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH V12 11/12] famfs: Report device capacity via statfs so df
 works
Message-ID: <20260806053300.GK3560084@frogsfrogsfrogs>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803023000.75948-1-john@jagalactic.com>
 <0100019fc57500f5-06c293c8-393c-44e3-ad42-d4f4de58245d-000000@email.amazonses.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019fc57500f5-06c293c8-393c-44e3-ad42-d4f4de58245d-000000@email.amazonses.com>

On Mon, Aug 03, 2026 at 02:30:07AM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Replace simple_statfs(), which reports zero blocks (so df omits the mount),
> with famfs_statfs() reporting real capacity and usage.
> 
> Add dax_fsdev_size() in drivers/dax/fsdev.c, returning the size fsdev
> caches at probe (dev_dax->cached_size - the sum of the device's ranges,
> stable while bound), exported. It lives in fsdev.c because cached_size is
> set only by the fsdev driver, and famfs only ever holds fsdev-mode daxdevs
> (fs_dax_get() enforces DAXDRV_FSDEV_TYPE); famfs.ko therefore depends on
> fsdev_dax.ko.
> 
> famfs tracks two byte counters under a new stats_sem:
>  - total_capacity: summed in famfs_install_daxdev() from dax_fsdev_size(),
>    covering the mount primary and every DAXDEV_OPEN secondary, counted once
>    per daxdev (on the valid 0->1 transition).
>  - used_capacity: summed in famfs_file_init_dax() from the fmap's mapped
>    device bytes (superblock + log + data files).
> 
> famfs_statfs() reports total and free (total - used). Free is an
> approximation of the userspace allocator's free space (it ignores allocator
> gaps and reserved regions), which is adequate for df.
> 
> (Side note: I am the maintainer of drivers/dax/fsdev.c)
> 
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/fsdev.c       | 19 +++++++++++++++++
>  fs/famfs/famfs_file.c     |  5 +++++
>  fs/famfs/famfs_inode.c    | 43 ++++++++++++++++++++++++++++++++++++++-
>  fs/famfs/famfs_internal.h |  8 ++++++++
>  include/linux/dax.h       |  1 +
>  5 files changed, 75 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index 188b2526bee4..a5b4b2d79428 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -104,6 +104,25 @@ static size_t fsdev_dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff
>  	return _copy_from_iter_flushcache(addr, bytes, i);
>  }
>  
> +/**
> + * dax_fsdev_size() - total size in bytes of an fsdev dax device
> + * @dax_dev: the dax device (must be bound to this driver)
> + *
> + * Returns the size cached at probe time (sum of all ranges); it cannot change
> + * while the driver is bound. Only valid for fsdev dax devices - callers
> + * ensure that (e.g. fs_dax_get() enforces DAXDRV_FSDEV_TYPE). Returns 0 if the
> + * device is not alive.
> + */
> +u64 dax_fsdev_size(struct dax_device *dax_dev)
> +{
> +	struct dev_dax *dev_dax = dax_get_private(dax_dev);
> +
> +	if (!dev_dax)
> +		return 0;
> +	return dev_dax->cached_size;
> +}
> +EXPORT_SYMBOL_GPL(dax_fsdev_size);
> +
>  static const struct dax_operations dev_dax_ops = {
>  	.direct_access = fsdev_dax_direct_access,
>  	.zero_page_range = fsdev_dax_zero_page_range,
> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> index abf049b32a4b..5be39d677089 100644
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
> @@ -280,6 +280,11 @@ famfs_file_init_dax(struct file *file, void __user *arg)
>  	}
>  	inode_unlock(inode);
>  
> +	/* Account the mapped device bytes for statfs (only on success) */
> +	if (!rc) {
> +		scoped_guard(rwsem_write, &fsi->stats_sem)
> +			fsi->used_capacity += extent_total;
> +	}
>  out:
>  	kvfree(fmap_buf);
>  	if (meta)
> diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> index 6cbd7d657fd8..3c0d1094d653 100644
> --- a/fs/famfs/famfs_inode.c
> +++ b/fs/famfs/famfs_inode.c
> @@ -24,6 +24,7 @@
>  #include <linux/iomap.h>
>  #include <linux/path.h>
>  #include <linux/namei.h>
> +#include <linux/statfs.h>
>  
>  #include "famfs_internal.h"
>  
> @@ -307,8 +308,37 @@ static void famfs_evict_inode(struct inode *inode)
>  	clear_inode(inode);
>  }
>  
> +/*
> + * famfs_statfs() - report device capacity and consumption so 'df' works.
> + * @total_capacity is the sum of installed daxdev sizes; @used_capacity is the
> + * sum of device bytes mapped by fmaps (superblock + log + data files). Free is
> + * the difference - an approximation of the userspace allocator's free space
> + * (it ignores allocator gaps / reserved regions), which is fine for df.
> + */
> +static int famfs_statfs(struct dentry *dentry, struct kstatfs *buf)
> +{
> +	struct famfs_fs_info *fsi = dentry->d_sb->s_fs_info;
> +	u64 total, used, free;
> +
> +	scoped_guard(rwsem_read, &fsi->stats_sem) {
> +		total = fsi->total_capacity;
> +		used  = fsi->used_capacity;
> +	}
> +	free = total > used ? total - used : 0;
> +
> +	buf->f_type    = FAMFS_SUPER_MAGIC;
> +	buf->f_bsize   = PAGE_SIZE;
> +	buf->f_frsize  = PAGE_SIZE;
> +	buf->f_blocks  = total >> PAGE_SHIFT;
> +	buf->f_bfree   = free  >> PAGE_SHIFT;
> +	buf->f_bavail  = free  >> PAGE_SHIFT;	/* no root reservation */
> +	buf->f_namelen = NAME_MAX;
> +	buf->f_fsid    = u64_to_fsid(huge_encode_dev(dentry->d_sb->s_dev));
> +	return 0;
> +}
> +
>  static const struct super_operations famfs_super_ops = {
> -	.statfs		= simple_statfs,
> +	.statfs		= famfs_statfs,
>  	.drop_inode	= inode_just_drop,
>  	.show_options	= famfs_show_options,
>  	.evict_inode    = famfs_evict_inode,
> @@ -399,6 +429,7 @@ int famfs_install_daxdev(
>  		const char *name)
>  {
>  	struct famfs_daxdev *daxdev;
> +	struct dax_device *devp = NULL;
>  	int rc = 0;
>  
>  	if (index >= fsi->dax_devlist->nslots) {
> @@ -462,6 +493,15 @@ int famfs_install_daxdev(
>  
>  		wmb(); /* All other fields must be visible before valid */
>  		daxdev->valid = 1;
> +		devp = daxdev->devp;
> +	}
> +
> +	/* Freshly installed: add its capacity to the statfs accounting */
> +	if (devp) {
> +		u64 sz = dax_fsdev_size(devp);
> +
> +		scoped_guard(rwsem_write, &fsi->stats_sem)
> +			fsi->total_capacity += sz;

Can dax devices change size the same way block devices can?

Though for statfs that hardly matters; a bdev shrinkage rarely causes
b_avail to be updated even if the filesystem starts barfing IO errors
due to invalid LBA range.

The code in here looks good to me otherwise.

--D

>  	}
>  
>  	return 0;
> @@ -717,6 +757,7 @@ static int famfs_init_fs_context(struct fs_context *fc)
>  		return -ENOMEM;
>  
>  	init_rwsem(&fsi->devlist_sem);
> +	init_rwsem(&fsi->stats_sem);
>  	atomic64_set(&fsi->opts, FAMFS_OPT_DEFAULT);
>  	fsi->mount_opts.mode = FAMFS_DEFAULT_MODE;
>  	fc->s_fs_info        = fsi;
> diff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h
> index 26873162b4a0..0bf50774fa82 100644
> --- a/fs/famfs/famfs_internal.h
> +++ b/fs/famfs/famfs_internal.h
> @@ -123,6 +123,11 @@ struct famfs_dax_devlist {
>   *               point, or if other "shutdown" conditions exist
>   * @dax_devlist: Table of backing daxdevs (slot 0 is the mount primary)
>   * @devlist_sem: Serializes installs into, and teardown of, @dax_devlist
> + * @stats_sem:   Protects the statfs accounting counters below
> + * @total_capacity: Sum of installed daxdev sizes, in bytes (grows as daxdevs
> + *               are added)
> + * @used_capacity:  Sum of installed fmap sizes, in bytes (grows as MAP_CREATE
> + *               attaches fmaps; this is device bytes consumed, not file size)
>   */
>  struct famfs_fs_info {
>  	struct famfs_mount_opts   mount_opts;
> @@ -130,6 +135,9 @@ struct famfs_fs_info {
>  	bool                      deverror;
>  	struct famfs_dax_devlist *dax_devlist;
>  	struct rw_semaphore       devlist_sem;
> +	struct rw_semaphore       stats_sem;
> +	u64                       total_capacity;
> +	u64                       used_capacity;
>  };
>  
>  /*
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 29113eb95e72..c25ef499d04f 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -256,6 +256,7 @@ static inline void dax_break_layout_final(struct inode *inode)
>  
>  bool dax_alive(struct dax_device *dax_dev);
>  void *dax_get_private(struct dax_device *dax_dev);
> +u64 dax_fsdev_size(struct dax_device *dax_dev);
>  int dax_set_ops(struct dax_device *dax_dev, const struct dax_operations *ops);
>  long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
>  		enum dax_access_mode mode, void **kaddr, unsigned long *pfn);
> -- 
> 2.53.0
> 
> 
> 
