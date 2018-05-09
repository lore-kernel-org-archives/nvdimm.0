Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 10 May 2018 07:51:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [Ksummit-discuss] bug-introducing patches
Message-ID: <20180510075149.57c3034a@canb.auug.org.au>
In-Reply-To: <CAPcyv4jtNXhMwCqpbKkHe5e-nDPK+2Wq=maFsB_SMSGyg7fw5w@mail.gmail.com>
References: <CAKMK7uHjA27K8y-kwYFyhLy3cSkJJw8Oe1gP=3hZXdfxcWAcNQ@mail.gmail.com>
        <20180502194632.GB18390@sasha-vm>
        <20180503020550.GP2714@sirena.org.uk>
        <20180503031000.GC29205@thunk.org>
        <0276fcda-0385-8f22-dbdb-e063f7ed8bbe@roeck-us.net>
        <20180503224217.GR2714@sirena.org.uk>
        <20180503230905.GA98604@atomide.com>
        <CAPDyKFrCKkRHwOh-7yfFbvMp+Ykhs7oXrDwhTShSPvUBvpn2ZQ@mail.gmail.com>
        <20180509084440.GW13402@sirena.org.uk>
        <CAKMK7uEWYmhA3owSeYM9tNA0tpMm5=4Yqda2j=VfMWi7i8ya8w@mail.gmail.com>
        <20180509090346.GY13402@sirena.org.uk>
        <20180509204727.7ff38021@canb.auug.org.au>
        <CAPcyv4jtNXhMwCqpbKkHe5e-nDPK+2Wq=maFsB_SMSGyg7fw5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/KyNS2/d6MOKSvSK194yyHAA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mark Brown <broonie@kernel.org>, "w@1wt.eu" <w@1wt.eu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ksummit-discuss@lists.linuxfoundation.org" <ksummit-discuss@lists.linuxfoundation.org>, Greg KH <gregkh@linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

--Sig_/KyNS2/d6MOKSvSK194yyHAA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Wed, 9 May 2018 09:04:31 -0700 Dan Williams <dan.j.williams@intel.com> w=
rote:
>
> Please add:
>=20
>     git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git
> libnvdimm-fixes
>=20
> We currently merge this into libnvdimm-for-next for -next coverage,
> and resolve any conflicts vs new development. Do you want to see those
> conflicts? Otherwise I would recommend only pulling libnvdimm-for-next
> for -next and libnvdimm-fixes for this new -next-fixes effort.

The conflicts are usually fine (but if you do the merges, I won't see
them - which is even better :-)).  I like to have the fixes branches in
linux-next so that noone has to worry about probelsm in Linus' tree
that have pending fixes already.

Added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgement of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/KyNS2/d6MOKSvSK194yyHAA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlrzbXUACgkQAVBC80lX
0GwzAgf/TxQI4NrJdZFoI7Y//UmYxwfeeSgkLWVg4aKZOOJPzX93qoqf+uLItfGn
RGKO51U4QQ+CFurwUXGuLOnjTKB2/ehyZYjDxj/UVsp709bDd+1A0vctYf8coYvn
dmPL+CpX9cLwl8w+FpP1ehy9wxDHlZich7Jh8fspSC34NZ/CuVSFn4e2QpTaq9zb
rJ2OaZ6Zy/t0+y/dFWtJD+o10Kp6aK4SXdF3o9sBEc9hp/nEBipVBK0BFnSYRbfo
4xfFh26jpvRLRV64JyK8kzsOJmn6mQRktV6xEEoeN9dDRH1XawwJVSAh7Rb4Xhri
/9UyA5kh8GCOqE8mQOuie/iO3IGFow==
=Sccc
-----END PGP SIGNATURE-----

--Sig_/KyNS2/d6MOKSvSK194yyHAA--
