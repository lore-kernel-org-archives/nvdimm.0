Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A1C385D69;
	Thu,  6 Aug 2026 05:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785992729; cv=none; b=CoYPrXCg8PSWk+Pv+4n+W4qDGg+l3XvFNFckQMFO1R+QaFRcHgJYl3VYw/02dhlhICPvk38ZkayryUeO/ICnWY/wJqHBDx5jsUy1xTkaUwtStUSBBf7++hr3tddE3HRT6VTHcBYoaew07LOWhZvp2SJjoXcJdYRWvLayciKr+u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785992729; c=relaxed/simple;
	bh=3qEuzHR3ctdxdHgc18EbaBNHWh8JhNWDVRl39Q9stnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iutZi/umIM0SEF/+dQk7MEVRL7UwnjX5B4HAXhqTy9yMG7n6yBMPMK9iyreAHF+75okh10KCiR+E1AhezouovhYXCuinrE4MkxzXKkEO4O/Sjjg7xY4TIiGww9wAW0bt+NoLLrSBlpQfCQW96LOkq1FISpdZOEVCD+RcHNlpG2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CONh2fIi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CONh2fIi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BF78E1F00A3A;
	Thu,  6 Aug 2026 05:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785992727;
	bh=OTN00HgA2QKv7cVGNj2jb+s1HsTPdAwa2wf+3nCfUMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CONh2fIi11nam3fyJkVocJhReirCnI0qMy2ImCGFA7D4Zs9FmvdddNHIhJ294FgXm
	 2rjcV3etRqbOPD7XOFUx6olDLxzVysOjzYBdqXez0m39Bamz/TZbA6y7JN165U/NHt
	 4aab7Cforx0p3Ju+2eQCNFMB8OWvSlnvPHGuqfJoH+oTqTupj2L7hxtzTkHACtTx+s
	 ZRCVBQmHbZQdaomQlA27wPWWuXd2nLyEPMotSxCgVxdquLZMpmpSjYZ3DuzR6s6xaj
	 T5TLTuD68Fk8esyRfN0MKswpiRR8aAu6YRkG6Pa76l+GHHolWBjQ6Em+xK3TlK1y50
	 9wp4M3d8nOrIw==
Date: Wed, 5 Aug 2026 22:05:27 -0700
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
Subject: Re: [PATCH V12 03/12] famfs: Add daxdev table and dax notify_failure
 support
Message-ID: <20260806050527.GC3560084@frogsfrogsfrogs>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022839.75794-1-john@jagalactic.com>
 <0100019fc573c7cd-d37cbc1c-7687-4b05-99e7-7d3624087b98-000000@email.amazonses.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019fc573c7cd-d37cbc1c-7687-4b05-99e7-7d3624087b98-000000@email.amazonses.com>

On Mon, Aug 03, 2026 at 02:28:47AM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Famfs file systems can span multiple dax devices, and daxdevs are stored
> in the daxdev_table. This adds the basic table structure, primtives and
> serialization code. Famfs file extents reference daxdevs by index, which
> is a cluster invariant maintained by user space.
> 
> We also add dax_holder_operations and a notify_failure handler, which
> is necessary to properly "open" a famfs-mode daxdev.

So you have to "mount /dev/somedaxthing0 /mnt" but you can then add more
dax devices later through some ioctl?

Can you remove daxdevs?  (I gather not...)

> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/famfs/famfs_inode.c    | 234 ++++++++++++++++++++++++++++++++++++++
>  fs/famfs/famfs_internal.h |  46 ++++++++
>  2 files changed, 280 insertions(+)
> 
> diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> index c299a90912a5..ad71e5e7a8e3 100644
> --- a/fs/famfs/famfs_inode.c
> +++ b/fs/famfs/famfs_inode.c
> @@ -75,6 +75,225 @@ static struct inode *famfs_get_inode(
>  /*
>   * famfs dax_operations (for famfs-mode dax)
>   */
> +static void famfs_set_daxdev_err(struct famfs_fs_info *fsi,
> +				 struct dax_device *dax_devp);
> +
> +static int
> +famfs_dax_notify_failure(
> +		struct dax_device *dax_dev, u64 offset,
> +		u64 len, int mf_flags)
> +{
> +	struct super_block *sb = dax_holder(dax_dev);
> +	struct famfs_fs_info *fsi = sb->s_fs_info;
> +
> +	pr_err("%s: offset=%lld len=%llu flags=%x\n", __func__,
> +	       offset, len, mf_flags);
> +
> +	/*
> +	 * Record the error on the specific daxdev and, near-term, shut the
> +	 * mount down: famfs_set_daxdev_err() also sets fsi->deverror so
> +	 * subsequent famfs operations fail. The resolver's per-daxdev
> +	 * famfs_dax_err() check remains and can make this finer later.
> +	 */
> +	famfs_set_daxdev_err(fsi, dax_dev);
> +
> +	return 0;
> +}
> +
> +static const struct dax_holder_operations famfs_dax_holder_ops = {
> +	.notify_failure		= famfs_dax_notify_failure,
> +};
> +
> +/*
> + * Allocate the daxdev table on first use (idempotent via cmpxchg).
> + */
> +int famfs_devlist_alloc(struct famfs_fs_info *fsi)
> +{
> +	struct famfs_dax_devlist *devlist;
> +
> +	if (fsi->dax_devlist)
> +		return 0;
> +
> +	devlist = kcalloc(1, sizeof(*devlist), GFP_KERNEL);
> +	if (!devlist)
> +		return -ENOMEM;
> +
> +	devlist->nslots = FAMFS_MAX_DAXDEVS;
> +	devlist->devlist = kcalloc(FAMFS_MAX_DAXDEVS, sizeof(struct famfs_daxdev),
> +				   GFP_KERNEL);
> +	if (!devlist->devlist) {
> +		kfree(devlist);
> +		return -ENOMEM;
> +	}
> +
> +	/* If another thread allocated it first, drop ours */
> +	if (cmpxchg(&fsi->dax_devlist, NULL, devlist) != NULL) {
> +		kfree(devlist->devlist);
> +		kfree(devlist);
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * famfs_install_daxdev() - exclusively acquire a resolved daxdev and publish
> + * it in the table at @index. Slot 0 is the mount primary; slots 1..n come from
> + * the daxdev-open ioctl.
> + *
> + * Serializes with concurrent installers under devlist_sem and rechecks
> + * ->valid, so re-registering an already-installed slot is idempotent. A daxdev
> + * is entered in the table only once it has been exclusively acquired via
> + * fs_dax_get() (with the super_block as the holder); on failure the
> + * dax_dev_find() reference is released and the slot is left invalid. @name may
> + * be NULL (the ioctl path passes no pathname).
> + */
> +int famfs_install_daxdev(
> +		struct famfs_fs_info *fsi,
> +		struct super_block *sb,
> +		u64 index,
> +		dev_t devno,
> +		const char *name)
> +{
> +	struct famfs_daxdev *daxdev;
> +	int rc = 0;
> +
> +	if (index >= fsi->dax_devlist->nslots) {
> +		pr_debug("%s: index(%llu) >= nslots(%d)\n",
> +		       __func__, index, fsi->dax_devlist->nslots);
> +		return -EINVAL;
> +	}
> +
> +	scoped_guard(rwsem_write, &fsi->devlist_sem) {
> +		daxdev = &fsi->dax_devlist->devlist[index];
> +
> +		/* Installed already by a concurrent (or repeated) open */
> +		if (daxdev->valid)
> +			return 0;
> +
> +		/*
> +		 * A prior attempt already determined this daxdev cannot be
> +		 * exclusively acquired (see the fs_dax_get() failure handling
> +		 * below). Don't thrash on fs_dax_get(); fail fast.
> +		 */
> +		if (daxdev->dax_err)
> +			return -EIO;
> +
> +		daxdev->devp = dax_dev_find(devno);
> +		if (!daxdev->devp) {
> +			pr_debug("%s: device %u:%u not found or not dax\n",
> +				__func__, MAJOR(devno), MINOR(devno));
> +			return -ENODEV;
> +		}
> +
> +		rc = fs_dax_get(daxdev->devp, sb, &famfs_dax_holder_ops);
> +		if (rc) {
> +			/*
> +			 * Distinguish a lost race from a real failure. -EBUSY
> +			 * with the daxdev already held by *this* super_block
> +			 * means a concurrent acquire won and will publish the
> +			 * slot valid: not an error, and must not be cached as
> +			 * dax_err. Any other failure is permanent for this
> +			 * mount, so record dax_err to stop re-acquiring it.
> +			 */
> +			if (!(rc == -EBUSY && dax_holder(daxdev->devp) == sb)) {
> +				pr_debug("%s: fs_dax_get(%u:%u) failed rc=%d\n",
> +				       __func__, MAJOR(devno), MINOR(devno), rc);
> +				daxdev->dax_err = true;
> +			}
> +			put_dax(daxdev->devp);
> +			daxdev->devp = NULL;
> +			return rc;
> +		}
> +
> +		daxdev->devno = devno;
> +		if (name) {
> +			daxdev->name = kstrdup(name, GFP_KERNEL);
> +			if (!daxdev->name) {
> +				fs_put_dax(daxdev->devp, sb);
> +				put_dax(daxdev->devp);
> +				daxdev->devp = NULL;
> +				return -ENOMEM;
> +			}
> +		}
> +
> +		wmb(); /* All other fields must be visible before valid */
> +		daxdev->valid = 1;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Release every daxdev in the table and free it. Detach the table under
> + * devlist_sem so a notify_failure racing teardown either runs first against
> + * the live table or observes dax_devlist == NULL and bails.
> + */
> +static void famfs_devlist_free(
> +			struct famfs_fs_info *fsi,
> +			struct super_block *sb)
> +{
> +	struct famfs_dax_devlist *devlist __free(kfree) = NULL;
> +	int i;
> +
> +	scoped_guard(rwsem_write, &fsi->devlist_sem) {
> +		devlist = fsi->dax_devlist;
> +		fsi->dax_devlist = NULL;
> +	}
> +
> +	if (!devlist || !devlist->devlist)
> +		return;
> +
> +	for (i = 0; i < devlist->nslots; i++) {
> +		struct famfs_daxdev *dd = &devlist->devlist[i];
> +
> +		if (!dd->valid)
> +			continue;
> +
> +		if (dd->devp) {
> +			if (!dd->dax_err)
> +				fs_put_dax(dd->devp, sb);
> +			put_dax(dd->devp);
> +		}
> +		kfree(dd->name);
> +	}
> +	kfree(devlist->devlist);
> +}
> +
> +/*
> + * Record a memory error on the daxdev matching @dax_devp. Searches the table
> + * under the write lock (which serializes against famfs_devlist_free()).
> + */
> +static void famfs_set_daxdev_err(
> +			struct famfs_fs_info *fsi,
> +			struct dax_device *dax_devp)
> +{
> +	int i;
> +
> +	scoped_guard(rwsem_write, &fsi->devlist_sem) {
> +		if (!fsi->dax_devlist)
> +			return;
> +		for (i = 0; i < fsi->dax_devlist->nslots; i++) {
> +			struct famfs_daxdev *dd = &fsi->dax_devlist->devlist[i];
> +
> +			if (!dd->valid || dd->devp != dax_devp)
> +				continue;
> +
> +			dd->error = true;
> +			/*
> +			 * Near-term policy: any daxdev memory error shuts down
> +			 * the whole mount. Finer per-daxdev handling (via
> +			 * famfs_dax_err() in the resolver) already exists and
> +			 * can supersede this later.
> +			 */
> +			fsi->deverror = true;

Hmm, I guess this is memory where really bad stuff happens ...?

I would have thought that you'd just kill the files on that device, but
you can relax this later if desirable.

> +			pr_err("%s: memory error on daxdev %s (%d)\n",
> +			       __func__, dd->name, i);
> +			return;
> +		}
> +	}
> +	pr_debug("%s: memory error on unrecognized daxdev\n", __func__);
> +}
> +
>  /*****************************************************************************
>   * fs_context_operations
>   */
> @@ -158,6 +377,18 @@ famfs_get_tree(struct fs_context *fc)
>  		famfs_fill_super(sb, fc);
>  	}
>  
> +	/* Install the primary daxdev (from the mount device) at slot 0 */
> +	err = famfs_devlist_alloc(fsi);
> +	if (err)
> +		goto deactivate_out;
> +
> +	err = famfs_install_daxdev(fsi, sb, 0, daxdevno, fc->source);
> +	if (err) {
> +		pr_err("%s: failed to install primary daxdev %s\n",
> +		       __func__, fc->source);
> +		goto deactivate_out;
> +	}
> +
>  	inode = famfs_get_inode(sb, NULL, S_IFDIR | fsi->mount_opts.mode, 0);
>  	sb->s_root = d_make_root(inode);
>  	if (!sb->s_root) {
> @@ -241,6 +472,7 @@ static int famfs_init_fs_context(struct fs_context *fc)
>  	if (!fsi)
>  		return -ENOMEM;
>  
> +	init_rwsem(&fsi->devlist_sem);
>  	fsi->mount_opts.mode = FAMFS_DEFAULT_MODE;
>  	fc->s_fs_info        = fsi;
>  	fc->ops              = &famfs_context_ops;
> @@ -251,6 +483,8 @@ static void famfs_kill_sb(struct super_block *sb)
>  {
>  	struct famfs_fs_info *fsi = sb->s_fs_info;
>  
> +	famfs_devlist_free(fsi, sb);
> +
>  	kill_char_super(sb);
>  
>  	kfree(fsi);
> diff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h
> index 6f481d79ed88..ebb9c499cf69 100644
> --- a/fs/famfs/famfs_internal.h
> +++ b/fs/famfs/famfs_internal.h
> @@ -11,22 +11,68 @@
>  #ifndef FAMFS_INTERNAL_H
>  #define FAMFS_INTERNAL_H
>  
> +#include <linux/rwsem.h>
> +#include <linux/bits.h>
> +#include <linux/build_bug.h>
> +
>  struct famfs_mount_opts {
>  	umode_t mode;
>  };
>  
> +/*
> + * famfs_daxdev - one entry in the per-superblock daxdev table
> + *
> + * @valid:   slot is populated and the daxdev has been exclusively acquired
> + * @error:   dax reported a memory error (probably poison) via notify_failure
> + * @dax_err: fs_dax_get() failed for this daxdev
> + * @devno:   dax device dev_t
> + * @devp:    the acquired dax_device
> + * @name:    dax device path (may be NULL for ioctl-registered daxdevs)
> + */
> +struct famfs_daxdev {
> +	bool valid;
> +	bool error;
> +	bool dax_err;
> +	dev_t devno;
> +	struct dax_device *devp;
> +	char *name;
> +};
> +
> +/*
> + * The daxdev index space (and thus this table) is capped at 64 so the set of
> + * daxdev indices referenced by a file's fmap fits in a u64 bitmap.
> + */
> +#define FAMFS_MAX_DAXDEVS 64
> +static_assert(BITS_PER_TYPE(u64) >= FAMFS_MAX_DAXDEVS);
> +
> +/*
> + * famfs_dax_devlist - the per-superblock table of famfs_daxdev's. Slot 0 is
> + * the primary daxdev supplied at mount; slots 1..n are registered via ioctl.
> + */
> +struct famfs_dax_devlist {
> +	int nslots;
> +	struct famfs_daxdev *devlist;
> +};
> +
>  /**
>   * @famfs_fs_info
>   *
>   * @mount_opts:  The mount options
>   * @deverror:    True if the dax device has called our notify_failure entry
>   *               point, or if other "shutdown" conditions exist
> + * @dax_devlist: Table of backing daxdevs (slot 0 is the mount primary)
> + * @devlist_sem: Serializes installs into, and teardown of, @dax_devlist
>   */
>  struct famfs_fs_info {
>  	struct famfs_mount_opts   mount_opts;
>  	bool                      deverror;
> +	struct famfs_dax_devlist *dax_devlist;
> +	struct rw_semaphore       devlist_sem;
>  };
>  
>  int lookup_daxdev(const char *pathname, dev_t *devno);
> +int famfs_devlist_alloc(struct famfs_fs_info *fsi);
> +int famfs_install_daxdev(struct famfs_fs_info *fsi, struct super_block *sb,
> +			 u64 index, dev_t devno, const char *name);
>  
>  #endif /* FAMFS_INTERNAL_H */
> -- 
> 2.53.0
> 
> 
> 
