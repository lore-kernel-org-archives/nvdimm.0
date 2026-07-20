Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF6E391838;
	Mon, 20 Jul 2026 03:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519825; cv=none; b=lNQUkec0nf95eshqVDnQL52xhJNbDNxvYPNn0au/7KlaGd+dXnBHObyxs9Hal+3hiVs2Egcz5kBAaB/oHfef3hky63Y4QMu0tpHSsyAsqNqRPMdMxg9fisKRF8Bz2YRo3Q80DPp+MlMW8W+vk3T2GAmrmE1GXFERDdDbK2LmH1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519825; c=relaxed/simple;
	bh=gUb1RE3R0w7S6C8TpPrz+FSTQjV+viFY95tz0zd1C/k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iPPCTS/sZ7YI/KD4P5cmqU4j5esXtGpy0xaAM/ARZJsrRsjoK88mV5DnRdHcb5uE45XrSMjHw2MOvb0fjgWwvZx+4RlgxBCPbCAeAW0JLyB+VoK7u+cuyMA7I3S9bWfUMdmIxE1P8+JFF2liSz4y2prT+9TycbB3Rqe4qHB+ceU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GhKTF0YM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GhKTF0YM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96F01F000E9;
	Mon, 20 Jul 2026 03:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784519824;
	bh=0oUzMAJKYmlpoHfxjiK+N+cGfjOjJ5XURT1pYrsEWsg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GhKTF0YMV29yOL/VxTs/Qj6FGN3XqZgBZjxuV87QsYPdqvyhGcwHyccl7Q/2N519x
	 NxYaYGm9AJBSfD+J9df/jfEnlXC8aK3rf3W5HaDJ+QS9Ph/qJWs/YFl14PaxQ7M6Ht
	 53aCI7G2HHTsgtuQmeJe1iLYlNAGeVz09B+FdYW0aMW9YaiWnx11Fal3zqC7lO6h0L
	 jipOAyTm+1NPLk7l8V5QlOkDpBFcq2DnIEcRCsg33qM+JhR+R4phGxpMdx0IRULofO
	 qkTFpNkn6ctjOWVsq2QCZG2zY1YYKiody7ejvCfIPazYi02eVq6Su9rU4E95Wc1pyw
	 ePynKBJSGb0RQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V11 6/9] famfs_fuse: Plumb dax iomap and fuse
 read/write/mmap
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <0100019f7da1cf3d-bb04c043-a09f-4925-bf63-eb92452871e5-000000@email.amazonses.com>
References: <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <20260720034616.68834-1-john@jagalactic.com>
 <0100019f7da1cf3d-bb04c043-a09f-4925-bf63-eb92452871e5-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 03:57:03 +0000
Message-Id: <20260720035703.D96F01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] famfs_fuse_write_iter and famfs_fuse_read_iter completely bypa=
ss mandatory VFS locking, security privilege stripping, and POSIX semantics.
- [High] famfs_fuse_mmap fails to set the VM_MIXEDMAP flag, guaranteeing a =
BUG_ON() crash during DAX page faults.
- [High] Explicitly returning -EIO for splice operations on famfs files bre=
aks standard system calls like sendfile() and splice().
- [High] 32-bit architectures suffer from silent data truncation due to the=
 use of size_t and off_t for 64-bit file offsets and sizes.
- [Medium] Concurrent, lockless modification of `meta->error` in `famfs_fil=
e_bad()` creates a data race.
--

--- Patch [6]: [PATCH V11 6/9] famfs_fuse: Plumb dax iomap and fuse read/wr=
ite/mmap ---
commit 26226f89d9106affa50e5f7fc0a4be4656c4531c
Author: John Groves <john@groves.net>

famfs_fuse: Plumb dax iomap and fuse read/write/mmap

This commit adds read, write, and mmap support for famfs files using the
dev_dax_iomap interface. It handles file offset resolution and page faults
via DAX upcalls.

> diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
> index a2a7dd631dc0f..ac56317944d93 100644
> --- a/fs/fuse/famfs.c
> +++ b/fs/fuse/famfs.c

[ ... ]

> +static int
> +famfs_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
> +			loff_t file_offset, off_t len, unsigned int flags)
> +{

[Severity: High]
Does defining the len parameter as off_t truncate the mapping length on 32-=
bit
systems?

[ ... ]

> +const struct vm_operations_struct famfs_file_vm_ops =3D {
> +	.fault		=3D famfs_filemap_fault,
> +	.huge_fault	=3D famfs_filemap_huge_fault,
> +	.map_pages	=3D filemap_map_pages,

[Severity: High]
Is it correct to assign a page-cache-specific mapping function here? Since
DAX mappings bypass the page cache, using filemap_map_pages might lead to
unexpected behavior.

> +	.page_mkwrite	=3D famfs_filemap_mkwrite,
> +	.pfn_mkwrite	=3D famfs_filemap_mkwrite,
> +};

[ ... ]

> +static int
> +famfs_file_bad(struct inode *inode)
> +{
> +	struct fuse_inode *fi =3D get_fuse_inode(inode);
> +	struct famfs_file_meta *meta =3D fi->famfs_meta;
> +	size_t i_size =3D i_size_read(inode);
> +
> +	if (!meta) {
> +		pr_err("%s: un-initialized famfs file\n", __func__);
> +		return -EIO;
> +	}
> +	if (meta->error) {
> +		pr_debug("%s: previously detected metadata errors\n", __func__);
> +		return -EIO;
> +	}
> +	if (i_size !=3D meta->file_size) {
> +		pr_warn("%s: i_size overwritten from %ld to %ld\n",
> +		       __func__, meta->file_size, i_size);
> +		meta->error =3D true;

[Severity: Medium]
Can concurrent I/O operations cause a data race on meta->error? Since read
and write paths can execute without the inode lock, multiple threads might
modify this flag simultaneously.

> +		return -ENXIO;
> +	}

[ ... ]

> +static ssize_t
> +famfs_fuse_rw_prep(struct kiocb *iocb, struct iov_iter *ubuf)
> +{
> +	struct inode *inode =3D iocb->ki_filp->f_mapping->host;
> +	size_t i_size =3D i_size_read(inode);

[Severity: High]
Might reading i_size_read() into a size_t truncate the 64-bit value on 32-b=
it
platforms? This would break I/O bounds checking for files larger than 4GB.
This also applies to the file_size field in the famfs_file_meta structure if
it is similarly defined as size_t.

> +	size_t count =3D iov_iter_count(ubuf);
> +	size_t max_count;
> +	ssize_t rc;

[ ... ]

> +ssize_t
> +famfs_fuse_read_iter(struct kiocb *iocb, struct iov_iter	*to)
> +{
> +	ssize_t rc;
> +
> +	rc =3D famfs_fuse_rw_prep(iocb, to);
> +	if (rc)
> +		return rc;
> +
> +	if (!iov_iter_count(to))
> +		return 0;
> +
> +	rc =3D dax_iomap_rw(iocb, to, &famfs_iomap_ops);

[Severity: Critical]
Does this read path need to acquire inode_lock_shared()? The standard VFS
read paths typically acquire it before calling dax_iomap_rw().

> +
> +	file_accessed(iocb->ki_filp);
> +	return rc;
> +}
> +
> +ssize_t
> +famfs_fuse_write_iter(struct kiocb *iocb, struct iov_iter *from)
> +{
> +	ssize_t rc;
> +
> +	rc =3D famfs_fuse_rw_prep(iocb, from);
> +	if (rc)
> +		return rc;
> +
> +	if (!iov_iter_count(from))
> +		return 0;
> +
> +	return dax_iomap_rw(iocb, from, &famfs_iomap_ops);
> +}

[Severity: Critical]
Does this write path omit mandatory VFS security and integrity checks?
Calling dax_iomap_rw() directly without acquiring inode_lock() bypasses
generic_write_checks() and file_remove_privs(), which could allow
unprivileged modification of setuid/setgid files and bypass O_APPEND
restrictions.

> +int
> +famfs_fuse_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct inode *inode =3D file_inode(file);
> +	ssize_t rc;
> +
> +	rc =3D famfs_file_bad(inode);
> +	if (rc)
> +		return rc;
> +
> +	file_accessed(file);
> +	vma->vm_ops =3D &famfs_file_vm_ops;
> +	vm_flags_set(vma, VM_HUGEPAGE);

[Severity: High]
Could this trigger a kernel panic during DAX page faults? The
vmf_insert_mixed() path expects VM_MIXEDMAP or VM_PFNMAP to be set on the
vma, but VM_MIXEDMAP appears to be omitted here.

> +	return 0;
> +}

[ ... ]

> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index b4e7b6a645870..2435a79cbb4a3 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c

[ ... ]

> @@ -1896,9 +1900,13 @@ static ssize_t fuse_splice_read(struct file *in, l=
off_t *ppos,
>  				unsigned int flags)
>  {
>  	struct fuse_file *ff =3D in->private_data;
> +	struct inode *inode =3D file_inode(in);
> +	struct fuse_inode *fi =3D get_fuse_inode(inode);
> =20
>  	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
> -	if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIRECT_IO))
> +	if (fuse_file_famfs(fi))
> +		return -EIO; /* famfs does not use the page cache... */

[Severity: High]
Will returning -EIO break standard system calls like splice() and sendfile()
for famfs files? Should this fall back to iter_file_splice_read() or
copy_splice_read() instead?

> +	else if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIRECT_I=
O))
>  		return fuse_passthrough_splice_read(in, ppos, pipe, len, flags);
>  	else
>  		return filemap_splice_read(in, ppos, pipe, len, flags);
> @@ -1908,9 +1916,13 @@ static ssize_t fuse_splice_write(struct pipe_inode=
_info *pipe, struct file *out,
>  				 loff_t *ppos, size_t len, unsigned int flags)
>  {
>  	struct fuse_file *ff =3D out->private_data;
> +	struct inode *inode =3D file_inode(out);
> +	struct fuse_inode *fi =3D get_fuse_inode(inode);
> =20
>  	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
> -	if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIRECT_IO))
> +	if (fuse_file_famfs(fi))
> +		return -EIO; /* famfs does not use the page cache... */

[Severity: High]
Does hardcoding -EIO here also break splice writes? Falling back to
iter_file_splice_write() might be required to keep standard system calls
functioning.

> +	else if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIRECT_I=
O))
>  		return fuse_passthrough_splice_write(pipe, out, ppos, len, flags);
>  	else
>  		return iter_file_splice_write(pipe, out, ppos, len, flags);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019f7d9fbe81-6c=
b16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com?part=3D6
