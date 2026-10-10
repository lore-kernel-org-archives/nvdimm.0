Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB852E738B
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 07:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791617709; cv=none; b=p8sGebf2s/Jb2cYba1pLyLJjyrCHqUYHaH3fBLp2VjALvadO1FfZouxf0VdQ0a/sC2Py6Z9CHwzN6g9sqFtC8jnXyK8zix8d7VbDPNMeHuN92tJzX17SRS49t6jG0AMACwGc2Yr4URyA5VUBvBzsXuJrO8zD9ukrDJuVXcZHVjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791617709; c=relaxed/simple;
	bh=Pno1EEiSQ8lrfhRF1JdjUdFyqZQ3m0vP1DxmfcWSYPY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=HxfXphBhVvzbSo8W5p1XbC8H68c9sAyhe8PTB2StBmaBiAGoCQAvolIdwkM7oHwnbfmf27EkmiGKcTHT5/BimZ6Rsry9isjNnqFKDlWZul5pUSZZ/Au0z0O4ZJzqZb1iGRPo6ckHfF/w4hZLYUMha++rPfo5ihW4vtBqO7RSdIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IcS2e/iP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IcS2e/iP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798471F000FF;
	Sat, 10 Oct 2026 07:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791617707;
	bh=nMTPw8PVxX+Gfr6F1XrbfCAcBhYBCrND2Hm3SghssOk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IcS2e/iPN7PHvEF0G7HrnyLOAKXwaB5Fo8lVf4yelhDaA6kZCG9EkzDR3SXGLjm9X
	 EYZ3B14HGgwhNZx5quqtwS26qjMPjgErMBSsnVZywZVPS0BrshUJNIN6AeuG7/mxAc
	 G637OJS3JNqmD6/lcEKBVfTM42rXdV7HeLA/3APm+Jfbx8sgtIuNeuvt9oZUl9RukH
	 9DL/zXkO5vOMSBDJvPypnG832GcOLgqC6DvxIWb1spnxL8aw+G2qzmF3gTOIOuphEG
	 IBud4MuCIo+2Pa6iOFoTaWRYq2doGWMvR9//pGQTdY+nYu5DNLKyzm8Orrvf1vl89c
	 6OXX58ny4iZIA==
Message-ID: <sashiko-outbox-166309@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dax: fix wrong size passed to dax_iomap_direct_access()
 in dax_range_compare_iter()
Reply-To: sashiko-reviews@lists.linux.dev
To: jianyungao89@gmail.com
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20261010071453.6028-1-jianyungao89@gmail.com>
References: <20261010071453.6028-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 07:35:06 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] fsdax: dax_range_compare_iter() memcmp ignores page-in-page offset
- [High] fsdax: out-of-bounds access due to bypassed length check in dax_io=
map_direct_access()
--

commit 05244bba82891c8d959214ace5da854f182c9e20
Author: Jianyun Gao <jianyungao89@gmail.com>

dax: fix wrong size passed to dax_iomap_direct_access() in dax_range_compar=
e_iter()

dax_range_compare_iter() passes ALIGN(pos + len, PAGE_SIZE) as the size
argument to dax_iomap_direct_access(), but this is an absolute file
offset rather than a length. This causes the underlying
dax_direct_access() to request a massively inflated nr_pages via
PHYS_PFN(size), leading to unnecessarily large access ranges and
potential spurious -EHWPOISON from driver badblock scans.

> diff --git a/fs/dax.c b/fs/dax.c
> index 08adeaed2baf1..fb12d0c0dcd49 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -2190,6 +2190,7 @@ static int dax_range_compare_iter(struct iomap_iter=
 *it_src,
>  	const struct iomap *dmap =3D &it_dest->iomap;
>  	loff_t pos1 =3D it_src->pos, pos2 =3D it_dest->pos;
>  	void *saddr, *daddr;
> +	size_t size1, size2;
>  	int id, ret;
> =20
>  	len =3D min(len, min(smap->length, dmap->length));
> @@ -2205,13 +2206,13 @@ static int dax_range_compare_iter(struct iomap_it=
er *it_src,
>  	}
> =20
>  	id =3D dax_read_lock();
> -	ret =3D dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE=
),
> -				      &saddr, NULL);
> +	size1 =3D ALIGN(len + (pos1 & ~PAGE_MASK), PAGE_SIZE);
> +	ret =3D dax_iomap_direct_access(smap, pos1, size1, &saddr, NULL);

[Severity: High]
Does this code risk an out-of-bounds access in the subsequent memcmp() if t=
he
underlying physical DAX memory mapped is shorter than requested?

Looking at dax_iomap_direct_access(), it bypasses the length validation when
the pfnp argument is NULL:

fs/dax.c:dax_iomap_direct_access() {
    ...
	if (!pfnp)
		goto out_check_addr;
	rc =3D -EINVAL;
	if (PFN_PHYS(length) < size)
		goto out;
    ...
}

If the iomap extent crosses a device mapper target boundary, such as on
dm-linear, dm_dax_direct_access() truncates the mapping length and returns
fewer pages than requested.

Because dax_iomap_direct_access() is called here with a NULL pfnp, it skips
the length check and returns success even for short mappings.

Could this regression cause the subsequent memcmp() to read beyond the
physically contiguous mapped memory?

>  	if (ret < 0)
>  		goto out_unlock;
> =20
> -	ret =3D dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE=
),
> -				      &daddr, NULL);
> +	size2 =3D ALIGN(len + (pos2 & ~PAGE_MASK), PAGE_SIZE);
> +	ret =3D dax_iomap_direct_access(dmap, pos2, size2, &daddr, NULL);
>  	if (ret < 0)
>  		goto out_unlock;
> =20

[Severity: High]
Is it possible that the memcmp() that follows compares the wrong file data
because it ignores the page-in-page offset?

The dax_iomap_direct_access() function translates a file offset to a kernel
virtual address, but the returned pointers saddr and daddr are strictly
page-aligned, ignoring any page-in-page offset (pos & ~PAGE_MASK).

When filesystem block sizes are smaller than the architecture's page size,
deduplication requests can be block-aligned but not page-aligned.

If memcmp() is called directly on saddr and daddr without adding the
pos1 & ~PAGE_MASK and pos2 & ~PAGE_MASK offsets:

fs/dax.c:dax_range_compare_iter() {
    ...
	*same =3D !memcmp(saddr, daddr, len);
    ...
}

Will this regression compare memory starting from the page boundary instead=
 of
the actual file offset? Could this lead to FIDEDUPERANGE incorrectly
deduplicating non-identical blocks and causing data corruption?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010071453.6028=
-1-jianyungao89@gmail.com?part=3D1
