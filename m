Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24C852D2BB;
	Thu,  1 Oct 2026 15:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790868287; cv=none; b=naiun62LJe6XipXh8f7dY+SIkk3qehdyMGcafblYy9Z7PVQVHd32Po01wA6xqNGrFGHtZZpuZzaUyD4oUWHhAfkNaYNct52CrssPc68/X+ER07c2YpMKeOWbgh2jAfXWZYy7JJyO925E6YIR9Bhe5LhPuiWN5aKKD3AnvsJIdjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790868287; c=relaxed/simple;
	bh=T3A6DiVTK+d1UO+hhaAGjYtmW+WA3njvWThlDxn8JQ0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VShKUuYR6S/LJTPHSVsFN1LuxwqdBHZzjf27HBCDutQeZc6HZuXz+m1LJj9S0RwB4J2zF7vZ1RRGq1hEF4wBgTtW6djNfSCBXlkYbpURH0VJdamJ6QkmwZnlt+uulRfksabt5KNEI9h+p4HSyI2OEvWxbQSqD3r2grtGNDHROTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kq44/qtU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kq44/qtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F521F000FF;
	Thu,  1 Oct 2026 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790868286;
	bh=PqdObrnXiUApGAveeLfS9Fg6EdvcgjQqoGxrlhe3EHQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kq44/qtU2NW/vnXz92+X/rPEgkHBqzah8+9BD96xoRRgDzYP8saYig6Kowpz0553X
	 VB6XlKuc2zb7yZrGY89cnvBsLzws5pt5Nvu9uDn+bbSK/qHFXYWvB/noeChl8vtWC0
	 XvEPTzzujNZsIMgiBtUm7UdXHe58MIMaryjZLqMdOkqjU6v7h/N//jj2knKF26aoYh
	 ZJ6jgJHjjDZ9vow9RkZBoRbeXwps+cvcVnIAZywHaDUJ+AfsEgDmEP4ORpTNkcqQv7
	 my8NRmWHQ8ATvXOgQaW+ksL4QW2p8omXBbrlL0uj40kuwu0xHSHkBSEXhgXSPQO8GT
	 acs4sF/ZUeI4g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/8] fuse: add extent map data structure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20261001150935.655979-7-mszeredi@redhat.com>
References: <20261001150935.655979-1-mszeredi@redhat.com>
 <20261001150935.655979-7-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 15:24:45 +0000
Message-Id: <20261001152446.22F521F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] fuse: sleep in RCU read-side critical section during backing files=
 cleanup
- [Medium] fuse: missing overflow validation on ext->addr and ext->length
--

commit 791e33c26af3a517c133a125042b17d8f5ff57ec
Author: Miklos Szeredi <mszeredi@redhat.com>

fuse: add extent map data structure

Add support for creating and managing extent maps that map file regions to
dax device regions. Introduce FUSE_NOTIFY_BACKING_MAP for populating extent
maps from userspace.

> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index c852f04989619..e954391d696d0 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
[ ... ]
> @@ -306,12 +310,36 @@ static void fuse_backing_rht_free(void *p, void *da=
ta)
> =20
>  void fuse_backing_files_free(struct fuse_conn *fc)
>  {
[ ... ]
> +	/*
> +	 * extents are referencing other backings, put these refs before
> +	 * destroying the backings themselves
> +	 */
> +	rhashtable_walk_enter(&fc->backing_64_ht, &iter);
> +	rhashtable_walk_start(&iter);
> +	while ((fb =3D rhashtable_walk_next(&iter))) {
> +		if (IS_ERR(fb)) {
> +			if (PTR_ERR(fb) =3D=3D -EAGAIN)
> +				continue;
> +			break;
> +		}
> +		if (fb->type =3D=3D FUSE_BACKING_EXTMAP) {
> +			fuse_ext_map_destroy(&fb->extents);

[Severity: High]
Does this code sleep in an RCU read-side critical section?

rhashtable_walk_start() explicitly acquires the RCU read lock.
When this code drops the final reference to the underlying DAXDEV backing,
the call chain is:

fuse_ext_map_destroy()
  fuse_backing_put()
    fuse_backing_free()
      fs_put_dax()
        iput()

Since iput() can sleep, it appears this could trigger 'scheduling while
atomic' panics or lockdep warnings when unmounting a FUSE passthrough
connection.

> +			fb->extents.rb_node =3D NULL;
> +		}
> +	}
> +	rhashtable_walk_stop(&iter);
> +	rhashtable_walk_exit(&iter);
> +
> +	rhashtable_free_and_destroy(&fc->backing_64_ht, fuse_backing_rht_free, =
NULL);
>  }

> diff --git a/fs/fuse/ext_map.c b/fs/fuse/ext_map.c
> new file mode 100644
> index 0000000000000..ab01d678d08e5
> --- /dev/null
> +++ b/fs/fuse/ext_map.c
[ ... ]
> +static int fuse_add_extent(struct fuse_conn *fc, struct rb_root *extents,
> +			   struct fuse_extent *ext)
> +{
> +	struct fuse_iext *new_fie __free(kfree) =3D kzalloc_obj(*new_fie);
> +	struct rb_node *parent =3D NULL, **link =3D &extents->rb_node;
> +	loff_t end;
[ ... ]
> +	if (overflows_type(ext->offset, loff_t) ||
> +	    check_add_overflow(ext->offset, ext->length, &end))
> +		return fuse_EIO("offset overflow");
> +
> +	new_fie->start =3D ext->offset;
> +	new_fie->end =3D end;
> +	new_fie->backing_offset =3D ext->addr;

[Severity: Medium]
Is it possible for the physical address calculation to wrap around?

The bounds check above validates ext->offset, but appears to omit checking
ext->addr + ext->length for overflow.

Could a user-space process supplying an ext->addr near U64_MAX cause an
integer overflow on the physical address range calculation, resulting in a
non-contiguous backing mapping?

> +
> +	while (*link) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001150935.6559=
79-1-mszeredi@redhat.com?part=3D6
