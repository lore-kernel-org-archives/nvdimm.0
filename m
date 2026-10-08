Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AEB3BB133;
	Thu,  8 Oct 2026 11:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791459137; cv=none; b=IDxG9V3G5+cjVhyIj5crctBS4TxPJWm73fidbkMYPa/avM1By50MKh6L0KCXewbnBV4KLcz4k4TX2iQ9tImUrxrkojMNatS7VXwFmz9l0SC0mpxTHLlmfxVBZjyWWWYlxApVMvQfbrMIlBwEYLwCUzHqO0QcxPf6VrUpSItl10w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791459137; c=relaxed/simple;
	bh=Ql/KeybQUdjxHHz+cIr49SzLZaiYCLK60qMGRP843FQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=iXLiKPFwHlR4DHQh4c0DxVpXa9Wg2CbmpBQSpxMku9lJhMxD65e2K15e1h2hLO2qYR/5sKXBjNfgK+C68y//Tojcs17pi9r6vJcrvoi/cEZGg1b9CiP4ginBx32b+FDaOru7+zX3+vOpWREbgzJukvf96mcaLv4D29t3BIVHq40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HE1+UMm3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HE1+UMm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CC71F000FF;
	Thu,  8 Oct 2026 11:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791459136;
	bh=tftI81bfrcRt3gsFKZz2SEOBEFHoAhqWMfo5y80m+Hc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HE1+UMm3dOkqhXb4piRrrdGh/W32zbr0UkYrtzqvSdL35Evwuu5zyMkK7Fr4d/aZc
	 KeBuDZXHikE37iW+76qQtWV6U+DXc0AXq5Zn18T6z1AcnOr2Hr1CSjfcLmJgG4+bKG
	 MAp1q4YAlAhD1rm8kK5sJoNvn3bFbvDDiC9769fv3mvm2roV9E29sMkyUkeIBEPGdl
	 to6gA0h7kbu5Yc4wCowqK1E7kxnTqdagZAd0HvOwDCq++rk3ws/Imm+jVPfllb/CJp
	 koYcUIOBwV2JksupEcSZvWzsK8Q6Dy868CJWmgPJPSVtQ9ECogYfvzh1nop3GWRWsf
	 t5sVuh0Qj4npA==
Message-ID: <sashiko-outbox-164090@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/9] dax: use READ_ONCE() in dax_holder()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20261008112004.1899560-3-mszeredi@redhat.com>
References: <20261008112004.1899560-1-mszeredi@redhat.com>
 <20261008112004.1899560-3-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 11:32:15 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] dax: UAF and NULL deref in xfs_dax_notify_failure due to synchrono=
us holder free
--

commit 27365c0f46f3cc2abb67ac0ebca3b78ca639e39f
Author: Miklos Szeredi <mszeredi@redhat.com>

dax: use READ_ONCE() in dax_holder()

This commit updates dax_holder() to use READ_ONCE() when returning the
holder_data. This is intended to allow dax_holder() to be utilized in RCU
context and ensure the holder cannot be freed by a racing fs_put_dax.

> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 25836f389bded..76e8d36546290 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -642,7 +642,7 @@ EXPORT_SYMBOL_GPL(put_dax);
>   */
>  void *dax_holder(struct dax_device *dax_dev)
>  {
> -	return dax_dev->holder_data;
> +	return READ_ONCE(dax_dev->holder_data);

[Severity: High]
Does this change and the reliance on RCU context expose a NULL pointer
dereference and Use-After-Free risk for existing users like XFS?

When a hardware memory failure triggers dax_holder_notify_failure(), it
takes the SRCU read lock and calls xfs_dax_notify_failure(). This reads the
holder pointer and unconditionally dereferences it without checking for NUL=
L:

fs/xfs/xfs_notify_failure.c:xfs_dax_notify_failure() {
	struct xfs_mount *mp =3D dax_holder(dax_dev);

	if (!(mp->m_super->s_flags & SB_BORN)) {
		...
}

Concurrently, if the filesystem is unmounted, xfs_free_buftarg() calls
fs_put_dax(), which clears the holder_data without waiting for active SRCU
or RCU readers to finish:

drivers/dax/super.c:fs_put_dax() {
	...
	WRITE_ONCE(dax_dev->holder_ops, NULL);
	prev =3D cmpxchg(&dax_dev->holder_data, holder, NULL);
	...
}

Immediately after, xfs_mount_free() synchronously frees the xfs_mount object
without waiting for an RCU or SRCU grace period:

fs/xfs/xfs_super.c:xfs_mount_free() {
	...
	debugfs_remove(mp->m_debugfs);
	kfree(mp->m_rtname);
	kfree(mp->m_logname);
#ifdef DEBUG
	kfree(mp->m_errortag);
#endif
	kfree(mp);
}

If xfs_dax_notify_failure() calls dax_holder() after it is cleared, mp is
NULL, causing an immediate crash when accessing mp->m_super. If it reads the
pointer before clearing, but kfree(mp) executes concurrently, it causes a
Use-After-Free.

An asynchronous memory failure during unmount could reliably trigger this.

The commit message mentions utilizing dax_holder() in RCU context to make
sure that the holder cannot be freed by a racing fs_put_dax. Does this
assume that filesystems defer freeing the holder? For XFS, the holder
appears to be synchronously freed without an RCU grace period.

>  }
>  EXPORT_SYMBOL_GPL(dax_holder);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008112004.1899=
560-1-mszeredi@redhat.com?part=3D2
