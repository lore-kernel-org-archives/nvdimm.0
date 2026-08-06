Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E301C84AB;
	Thu,  6 Aug 2026 16:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786033908; cv=none; b=My1IwzwrkpVdGdOR237HbihFUvbUyEhGCmeV8iPNUKosIF9iYBLTyXvlmMgbDvpnLNptUE0SRvJgjbiq9CoTLoEb3zrkj5hkYJj3GQHTFuyle7C+g9QpKC5ilcWsnxd0SkwCcCNc1gEDwG8/3N3hi82Bn+7xkgKrtx3xaMASgG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786033908; c=relaxed/simple;
	bh=S1WHS47dZqOWcWdyoLnXM71Fkc3PHLqdyZiQgtqEFPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1ByiVxYf9uEV7ztpVe6FGe3jKfBX7bm5RnG+Yv/vhp2RQOGqw+ZDtq6OGclLdTSYIjZ+yPv5K4S3z30EfqXtCPuhfHPSYY88RgbKM0fOtT5PTAsN0SDxj/oYcA2j1QF0WnsUwDPmuE/6rQ1xG0RDISHXUvNnV5d6JIazQF2nMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9AD0A0110;
	Thu,  6 Aug 2026 16:31:34 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf15.hostedemail.com (Postfix) with ESMTPA id 1FEAF17;
	Thu,  6 Aug 2026 16:31:17 +0000 (UTC)
Date: Thu, 6 Aug 2026 11:31:16 -0500
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
Subject: Re: [PATCH V12 04/12] famfs: Introduce inode_operations and
 super_operations
Message-ID: <anSgvuQ872AjkSK2@groves.net>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022849.75812-1-john@jagalactic.com>
 <0100019fc573edf6-93c159df-6197-4bdf-9f1d-74b77a72ce7e-000000@email.amazonses.com>
 <20260806051230.GD3560084@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806051230.GD3560084@frogsfrogsfrogs>
X-Stat-Signature: ha4eefzwkjiajen9eszr5zyeqn47tzdi
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 1FEAF17
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+8g1aralK8ALulQm0aAsZil2Ejzt4LBlM=
X-HE-Tag: 1786033877-219472
X-HE-Meta: U2FsdGVkX19FDx7M19BFjDZUbutSb/i+gHmwI5uUhFDw0kOlD+8xaf2k6wfg6MtvehsDkMFGuBvN4S0We2DKi3glVZE29vIPxTCKx4WUvmxXCsuBiGEekBW3N5Pmts0imjwbdoDr4E1Yl0DSbcsnmn+ZwiODX5smwNoXp6N6o5O5jTYfj0naen56uroTnTKrzYYHXOhQ42qcDuTiaLP+VrlN0y33KluDXqEafT5k4INmq+MchKXeKb1DSTEVzWEVTLPAv+OEuZf6GzPyet0CykF4hmOB3jUiQR7OH8U5Ux0F9SjsGdUyd+jHwb4W9GErzzYimJd2po9PdGdFu0l0bOfPWfwq3TDhVItCmwkc00YPKv9AP5gBqAk11GK6ws8P

On 26/08/05 10:12PM, Darrick J. Wong wrote:
> On Mon, Aug 03, 2026 at 02:28:56AM +0000, John Groves wrote:
> > From: John Groves <john@groves.net>
> > 
> > The famfs inode and super operations are generic other than
> > show_options, evict_inode and setattr (which prevents truncation..
> > 
> > This commit builds but is still too incomplete to run
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/famfs/famfs_inode.c    | 249 +++++++++++++++++++++++++++++++++++++-
> >  fs/famfs/famfs_internal.h |   6 +
> >  2 files changed, 252 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> > index ad71e5e7a8e3..efc6b852eca0 100644
> > --- a/fs/famfs/famfs_inode.c
> > +++ b/fs/famfs/famfs_inode.c
> > @@ -29,6 +29,9 @@
> >  
> >  #define FAMFS_DEFAULT_MODE	0755
> >  
> > +static const struct inode_operations famfs_file_inode_operations;
> > +static const struct inode_operations famfs_dir_inode_operations;
> > +
> >  static struct inode *famfs_get_inode(
> >  			struct super_block *sb,
> >  			const struct inode *dir,
> > @@ -54,11 +57,11 @@ static struct inode *famfs_get_inode(
> >  		init_special_inode(inode, mode, dev);
> >  		break;
> >  	case S_IFREG:
> > -		inode->i_op = NULL /* famfs_file_inode_operations */;
> > +		inode->i_op = &famfs_file_inode_operations;
> >  		inode->i_fop = NULL /* &famfs_file_operations */;
> >  		break;
> >  	case S_IFDIR:
> > -		inode->i_op = NULL /* famfs_dir_inode_operations */;
> > +		inode->i_op = &famfs_dir_inode_operations;
> >  		inode->i_fop = &simple_dir_operations;
> >  
> >  		/* Directory inodes start off with i_nlink == 2 (for ".") */
> > @@ -72,6 +75,246 @@ static struct inode *famfs_get_inode(
> >  	return inode;
> >  }
> >  
> > +/***************************************************************************
> > + * famfs inode_operations
> > + */
> > +
> > +static int
> > +famfs_setattr(
> > +	struct mnt_idmap *idmap,
> > +	struct dentry *dentry,
> > +	struct iattr *iattr)
> > +{
> > +	struct inode *inode = d_inode(dentry);
> > +	struct famfs_fs_info *fsi = inode->i_sb->s_fs_info;
> > +
> > +	/* Resizing a famfs file (its size is pinned to the fmap) */
> > +	if ((iattr->ia_valid & ATTR_SIZE) &&
> > +	    !famfs_opt_enabled(fsi, FAMFS_OPT_TRUNCATE) &&
> 
> Does truncating the file down release the mapped memory?
> Can you truncate it up?  How does the famfs manager deal with this?

Truncate won't be enabled in any situation I can currently think of,
but it made sense to gate it with the opt_enabled mechanism in case
it makes sense at some point.

Space is not freed; It's still part of the daxdev, which is never
sparse.  The famfs metadata log is authoritative on allocations, and 
doesn't currently support delete, so the dax memory for a file is 
spoken for until the whole file system is killed.

There are cases where chmod/chown make sense, but the change is local
and ephemeral - not recorded to the metadata log.

> 
> > +	    iattr->ia_size != i_size_read(inode))
> > +		return -EPERM;
> > +	if ((iattr->ia_valid & ATTR_MODE) &&
> > +	    !famfs_opt_enabled(fsi, FAMFS_OPT_CHMOD))
> > +		return -EPERM;
> > +	if ((iattr->ia_valid & (ATTR_UID | ATTR_GID)) &&
> > +	    !famfs_opt_enabled(fsi, FAMFS_OPT_CHOWN))
> > +		return -EPERM;
> > +	if ((iattr->ia_valid & (ATTR_ATIME | ATTR_MTIME)) &&
> > +	    !famfs_opt_enabled(fsi, FAMFS_OPT_UTIMES))
> > +		return -EPERM;
> > +
> > +	return simple_setattr(idmap, dentry, iattr);
> > +}
> > +
> > +static const struct inode_operations famfs_file_inode_operations = {
> > +	/* All generic */
> > +	.setattr	   = famfs_setattr,
> > +	.getattr	   = simple_getattr,
> > +};
> > +
> > +/*
> > + * Internal inode creation helper, shared by ->create, ->mkdir, ->mknod and
> > + * ->symlink. Each of those callers is responsible for its own FAMFS_OPT_*
> > + * permission check before getting here.
> > + */
> > +static int
> > +famfs_mknod(struct mnt_idmap *idmap, struct inode *dir, struct dentry *dentry,
> > +	    umode_t mode, dev_t dev)
> > +{
> > +	struct famfs_fs_info *fsi = dir->i_sb->s_fs_info;
> > +	struct timespec64 tv;
> > +	struct inode *inode;
> > +
> > +	if (fsi->deverror)
> > +		return -ENODEV;
> > +
> > +	inode = famfs_get_inode(dir->i_sb, dir, mode, dev);
> > +	if (!inode)
> > +		return -ENOSPC;
> > +
> > +	d_make_persistent(dentry, inode);
> > +	tv = inode_set_ctime_current(inode);
> > +	inode_set_mtime_to_ts(inode, tv);
> > +	inode_set_atime_to_ts(inode, tv);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct dentry *famfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
> > +		struct dentry *dentry, umode_t mode)
> > +{
> > +	struct famfs_fs_info *fsi = dir->i_sb->s_fs_info;
> > +	int rc;
> > +
> > +	if (fsi->deverror)
> > +		return ERR_PTR(-ENODEV);
> > +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_MKDIR))
> > +		return ERR_PTR(-EPERM);
> > +
> > +	rc = famfs_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFDIR, 0);
> > +	if (rc)
> > +		return ERR_PTR(rc);
> > +
> > +	inc_nlink(dir);
> > +
> > +	return ERR_PTR(0);
> > +}
> > +
> > +static int famfs_create(struct mnt_idmap *idmap, struct inode *dir,
> > +			struct dentry *dentry, umode_t mode, bool excl)
> > +{
> > +	struct famfs_fs_info *fsi = dir->i_sb->s_fs_info;
> > +
> > +	if (fsi->deverror)
> > +		return -ENODEV;
> > +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_CREATE))
> > +		return -EPERM;
> > +
> > +	return famfs_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFREG, 0);
> 
> Is the model here that you creat() a file and then the famfs server has
> to go find it some cxl memory?  I was kinda under the impression that
> you'd get the famfs software to map some memory to a name, and then the
> famfs server on each node would create it and upload the mapping, and
> now the cxlmem-backed file can be mmaped from multiple nodes?
> 
> But maybe this is less of a cluster filesystem than I assumed it was.
> 
> --D

Not quite. The memory is allocated when a file is committed to the
metadata log, before a file is ever creat'd. When the log is played, 
initially empty file instances get created (by the famfs lib in user
space) and then the fmaps get passed in via FAMFS_IOC_MAP_CREATE 
(after which files are usable). (the word "file" is admittedly 
overloaded here; hope it makes sense.)

The cluster aspect is unusual if not unique. Only one node (the master) 
can write the MD log, meaning only that node can create files (by which 
I mean commit file_create log entries). Other nodes can only play the 
log, which guarantees they see files that point the the same memory 
cluster-wide.

Although file allocation is immutable until you kill the superblocks
and start over, data can be mutable from any node you like. This is
definitely unusual.

The MD log is append-only, and does not support mutations to allocation
(truncate/append/delete), which solves the cluster consistency problem
around which files point where. The worst structural inconsistency
that's possible, if some nodes are behind on playing the log, is that
those nodes don't see the newest files.

Thank you!
John

<snip>

