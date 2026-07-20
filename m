Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B95391838;
	Mon, 20 Jul 2026 03:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519782; cv=none; b=SJVxes6vnOutnKh8E7of1IIciFGP8t94NlK+55V0Yr6r5tWvmun3xZL+zFub6GgDy/e2T1Bx1BgOhw7YJ9fE5X5gvNtfUvpWA2sVLSMHiKMquiHVXgpwV6UwZFi3Ewpfi63S5ECY5l9GQJKZ94Vw3a31cRYYRdTLtY/EABbLTgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519782; c=relaxed/simple;
	bh=43xaS+cTuV6YHzvJZe5iGxAfKT7ZvSFnnMqGQ3+UdzY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fbBQhnHLDh9rG0u+VNKkJEHdz6KqY5H2ZLO6amT2CemPnp8UvTCVdNHb5KkpVB1FBik+RXpGJIGiTKcvNTP+eThtdpbr7Y651uGTxXSlCY6/vAAJZUtwDmGHHnCWFocERytfvxiqvFygvYYy6vHN3TsEo4Tsdjl3lpPuuSPV+8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ILBi1WPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ILBi1WPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A531F000E9;
	Mon, 20 Jul 2026 03:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784519781;
	bh=jHAnoNDo1XZYjEPXQInIr21XbiHMdsVXDeVvDT8tVU0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ILBi1WPxdihVPSFi+p1Ny5Msowd16WfLuA6IJ8c3TnhvKd3ZZF4CqKeytB4Xoyf7y
	 hPa6U6LZvseZuy9rilSDK4eIR2UlAmj//e2uQ6UC5k0BiMMPohx4NFnO+YM0R88Mmb
	 OiA6j8vypzqmow3IMkNHQRV6lPZRHr7oHjFy0N7bud/11TtgXQko/OhpBPs3vHfPNr
	 yHs9yciSQGTzrTC3hhj4MfhmNpQM77ry5FmxqA2+vv1f/puNubw+6w/zK627iITAJJ
	 pW8gdhNn6maUWx6U86OQmSSWZW/Hovs2dywVwnw35EHW3p0ItG1hjlTzVQ94NFcXLl
	 WIOtXAM+okQcg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V11 2/9] famfs_fuse: Basic fuse kernel ABI enablement
 for famfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <0100019f7da11f42-c1026097-89e3-4a44-93d0-ef0938544d6b-000000@email.amazonses.com>
References: <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <20260720034532.68759-1-john@jagalactic.com>
 <0100019f7da11f42-c1026097-89e3-4a44-93d0-ef0938544d6b-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 03:56:20 +0000
Message-Id: <20260720035621.27A531F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing capability check allows unprivileged FUSE servers to negot=
iate famfs (devdax) maps.
--

--- Patch [2]: [PATCH V11 2/9] famfs_fuse: Basic fuse kernel ABI enablement=
 for famfs ---
commit 4d97f5030fb15081e23a077a520a8dbf87b728ec
Author: John Groves <john@groves.net>

famfs_fuse: Basic fuse kernel ABI enablement for famfs

This commit adds the initial FUSE plumbing to support famfs (fabric-attached
memory file system). It introduces the FUSE_FAMFS_DAX Kconfig option, the
FUSE_DAX_FMAP capability flag for INIT negotiation, and a famfs_iomap flag
in the fuse connection.

> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 77c21b28b6fa7..c347471d04b6b 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1406,6 +1406,10 @@ static void process_init_reply(struct fuse_args *a=
rgs, int error)
> =20
>  			if (flags & FUSE_REQUEST_TIMEOUT)
>  				timeout =3D arg->request_timeout;
> +
> +			if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
> +			    flags & FUSE_DAX_FMAP)
> +				fc->famfs_iomap =3D 1;

[Severity: High]
Does this allow an unprivileged FUSE server to negotiate famfs maps?

Since unprivileged users can mount FUSE filesystems in user namespaces,
could a malicious server reply with FUSE_DAX_FMAP and enable
fc->famfs_iomap without the kernel ever verifying if the mount issuer
has privileges like capable(CAP_SYS_RAWIO)?

>  		} else {
>  			ra_pages =3D fc->max_read / PAGE_SIZE;
>  			fc->no_lock =3D 1;

[ ... ]

> @@ -1473,6 +1477,8 @@ static struct fuse_init_args *fuse_new_init(struct =
fuse_mount *fm)
>  		flags |=3D FUSE_SUBMOUNTS;
>  	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
>  		flags |=3D FUSE_PASSTHROUGH;
> +	if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> +		flags |=3D FUSE_DAX_FMAP;

[Severity: High]
Should this flag negotiation be restricted to callers with CAP_SYS_RAWIO?

Without a capability check here in fuse_new_init(), FUSE_DAX_FMAP is
sent to the server unconditionally if CONFIG_FUSE_FAMFS_DAX is enabled,
which might allow unprivileged users to negotiate access to devdax
memory mapping.

> =20
>  	/*
>  	 * This is just an information flag for fuse server. No need to check

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019f7d9fbe81-6c=
b16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com?part=3D2
