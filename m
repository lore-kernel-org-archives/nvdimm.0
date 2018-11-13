Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 13 Nov 2018 23:10:14 +0100
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [driver-core PATCH v6 2/9] async: Add support for queueing on
 specific NUMA node
Message-ID: <20181113221014.GB2235@amd>
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170041079.12967.13132220574997822111.stgit@ahduyck-desk1.jf.intel.com>
 <20181111193208.GB8332@kroah.com>
 <20181111195903.GA9726@amd>
 <20181111203304.GA16871@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aVD9QWMuhilNxW9f"
Content-Disposition: inline
In-Reply-To: <20181111203304.GA16871@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, tj@kernel.org, akpm@linux-foundation.org, linux-pm@vger.kernel.org, jiangshanlai@gmail.com, rafael@kernel.org, len.brown@intel.com, zwisler@kernel.org, dan.j.williams@intel.com, dave.jiang@intel.com, bvanassche@acm.org
List-ID: <linux-nvdimm@lists.01.org>


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > > ---
> > >=20
> > > No one else from Intel has reviewed/verified this code at all?
> > >=20
> > > Please take advantages of the resources you have that most people do
> > > not, get reviewes from your coworkers please before you send this out
> > > again, as they can give you valuable help before the community has to
> > > review the code...
> >=20
> > We always said to companies we want to see code as soon as
> > possible. You don't have to review their code, but discouraging the
> > posting seems wrong.
>=20
> I have a long history of Intel using me for their basic "find the
> obvious bugs" review process for new driver subsystems and core changes.
> When I see new major patches show up from an Intel developer without
> _any_ other review from anyone else, directed at me, I get suspicious it
> is happening again.
>=20
> If you note, Intel is the _only_ company I say this to their developers
> because of this problem combined with the fact that they have a whole
> load of developers that they should be running things by first.
>=20
> And yes, to answer Dan's point, we do want to do review in public.  But
> this is v6 of a core patchset and there has been NO review from anyone
> else at Intel on this.  So if that review was going to happen, one would
> have thought it would have by now, instead of relying on me to do it.
>=20
> And yes, I am grumpy, but I am grumpy because of the history here.  I am
> not trying to discourage anything, only to take ADVANTAGE of resources
> that almost no other company provides.
>=20
> Hope this helps explain my statement here.

Thanks for explanation. I did not have same bad experience with Intel,
so I did not understand what was going on.

Best regards,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--aVD9QWMuhilNxW9f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlvrS8YACgkQMOfwapXb+vKXDACfRF940tdVtPFWr2eNlsV9g5xo
fPQAnAiV3u4EVf2YtSl7wU1bP7fIeP/X
=PK1K
-----END PGP SIGNATURE-----

--aVD9QWMuhilNxW9f--
