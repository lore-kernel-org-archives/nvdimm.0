Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059223D7D69;
	Wed, 24 Jun 2026 15:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313884; cv=none; b=haApCMq5jlJAveJnzUV31Fr8Q9cYNlLNAovC7XzjxY9x8HgAQ9gXspuCbYLb24DQXofYQYHlhl6d6AeUIiAyaRJFl2qJrHxWIf5GSLJtaO9FJD4PCSG8Be1BJxxdQQHSrJVIS6V9IDDqa33bpVdTeNk5nKeulr8PiHYsvBAaglw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313884; c=relaxed/simple;
	bh=gdZxg9oz9WLpakJPOTOQ6HIqAykaWiGAYrwKtCN9pDo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jplzG5mgaxkPBf/JHTc0HOjaG2B2pfI70zKVqTeusHNfGvZuvwLZdOw9r/fVaQT79YXoOLerOzUMzTPHQe2Kpw9j03t8rhGfZfwbPyNb3KKq+E3WDgtyhopL7wA2TTOymubKtdBPbIacfHuetBWkNjT8Ri12SPqMi44GkTE4P3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jBXi+ChV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jBXi+ChV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE551F000E9;
	Wed, 24 Jun 2026 15:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782313882;
	bh=XD68JWdyXT0rejUkeTo8kBojIyncLoeSQ6lzIaG+40o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jBXi+ChVBp6Cesbv21Wx6PJ/XvJN9wt43RM7xoNP5twJkmVXij+yoF01+60J5zzTY
	 KDlHjOsjFq2c1JuxOtd8YV/23O0xOyHhaQBE2wXxFgI6dfbEulFjKT9RPkXvTCOV18
	 jab3m6CSwErAR21EruuqOxIWFX80J/RfCrRinuQmGpjjydK7STOFfg0w/TNPnFruWs
	 OM6k9en+6gDlCXYZESKhdGmZmBSP8+SrYke7sZO9GIw3+hqt0/qf+QvF7UbHo7p5MH
	 vY/58A0eJW92dPEgEqu4xbyxgxz4ye4VWzpjKQbOzbE7+piGjYyhhdvVYxQHWW6hRI
	 /oK7z+Xz0TQRg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 8/9] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260624145744.3532049-9-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-9-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 15:11:21 +0000
Message-Id: <20260624151122.AFE551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The protection against deadlocks during driver unbind can be compl=
etely bypassed if the underlying memory blocks are manually onlined via the=
 core memory sysfs, causing state desynchronization.
- [Medium] any_hotremove_failed is irrevocably set on recoverable sysfs hot=
remove failures, leading to a permanent leak of kmem_name.
--

commit fa89899811083ada324ea3db8204b1c135005af5
Author: Gregory Price <gourry@gourry.net>
Subject: dax/kmem: add sysfs interface for atomic whole-device hotplug

This patch adds a new 'state' sysfs attribute for dax_kmem devices to enable
atomic whole-device hotplug operations. It also updates the unbind logic to
prevent deadlocks by omitting memory removal if the memory blocks are
currently online.

> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index a45e50def5371..340486586d82c 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c

[ ... ]

> +static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
> +				 struct dax_kmem_data *data)
> +{

[ ... ]

> +	rc =3D offline_and_remove_memory_ranges(ranges, nr_ranges);
> +	kfree(ranges);
> +	if (rc) {
> +		any_hotremove_failed =3D true;
> +		dev_err(dev, "hotremove failed, device left online: %d\n", rc);
> +		return rc;
> +	}

[Severity: Medium]
Does this permanently leak kmem_name on recoverable sysfs failures?

If a user attempts to unplug a device via sysfs and the hotremove fails
transiently (e.g., due to memory being in use), any_hotremove_failed is set
to true. Even if the user retries and the unplug later succeeds, this global
flag is never cleared, which will prevent freeing kmem_name during module
unload.

[ ... ]

> @@ -348,20 +490,26 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_d=
ax)
>  #ifdef CONFIG_MEMORY_HOTREMOVE
>  static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>  {

[ ... ]

> +	if (dax_kmem_state_is_online(data->state)) {
> +		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
> +		any_hotremove_failed =3D true;
> +		return;
> +	} else if (data->state =3D=3D MMOP_OFFLINE &&
> +	    dax_kmem_do_hotremove(dev_dax, data)) {
> +		dev_warn(dev, "Unplug failed, resources leaked until reboot\n");
>  		return;
>  	}

[Severity: High]
Can this deadlock during unbind if the memory state is desynchronized?

If the device is configured with auto_online_blocks=3Doffline, data->state =
is
initially MMOP_OFFLINE. If a user manually onlines the underlying memory
blocks via the generic /sys/devices/system/memory/memoryX/state sysfs
interface, data->state remains MMOP_OFFLINE.

During unbind, dev_dax_kmem_remove() will evaluate
dax_kmem_state_is_online(data->state) as false and proceed to call
dax_kmem_do_hotremove() instead of safely aborting. This attempts to offline
the blocks while holding the device unbind lock, bypassing the intended
deadlock protection.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624145744.3532=
049-1-gourry@gourry.net?part=3D8
