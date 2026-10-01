Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70D851AEF3;
	Thu,  1 Oct 2026 15:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867926; cv=none; b=d/ofSRTvg2NeFwJWXqNZcv1hBgbyFgYmtL85i/SdiA68wyDhQr9bzw6gaMA2UZDNkkwwj2rYNP+4izc0uD5abkUWJbLDKOCNirvZjJ+ovZOfdOyMAhDe0nkJkXmQJ/H18mHfrNKOIP3C5Gu+c+u1bO6GzsXQKYbTorbMukMe4ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867926; c=relaxed/simple;
	bh=XGhU93g2MMl9Zm9Nhy8VpKFmRLHKr8AqjEryR7kt1+8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=K3wPzQN70TaDETfQK1OlUGy9qpUVyzDmi7+QS7IeMAGyCL/GxYZ224yM4Vlt3pBE14icb4OEqh/UmhZaDtm2/WjmNE5/hqnfd916KWMI0ZJkKoJFFyvLahPQA9zntoMk7wqWuTOBvoYb8qSPdJ2UPRy2Sq/naapc/Te5ny9Df1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+KvvySR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+KvvySR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3511F000FF;
	Thu,  1 Oct 2026 15:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790867925;
	bh=GMjjcdeHqShFZdoMlXvb1rZp2mlJmg9q/Cr0vfM/X6w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W+KvvySRT7fhGG1w1//YKS6afjAV4leAjgqH6aEY6O9T0D/M7gvusmLZkXbujYkGY
	 NKUycKf2dFCo05o3H1mTM3gj3vBdqMTlwqlsHGQGCMZhqWAS6msOt/LruKBMPio36y
	 Fw4KRh+43WVCAUQGyJ2RsXAxibWC8A+i6XssuAIP84ndXeSFNq54Am7MntNffpr7Jl
	 UQJxEFXjSEJLEArCrABJJ6B1YKIF6PAByia4BE/lnpzpnuNVJtDpmNvL3OVttGEpDc
	 WbRGaMADTk898d51Sw+bgJw6EbmvLux7ZtOnHchguA5v7+TFto/GolVy36kYtA/cyD
	 kwWSoVRL0k3TA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/8] fuse: add helpers for EIO return value with
 kernel message
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261001150935.655979-3-mszeredi@redhat.com>
References: <20261001150935.655979-1-mszeredi@redhat.com>
 <20261001150935.655979-3-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 15:18:44 +0000
Message-Id: <20261001151845.0C3511F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] fs/fuse: uninitialized err returned in fuse_file_io_open()
--

commit bfd7cbb3d1064d14b9422fa08119f1cc83817677
Author: Miklos Szeredi <mszeredi@redhat.com>

fuse: add helpers for EIO return value with kernel message

This commit introduces helpers to print a short message to the kernel log
and return an error value when a buggy fuse server triggers an EIO
condition. It also updates various I/O and passthrough open handlers to
utilize these helpers, removing older debug messages and changing some
functions to return boolean values on success.

> diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
> index 79637c09e8839..1a10bc65fb310 100644
> --- a/fs/fuse/iomode.c
> +++ b/fs/fuse/iomode.c
[ ... ]
> @@ -208,11 +201,12 @@ int fuse_file_io_open(struct file *file, struct ino=
de *inode)
> =20
>  	/*
>  	 * Server is expected to use FOPEN_PASSTHROUGH for all opens of an inode
> -	 * which is already open for passthrough.
> +	 * which is already open for passthrough.  Using incorrect open mode is
> +	 * a server mistake, which results in user visible failure of open()
> +	 * with EIO error.
>  	 */
> -	err =3D -EINVAL;
>  	if (fuse_inode_backing(fi) && !(ff->open_flags & FOPEN_PASSTHROUGH))
> -		goto fail;
> +		return fuse_EIO("FOPEN_PASSTHROUGH expected");
[ ... ]
>  	if (ff->open_flags & FOPEN_PASSTHROUGH)
>  		err =3D fuse_file_passthrough_open(inode, file);
> -	else
> -		err =3D fuse_file_cached_io_open(inode, ff);
> -	if (err)
> -		goto fail;
> +	else if (!fuse_file_cached_io_open(inode, ff))
> +		err =3D fuse_EIO("conflicting passthrough open");
> =20
> -	return 0;
> -
> -fail:
> -	pr_debug("failed to open file in requested io mode (open_flags=3D0x%x, =
err=3D%i).\n",
> -		 ff->open_flags, err);
> -	/*
> -	 * The file open mode determines the inode io mode.
> -	 * Using incorrect open mode is a server mistake, which results in
> -	 * user visible failure of open() with EIO error.
> -	 */
> -	return -EIO;
> +	return err;
>  }

[Severity: High]
Does this code leak an uninitialized stack value on success?

On the standard cached I/O open path, if the FOPEN_PASSTHROUGH flag is
not set and fuse_file_cached_io_open() returns true for success,
execution will bypass both branches of the if/else-if statement.

Since the initial err =3D -EINVAL assignment was removed earlier in the
function, the err variable remains unassigned in this scenario. This means
a successful file open will return an uninitialized stack variable,
potentially leading to undefined VFS behavior or random system call
failures depending on the stack contents.

Could we initialize err to 0 at declaration, or explicitly return 0 on
the success path?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001150935.6559=
79-1-mszeredi@redhat.com?part=3D2
