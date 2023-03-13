Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [85.220.165.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ADB8C17
	for <nvdimm@lists.linux.dev>; Mon, 13 Mar 2023 21:26:29 +0000 (UTC)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pbpg2-00081X-CX; Mon, 13 Mar 2023 22:25:54 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pbpg0-003w5l-5I; Mon, 13 Mar 2023 22:25:52 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pbpfz-004fMW-Gh; Mon, 13 Mar 2023 22:25:51 +0100
Date: Mon, 13 Mar 2023 22:25:51 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, kernel@pengutronix.de,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH] dax/hmem: Drop empty platform remove function
Message-ID: <20230313212551.pckzjktf35lhyni2@pengutronix.de>
References: <20221212220725.3778201-1-u.kleine-koenig@pengutronix.de>
 <6397f58686d6d_b05d1294dc@dwillia2-xfh.jf.intel.com.notmuch>
 <20230112215658.q74wtxaw57iss267@pengutronix.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nxqypmwtckviqp42"
Content-Disposition: inline
In-Reply-To: <20230112215658.q74wtxaw57iss267@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: nvdimm@lists.linux.dev


--nxqypmwtckviqp42
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2023 at 10:56:58PM +0100, Uwe Kleine-K=F6nig wrote:
> On Mon, Dec 12, 2022 at 07:46:14PM -0800, Dan Williams wrote:
> > Uwe Kleine-K=F6nig wrote:
> > > A remove callback just returning 0 is equivalent to no remove callback
> > > at all. So drop the useless function.
> >=20
> > Looks good, applied.
>=20
> Thanks. I wonder why the patch doesn't appear in next though. Is this
> deliberate?

Hmm, strange. This patch didn't make it in, but the same patch submitted
by you later with a different commit log eventually made it in.

v2 from Feb 10 2023
(https://lore.kernel.org/r/167602001664.1924368.9102029637928071240.stgit@d=
willia2-xfh.jf.intel.com)
was applied as 84fe17f8e9c68a4389c6e89b7ce3b4651b359989, initial series fro=
m Feb 05
(https://lore.kernel.org/all/167564542679.847146.17174404738816053065.stgit=
@dwillia2-xfh.jf.intel.com)

I feel a bit humbugged,
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--nxqypmwtckviqp42
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmQPlNwACgkQwfwUeK3K
7AnQEQf/TYuICkfvC2J7/UsX+0V8bpdzVGAvlVLBLRBuHmBZ9V4ljoboIdF/GSKY
Yl1f1RZ2hZwJ6eaFifnvRpun2BOE4WtCfc0G12DCAoZL/7BpTMwPpX0egHww5+KY
Xr+mqOkxmFVDLtFqt+EYYdMACJhzYDv1iEGIWR4PD9mD0CylS4v35jv/I0c8LwGg
WkbIs3cEn5XQxLbryCfEMnMXJb3NeVzMj4aKmrQuC9qTynqfIdiA0bLG7gGj9G5+
lkiTB8bf/FvFuz+L2qrGNJEZ2ppoGjVuM2XoxExQwuAH+WYGPxv5HMyBvSoqUD+A
0OUoLPn9zkSZdVfdJR6CFf77FIBoCQ==
=/8Oi
-----END PGP SIGNATURE-----

--nxqypmwtckviqp42--
