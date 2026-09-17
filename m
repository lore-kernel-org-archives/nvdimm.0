Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647094FDE43
	for <nvdimm@lists.linux.dev>; Thu, 17 Sep 2026 12:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789649083; cv=none; b=O92BjzKoegT3lHOwg5PyzCwEVJa2yx35BPjcl3S9D8vcy0ui/x2ydEbKmdeKuecdP7xXtl9fm7VJQV5AzhmWpgH3NIJVcz2rs3t9h/yaEidb421y3Wvc+qEtsYGPvgOjyYh2XZeEsGB/nKqHWTCzhAYnB8+w+AlDa/cRXyGD/us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789649083; c=relaxed/simple;
	bh=EoCf8CgjLCyslLp4YakW2aRMqv5WdAZ0J3Xc/aGMG1Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dfIWTBqgj4WaccKoP5yJCQbHpMBgHjYyW+Fhazutpw2l0/IutccUb5dhREDmAgEjjQ3ND5OaIum0mgjuOmfEKoPsuiys81z+Ct7A/H2Y7cN3bNjHIfPuYX81ERYpf5j3NKQUAWTs4GvYBB91DP+bau0b75bDO+80jczXcDp1QCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZXBNN9s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZXBNN9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E511F000FF;
	Thu, 17 Sep 2026 12:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789649072;
	bh=v4lIWEO+8xmG95lgSephkdyqWvjni4TVSuh6a7Wl9Vo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SZXBNN9sxA12bjgEfiR8N1ncE+PQuQm0Nv+v4vgOlekgNxZwAMI4exe2DXD4H7Klm
	 gvzCKMgPFgIxCOz3Pt2ID9Bpo/ZVMpb4GReuj4QjdgMLZeeJudePXtDXorwZ8M9JRU
	 LkKj4niaDgVSNNbbmpS0VVr9+m+WwWueHEekVd+J9mEBpPusswd97S1iXPb5LPYhsp
	 iyru+HnTDfZQBonqtYUXT0rXIT2mczeY/kBhqfQhCfq7dYTBlLlN74AmB+Lk3LOl+2
	 KaJLSr/QRRG7FXjBqona2lPXdeCqqrRXSUH6s7J5TnYjse1k5LomJHNLu2eGtoMjTM
	 FXsTHvSby4gSA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] nvdimm/bus: Fix dev double put in
 nd_async_device_register()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260917122816.2151081-1-vulab@iscas.ac.cn>
References: <20260917122816.2151081-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 12:44:32 +0000
Message-Id: <20260917124432.B0E511F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] nvdimm: memory leak on device_add() failure in nd_async_device_r=
egister()
--

commit 3bb889471cc9122db778cd1b964d9131ca101b98
Author: Wentao Liang <vulab@iscas.ac.cn>

nvdimm/bus: Fix dev double put in nd_async_device_register()

device_add() takes and drops its own reference on every return path, so
the async worker only owns the reference that __nd_device_register()
took with get_device(). The failure branch drops that same reference once
more before the unconditional put_device(), which underflows the refcount
and frees the device while it is still referenced by its creator.

> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 45b7d756e39a0..a1f33a03aba81 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -488,10 +488,8 @@ static void nd_async_device_register(void *d, async_=
cookie_t cookie)
>  	struct device *dev =3D d;
>  	struct device *parent =3D dev->parent;
> =20
> -	if (device_add(dev) !=3D 0) {
> +	if (device_add(dev) !=3D 0)
>  		dev_err(dev, "%s: failed\n", __func__);
> -		put_device(dev);
> -	}

[Severity: Medium]
Will this lead to a memory leak of the device if device_add() fails?

Devices initialized with device_initialize() start with a refcount of 1.
In __nd_device_register(), a second reference is taken before queuing the
async worker. If device_add() fails here, it does not consume a reference.

By removing the extra put_device() from the failure path, the async worker
only drops the second reference, leaving the device with a refcount of 1.
Because device_add() failed, the device isn't added to the parent's
klist_children, so it won't be unregistered when the parent is removed.
Since the creator simply nullifies its pointer without dropping the final
reference, does this result in a permanent leak of the device and its
container structures?

>  	put_device(dev);
>  	if (parent)
>  		put_device(parent);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917122816.2151=
081-1-vulab@iscas.ac.cn?part=3D1
