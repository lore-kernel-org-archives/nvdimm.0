Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sun, 25 Nov 2018 11:57:54 +0100
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH 0/3] Maintainer Handbook: Subsystem Profile
Message-ID: <20181125105754.GB25471@amd>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>, Dave Jiang <dave.jiang@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Linus Torvalds <torvalds@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>, Vishal Verma <vishal.l.verma@intel.com>, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ross Zwisler <zwisler@kernel.org>, Joe Perches <joe@perches.com>, "Tobin C. Harding" <me@tobin.cc>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steve French <stfrench@microsoft.com>, Olof Johansson <olof@lixom.net>, linux-nvdimm@lists.01.org, ksummit-discuss@lists.linuxfoundation.org
List-ID: <linux-nvdimm@lists.01.org>


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2018-11-14 20:53:13, Dan Williams wrote:
> At a recently concluded session at the Linux Plumbers Conference I
> proposed a "Subsystem Profile" as a document that a maintainer can
> provide to set contributor expectations and provide fodder for a
> discussion between maintainers about the merits of different maintainer
> policies.
>=20
> For those that did not attend, the goal of the Subsystem Profile, and the
> Maintainer Handbook more generally, is to provide a desk reference for
> maintainers both new and experienced. The session introduction was:
>=20
>     The first rule of kernel maintenance is that there are no hard and
>     fast rules. That state of affairs is both a blessing and a curse. It
>     has served the community well to be adaptable to the different
>     people and different problem spaces that inhabit the kernel
>     community. However, that variability also leads to inconsistent
>     experiences for contributors, little to no guidance for new
>     contributors, and unnecessary stress on current maintainers. There
>     are quite a few of people who have been around long enough to make
>     enough mistakes that they have gained some hard earned proficiency.
>     However if the kernel community expects to keep growing it needs to
>     be able both scale the maintainers it has and ramp new ones without
>     necessarily let them make a decades worth of mistakes to learn the
>     ropes.=20
>=20
> To be clear, the proposed document does not impose or suggest new
> rules. Instead it provides an outlet to document the unwritten rules
> and policies in effect for each subsystem, and that each subsystem
> might decide differently for whatever reason.

Sounds like a new rules to me :-(, making submitting simple patches
harder.

It would be good if the rules were similar / same accross the
subsystems, documenting "it is okay to be different" is not really helpful.


									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlv6gDIACgkQMOfwapXb+vIHpACeMr/5ZBBOd8P13v1FJdbu09st
8jwAoLVfTBCtCF/7C+p9+kZKxV4DKggb
=utEq
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
