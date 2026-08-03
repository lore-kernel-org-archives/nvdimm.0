Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A1346B5;
	Mon,  3 Aug 2026 02:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785725922; cv=none; b=FkBhax4FlLvwbLe2/mMcVdy4BbF6DDBaE8SegrkgwovgeIFpCuufIDAK47vXxNAYw3evZ5tsEYPUnIbC+4WAQYbn0BOFoPUF1x3WhpHcGbFncOSmCrPTETa0VUb6dszbf95/qJWCUloPVbmZvIOZvHkU7F7WRaNNyXWEae+WMbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785725922; c=relaxed/simple;
	bh=tugNx1PaJd2tg61DsKcNP93OkVmOBNo09JW7PBY+VyI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NWzXmfs9Y+QD7VQ+BdsHCkp28ogMAEV4GM+z0XYkxDisI4LcTXhugH1403x69taGffgFNKBRuDJgQzM44ZVKSyALgVWx6dccvRNjVyKmofEVN63Jtm7f+9uIXPWcJiuqa46aLn5C05cw0un4GZ7cD9JKyAQOIlDtvJXtGRKOACk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mevykAmf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mevykAmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72C41F000E9;
	Mon,  3 Aug 2026 02:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785725921;
	bh=scKVvPRAwurITBFZhElF1gE0YrZ852yZDbH7W8DyyeQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mevykAmfSlBYC1nKvP+S2K/NhKb8mKvp31pY+D6+RKZAmrfe0obHhfNz9z5XR6s92
	 JhKA9ZNYt9IBQLE0oc/gB2ggJ/pxYNMXf+03NVQLEOzaAP5Fkdi2dGqw+HM4E8ke9N
	 vXZgkKITLXCZaembpLyARmVo7ZehE2yVMY2kUOo6xDyhpabd/o5Lnsn8KsdZAD2ybr
	 qphAuI8xPUBMpdZ+PL5pzPpFSlWu0Bn3kQheF3s44ksep4eXgZ4h2twuxfetyQ8xym
	 nib7OMR5ee7T1sP6HJagYlr4yAc0ufqzXw2pxlngHpags003+P9HRofZgPq9TJcPpP
	 1WjJmEa/CgN4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V12 11/12] famfs: Report device capacity via statfs so
 df works
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <0100019fc57500f5-06c293c8-393c-44e3-ad42-d4f4de58245d-000000@email.amazonses.com>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803023000.75948-1-john@jagalactic.com>
 <0100019fc57500f5-06c293c8-393c-44e3-ad42-d4f4de58245d-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 02:58:40 +0000
Message-Id: <20260803025840.E72C41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] The `used_capacity` counter is permanently leaked when mapped file=
s are unlinked or their inodes are evicted.
- [High] dax_fsdev_size() accesses the private dev_dax structure without ho=
lding the required dax_read_lock(), leading to a use-after-free race condit=
ion with concurrent device unbinds.
- [High] Missing read memory barrier when locklessly checking `daxdev->vali=
d` allows reading an uninitialized or stale `daxdev->devp` pointer.
- [Low] famfs_file_init_dax() mixes goto-based error handling with scope-ba=
sed cleanup helpers, violating the subsystem rules.
--

--- Patch [11]: [PATCH V12 11/12] famfs: Report device capacity via statfs =
so df works ---
commit 72bb530cad0a65ccec5c1eea93f055e5015f64ec
Author: John Groves <John@Groves.net>

famfs: Report device capacity via statfs so df works

Replace simple_statfs(), which reports zero blocks (so df omits the mount),
with famfs_statfs() reporting real capacity and usage.

Add dax_fsdev_size() in drivers/dax/fsdev.c, returning the size fsdev
caches at probe (dev_dax->cached_size - the sum of the device's ranges,
stable while bound), exported. It lives in fsdev.c because cached_size is
set only by the fsdev driver, and famfs only ever holds fsdev-mode daxdevs
(fs_dax_get() enforces DAXDRV_FSDEV_TYPE); famfs.ko therefore depends on
fsdev_dax.ko.

famfs tracks two byte counters under a new stats_sem:
 - total_capacity: summed in famfs_install_daxdev() from dax_fsdev_size(),
   covering the mount primary and every DAXDEV_OPEN secondary, counted once
   per daxdev (on the valid 0->1 transition).
 - used_capacity: summed in famfs_file_init_dax() from the fmap's mapped
   device bytes (superblock + log + data files).

famfs_statfs() reports total and free (total - used). Free is an
approximation of the userspace allocator's free space (it ignores allocator
gaps and reserved regions), which is adequate for df.

(Side note: I am the maintainer of drivers/dax/fsdev.c)

Signed-off-by: John Groves <john@groves.net>

> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index 188b2526bee45..a5b4b2d794286 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -104,6 +104,25 @@ static size_t fsdev_dax_recovery_write(struct dax_de=
vice *dax_dev, pgoff_t pgoff
>  	return _copy_from_iter_flushcache(addr, bytes, i);
>  }
> =20
> +/**
> + * dax_fsdev_size() - total size in bytes of an fsdev dax device
> + * @dax_dev: the dax device (must be bound to this driver)
> + *
> + * Returns the size cached at probe time (sum of all ranges); it cannot =
change
> + * while the driver is bound. Only valid for fsdev dax devices - callers
> + * ensure that (e.g. fs_dax_get() enforces DAXDRV_FSDEV_TYPE). Returns 0=
 if the
> + * device is not alive.
> + */
> +u64 dax_fsdev_size(struct dax_device *dax_dev)
> +{
> +	struct dev_dax *dev_dax =3D dax_get_private(dax_dev);
> +
> +	if (!dev_dax)
> +		return 0;
> +	return dev_dax->cached_size;
> +}

[Severity: High]
Does dax_get_private() require holding the dax_read_lock() here?

In the DAX subsystem, accessing dev_dax from a dax_device requires holding =
the
SRCU-based dax_read_lock(), because a concurrent driver unbind can call
kill_dax(), which clears DAXDEV_ALIVE, calls synchronize_srcu(&dax_srcu), a=
nd
frees the dev_dax structure.

Since dax_fsdev_size() and its caller famfs_install_daxdev() do not hold
dax_read_lock(), could a concurrent unbind result in dev_dax being freed
before dev_dax->cached_size is dereferenced?

> +EXPORT_SYMBOL_GPL(dax_fsdev_size);
> +
>  static const struct dax_operations dev_dax_ops =3D {
> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> index abf049b32a4b9..5be39d6770899 100644
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
> @@ -280,6 +280,11 @@ famfs_file_init_dax(struct file *file, void __user *=
arg)
>  	}
>  	inode_unlock(inode);
> =20
> +	/* Account the mapped device bytes for statfs (only on success) */
> +	if (!rc) {
> +		scoped_guard(rwsem_write, &fsi->stats_sem)
> +			fsi->used_capacity +=3D extent_total;

[Severity: High]
Is fsi->used_capacity ever decremented when files are unlinked?

If famfs_file_init_dax() increments fsi->used_capacity here, should there b=
e a
matching decrement path when the mapping is torn down and its private metad=
ata
is freed in famfs_evict_inode()?

If FAMFS_OPT_UNLINK is enabled via ioctl, userspace could repeatedly create,
map, and delete files, causing used_capacity to monotonically grow until it
exceeds total_capacity. Would this permanently break the statfs free space
accounting for the mount?

> +	}
>  out:
>  	kvfree(fmap_buf);
>  	if (meta)
>  		famfs_meta_free(meta);

[Severity: Low]
This isn't a bug, but does this code mix goto-based error handling with
scope-based cleanup helpers?

Using the out label for manual cleanup (freeing fmap_buf and meta) while al=
so
using scoped_guard() in the same function violates the documented cleanup
guidelines, which state that functions must not mix goto-based cleanup labe=
ls
and __free()/guard() declarations.

> diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> index 6cbd7d657fd80..3c0d1094d6532 100644
> --- a/fs/famfs/famfs_inode.c
> +++ b/fs/famfs/famfs_inode.c
> @@ -462,6 +493,15 @@ int famfs_install_daxdev(
> =20
>  		wmb(); /* All other fields must be visible before valid */
>  		daxdev->valid =3D 1;
> +		devp =3D daxdev->devp;
> +	}

[Severity: High]
Is there a matching read memory barrier on the consumer side?

Here the producer uses wmb() before setting daxdev->valid =3D 1 to make the=
 new
devp visible.

On the IO/fault path, famfs_daxdev_from_index() calls famfs_dax_err() to
locklessly read dd->valid, and if true, proceeds to read dd->devp:

fs/famfs/famfs_file.c:famfs_dax_err() {
    if (!dd->valid) {
        ...
}

fs/famfs/famfs_file.c:famfs_daxdev_from_index() {
    ...
    *errp =3D 0;
    return dd->devp;
}

If there is no paired read memory barrier (e.g., smp_rmb() or
smp_load_acquire()) on the consumer side, could the CPU reorder the loads?

A concurrent thread might observe valid =3D=3D 1 but still read a stale or =
NULL
value for devp, resulting in a NULL pointer dereference during IO.

> +
> +	/* Freshly installed: add its capacity to the statfs accounting */
> +	if (devp) {
> +		u64 sz =3D dax_fsdev_size(devp);
> +
> +		scoped_guard(rwsem_write, &fsi->stats_sem)
> +			fsi->total_capacity +=3D sz;
>  	}
> =20
>  	return 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019fc572ca94-ec=
363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com?part=3D11
