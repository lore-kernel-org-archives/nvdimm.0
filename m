Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7660C489863;
	Mon,  3 Aug 2026 02:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724975; cv=none; b=nfFB1dWuRMnjpQHBIZ0/9CH9XGILkjmMpT0h+NYYo93MFiTdEY5qBUYav59hwYAhn/SNg0tD5itcirxmNuoOf9cLVnPyD4bFV5seQpU8Tivi8pCkLwVlx5ErEXQbqH0nk8lK3h+hA0QXMYpihAbZLEl76Dp64TH5map8KH706Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724975; c=relaxed/simple;
	bh=bCDm7fbqV3uwTYHVZQImCTxLRVS2mvw9ZC6566XgxSg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HlB7ejMtdKN4JDZfHC0FANuKx5vjCz57PsbtyUa3h8CHp+FN7RXWAPCHnBqGrGrKwUCcRc7Y00SBTabZkrTmS1ohFQOg7/BlSAEQOBd2V9FIDNxt8cDNABobkFxaV3f5QnFXFnUEw/tNgEHwPEXaQWipY7tIssKaFzICsXt25HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dIbiF4Db; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dIbiF4Db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2431F000E9;
	Mon,  3 Aug 2026 02:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785724974;
	bh=1JwSqGqn94RIbPNRe2todwOklLLoibUcogVq/FnV+6Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dIbiF4DbVrhUKR17d+CRQReuafCmxcnjSVy5oaLvDrPyrZnAV24VN6sW+Ot2k4a/w
	 3X5WmQyJdn6C3KCJ7i+uIcVIIUqGqe8RTQ5zDH92wYjYemeHqKqWth9eGEoAZhYBqt
	 eSUoxiWKphdBxRhd4qvu91+wyK1G7nzFqF37GPN4TlMXUKah8AXmkQivxoYRmXCQs0
	 wcIb89rnwRgz3hLGvAz1nmIU7xQtFZnyF4iQC2kJFIbQC13wphoNIccD7O6A99uzA2
	 +GGbtMUEAJq9wkRMgKkj1H1ezovwgphUEJCWVYw5yMV9KVGtIF9/ZcKVrdm0lAQZa0
	 YWRFF1RAqbIMg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V12 04/12] famfs: Introduce inode_operations and
 super_operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <0100019fc573edf6-93c159df-6197-4bdf-9f1d-74b77a72ce7e-000000@email.amazonses.com>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022849.75812-1-john@jagalactic.com>
 <0100019fc573edf6-93c159df-6197-4bdf-9f1d-74b77a72ce7e-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 02:42:53 +0000
Message-Id: <20260803024253.DC2431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Setting `inode->i_fop` to `NULL` for regular files triggers a kern=
el WARN_ON during `open()`, leading to a denial of service.
- [High] The `FAMFS_OPT_UNLINK` and `FAMFS_OPT_RMDIR` policies can be trivi=
ally bypassed by renaming an entry over existing files or directories.
- [Medium] Creation operations (create, mkdir, mknod) fail to update the pa=
rent directory's timestamps, and racily update the child inode's timestamps=
 after publishing.
--

--- Patch [4]: [PATCH V12 04/12] famfs: Introduce inode_operations and supe=
r_operations ---
commit 1062e22926010cfce092f1770e05033249b3ab2f
Author: John Groves <john@groves.net>

famfs: Introduce inode_operations and super_operations

The famfs inode and super operations are generic other than
show_options, evict_inode and setattr. This commit builds but is
still too incomplete to run.

> diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> index ad71e5e7a8e39..efc6b852eca00 100644
> --- a/fs/famfs/famfs_inode.c
> +++ b/fs/famfs/famfs_inode.c
[ ... ]
> @@ -54,11 +57,11 @@ static struct inode *famfs_get_inode(
>  		init_special_inode(inode, mode, dev);
>  		break;
>  	case S_IFREG:
> -		inode->i_op =3D NULL /* famfs_file_inode_operations */;
> +		inode->i_op =3D &famfs_file_inode_operations;
>  		inode->i_fop =3D NULL /* &famfs_file_operations */;

[Severity: High]
Will this trigger a kernel warning during open()?

When VFS attempts to open a regular file, do_dentry_open() calls
fops_get(inode->i_fop). Passing a NULL f_op pointer triggers a
WARN_ON(!f->f_op), which could lead to a denial of service on systems
with panic_on_warn enabled.

>  		break;
>  	case S_IFDIR:
> -		inode->i_op =3D NULL /* famfs_dir_inode_operations */;
> +		inode->i_op =3D &famfs_dir_inode_operations;
>  		inode->i_fop =3D &simple_dir_operations;
[ ... ]
> +static int
> +famfs_mknod(struct mnt_idmap *idmap, struct inode *dir, struct dentry *d=
entry,
> +	    umode_t mode, dev_t dev)
> +{
> +	struct famfs_fs_info *fsi =3D dir->i_sb->s_fs_info;
> +	struct timespec64 tv;
> +	struct inode *inode;
> +
> +	if (fsi->deverror)
> +		return -ENODEV;
> +
> +	inode =3D famfs_get_inode(dir->i_sb, dir, mode, dev);
> +	if (!inode)
> +		return -ENOSPC;
> +
> +	d_make_persistent(dentry, inode);
> +	tv =3D inode_set_ctime_current(inode);
> +	inode_set_mtime_to_ts(inode, tv);
> +	inode_set_atime_to_ts(inode, tv);

[Severity: Medium]
Is there a typo here with 'inode' instead of 'dir'?

Creation operations should update the parent directory's mtime and ctime.
Updating the newly created child inode's timestamps here seems redundant si=
nce
they are already initialized in famfs_get_inode().=20

Additionally, modifying the child inode's timestamps after calling
d_make_persistent() publishes it to the dcache creates a race condition
against lockless lookups.

> +
> +	return 0;
> +}
[ ... ]
> +static int
> +famfs_rename(
> +	struct mnt_idmap *idmap,
> +	struct inode *old_dir,
> +	struct dentry *old_dentry,
> +	struct inode *new_dir,
> +	struct dentry *new_dentry,
> +	unsigned int flags)
> +{
> +	struct famfs_fs_info *fsi =3D old_dir->i_sb->s_fs_info;
> +
> +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_RENAME))
> +		return -EPERM;
> +
> +	return simple_rename(idmap, old_dir, old_dentry, new_dir, new_dentry,
> +			     flags);

[Severity: High]
Can this implementation bypass the protections in famfs_unlink() and
famfs_rmdir()?

The filesystem implements safety checks in famfs_unlink() to prevent
the removal of files with active memory maps (where inode->i_private is
set). However, delegating directly to simple_rename() will internally call
simple_unlink() or simple_rmdir() on an existing target without invoking the
custom policy checks.

Could this allow a policy bypass by renaming an entry over a protected
target, potentially destroying active shared memory states?

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019fc572ca94-ec=
363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com?part=3D4
