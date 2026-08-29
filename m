Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08627353A8D;
	Sat, 29 Aug 2026 17:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788024745; cv=none; b=RYDWxlCJBTzJvdvvf50Rw6+oehY73HGby5XrR65ufr518InC2oqVQ8ut2Na7216I2ZMiiFr0Zg4w+o99ZXWHqObnElb6foS/zfnXcVR7ycTAxylFhfq6pEX9mNkhGoxxkAmq7heSm/AaOXxyJ65bUF6d4ZyLMled4V0ie+QjZvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788024745; c=relaxed/simple;
	bh=+VF7h8TEjmVQ1IE1fdhRRPBk4gxANsFmYg9x4EHW8bo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iWQsd5SuZJV7jkhMUsPBRf5CIZ1Ok5oI56lhaAhLqbRNs2obF5TyxarXHl1UUmGZJTqsaYwsxzFsHMByJtDChtT7i2rofZPA6VLyNIowilPMe4PJfARcRsK4Ep+iECT7CjcFyQF+gowRNOqlRVGDMZR7crwAH20pDKsHWahw2hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nd3Q/lk3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nd3Q/lk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7799A1F000E9;
	Sat, 29 Aug 2026 17:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788024743;
	bh=5iwnFVOdGFBdGOAwLBMpG42wzp2Gl3Vd2FcpIA55B44=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nd3Q/lk38Ixbb/4qwiaCOb0nfIiMv43QVGm0r05p2OlxJwkaSxhA5cCu2NREtgwBu
	 V08nk7S4MQaaNRd4gSUiBWzwXjuuwEbKQAlyN8u+luUZ25kvNVVnWrEQvaz/AaUuUn
	 5yX5K5sGf13mzoAXhKXO4ITNZHVxBx+fLQRY+lqTiaQlpbZjhtOOmIpDn0kQcSZTxO
	 FjQXmIjc0+YA9l+7+ntyjEBBbyQSti5gSDcwuORgjVLFlf8GxDo32f7N5M5TKv4SbA
	 HDoIHOO7QJ6D3rSlINYnAVivbEpoXS2w1wV67t6EhJ8Yi6vlPxcOoBCbdGy2QgmAHp
	 qX3l575m+ZcMw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V14 03/12] famfs: Add daxdev table and dax
 notify_failure support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <010001a04e8100cf-a8efea37-2f0c-4862-b4a9-9dc70cf04b34-000000@email.amazonses.com>
References: <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com>
 <20260829171104.7394-1-john@jagalactic.com>
 <010001a04e8100cf-a8efea37-2f0c-4862-b4a9-9dc70cf04b34-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 29 Aug 2026 17:32:23 +0000
Message-Id: <20260829173223.7799A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Incorrect memory ordering primitive for publishing lockless state =
(wmb() vs smp_store_release())
--

commit df7a50134ff93b3213d9bbccb1aca11a71421bee
Author: John Groves <John@Groves.net>

famfs: Add daxdev table and dax notify_failure support

This commit introduces the daxdev table for famfs, which manages multiple d=
ax
devices using a basic structure, primitives, and serialization. It also adds
dax_holder_operations and a notify_failure handler required to properly open
a famfs-mode daxdev.

> diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> index 5a13903da61b7..5735d8d1900bd 100644
> --- a/fs/famfs/famfs_inode.c
> +++ b/fs/famfs/famfs_inode.c

[ ... ]

> @@ -76,6 +76,231 @@ famfs_get_inode(
> +int
> +famfs_install_daxdev(
> +	struct famfs_fs_info *fsi,
> +	struct super_block *sb,
> +	u64 index,
> +	dev_t devno,
> +	const char *name)
> +{

[ ... ]

> +		daxdev->devno =3D devno;
> +		if (name) {
> +			daxdev->name =3D kstrdup(name, GFP_KERNEL);
> +			if (!daxdev->name) {
> +				fs_put_dax(daxdev->devp, sb);
> +				put_dax(daxdev->devp);
> +				daxdev->devp =3D NULL;
> +				return -ENOMEM;
> +			}
> +		}
> +
> +		wmb(); /* All other fields must be visible before valid */
> +		daxdev->valid =3D 1;

[Severity: High]
Does this code safely publish the daxdev structure to concurrent lockless
readers?

In famfs_install_daxdev(), the structure is populated and then its valid fl=
ag
is set to 1 after a naked wmb(). While wmb() provides a write barrier for t=
he
writer, it does not enforce pairing on the reader side. If a concurrent
lockless reader (such as famfs_daxdev_from_index() added later in this patch
series) checks valid using a simple read like if (!dd->valid) without a
corresponding read barrier, the CPU could reorder the reads.

If the reads are reordered, the reader could observe valid =3D=3D 1 but see
uninitialized data or a NULL devp, which might lead to a NULL pointer
dereference.

Could this be converted to use smp_store_release(&daxdev->valid, 1) on the
writer side, and paired with smp_load_acquire() on the lockless reader side?

> +	}
> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/010001a04e801a4e-8e=
b212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com?part=3D3
