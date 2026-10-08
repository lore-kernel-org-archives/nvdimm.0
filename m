Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1B446EF65;
	Thu,  8 Oct 2026 11:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791459408; cv=none; b=BQkBei+SQTovsKpO3DFcURQ8pbrM80njVBMDMJ75wOx9gpg2HqBsMZ0MfAXLhLVqC/7w/9oFxlrLz6ant3d6CWx3zzeNZZGI8ui0X0SAUgjN5nHztJDktyBV/C/Afv7UdBUaRVSDdldsmIpT0hdXhykBL2ba+quF2tbDf8nt7Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791459408; c=relaxed/simple;
	bh=4N2AWfVl9eRn/e1GvwowQX1pzVpzbs98yiPgPH+2Z+A=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=l9ohT17uvYMpNOZ5av4asQ4HKNpRRsByMSUPfddXLkX9QJkGMNneSu5ZsxtUuuwjGO2g02lDPf58yXIc2kngd4a9JJ4B4K9n84ogTbsA6OvzrdgvMB35/YuSIKP1yuUA8at69e26yaXkdkIJ3qtlrDOcNZlxQrgh/tLUusitQGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D5qUnoM5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D5qUnoM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B731F000FF;
	Thu,  8 Oct 2026 11:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791459406;
	bh=MZx1zw/H3aKeYewjIWCYkyTeCi5epiDKVO1g2I+SmGE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D5qUnoM5B3FPRVXc4JzAYQFLRsjKwBJdXhN7WgZO7GeT1DG9+YBgK8Ejz7KX5FG6l
	 dR2TT/J+Kj9U1tnAIWzISiMUZBgQEx2BScZgewx3h9bygdADP3VCHRMw5PT1JFryTj
	 Uyw8taGtpyqBk3afABqZa9u+VPNQ9YIqfInsyZDH5kkwptx/iZXCwYYE7IFLhHEPCs
	 RaoDmf2Ouerp/KJm/0dYaXhsOfX4aQcSFnv7Mn73zM2wccKuDNnZYrjdT+lw9/UiMh
	 GLmiI6bOFoIP+ej5AweseHkmSgloTGjWj5Yzw4CHN0VhqJdW97bnWesEr2ctU1wXWP
	 bcIC/riL2sHfw==
Message-ID: <sashiko-outbox-164097@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 8/9] fuse: add extent map I/O support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261008112004.1899560-9-mszeredi@redhat.com>
References: <20261008112004.1899560-1-mszeredi@redhat.com>
 <20261008112004.1899560-9-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 11:36:46 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] fuse: silent data loss on fsync for DAX extent-mapped files
- [High] fuse: ABBA deadlock between pipe_lock and inode lock in splice wri=
te
- [High] fuse: concurrent EXTMAP DAX faults and truncate/punch_hole race du=
e to missing lock
--

commit 5f3e8f02d15211d77c4f619bc19ce42ddb86c547
Author: Miklos Szeredi <mszeredi@redhat.com>

fuse: add extent map I/O support

Wire up read, write, splice and mmap operations for extent-mapped files
through the iomap/DAX infrastructure. When a passthrough file is opened
with an EXTMAP backing, I/O is dispatched to the dax devices referenced
by the extent map.

> diff --git a/fs/fuse/ext_map.c b/fs/fuse/ext_map.c
> index afac5de51c802..744940cbf36e1 100644
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
> +	if (!IS_ENABLED(CONFIG_FS_DAX))
> +		return VM_FAULT_SIGBUS;
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

[Severity: High]
Does this allow concurrent truncate or punch_hole operations to race with p=
age
faults?

The page fault handler acquires filemap_invalidate_lock_shared() here,
expecting writers to hold it exclusively during invalidation. However, writ=
er
paths like fuse_do_setattr() and fuse_file_fallocate() check FUSE_IS_VDAX()
to decide whether to acquire the exclusive filemap_invalidate_lock. For EXT=
MAP
DAX files, FUSE_IS_VDAX() evaluates to false, causing the exclusive lock
acquisition to be skipped. Consequently, page faults are not blocked during
truncate_pagecache() or truncate_pagecache_range().

Can this leave stale DAX entries in the mapping tree, leading to
use-after-free of storage blocks when memory-mapped I/O accesses blocks that
have been freed or punched out?

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
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index b5bef7b9e466e..77d7a54066e47 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -551,6 +551,17 @@ static int fuse_fsync(struct file *file, loff_t star=
t, loff_t end,
>  	if (fuse_is_bad(inode))
>  		return -EIO;
> =20
> +	if (IS_DAX(inode) && !fuse_inode_vdax(inode)) {
> +		/*
> +		 * Note: the DAX fault path calls this via dax_finish_sync_fault()
> +		 * and taking inode lock in that context is prohibited.
> +		 *
> +		 * FIXME: need to flush CPU caches for the DAX memory range
> +		 * FIXME: need to sync metadata to the server
> +		 */
> +		return 0;

[Severity: High]
Can this cause silent data loss on fsync() for DAX extent-mapped files?

When an application calls fsync() on a FUSE DAX extent-mapped file, this
bypasses flushing the CPU caches for the DAX memory range or syncing metada=
ta
to the server, while still returning 0 (success).

Because the operation falsely reports success, applications relying on fsyn=
c()
or MAP_SYNC (via dax_finish_sync_fault()) to ensure data durability will not
take fallback actions. Could this lead to silent data loss on a power failu=
re
or crash?

> +	}
> +
>  	inode_lock(inode);
> =20
>  	/*
> diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> index e9ab1aea34e27..040817ad76e94 100644
> --- a/fs/fuse/passthrough.c
> +++ b/fs/fuse/passthrough.c
[ ... ]
> @@ -74,10 +73,13 @@ ssize_t fuse_passthrough_write_iter(struct kiocb *ioc=
b,
>  	if (!count)
>  		return 0;
> =20
> -	inode_lock(inode);
> +	guard(rwsem_write)(&inode->i_rwsem);
> +
> +	if (!backing_file)
> +		return fuse_ext_map_write_iter(iocb, iter);

[Severity: High]
Does this introduce an ABBA deadlock between pipe_lock and the inode lock?

For normal passthrough, fuse_passthrough_splice_write() acquires the inode
lock first, and then calls backing_file_splice_write(), which ultimately
acquires pipe_lock() via the backing file's splice_write callback.

However, the EXTMAP DAX path added below for splice_write() directly calls
iter_file_splice_write(), which acquires pipe_lock() first. That function t=
hen
invokes fuse_passthrough_write_iter() where the inode lock is acquired here
via guard(rwsem_write).

If a malicious FUSE server provides a normal passthrough backing for one op=
en
and an EXTMAP backing for another open of the same inode, and two threads
perform splice writes using the same pipe and the two different file
descriptors, it results in a literal ABBA deadlock. Even operating on
different inodes would trigger a lockdep lock inversion splat.

> +
>  	ret =3D backing_file_write_iter(backing_file, iter, iocb, iocb->ki_flag=
s,
>  				      &ctx);
> -	inode_unlock(inode);
[ ... ]
> @@ -123,6 +128,9 @@ ssize_t fuse_passthrough_splice_write(struct pipe_ino=
de_info *pipe,
>  	pr_debug("%s: backing_file=3D0x%p, pos=3D%lld, len=3D%zu, flags=3D0x%x\=
n", __func__,
>  		 backing_file, *ppos, len, flags);
> =20
> +	if (!backing_file)
> +		return iter_file_splice_write(pipe, out, ppos, len, flags);
> +
>  	inode_lock(inode);
>  	init_sync_kiocb(&iocb, out);
>  	iocb.ki_pos =3D *ppos;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008112004.1899=
560-1-mszeredi@redhat.com?part=3D8
