Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5A8388E44;
	Thu,  6 Aug 2026 05:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785993153; cv=none; b=rOU1K1DL3y9jHnKFkG2guJkJqM3h+SRG+Xeu+4mE3NzMrxnoDks6GdpgbrwuymC9XALWZl9hM27OHXpu27Hz444lPi4B/Og6IBvzrZk6bEvtDGpZXwrxFVlv4hEvIRCbtx5zVwSFAL4eetvFlTYaOiHH6iriHqk3FiKMxQk5DFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785993153; c=relaxed/simple;
	bh=nMNUp2vTzEqVibPXQPd4tKAsjHyoDzt/1nksPC7cMJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KY+vrCgKmgjk2YlXC+4TkX0Z0GoGe51IYSD4iTdgaBgSIB9Xgi78jSZtETTkbM6GXUkVQkjyJrdesD/493j3vniOcHD4U9Cqc6uvQF6lblKvrZnDK4tSu+mNOeMO7csgc1eUljv4+5GWKVvNcVNwwR9fvO4fBj46Yb3fBfJEzRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZqYzTbBV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZqYzTbBV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 402081F000E9;
	Thu,  6 Aug 2026 05:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785993151;
	bh=cmvCEj1SNfgQu/aqHwyEosderoFUrk4GJ5jvD2mbOcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZqYzTbBVVdU1/gs21FMnXpyqwrOK3xFfVT1gVA+NbAopupUtSg54wxS6eZbmuivfZ
	 +WFn+l+k+Wi9PCoUIgf99qtaTkhNtlwz1kZCJ2rdtThPrNNk5UBjylphobru83ItgM
	 P5YqejOAwnp1UI5C9uxEN1xTyOPVa5YGN0mmKvks1aY5fNM53AWNzuIpOiJsejBuvZ
	 xe3neiFuM+QGJeKFIpUB/bmk5gXF9nd+GTmUuwr/PWuMmzRU+rZd4wP3K2i89beYwv
	 qXZWCp+z4e3mImFXYxPEztiN0t6MPI1QJH+C+QkJNk/ugH6I8eCkKf1C5Qh8mRspb6
	 ns/ANiAkkhQ/A==
Date: Wed, 5 Aug 2026 22:12:30 -0700
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
Subject: Re: [PATCH V12 04/12] famfs: Introduce inode_operations and
 super_operations
Message-ID: <20260806051230.GD3560084@frogsfrogsfrogs>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022849.75812-1-john@jagalactic.com>
 <0100019fc573edf6-93c159df-6197-4bdf-9f1d-74b77a72ce7e-000000@email.amazonses.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019fc573edf6-93c159df-6197-4bdf-9f1d-74b77a72ce7e-000000@email.amazonses.com>

On Mon, Aug 03, 2026 at 02:28:56AM +0000, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> The famfs inode and super operations are generic other than
> show_options, evict_inode and setattr (which prevents truncation..
> 
> This commit builds but is still too incomplete to run
> 
> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/famfs/famfs_inode.c    | 249 +++++++++++++++++++++++++++++++++++++-
>  fs/famfs/famfs_internal.h |   6 +
>  2 files changed, 252 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> index ad71e5e7a8e3..efc6b852eca0 100644
> --- a/fs/famfs/famfs_inode.c
> +++ b/fs/famfs/famfs_inode.c
> @@ -29,6 +29,9 @@
>  
>  #define FAMFS_DEFAULT_MODE	0755
>  
> +static const struct inode_operations famfs_file_inode_operations;
> +static const struct inode_operations famfs_dir_inode_operations;
> +
>  static struct inode *famfs_get_inode(
>  			struct super_block *sb,
>  			const struct inode *dir,
> @@ -54,11 +57,11 @@ static struct inode *famfs_get_inode(
>  		init_special_inode(inode, mode, dev);
>  		break;
>  	case S_IFREG:
> -		inode->i_op = NULL /* famfs_file_inode_operations */;
> +		inode->i_op = &famfs_file_inode_operations;
>  		inode->i_fop = NULL /* &famfs_file_operations */;
>  		break;
>  	case S_IFDIR:
> -		inode->i_op = NULL /* famfs_dir_inode_operations */;
> +		inode->i_op = &famfs_dir_inode_operations;
>  		inode->i_fop = &simple_dir_operations;
>  
>  		/* Directory inodes start off with i_nlink == 2 (for ".") */
> @@ -72,6 +75,246 @@ static struct inode *famfs_get_inode(
>  	return inode;
>  }
>  
> +/***************************************************************************
> + * famfs inode_operations
> + */
> +
> +static int
> +famfs_setattr(
> +	struct mnt_idmap *idmap,
> +	struct dentry *dentry,
> +	struct iattr *iattr)
> +{
> +	struct inode *inode = d_inode(dentry);
> +	struct famfs_fs_info *fsi = inode->i_sb->s_fs_info;
> +
> +	/* Resizing a famfs file (its size is pinned to the fmap) */
> +	if ((iattr->ia_valid & ATTR_SIZE) &&
> +	    !famfs_opt_enabled(fsi, FAMFS_OPT_TRUNCATE) &&

Does truncating the file down release the mapped memory?
Can you truncate it up?  How does the famfs manager deal with this?

> +	    iattr->ia_size != i_size_read(inode))
> +		return -EPERM;
> +	if ((iattr->ia_valid & ATTR_MODE) &&
> +	    !famfs_opt_enabled(fsi, FAMFS_OPT_CHMOD))
> +		return -EPERM;
> +	if ((iattr->ia_valid & (ATTR_UID | ATTR_GID)) &&
> +	    !famfs_opt_enabled(fsi, FAMFS_OPT_CHOWN))
> +		return -EPERM;
> +	if ((iattr->ia_valid & (ATTR_ATIME | ATTR_MTIME)) &&
> +	    !famfs_opt_enabled(fsi, FAMFS_OPT_UTIMES))
> +		return -EPERM;
> +
> +	return simple_setattr(idmap, dentry, iattr);
> +}
> +
> +static const struct inode_operations famfs_file_inode_operations = {
> +	/* All generic */
> +	.setattr	   = famfs_setattr,
> +	.getattr	   = simple_getattr,
> +};
> +
> +/*
> + * Internal inode creation helper, shared by ->create, ->mkdir, ->mknod and
> + * ->symlink. Each of those callers is responsible for its own FAMFS_OPT_*
> + * permission check before getting here.
> + */
> +static int
> +famfs_mknod(struct mnt_idmap *idmap, struct inode *dir, struct dentry *dentry,
> +	    umode_t mode, dev_t dev)
> +{
> +	struct famfs_fs_info *fsi = dir->i_sb->s_fs_info;
> +	struct timespec64 tv;
> +	struct inode *inode;
> +
> +	if (fsi->deverror)
> +		return -ENODEV;
> +
> +	inode = famfs_get_inode(dir->i_sb, dir, mode, dev);
> +	if (!inode)
> +		return -ENOSPC;
> +
> +	d_make_persistent(dentry, inode);
> +	tv = inode_set_ctime_current(inode);
> +	inode_set_mtime_to_ts(inode, tv);
> +	inode_set_atime_to_ts(inode, tv);
> +
> +	return 0;
> +}
> +
> +static struct dentry *famfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
> +		struct dentry *dentry, umode_t mode)
> +{
> +	struct famfs_fs_info *fsi = dir->i_sb->s_fs_info;
> +	int rc;
> +
> +	if (fsi->deverror)
> +		return ERR_PTR(-ENODEV);
> +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_MKDIR))
> +		return ERR_PTR(-EPERM);
> +
> +	rc = famfs_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFDIR, 0);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	inc_nlink(dir);
> +
> +	return ERR_PTR(0);
> +}
> +
> +static int famfs_create(struct mnt_idmap *idmap, struct inode *dir,
> +			struct dentry *dentry, umode_t mode, bool excl)
> +{
> +	struct famfs_fs_info *fsi = dir->i_sb->s_fs_info;
> +
> +	if (fsi->deverror)
> +		return -ENODEV;
> +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_CREATE))
> +		return -EPERM;
> +
> +	return famfs_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFREG, 0);

Is the model here that you creat() a file and then the famfs server has
to go find it some cxl memory?  I was kinda under the impression that
you'd get the famfs software to map some memory to a name, and then the
famfs server on each node would create it and upload the mapping, and
now the cxlmem-backed file can be mmaped from multiple nodes?

But maybe this is less of a cluster filesystem than I assumed it was.

--D

> +}
> +
> +static int
> +famfs_mknod_op(struct mnt_idmap *idmap, struct inode *dir,
> +	       struct dentry *dentry, umode_t mode, dev_t dev)
> +{
> +	struct famfs_fs_info *fsi = dir->i_sb->s_fs_info;
> +
> +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_MKNOD))
> +		return -EPERM;
> +
> +	return famfs_mknod(idmap, dir, dentry, mode, dev);
> +}
> +
> +static int
> +famfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
> +	      struct dentry *dentry, const char *symname)
> +{
> +	struct famfs_fs_info *fsi = dir->i_sb->s_fs_info;
> +	struct inode *inode;
> +	int len, rc;
> +
> +	if (fsi->deverror)
> +		return -ENODEV;
> +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_SYMLINK))
> +		return -EPERM;
> +
> +	inode = famfs_get_inode(dir->i_sb, dir, S_IFLNK | 0777, 0);
> +	if (!inode)
> +		return -ENOSPC;
> +
> +	len = strlen(symname) + 1;
> +	rc = page_symlink(inode, symname, len);
> +	if (rc) {
> +		iput(inode);
> +		return rc;
> +	}
> +
> +	d_make_persistent(dentry, inode);
> +	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
> +
> +	return 0;
> +}
> +
> +static int
> +famfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
> +{
> +	struct famfs_fs_info *fsi = dir->i_sb->s_fs_info;
> +
> +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_LINK))
> +		return -EPERM;
> +
> +	return simple_link(old_dentry, dir, dentry);
> +}
> +
> +static int famfs_unlink(struct inode *dir, struct dentry *dentry)
> +{
> +	struct inode *inode = d_inode(dentry);
> +	struct famfs_fs_info *fsi = dir->i_sb->s_fs_info;
> +
> +	/* A file with an fmap may only be unlinked when explicitly enabled */
> +	if (inode->i_private && !famfs_opt_enabled(fsi, FAMFS_OPT_UNLINK))
> +		return -EPERM;
> +
> +	return simple_unlink(dir, dentry);
> +}
> +
> +static int famfs_rmdir(struct inode *dir, struct dentry *dentry)
> +{
> +	struct famfs_fs_info *fsi = dir->i_sb->s_fs_info;
> +
> +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_RMDIR))
> +		return -EPERM;
> +
> +	return simple_rmdir(dir, dentry);
> +}
> +
> +static int
> +famfs_rename(
> +	struct mnt_idmap *idmap,
> +	struct inode *old_dir,
> +	struct dentry *old_dentry,
> +	struct inode *new_dir,
> +	struct dentry *new_dentry,
> +	unsigned int flags)
> +{
> +	struct famfs_fs_info *fsi = old_dir->i_sb->s_fs_info;
> +
> +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_RENAME))
> +		return -EPERM;
> +
> +	return simple_rename(idmap, old_dir, old_dentry, new_dir, new_dentry,
> +			     flags);
> +}
> +
> +static const struct inode_operations famfs_dir_inode_operations = {
> +	.create		= famfs_create,
> +	.lookup		= simple_lookup,
> +	.link		= famfs_link,
> +	.unlink		= famfs_unlink,
> +	.symlink	= famfs_symlink,
> +	.mkdir		= famfs_mkdir,
> +	.mknod		= famfs_mknod_op,
> +	.rmdir		= famfs_rmdir,
> +	.rename		= famfs_rename,
> +};
> +
> +/*****************************************************************************
> + * famfs super_operations
> + *
> + * TODO: implement a famfs_statfs() that shows size, free and available space,
> + * etc.
> + */
> +
> +/*
> + * famfs_show_options() - Display the mount options in /proc/mounts.
> + */
> +static int famfs_show_options(struct seq_file *m, struct dentry *root)
> +{
> +	struct famfs_fs_info *fsi = root->d_sb->s_fs_info;
> +
> +	if (fsi->mount_opts.mode != FAMFS_DEFAULT_MODE)
> +		seq_printf(m, ",mode=%o", fsi->mount_opts.mode);
> +
> +	return 0;
> +}
> +
> +static void famfs_evict_inode(struct inode *inode)
> +{
> +	inode->i_private = NULL;
> +	dax_break_layout_final(inode);
> +	truncate_inode_pages_final(&inode->i_data);
> +	clear_inode(inode);
> +}
> +
> +static const struct super_operations famfs_super_ops = {
> +	.statfs		= simple_statfs,
> +	.drop_inode	= inode_just_drop,
> +	.show_options	= famfs_show_options,
> +	.evict_inode    = famfs_evict_inode,
> +};
> +
> +/*****************************************************************************/
> +
>  /*
>   * famfs dax_operations (for famfs-mode dax)
>   */
> @@ -305,7 +548,7 @@ famfs_fill_super(struct super_block *sb, struct fs_context *fc)
>  	sb->s_blocksize		= PAGE_SIZE;
>  	sb->s_blocksize_bits	= PAGE_SHIFT;
>  	sb->s_magic		= FAMFS_SUPER_MAGIC;
> -	sb->s_op		= NULL /* famfs_super_ops */;
> +	sb->s_op		= &famfs_super_ops;
>  	sb->s_time_gran		= 1;
>  }
>  
> diff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h
> index ebb9c499cf69..485087588a11 100644
> --- a/fs/famfs/famfs_internal.h
> +++ b/fs/famfs/famfs_internal.h
> @@ -70,6 +70,12 @@ struct famfs_fs_info {
>  	struct rw_semaphore       devlist_sem;
>  };
>  
> +/* This stub will be replaced in a later commit 
> + * Note: the opt parameter is intentionally unused, and will be used by
> + * the replacement function when that commit lands
> + */
> +#define famfs_opt_enabled(fsi, opt) (fsi != 0)
> +
>  int lookup_daxdev(const char *pathname, dev_t *devno);
>  int famfs_devlist_alloc(struct famfs_fs_info *fsi);
>  int famfs_install_daxdev(struct famfs_fs_info *fsi, struct super_block *sb,
> -- 
> 2.53.0
> 
> 
> 
