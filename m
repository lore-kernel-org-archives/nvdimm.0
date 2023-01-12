Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [85.220.165.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017648F44
	for <nvdimm@lists.linux.dev>; Thu, 12 Jan 2023 21:57:13 +0000 (UTC)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pG5ZE-0005sk-Cx; Thu, 12 Jan 2023 22:57:00 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pG5ZD-005cqP-62; Thu, 12 Jan 2023 22:56:59 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pG5ZC-00CN36-IN; Thu, 12 Jan 2023 22:56:58 +0100
Date: Thu, 12 Jan 2023 22:56:58 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev,
	kernel@pengutronix.de
Subject: Re: [PATCH] dax/hmem: Drop empty platform remove function
Message-ID: <20230112215658.q74wtxaw57iss267@pengutronix.de>
References: <20221212220725.3778201-1-u.kleine-koenig@pengutronix.de>
 <6397f58686d6d_b05d1294dc@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ictlcrhm65tmwfl2"
Content-Disposition: inline
In-Reply-To: <6397f58686d6d_b05d1294dc@dwillia2-xfh.jf.intel.com.notmuch>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: nvdimm@lists.linux.dev


--ictlcrhm65tmwfl2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 12, 2022 at 07:46:14PM -0800, Dan Williams wrote:
> Uwe Kleine-K=F6nig wrote:
> > A remove callback just returning 0 is equivalent to no remove callback
> > at all. So drop the useless function.
>=20
> Looks good, applied.

Thanks. I wonder why the patch doesn't appear in next though. Is this
deliberate?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--ictlcrhm65tmwfl2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmPAgicACgkQwfwUeK3K
7AmNvggAlzOTrzqqNLKCsVvBVm30biDV6rkpyT/8ld9acqoVG2zw4m0hME28U7T8
Szose5VqGl1GDsfHX9Z00C3OLg+w+rfw7u77Gfc6XE4kQk/cgYDc6iwg0td56p44
TV7xfTlE0viaUwMntuRBLVuhAlykgm4qDWuQn0KSqUTVuo9Ps8B4u5/xfkiq6qlT
olRmMNVu918EKPUkrZFL87l4ksAluw3HyE20dwwMTglO20+MfYx89z70Sj8Q7SMI
4ocLPM2risBjwdN+K9hDrHQudAyebmZ97BWB/AZci9j+iIiOCM5PHDxh7D8gFeRz
WhkIcbVwkOtcJnH5RxTFtwV4YEIUzA==
=JTvU
-----END PGP SIGNATURE-----

--ictlcrhm65tmwfl2--
