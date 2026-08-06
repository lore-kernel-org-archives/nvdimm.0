Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BF63845B0;
	Thu,  6 Aug 2026 13:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786022598; cv=none; b=eh8YkuGS1EGvphvM6+gQQ92Y/la1zEYypYfYDleiW//SHQ0Lc16097x6I5gC0kkCLtTfPVD92LD3W6ZaQLDYxQtNKDDPlHSLRqpOzxKKsO1uSOrgvri3N+CAU/aW+TK0ZgWmBi04K5P689AwUxf8NS1bnSFVRJJMwhjuLbmPQmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786022598; c=relaxed/simple;
	bh=5InyUl5W0jLvoAx9w8BZWnekydhALDFIUIOZUziCFU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tnNnQ6E+eFonEAYldXi5pUWDRZ9e1U5N2nyz3QlqUkGdQoTNcjVr+0Y0EzJi7JdYcj+4Q2b6PFRl2yG0WvcYvP1Vy/WbVMMJe2P6MYiKnfhTiTx8eVdRRdwcoBNFicy5D2/m+8if9qJ1JDMHgheUKj+Tj6L1TWWqxEl4tuUgEKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 457861C1436;
	Thu,  6 Aug 2026 13:23:07 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf01.hostedemail.com (Postfix) with ESMTPA id 36E5360010;
	Thu,  6 Aug 2026 13:22:50 +0000 (UTC)
Date: Thu, 6 Aug 2026 08:22:48 -0500
From: John Groves <John@groves.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <jic23@kernel.org>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ira Weiny <iweiny@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Haren Myneni <haren@linux.ibm.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Ethan Nelson-Moore <enelsonmoore@gmail.com>, Gabriel Whigham <gabewhigham@gmail.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH V12 02/12] famfs: Module operations, fs_context, and mount
Message-ID: <anSJef-23hvo3okz@groves.net>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022828.75776-1-john@jagalactic.com>
 <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
 <20260806043712.GB3560084@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806043712.GB3560084@frogsfrogsfrogs>
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 36E5360010
X-Stat-Signature: shjbta4o48sxj74rzcf84bmuf9m9kkhm
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18CNzZzCcvFvDKrpIBpdeDzhRyo6ppcLJ8=
X-HE-Tag: 1786022570-514801
X-HE-Meta: U2FsdGVkX1//78HpFSnURyveHl0WDWBrl5XmaV5ySoWTonC8Cd/MPvj1KnaCN5R6Mf1Ldc1ejYuMv2EX0TqJl96ntffOg/JEGWJlJPO208TIntX8pJVRnTBURMpby7cVQBmq1KBEmoj6W4bot816mU2TDDU60w6lWL0xT+vwPMA4w5iGteTaplpQNjlBeT3rozb/ebDOteQ0n01itanLO0xMBVsj8EjQeOHrgv7qfTIivI2EoJO5YjtR8yIu6D186+D7NFbM9b38MJ8seJkcgqYGI1lY2c0rKwqf8cqViTG+VU/ACfNiSzmW+uK88sID6x2dDzIufR7MOEOt94I5Qppo+CdKmuZXdzARCaXPHW8wXPUlQ9zSpLHRvy8fkQaHLe5OYi8BuUh3BrpFU8CEqMC13K75ftUVL6ONo9QQbsvOsKIOTWD2egnq2SBZdOkC4B3kL/8utQ/DdyR0mCm8iI8jeDG/r8XA4WMqxp8Btjg=

On 26/08/05 09:37PM, Darrick J. Wong wrote:
> On Mon, Aug 03, 2026 at 02:28:36AM +0000, John Groves wrote:
> > From: John Groves <john@groves.net>
> > 
> > Start building up from the famfs module operations. This commit
> > includes the following:
> > 
> > * Register as a file system
> > * Parse mount parameters
> > * Allocate or find (and initialize) a superblock via famfs_get_tree()
> > * Lookup the host dax device, and bail if it's in use (or not dax)
> > * Add Kconfig and Makefile misc to build famfs
> > * Add FAMFS_SUPER_MAGIC to include/uapi/linux/magic.h
> > * Add export of fs/namei.c:may_open_dev(), which famfs needs to call
> > * Update MAINTAINERS file for the fs/famfs/ path
> > 
> > The following exports had to happen to enable famfs:
> > 
> > * This adds the new fs/super.c:kill_char_super() - the other kill*super
> >   helpers were not quite right.
> 
> Err, how were they not quite right??

Adding this to the description:

   famfs keys its superblock on the backing devdax device's dev_t (via
    sget_dev()), so a second mount of the same device shares one super,
    much as a block filesystem keys on its block device. As a result
    sb->s_dev is a real char-device number: there is no s_bdev, and no
    anonymous block device was allocated. None of the existing kill_sb
    helpers fit:

      - kill_block_super() releases an s_bdev, which famfs does not have.
      - kill_anon_super()/kill_litter_super() call free_anon_bdev(s_dev),
        but s_dev is the devdax dev_t, not an anon-bdev minor famfs
        allocated; freeing it would corrupt the anonymous-dev IDA.
      - generic_shutdown_super() alone omits kill_super_notify(), which
        unlinks the dying sb from fs_supers and wakes concurrent mounters
        (SB_DEAD); skipping it can leave a dead sb discoverable and hang a
        racing mount.

    The correct teardown is generic_shutdown_super() + kill_super_notify()
    with no device free. kill_super_notify() is static to fs/super.c, so a
    module cannot compose it -- hence this small exported helper.

> 
> > This commit builds but is otherwise too incomplete to run
> 
> Maybe you shouldn't add famfs to fs/Makefile until the very last patch,
> since that would eliminate all bisection errors.
> 
> Also, are you trying to get this merged for 7.3?  Because I'm /really/
> tired of watching this continue to drag on for three years now.  You
> prototyped a weird left turn through fuse.  In trying to work with
> Miklos and Amir on various fuse improvements, we both discovered that
> Miklos says he's not a good maintainer[1].
> 
> At this point I agree with you that it makes no sense to continue with
> the fuse direction even if Amir and Joanne think you're close, because
> no, you're not close, you're *done*.  This is a working driver, you've
> spent years QAing it, sampling it to some users (apparently) to get
> feedback so you know that you've built better than a trash fire, and now
> you're the co-chair of some CXL committee so you and Micron are probably
> stuck with it in the long run.  You've even demonstrated that you can
> follow community processes even when they're frustrating and slow.
> 
> IOWs, let's fix the remaining wobbles (if any) and just merge this
> already.  No more side quests through gigantic refactorings of fusex,
> that's too much to ask after you already redesigned and reimplemented
> the whole thing already.
> 
> Quoting Miklos from the fuse session at LSFMM:
> [1] https://lwn.net/Articles/1086336/
> 
> Proceeding on to the wobbles (if any).
> 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  MAINTAINERS                |   7 +
> >  fs/Kconfig                 |   2 +
> >  fs/Makefile                |   1 +
> >  fs/famfs/Kconfig           |  11 ++
> >  fs/famfs/Makefile          |   5 +
> >  fs/famfs/famfs_inode.c     | 293 +++++++++++++++++++++++++++++++++++++
> >  fs/famfs/famfs_internal.h  |  32 ++++
> >  fs/namei.c                 |   1 +
> >  fs/super.c                 |   7 +
> >  include/linux/fs.h         |   1 +
> >  include/uapi/linux/magic.h |   1 +
> >  11 files changed, 361 insertions(+)
> >  create mode 100644 fs/famfs/Kconfig
> >  create mode 100644 fs/famfs/Makefile
> >  create mode 100644 fs/famfs/famfs_inode.c
> >  create mode 100644 fs/famfs/famfs_internal.h
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index a674e36529f7..ca7b90a8f0a1 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -9905,6 +9905,13 @@ F:	Documentation/networking/failover.rst
> >  F:	include/net/failover.h
> >  F:	net/core/failover.c
> >  
> > +FAMFS [Fabric-Attached Memory File System]
> > +M:	John Groves <John@Groves.net>
> > +L:	linux-fsdevel@vger.kernel.org
> > +L:	linux-cxl@vger.kernel.org
> > +S:	Supported
> > +F:	fs/famfs/
> > +
> >  FANOTIFY
> >  M:	Jan Kara <jack@suse.cz>
> >  R:	Amir Goldstein <amir73il@gmail.com>
> > diff --git a/fs/Kconfig b/fs/Kconfig
> > index cf6ae64776e6..2db647accc00 100644
> > --- a/fs/Kconfig
> > +++ b/fs/Kconfig
> > @@ -131,6 +131,8 @@ source "fs/autofs/Kconfig"
> >  source "fs/fuse/Kconfig"
> >  source "fs/overlayfs/Kconfig"
> >  
> > +source "fs/famfs/Kconfig"
> > +
> >  menu "Caches"
> >  
> >  source "fs/netfs/Kconfig"
> > diff --git a/fs/Makefile b/fs/Makefile
> > index 89a8a9d207d1..f49f9a000210 100644
> > --- a/fs/Makefile
> > +++ b/fs/Makefile
> > @@ -129,3 +129,4 @@ obj-$(CONFIG_VBOXSF_FS)		+= vboxsf/
> >  obj-$(CONFIG_ZONEFS_FS)		+= zonefs/
> >  obj-$(CONFIG_BPF_LSM)		+= bpf_fs_kfuncs.o
> >  obj-$(CONFIG_RESCTRL_FS)	+= resctrl/
> > +obj-$(CONFIG_FAMFS)		+= famfs/
> > diff --git a/fs/famfs/Kconfig b/fs/famfs/Kconfig
> > new file mode 100644
> > index 000000000000..ed40cf8b0592
> > --- /dev/null
> > +++ b/fs/famfs/Kconfig
> > @@ -0,0 +1,11 @@
> > +
> > +
> > +config FAMFS
> > +       tristate "famfs: shared memory file system"
> > +       depends on DEV_DAX && FS_DAX && DEV_DAX_FSDEV
> > +       default m if DEV_DAX && FS_DAX && DEV_DAX_FSDEV
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
> > index 000000000000..c299a90912a5
> > --- /dev/null
> > +++ b/fs/famfs/famfs_inode.c
> 
> You could probably call this fs/famfs/inode.c.

Can do. I have a personal bias against same-name-different-dir
files, but it would save some keystrokes...

> 
> > @@ -0,0 +1,293 @@
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
> > +#include <linux/cleanup.h>
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
> > +static struct inode *famfs_get_inode(
> > +			struct super_block *sb,
> > +			const struct inode *dir,
> > +			umode_t mode, dev_t dev)
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
> 
> (I would almost rather you declare empty ops structs instead of churning
> this later, but eh.)

That might have been easier to get this rebased into a bisectable
series (which was hard)... but unless I broke it last minute, it 
is bisectable, so I'll leave it alone unless somebody feels strongly.

> 
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
> > + * famfs dax_operations (for famfs-mode dax)
> > + */
> > +/*****************************************************************************
> > + * fs_context_operations
> > + */
> > +
> > +static void
> > +famfs_fill_super(struct super_block *sb, struct fs_context *fc)
> > +{
> > +	sb->s_maxbytes		= MAX_LFS_FILESIZE;
> > +	sb->s_blocksize		= PAGE_SIZE;
> > +	sb->s_blocksize_bits	= PAGE_SHIFT;
> > +	sb->s_magic		= FAMFS_SUPER_MAGIC;
> > +	sb->s_op		= NULL /* famfs_super_ops */;
> > +	sb->s_time_gran		= 1;
> > +}
> > +
> > +int
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
> > +	if (!may_open_dev(&path)) {
> > +		err = -EACCES;
> > +		goto out_path_put;
> > +	}
> > +
> > +	/* i_rdev is the char dev_t; fs_dax_get() confirms it is dax later */
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
> > +	struct super_block *sb;
> > +	struct inode *inode;
> > +	dev_t daxdevno;
> > +	int err;
> > +
> > +	err = lookup_daxdev(fc->source, &daxdevno);
> > +	if (err)
> > +		return err;
> > +
> > +	/* This will set sb->s_dev=daxdevno */
> > +	sb = sget_dev(fc, daxdevno);
> > +	if (IS_ERR(sb)) {
> > +		pr_debug("%s: sget_dev error\n", __func__);
> > +		return PTR_ERR(sb);
> > +	}
> > +
> > +	if (sb->s_root) {
> > +		pr_debug("%s: found a matching superblock for %s\n",
> > +			__func__, fc->source);
> > +
> > +		/* We don't expect to find a match by dev_t; if we do, it must
> > +		 * already be mounted, so we bail
> > +		 */
> > +		err = -EBUSY;
> > +		goto deactivate_out;
> > +	} else {
> > +		pr_debug("%s: initializing new superblock for %s\n",
> > +			__func__, fc->source);
> > +		famfs_fill_super(sb, fc);
> > +	}
> > +
> > +	inode = famfs_get_inode(sb, NULL, S_IFDIR | fsi->mount_opts.mode, 0);
> 
> Can this fail?
> 
> The rest looks good to me, though I imagine shashiko will mumble things
> off-list for you to fix. :P

Yes it did!

Thank you Darrick!!

John

<snip>
