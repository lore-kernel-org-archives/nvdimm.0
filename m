Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939995304C3;
	Thu,  1 Oct 2026 15:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790868154; cv=none; b=q3hcXc18tK9KKHjMdcf7aIkbtFVAmdj6i+c032AWiVZaEYM5JQH5FgpLb5bAHkghPXXUGdzLCzJc2wDBPfGtfsqcg2UcqqBwVU7pJ0Wieg+7TgtiF5xQmhySHiH1qPsB6Ad+v8Z04dPdH/11fimQgOenKhWdL1/FniZ0NcPW1e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790868154; c=relaxed/simple;
	bh=k71KAmtN9dvFtCOdhli9s45vBQlPLsAwNR/9B90as3M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mLwcNTuVBQQOZukhDNjlvOdr0EcCGJstCpsRyNJQZTBL6L7OKxgsYwV5i2EuL7aCcsN5T2kBza1HhRkIZ86ujj/3OSUDjnhX2amUXmQYPKTxndhkc0lAwlSiOjrIxBmVAHa3bseURFJLo8fznvJI3Z4VIkJj1Z6pO2ImDBdEnIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VTrGb12I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VTrGb12I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128201F00898;
	Thu,  1 Oct 2026 15:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790868153;
	bh=jQxX/2gWR/n0N9XPUeTeH/dlX9sQCYpy4yT3lANa5l4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VTrGb12ICxnVTCUvkpXBjG3Sdt+sYnX/lM/ABWAlqOM41pyrvGaYYrWZk94WMq/LS
	 2W02MGsERjKKDohw/Xq+5i/jSMOIXxEhRXL04D0iNsHi8NjHm0wShsuqAVhphRz/nz
	 uqALImu2NryXuZJtVTIS2NSYLJRF4o21L/gF/kFBDIhjX3/GYZYNIPjgs3ZFh0DFMo
	 NNl/HkwLczDlWXcU3IBAewOtN/ujwC4AZWxJyyXuJo/R82aHowhSKTnKH1ImbooIcF
	 duSiqZ+Mu85GAXAK4/vxFiiXHOsG5zZa6HmxJWk/cLHlA+Wts9jxjwKEzEArSH9r+t
	 +gf2YRWTbUo0w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/8] fuse: support opening 64 bit backing ID
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261001150935.655979-5-mszeredi@redhat.com>
References: <20261001150935.655979-1-mszeredi@redhat.com>
 <20261001150935.655979-5-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 15:22:32 +0000
Message-Id: <20261001152233.128201F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] fuse: negative backing ID validation bypass due to unsigned convers=
ion
--

commit 38737a0048b9ea224c699e27954c4cb00bdfc596
Author: Miklos Szeredi <mszeredi@redhat.com>

fuse: support opening 64 bit backing ID

This commit adds a backing_id_64 field to fuse_open_out to allow opening
files with 64-bit server-allocated backing IDs. When the server sets
FUSE_BACKING_ID_64, the kernel reads the backing ID from backing_id_64
instead of backing_id.

> diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
> index 1a10bc65fb310..811ea603b7767 100644
> --- a/fs/fuse/iomode.c
> +++ b/fs/fuse/iomode.c
> @@ -160,7 +160,9 @@ static int fuse_file_passthrough_open(struct inode *i=
node, struct file *file)
>  {
>  	struct fuse_file *ff =3D file->private_data;
>  	struct fuse_conn *fc =3D get_fuse_conn(inode);
> +	struct fuse_open_out *outarg =3D &ff->args->open_outarg;
>  	struct fuse_backing *fb;
> +	u64 backing_id;
>  	int err;
> =20
>  	/* Check allowed conditions for file open in passthrough mode */
> @@ -170,18 +172,38 @@ static int fuse_file_passthrough_open(struct inode =
*inode, struct file *file)
>  	if (ff->open_flags & ~FOPEN_PASSTHROUGH_MASK)
>  		return fuse_EIO("conflicting open flags");
> =20
> -	fb =3D fuse_passthrough_open(file, ff->args->open_outarg.backing_id);
> -	if (IS_ERR(fb))
> -		return PTR_ERR(fb);
> +	if (!fc->backing_id_64) {
> +		if (outarg->backing_id_64 !=3D 0)
> +			return fuse_EIO("64 bit backing ID set");
> +
> +		backing_id =3D outarg->backing_id;
> +		if (backing_id <=3D 0)

[Severity: Low]
Since outarg->backing_id is a signed 32-bit integer and backing_id is an
unsigned 64-bit integer, will negative IDs bypass this explicit error check
due to sign-extension during the assignment?

If outarg->backing_id is negative, it gets sign-extended into a large
positive value when assigned to the u64 backing_id. This causes the <=3D 0
check to evaluate to false, skipping the intended "invalid backing ID"
validation.

The code will then proceed and fail in fuse_backing_lookup(), logging
"backing not found" instead of the expected "invalid backing ID" error.

> +			return fuse_EIO("invalid backing ID");
> +	} else {
> +		if (outarg->backing_id !=3D 0)
> +			return fuse_EIO("32 bit backing ID set");
> +
> +		backing_id =3D outarg->backing_id_64;
> +	}
> +	fb =3D fuse_backing_lookup(fc, backing_id);
> +	if (!fb)
> +		return fuse_EIO("backing not found");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001150935.6559=
79-1-mszeredi@redhat.com?part=3D4
