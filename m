Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55EA4A3878;
	Tue,  6 Oct 2026 18:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791310819; cv=none; b=TQr8eBTdcAj7FeiMNoUlKtj0E/MaJNQhtTAuWilmTQ7DjFClz786PDqzl1jYyQjVsy0AFGHp6x6gJLTTOzE6DfcDiRoNB1M14Wkf6XR/PlscUovZD0rp5b8cLd1aJRkgJoiZeF0PE4UdMauMBy3MofuHBMoW58bCYsFy+tGrP/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791310819; c=relaxed/simple;
	bh=SspdtcoqWI3NKmmTIMWku/qfyzdQHG60UrdThvBunz0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=fy7Axf2KudLPb/Jzn+qxhjFA37rvWYQWEFMdb3RYaKzOCYLn4ypmODwMRVn/3iSYYW6U9Pln3tp45VcGPC99Bq6d2I5wbmlbgvm6xS42a/sicHtgj/ajNLAUz+eEtsMPBEEW+MXYRVkDF7bmax+IcuY65zdRUzclrbkHJcqh6PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PDcdQ5+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PDcdQ5+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5F61F0089B;
	Tue,  6 Oct 2026 18:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791310818;
	bh=Rr8Il5jOZrjyRbAuxYaGeqQz6WyfekgtnNBXygN6DDo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PDcdQ5+y1T2MDhA8l2Gm3WPFoDE8ZOMmdstMXEhsDcIbkehn3VEFmVNWMlEA4q/wy
	 Frw/jox/2BH9r2nmJYtg6mSomjk1qwNmUl/HL/2zaFT3B7rdFjWLgqb+BgG4DGTl6u
	 HkkSJI8C8uXImxNcAZ5BtQ4q6EnJ5sjw/O5jNcRp1ZADaW7m+v3gvo6+dHzmDpWeE3
	 Z22SB91c8LTIBgcaH/6s6P4jnAT210QQ9MXEPc7BlHCzS4Yp7O8NP8CjFTAkGc7Rzy
	 +Y0ZDA0P5EyapkxcX0eI+gA1yO5u7S2KeSIQGnkcV0qzl558erDI+yfTRLiW+TvhLT
	 LbBdj93dmX4Wg==
Message-ID: <sashiko-outbox-162331@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/9] fuse: support 64 bit, server allocated backing
 ID
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261006180115.1425232-5-mszeredi@redhat.com>
References: <20261006180115.1425232-1-mszeredi@redhat.com>
 <20261006180115.1425232-5-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 18:20:17 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] fuse: Uninitialized rhashtable destruction on failed init
- [High] fuse: TOCTOU race between fuse_backing_close and process_init_reply
- [Medium] fuse: rhashtable_insert_fast allows duplicate backing_id
--

commit 90eba0277f715071875b550790d8bf829971f8b3
Author: Miklos Szeredi <mszeredi@redhat.com>

fuse: support 64 bit, server allocated backing ID

This commit adds support for server-allocated 64-bit backing IDs alongside
the existing kernel-allocated 32-bit IDs. It introduces a new ioctl to
create these backing IDs and handles their removal.

> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 433fa3098d71f..bc40818778dff 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
[ ... ]
> +static const struct rhashtable_params fuse_backing_prm =3D {
> +	.head_offset =3D offsetof(struct fuse_backing, hash_node),
> +	.key_offset =3D offsetof(struct fuse_backing, backing_id),
> +	.key_len =3D sizeof_field(struct fuse_backing, backing_id),
> +};
> =20
> +static int fuse_backing_add_64(struct fuse_conn *fc, struct fuse_backing=
 *fb)
> +{
> +	return rhashtable_insert_fast(&fc->backing_64_ht, &fb->hash_node, fuse_=
backing_prm);
>  }

[Severity: Medium]
Does this code allow duplicate backing_id values?

If a FUSE daemon provides an already-existing backing_id,
rhashtable_insert_fast() will insert the new object instead of rejecting
it with -EEXIST.

Should this use rhashtable_lookup_insert_fast() instead to safely enforce
uniqueness?

[ ... ]
>  int fuse_backing_close(struct fuse_conn *fc, int backing_id)
>  {
>  	struct fuse_backing *fb =3D NULL;
>  	int err;
> =20
>  	pr_debug("%s: backing_id=3D%d\n", __func__, backing_id);
> =20
> +	if (fc->backing_id_64)
> +		return -EINVAL;
> +

[Severity: High]
Can this TOCTOU race lead to memory corruption? Since fc->backing_id_64 is
read here outside of fc->lock, it can be observed as false concurrently with
process_init_reply() setting it to true:

CPU1 (fuse_dev_ioctl_backing_close):
    if (fc->backing_id_64) // reads false
        ...
    fuse_backing_id_remove()
        spin_lock(&fc->lock);
        idr_remove(&fc->backing_files_map, id);

CPU2 (process_init_reply):
    scoped_guard(spinlock, &fc->lock) {
        fc->backing_id_64 =3D true;
    }
    if (ok)
        fuse_backing_files_init_64(fc); // calls rhashtable_init()

Because fuse_backing_close() proceeds, it calls idr_remove() on the union
concurrently with rhashtable_init() in CPU2, corrupting the shared memory.

>  	/* TODO: relax CAP_SYS_ADMIN once backing files are visible to lsof */
>  	err =3D -EPERM;
>  	if (!fc->passthrough || !capable(CAP_SYS_ADMIN))
[ ... ]
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index cbb10e19e7e86..b5b51865d59f8 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
[ ... ]
>  			if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH) &&
> -			    (flags & FUSE_PASSTHROUGH) &&
> +			    (flags & (FUSE_PASSTHROUGH | FUSE_PASSTHROUGH_V2)) &&
>  			    arg->max_stack_depth > 0 &&
>  			    arg->max_stack_depth <=3D FILESYSTEM_MAX_STACK_DEPTH &&
>  			    !(flags & FUSE_WRITEBACK_CACHE))  {
>  				fc->passthrough =3D 1;
>  				fc->max_stack_depth =3D arg->max_stack_depth;
>  				fm->sb->s_stack_depth =3D arg->max_stack_depth;
> +				if (flags & FUSE_PASSTHROUGH_V2) {
> +					/* Prevent race with fuse_backing_open() */
> +					scoped_guard(spinlock, &fc->lock) {
> +						if (fc->backing_id_32)
> +							ok =3D false;
> +						else
> +							fc->backing_id_64 =3D true;
> +					}
> +					if (ok)
> +						fuse_backing_files_init_64(fc);
> +				}

[Severity: High]
Does this unconditionally set fc->backing_id_64 =3D true but skip initializ=
ation
if ok is false?

If an earlier validation check sets ok =3D false, this code still sets
fc->backing_id_64 =3D true but skips calling fuse_backing_files_init_64(fc).

When the FUSE connection is later torn down, fuse_backing_files_free() will
see fc->backing_id_64 =3D=3D true and attempt to call rhashtable_free_and_d=
estroy()
on an uninitialized rhashtable, causing a kernel crash.

>  			}
>  			if (flags & FUSE_NO_EXPORT_SUPPORT)
>  				fm->sb->s_export_op =3D &fuse_export_fid_operations;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006180115.1425=
232-1-mszeredi@redhat.com?part=3D4
