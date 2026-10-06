Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CB434D389;
	Tue,  6 Oct 2026 18:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791310257; cv=none; b=EEsJLMt2wywopMMjnp1pkVECHOowCYNW830XRF7VsxaIdemZzvK5D4rq8gbKgCk/zcsAb04FYbSJPDXRHkmtAjYATPXUuA0zjfJDwImoWVJxE58mmhygsOaGPHlvQLKpJ5gESHMTHddmp5WH4n/IysL3IxhFUhdQpn6ZtFI/zaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791310257; c=relaxed/simple;
	bh=ABJLuWVwU6Q16nUgXt4JW+qoKLmDVEgaqvBjqrwIY0E=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=s/VIM+Gu3/NV1faBcI2botYDx2Wk/cyOdfWt4RXGT2a+8BXejRIIVWwH4Nl8+MhUAs1V7GNQboru3ka/WUcYXIsyDHpFHa0LbNWKshZil4LRq8ad+D97HfU+Vv/+7ShAclyHHrFsONFDhes4WooIGrafZECL0BprKhCyzLJNn4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HSJ4DYSs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HSJ4DYSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD051F0089B;
	Tue,  6 Oct 2026 18:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791310255;
	bh=So1AJRy12Dc0ddur5QSG4c+c2ty3Yr5RIrk3pNGxlSA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HSJ4DYSsxtFMFmkRkzGMA5xe9znLfbMaT7xbupYNCHrn2HrllhPHfz0CzkOtk2F2V
	 0YperARaveY4Hk92qe7qn/kr3qtGMRvQ5UfWwU5Goet1FiTA5CvfO3aYV4FbAcgkCH
	 f8d3+AZONJwiCvVuBz2GbFR+SW+lilFajC0iiKwQD4+fBr+uiqfzv9GgeY2qkvPihv
	 JttbtkTBID6zknzaexpKni3xMjK1PGyUokVoj/Gt/bkgtQjjpLrzARih7Cve9ueK6j
	 CkhF9Qxax27PfUGbPs7OJGTdxJJkVkcvrB6//RSN2f2XodshPIO4SrD8ZwA5DiKTze
	 EOUw7/Xi7DgcQ==
Message-ID: <sashiko-outbox-162320@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/9] dax: replace exported dax_dev_get() with
 non-allocating dax_dev_find()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20261006180115.1425232-2-mszeredi@redhat.com>
References: <20261006180115.1425232-1-mszeredi@redhat.com>
 <20261006180115.1425232-2-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 18:10:55 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] dax: partially initialized dax_device returned by dax_dev_find() d=
ue to premature unlock_new_inode()
--

commit 9b2ac5a45a1d5eca0b23e84e793ce64303f44b4e
Author: John Groves <John@Groves.net>

dax: replace exported dax_dev_get() with non-allocating dax_dev_find()

dax_dev_get() uses iget5_locked() which creates a new inode if no
matching one exists, which is dangerous for external callers. This patch
introduces dax_dev_find() to provide lookup-only semantics without allocati=
ng
new inodes, and restricts dax_dev_get() to internal allocation use.

> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 45f84b0eb909a..824e1f6df3780 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c

[ ... ]

> @@ -588,7 +588,41 @@ struct dax_device *dax_dev_get(dev_t devt)
> =20
>  	return dax_dev;
>  }
> -EXPORT_SYMBOL_GPL(dax_dev_get);
> +
> +/**
> + * dax_dev_find - look up an existing dax_device by dev_t
> + * @devt: the device number to find
> + *
> + * Returns a dax_device with an elevated inode reference, or NULL if no
> + * device with the given dev_t exists. Unlike dax_dev_get(), this never
> + * allocates a new inode -- it is safe for external callers that are loo=
king
> + * up devices from user-supplied or metadata-supplied dev_t values.
> + *
> + * Caller must put_dax() the returned device when done.
> + */
> +struct dax_device *dax_dev_find(dev_t devt)
> +{
> +	struct dax_device *dax_dev;
> +	struct inode *inode;
> +	int id;
> +
> +	inode =3D ilookup5(dax_superblock, hash_32(devt + DAXFS_MAGIC, 31),
> +			 dax_test, &devt);
> +	if (!inode)
> +		return NULL;
> +
> +	dax_dev =3D to_dax_dev(inode);
> +	id =3D dax_read_lock();
> +	if (!dax_alive(dax_dev)) {
        ^^^^^^^^^^^^^^^^^^^^^^^

[Severity: High]
Does this introduce a regression where a concurrent external caller of
dax_dev_find() can obtain a partially initialized device?

When a thread calls alloc_dax(), it calls dax_dev_get() to allocate the ino=
de.
Inside dax_dev_get(), the new inode is instantiated, DAXDEV_ALIVE is set, a=
nd
unlock_new_inode() is called:

drivers/dax/super.c:dax_dev_get() {
    ...
    if (inode_state_read_once(inode) & I_NEW) {
        set_bit(DAXDEV_ALIVE, &dax_dev->flags);
        ...
        unlock_new_inode(inode);
    }
    return dax_dev;
}

This clears the I_NEW flag, making the inode fully accessible to concurrent
VFS lookups before dax_dev_get() returns.

If a concurrent thread calls dax_dev_find() at this moment, ilookup5() will
find the unlocked inode and return it. Since DAXDEV_ALIVE is already set,
dax_dev_find() will successfully return the device.

However, the allocating thread has not yet initialized the operations and
private data in alloc_dax():

drivers/dax/super.c:alloc_dax() {
    ...
    dax_dev =3D dax_dev_get(devt);
    if (!dax_dev)
        goto err_dev;

    dax_dev->ops =3D ops;
    dax_dev->private =3D private;
    return dax_dev;
}

Will this sequence allow an external caller to access a dax_device with
uninitialized ops and private pointers?

> +		dax_read_unlock(id);
> +		iput(inode);
> +		return NULL;
> +	}
> +	dax_read_unlock(id);
> +
> +	return dax_dev;
> +}
> +EXPORT_SYMBOL_GPL(dax_dev_find);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006180115.1425=
232-1-mszeredi@redhat.com?part=3D1
