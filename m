Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF419168DC
	for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 07:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714376011; cv=none; b=VwRFEmDzwuQn81lm2+PO3ZYwAX+/j9J3uv058w6lYaWznC7FjRkhDz/mJVX7xfyna9jwtRY2xy8yfeAIKATtemjVQE4Kxt/TlJruv3OnPaLAwPc8WLT+FW4vHKL2MvLL94A8a9VPLwn1jyUvzFMLYEtuqns6x3PcdqJxZo3in4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714376011; c=relaxed/simple;
	bh=NH0X98pKZIgAFhQCwMPvLwkx5W3Bz1dEy0aFUXtpcJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SVBDaNaJ9gA0CxBNa90nv3doedZzumIHN3tw4mXoIIcjaUfOG9bDhwlmgwy73WBgdZjwDGJ79qtYJkj5j5QV4NPMbiEy1rbCZvUl6jdqHZVUJzLVlUgPM7oWh2Rctum02zN6zONDJJWQKyHxIQfc3SD7yBXiHDma5xMYBAIOQ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1s1LVl-00069Y-8g; Mon, 29 Apr 2024 09:33:17 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1s1LVk-00Ew8z-AQ; Mon, 29 Apr 2024 09:33:16 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.96)
	(envelope-from <ukl@pengutronix.de>)
	id 1s1LVk-00BEFB-0m;
	Mon, 29 Apr 2024 09:33:16 +0200
Date: Mon, 29 Apr 2024 09:33:16 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Oliver O'Halloran <oohall@gmail.com>
Cc: nvdimm@lists.linux.dev, kernel@pengutronix.de
Subject: Re: [PATCH 0/2] nvdimm: Convert to platform remove callback
 returning void
Message-ID: <dgye5olc5ofqlxvtouiw4pl4b3sf7gnego7bhf2fa57knjkv6y@xom44xpshmcs>
References: <cover.1712756722.git.u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3ibpktgf6wll4sev"
Content-Disposition: inline
In-Reply-To: <cover.1712756722.git.u.kleine-koenig@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: nvdimm@lists.linux.dev


--3ibpktgf6wll4sev
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Wed, Apr 10, 2024 at 03:47:32PM +0200, Uwe Kleine-K=F6nig wrote:
> this series converts all platform drivers below drivers/nvdimm/ to not
> use struct platform_device::remove() any more. See commit 5c5a7680e67b
> ("platform: Provide a remove callback that returns no value") for an
> extended explanation and the eventual goal.
>=20
> All conversations are trivial, because the driver's .remove() callbacks
> returned zero unconditionally.
>=20
> There are no interdependencies between these patches, so they can be
> applied independently if needed. This is merge window material.

I intend to send the change adapting the prototype of struct
platform_device::remove() soon after the upcoming merge window closed.
So it would be great if these two patches made it in before. If not,
I'll ask Greg to take these patches together with the change to struct
platform_device.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--3ibpktgf6wll4sev
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmYvTTsACgkQj4D7WH0S
/k68Mgf+PMvh1WxXeF8CcMXFvTCkFgN/Ch2XgqzW6FvEOPeE8ucdHP0Iu3yMNDnJ
GJBHOhNCW2KUYnfMzAHWSmAib0dcWZzIiQ91NIwoIXrT3BIYhDF/zdykYbE3zGt5
a2zsEwfMhGF79E5EBPfVrP8+l0N0Gr0ALJEAskXbT3XrJolD0MrUjJjlv95BRSCq
IOqhYeyXiWRIKDdcuW7watrRMW9N2a/J0qmnVOgoxfUwzqcahIcuU0Pn4fCWn7dL
92fimJbTwFeaQcbo+QBYouBIM02GMLFtbJXU2rdyE6VMvm5EKABRfaRjwUSk4OiK
7qkyej0x7+kYEyqtC/gjSVefz+paVg==
=39Hs
-----END PGP SIGNATURE-----

--3ibpktgf6wll4sev--
