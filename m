Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD324523786;
	Thu,  1 Oct 2026 15:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790868457; cv=none; b=LvL+hpo8k5xj6Gz0nTPGmXHW4C0AkSUfdfphK3ONMoFLOaR/8SxTCT1vQw5xaIsUSUrmd/8jChM+mNdBsRd3zX1kttLWMlkpl8rM0hUVRILuKZa0zXpNLXHIkxegbW8jtS01ZYYiHmZhAiIMo7rGhqCuwBK70RKOSPyhJjRswgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790868457; c=relaxed/simple;
	bh=WCQMdyGahY6yKrEEk7/QhEOOV2nVsOM8xSBIxjCek3Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ptBbKdz0h6KTfZJu5GnwEPwqobtIkk9meuCY7mtDKC7Yj690oCQxwFJX8K7EYbbYpizpOjMxoeO4dRob01BoWdKvGDxkGBtYy4PrK4ykGHgqwpbgJ193D/M62blN09Xrqpoo4t5c7g5zo8lFsYj7UgiihOC8lvkVF1vstHizaP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DbmPh+SH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DbmPh+SH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8189B1F000FF;
	Thu,  1 Oct 2026 15:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790868455;
	bh=qC66zW48Od7Y7Clz7zrL/BXnNcXoNr05+eiWwfsVqCc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DbmPh+SHz09sAtrSYJL+u/prWfF7yV33F5x9/oRgGXEjomH5yZvFVsMfgJ/PxVgaO
	 zluv+OFJN3wsvuIyJI5+aQFzBRNzdLGEZRQXINUih998VG5YqWf81xYsUq8sIU9/x1
	 oeS7hTjS0n+Duj22pxTEPhXhnJQQ1xgUtnxlmvXwdhOfsAxUuYMD5CkwBGWBbzmjUd
	 k7qAMXqlYh8ST1gXHL6FCnFp1XRvo2TQc7perbU5iMFI71NaFtQNFIbV2qxhRKixvy
	 PpR5GBYG0uodGzWFYmOEgSL/D9iMqq62BdLElBYQ8hi5aZzmPpgiWM4uyYQIYyq14X
	 YbD7xAKxOH6pQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 7/8] fuse: add extent map I/O support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261001150935.655979-8-mszeredi@redhat.com>
References: <20261001150935.655979-1-mszeredi@redhat.com>
 <20261001150935.655979-8-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 15:27:35 +0000
Message-Id: <20261001152735.8189B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] fuse: missing inode_lock_shared() in DAX read path causes lockdep =
splats and races
- [High] fuse: fuse_rw_clamp() truncates writes at EOF to 0 bytes, causing =
infinite loops
- [High] fuse: O_APPEND writes bypass fuse_rw_clamp limits due to ordering
- [High] fuse: ABBA deadlock between mmap_lock and i_rwsem in DAX page fault
--

commit 900b63ca4cd5e837e1d2beda0ce7ca37d122ab2d
Author: Miklos Szeredi <mszeredi@redhat.com>
Subject: fuse: add extent map I/O support

Wire up read, write, splice and mmap operations for extent-mapped
files through the iomap/DAX infrastructure.

> diff --git a/fs/fuse/ext_map.c b/fs/fuse/ext_map.c
> index ab01d678d08e5..61cb22e821b60 100644
> --- a/fs/fuse/ext_map.c
> +++ b/fs/fuse/ext_map.c
[ ... ]
> +static vm_fault_t fuse_ext_map_huge_fault(struct vm_fault *vmf, unsigned=
 int order)
> +{
> +	struct inode *inode =3D file_inode(vmf->vma->vm_file);
> +	bool write_fault =3D (vmf->flags & FAULT_FLAG_WRITE) && (vmf->vma->vm_f=
lags & VM_SHARED);
> +	vm_fault_t ret;
> +	unsigned long pfn;
> +
> +	if (WARN_ON_ONCE(!IS_DAX(inode)))
> +		return VM_FAULT_SIGBUS;
> +
> +	if (write_fault) {
> +		sb_start_pagefault(inode->i_sb);
> +		file_update_time(vmf->vma->vm_file);
> +	}
> +
> +	filemap_invalidate_lock_shared(inode->i_mapping);
> +
> +	ret =3D dax_iomap_fault(vmf, order, &pfn, NULL, &fuse_ext_map_iomap_ops=
);
> +	if (ret & VM_FAULT_NEEDDSYNC)
> +		ret =3D dax_finish_sync_fault(vmf, order, pfn);
        ^^^^

[Severity: High]
Can this create an ABBA deadlock between mmap_lock and i_rwsem?

This page fault handler is entered holding the VFS mmap_lock, and then
takes filemap_invalidate_lock_shared(). If the fault requires a data
sync (O_DSYNC), it calls dax_finish_sync_fault() which synchronously
invokes vfs_fsync_range().=20

The filesystem's fsync handler, fuse_fsync(), unconditionally acquires
inode_lock(inode). This creates an mmap_lock -> inode_lock dependency,
which violates the standard kernel lock hierarchy and can deadlock if
another thread holds the inode_lock while taking a page fault.

> +
> +	filemap_invalidate_unlock_shared(inode->i_mapping);
> +
> +	if (write_fault)
> +		sb_end_pagefault(inode->i_sb);
> +
> +	return ret;
> +}
[ ... ]
> +ssize_t fuse_ext_map_write_iter(struct kiocb *iocb, struct iov_iter *fro=
m)
> +{
> +	ssize_t res;
> +
> +	fuse_rw_clamp(iocb, from);
> +
> +	res =3D generic_write_checks(iocb, from);
        ^^^^

[Severity: High]
Can O_APPEND writes bypass the file size limits checked in
fuse_rw_clamp() due to this ordering?

Because fuse_rw_clamp() runs before generic_write_checks(),
kiocb->ki_pos is not yet updated to i_size for O_APPEND writes. Clamping
will evaluate based on the old, smaller position, and
generic_write_checks() will then advance ki_pos to i_size, allowing an
out-of-bounds write via dax_iomap_rw().

[Severity: High]
Also, does fuse_rw_clamp() cause writes at or past EOF to return 0
instead of a standard POSIX error?

When a write starts at or past i_size, fuse_rw_clamp() truncates the
iterator to 0. Then, generic_write_checks() returns 0, which propagates
up to the VFS. This can cause standard utilities (like cp and dd) to
retry indefinitely in an infinite loop instead of receiving -ENOSPC or
-EFBIG.

> +	if (res <=3D 0)
> +		return res;
> +
> +	res =3D kiocb_modified(iocb);
> +	if (res)
> +		return res;
> +
> +	return dax_iomap_rw(iocb, from, &fuse_ext_map_iomap_ops);
> +}

> diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> index e9ab1aea34e27..040817ad76e94 100644
> --- a/fs/fuse/passthrough.c
> +++ b/fs/fuse/passthrough.c
> @@ -48,10 +47,10 @@ ssize_t fuse_passthrough_read_iter(struct kiocb *iocb=
, struct iov_iter *iter)
>  	if (!count)
>  		return 0;
> =20
> -	ret =3D backing_file_read_iter(backing_file, iter, iocb, iocb->ki_flags,
> -				     &ctx);
> +	if (!backing_file)
> +		return fuse_ext_map_read_iter(iocb, iter);
        ^^^^

[Severity: High]
Does this path miss acquiring the inode read lock before calling into
the DAX read operations?

When fuse_ext_map_read_iter() processes the read, it delegates to
dax_iomap_rw() which expects the VFS inode lock to be held for
synchronization against truncates. Skipping
inode_lock_shared(&inode->i_rwsem) here could lead to lockdep splats or
out-of-bounds reads during concurrent mapping changes.

> =20
> -	return ret;
> +	return backing_file_read_iter(backing_file, iter, iocb, iocb->ki_flags,=
 &ctx);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001150935.6559=
79-1-mszeredi@redhat.com?part=3D7
