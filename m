Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87503815FA;
	Thu,  6 Aug 2026 04:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785991035; cv=none; b=uUqb+CPNFMVZZE9SQiv+STZxx8SAiMYL4QR+hyKFlY8bcc2hseEpydVCy2CPThgd6e9bspI8Aj39gZ2YbsCvzGqJmK8TlLR51CWVNUU+HQLL0b47TnjCDUbQYqCCi4pfDNK/HvgANFTeCccajOZUbNN3Gsyq4tjNtyfSxPd2aQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785991035; c=relaxed/simple;
	bh=YyzcItmMTIjH8L5Ssz9P0gfiftjNN2SwmnFB648QvEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CPO7evRg2AEUNNuBqPOHiUHBXkB723x1bGnpXUBooMfjR4XUulTeJmoyzZbMaiaqYsJRtkzhyiG5jVLqtYZYTFlDvpNOEGneMdIdf4ctPkFbOvo3Z4Xzyq9GaY3GIxIAlZooQ9Nmo3wN8kRIS0MJBWklo2kAH3wY5rGxjJmWn4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RKYh2etz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RKYh2etz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3B1471F000E9;
	Thu,  6 Aug 2026 04:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785991033;
	bh=SkDCICo2MYIWjxIE/EbvZVNwKPX2hwndCp4pUTakAjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RKYh2etzQyvVvU0beZPQPTguWU0CC5smXIIc53Be9Bb3aLpDedHuOCOg56zyEAiiQ
	 0PcT6vckfUEvw9E1VAkloAU6ojM2M4dxpLO2BvZW3iKk5EeAMRrAdgJ8yUtOLjTGsi
	 A+uTc+loBRGDEAUiukLrgF1wO/3kmtpuZNHnZIaTVJ+zqcFSrz31HaqAoRePeBKVxT
	 sSHuDyOWZ/BWm+OQhnyvTHiZ7uMnlNLtEwYT1yxw4Mw+IqUYDemXBiA/ZhwUfJ2SoD
	 BFWkxkzzWSuim0SLRgv0t7KPRtg6jBvbsVtFr8VXgbKvHx64Saj8K5Q8mpq2W2Qpkc
	 NtzEFclM/5l0w==
Date: Wed, 5 Aug 2026 21:37:12 -0700
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
Subject: Re: [PATCH V12 02/12] famfs: Module operations, fs_context, and mount
Message-ID: <20260806043712.GB3560084@frogsfrogsfrogs>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022828.75776-1-john@jagalactic.com>
 <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>

On Mon, Aug 03, 2026 at 02:28:36AM +0000, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> Start building up from the famfs module operations. This commit
> includes the following:
> 
> * Register as a file system
> * Parse mount parameters
> * Allocate or find (and initialize) a superblock via famfs_get_tree()
> * Lookup the host dax device, and bail if it's in use (or not dax)
> * Add Kconfig and Makefile misc to build famfs
> * Add FAMFS_SUPER_MAGIC to include/uapi/linux/magic.h
> * Add export of fs/namei.c:may_open_dev(), which famfs needs to call
> * Update MAINTAINERS file for the fs/famfs/ path
> 
> The following exports had to happen to enable famfs:
> 
> * This adds the new fs/super.c:kill_char_super() - the other kill*super
>   helpers were not quite right.

Err, how were they not quite right??

> This commit builds but is otherwise too incomplete to run

Maybe you shouldn't add famfs to fs/Makefile until the very last patch,
since that would eliminate all bisection errors.

Also, are you trying to get this merged for 7.3?  Because I'm /really/
tired of watching this continue to drag on for three years now.  You
prototyped a weird left turn through fuse.  In trying to work with
Miklos and Amir on various fuse improvements, we both discovered that
Miklos says he's not a good maintainer[1].

At this point I agree with you that it makes no sense to continue with
the fuse direction even if Amir and Joanne think you're close, because
no, you're not close, you're *done*.  This is a working driver, you've
spent years QAing it, sampling it to some users (apparently) to get
feedback so you know that you've built better than a trash fire, and now
you're the co-chair of some CXL committee so you and Micron are probably
stuck with it in the long run.  You've even demonstrated that you can
follow community processes even when they're frustrating and slow.

IOWs, let's fix the remaining wobbles (if any) and just merge this
already.  No more side quests through gigantic refactorings of fusex,
that's too much to ask after you already redesigned and reimplemented
the whole thing already.

Quoting Miklos from the fuse session at LSFMM:
[1] https://lwn.net/Articles/1086336/

Proceeding on to the wobbles (if any).

> Signed-off-by: John Groves <john@groves.net>
> ---
>  MAINTAINERS                |   7 +
>  fs/Kconfig                 |   2 +
>  fs/Makefile                |   1 +
>  fs/famfs/Kconfig           |  11 ++
>  fs/famfs/Makefile          |   5 +
>  fs/famfs/famfs_inode.c     | 293 +++++++++++++++++++++++++++++++++++++
>  fs/famfs/famfs_internal.h  |  32 ++++
>  fs/namei.c                 |   1 +
>  fs/super.c                 |   7 +
>  include/linux/fs.h         |   1 +
>  include/uapi/linux/magic.h |   1 +
>  11 files changed, 361 insertions(+)
>  create mode 100644 fs/famfs/Kconfig
>  create mode 100644 fs/famfs/Makefile
>  create mode 100644 fs/famfs/famfs_inode.c
>  create mode 100644 fs/famfs/famfs_internal.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a674e36529f7..ca7b90a8f0a1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9905,6 +9905,13 @@ F:	Documentation/networking/failover.rst
>  F:	include/net/failover.h
>  F:	net/core/failover.c
>  
> +FAMFS [Fabric-Attached Memory File System]
> +M:	John Groves <John@Groves.net>
> +L:	linux-fsdevel@vger.kernel.org
> +L:	linux-cxl@vger.kernel.org
> +S:	Supported
> +F:	fs/famfs/
> +
>  FANOTIFY
>  M:	Jan Kara <jack@suse.cz>
>  R:	Amir Goldstein <amir73il@gmail.com>
> diff --git a/fs/Kconfig b/fs/Kconfig
> index cf6ae64776e6..2db647accc00 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -131,6 +131,8 @@ source "fs/autofs/Kconfig"
>  source "fs/fuse/Kconfig"
>  source "fs/overlayfs/Kconfig"
>  
> +source "fs/famfs/Kconfig"
> +
>  menu "Caches"
>  
>  source "fs/netfs/Kconfig"
> diff --git a/fs/Makefile b/fs/Makefile
> index 89a8a9d207d1..f49f9a000210 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -129,3 +129,4 @@ obj-$(CONFIG_VBOXSF_FS)		+= vboxsf/
>  obj-$(CONFIG_ZONEFS_FS)		+= zonefs/
>  obj-$(CONFIG_BPF_LSM)		+= bpf_fs_kfuncs.o
>  obj-$(CONFIG_RESCTRL_FS)	+= resctrl/
> +obj-$(CONFIG_FAMFS)		+= famfs/
> diff --git a/fs/famfs/Kconfig b/fs/famfs/Kconfig
> new file mode 100644
> index 000000000000..ed40cf8b0592
> --- /dev/null
> +++ b/fs/famfs/Kconfig
> @@ -0,0 +1,11 @@
> +
> +
> +config FAMFS
> +       tristate "famfs: shared memory file system"
> +       depends on DEV_DAX && FS_DAX && DEV_DAX_FSDEV
> +       default m if DEV_DAX && FS_DAX && DEV_DAX_FSDEV
> +       help
> +	  Support for the famfs file system. Famfs is a dax file system that
> +	  can support scale-out shared access to fabric-attached memory
> +	  (e.g. CXL shared memory). Famfs is not a general purpose file system;
> +	  it is an enabler for data sets in shared memory.
> diff --git a/fs/famfs/Makefile b/fs/famfs/Makefile
> new file mode 100644
> index 000000000000..62230bcd6793
> --- /dev/null
> +++ b/fs/famfs/Makefile
> @@ -0,0 +1,5 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +obj-$(CONFIG_FAMFS) += famfs.o
> +
> +famfs-y := famfs_inode.o
> diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> new file mode 100644
> index 000000000000..c299a90912a5
> --- /dev/null
> +++ b/fs/famfs/famfs_inode.c

You could probably call this fs/famfs/inode.c.

> @@ -0,0 +1,293 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * famfs - dax file system for shared fabric-attached memory
> + *
> + * Copyright 2023-2024 Micron Technology, inc
> + *
> + * This file system, originally based on ramfs the dax support from xfs,
> + * is intended to allow multiple host systems to mount a common file system
> + * view of dax files that map to shared memory.
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/cleanup.h>
> +#include <linux/time.h>
> +#include <linux/init.h>
> +#include <linux/string.h>
> +#include <linux/parser.h>
> +#include <linux/magic.h>
> +#include <linux/slab.h>
> +#include <linux/fs_context.h>
> +#include <linux/fs_parser.h>
> +#include <linux/dax.h>
> +#include <linux/hugetlb.h>
> +#include <linux/iomap.h>
> +#include <linux/path.h>
> +#include <linux/namei.h>
> +
> +#include "famfs_internal.h"
> +
> +#define FAMFS_DEFAULT_MODE	0755
> +
> +static struct inode *famfs_get_inode(
> +			struct super_block *sb,
> +			const struct inode *dir,
> +			umode_t mode, dev_t dev)
> +{
> +	struct inode *inode = new_inode(sb);
> +	struct timespec64 tv;
> +
> +	if (!inode)
> +		return NULL;
> +
> +	inode->i_ino = get_next_ino();
> +	inode_init_owner(&nop_mnt_idmap, inode, dir, mode);
> +	inode->i_mapping->a_ops = &ram_aops;
> +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> +	mapping_set_unevictable(inode->i_mapping);
> +	tv = inode_set_ctime_current(inode);
> +	inode_set_mtime_to_ts(inode, tv);
> +	inode_set_atime_to_ts(inode, tv);
> +
> +	switch (mode & S_IFMT) {
> +	default:
> +		init_special_inode(inode, mode, dev);
> +		break;
> +	case S_IFREG:
> +		inode->i_op = NULL /* famfs_file_inode_operations */;
> +		inode->i_fop = NULL /* &famfs_file_operations */;

(I would almost rather you declare empty ops structs instead of churning
this later, but eh.)

> +		break;
> +	case S_IFDIR:
> +		inode->i_op = NULL /* famfs_dir_inode_operations */;
> +		inode->i_fop = &simple_dir_operations;
> +
> +		/* Directory inodes start off with i_nlink == 2 (for ".") */
> +		inc_nlink(inode);
> +		break;
> +	case S_IFLNK:
> +		inode->i_op = &page_symlink_inode_operations;
> +		inode_nohighmem(inode);
> +		break;
> +	}
> +	return inode;
> +}
> +
> +/*
> + * famfs dax_operations (for famfs-mode dax)
> + */
> +/*****************************************************************************
> + * fs_context_operations
> + */
> +
> +static void
> +famfs_fill_super(struct super_block *sb, struct fs_context *fc)
> +{
> +	sb->s_maxbytes		= MAX_LFS_FILESIZE;
> +	sb->s_blocksize		= PAGE_SIZE;
> +	sb->s_blocksize_bits	= PAGE_SHIFT;
> +	sb->s_magic		= FAMFS_SUPER_MAGIC;
> +	sb->s_op		= NULL /* famfs_super_ops */;
> +	sb->s_time_gran		= 1;
> +}
> +
> +int
> +lookup_daxdev(const char *pathname, dev_t *devno)
> +{
> +	struct inode *inode;
> +	struct path path;
> +	int err;
> +
> +	if (!pathname || !*pathname)
> +		return -EINVAL;
> +
> +	err = kern_path(pathname, LOOKUP_FOLLOW, &path);
> +	if (err)
> +		return err;
> +
> +	inode = d_backing_inode(path.dentry);
> +	if (!S_ISCHR(inode->i_mode)) {
> +		err = -EINVAL;
> +		goto out_path_put;
> +	}
> +
> +	if (!may_open_dev(&path)) {
> +		err = -EACCES;
> +		goto out_path_put;
> +	}
> +
> +	/* i_rdev is the char dev_t; fs_dax_get() confirms it is dax later */
> +	*devno = inode->i_rdev;
> +
> +out_path_put:
> +	path_put(&path);
> +	return err;
> +}
> +
> +static int
> +famfs_get_tree(struct fs_context *fc)
> +{
> +	struct famfs_fs_info *fsi = fc->s_fs_info;
> +	struct super_block *sb;
> +	struct inode *inode;
> +	dev_t daxdevno;
> +	int err;
> +
> +	err = lookup_daxdev(fc->source, &daxdevno);
> +	if (err)
> +		return err;
> +
> +	/* This will set sb->s_dev=daxdevno */
> +	sb = sget_dev(fc, daxdevno);
> +	if (IS_ERR(sb)) {
> +		pr_debug("%s: sget_dev error\n", __func__);
> +		return PTR_ERR(sb);
> +	}
> +
> +	if (sb->s_root) {
> +		pr_debug("%s: found a matching superblock for %s\n",
> +			__func__, fc->source);
> +
> +		/* We don't expect to find a match by dev_t; if we do, it must
> +		 * already be mounted, so we bail
> +		 */
> +		err = -EBUSY;
> +		goto deactivate_out;
> +	} else {
> +		pr_debug("%s: initializing new superblock for %s\n",
> +			__func__, fc->source);
> +		famfs_fill_super(sb, fc);
> +	}
> +
> +	inode = famfs_get_inode(sb, NULL, S_IFDIR | fsi->mount_opts.mode, 0);

Can this fail?

The rest looks good to me, though I imagine shashiko will mumble things
off-list for you to fix. :P

--D

> +	sb->s_root = d_make_root(inode);
> +	if (!sb->s_root) {
> +		pr_debug("%s: d_make_root() failed\n", __func__);
> +		err = -ENOMEM;
> +		goto deactivate_out;
> +	}
> +
> +	sb->s_flags |= SB_ACTIVE;
> +
> +	WARN_ON(fc->root);
> +	fc->root = dget(sb->s_root);
> +	return 0;
> +
> +deactivate_out:
> +	pr_debug("%s: deactivating sb=%llx\n", __func__, (u64)sb);
> +	deactivate_locked_super(sb);
> +	return err;
> +}
> +
> +/*****************************************************************************/
> +
> +enum famfs_param {
> +	Opt_mode,
> +	Opt_dax,
> +};
> +
> +const struct fs_parameter_spec famfs_fs_parameters[] = {
> +	fsparam_u32oct("mode",	  Opt_mode),
> +	fsparam_string("dax",     Opt_dax),
> +	{}
> +};
> +
> +static int famfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
> +{
> +	struct famfs_fs_info *fsi = fc->s_fs_info;
> +	struct fs_parse_result result;
> +	int opt;
> +
> +	opt = fs_parse(fc, famfs_fs_parameters, param, &result);
> +	if (opt == -ENOPARAM) {
> +		opt = vfs_parse_fs_param_source(fc, param);
> +		if (opt != -ENOPARAM)
> +			return opt;
> +
> +		return 0;
> +	}
> +	if (opt < 0)
> +		return opt;
> +
> +	switch (opt) {
> +	case Opt_mode:
> +		fsi->mount_opts.mode = result.uint_32 & S_IALLUGO;
> +		break;
> +	case Opt_dax:
> +		if (strcmp(param->string, "always"))
> +			pr_debug("%s: invalid dax mode %s\n",
> +				  __func__, param->string);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static void famfs_free_fc(struct fs_context *fc)
> +{
> +	kfree(fc->s_fs_info);
> +}
> +
> +static const struct fs_context_operations famfs_context_ops = {
> +	.free		= famfs_free_fc,
> +	.parse_param	= famfs_parse_param,
> +	.get_tree	= famfs_get_tree,
> +};
> +
> +static int famfs_init_fs_context(struct fs_context *fc)
> +{
> +	struct famfs_fs_info *fsi;
> +
> +	fsi = kzalloc_obj(*fsi, GFP_KERNEL);
> +	if (!fsi)
> +		return -ENOMEM;
> +
> +	fsi->mount_opts.mode = FAMFS_DEFAULT_MODE;
> +	fc->s_fs_info        = fsi;
> +	fc->ops              = &famfs_context_ops;
> +	return 0;
> +}
> +
> +static void famfs_kill_sb(struct super_block *sb)
> +{
> +	struct famfs_fs_info *fsi = sb->s_fs_info;
> +
> +	kill_char_super(sb);
> +
> +	kfree(fsi);
> +	sb->s_fs_info = NULL;
> +}
> +
> +#define MODULE_NAME "famfs"
> +static struct file_system_type famfs_fs_type = {
> +	.name		  = MODULE_NAME,
> +	.init_fs_context  = famfs_init_fs_context,
> +	.parameters	  = famfs_fs_parameters,
> +	.kill_sb	  = famfs_kill_sb,
> +	.fs_flags	  = FS_REQUIRES_DEV,
> +};
> +
> +/******************************************************************************
> + * Module stuff
> + */
> +static int __init init_famfs_fs(void)
> +{
> +	int rc;
> +
> +	rc = register_filesystem(&famfs_fs_type);
> +
> +	return rc;
> +}
> +
> +static void
> +__exit famfs_exit(void)
> +{
> +	unregister_filesystem(&famfs_fs_type);
> +	pr_info("%s: unregistered\n", __func__);
> +}
> +
> +fs_initcall(init_famfs_fs);
> +module_exit(famfs_exit);
> +
> +MODULE_AUTHOR("John Groves");
> +MODULE_DESCRIPTION("Fabric-Attached Memory File System: see famfs.org");
> +MODULE_LICENSE("GPL");
> diff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h
> new file mode 100644
> index 000000000000..6f481d79ed88
> --- /dev/null
> +++ b/fs/famfs/famfs_internal.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * famfs - dax file system for shared fabric-attached memory
> + *
> + * Copyright 2023-2024 Micron Technology, Inc.
> + *
> + * This file system, originally based on ramfs the dax support from xfs,
> + * is intended to allow multiple host systems to mount a common file system
> + * view of dax files that map to shared memory.
> + */
> +#ifndef FAMFS_INTERNAL_H
> +#define FAMFS_INTERNAL_H
> +
> +struct famfs_mount_opts {
> +	umode_t mode;
> +};
> +
> +/**
> + * @famfs_fs_info
> + *
> + * @mount_opts:  The mount options
> + * @deverror:    True if the dax device has called our notify_failure entry
> + *               point, or if other "shutdown" conditions exist
> + */
> +struct famfs_fs_info {
> +	struct famfs_mount_opts   mount_opts;
> +	bool                      deverror;
> +};
> +
> +int lookup_daxdev(const char *pathname, dev_t *devno);
> +
> +#endif /* FAMFS_INTERNAL_H */
> diff --git a/fs/namei.c b/fs/namei.c
> index 19ce43c9a6e6..d67194e89963 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -4232,6 +4232,7 @@ bool may_open_dev(const struct path *path)
>  	return !(path->mnt->mnt_flags & MNT_NODEV) &&
>  		!(path->mnt->mnt_sb->s_iflags & SB_I_NODEV);
>  }
> +EXPORT_SYMBOL(may_open_dev);
>  
>  static int may_open(struct mnt_idmap *idmap, const struct path *path,
>  		    int acc_mode, int flag)
> diff --git a/fs/super.c b/fs/super.c
> index a8fd61136aaf..822ed205d07b 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1235,6 +1235,13 @@ void kill_anon_super(struct super_block *sb)
>  }
>  EXPORT_SYMBOL(kill_anon_super);
>  
> +void kill_char_super(struct super_block *sb)
> +{
> +	generic_shutdown_super(sb);
> +	kill_super_notify(sb);
> +}
> +EXPORT_SYMBOL(kill_char_super);
> +
>  int set_anon_super_fc(struct super_block *sb, struct fs_context *fc)
>  {
>  	return set_anon_super(sb, NULL);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 50ce731a2b78..a8b030d6f218 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2328,6 +2328,7 @@ void retire_super(struct super_block *sb);
>  void generic_shutdown_super(struct super_block *sb);
>  void kill_block_super(struct super_block *sb);
>  void kill_anon_super(struct super_block *sb);
> +void kill_char_super(struct super_block *sb);
>  void deactivate_super(struct super_block *sb);
>  void deactivate_locked_super(struct super_block *sb);
>  int set_anon_super(struct super_block *s, void *data);
> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> index 4f2da935a76c..e644e1fd49bd 100644
> --- a/include/uapi/linux/magic.h
> +++ b/include/uapi/linux/magic.h
> @@ -38,6 +38,7 @@
>  #define OVERLAYFS_SUPER_MAGIC	0x794c7630
>  #define FUSE_SUPER_MAGIC	0x65735546
>  #define BCACHEFS_SUPER_MAGIC	0xca451a4e
> +#define FAMFS_SUPER_MAGIC	0x87b282ff
>  
>  #define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
>  #define MINIX_SUPER_MAGIC2	0x138F		/* minix v1 fs, 30 char names */
> -- 
> 2.53.0
> 
> 
> 
