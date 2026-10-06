Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A624B4A43F6;
	Tue,  6 Oct 2026 18:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791310687; cv=none; b=SY7m+FsY/xDNgNnW2bWJ14pYPhq7ygPuH9++ESTWz/6xtm+AcYtf0IfAlDJGEXl3f+bAcx2hgxhDVtTdy6ahoyO2dkycIPVet8j9YLWMiXydfhvCrZMnCJvKAd9LD34Ur7AFjM0ALoutcGbwL51zOvt0+kSu3kRXplyknUzWu1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791310687; c=relaxed/simple;
	bh=++UgkJvNh9Yv9IWhuVR9mt1WFQvfzE9BLAPF9PwtNxc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=WSJ9ytkHyAMaw2ajl9J65kfzPQJhGuAn8b25laojr3sg4YQxLKzxo6zIO5KTq84SKgGhbgbk2+JnlxBCLVyoFCPC1wLVjks+g2h8xSpfedNjtu+xJq1DcC7uskZhAKLjnHMtu89Lnj0zo1quyTns38XZN8eWV8F1GGgwKH8cQm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oRCvP0eU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oRCvP0eU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073821F0089B;
	Tue,  6 Oct 2026 18:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791310685;
	bh=5LHQvJCHbEznKNLqe7zTSY72VLKj3EOYIMwogBHmoCw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oRCvP0eU09U6B6WERHb4w9xDXS1r6BZX8s8hOyAGmFYhregclHw67bTtzj8ZXSjVo
	 P4ljChfhE77tcAPcidQ/zVQTiWN1A8UPe06NpFxbdp2TmZrTKURr+XcB1l7XBz+16M
	 T62H8AsYNZuziXVqpZmdQfIVUQ64iYxgdHAPfNSe49rvjA5Dh5R83wehKT+tYGlv6J
	 Raqfa+xYZr7MIq9TuogCh54e7YWD7maO/yx4F8HJf9FPd6mVfDbiQ+V8tumfMX2Jio
	 r+7AK1PLCmZpQIeHrKoKpnGhvc/GmeL6v7JGBXwhx+4zpdmAkqTSzpP00NEri37r0Q
	 D/1mIUOjelwjA==
Message-ID: <sashiko-outbox-162328@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 6/9] fuse: add support for opening dax device as
 backing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261006180115.1425232-7-mszeredi@redhat.com>
References: <20261006180115.1425232-1-mszeredi@redhat.com>
 <20261006180115.1425232-7-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 18:18:04 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] fuse: FUSE_ATTR_DAX applied to non-regular files causes symlin=
k DoS
- [High] fuse: sleep-in-atomic bug in fuse_backing_free() during RCU inode =
teardown
--

commit 122a624f241dd19a7e4f459c49f52f0a5d738881
Author: Miklos Szeredi <mszeredi@redhat.com>
Subject: fuse: add support for opening dax device as backing

This commit adds support for using a DAX device as a backing file in FUSE
passthrough mode. It introduces a new DAX backing type and marks the inode
with S_DAX if FUSE_ATTR_DAX is set during lookup.

> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index bc40818778dff..0ed850ddf8cde 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
[ ... ]
> @@ -22,9 +23,16 @@ static void fuse_backing_free(struct fuse_backing *fb)
>  {
>  	pr_debug("%s: fb=3D0x%p\n", __func__, fb);
> =20
> -	if (fb->file)
> -		fput(fb->file);
> -	put_cred(fb->cred);
> +	switch (fb->type) {
> +	case FUSE_BACKING_PATH:
> +		path_put(&fb->path);
> +		put_cred(fb->cred);
> +		break;
> +
> +	case FUSE_BACKING_DAXDEV:
> +		fs_put_dax(fb->dax_dev, fb);
> +		break;
> +	}

[Severity: High]
Can path_put() or fs_put_dax() be called from atomic context here?

When the final reference is dropped during inode teardown in
fuse_free_inode(), it executes from the VFS RCU softirq callback
(i_callback).

If fuse_backing_put() is called from that RCU softirq context and drops
the final reference, invoking fuse_backing_free() synchronously, could
the sleeping functions path_put() and fs_put_dax() (which calls iput())
trigger a sleep-in-atomic bug?

>  	kfree_rcu(fb, rcu);
>  }
> =20
[ ... ]
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index b5b51865d59f8..750e092c3971d 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
[ ... ]
> @@ -430,6 +434,11 @@ static void fuse_init_inode(struct inode *inode, str=
uct fuse_attr *attr,
>  	 */
>  	if (!fc->posix_acl)
>  		inode->i_acl =3D inode->i_default_acl =3D ACL_DONT_CACHE;
> +
> +	if ((attr->flags & FUSE_ATTR_DAX) && !fuse_inode_vdax(inode)) {
> +		inode->i_flags |=3D S_DAX;
> +		inode->i_data.a_ops =3D &fuse_dax_aops;
> +	}

[Severity: Critical]
Does this overwrite the address space operations for non-regular files
like symlinks?

If a FUSE server returns FUSE_ATTR_DAX on a symlink lookup, this code
unconditionally sets inode->i_data.a_ops =3D &fuse_dax_aops.

Since fuse_dax_aops does not implement a .read_folio callback, won't
this cause a NULL pointer dereference when a readlink() syscall attempts
to read the symlink (e.g., via fuse_get_link() -> page_get_link_raw() ->
read_mapping_folio())?

Should there be a check for S_ISREG(inode->i_mode) before setting the
DAX address space operations?

>  }
> =20
>  static int fuse_inode_eq(struct inode *inode, void *_nodeidp)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006180115.1425=
232-1-mszeredi@redhat.com?part=3D6
