Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [85.220.165.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969DA2104
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 05:56:15 +0000 (UTC)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pwGKE-0001QW-Fh; Tue, 09 May 2023 07:55:50 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pwGKC-002A6X-0A; Tue, 09 May 2023 07:55:48 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pwGKA-002fyV-V5; Tue, 09 May 2023 07:55:46 +0200
Date: Tue, 9 May 2023 07:55:46 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev, kernel@pengutronix.de
Subject: Re: [PATCH] tools/testing/nvdimm: Drop empty platform remove function
Message-ID: <20230509055546.pw3rippph347hugg@pengutronix.de>
References: <20221213100512.599548-1-u.kleine-koenig@pengutronix.de>
 <6398cde3808c6_b05d1294c4@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2mzoxzbybr47rncc"
Content-Disposition: inline
In-Reply-To: <6398cde3808c6_b05d1294c4@dwillia2-xfh.jf.intel.com.notmuch>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: nvdimm@lists.linux.dev


--2mzoxzbybr47rncc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 13, 2022 at 11:09:23AM -0800, Dan Williams wrote:
> Uwe Kleine-K=F6nig wrote:
> > A remove callback just returning 0 is equivalent to no remove callback
> > at all. So drop the useless function.
>=20
> Looks good, applied to my for-6.3/misc branch for now.

It seems it didn't make it from your for-6.3/misc branch into the
mainline (as of v6.4-rc1). What is missing?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--2mzoxzbybr47rncc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmRZ4GIACgkQj4D7WH0S
/k5QLgf+KEs1Or8mWJcOgDKgYq4GAnf+RxxcctTN5AeRYNsoWHLK48KsBTSdmpwP
F3KbtKpU+y0QbXBs2ZUmFOs0krdcVW/Pd7GGk/EF2qsu3lmDplFB8/4YfUpo5uYy
kOrx85uv8dNhpLyK18mRVibMYEqF0GHyNP6sCgYSotKATY25i2z3ubUpR8a64LNk
TrIJ/NMkThhEXieoYYd0h2GKsRQEG0tnT8GYCYvChHryZyD+bzQ8fje67NT9Fqwh
U7JnqQJn7iWttW85kJ2ho0Xj2nUn+b+8c+1Yz9nUv6LbGB7uYst7ErUMQWTbDj7o
BSDH/FkfdNPeU46hlCX9rOFvBMZLEg==
=gYVr
-----END PGP SIGNATURE-----

--2mzoxzbybr47rncc--
