Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sun, 11 Nov 2018 15:31:59 +0100
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [driver-core PATCH v5 5/9] driver core: Establish clear order of
 operations for deferred probe and remove
Message-ID: <20181111143159.GD5215@amd>
References: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
 <154145232484.29224.1635232599636954462.stgit@ahduyck-desk1.jf.intel.com>
 <1541548114.196084.195.camel@acm.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="P+33d92oIH25kiaB"
Content-Disposition: inline
In-Reply-To: <1541548114.196084.195.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, linux-nvdimm@lists.01.org, tj@kernel.org, akpm@linux-foundation.org, linux-pm@vger.kernel.org, jiangshanlai@gmail.com, rafael@kernel.org, len.brown@intel.com, zwisler@kernel.org, dan.j.williams@intel.com, dave.jiang@intel.com
List-ID: <linux-nvdimm@lists.01.org>


--P+33d92oIH25kiaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > One change I made in addition is I replaced the use of "bool X:1" to de=
fine
> > the bitfield to a "u8 X:1" setup in order to resolve some checkpatch
> > warnings.
>=20
> Please use "bool X:1" instead of "u8 X:1". I think it was a bad idea to m=
ake
> checkpatch complain about "bool X:1" since "bool X:1" should only be avoi=
ded
> in structures for which alignment must be architecture-independent. For s=
truct
> device it is fine if member alignment differs per architecture. Additiona=
lly,
> changing "bool X:1" into "u8 X:1" will reduce performance on architecture=
s that
> cannot do byte addressing.

Should we introduce typedef bit boolean "bbool" and set it
appropriately, so that architecture sets it "right" and people just
use it?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--P+33d92oIH25kiaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlvoPV8ACgkQMOfwapXb+vKjbwCcC2HroQ2q5IEFmvjSgMUcgKe9
ER8An24GZBL1gBzqPvaJrEdnCuOL5Ixz
=5axe
-----END PGP SIGNATURE-----

--P+33d92oIH25kiaB--
