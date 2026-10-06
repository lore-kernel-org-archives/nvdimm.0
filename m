Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDE838F930;
	Tue,  6 Oct 2026 18:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791310418; cv=none; b=WG4AQUW1juLLzYWVanRYUFgQT+pRa3oEmtg21lJ6q+XmBwxs1QQmY/IIShXpZx4+cXFlWmdF/XwfFyti8OHiKr3bgAf4Ex3J24DLphTDfVmkQSx7mvwTIceDtc85C1C9RwN+a26Ytqc7iryQJ2C8JP/fsO4VA4lXVq0wQi49atY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791310418; c=relaxed/simple;
	bh=bf6zZs4EosBKKZEsjUCol59M2vNWjAqaatRp80XWtfo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jyrrjhu4DS1US/zAAXSH2h9Fjp6mcxZeRrx88gaBNeYE+XP/+kdbytYPICsIJ29HWqL2vfxCGvZgKPS8qufm2kZId91v3KeN6oN7zoTW6sTCMkYMBc10l7zK2DThiPD9ZvDj4NbHUwr0iOExPuUXAvOYHo0omBiaIJNWcTnvHkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bv0CqOeS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bv0CqOeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B3B1F0089B;
	Tue,  6 Oct 2026 18:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791310416;
	bh=JSBSxxBd2P6MoXh3fMA1Bp+JyVVca711Blx/hphFMgI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Bv0CqOeSzpKLF4nHRYF72jvrYzuH427eLU/MPPG46modlAyvfifmw8qr3KD16ZUNh
	 u16zQCqck+jQ1dvm1OKIOjqo3hbmUNgwoHVpC03Zr9aPFxxLsAIK7Tiv5tylxM1j7H
	 MVIzPVi3mBW/QPUIx8eUCvLumZv8Z9Wo4jkouSEws71Sa2BP3c1Yh6UBunQp5x4/Q9
	 ilAqyyQ9IZHrc87vfGziy4VkPRZwlJq+yBaeDtWT8uH9Zw+9xNblPxtZfp76OpH3An
	 bU7gs3oOm6MQTdxmAgCq4jmD1WgHC/VmEL8q5Y45RJncs5Cb0pk8OqoxTqPw0jwaef
	 fMIaikEbQVIhg==
Message-ID: <sashiko-outbox-162321@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/9] dax: use READ_ONCE() in dax_holder()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miklos Szeredi" <mszeredi@redhat.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20261006180115.1425232-3-mszeredi@redhat.com>
References: <20261006180115.1425232-1-mszeredi@redhat.com>
 <20261006180115.1425232-3-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 18:13:36 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] xfs: missing NULL check in xfs_dax_notify_failure() causes NULL po=
inter dereference
- [High] dax: missing synchronize_srcu() in fs_put_dax() leads to Use-After=
-Free of xfs_mount
--

commit b62dcd3b2d7873db8fcf1fc4a0c2b9c52417ad0a
Author: Miklos Szeredi <mszeredi@redhat.com>

dax: use READ_ONCE() in dax_holder()
   =20
Make sure that a non-NULL check in callers remains valid even when racing
with fs_put_dax().

> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 824e1f6df3780..0a440f8b42e4f 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -677,7 +677,7 @@ EXPORT_SYMBOL_GPL(put_dax);
>   */
>  void *dax_holder(struct dax_device *dax_dev)
>  {
> -	return dax_dev->holder_data;
> +	return READ_ONCE(dax_dev->holder_data);

[Severity: High]
Does this code still leave a window for a NULL pointer dereference?

The commit message mentions protecting a non-NULL check in callers, but the
caller in xfs_dax_notify_failure() doesn't appear to have one:

fs/xfs/xfs_notify_failure.c:xfs_dax_notify_failure() {
	struct xfs_mount	*mp =3D dax_holder(dax_dev);

	if (!(mp->m_super->s_flags & SB_BORN)) {
		...
}

If a concurrent unmount clears dax_dev->holder_data to NULL via
fs_put_dax(), won't this result in assigning NULL to mp and immediately
dereferencing mp->m_super?


[Severity: High]
Can a use-after-free occur on the returned xfs_mount pointer even if a NULL
check is added?

When a memory failure triggers dax_holder_notify_failure(), it acquires
dax_read_lock() (which is SRCU) and calls xfs_dax_notify_failure().

Concurrently, if an unmount calls fs_put_dax(), it clears the holder data:

drivers/dax/super.c:fs_put_dax() {
	...
	WRITE_ONCE(dax_dev->holder_ops, NULL);
	prev =3D cmpxchg(&dax_dev->holder_data, holder, NULL);
	...
}

Since fs_put_dax() returns without calling synchronize_srcu(&dax_srcu) to
wait for active readers, the unmount process can proceed and destroy the
xfs_mount structure.

Won't the still-executing xfs_dax_notify_failure() then access the freed
xfs_mount, resulting in a use-after-free?

>  }
>  EXPORT_SYMBOL_GPL(dax_holder);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006180115.1425=
232-1-mszeredi@redhat.com?part=3D2
