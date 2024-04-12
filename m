Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EFD5B5B6
	for <nvdimm@lists.linux.dev>; Fri, 12 Apr 2024 12:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712925444; cv=none; b=aGZbHgrnAoNFLXGcJRbBM4d65EpgP0U0Ivr+IjAV+X8YvMvdycoycM+GdINfpzPyyi0w3q/0PbHC+WlK+z5P+nq9iJWOkRLCtEYqfwEZRoq/CiwNVBopukO3rbJuS8YZqlFJD7pFJcQPRG3VzYOq26ewHAxG/YFtA12kp3+LDq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712925444; c=relaxed/simple;
	bh=3pNK9YTqMqiViynBQNAstvuzyugc6Dm6cYfCp/2gkJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XEKZtFwTT6kjvqIPH7Mg+Xjr92Jr2r+hesGGt3MWvrZabfWibgOoRY+qKxmEPxuhxnTONpyPvgIOPArdzXyVFyyOcWu+oKEq9zinge7hd043ejStgQny3GSgFV7rtrlJ8zXATUmF94khojsBtVcMZRByG4txMLLvCNQ0ebuCZbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1rvG9W-0001xE-LG; Fri, 12 Apr 2024 14:37:10 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rvG9V-00BsYn-Gx; Fri, 12 Apr 2024 14:37:09 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.96)
	(envelope-from <ukl@pengutronix.de>)
	id 1rvG9V-000Am8-1P;
	Fri, 12 Apr 2024 14:37:09 +0200
Date: Fri, 12 Apr 2024 14:37:09 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Benjamin Tissoires <benjamin.tissoires@redhat.com>, Yi Zhang <yi.zhang@redhat.com>, kernel@pengutronix.de, 
	nvdimm@lists.linux.dev
Subject: Re: [PATCH] ndtest: Convert to platform remove callback returning
 void
Message-ID: <xyisbsurpa2irnjtedqcrgn2wnhp5s3jge7tzavxzud7pvk3rm@4tcefxvvs7l5>
References: <c04bfc941a9f5d249b049572c1ae122fe551ee5d.1709886922.git.u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cls2lzh2xu37w3g6"
Content-Disposition: inline
In-Reply-To: <c04bfc941a9f5d249b049572c1ae122fe551ee5d.1709886922.git.u.kleine-koenig@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: nvdimm@lists.linux.dev


--cls2lzh2xu37w3g6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 08, 2024 at 09:51:22AM +0100, Uwe Kleine-K=F6nig wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
>=20
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
>=20
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>=20
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

This patch got two positive review feedback mails but isn't included in
next. This makes me wonder who feels responsible for picking it up.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--cls2lzh2xu37w3g6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmYZKvQACgkQj4D7WH0S
/k58HAf+P8U0ngRtTJh9NOBcgWlR/NYZ/CW0r79wbZgJHRJ+pSgoTpAAUNt8bmsg
St3fsT/NldgyPkz661tcHHC8680zCACHQd6U4OSqXZL8MlEhobGBNDIeVU7OsGLB
O7m+9KfiIlJ1o/RdMAnCWW9hrq7YZNhkPf50g4xzFp24IwIfJjlYrr88Lwu5ljZX
I+l5Wr03viRqqFmgommoTD2kZmx0a7RMPxmt8ghSTGg4cbivp/GqZkYPTNEDQAuZ
sDfGQGkflLL5u8QL3KkJJcdllQn9MuL0ILfKWZy2iQ8l0npQZuZzeJxHurI4EQE/
Ebb4Rr+Zgc0BmI9O3FmtkmKYhrayvA==
=yv8X
-----END PGP SIGNATURE-----

--cls2lzh2xu37w3g6--
