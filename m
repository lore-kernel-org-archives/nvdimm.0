Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE552459E1;
	Sun, 27 Sep 2026 11:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790510301; cv=none; b=ojLULHcfGVnplaDOutWSuzD4m3sYmL+vZ0r3A9MSWA+0w0Jh6r1Hy4t+CNeJ5UaDvwltiD/0TJw1bZ0gmVStVKlGIEZwMIGosDgoeX6cNxrBz8pQHrG4X/Uou4jcjbGNnooNRDc7l2kDp06timaz5Rrok/Vu/lZHEK0LLWTD3y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790510301; c=relaxed/simple;
	bh=6JNXZ2bMh31VIN5WJ2uqSlN5asDL64HzWvnXO8Rssnk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dsqAQ+dXN43Ekk1AHZb+DNDjhzNJvRWKaHicZB7tqFMRFSpwC9RQTgd3ZKLfA+eRn0lEiVrjV7T2Y5Ip03Bv/Fa0r+Chii2R0eLOCCzVVi4PFDhRjlwJ0dyZd+gb296yEm9iAGKQRqN/aT7EJFqS2SVB0k63umDwV/7Os+YPn+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=npsq5L9a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="npsq5L9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E299C1F000FF;
	Sun, 27 Sep 2026 11:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790510300;
	bh=VlP/4JxjjTyj20BlDorORFWApHjHSNKDUH2pw5L7Jjk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=npsq5L9a3igxiyisW0TKg2u2bgm9Gsgl9azdcabcKgoVzhUTYSKQld5l+xQwz7jQw
	 Egc40+XIY0U2gS92/HvRNRwgoi5VXdk4YN3F0G+WQ9/j+tLaC+ADTqB5A2wm+FZBUx
	 qD8ZQS6+0xmRZxgFN2+SygktUSEIvPRGtrL0BsnyjSPqS4zsc8HreBXrrRwD9NUSW0
	 sAdHT0aKc/E0jWrDlcNDIddC6q/qz5BTyoRCK3OXB5AcMFLo8MItupy8+X+qbX+Kl3
	 ifMbEIwtwDVKVWEM0FlcOQFZ+A+J3jNhvH13r37iFZxi77dhCEjVJXhax24Qno6NyY
	 g1m9FdZH422vg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dax/device: defer publishing the dynamic pgmap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiale Yao" <yaojiale02@163.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260927114736.1113965-1-yaojiale02@163.com>
References: <20260927114736.1113965-1-yaojiale02@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 27 Sep 2026 11:58:19 +0000
Message-Id: <20260927115819.E299C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] dax: NULL pointer dereference in dax_set_mapping() due to probe ra=
ce
--

commit e1fc62ba8d484aee08a80e703a3d5b11181f82a7
Author: Jiale Yao <yaojiale02@163.com>

dax/device: defer publishing the dynamic pgmap
   =20
The dynamic device-dax probe path publishes its devm-allocated pgmap
before several operations that can still fail.  If one of them fails,
devres frees the pgmap while dev_dax->pgmap remains non-NULL.  A later
bind then fails the dynamic-dax invariant check and leaves the device
unusable until its region is recreated.
   =20
Cc: stable@vger.kernel.org

> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index d0c9b4e03b477..8cd8e05872c35 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
[ ... ]
> @@ -450,7 +449,13 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
>  		return rc;
> =20
>  	run_dax(dax_dev);
> -	return devm_add_action_or_reset(dev, dev_dax_kill, dev_dax);
> +	rc =3D devm_add_action_or_reset(dev, dev_dax_kill, dev_dax);
> +	if (rc)
> +		return rc;
> +
> +	/* Probe can no longer fail; expose the pgmap via dev_dax. */
> +	dev_dax->pgmap =3D pgmap;

[Severity: High]
Does this sequence introduce a NULL pointer dereference race condition?

When run_dax() is called, it sets DAXDEV_ALIVE, which enables the device to
begin accepting userspace page faults. Because cdev_add() was already called
earlier in the probe path, a user application can continually call mmap() a=
nd
trigger a page fault during device binding.

If a page fault occurs before dev_dax->pgmap is assigned here, could it rea=
ch
dax_set_mapping() and dereference a NULL pointer?

drivers/dax/device.c:dax_set_mapping() {
    ...
	/* mapping is only set on the head */
	if (dev_dax->pgmap->vmemmap_shift)
		nr_pages =3D 1;
    ...
}

> +	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927114736.1113=
965-1-yaojiale02@163.com?part=3D1
