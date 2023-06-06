Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [85.220.165.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDFC37B97
	for <nvdimm@lists.linux.dev>; Tue,  6 Jun 2023 15:57:25 +0000 (UTC)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6Z3V-0000gY-0E; Tue, 06 Jun 2023 17:57:09 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6Z3U-005XaJ-9m; Tue, 06 Jun 2023 17:57:08 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6Z3T-00BkOx-Ld; Tue, 06 Jun 2023 17:57:07 +0200
Date: Tue, 6 Jun 2023 17:57:07 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, kernel@pengutronix.de,
	Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev
Subject: Re: [PATCH] tools/testing/nvdimm: Drop empty platform remove function
Message-ID: <20230606155707.gzoj5qdb7ebf6z7n@pengutronix.de>
References: <20221213100512.599548-1-u.kleine-koenig@pengutronix.de>
 <6398cde3808c6_b05d1294c4@dwillia2-xfh.jf.intel.com.notmuch>
 <20230509055546.pw3rippph347hugg@pengutronix.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dgflg45qdwmm4vrn"
Content-Disposition: inline
In-Reply-To: <20230509055546.pw3rippph347hugg@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: nvdimm@lists.linux.dev


--dgflg45qdwmm4vrn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Dan,

On Tue, May 09, 2023 at 07:55:46AM +0200, Uwe Kleine-K=F6nig wrote:
> On Tue, Dec 13, 2022 at 11:09:23AM -0800, Dan Williams wrote:
> > Uwe Kleine-K=F6nig wrote:
> > > A remove callback just returning 0 is equivalent to no remove callback
> > > at all. So drop the useless function.
> >=20
> > Looks good, applied to my for-6.3/misc branch for now.
>=20
> It seems it didn't make it from your for-6.3/misc branch into the
> mainline (as of v6.4-rc1). What is missing?

I don't know what was missing, back then, but the symptom stays: This
patch isn't contained in today's next. :-\

I found the patch in the nvdimm patchwork
(https://patchwork.kernel.org/project/linux-nvdimm/patch/20221213100512.599=
548-1-u.kleine-koenig@pengutronix.de/),
it was archived. I dared to unarchive it, maybe that helps!?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--dgflg45qdwmm4vrn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmR/V1IACgkQj4D7WH0S
/k7K/wgAgTygYkQoZGwkdLuA5cHctqIVzInSB+PFRWfALnE96O64HIyCamI1xoIZ
EeoR17a7dd3/53XW6f7W1BP4y5S6bYIJVxc42XIvwJyC5Tk7T+4agtLEIe5n788I
lzvQruZc0F+10owmBA08W1qW9KkuCg9SGaWD3SBrRUu7o7/dzKCERe2tXMy0zykC
HSNG40/O6b2QP91YFAifhoWCSaD2yKhONqVxNKnWsajMqy4/a+YD2ArKHlyx9tlK
oOYTx/IQaQCxQbJE15dcHos9Ej3zHyDZdyVmGUu43CB9v2TkmlIRh4Nle9W3lsWq
QvZDs9YdHuGk4PiYl0f4oXiZOcDiVQ==
=zso7
-----END PGP SIGNATURE-----

--dgflg45qdwmm4vrn--
