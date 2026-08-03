Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B568D489863;
	Mon,  3 Aug 2026 02:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724959; cv=none; b=lN5OROIKJ3TJeUErfMVdYC7H9S7UXPTYGcdcM1/hxyULie8ZRHxbr4UVtjRIJmJCn5fnGsDXw19ChE+/YIYaLfnhw9c72ee8P6KPQVIJ04Rjrv4hwX2HxKJrMhAr0NeSdoWUgd8CWPlC4m45mWOrA+N6+xk5vZeTpjFFMi3QWck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724959; c=relaxed/simple;
	bh=fO9blh7IguIR24nrCGpaRHBFuB+mymtb06dG9WQf69w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ir5l7jPQy8jrWHrWMQDVitnIVj+ZiAjxAE25lJ0gaZ5hQx0Vl4F5dJonQBoU0Uvyn6TfNxQdnSKCRwGMhZmed54MSGLAakjfoR2+4c4NtALefqKQ8GYVVc0KmrYI5Zc3aAxhAIs9WPGqMMRk1F6eu9S4YkUGASqSFsLfLn+9nFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gZfSzh/Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZfSzh/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EC01F000E9;
	Mon,  3 Aug 2026 02:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785724957;
	bh=cxYmbLYVydA7qYG4qTlZOGcIjyE3cVLo5LP0Q8bw3/0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gZfSzh/YqMa7QEhMyDpJjmOGNDwJ1eZi44eT/xNr7NYlDE9Pytcou4kcKGIr3Z9on
	 t8KVxpHdh79JjvwRc0t8gP2ME8luTaQJxJqEkJeySL4NqzRCEOyE9uFZBTLfCUty0p
	 ssEkMPuYd6Mb9N4AigG60tisVm/Fz2QZEy80BmaY8nhd8uT3PIhPHXRtEbcm9Mj4o1
	 F5+1RO7//JNr3u4SFRM+D40oOtYhc4LfBxjIDTCUJfda39PyZEK6kUzXqciKOQn0GB
	 Dln6bSPfQLl48OSZAt6WMh5aYIOdBTRcgHsF2qCb5ThsZsZO/NFC01sBxZJfnB3gAM
	 2MrODfCMgQ9WQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V12 05/12] famfs: Introduce file_operations read/write
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <0100019fc5741536-d6b2c2f4-794a-43b4-abf4-f38f2d812e19-000000@email.amazonses.com>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022859.75838-1-john@jagalactic.com>
 <0100019fc5741536-d6b2c2f4-794a-43b4-abf4-f38f2d812e19-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 02:42:36 +0000
Message-Id: <20260803024237.24EC01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [High] The custom write iterator famfs_dax_write_iter() omits the require=
d VFS file_modified() / file_remove_privs() hooks, bypassing setuid/setgid =
privilege stripping and timestamp updates.
- [High] famfs_dax_write_iter() bypasses POSIX append semantics and file si=
ze limits by omitting generic_write_checks().
- [High] famfs_rw_prep() truncates the 64-bit file size to 32 bits on 32-bi=
t architectures, breaking bounds checking and causing artificial IO limits.
- [High] Using filemap_splice_read on a DAX filesystem initialized with ram=
_aops will cause splice reads to silently return streams of zeroes.
- [Medium] Writes past the end of the file return 0 instead of an error, wh=
ich can cause infinite loops in userspace.
- [Low] file_accessed() is called unconditionally on reads, updating access=
 time even on errors or EOF.
- [Low] Kernel heap address leak via pr_debug using %llx on an inode pointe=
r.
--

--- Patch [5]: [PATCH V12 05/12] famfs: Introduce file_operations read/writ=
e ---
commit 025e683c34185b254d9bc60d68aabd4be0342a87
Author: John Groves <john@groves.net>

famfs: Introduce file_operations read/write

This commit introduces fs/famfs/famfs_file.c and the famfs
file_operations for read/write. It sets up the groundwork for
DAX I/O, though it currently calls dax_iomap_rw with NULL iomap_ops.

> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> new file mode 100644
> index 0000000000000..e192b573c51f7
> --- /dev/null
> +++ b/fs/famfs/famfs_file.c
> @@ -0,0 +1,138 @@
[ ... ]
> +/* Reject I/O to files that aren't in a valid state */
> +static ssize_t
> +famfs_file_invalid(struct inode *inode)
> +{
> +	if (!IS_DAX(inode)) {
> +		pr_debug("%s: inode %llx IS_DAX is false\n",
> +			 __func__, (u64)inode);

[Severity: Low]
Does this explicit cast to u64 leak the raw kernel heap address of the inod=
e?

When dynamic debugging is enabled and famfs_file_invalid() is called on an
inode without S_DAX, bypassing the kernel's %p hashing protection could exp=
ose
the heap layout to dmesg. Could this assist attackers in bypassing KASLR?

> +		return -ENXIO;
> +	}
> +	return 0;
> +}
> +
> +static ssize_t
> +famfs_rw_prep(struct kiocb *iocb, struct iov_iter *ubuf)
> +{
> +	struct inode *inode =3D iocb->ki_filp->f_mapping->host;
> +	struct super_block *sb =3D inode->i_sb;
> +	struct famfs_fs_info *fsi =3D sb->s_fs_info;
> +	size_t i_size =3D i_size_read(inode);

[Severity: High]
Does this truncate the 64-bit loff_t file size to 32 bits on 32-bit
architectures?

When reading or writing a famfs file larger than 4GB on a 32-bit system,
i_size_read() will be truncated into the 32-bit size_t i_size. Will this br=
eak
bounds checking and make data past the 32-bit wrapped boundary inaccessible?

> +	size_t count =3D iov_iter_count(ubuf);
> +	size_t max_count;
> +	ssize_t rc;
[ ... ]
> +	/* Avoid unsigned underflow if position is past EOF */
> +	if (iocb->ki_pos >=3D i_size)
> +		max_count =3D 0;
> +	else
> +		max_count =3D i_size - iocb->ki_pos;
> +
> +	if (count > max_count)
> +		iov_iter_truncate(ubuf, max_count);
> +
> +	if (!iov_iter_count(ubuf))
> +		return 0;

[Severity: Medium]
When writing at or past EOF (ki_pos >=3D i_size), famfs_rw_prep() sets max_=
count
to 0 and returns 0. Will famfs_dax_write_iter() bubble this 0 up to the
syscall instead of returning an error code like -ENOSPC or -EFBIG?

Userspace tools often interpret a 0-byte write return as a temporary
condition and retry indefinitely. Could this cause unprivileged applications
to hang in infinite loops?

> +
> +	return rc;
> +}
> +
> +static ssize_t
> +famfs_dax_read_iter(struct kiocb *iocb, struct iov_iter	*to)
> +{
[ ... ]
> +	rc =3D dax_iomap_rw(iocb, to, NULL /*&famfs_iomap_ops */);
> +	inode_unlock_shared(inode);
> +
> +	file_accessed(iocb->ki_filp);

[Severity: Low]
Should file_accessed() only be called if the read successfully transferred
data (rc > 0)?

Unconditionally calling file_accessed() in famfs_dax_read_iter() will update
access times and generate metadata traffic even for failed reads or zero-by=
te
EOF reads.

> +	return rc;
> +}
> +
> +/**
> + * famfs_dax_write_iter()
> + *
> + * We need our own write-iter in order to prevent append
> + *
> + * @iocb:
> + * @from: iterator describing the user memory source for the write
> + */
> +static ssize_t
> +famfs_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
> +{
> +	struct inode *inode =3D iocb->ki_filp->f_mapping->host;
> +	struct famfs_fs_info *fsi =3D inode->i_sb->s_fs_info;
> +	ssize_t rc;
> +
> +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_WRITE))
> +		return -EPERM;
> +
> +	/* dax_iomap_rw() requires i_rwsem held (exclusive for write) */
> +	inode_lock(inode);
> +	rc =3D famfs_rw_prep(iocb, from);

[Severity: High]
Does famfs_dax_write_iter() bypass POSIX append semantics and file size lim=
its
by omitting generic_write_checks() here?

Without generic_write_checks() before preparing the IO, any user process
opening a file with O_APPEND or a restricted RLIMIT_FSIZE can write directly
to the current offset and bypass those limits.

> +	if (rc || !iov_iter_count(from)) {
> +		inode_unlock(inode);
> +		return rc;
> +	}
> +
> +	rc =3D dax_iomap_rw(iocb, from, NULL /*&famfs_iomap_ops*/);

[Severity: High]
Does this bypass setuid/setgid privilege stripping and timestamp updates?

The famfs_dax_write_iter() function modifies the file via dax_iomap_rw()
without calling the required VFS hooks like file_modified() or
file_remove_privs(). Could this omission allow unprivileged users to escala=
te
privileges on SUID/SGID files they have write access to?

> +	inode_unlock(inode);
> +	return rc;
> +}
> +
> +const struct file_operations famfs_file_operations =3D {
> +	.owner             =3D THIS_MODULE,
> +
[ ... ]
> +	/* Generic Operations */
> +	.fsync		   =3D noop_fsync,
> +	.splice_read	   =3D filemap_splice_read,

[Severity: High]
Is filemap_splice_read the correct operation for a DAX filesystem?

Because famfs inodes lack the S_DAX flag, VFS falls back to using
filemap_splice_read. This function queries the page cache and allocates new
pages using ram_aops.read_folio (which resolves to simple_read_folio and ze=
ro
fills them). Will userspace applications using splice() or sendfile() recei=
ve
a stream of zeroes instead of the actual DAX memory contents?

> +	.splice_write	   =3D iter_file_splice_write,
> +	.llseek		   =3D generic_file_llseek,
> +};

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019fc572ca94-ec=
363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com?part=3D5
