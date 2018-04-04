Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 5 Apr 2018 09:19:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [v8, 11/18] mm, dax: enable filesystems to trigger dev_pagemap
 ->page_free callbacks
Message-ID: <20180405091946.7ca20ead@canb.auug.org.au>
In-Reply-To: <CAPcyv4jd+aSzMvGHJ6O8K5vJ+qmH=XU2i2bzsGvZENXnkpM7=g@mail.gmail.com>
References: <152246898837.36038.26895928842345061.stgit@dwillia2-desk3.amr.corp.intel.com>
        <20180404212340.GA12737@outlook.office365.com>
        <CAPcyv4jknruAmkPEVx0X6Bd3uRs_FYdPf-W-5cDO1Z+kaG5+uw@mail.gmail.com>
        <CAPcyv4jd+aSzMvGHJ6O8K5vJ+qmH=XU2i2bzsGvZENXnkpM7=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/sgDCFHZZhV61WXqrqZ/wP=B"; protocol="application/pgp-signature"
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrei Vagin <avagin@virtuozzo.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Michal Hocko <mhocko@suse.com>, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, david <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

--Sig_/sgDCFHZZhV61WXqrqZ/wP=B
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Wed, 4 Apr 2018 14:35:20 -0700 Dan Williams <dan.j.williams@intel.com> w=
rote:
>
> New branch pushed out with this offending commit removed.

Thanks, I refetched.

--=20
Cheers,
Stephen Rothwell

--Sig_/sgDCFHZZhV61WXqrqZ/wP=B
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlrFXZIACgkQAVBC80lX
0GzkHwgAoJUYgLchV2FPkM6kN5+QkaSI/dMQ571cQ+bs5JkrfAkANCdIr1LNVk5p
JxFaMZccM3i4K/6t+/h84UowZV6Qk3W2GkrPhxUpFKsCWEc3w4wXrZRN71c4rM5D
FIHHwY29bOj3wiP5ngOTFFR0D8F8cnrOD2k+bTetaNpCbuJ63am+I8NiI15qfzU3
n5J+S+Ra7m4aCBi3n/pQqTKWKJehpjE3FSd5qwepBLXLsCXiQtcDzIT1+U0vvX27
b/F2UAoOwZa8EZCsBCSDzQD5PX6/vSwk11hXkoveRhyhy7P8YOniRin8u/KOefsl
+8T7T2oYf/74PSICuIObkzEf9ZSQHQ==
=nbIL
-----END PGP SIGNATURE-----

--Sig_/sgDCFHZZhV61WXqrqZ/wP=B--
