Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sun, 18 Nov 2018 09:12:54 +0200
From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [Ksummit-discuss] [RFC PATCH 3/3] libnvdimm, MAINTAINERS:
 Subsystem Profile
Message-ID: <20181118071254.GG24359@mtr-leonro.mtl.com>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225761038.2499188.1270468803677883744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAMuHMdVOJsM=66RrnbOzVthsT9=dFRQtL2rv99tCPC02M=hiXw@mail.gmail.com>
 <20181115061036.1575223d@silica.lan>
 <20181115162008.GO3759@mtr-leonro.mtl.com>
 <20181115110919.46978343@silica.lan>
 <20181115193520.GA24359@mtr-leonro.mtl.com>
 <3908561D78D1C84285E8C5FCA982C28F7D459E55@ORSMSX110.amr.corp.intel.com>
 <e4efcfd8c99ef197714230cb1eb246b39dc83151.camel@perches.com>
 <20181116033947.5689b51c@silica.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="m0vRWufqUC70IDnR"
Content-Disposition: inline
In-Reply-To: <20181116033947.5689b51c@silica.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Joe Perches <joe@perches.com>, "Luck, Tony" <tony.luck@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "ksummit-discuss@lists.linuxfoundation.org" <ksummit-discuss@lists.linuxfoundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Verma, Vishal L" <vishal.l.verma@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "zwisler@kernel.org" <zwisler@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>


--m0vRWufqUC70IDnR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 16, 2018 at 03:39:47AM -0800, Mauro Carvalho Chehab wrote:
> Em Thu, 15 Nov 2018 11:43:51 -0800
> Joe Perches <joe@perches.com> escreveu:
>
> > On Thu, 2018-11-15 at 19:40 +0000, Luck, Tony wrote:
> > > > I would recommend to remove this section at all.
> > > > New maintainers won't come out of blue, but will be come
> > > > from existing community and such individuals for sure will see
> > > > and judge by themselves to whom they trust and to whom not.
> > >
> > > Perhaps this is more of a hint to contributors than to maintainers
> > > (see earlier discussion on who is the target audience for these documents).
> > >
> > > It would help contributors know some names of useful reviewers (and
> > > thus this list should be picked up by scripts/get_maintainer.pl to help
> > > the user compose Cc: lists for e-mail patches).
> >
> > Trusted reviewers should be specifically listed
> > in the MAINTAINERS file with an "R:" entry.
> >
> > get_maintainers should not look anywhere else.
>
> I know that making get_maintainers to look elsewhere can make it more
> complex and slower, but IMHO, by having a per-subsystem profile, this is
> unavoidable.
>
> The thing is that touching at a single MAINTAINERS file every time a new
> reviewer comes is painful. Also, MAINTAINERS file format doesn't allow
> adding free text explaining the criteria for someone to become a
> reviewer.

You are pointing to the actual problem -> someone needs to maintain such
lists, Removal of persons from that list won't be easy task too.

>
> IMO, having reviewers on a per-subsystem file, where one could explain
> the criteria for being added there will make easier to attract more
> reviewers.
>
> Cheers,
> Mauro

--m0vRWufqUC70IDnR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb8RD2AAoJEORje4g2clindZYQAJO+F1DrCC7+Lb+tjzA1DhIh
kntP2f98RI9aWZ2b84xhGImW1O9Q47zQaExcVHIiaJf4VD+wCrmU4BejsHj7HI2A
vKGsGjRXl03zplhGyQpDAemxPy5dNiyCh59fzMGulEWHD/DCZYuJlQwluvPpckgh
XrEkF8/1WpeIsLsI4PcPIb5R5XAwmIpFAq/+WAY94mynOTlaa5lXTxKtQrYso3As
jqpaR1PqnTKwt3b94ZS5ZmBLkeCjq4WeuY9eATs6Vzpn0ZSF/tNYilGatE0l0JEq
qw1AnVOFXRd+0WUIgHZi9SdWp/UQYl0wIRH/0/653pU5D6d6ggnBxJXUgsLdeFhE
NB1eje3XrDBtfZeCWjComMsYeKsyp6a1Orls7rY2/SxkHv07JfVkPxUBRwuF1v7v
7TQPyPeEAkYfcqz3ScTLojotrKYFK+rG5ga6vspD+rIQgl3SCbit8cANfOuSq72R
lc1iz/w0OXnMiBlAWT8KKKFP3RP964eMeOglm4i5zEexVHijW4ChaZYM9W2iidpK
VwGwouyrjak/c3wQGoB1JLb9Dr/Wmc8aaW8QJkoifzojTp0mBNDpk4tEiwhTUBNj
NG+fyYf0pD/kYM7TjqjB2W3VAzmoruPMHoGfXQCcxszsXqyl21nwbqwo/SZ2mfme
IA9RVHifSFSXyCjGjINW
=giYP
-----END PGP SIGNATURE-----

--m0vRWufqUC70IDnR--
