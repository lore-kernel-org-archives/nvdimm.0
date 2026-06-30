Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC02328690;
	Tue, 30 Jun 2026 21:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782855139; cv=none; b=JKRGV9kRy2zh6R0AyERuW7BFaH8n7rC6txZ0zs2mkFpsszHNgdtcIu8c9wseClNIUT7wwgv8f8TljHxwm2dP2uoGqH89HShukmhqt9mIGUcdscETMTDtUC6jgROSKnGGJVEcUO2n/20BghDyF6QUbVoDjpVNwwWOlHYY/VIRg50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782855139; c=relaxed/simple;
	bh=0Nakuy9n1y9QhcfHiYEVjfE2qiV8v4cY3/dCPv77iwU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OOhpwORmUEF/GBZ/U1t7wAu7nFcyzry+63B0VVMMnVOfJAz97IPOS8CVjui8n+Ll/h0Kk3KJ8AM99ey4LFg7v8+xjPb173Bzna51L7FIVxN1H4hj8cRzGojAlaYit5h6kNxBUJaq8PNQfXnooWDMld2M1ZeuaSEw4T+KrcAsgNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mcO3qVVl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mcO3qVVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A90E1F000E9;
	Tue, 30 Jun 2026 21:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782855138;
	bh=D9Mc2bdI7ErsBSIFnTArjJEckjDk8zvGkqW0gWYE+UU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mcO3qVVlQjCCo/FRS8HGioaoh1mQ+OkznpxEiMWeaYuXsPAUjA5YcqdzSLI/4OzP2
	 OdjHF2heg1D6eqVRwJr2F8VDy25EKHz95ZGk1mMYtKOlZ8Nb3SvFAFjyuO6RvxNo8P
	 hZvBqQskS4ghZUcend7u0Kv0nlTrUEdmmKD1/qwQxt8F+oF5pe/JKxYuPu8vBSJ1CZ
	 UFlBc/PMcLXUAu3+LWATifF/g8T7222gx4GCVOWEydlEmEBEsHrE5lHEyRUd1Rdc3u
	 PoyCmcseALHyIvrQper0ygCtfWuotsSp/AySN5vLuycl9PecTJRVvLWRnVer4CLMw/
	 igpuwsWvrLVdQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260630211842.2252800-10-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 21:32:17 +0000
Message-Id: <20260630213218.4A90E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing error cleanup in state_store() leaks resource reservations=
 and corrupts state for subsequent unplug operations if dax_kmem_do_hotplug=
() fails.
--

commit 48ff7b34b13219e34e3823e263b700c3183a5d86
Author: Gregory Price <gourry@gourry.net>

dax/kmem: add sysfs interface for atomic whole-device hotplug

Adds a new 'state' sysfs attribute to daxX.Y devices that allows an atomic
whole-device hotplug operation across its entire memory region. The device
can be transitioned between unplugged, online, online_kernel, and
online_movable states.

> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 72dcccee41e16..19effe0da3dce 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
[ ... ]
> @@ -123,14 +145,14 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_=
dax,
>  				kfree(data->res[i]);
>  				data->res[i] =3D NULL;
>  			}
> -			if (onlined)
> +			if (added)
>  				continue;
>  			return rc;

[Severity: High]
If this fails on the first range (added =3D=3D 0), it returns immediately.
Since dax_kmem_init_resources() reserves all ranges beforehand, doesn't this
leave reservations for subsequent ranges (i+1 to N) allocated in data->res?

>  		}
> -		onlined++;
> +		added++;
>  	}
> =20
> -	return onlined;
> +	return added;
>  }
[ ... ]
> @@ -256,6 +309,85 @@ static void dax_kmem_cleanup_resources(struct dev_da=
x *dev_dax,
[ ... ]
> +static ssize_t state_store(struct device *dev, struct device_attribute *=
attr,
> +			     const char *buf, size_t len)
> +{
[ ... ]
> +	/* Re-acquire resources if previously unplugged, otherwise no-op */
> +	rc =3D dax_kmem_init_resources(dev_dax, data);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc =3D dax_kmem_do_hotplug(dev_dax, data, online_type);
> +	if (rc < 0)
> +		return rc;

[Severity: High]
If dax_kmem_do_hotplug() returns an error here, state_store() returns
directly without calling dax_kmem_cleanup_resources().

If the first range fails to hotplug, does this leave the remaining ranges
reserved but not added?

If the user later writes "unplugged" to sysfs, would dax_kmem_do_hotremove()
attempt to offline and remove memory that was never successfully added to t=
he
hotplug subsystem?

> +
> +	data->state =3D online_type;
> +	return len;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630211842.2252=
800-1-gourry@gourry.net?part=3D9
