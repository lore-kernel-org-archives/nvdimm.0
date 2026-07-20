Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7204E394EA7;
	Mon, 20 Jul 2026 04:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784520014; cv=none; b=HV2sImpHOL/JI2QducMWXIYT1tfAncvJ5lRBzRMwi2hQOsSZ0q+rW/HRDIgKSIc4o3BtezGYP+n/we6X+HL0i/vNVnXBU8KmbkfMqOsfGNilacldNwFqvjMFxz/rKtq2ZIoxV1V9wpKM4aNyHzqlmDicjgpPWxOk3A39Sl7xKck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784520014; c=relaxed/simple;
	bh=BLmetHs6vitygE8aeEOf9kDHC90fHh3Y6oBh0kzmxK4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=X+aF3N8na+Ujfwrn9+d7QnULNJsZttKuPxzOjzmYgk/FJCXmRJN64kMUCr8fa+jwdy3BSUsfpvFCrBCrVuNg8JHzW38+hgUEhSO7yaN1UuWaHVepiVZiLPv6qGZTuscLk2isGl48zsRAoG8CU+xjHMfSiEpZIcKa0oZtUfiEN2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nqcGFlkE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nqcGFlkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78B91F000E9;
	Mon, 20 Jul 2026 04:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784520013;
	bh=vuQ8Lpxhzff70kDh8BosSYBk0dXVnqdVIQLKuDIrhLc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nqcGFlkEOQ17mWGgA+2uvEogBH07xJWrm6IHQcGBNcjtZmEc+Dp4XRKCmFTtZmwrl
	 W3EQPHt3UsGyXw4ro3ziu3BEVrsXhOBHrRx2pp7Htx71HlplcgPL9eHwXbN4q8DURT
	 aRACFXzeqZDPPPo950osfYrFU/V3k42OvoOEEUhllj/lfb4/y/atdvTYhGzErqoV2S
	 hGn4yS+EsrEElHWU+ILAlxTlGkYcysc2rmppgQx0eKriqOTkA/WpzHf6PdpC7ixCzP
	 u9xmlLbMqojA9VTgj6GwGq+xKT3i5AzsRISNX3DTnQIOEoTP7s8wS4QRI9jgbEbnUN
	 OxLJWCk2kCuHw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V11 7/9] famfs_fuse: fail I/O on invalid or errored
 daxdevs
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <0100019f7da1faa3-75c84002-18fc-4762-a69c-ef33d15a449d-000000@email.amazonses.com>
References: <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <20260720034626.68851-1-john@jagalactic.com>
 <0100019f7da1faa3-75c84002-18fc-4762-a69c-ef33d15a449d-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 04:00:12 +0000
Message-Id: <20260720040012.E78B91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] Returning -EHWPOISON from iomap_begin leaks the internal error c=
ode to read() and write() syscalls.
- [Medium] Permanent invalidation of the file via `meta->error =3D true` ma=
sks hardware poison errors on subsequent page faults.
- [Low] Data race on shared boolean flags without READ_ONCE() and WRITE_ONC=
E().
--

--- Patch [7]: [PATCH V11 7/9] famfs_fuse: fail I/O on invalid or errored d=
axdevs ---
commit baadfa284b86538249581ed04638cf37b1935608
Author: John Groves <john@groves.net>

famfs_fuse: fail I/O on invalid or errored daxdevs

This commit gates the iomap resolution path on the state of the daxdev
backing each referenced extent. If the daxdev is invalid, has a dax_err,
or reports a memory error, famfs_fileofs_to_daxofs() marks the file with
an error and prevents further access.

> diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
> index ac56317944d93..8d13282e8949f 100644
> --- a/fs/fuse/famfs.c
> +++ b/fs/fuse/famfs.c
[ ... ]
> @@ -589,6 +589,26 @@ famfs_file_init_dax(
> =20
>  static int famfs_file_bad(struct inode *inode);
> =20
> +static int famfs_dax_err(struct famfs_daxdev *dd)
> +{
> +	if (!dd->valid) {

[Severity: Low]
Are these shared boolean flags accessed concurrently without protection?

Hardware memory poison can asynchronously modify the device state flags
(dd->valid, dd->dax_err, dd->error). Should these be protected with
READ_ONCE() to avoid data races and KCSAN warnings?

> +		pr_err("%s: daxdev=3D%s invalid\n",
> +		       __func__, dd->name);
> +		return -EIO;
> +	}
> +	if (dd->dax_err) {
> +		pr_err("%s: daxdev=3D%s dax_err\n",
> +		       __func__, dd->name);
> +		return -EIO;
> +	}
> +	if (dd->error) {
> +		pr_err("%s: daxdev=3D%s memory error\n",
> +		       __func__, dd->name);
> +		return -EHWPOISON;

[Severity: Medium]
Is there a risk of leaking the internal -EHWPOISON error code to read() or
write() syscalls here?

If a userspace process calls read() or write() on a file backed by a
poisoned daxdev, famfs_fuse_read_iter() calls dax_iomap_rw(), which calls
iomap_iter() and subsequently famfs_fuse_iomap_begin().

Returning -EHWPOISON here bypasses the generic DAX error translation
(dax_mem2blk_err) and is returned directly to the syscall. This gives
userspace an unfamiliar error code (-1 with errno =3D 133) instead of
standard POSIX error codes like EIO.

> +	}
> +	return 0;
> +}
> +
>  /**
>   * famfs_fileofs_to_daxofs() - Resolve (file, offset, len) to (daxdev, o=
ffset, len)
>   *
[ ... ]
> @@ -670,6 +691,13 @@ famfs_fileofs_to_daxofs(struct inode *inode, struct =
iomap *iomap,
> =20
>  		dd =3D &fc->dax_devlist->devlist[daxdev_idx];
> =20
> +		rc =3D famfs_dax_err(dd);
> +		if (rc) {
> +			/* Shut down access to this file */
> +			meta->error =3D true;

[Severity: Medium]
Does permanently flagging the file as errored mask hardware poison errors on
subsequent page faults?

When famfs_fileofs_to_daxofs() first encounters a memory error, it returns
-EHWPOISON but permanently sets meta->error =3D true.

On any subsequent fault to the file, famfs_file_bad() evaluates to true,
causing famfs_fileofs_to_daxofs() to branch to err_out which unconditionally
returns -EIO instead of -EHWPOISON.

This causes subsequent page faults on poisoned memory to deliver a generic
SIGBUS (BUS_ADRERR) instead of a hardware memory error SIGBUS
(BUS_MCEERR_AR).

[Severity: Low]
Also, similar to the read side in famfs_dax_err(), should this concurrent
write to meta->error use WRITE_ONCE() to prevent data races?

> +			return rc;
> +		}
> +
>  		iomap->addr    =3D dax_ext_offset + local_offset;
>  		iomap->offset  =3D file_offset;
>  		iomap->length  =3D min_t(loff_t, len, ext_len_remainder);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019f7d9fbe81-6c=
b16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com?part=3D7
