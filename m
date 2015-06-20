Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sat, 20 Jun 2015 22:40:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v7 00/16] libnvdimm: non-volatile memory devices
Message-ID: <20150620224026.582616fe@canb.auug.org.au>
In-Reply-To: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/cF97qF+0vI8J8kmt_K4.TyC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Boaz Harrosh <boaz@plexistor.com>, rafael@kernel.org, neilb@suse.de, Lv Zheng <lv.zheng@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, mingo@kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, hch@lst.de, linux-acpi@vger.kernel.org, jmoyer@redhat.com, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, axboe@kernel.dk, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, linux-api@vger.kernel.org, akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

--Sig_/cF97qF+0vI8J8kmt_K4.TyC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Wed, 17 Jun 2015 19:13:19 -0400 Dan Williams <dan.j.williams@intel.com> =
wrote:
>
> A new sub-system in support of non-volatile memory storage devices.
>=20
> Stephen, please add libnvdimm-for-next to -next:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm libnvdimm-for=
-next

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
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

--Sig_/cF97qF+0vI8J8kmt_K4.TyC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVhV9AAAoJEMDTa8Ir7ZwVjPUP/1cZUb9/UBIZ5ybxzgc2yro6
5btwHuMB68JTMUUXHP5R/Ovla0RQHwaoHR3eJxF1X1kM+UKjFdX86in5HFGC7W5b
pfXTc37hucTpbtYZguIKyEu78i02tL9z2tfiuSQ0kJCnTqQ5Ae/uHwaZrK6LTpy9
x2AfF0XVcOi2oVdg+uc7WWiAMBylOsjrBMPBKZklfyaRPZ7Qo+volJDVTFIIXRnZ
HCZoRSkxiE0fMHBqRqL/7OPlYqrFBvhIpFk0t+TKwsANaPKNlKVuvh27TD/mkXiI
KIKatykIQsbr/iWBm/F81gcOjqPJFioGP0dm2TlVsMHKdbFv+Fi+WSHeufiBqBwY
IZGiuY5kr4UQeeXQJN4sUgPmrYZr8508lr3CZwUWIRr3xB+rQGdbV2Y3+nvHMpAi
q7unS8u/C4nxx+7lzlJWGHcURuejgVO/Lg1xZSZpb26kyIybKE68HBXfridnAej/
DViONYHU/DcwptB9ucObXvp3nWQkJ0NpV+9CwVQWlrkoerE4nM6mK1FN9YZm2sHn
je3ozE8Scsngw6KGqEFLxJUK+XogrGkMXAF/fxMKzYkr9CTr27hHcQyUpDx7/zlU
xMlhmXT9IqqYu3tYls8t488N+qaTy3pkJgOKVXtpWcxgkWnSz3253Du/yqA2amKH
4KLXIoSANioA6efVD5Vw
=1qeW
-----END PGP SIGNATURE-----

--Sig_/cF97qF+0vI8J8kmt_K4.TyC--
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
