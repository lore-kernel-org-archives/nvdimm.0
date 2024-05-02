Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD6A46521
	for <nvdimm@lists.linux.dev>; Thu,  2 May 2024 15:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714665106; cv=none; b=Vb7MbLoLdM1lWYBwwXCKJxM2GTuqdoWKotAqIfjUBHQLTTqMS5Pp+qObOsxpGma9pt0+g5nCsYrpsXbN3gSTq+72aUKYSUkl6b/qkWKJ4kjopZoMDuiT2mJ2KFzvgTrd8hVQxgS5c+1WbJ0hxHxXG66NFY6azH3dgbmu47f4j0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714665106; c=relaxed/simple;
	bh=madXtRtye2NdTAMFoTu9MhdM+cjDEtSL9BOuWZzVI94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oWLqIDDe60ATXgmhlKHksq6EYgAR/lFGfQAF+KRTF8BK/pf8EN65JllwisxBcifUQadDgxKUhgKTF4IAJ23kfazCX4hQ2HOFhPUrUH9Ci4h7FFS0Ni30Gzi6g4Fb+gYK6Lfn52qV5Q5lKkUOgIVdT4j73VVzU0TPZV0T4HgmKJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J4HgZdvP; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J4HgZdvP"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6ef98eee195so634891a34.1
        for <nvdimm@lists.linux.dev>; Thu, 02 May 2024 08:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714665103; x=1715269903; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tSw5CDNnmNfjcv9csnsLo9GWGGKwZzHe3Z8GskOuqRU=;
        b=J4HgZdvP4fYliiUG4uYm1md9vaH2SvtGbWHNChjR+8cjOtDJf/gWeMzRcH6kvvNwK4
         FciQBnqxeIxa6Lejqw9vhKVcDFHNQSD0HHB6Z7Ba0RfXj8W8myfDn9STu0VmW/IwsHi0
         ddsjUEqJ552aho/KalXI4xd3Hc71aFQv9yErTyvMIMeG5SLRip+T26CXvw1+L153HAvf
         jpUZkqh2yKEhfrh6hfJWeVi8lTTb1Oy0dC5LIGvDhVpB71+FaDsb9y6QFU26T7XTdb+Z
         fDUpYjVvwPST6miCMZYGnoT1cPDqxdPRprAHJO5HmcjCt8ES5T6E+FLNst0Syhr03i70
         qHKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714665103; x=1715269903;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tSw5CDNnmNfjcv9csnsLo9GWGGKwZzHe3Z8GskOuqRU=;
        b=jeiNEVGdwYq3uKeyM0ms3gxykNGEKxcwDz/pwZcUZTdeGJO++rv+g09pT12krZ35py
         DDxJXhuYjaPr1ERXawwhc9JO21EHcB2LBGx6BQ1f+9Sfh4wHyTSL2GYE0+cbIJP6qOT5
         wzv4sgabKIovajjqP9YEhYfaNpTdfG7rT6sfIRJLefWUzK6PRFGohIid2KNf8HGkoW/l
         I1odhtYWCBb4JTV/W01vOBGoJCOVUaW6nPHuzOrCwpQnXYkBHpa8qZG7n79LQ74pGCGK
         1uf5S8Os35lLInKu8RHDuZmkbSX9ui0+irJcEBLCIPJYRpfMI8hfq7t8pKdInWaww8h3
         kPdQ==
X-Forwarded-Encrypted: i=1; AJvYcCV82/saf5rDMtJqtYRP55ojmEmpwBuS1pB50PbNScT1c34ugeB2Kh8FmCCKMCrEiZnDohcTR9veVQcIzaHXNaktSV8eZxaf
X-Gm-Message-State: AOJu0Ywk3i5gX/sKP4hxnYMjf5CxBsaL/PGrN1BU+pHu222oX8r5c1OM
	nlTT2wfrdvETJavrHmJkocmj4IMJAX4JFAmDGxaQ7vC8F/hf5tPT
X-Google-Smtp-Source: AGHT+IE6ElHBfSwWcZ1io4BsdOj3NVDPEhkrPjboLrwtaQcD7SqjMQ8+2u2iaflIjiXGp8WWORSnaw==
X-Received: by 2002:a05:6830:158:b0:6ee:3370:142e with SMTP id j24-20020a056830015800b006ee3370142emr270743otp.24.1714665103103;
        Thu, 02 May 2024 08:51:43 -0700 (PDT)
Received: from Borg-10.local (syn-070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id cl8-20020a05683064c800b006ef0f290550sm234485otb.31.2024.05.02.08.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 08:51:42 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 2 May 2024 10:51:39 -0500
From: John Groves <John@groves.net>
To: Christian Brauner <brauner@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	John Groves <jgroves@micron.com>, john@jagalactic.com, Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com, gregory.price@memverge.com, 
	Randy Dunlap <rdunlap@infradead.org>, Jerome Glisse <jglisse@google.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	Eishan Mirakhur <emirakhur@micron.com>, Ravi Shankar <venkataravis@micron.com>, 
	Srinivasulu Thanneeru <sthanneeru@micron.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Chandan Babu R <chandanbabu@kernel.org>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Steve French <stfrench@microsoft.com>, 
	Nathan Lynch <nathanl@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Julien Panis <jpanis@baylibre.com>, 
	Stanislav Fomichev <sdf@google.com>, Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: Re: [RFC PATCH v2 08/12] famfs: module operations & fs_context
Message-ID: <hrboank5xdhpr6jj4x5pd4trmsnehbo2yrvi57aed736pakz2w@eldaewzyg2jv>
References: <cover.1714409084.git.john@groves.net>
 <86694a1a663ab0b6e8e35c7b187f5ad179103482.1714409084.git.john@groves.net>
 <20240430-badeverbot-paletten-05442cfbbdf0@brauner>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430-badeverbot-paletten-05442cfbbdf0@brauner>

On 24/04/30 01:01PM, Christian Brauner wrote:
> On Mon, Apr 29, 2024 at 12:04:24PM -0500, John Groves wrote:
> > Start building up from the famfs module operations. This commit
> > includes the following:
> > 
> > * Register as a file system
> > * Parse mount parameters
> > * Allocate or find (and initialize) a superblock via famfs_get_tree()
> > * Lookup the host dax device, and bail if it's in use (or not dax)
> > * Register as the holder of the dax device if it's available
> > * Add Kconfig and Makefile misc to build famfs
> > * Add FAMFS_SUPER_MAGIC to include/uapi/linux/magic.h
> > * Add export of fs/namei.c:may_open_dev(), which famfs needs to call
> > * Update MAINTAINERS file for the fs/famfs/ path
> > 
> > The following exports had to happen to enable famfs:
> > 
> > * This uses the new fs/super.c:kill_char_super() - the other kill*super
> >   helpers were not quite right.
> > * This uses the dev_dax_iomap export of dax_dev_get()
> > 
> > This commit builds but is otherwise too incomplete to run
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  MAINTAINERS                |   1 +
> >  fs/Kconfig                 |   2 +
> >  fs/Makefile                |   1 +
> >  fs/famfs/Kconfig           |  10 ++
> >  fs/famfs/Makefile          |   5 +
> >  fs/famfs/famfs_inode.c     | 345 +++++++++++++++++++++++++++++++++++++
> >  fs/famfs/famfs_internal.h  |  36 ++++
> >  fs/namei.c                 |   1 +
> >  include/uapi/linux/magic.h |   1 +
> >  9 files changed, 402 insertions(+)
> >  create mode 100644 fs/famfs/Kconfig
> >  create mode 100644 fs/famfs/Makefile
> >  create mode 100644 fs/famfs/famfs_inode.c
> >  create mode 100644 fs/famfs/famfs_internal.h
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 3f2d847dcf01..365d678e2f40 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -8188,6 +8188,7 @@ L:	linux-cxl@vger.kernel.org
> >  L:	linux-fsdevel@vger.kernel.org
> >  S:	Supported
> >  F:	Documentation/filesystems/famfs.rst
> > +F:	fs/famfs
> >  
> >  FANOTIFY
> >  M:	Jan Kara <jack@suse.cz>
> > diff --git a/fs/Kconfig b/fs/Kconfig
> > index a46b0cbc4d8f..53b4629e92a0 100644
> > --- a/fs/Kconfig
> > +++ b/fs/Kconfig
> > @@ -140,6 +140,8 @@ source "fs/autofs/Kconfig"
> >  source "fs/fuse/Kconfig"
> >  source "fs/overlayfs/Kconfig"
> >  
> > +source "fs/famfs/Kconfig"
> > +
> >  menu "Caches"
> >  
> >  source "fs/netfs/Kconfig"
> > diff --git a/fs/Makefile b/fs/Makefile
> > index 6ecc9b0a53f2..3393f399a9e9 100644
> > --- a/fs/Makefile
> > +++ b/fs/Makefile
> > @@ -129,3 +129,4 @@ obj-$(CONFIG_EFIVAR_FS)		+= efivarfs/
> >  obj-$(CONFIG_EROFS_FS)		+= erofs/
> >  obj-$(CONFIG_VBOXSF_FS)		+= vboxsf/
> >  obj-$(CONFIG_ZONEFS_FS)		+= zonefs/
> > +obj-$(CONFIG_FAMFS)             += famfs/
> > diff --git a/fs/famfs/Kconfig b/fs/famfs/Kconfig
> > new file mode 100644
> > index 000000000000..edb8980820f7
> > --- /dev/null
> > +++ b/fs/famfs/Kconfig
> > @@ -0,0 +1,10 @@
> > +
> > +
> > +config FAMFS
> > +       tristate "famfs: shared memory file system"
> > +       depends on DEV_DAX && FS_DAX && DEV_DAX_IOMAP
> > +       help
> > +	  Support for the famfs file system. Famfs is a dax file system that
> > +	  can support scale-out shared access to fabric-attached memory
> > +	  (e.g. CXL shared memory). Famfs is not a general purpose file system;
> > +	  it is an enabler for data sets in shared memory.
> > diff --git a/fs/famfs/Makefile b/fs/famfs/Makefile
> > new file mode 100644
> > index 000000000000..62230bcd6793
> > --- /dev/null
> > +++ b/fs/famfs/Makefile
> > @@ -0,0 +1,5 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +
> > +obj-$(CONFIG_FAMFS) += famfs.o
> > +
> > +famfs-y := famfs_inode.o
> > diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> > new file mode 100644
> > index 000000000000..61306240fc0b
> > --- /dev/null
> > +++ b/fs/famfs/famfs_inode.c
> > @@ -0,0 +1,345 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * famfs - dax file system for shared fabric-attached memory
> > + *
> > + * Copyright 2023-2024 Micron Technology, inc
> > + *
> > + * This file system, originally based on ramfs the dax support from xfs,
> > + * is intended to allow multiple host systems to mount a common file system
> > + * view of dax files that map to shared memory.
> > + */
> > +
> > +#include <linux/fs.h>
> > +#include <linux/time.h>
> > +#include <linux/init.h>
> > +#include <linux/string.h>
> > +#include <linux/parser.h>
> > +#include <linux/magic.h>
> > +#include <linux/slab.h>
> > +#include <linux/fs_context.h>
> > +#include <linux/fs_parser.h>
> > +#include <linux/dax.h>
> > +#include <linux/hugetlb.h>
> > +#include <linux/iomap.h>
> > +#include <linux/path.h>
> > +#include <linux/namei.h>
> > +
> > +#include "famfs_internal.h"
> > +
> > +#define FAMFS_DEFAULT_MODE	0755
> > +
> > +static struct inode *famfs_get_inode(struct super_block *sb,
> > +				     const struct inode *dir,
> > +				     umode_t mode, dev_t dev)
> > +{
> > +	struct inode *inode = new_inode(sb);
> > +	struct timespec64 tv;
> > +
> > +	if (!inode)
> > +		return NULL;
> > +
> > +	inode->i_ino = get_next_ino();
> > +	inode_init_owner(&nop_mnt_idmap, inode, dir, mode);
> > +	inode->i_mapping->a_ops = &ram_aops;
> > +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> > +	mapping_set_unevictable(inode->i_mapping);
> > +	tv = inode_set_ctime_current(inode);
> > +	inode_set_mtime_to_ts(inode, tv);
> > +	inode_set_atime_to_ts(inode, tv);
> > +
> > +	switch (mode & S_IFMT) {
> > +	default:
> > +		init_special_inode(inode, mode, dev);
> > +		break;
> > +	case S_IFREG:
> > +		inode->i_op = NULL /* famfs_file_inode_operations */;
> > +		inode->i_fop = NULL /* &famfs_file_operations */;
> > +		break;
> > +	case S_IFDIR:
> > +		inode->i_op = NULL /* famfs_dir_inode_operations */;
> > +		inode->i_fop = &simple_dir_operations;
> > +
> > +		/* Directory inodes start off with i_nlink == 2 (for ".") */
> > +		inc_nlink(inode);
> > +		break;
> > +	case S_IFLNK:
> > +		inode->i_op = &page_symlink_inode_operations;
> > +		inode_nohighmem(inode);
> > +		break;
> > +	}
> > +	return inode;
> > +}
> > +
> > +/*
> > + * famfs dax_operations  (for char dax)
> > + */
> > +static int
> > +famfs_dax_notify_failure(struct dax_device *dax_dev, u64 offset,
> > +			u64 len, int mf_flags)
> > +{
> > +	struct super_block *sb = dax_holder(dax_dev);
> > +	struct famfs_fs_info *fsi = sb->s_fs_info;
> > +
> > +	pr_err("%s: rootdev=%s offset=%lld len=%llu flags=%x\n", __func__,
> > +	       fsi->rootdev, offset, len, mf_flags);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct dax_holder_operations famfs_dax_holder_ops = {
> > +	.notify_failure		= famfs_dax_notify_failure,
> > +};
> > +
> > +/*****************************************************************************
> > + * fs_context_operations
> > + */
> > +
> > +static int
> > +famfs_fill_super(struct super_block *sb, struct fs_context *fc)
> > +{
> > +	int rc = 0;
> > +
> > +	sb->s_maxbytes		= MAX_LFS_FILESIZE;
> > +	sb->s_blocksize		= PAGE_SIZE;
> > +	sb->s_blocksize_bits	= PAGE_SHIFT;
> > +	sb->s_magic		= FAMFS_SUPER_MAGIC;
> > +	sb->s_op		= NULL /* famfs_super_ops */;
> > +	sb->s_time_gran		= 1;
> > +
> > +	return rc;
> > +}
> > +
> > +static int
> > +lookup_daxdev(const char *pathname, dev_t *devno)
> > +{
> > +	struct inode *inode;
> > +	struct path path;
> > +	int err;
> > +
> > +	if (!pathname || !*pathname)
> > +		return -EINVAL;
> > +
> > +	err = kern_path(pathname, LOOKUP_FOLLOW, &path);
> > +	if (err)
> > +		return err;
> > +
> > +	inode = d_backing_inode(path.dentry);
> > +	if (!S_ISCHR(inode->i_mode)) {
> > +		err = -EINVAL;
> > +		goto out_path_put;
> > +	}
> > +
> > +	if (!may_open_dev(&path)) { /* had to export this */
> > +		err = -EACCES;
> > +		goto out_path_put;
> > +	}
> > +
> > +	 /* if it's dax, i_rdev is struct dax_device */
> > +	*devno = inode->i_rdev;
> > +
> > +out_path_put:
> > +	path_put(&path);
> > +	return err;
> > +}
> > +
> > +static int
> > +famfs_get_tree(struct fs_context *fc)
> > +{
> > +	struct famfs_fs_info *fsi = fc->s_fs_info;
> > +	struct dax_device *dax_devp;
> > +	struct super_block *sb;
> > +	struct inode *inode;
> > +	dev_t daxdevno;
> > +	int err;
> > +
> > +	/* TODO: clean up chatty messages */
> > +
> > +	err = lookup_daxdev(fc->source, &daxdevno);
> > +	if (err)
> > +		return err;
> > +
> > +	fsi->daxdevno = daxdevno;
> > +
> > +	/* This will set sb->s_dev=daxdevno */
> > +	sb = sget_dev(fc, daxdevno);
> 
> This will open the dax device as a block device. However, nothing in
> your ->kill_sb method or kill_char_super() closes it again. So you're
> leaking block device references and leaving unitialized memory around as
> you've claimed that device but never ended your claim.

My uptake is admittedly a bit slow with the superblock handling code; I'm
still working to get my head around it. Thank you for your help and
patience on this.

By "This will open the dax device as a block device", are you referring to
the call from sget_fc() to get_filesystem() - which then does a
__module_get(fs->owner)? That's the only thing I see that one might refer
to as "open" - and I do see [I think] that the famfs code is not doing a
module_put. Or maybe I'm missing something else...

Looking at xfs as an example, bdev_file_open_by_path() is called from 
xfs_fill_super(), which is called back from get_tree_bdev() after the
superblock is found or allocated.

In famfs, I'm not currently using a get_tree helper because there doesn't 
appear to be one that's quite right for a character-backed FS (?). The 
call in famfs that I think is most analogous to bdev_file_open_by_path() 
is dax_dev_get(), which is called after we've found or allocated a 
superblock via sget_dev()->sget_fc().

Using sget_dev() looked ok to me, but it does put a devdax (char device)
dev_t in superblock->s_dev - which may be a bit squirrely because it's
usually a block dev_t. But I don't see s_dev being used except in the
setup_bdev_super() path, which famfs is not using.

So if there is an open that I'm not closing, I'm not seeing it yet (other
than the apparent missing module_put()). Can you elaborate a bit?

> 
> > +	if (IS_ERR(sb)) {
> > +		pr_err("%s: sget_dev error\n", __func__);
> > +		return PTR_ERR(sb);
> > +	}
> > +
> > +	if (sb->s_root) {
> > +		pr_info("%s: found a matching suerblock for %s\n",
> > +			__func__, fc->source);
> > +
> > +		/* We don't expect to find a match by dev_t; if we do, it must
> > +		 * already be mounted, so we bail
> > +		 */
> > +		err = -EBUSY;
> > +		goto deactivate_out;
> > +	} else {
> > +		pr_info("%s: initializing new superblock for %s\n",
> > +			__func__, fc->source);
> > +		err = famfs_fill_super(sb, fc);
> > +		if (err)
> > +			goto deactivate_out;
> > +	}
> > +
> > +	/* This will fail if it's not a dax device */
> > +	dax_devp = dax_dev_get(daxdevno);
> > +	if (!dax_devp) {
> > +		pr_warn("%s: device %s not found or not dax\n",
> > +		       __func__, fc->source);
> > +		err = -ENODEV;
> > +		goto deactivate_out;
> > +	}
> > +
> > +	err = fs_dax_get(dax_devp, sb, &famfs_dax_holder_ops);
> > +	if (err) {
> > +		pr_err("%s: fs_dax_get(%lld) failed\n", __func__, (u64)daxdevno);
> > +		err = -EBUSY;
> > +		goto deactivate_out;
> > +	}
> > +	fsi->dax_devp = dax_devp;
> > +
> > +	inode = famfs_get_inode(sb, NULL, S_IFDIR | fsi->mount_opts.mode, 0);
> > +	sb->s_root = d_make_root(inode);
> > +	if (!sb->s_root) {
> > +		pr_err("%s: d_make_root() failed\n", __func__);
> > +		err = -ENOMEM;
> > +		fs_put_dax(fsi->dax_devp, sb);
> > +		goto deactivate_out;
> > +	}
> > +
> > +	sb->s_flags |= SB_ACTIVE;
> > +
> > +	WARN_ON(fc->root);
> > +	fc->root = dget(sb->s_root);
> > +	return err;
> > +
> > +deactivate_out:
> > +	pr_debug("%s: deactivating sb=%llx\n", __func__, (u64)sb);
> > +	deactivate_locked_super(sb);
> > +	return err;
> > +}
> > +
> > +/*****************************************************************************/
> > +
> > +enum famfs_param {
> > +	Opt_mode,
> > +	Opt_dax,
> > +};
> > +
> > +const struct fs_parameter_spec famfs_fs_parameters[] = {
> > +	fsparam_u32oct("mode",	  Opt_mode),
> > +	fsparam_string("dax",     Opt_dax),
> > +	{}
> > +};
> > +
> > +static int famfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
> > +{
> > +	struct famfs_fs_info *fsi = fc->s_fs_info;
> > +	struct fs_parse_result result;
> > +	int opt;
> > +
> > +	opt = fs_parse(fc, famfs_fs_parameters, param, &result);
> > +	if (opt == -ENOPARAM) {
> > +		opt = vfs_parse_fs_param_source(fc, param);
> > +		if (opt != -ENOPARAM)
> > +			return opt;
> 
> This shouldn't be needed. The VFS will handle all that for you.
> 
> > +
> > +		return 0;
> > +	}
> > +	if (opt < 0)
> > +		return opt;
> > +
> > +	switch (opt) {
> > +	case Opt_mode:
> > +		fsi->mount_opts.mode = result.uint_32 & S_IALLUGO;
> > +		break;
> > +	case Opt_dax:
> > +		if (strcmp(param->string, "always"))
> > +			pr_notice("%s: invalid dax mode %s\n",
> > +				  __func__, param->string);
> > +		break;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void famfs_free_fc(struct fs_context *fc)
> > +{
> > +	struct famfs_fs_info *fsi = fc->s_fs_info;
> > +
> > +	if (fsi && fsi->rootdev)
> > +		kfree(fsi->rootdev);
> 
> Dead code since rootdev is unused an unset?

Good catch, thank you. rootdev was used in v1 but not in v2.

> 
> > +
> > +	kfree(fsi);
> > +}
> > +
> > +static const struct fs_context_operations famfs_context_ops = {
> > +	.free		= famfs_free_fc,
> > +	.parse_param	= famfs_parse_param,
> > +	.get_tree	= famfs_get_tree,
> > +};
> > +
> > +static int famfs_init_fs_context(struct fs_context *fc)
> > +{
> > +	struct famfs_fs_info *fsi;
> > +
> > +	fsi = kzalloc(sizeof(*fsi), GFP_KERNEL);
> > +	if (!fsi)
> > +		return -ENOMEM;
> > +
> > +	fsi->mount_opts.mode = FAMFS_DEFAULT_MODE;
> > +	fc->s_fs_info        = fsi;
> > +	fc->ops              = &famfs_context_ops;
> > +	return 0;
> > +}
> > +
> > +static void famfs_kill_sb(struct super_block *sb)
> > +{
> > +	struct famfs_fs_info *fsi = sb->s_fs_info;
> > +
> > +	if (fsi->dax_devp)
> > +		fs_put_dax(fsi->dax_devp, sb);
> > +	if (fsi && fsi->rootdev)
> > +		kfree(fsi->rootdev);
> > +	kfree(fsi);
> > +	sb->s_fs_info = NULL;
> > +
> > +	kill_char_super(sb); /* new */
> > +}
> 
> Can likely just be
> 
> static void famfs_kill_sb(struct super_block *sb)
> {
> 	struct famfs_fs_info *fsi = sb->s_fs_info;
> 
> 	generic_shutdown_super(sb);
> 
>         if (sb->s_bdev_file)
> 		bdev_fput(sb->s_bdev_file);
> 
> 	if (fsi->dax_devp)
> 		fs_put_dax(fsi->dax_devp, sb);
> 
> 	kfree(fsi);
> }
> 
> and then you don't need any custom helpers at all.

Thanks; will give this a try

> 
> > +
> > +#define MODULE_NAME "famfs"
> > +static struct file_system_type famfs_fs_type = {
> > +	.name		  = MODULE_NAME,
> > +	.init_fs_context  = famfs_init_fs_context,
> > +	.parameters	  = famfs_fs_parameters,
> > +	.kill_sb	  = famfs_kill_sb,
> > +	.fs_flags	  = FS_USERNS_MOUNT,
> 
> Sorry, no. This should not be mountable by unprivileged users and
> containers if it's using a real device and especially not since it's not
> even a mature filesystem.

I'm a derp. That should be:

	.fs_flags = FS_REQUIRES_DEV;

Right?

<snip>

Thank you for your help!
John

