Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sun, 18 Nov 2018 09:00:03 +0200
From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [Ksummit-discuss] [RFC PATCH 3/3] libnvdimm, MAINTAINERS:
 Subsystem Profile
Message-ID: <20181118070003.GF24359@mtr-leonro.mtl.com>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225761038.2499188.1270468803677883744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAMuHMdVOJsM=66RrnbOzVthsT9=dFRQtL2rv99tCPC02M=hiXw@mail.gmail.com>
 <20181115061036.1575223d@silica.lan>
 <20181115162008.GO3759@mtr-leonro.mtl.com>
 <20181115110919.46978343@silica.lan>
 <20181115193520.GA24359@mtr-leonro.mtl.com>
 <20181116033258.23992cde@silica.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mrJd9p1Ce66CJMxE"
Content-Disposition: inline
In-Reply-To: <20181116033258.23992cde@silica.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>, ksummit-discuss@lists.linuxfoundation.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, vishal.l.verma@intel.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>


--mrJd9p1Ce66CJMxE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 16, 2018 at 03:33:17AM -0800, Mauro Carvalho Chehab wrote:
> Em Thu, 15 Nov 2018 21:35:20 +0200
> Leon Romanovsky <leon@kernel.org> escreveu:
>
> > On Thu, Nov 15, 2018 at 11:09:34AM -0800, Mauro Carvalho Chehab wrote:
> > > Em Thu, 15 Nov 2018 18:20:08 +0200
> > > Leon Romanovsky <leon@kernel.org> escreveu:
> > >
> > > > On Thu, Nov 15, 2018 at 06:10:36AM -0800, Mauro Carvalho Chehab wrote:
> > > > > Em Thu, 15 Nov 2018 09:03:11 +0100
> > > > > Geert Uytterhoeven <geert@linux-m68k.org> escreveu:
> > > > >
> > > > > > Hi Dan,
> > > > > >
> > > > > > On Thu, Nov 15, 2018 at 6:06 AM Dan Williams <dan.j.williams@intel.com> wrote:
> > > > > > > Document the basic policies of the libnvdimm subsystem and provide a
> > > > > > > first example of a Subsystem Profile for others to duplicate and edit.
> > > > > > >
> > > > > > > Cc: Ross Zwisler <zwisler@kernel.org>
> > > > > > > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > > > > > > Cc: Dave Jiang <dave.jiang@intel.com>
> > > > > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > > >
> > > > > > Thanks for your patch!
> > > > > >
> > > > > > > --- /dev/null
> > > > > > > +++ b/Documentation/nvdimm/subsystem-profile.rst
> > > > > >
> > > > > > > +Trusted Reviewers
> > > > > > > +-----------------
> > > > > > > +Johannes Thumshirn
> > > > > > > +Toshi Kani
> > > > > > > +Jeff Moyer
> > > > > > > +Robert Elliott
> > > > > >
> > > > > > Don't you want to add email addresses?
> > > > > > Only the first one is listed in MAINTAINERS.
> > > > >
> > > > > IMO, it makes sense to have their e-mails here, in a way that it could
> > > > > easily be parsed by get_maintainers.pl.
> > > >
> > > > I personally think that list of "trusted reviewers" makes more harm than
> > > > good. It creates unneeded negative feelings to those who wanted to be in
> > > > this list, but for any reason they don't. Those reviewers will feel
> > > > "untrusted".
> > >
> > > Yeah, perhaps something like "most active reviewers" would sound
> > > better.
> >
> > I would recommend to remove this section at all.
> > New maintainers won't come out of blue, but will be come
> > from existing community and such individuals for sure will see
> > and judge by themselves to whom they trust and to whom not.
>
> I see your point, but, on the other hand, having a list with the ones
> that are actively doing reviews helps newcomers.
>
> I would keep, but perhaps it makes sense to add some notice about a
> criteria about how to be included at the "active reviewers" list,
> (the criteria probably belongs to the subsystem profile), e. g.
> something like:
>
> 	"Active reviewers are developers that contribute with more than 25
> 	 patches per year and do more than 50 reviews per year on
> 	 on patches written for drivers that they're not usual contributors"

Someone will need to maintain it and it looks to me like over complication.
I think that get_maintainer.pl already provides at least part of needed
information, but definitely not in very intuitive way.

It is worth to document get_maintainers.pl and update it to create the
list of "trusted reviewers".

Thanks

> Cheers,
> Mauro

--mrJd9p1Ce66CJMxE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb8Q3zAAoJEORje4g2clin64cQAL+coaR5IJ3eO+Wnix/Y+6/j
X9tqw0WOHUtG5pUp4cdi5O9fS24qkjq6W46zpb+EqsFB/lgaD6PbDOEDvKvU/Nm6
nRJu3bWhiDl4hxYY7YNmmqOydh6IvQ+s1CXdC7r3eUFlUWjL90Zhf2BkHWrlJnMp
KughstVEnfRgoJhZhVlkfquu6kbVVuYRwLGm57rlJYKLZ8dPlUPhFOTGCrIWflq7
Gj380JQ4O0k88WnvdVpkFEGVYDxZg6dJOIZ4/V+ghDubIQJg0dJnZ/Sb6DgEJ+sB
ry8yL0LO6Xa0Tyz7OwCLP+n/s1IhOJW44b4mOf0hRtxtrZnTGIBqENTH2H66WNNq
tT8lTADTep1nqFAf6/hxDZqBwMcrzKM7/4KiAoltPAQaywFEEVQLv9eu+hcc4l2i
2GEOQMKz3eC4QY0s+I60xMrqy/CsIDp5tDIAWZ4RmiumOiuPIeLo+8RNu4b0l5TV
ZtpcMac5Sl07SLRupKB++Wa+5HfL8d8sGZZA+eJ8qimiPyDg7sqq0LJm9sZ0YZrC
z4LNABKfJ1gsDkC2avL9BD2wGfwnKxnkZADvkgOwf5C/PSIczVMcmBrNVzO0OZqw
QU+2UnRMLXW8vkXrBBrpa9aJu9vxRB70G3+a5hR8X05lstR57eF+nTMYDdfuQP0h
Vwxu4GiVTV9xNL9vwbnu
=WMtp
-----END PGP SIGNATURE-----

--mrJd9p1Ce66CJMxE--
