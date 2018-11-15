Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 15 Nov 2018 21:35:20 +0200
From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [Ksummit-discuss] [RFC PATCH 3/3] libnvdimm, MAINTAINERS:
 Subsystem Profile
Message-ID: <20181115193520.GA24359@mtr-leonro.mtl.com>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225761038.2499188.1270468803677883744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAMuHMdVOJsM=66RrnbOzVthsT9=dFRQtL2rv99tCPC02M=hiXw@mail.gmail.com>
 <20181115061036.1575223d@silica.lan>
 <20181115162008.GO3759@mtr-leonro.mtl.com>
 <20181115110919.46978343@silica.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20181115110919.46978343@silica.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Dave Jiang <dave.jiang@intel.com>, ksummit-discuss@lists.linuxfoundation.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, vishal.l.verma@intel.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 15, 2018 at 11:09:34AM -0800, Mauro Carvalho Chehab wrote:
> Em Thu, 15 Nov 2018 18:20:08 +0200
> Leon Romanovsky <leon@kernel.org> escreveu:
>
> > On Thu, Nov 15, 2018 at 06:10:36AM -0800, Mauro Carvalho Chehab wrote:
> > > Em Thu, 15 Nov 2018 09:03:11 +0100
> > > Geert Uytterhoeven <geert@linux-m68k.org> escreveu:
> > >
> > > > Hi Dan,
> > > >
> > > > On Thu, Nov 15, 2018 at 6:06 AM Dan Williams <dan.j.williams@intel.=
com> wrote:
> > > > > Document the basic policies of the libnvdimm subsystem and provid=
e a
> > > > > first example of a Subsystem Profile for others to duplicate and =
edit.
> > > > >
> > > > > Cc: Ross Zwisler <zwisler@kernel.org>
> > > > > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > > > > Cc: Dave Jiang <dave.jiang@intel.com>
> > > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > >
> > > > Thanks for your patch!
> > > >
> > > > > --- /dev/null
> > > > > +++ b/Documentation/nvdimm/subsystem-profile.rst
> > > >
> > > > > +Trusted Reviewers
> > > > > +-----------------
> > > > > +Johannes Thumshirn
> > > > > +Toshi Kani
> > > > > +Jeff Moyer
> > > > > +Robert Elliott
> > > >
> > > > Don't you want to add email addresses?
> > > > Only the first one is listed in MAINTAINERS.
> > >
> > > IMO, it makes sense to have their e-mails here, in a way that it could
> > > easily be parsed by get_maintainers.pl.
> >
> > I personally think that list of "trusted reviewers" makes more harm than
> > good. It creates unneeded negative feelings to those who wanted to be in
> > this list, but for any reason they don't. Those reviewers will feel
> > "untrusted".
>
> Yeah, perhaps something like "most active reviewers" would sound
> better.

I would recommend to remove this section at all.
New maintainers won't come out of blue, but will be come
=66rom existing community and such individuals for sure will see
and judge by themselves to whom they trust and to whom not.

Thanks

>
> Cheers,
> Mauro

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb7cp4AAoJEORje4g2clinjWwQAK++V4yQRc853j590uHyWtZI
yBJabMYXfdKMh6mjP7T81EokNT7A9rMcdENkd9F2WV3NGBmAllNl66an+M6CYxTs
ztPhhSGS1SqiO2Mm1yTTcvWHGsrnv/CDqGbWOOGfkx6632dbpPs5+2Dn0U3573al
+7T4Csuh3zTcoXpWkJedl2S2M16462CqTITdbzg5JAtHoGsvftHYzmowBmU5v8+8
9Ohn78v1nFxtR0eE5JFy7N+9w06CN+jfR2ykLp0t7jvolPp0h3rHgz9/PRvHjoBz
4yRnX4S9fyhtXIaMjPNdbxQz6J3I1b+0KdD4ALV8wN0oKr9fzs+44PZgnvfOYqaK
aLl60cUd3WgYhOsKNAHRh701x6oM5AereltDw1hyDnI8EHoGF/Q0E3nwHxpkqd3g
5iSjFfz2CuJy3CNM32OEVYkbOMvQ3JbnwE2tYQARt30MNlflGVbd7wgYi9fn+WWz
ttgGU2Jc5Q6djnPBaqtHF8uOZ/FSdrRHXx6QFL1sttb2wtuYCY78DPLSBkfbYc+2
+zTNhJnxSuMkfA2OizKg8jRBYBNTm10FteX70AENnIQ9nI/g6/McEnxwKH2L76BY
e7D52h4YoU/Faayjzds/13gjFPSueGw7XNP/8GyBmEzw8y/9WZty1sNhH9nGyvDd
wcBfMJH6iX9J4zDddBdT
=eIEo
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
