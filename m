Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C0243E4A2;
	Thu,  8 Oct 2026 11:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791459245; cv=none; b=SkcAy4ZQlyw5y2PBSyfPF1YSvsTbAAX0QAd/7BW13tvRHmGVbBeh3hV36VKwroiqT2Vj5kHnhIGjwiQWwFjBpl1ZydxlFCfD8maHede7RoVSr641TDEVstLZNwq1Bxeah9dHGJ6yuc1SHr9xgzqbdlpGqCXfwev6slpMEJtZaiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791459245; c=relaxed/simple;
	bh=QJ+MGi1I/cjR13sHt6lnsN/igJGaarb4saZeK3J39MQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=mzXaMRD7py1olMUG74xdaBB8lOjVW1bVYLEkxFy9iEsyePoG4cCYSJH3ITZFa/jUN1rgjda+eD4oReERPrjpNWzazyOEbGuLErl+jzKBgD6ARsHMsUuaT2mGASQTkQx7bptprUT3uSgNZqgrcnWB92MS+BBF0FnbQLXXFo3FSDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a69sdiRO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a69sdiRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A390D1F000FF;
	Thu,  8 Oct 2026 11:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791459243;
	bh=0isLm5GUJvK/JMnp/8RMeohHQh3vqf1HPCD5yQET1Sw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a69sdiROxn7nOKb9QwaDGKm5E8RdOZFnyvsg0ikoezKsEVx90I9ado1DOVPX1X5vn
	 o9CCrrCmobCwrkqkrK5nUbH+Gv9CkuTfhO/U4TowXm9C78eG4fEoUXZrd/tAsGnGYz
	 HfEhuZGoEc0oDUKwZGM6egKGdg1HUw7h0dBb3LsUYpA9sfFp8GhOPuIs556spA78pG
	 JiFxHPVerzaRINhmCGVX0GXWbu2xJlu0hz892/4ZbvDgKYsMBe1zgan22i0ql12YNF
	 4iuivftyngEaCMIJHNbU0l54PXJxeE0+XWRhh+ypsimk8Wg8mPznld2pg0GXoSDEik
	 heU0mSF0IkLwA==
Message-ID: <sashiko-outbox-164094@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 6/9] fuse: add support for opening dax device as
 backing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261008112004.1899560-7-mszeredi@redhat.com>
References: <20261008112004.1899560-1-mszeredi@redhat.com>
 <20261008112004.1899560-7-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 11:34:03 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] kconfig: FUSE_FS=3Dy and DEV_DAX_FSDEV=3Dm causes undefined referen=
ce to fsdev_dax_from_file
--

commit 0e6c3b76d8791b10c41a202ee1e4d5b108cb9e7d
Author: Miklos Szeredi <mszeredi@redhat.com>

fuse: add support for opening dax device as backing

This commit adds support for opening a dax device as a FUSE passthrough
backing file, enabling S_DAX on inodes when requested. It also updates
the cleanup sequence by moving fuse_backing_put() to fuse_evict_inode()
to avoid sleeping in atomic context.

> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 15132150535a5..9ded41a94fcc6 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
[ ... ]
> +static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_back=
ing *fb, struct file *file)
> +{
> +	struct inode *inode =3D file_inode(file);
> +	struct dax_device *daxdev;
> +	int err;
> +
> +	switch (inode->i_mode & S_IFMT) {
[ ... ]
> +	case S_IFCHR:
> +		if (!fc->passthrough || !fc->backing_id_64)
> +			return -EINVAL;
> +
> +		if (!IS_ENABLED(CONFIG_DEV_DAX_FSDEV))
> +			return -EINVAL;
> +
> +		daxdev =3D fsdev_dax_from_file(file);

[Severity: Low]
If FUSE_FS is built-in (y) and DEV_DAX_FSDEV is compiled as a loadable modu=
le
(m), will IS_ENABLED(CONFIG_DEV_DAX_FSDEV) evaluate to true here? Since this
code is built into vmlinux, wouldn't statically referencing the
fsdev_dax_from_file() symbol from the fsdev_dax.ko loadable module cause an
undefined reference linker error during the kernel build?

Could this use IS_REACHABLE(CONFIG_DEV_DAX_FSDEV) instead to prevent the bu=
ild
failure?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008112004.1899=
560-1-mszeredi@redhat.com?part=3D6
