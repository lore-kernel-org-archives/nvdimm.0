Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0AF34F483;
	Sat, 29 Aug 2026 17:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788024628; cv=none; b=eKxUD/rZlHLspcuii/IKDd1jie1NGDGmqb29kC2fZ4jLJkJEm6i0/Pl+A8nwj62M4/sKBxE2A3NrFhmZT3+eK2ahSseYr3AoaBeo8IRZBK0J1AOlbQ6YGzHQXnCvV1aeoyhVg9BVMraLRWxM2vHAVHYHkkCx2M9ugAcqYuqi5x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788024628; c=relaxed/simple;
	bh=cT/6L4Qtl0PR3iu/tRgysnKhBntVIBBPmklGWYYnIbA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=g6H4q5IvxwW2KK5GYTnBDiTvpJQF1SfRduWPF1iI6bOEK8DUquEMAngHTSLv1bWNzU8seOD3qVVhHKlKtFQFR1vcBExaBuQdjMo7G5NeWzICF0QHxsHuOaM/WgY/upm/Qwzc1yQlfS9MhW1qmcvbg492LpLUVmyY7KbMXgKCH6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QzaDr57i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QzaDr57i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D607D1F000E9;
	Sat, 29 Aug 2026 17:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788024627;
	bh=wyYuMk45tdQwau58f23bTDTfJ0JP2buc78Qktz0J9FA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QzaDr57iyDD48+no8tM9p2YclFdGEvYFPMqorLJNbACSEIDIiczX+4tAa5CVXJQaF
	 LBhGeDr6GNmmRAtNCl94ZwVWC+cistqco4WEgFJarc1fn39zSqvkTy4rSTeWI5Hkn3
	 q/wpKIj/nqZANjj5tatJhZ7s8AXQ5xzY96daEWz7Eh/TJ3AdfsLa86YT8fXlpPWY2g
	 aljc9nYsdDYe60lXMhkWXX/fRkF3mAQLxRmM4ATuDhWwKPEFTD0qldLj3jvhYhpBAY
	 iicz1mtOlBw8LZC6pSH47HfeW0kPsNinX+UjwcD4Bq3uLRiWxr4ZEjOQV7FbR3laEh
	 +JXQ0erYWErOw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V14 07/12] famfs: MAP_CREATE ioctl and fmap ingest (ABI
 44)
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <010001a04e81b68e-8f5128b9-249f-49af-be87-024b15eb0bd9-000000@email.amazonses.com>
References: <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com>
 <20260829171148.7467-1-john@jagalactic.com>
 <010001a04e81b68e-8f5128b9-249f-49af-be87-024b15eb0bd9-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 29 Aug 2026 17:30:26 +0000
Message-Id: <20260829173026.D607D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Missing memory barriers when publishing and reading `inode->i_priv=
ate` allows concurrent readers to see uninitialized metadata.
- [Medium] Reserved fields in the UAPI structs are not validated to be zero=
, breaking forward compatibility.
--

commit 01eb70d8c2de27c662f746e15fb2d3e809666490
Author: John Groves <John@Groves.net>

famfs: MAP_CREATE ioctl and fmap ingest (ABI 44)
   =20
Add the famfs file ioctl handler (FAMFSIOC_NOP, FAMFSIOC_MAP_CREATE) and
the KABI-44 self-describing fmap message: the wire ABI in famfs_ioctl.h
(famfs_ioc_fmap_header plus the simple and interleaved extent structs), the
in-core famfs_file_meta, and famfs_file_init_dax(), which copies the
message in, parses both the simple-extent and interleaved (striped) wire
forms into inode->i_private, and sets S_DAX.

> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> index 9c1cd2f674893..f099e0d08673f 100644
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
[ ... ]
> @@ -13,9 +13,377 @@
[ ... ]
> +static int
> +famfs_file_init_dax(struct file *file, void __user *arg)
> +{
> +	struct famfs_ioc_fmap_header fmh;
[ ... ]
> +	if (copy_from_user(&fmh, arg, sizeof(fmh)))
> +		return -EFAULT;
> +
> +	if (fmh.fmap_version !=3D FAMFS_FMAP_VERSION)
> +		return -EINVAL;
> +	if (fmh.fmap_size < sizeof(fmh))
> +		return -EINVAL;

[Severity: Medium]
Are the reserved and reserved1 fields in famfs_ioc_fmap_header validated
to be zero here?=20

If userspace passes uninitialized or garbage data in these fields, the kern=
el
will blindly accept it. This could prevent the kernel from safely assigning
meaning to these fields in the future without breaking backward compatibili=
ty,
since it won't be able to distinguish between older applications passing
garbage and newer applications intentionally using the flags.=20

The reserved fields in famfs_ioc_simple_ext and famfs_ioc_iext also appear
to lack zero-validation.

> +	if (fmh.fmap_size > FAMFS_FMAP_MSG_MAX)
> +		return -EFBIG;
[ ... ]
> +	/* Publish the famfs metadata on inode->i_private */
> +	inode_lock(inode);
> +	if (inode->i_private) {
> +		rc =3D -EEXIST; /* file already has famfs metadata */
> +	} else {
> +		inode->i_private =3D meta;
> +		i_size_write(inode, meta->file_size);

[Severity: High]
Does this assignment to inode->i_private need a release memory barrier?

This plain store publishes the structure without a release barrier, allowing
prior initialization stores to be reordered after it. A concurrent reader
could observe a non-NULL inode->i_private pointer but read uninitialized or
stale metadata fields.

For instance, a concurrent mmap() on the same file calls famfs_file_mmap()
which in turn calls famfs_file_invalid(inode). Because famfs_file_mmap()
does not hold inode_lock, famfs_file_invalid() will execute a plain load
(struct famfs_file_meta *meta =3D inode->i_private;) without an acquire
barrier.=20

If it reads uninitialized data like meta->file_size, it could fail the=20
i_size !=3D meta->file_size check, which permanently sets meta->error =3D t=
rue,
thereby permanently bricking the file mapping.

Should smp_store_release() and smp_load_acquire() be used here to enforce
the required memory ordering?

> +		inode->i_flags |=3D S_DAX;
> +		meta =3D NULL; /* owned by the inode now */
> +		rc =3D 0;
> +	}
> +	inode_unlock(inode);
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/010001a04e801a4e-8e=
b212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com?part=3D7
