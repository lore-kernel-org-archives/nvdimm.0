Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616192BEC45;
	Fri,  7 Aug 2026 13:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786110479; cv=none; b=EGHzpN+igJDjyd3vnee1bA8yxSWFIVse+nDWUCvaGdKBsouCDv2rjpRaE3PefK1XiYCjhuzxhIWSTQd91hHYmlukZvmw38VJGN0YIyJWQPxwiZpSXiphlFeX/JJD8UJ2MaiRshExmGl/Pli4PSYobSO/yGcmRUZhU8pjhscfub0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786110479; c=relaxed/simple;
	bh=eYl16HP5uXexE4QsoqXNys6JrQgZzYjwhcMhwbxiam4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SgTB5ad/pmjcblL/hAVeFwCKSCRIGpCSygXA97QN2OCibDetQqDhIgsy1tGgXahf1K18NBZB8VAvWUOoFQpuPaOIOlT6XKGvVn0+FwU+Zii1Cg2h4ad6FvEQYGl8FQlmuQ1M5TW8DCunTbrRsAKfZ+Koa8yHG2RxzVaW+IJrAVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23379403D0;
	Fri,  7 Aug 2026 13:47:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf06.hostedemail.com (Postfix) with ESMTPA id 7B8F32000F;
	Fri,  7 Aug 2026 13:47:20 +0000 (UTC)
Date: Fri, 7 Aug 2026 08:47:19 -0500
From: John Groves <john@groves.net>
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
Subject: Re: [PATCH V12 11/12] famfs: Report device capacity via statfs so df
 works
Message-ID: <anXhywwC-DWjHGRz@groves.net>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803023000.75948-1-john@jagalactic.com>
 <0100019fc57500f5-06c293c8-393c-44e3-ad42-d4f4de58245d-000000@email.amazonses.com>
 <20260806053300.GK3560084@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806053300.GK3560084@frogsfrogsfrogs>
X-Stat-Signature: pwrq6rgztu5gdqo7od7a6fg3d45qzcuy
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 7B8F32000F
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1/1vmEfcB0ZWzj6v0b7ezNU01nhES/SZBA=
X-HE-Tag: 1786110440-538022
X-HE-Meta: U2FsdGVkX18XfVA4JrV3nFfuua9yhjn8m+dg/G+LQxmf4sMMGGtOUQeXXEIGISUaUu2JXALFW2BVZgTaH+aLE+iiUKA6KBpKfPLmriNfaWgaaNO3gDRGkhL9PknoGyjO4ZfsB91+bThfZy/mFbb/FV4wwDKoAjrYlqZ9aT0hy84B5GoSYVx1b77c5IiFpOiobgd0krwslBQXQcV5QetVVePkDJMKd38vkethLgeN4HSUCM9LcQR7+vvX4pHFK8u4H8GFzvxBQRfgP8jaHaadlZv//y3F7EKkr2oUqGs+I5QvKS9nbYQRTiLWS+CosOTDiGZ76yRmhpE5r5HZZw15st6ikc3A7GCiTRUhab1kTKTC+JkbRnhogTcDhWHxpDd+

On 26/08/05 10:33PM, Darrick J. Wong wrote:
> On Mon, Aug 03, 2026 at 02:30:07AM +0000, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > Replace simple_statfs(), which reports zero blocks (so df omits the mount),
> > with famfs_statfs() reporting real capacity and usage.
> > 
> > Add dax_fsdev_size() in drivers/dax/fsdev.c, returning the size fsdev
> > caches at probe (dev_dax->cached_size - the sum of the device's ranges,
> > stable while bound), exported. It lives in fsdev.c because cached_size is
> > set only by the fsdev driver, and famfs only ever holds fsdev-mode daxdevs
> > (fs_dax_get() enforces DAXDRV_FSDEV_TYPE); famfs.ko therefore depends on
> > fsdev_dax.ko.
> > 
> > famfs tracks two byte counters under a new stats_sem:
> >  - total_capacity: summed in famfs_install_daxdev() from dax_fsdev_size(),
> >    covering the mount primary and every DAXDEV_OPEN secondary, counted once
> >    per daxdev (on the valid 0->1 transition).
> >  - used_capacity: summed in famfs_file_init_dax() from the fmap's mapped
> >    device bytes (superblock + log + data files).
> > 
> > famfs_statfs() reports total and free (total - used). Free is an
> > approximation of the userspace allocator's free space (it ignores allocator
> > gaps and reserved regions), which is adequate for df.
> > 
> > (Side note: I am the maintainer of drivers/dax/fsdev.c)
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  drivers/dax/fsdev.c       | 19 +++++++++++++++++
> >  fs/famfs/famfs_file.c     |  5 +++++
> >  fs/famfs/famfs_inode.c    | 43 ++++++++++++++++++++++++++++++++++++++-
> >  fs/famfs/famfs_internal.h |  8 ++++++++
> >  include/linux/dax.h       |  1 +
> >  5 files changed, 75 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> > index 188b2526bee4..a5b4b2d79428 100644
> > --- a/drivers/dax/fsdev.c
> > +++ b/drivers/dax/fsdev.c
> > @@ -104,6 +104,25 @@ static size_t fsdev_dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff
> >  	return _copy_from_iter_flushcache(addr, bytes, i);
> >  }
> >  
> > +/**
> > + * dax_fsdev_size() - total size in bytes of an fsdev dax device
> > + * @dax_dev: the dax device (must be bound to this driver)
> > + *
> > + * Returns the size cached at probe time (sum of all ranges); it cannot change
> > + * while the driver is bound. Only valid for fsdev dax devices - callers
> > + * ensure that (e.g. fs_dax_get() enforces DAXDRV_FSDEV_TYPE). Returns 0 if the
> > + * device is not alive.
> > + */
> > +u64 dax_fsdev_size(struct dax_device *dax_dev)
> > +{
> > +	struct dev_dax *dev_dax = dax_get_private(dax_dev);
> > +
> > +	if (!dev_dax)
> > +		return 0;
> > +	return dev_dax->cached_size;
> > +}
> > +EXPORT_SYMBOL_GPL(dax_fsdev_size);
> > +
> >  static const struct dax_operations dev_dax_ops = {
> >  	.direct_access = fsdev_dax_direct_access,
> >  	.zero_page_range = fsdev_dax_zero_page_range,
> > diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> > index abf049b32a4b..5be39d677089 100644
> > --- a/fs/famfs/famfs_file.c
> > +++ b/fs/famfs/famfs_file.c
> > @@ -280,6 +280,11 @@ famfs_file_init_dax(struct file *file, void __user *arg)
> >  	}
> >  	inode_unlock(inode);
> >  
> > +	/* Account the mapped device bytes for statfs (only on success) */
> > +	if (!rc) {
> > +		scoped_guard(rwsem_write, &fsi->stats_sem)
> > +			fsi->used_capacity += extent_total;
> > +	}
> >  out:
> >  	kvfree(fmap_buf);
> >  	if (meta)
> > diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> > index 6cbd7d657fd8..3c0d1094d653 100644
> > --- a/fs/famfs/famfs_inode.c
> > +++ b/fs/famfs/famfs_inode.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/iomap.h>
> >  #include <linux/path.h>
> >  #include <linux/namei.h>
> > +#include <linux/statfs.h>
> >  
> >  #include "famfs_internal.h"
> >  
> > @@ -307,8 +308,37 @@ static void famfs_evict_inode(struct inode *inode)
> >  	clear_inode(inode);
> >  }
> >  
> > +/*
> > + * famfs_statfs() - report device capacity and consumption so 'df' works.
> > + * @total_capacity is the sum of installed daxdev sizes; @used_capacity is the
> > + * sum of device bytes mapped by fmaps (superblock + log + data files). Free is
> > + * the difference - an approximation of the userspace allocator's free space
> > + * (it ignores allocator gaps / reserved regions), which is fine for df.
> > + */
> > +static int famfs_statfs(struct dentry *dentry, struct kstatfs *buf)
> > +{
> > +	struct famfs_fs_info *fsi = dentry->d_sb->s_fs_info;
> > +	u64 total, used, free;
> > +
> > +	scoped_guard(rwsem_read, &fsi->stats_sem) {
> > +		total = fsi->total_capacity;
> > +		used  = fsi->used_capacity;
> > +	}
> > +	free = total > used ? total - used : 0;
> > +
> > +	buf->f_type    = FAMFS_SUPER_MAGIC;
> > +	buf->f_bsize   = PAGE_SIZE;
> > +	buf->f_frsize  = PAGE_SIZE;
> > +	buf->f_blocks  = total >> PAGE_SHIFT;
> > +	buf->f_bfree   = free  >> PAGE_SHIFT;
> > +	buf->f_bavail  = free  >> PAGE_SHIFT;	/* no root reservation */
> > +	buf->f_namelen = NAME_MAX;
> > +	buf->f_fsid    = u64_to_fsid(huge_encode_dev(dentry->d_sb->s_dev));
> > +	return 0;
> > +}
> > +
> >  static const struct super_operations famfs_super_ops = {
> > -	.statfs		= simple_statfs,
> > +	.statfs		= famfs_statfs,
> >  	.drop_inode	= inode_just_drop,
> >  	.show_options	= famfs_show_options,
> >  	.evict_inode    = famfs_evict_inode,
> > @@ -399,6 +429,7 @@ int famfs_install_daxdev(
> >  		const char *name)
> >  {
> >  	struct famfs_daxdev *daxdev;
> > +	struct dax_device *devp = NULL;
> >  	int rc = 0;
> >  
> >  	if (index >= fsi->dax_devlist->nslots) {
> > @@ -462,6 +493,15 @@ int famfs_install_daxdev(
> >  
> >  		wmb(); /* All other fields must be visible before valid */
> >  		daxdev->valid = 1;
> > +		devp = daxdev->devp;
> > +	}
> > +
> > +	/* Freshly installed: add its capacity to the statfs accounting */
> > +	if (devp) {
> > +		u64 sz = dax_fsdev_size(devp);
> > +
> > +		scoped_guard(rwsem_write, &fsi->stats_sem)
> > +			fsi->total_capacity += sz;
> 
> Can dax devices change size the same way block devices can?
> 
> Though for statfs that hardly matters; a bdev shrinkage rarely causes
> b_avail to be updated even if the filesystem starts barfing IO errors
> due to invalid LBA range.
> 
> The code in here looks good to me otherwise.
> 
> --D

There are cases where a daxdev can change size, but fsdev/famfs mode
explicitly prohibits that.

Since the whole idea is that daxdevs probably point to shared memory,
We can't let the size change because it might not happen at the same
instant everywhere. Because special relativity ;)

I watched a video of Leslie Lamport some time back where he said software
concurrency was like special relativity: you often *cannot* know whether
A happened after B, etc.

Thanks!
John

<snip>
