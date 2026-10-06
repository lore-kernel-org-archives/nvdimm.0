Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806482DC792;
	Tue,  6 Oct 2026 18:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791310634; cv=none; b=e6DNkGOyZ8zwzNfawIdtu4JLv09bCowurlnJCbh2IrYlhVUzomrMsUm2eKW03vna59f3JhEhqtWFPaY2kBTcoBK2q+Ib5KzRsAyivXJwreAYNGby62BSJV8u19T1cqxlxL7lqCgnTT4DrS9BoANueQijUir9pnUZq5l28wSfAEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791310634; c=relaxed/simple;
	bh=OWC0qgxA+c2c/lAhZLY8Sn9Sp+Qf12ZFgCyh4z+2YVA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KuR+jndHH7w77c5qs0Q5VC4Th2ZS8pavq1YBJoaS3U5IB1+XZDUlFl17j0EhO6F5t1UUsqTdS7Kf8uaNRd7y/BQHiVnMeyszzc4bJPTiVvwINOcvORFXmpdXIkSlpJmvUZWjUXQAa1b7NfSdQwMX1OI+QVCwPHJrWQMnnijP36Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ptf+gfx7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ptf+gfx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411581F0089B;
	Tue,  6 Oct 2026 18:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791310629;
	bh=8HZ3OxrvRecdqerbrS/4vi1DSjydB4qxlWqpViUB8g8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ptf+gfx7lfaftd/IO+jD7KqGcXfh+5D5mnhnJHDAH083/PvSx1GTe8GS6X/fKpDmC
	 7ZIZUFdkVx8P5sVTBiWzYo2yyI3JLp47ZtkcWlIwbymWzaXM1AtbpZw+a3m4vGaIxR
	 sBOIopaLLjUmO5oLKNkkR9Iq1WnE6Ua/n5xx+43/gjAovuSOMf3ZPJN5vPka6JMz31
	 TnnEW5tu4cTcotqGjqFz/ogjp+c84VkYvE0NySzEvpjuY1BOfrZCiucQ84wMtWspTO
	 bBh0eBlDUfyf6trkXKtedO3W/YS1p4PtsEKI/7BUVhRm7r+zO/k644fpygWKXYiIqv
	 JDC0z3qUA+p1Q==
Message-ID: <sashiko-outbox-162326@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 7/9] fuse: add extent map data structure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261006180115.1425232-8-mszeredi@redhat.com>
References: <20261006180115.1425232-1-mszeredi@redhat.com>
 <20261006180115.1425232-8-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 18:17:08 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] fuse: NULL pointer dereference in fuse_notify_map() due to missing=
 backing_id_64 check
- [High] fuse: type confusion and wild pointer dereference in fuse_ext_map_=
is_dax()
- [Medium] fuse: duplicate backing_id insertion due to rhashtable_insert_fa=
st usage
--

commit 7c30614b0de0feab07ac16cfbaac90b3eedab05c
Author: Miklos Szeredi <mszeredi@redhat.com>

fuse: add extent map data structure

Add support for creating and managing extent maps that map file regions to
dax device regions. Introduce FUSE_NOTIFY_BACKING_MAP for populating extent
maps from userspace.

> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 0ed850ddf8cde..b7ebc951dc313 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
[ ... ]
> @@ -84,7 +88,7 @@ static const struct rhashtable_params fuse_backing_prm =
=3D {
>  	.key_len =3D sizeof_field(struct fuse_backing, backing_id),
>  };
> =20
> -static int fuse_backing_add_64(struct fuse_conn *fc, struct fuse_backing=
 *fb)
> +int fuse_backing_add_64(struct fuse_conn *fc, struct fuse_backing *fb)
>  {
>  	return rhashtable_insert_fast(&fc->backing_64_ht, &fb->hash_node, fuse_=
backing_prm);
>  }

[Severity: Medium]
Will this blindly insert duplicate backing IDs into the hash table?

Calling rhashtable_insert_fast() passes NULL as the key to the internal
__rhashtable_insert_fast(), which short-circuits the duplicate comparison
logic. Since the newly added FUSE_NOTIFY_BACKING_MAP accepts user-provided
backing IDs and inserts them here, could an untrusted FUSE server send
multiple requests with the same backing ID and cause inconsistent state or
unbounded memory accumulation?

Should this use rhashtable_lookup_insert_fast() instead to properly check
for uniqueness?

> diff --git a/fs/fuse/ext_map.c b/fs/fuse/ext_map.c
> new file mode 100644
> index 0000000000000..39d7bb521873c
> --- /dev/null
> +++ b/fs/fuse/ext_map.c
[ ... ]
> +bool fuse_ext_map_is_dax(struct fuse_backing *fb)
> +{
> +	struct fuse_iext *fie;
> +
> +	if (WARN_ON(RB_EMPTY_ROOT(&fb->extents)))
> +		return false;
> +
> +	fie =3D rb_entry(fb->extents.rb_node, typeof(*fie), rb);
> +	return fie->backing->type =3D=3D FUSE_BACKING_DAXDEV;
> +}

[Severity: High]
Does this safely handle other backing types passed in via the fb pointer?

The extents field is part of an anonymous union overlaying dax_dev. If this
function is called on a FUSE_BACKING_DAXDEV backing, it will treat the
dax_dev pointer as an rb_root. If dax_dev is non-NULL, RB_EMPTY_ROOT()
returns false, and the code then casts the pointer via rb_entry() and
dereferences it.

Can this cause an out-of-bounds read or a wild pointer dereference? Should
there be a check to ensure fb->type =3D=3D FUSE_BACKING_EXTMAP before attem=
pting
to access fb->extents?

> diff --git a/fs/fuse/notify.c b/fs/fuse/notify.c
> index 93e916a16ac93..7c427f88bbc52 100644
> --- a/fs/fuse/notify.c
> +++ b/fs/fuse/notify.c
[ ... ]
> +static int fuse_notify_map(struct fuse_conn *fc, unsigned int size,
> +			   struct fuse_copy_state *cs)
> +{
> +	struct fuse_notify_backing_map_out outarg;
> +	struct fuse_extent *ext __free(kvfree) =3D NULL;
> +	int err;
[ ... ]
> +	if (outarg.flags & ~FUSE_BACKING_MAP_CREATE)
> +		return -EINVAL;
> +
> +	if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> +		return -EOPNOTSUPP;
> +
> +	ext =3D kvmalloc_objs(*ext, outarg.num_extents);
> +	if (!ext)
> +		return -ENOMEM;
> +
> +	err =3D fuse_copy_one(cs, ext, size);
> +	if (err)
> +		return err;
> +
> +	return fuse_ext_map_populate(fc, &outarg, ext);
> +}

[Severity: High]
Is a check for fc->backing_id_64 missing here before attempting to populate
the extent map?

If the backing_id_64 feature was not negotiated with the FUSE server during
connection initialization, fc->backing_64_ht will remain uninitialized
(zero-filled) because fuse_backing_files_init_64() is never called.

When fuse_ext_map_populate() subsequently calls fuse_backing_add_64(), it
will use rhashtable_insert_fast() on an uninitialized hash table. Could this
result in a guaranteed NULL pointer dereference on ht->tbl, allowing a buggy
or malicious FUSE server to crash the kernel?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006180115.1425=
232-1-mszeredi@redhat.com?part=3D7
