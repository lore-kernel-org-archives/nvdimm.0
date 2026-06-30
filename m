Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255E43F20E7
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 11:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782820208; cv=none; b=Ak4cXCzTICKdxSUNlP+uYmqSFbwd4xcqGO0FQA0pQnUoSbYt2zDDOBLxwPNFMqF5r+XmCAswoWH54/4avi/FWawAqukYUY3rBDC81onM3YcCL6m0wu0WRcae0EmbxTyrRovlYxT5XNIXnNfdOMky1jK46JulDJIQkmAI8pkPLpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782820208; c=relaxed/simple;
	bh=4/vj1penIXBj/yMttMO4P34VP2gxDPm/cdU9+hxHe1Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dOofVBQukG4izENpcSbL4t8k5s0XUqzrSOFe2BgbTx/iBUj+p7zxe4P58DSnE5vII0ZxacT6a7nLchXFIhbxDIMFe5ZVvyimaxNgmyh+AoQbI5dyMBcMJHj9zuSjAmTvsqZoOWjHksLsJAk2sHBleQrD8a9k2Toh35m2pRM+qws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MilfwJmQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MilfwJmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948D61F000E9;
	Tue, 30 Jun 2026 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782820206;
	bh=Btxb+uS7hyuKU7DJJj4GgTlNOIhETnE03+M+ja8m+EA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MilfwJmQKe2stfHWZ7n8Sy1cUTPP8KaTGcHrd/P9BWzE5LETxRXVgvk9kDkM4VJFE
	 jFjqjRo67u2J4D8AWW9mXRvHEALk+XU5XalYy7+zs82zPwOSLgo4p4cPwM4u9eAm0v
	 Qoa8wnWsDzIeogOTDWuU/7Tt0JzpjC8LRCwj39pbCCBBVzSO5PDUDfQynbQjUDegUp
	 FzNC7AuosRp5KrLnVIiVPDrHsuqWFm9Whhw/I+0KdMzkL7WSd7rgcdB142WWVSLbuv
	 xnsiLT3JAvsk6VzgKWuZx2/7DW5Odpb/k2A88Yvbu+z/wuk6mu5/m6bw44mA3RlTbW
	 EaOJ64TDQIWDw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 11/12] nvdimm: virtio_pmem: converge broken virtqueue
 to -EIO
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Chen" <me@linux.beauty>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260630092338.2094628-12-me@linux.beauty>
References: <20260630092338.2094628-1-me@linux.beauty>
 <20260630092338.2094628-12-me@linux.beauty>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 11:50:06 +0000
Message-Id: <20260630115006.948D61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The use of `dev_err_once()` in `virtio_pmem_mark_broken()` cause=
s a false positive error during normal device removal and permanently masks=
 actual virtqueue failures for all subsequent devices.
--

commit eef59350d160a3f85b9b2a847d436de7706e56bd
Author: Li Chen <me@linux.beauty>

nvdimm: virtio_pmem: converge broken virtqueue to -EIO

This commit tracks a device-level broken state for the virtio pmem
request virtqueue to fail fast and wake up waiters when the queue is
broken. It unifies the handling of broken queues and synchronously fails
parent bios.

Link: https://lore.kernel.org/r/202512250116.ewtzlD0g-lkp@intel.com/

> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
[ ... ]
> +void virtio_pmem_mark_broken(struct virtio_pmem *vpmem)
> +{
> +	if (!READ_ONCE(vpmem->broken)) {
> +		WRITE_ONCE(vpmem->broken, true);
> +		dev_err_once(&vpmem->vdev->dev, "virtqueue is broken\n");

[Severity: Medium]
Will this dev_err_once() globally mask true virtqueue failures and produce
false positive errors during normal operation?

Because dev_err_once() uses a globally static boolean, it will only print
this message once for the entire driver, rather than once per device.

> +	}
> +
> +	virtio_pmem_wake_inflight(vpmem);
> +	virtio_pmem_wake_all_waiters(vpmem);
> +}
> +EXPORT_SYMBOL_GPL(virtio_pmem_mark_broken);
[ ... ]
> diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> --- a/drivers/nvdimm/virtio_pmem.c
> +++ b/drivers/nvdimm/virtio_pmem.c
[ ... ]
> @@ -148,11 +150,21 @@ static void virtio_pmem_remove(struct virtio_device=
 *vdev)
>  {
>  	struct nvdimm_bus *nvdimm_bus =3D dev_get_drvdata(&vdev->dev);
>  	struct virtio_pmem *vpmem =3D vdev->priv;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vpmem->pmem_lock, flags);
> +	virtio_pmem_mark_broken(vpmem);

[Severity: Medium]
Does this unconditional call during teardown mean the first normal device
removal will trigger the one-time error log?

If a user unbinds the driver or removes a device, virtio_pmem_remove()
will call virtio_pmem_mark_broken(). This appears to log a false positive
error during expected teardown, and because it was logged via
dev_err_once(), it will silently mask any actual hardware or virtqueue
failures on other virtio-pmem devices afterwards.

> +	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> =20
> -	nvdimm_bus_unregister(nvdimm_bus);
>  	drain_workqueue(vpmem->flush_wq);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630092338.2094=
628-1-me@linux.beauty?part=3D11
