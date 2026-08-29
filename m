Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E23B2E5B29;
	Sat, 29 Aug 2026 17:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788024492; cv=none; b=mHhEJLO9oZbw7vENjwl9s068wlDsn40C13Au5Vg73TTt+BNlNQpqIXh9EB7gRuxiL3KOmJHwt5dw4MKYww0xEJWKjL8x8x0w1gA4JrHTGVhgoZlwSAHM94T9daMt7E77d/Z6ErJRYv43vE8Z4QNL4c0kkKaHETrhro503dPCnHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788024492; c=relaxed/simple;
	bh=STPK7eVxLZVEoFL8sDlNCBgllqo9RTD9Lj2GKI1DpwE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nJkCavUEt2RSNZ1xKUVfh86TKi12TJIdtG72kR5z+4v/0VkQANjb6CVurmgBczFO9lpL9v0yQoZDISSaZN/mtW//tNPKv3r2qgoLUrpeqyuOpfIDSSFX3/7WOQyKTucS533Ijgw05x5kXaoPp7Y1yZmNMlmuZtyq/tbkRVd9NS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MvCTutPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MvCTutPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022991F000E9;
	Sat, 29 Aug 2026 17:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788024491;
	bh=MM1a8NwJURR0FNW1BVHAIbwC1CvtMsY020dLnuVeeVQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MvCTutPLU6WEmuCQFaQhNknPIT0JDeNBbncy6L3jwbUzA32e5FEhngfkhKOkY2f/t
	 U+38Cpsb8XJ4aKZQzTyWCTjMyWLFWjkRS6V5F2Z5ydtsCDEIE91fP0kWPaACTbTpoM
	 /LFX0m8i6HJetBxh4Pl32WJMb4PDDxsnkubcliakNCPbsO3pVvZb7E2nIup4nEOSzR
	 oDTYtQQa3TrTOSdaM3FMMPauh8/ypu76TyB+x+hJQ++VaT0hU0hjFIC8QuiU/Ibj+Z
	 FNqbJUXdIbhkin2OPBBf7a9nXMoPO7j+RGL6uBu67M5Cn5DJ3mM60sHemugCHvB+rk
	 C8gTGd6h24+uw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V14 02/12] famfs: Module operations, fs_context, and
 mount
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <010001a04e80d952-12403958-9576-475d-a375-b0948273892f-000000@email.amazonses.com>
References: <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com>
 <20260829171055.7379-1-john@jagalactic.com>
 <010001a04e80d952-12403958-9576-475d-a375-b0948273892f-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 29 Aug 2026 17:28:10 +0000
Message-Id: <20260829172811.022991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The mount path explicitly rejects concurrent mounts of the same =
backing device, contradicting the commit message claim that multiple mounts=
 should share the superblock.
--

commit c082254e4802428a0767926c0085c3cbeace41cb
Author: John Groves <john@groves.net>
famfs: Module operations, fs_context, and mount

This commit introduces the initial module operations for famfs, including
filesystem registration, mount parameter parsing, superblock initialization,
and DAX device lookup.

> diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> new file mode 100644
> index 0000000000000..5a13903da61b7
> --- /dev/null
> +++ b/fs/famfs/famfs_inode.c

[ ... ]

> +static int
> +famfs_get_tree(struct fs_context *fc)
> +{
> +	struct famfs_fs_info *fsi =3D fc->s_fs_info;
> +	struct super_block *sb;
> +	struct inode *inode;
> +	dev_t daxdevno;
> +	int err;

[ ... ]

> +	/* This will set sb->s_dev=3Ddaxdevno */
> +	sb =3D sget_dev(fc, daxdevno);
> +	if (IS_ERR(sb)) {
> +		pr_debug("%s: sget_dev error\n", __func__);
> +		return PTR_ERR(sb);
> +	}
> +
> +	if (sb->s_root) {
> +		pr_debug("%s: found a matching superblock for %s\n",
> +			__func__, fc->source);
> +
> +		/* We don't expect to find a match by dev_t; if we do, it must
> +		 * already be mounted, so we bail
> +		 */
> +		err =3D -EBUSY;
> +		goto deactivate_out;

[Severity: Medium]
Does returning -EBUSY here intentionally prevent sharing the superblock
across multiple mounts?

The commit message states: "so a second mount of the same device shares one
super, much as a block filesystem keys on its block device." However, this
check appears to explicitly reject concurrent mounts of the same DAX backing
device rather than sharing the existing superblock.

> +	} else {
> +		pr_debug("%s: initializing new superblock for %s\n",
> +			__func__, fc->source);
> +		famfs_fill_super(sb, fc);
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/010001a04e801a4e-8e=
b212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com?part=3D2
