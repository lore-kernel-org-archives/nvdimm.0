Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1B326F2BE;
	Mon,  3 Aug 2026 02:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785725183; cv=none; b=qEH3bmo7JMnX7k4QVjnFwkce9NNpjFL3H5VgaU0Pg9iJ6ekpc3eGpnLwiFqscqvlVB/G4vGEVPj8WgWtIsw8i8ht/qzcx6HiPeaCUxr7l0wotWkS9G3fpWvQND8QtiDCQ0QEaDCPMLPaKgvOSQi9S+70j/Xm3PlF3OFNRYTGZlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785725183; c=relaxed/simple;
	bh=7VMrXvYOxH4HOgeXbGzxGivG/j33jhExJgcjTP/YIrU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J5J69WxoX9XiJo1Ww9iM+WtwXp+LSuUpaj7zD7zW/5OSrSAHR+EinJazyqS6qJMO/alKBTFfS/dl+63WFssxbgSWm/AkOmL/pjA/ZbomW+VQi9qeQwSj2to1HzGijNsx2ek1JprkNzCGFajGaTG3+CjVvYwiI9hxSANxm52VXMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nDr8p4KA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nDr8p4KA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59061F000E9;
	Mon,  3 Aug 2026 02:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785725182;
	bh=WOWQGfOmFsEbh8JGXJwhusFRJBrjqvD02BOl+hj3j6w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nDr8p4KAudBeXMga7IezjKTJ/turwfwvBiaEnM5eUugGcm49CnH4xeuq0rEsMJGpI
	 1ASH0GB32a9SyLpeEblZQYdBYgcaftiwPj+V+HxM2Qe7/QxR7WyH1vin6dp/850klH
	 TQ37w3NCLM8SfEJxPt3tXQsaZJUtYOZyGq3DikAqbvrTgjSLzePJetcT5Rp39EuC+h
	 M+2E6bPxz7mrXYNLyXfQdw6SgVOyw0b9mgO6xrqTtIPvlLH5OQjZWPvtri4RMMJkIo
	 PmqWrT0takg+a15wToBtQ/RP1iLKqlbSV8lPsw2TcRzYSqL9kf10Iw3bZovH2+Onr+
	 Gw/6InEvUs9CQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V12 06/12] famfs: Introduce mmap and VM fault handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <0100019fc5743aef-39284cf3-b235-4a69-832f-c51b2198e8da-000000@email.amazonses.com>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022909.75856-1-john@jagalactic.com>
 <0100019fc5743aef-39284cf3-b235-4a69-832f-c51b2198e8da-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 02:46:21 +0000
Message-Id: <20260803024621.C59061F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [Medium] Hardcoded NULL iomap_ops passed to DAX functions will cause a ke=
rnel panic
- [Medium] Missing file_modified() call allows bypassing security privilege=
s on write
- [Medium] Missing generic_write_sync() silently breaks DAX synchronous wri=
tes
- [Medium] Missing FOP_MMAP_SYNC flag prevents MAP_SYNC usage
- [Medium] mprotect() can bypass the FAMFS_OPT_WRITE gate to gain writable =
mappings
- [Medium] Missing lock serialization between DAX page faults and file trun=
cation
- [Low] Setting .map_pages to filemap_map_pages is invalid for DAX mappings
--

--- Patch [6]: [PATCH V12 06/12] famfs: Introduce mmap and VM fault handlin=
g ---
commit a41970b8d49174c2162aaa9777d2fc2abc414431
Author: John Groves <john@groves.net>

famfs: Introduce mmap and VM fault handling

This commit adds vm_operations, famfs_mmap(), and fault handlers to the
famfs filesystem. It sets up the groundwork for memory mapping DAX files,
though it is still missing iomap_ops and mapping resolution.

> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> index e192b573c51f7..678f2035fd5fa 100644
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
> @@ -16,6 +16,75 @@
> =20
>  #include "famfs_internal.h"
> =20
> +/*********************************************************************
> + * vm_operations
> + */
> +static vm_fault_t
> +__famfs_filemap_fault(struct vm_fault *vmf, unsigned int order,
> +		      bool write_fault)
> +{
> +	struct inode *inode =3D file_inode(vmf->vma->vm_file);
> +	struct super_block *sb =3D inode->i_sb;
> +	struct famfs_fs_info *fsi =3D sb->s_fs_info;
> +	vm_fault_t ret;
> +	unsigned long pfn;
> +
> +	if (fsi->deverror)
> +		return VM_FAULT_SIGBUS;
> +
> +	if (!IS_DAX(file_inode(vmf->vma->vm_file))) {
> +		pr_err("%s: file not marked IS_DAX!!\n", __func__);
> +		return VM_FAULT_SIGBUS;
> +	}
> +
> +	if (write_fault) {
> +		sb_start_pagefault(inode->i_sb);
> +		file_update_time(vmf->vma->vm_file);
> +	}
> +
> +	ret =3D dax_iomap_fault(vmf, order, &pfn, NULL, NULL /*&famfs_iomap_ops=
 */);

[Severity: Medium]
Will this hardcoded NULL pointer for the iomap_ops argument cause a kernel
panic? The core DAX subsystem unconditionally dereferences the ops pointer
(for example, by calling ops->iomap_begin()). This also appears to happen
in famfs_dax_read_iter() and famfs_dax_write_iter() when calling
dax_iomap_rw().

[Severity: Medium]
Is there missing lock serialization between DAX page faults and file
truncation here? Calling the DAX page fault handler without holding an
internal filesystem lock (like i_mmap_sem) might allow concurrent truncation
and page faults to race, mapping DAX pages out-of-bounds or into truncated
regions.

> +	if (ret & VM_FAULT_NEEDDSYNC)
> +		ret =3D dax_finish_sync_fault(vmf, order, pfn);
> +
> +	if (write_fault)
> +		sb_end_pagefault(inode->i_sb);
> +
> +	return ret;
> +}
> +
[ ... ]
> +const struct vm_operations_struct famfs_file_vm_ops =3D {
> +	.fault		=3D famfs_filemap_fault,
> +	.huge_fault	=3D famfs_filemap_huge_fault,
> +	.map_pages	=3D filemap_map_pages,

[Severity: Low]
Is it valid to assign filemap_map_pages to a DAX filesystem?
filemap_map_pages is designed to map standard page cache folios, but DAX
filesystems use value entries in the xarray. Since modern kernels safely
skip these via xa_is_value(), iterating the xarray to map nothing wastes
CPU cycles and appears to be an architectural violation.

> +	.page_mkwrite	=3D famfs_filemap_mkwrite,
> +	.pfn_mkwrite	=3D famfs_filemap_mkwrite,
> +};
> +
>  /*********************************************************************
>   * file_operations
>   */
> @@ -117,6 +186,36 @@ famfs_dax_write_iter(struct kiocb *iocb, struct iov_=
iter *from)

[Severity: Medium]
Does the I/O performed in famfs_dax_write_iter() miss a preceding call to
file_modified()? If so, when an unprivileged user writes to a file, the
setuid and setgid bits are not stripped, and the mtime/ctime timestamps
are not updated, violating POSIX security and semantics.

[Severity: Medium]
Does famfs_dax_write_iter() return the result of the write without calling
generic_write_sync() to perform the necessary cache flushes?
Without this, data written with synchronous flags (like O_SYNC or O_DSYNC)
will not be flushed from the CPU cache to persistent media, leading to
silent data loss upon power failure despite user requests for persistence.

>  	return rc;
>  }
> =20
> +static int
> +famfs_file_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct inode *inode =3D file_inode(file);
> +	struct super_block *sb =3D inode->i_sb;
> +	struct famfs_fs_info *fsi =3D sb->s_fs_info;
> +	ssize_t rc;
> +
> +	if (fsi->deverror)
> +		return -ENODEV;
> +
> +	/*
> +	 * Gate shared-writable mappings on FAMFS_OPT_WRITE. This is best
> +	 * effort: clearing the bit blocks new writable mappings and write(),
> +	 * but does not revoke mappings that already exist.
> +	 */
> +	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE) &&
> +	    !famfs_opt_enabled(fsi, FAMFS_OPT_WRITE))

[Severity: Medium]
Does this missing check for VM_MAYWRITE leave the VMA vulnerable to mprotect
upgrades?

If a user maps the file with PROT_READ when FAMFS_OPT_WRITE is disabled,
they could later bypass the access control and obtain a writable mapping
by calling mprotect() to PROT_WRITE.

> +		return -EPERM;
> +
> +	rc =3D famfs_file_invalid(inode);
> +	if (rc)
> +		return (int)rc;
> +
> +	file_accessed(file);
> +	vma->vm_ops =3D &famfs_file_vm_ops;
> +	vm_flags_set(vma, VM_HUGEPAGE);
> +	return 0;
> +}
> +
>  const struct file_operations famfs_file_operations =3D {
>  	.owner             =3D THIS_MODULE,
> =20
> @@ -124,7 +223,7 @@ const struct file_operations famfs_file_operations =
=3D {
>  	.write_iter	   =3D famfs_dax_write_iter,
>  	.read_iter	   =3D famfs_dax_read_iter,
>  	.unlocked_ioctl    =3D NULL /*famfs_file_ioctl*/,
> -	.mmap		   =3D NULL /* famfs_file_mmap */,
> +	.mmap		   =3D famfs_file_mmap,

[Severity: Medium]
Does the file operations structure lack the required .fop_flags =3D
FOP_MMAP_SYNC?

Without this flag, the VFS will reject mmap() requests that include
MAP_SYNC | MAP_SHARED_VALIDATE with -EOPNOTSUPP, breaking the core DAX
use-case of userspace flushing without fsync.

> =20
>  	/* Force PMD alignment for mmap */
>  	.get_unmapped_area =3D thp_get_unmapped_area,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019fc572ca94-ec=
363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com?part=3D6
