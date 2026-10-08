Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97235444719;
	Thu,  8 Oct 2026 11:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791459255; cv=none; b=PJ4NEX0ujjDHqAcBo8U+ixiduTBekBRYrQY+eOmyduWks/HyiyeH1BbZJTso2XNRxSNr6mIQ+/1jB9UMZhGZL+vcd4GfTT0ga/K3rMbpneFBjXj3LfCB9A93PKOYS7ixJMGUWCrgIfV5pxYk96cJmo5MlpMALO3MIqTmPhKXb5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791459255; c=relaxed/simple;
	bh=Qf3Xbkb0fGceg5rmNK+c5Smgg11CwbuyizfcaYisWfc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=PQ+gJCc++q9k3uXYyTNGBaXIF0zYpw3k2B6gLtCRsGzoVWX72TEJdHPsabqlKC1SoOqD3Tb22/p/5ZT+ugaO7jiaxDKs9esytf054pxakGU1W4fULQBtJEYzP75haCB84zWEZHZTae+QWOUDEHrwbjZUN0Yz7TD71gV38Bt7mRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kMtHwNUR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kMtHwNUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483AA1F000FF;
	Thu,  8 Oct 2026 11:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791459254;
	bh=W9kMku2G9zV1wQ7bwW4uPPh/98qlPgCAU2YneIS5AMU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kMtHwNURPDu0aesXoTkdQp4urJcyiJ9T3sfW2I469RSO1Blt0HXfQah6lEAG8uPal
	 mVReHgSNr3cAs46gAKrHIjfwCdSXOEbj8gxktEQzqSl5ZazRVaUrEZ4TZMHoXNVuem
	 /KkSWhw8z+WugOz74d2MXBY6KdVuJ9x109NWVjaRX4LpXZSNXLIojicuipobPBNgxg
	 2pglUzHcb54nVxi4Sg77D2MsC9Wlqq+/KO7tImSa0Xz6T5sKfMgSrp1lHkHzYt79kS
	 J+vOdGRYp48Cu2bkMmV4VdcMbmgiZWleRVHoxmNFvVc5C3E9i1l4tSiujiAGvavCos
	 igUs6AFFEJVpg==
Message-ID: <sashiko-outbox-164095@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/9] dax: add fsdev_dax_from_file()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261008112004.1899560-2-mszeredi@redhat.com>
References: <20261008112004.1899560-1-mszeredi@redhat.com>
 <20261008112004.1899560-2-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 11:34:13 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] dax: lockdep splat and user-triggerable WARN_ON in fsdev_dax_from_=
file()
--

commit f952deffb3bddf19404bc61323d8ebb31e8333ad
Author: John Groves <John@Groves.net>
Date:   Thu Oct 8 11:19:52 2026 +0000

    dax: add fsdev_dax_from_file()

This commit adds the fsdev_dax_from_file() helper to get the dax_dev from a
device inode's i_cdev and grab a reference on the private dax inode. It also
makes dax_dev_get() static again, replacing its export with the new helper.

> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c

[ ... ]

> @@ -234,6 +234,30 @@ static const struct file_operations fsdev_fops =3D {
>  	.release =3D fsdev_release,
>  };
> =20
> +/**
> + * fsdev_dax_from_file - get dax_device from an open file
> + * @file: open device file
> + *
> + * Returns a dax_device pointer if @file refers to a fsdev_dax device.
> + * Otherwise return NULL.
> + *
> + * Caller must put_dax() the returned device when done.
> + */
> +struct dax_device *fsdev_dax_from_file(struct file *file)
> +{
> +	struct dax_device *dax_dev;
> +
> +	if (file->f_op !=3D &fsdev_fops)
> +		return NULL;
> +
> +	dax_dev =3D inode_dax(file_inode(file));
> +	WARN_ON(!dax_alive(dax_dev));
> +	ihold(dax_inode(dax_dev));
> +
> +	return dax_dev;

[Severity: High]
Does this code trigger a lockdep splat when calling dax_alive()?

Looking at dax_alive() in drivers/dax/super.c, it explicitly asserts that
the dax_srcu lock is held:

bool dax_alive(struct dax_device *dax_dev)
{
        lockdep_assert_held(&dax_srcu);
        return test_bit(DAXDEV_ALIVE, &dax_dev->flags);
}

Since fsdev_dax_from_file() does not appear to acquire the dax_srcu lock
before this call, it looks like this will cause a lockdep splat on every
invocation when lockdep is enabled.

Additionally, if an administrator unbinds the driver via sysfs (which
clears DAXDEV_ALIVE), will this WARN_ON become user-triggerable during a
later file lookup? A user-triggerable kernel splat can cause a panic if
panic_on_warn is enabled.

If the device is actually dead, is it safe to proceed to call ihold() and
return the dead device pointer to the caller? Perhaps this path should
return NULL or an error instead of providing a dead device.

> +}
> +EXPORT_SYMBOL_GPL(fsdev_dax_from_file);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008112004.1899=
560-1-mszeredi@redhat.com?part=3D1
