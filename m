Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 15 Nov 2018 18:20:08 +0200
From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [Ksummit-discuss] [RFC PATCH 3/3] libnvdimm, MAINTAINERS:
 Subsystem Profile
Message-ID: <20181115162008.GO3759@mtr-leonro.mtl.com>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225761038.2499188.1270468803677883744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAMuHMdVOJsM=66RrnbOzVthsT9=dFRQtL2rv99tCPC02M=hiXw@mail.gmail.com>
 <20181115061036.1575223d@silica.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BghK6+krpKHjj+jk"
Content-Disposition: inline
In-Reply-To: <20181115061036.1575223d@silica.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Dave Jiang <dave.jiang@intel.com>, ksummit-discuss@lists.linuxfoundation.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, vishal.l.verma@intel.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>


--BghK6+krpKHjj+jk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 15, 2018 at 06:10:36AM -0800, Mauro Carvalho Chehab wrote:
> Em Thu, 15 Nov 2018 09:03:11 +0100
> Geert Uytterhoeven <geert@linux-m68k.org> escreveu:
>
> > Hi Dan,
> >
> > On Thu, Nov 15, 2018 at 6:06 AM Dan Williams <dan.j.williams@intel.com> wrote:
> > > Document the basic policies of the libnvdimm subsystem and provide a
> > > first example of a Subsystem Profile for others to duplicate and edit.
> > >
> > > Cc: Ross Zwisler <zwisler@kernel.org>
> > > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > > Cc: Dave Jiang <dave.jiang@intel.com>
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >
> > Thanks for your patch!
> >
> > > --- /dev/null
> > > +++ b/Documentation/nvdimm/subsystem-profile.rst
> >
> > > +Trusted Reviewers
> > > +-----------------
> > > +Johannes Thumshirn
> > > +Toshi Kani
> > > +Jeff Moyer
> > > +Robert Elliott
> >
> > Don't you want to add email addresses?
> > Only the first one is listed in MAINTAINERS.
>
> IMO, it makes sense to have their e-mails here, in a way that it could
> easily be parsed by get_maintainers.pl.

I personally think that list of "trusted reviewers" makes more harm than
good. It creates unneeded negative feelings to those who wanted to be in
this list, but for any reason they don't. Those reviewers will feel
"untrusted".

Thanks

--BghK6+krpKHjj+jk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb7Zy4AAoJEORje4g2clindrgP/1qcVPjXlzT/2KPN0TVNBnWU
znL7sRQ1QhswSAfRNWdSyqR4/15ANb8wz6lV4p22d+p/NuswrYRMqxWA5X6XTjUc
L8Y8SQPMXIaGnlY7hUjY2FSnYSyK+sW71zZe6ys6ciDEmXhJYZGYx+kY2OENZ9K2
lTIsQg5EPVNKP7lE9mMYe17ga1ctCDCzIuhvBLoIw7bHPHyefc4YCWRFJXh24vsn
DnUZXzfg8WLie/PcdWAqkQlCPkG784+d6jAaiEHIe4iel4nJfXf1tzdwaUUSPq4U
0Ri2m9l1KtdJHug1UV+/JFcQIq9I+M/rdjSqIkcZrKj1YIwKp39wqOzRe+bIVA0u
/SY0zI0osAjDyWV5HrQRJko7XlXFlJxoqJLW/rGa2B3E3pigyAxoIj/Cs5alxJQg
HYjjaktPfGWgW9i4/8IK2BJM8GdDbdG8qQe1v2neFPgbGC6tBGZMP9Rx/oXeq1NW
UXj4wPzGczoXxmzKgrNLviEgL7UfRD31gMl6vO1wxhkVsMzGhdyB80awqQWSTSek
7MztMEC0OM2aL043qrdH5oBqzCDgUaQL3KEY2O/r+BirBe1VlUpD3mW8sBvJ8gYs
WaiDPE3zkaQkYJYvIctnOrJKi9cm1DSo1GCN6xQrA3+hBWAULUUyI0fmG0S3ftrc
JOhcb8uIgYycsbk3MBdk
=/bPL
-----END PGP SIGNATURE-----

--BghK6+krpKHjj+jk--
