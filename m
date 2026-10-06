Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2580883F;
	Tue,  6 Oct 2026 18:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791310949; cv=none; b=CjjcsP8UbeGagZiKyGYNCl7GH0SvEWUyHVAQubeSVmGEtBOdsmDDYJIWxG+6XsjTUGEs4DfC8emvTXtPbtde3mY+741nufbXA4a3MTs/yPfr3YGEo0C+uxCqUKQ2Wy2Hl9XFwBxbzDyV3fvSJlswsduewQnSFc39rCiV9ex7oHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791310949; c=relaxed/simple;
	bh=AWRdno5YefYpZf3qNcjCBlrbwhDPXmx98Kw5gDOrILQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=JJXdkp7m9rRkEw8qkQg1Qrb5qapmmt25hiNeCTntFeisNCXCsJKPWYpO58KJJFcAU9mZ+Jj+RDpCZRhwbdKugYmnWjr2as5avlSOs4EbrJMG9SkRzliIo7owh6Xi+uZWyWbWOk+nVn4OuuSs2aqVCnRCuMCKe9juDtEZM8OTYPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LV6+M2np; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LV6+M2np"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6FD1F0089B;
	Tue,  6 Oct 2026 18:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791310948;
	bh=f29rFa1K0MHMNX/aTB9g6+FDvqyNxVA4DeABvmj+Nnw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LV6+M2npUesQWmqYWUrH+R+iaViz2iboVY9kAoc6UrjgQYMV8EP4EGpBRyTsTV95M
	 jbY+foLWGQ/doNNyehN0Q2qw0feDPprmT2N8vitT+IEm9eX9+M4VbEVrsR4tCvd48l
	 rf2KmBW9+P4u7NJHA5xC7/M7/BJY/BO4ZDAXAK8YKADPYd7ugx1X78eZsPvnVaPDA8
	 LtxVuZj82pmDkGt6z87QBdBAoSeHSJTbW8Twc3/tuUnPDTbwet8LHMHIWjHetOBZFv
	 rwOgIeUdv4/zH6F10ldkBE7uTulNZ7xHHIOoZDgaSt8JpC05eO1aKArmKvyrUWDrOQ
	 spZbnaRj1Ep+w==
Message-ID: <sashiko-outbox-162337@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 8/9] fuse: add extent map I/O support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261006180115.1425232-9-mszeredi@redhat.com>
References: <20261006180115.1425232-1-mszeredi@redhat.com>
 <20261006180115.1425232-9-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 18:22:27 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] fuse: fsync skips CPU cache flushing and metadata sync for EXTMAP =
DAX
- [High] fuse: dax_iomap_fault stubs return -EIO instead of valid vm_fault_t
- [Medium] fuse: incorrect -EFBIG error on write past EOF for EXTMAP DAX
--

commit 6c74cf2f1c1750d6fe1df2fa7ef25325ee0d117e
Author: Miklos Szeredi <mszeredi@redhat.com>

fuse: add extent map I/O support

This commit wires up read, write, splice, and mmap operations for
extent-mapped files using the iomap and DAX infrastructure. When a
passthrough file is opened with an EXTMAP backing, I/O is dispatched
to the associated DAX devices.

> diff --git a/fs/fuse/ext_map.c b/fs/fuse/ext_map.c
> index 39d7bb521873c..4f418185c0b79 100644
> --- a/fs/fuse/ext_map.c
> +++ b/fs/fuse/ext_map.c
> @@ -3,6 +3,14 @@
>  #include "fuse_i.h"
>  #include <linux/rbtree.h>
>  #include <linux/pagemap.h>
> +#include <linux/iomap.h>
> +#include <linux/dax.h>
> +
> +#ifndef CONFIG_FS_DAX
> +#define dax_iomap_rw(...) (-EIO)
> +#define dax_iomap_fault(...) (-EIO)
> +#define dax_finish_sync_fault(...) (-EIO)
> +#endif

[Severity: High]
Can returning -EIO here cause memory management fault handler corruption?=20

When CONFIG_FS_DAX is disabled, these macros stub out the DAX fault=20
handlers to return -EIO. However, the return type of the fault handlers=20
is vm_fault_t, which expects a bitmask of VM_FAULT_* flags (such as=20
VM_FAULT_SIGBUS).

Returning a negative integer like -EIO is interpreted as setting almost
all VM_FAULT_x bits simultaneously. This might lead to unpredictable
kernel behavior or infinite fault loops when handled by the core memory
management fault logic.

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
[ ... ]
> +
> +	filemap_invalidate_lock_shared(inode->i_mapping);
> +
> +	ret =3D dax_iomap_fault(vmf, order, &pfn, NULL, &fuse_ext_map_iomap_ops=
);
> +	if (ret & VM_FAULT_NEEDDSYNC)
> +		ret =3D dax_finish_sync_fault(vmf, order, pfn);
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
> +	res =3D generic_write_checks(iocb, from);
> +	if (res <=3D 0)
> +		return res;
> +
> +	fuse_rw_clamp(iocb, from);
> +
> +	if (!iov_iter_count(from))
> +		return -EFBIG;

[Severity: Medium]
Is -EFBIG the correct error code to return for writes past the end of an=20
extent-mapped file?=20

The fuse_rw_clamp() call truncates the iterator if the write starts at or
beyond the current file size. Returning -EFBIG in this condition maps a
standard EOF or out-of-space scenario to a file too large error.=20

POSIX semantics generally expect -ENOSPC or 0 (a short write) when writing
past a non-extensible block device or fixed-size mapping. Returning -EFBIG
might cause applications like cp or dd to fail incorrectly or inadvertently
trigger a SIGXFSZ signal.

> +
> +	res =3D kiocb_modified(iocb);
> +	if (res)
> +		return res;
> +
> +	return dax_iomap_rw(iocb, from, &fuse_ext_map_iomap_ops);
> +}

[ ... ]

> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index b5bef7b9e466e..b5c66f63acd02 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -551,6 +551,10 @@ static int fuse_fsync(struct file *file, loff_t star=
t, loff_t end,
>  	if (fuse_is_bad(inode))
>  		return -EIO;
> =20
> +	/* Skip sync for DAX inodes */
> +	if (IS_DAX(inode) && !fuse_inode_vdax(inode))
> +		return 0;

[Severity: High]
Does this early return bypass CPU cache flushing and metadata sync for=20
EXTMAP DAX files?=20

For FUSE passthrough EXTMAP files, IS_DAX(inode) will be true, but=20
fuse_inode_vdax(inode) evaluates to false since vdax is specific to the=20
traditional virtio-fs DAX window.=20

Returning 0 here completely skips file_write_and_wait_range(), which is
needed to flush CPU caches for DAX memory via dax_writeback_mapping_range().
It also skips sync_inode_metadata(), which syncs metadata updates to the=20
FUSE server. This bypass could cause CPU-cached DAX writes to be lost on a
crash, violating DAX durability guarantees.

> +
>  	inode_lock(inode);
> =20
>  	/*

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006180115.1425=
232-1-mszeredi@redhat.com?part=3D8
