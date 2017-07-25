From: Rik van Riel <riel@redhat.com>
Subject: Re: KVM "fake DAX" flushing interface - discussion
Date: Tue, 25 Jul 2017 16:59:35 -0400
Message-ID: <1501016375.26846.21.camel@redhat.com>
References: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
         <1500818683.4073.31.camel@redhat.com>
         <CAPcyv4h5O4D2kp6SJhWiz4V=dOLDa_Q3pk2B=u-x7hKKQqdXsQ@mail.gmail.com>
         <1500833428.4073.36.camel@redhat.com>
         <CAPcyv4hpbk0jgp+mA=q05zVBV8ZSZvCvV68JJ4gjE3QhK70d1w@mail.gmail.com>
         <20170724102330.GE652@quack2.suse.cz>
         <1157879323.33809400.1500897967669.JavaMail.zimbra@redhat.com>
         <20170724123752.GN652@quack2.suse.cz>
         <1888117852.34216619.1500992835767.JavaMail.zimbra@redhat.com>
         <CAPcyv4in28F3FOVKp9abvrggxPuXdbGynF5=ZvBXCrywoa06JA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-0yV1qDWO2FxT0D2yrVqZ"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4in28F3FOVKp9abvrggxPuXdbGynF5=ZvBXCrywoa06JA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Pankaj Gupta <pagupta@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Stefan Hajnoczi <stefanha@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, kvm-devel <kvm@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, ross zwisler <ross.zwisler@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, Haozhong Zhang <haozhong.zhang@intel.com>, Ross Zwisler <ross.zwisler@intel.com>
List-Id: linux-nvdimm@lists.01.org


--=-0yV1qDWO2FxT0D2yrVqZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-07-25 at 07:46 -0700, Dan Williams wrote:
> On Tue, Jul 25, 2017 at 7:27 AM, Pankaj Gupta <pagupta@redhat.com>
> wrote:
> >=20
> > Looks like only way to send flush(blk dev) from guest to host with
> > nvdimm
> > is using flush hint addresses. Is this the correct interface I am
> > looking?
> >=20
> > blkdev_issue_flush
> > =C2=A0submit_bio_wait
> > =C2=A0 submit_bio
> > =C2=A0=C2=A0=C2=A0=C2=A0generic_make_request
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pmem_make_request
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0...
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (b=
io->bi_opf & REQ_FLUSH)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0nvdimm_flush(nd_region);
>=20
> I would inject a paravirtualized version of pmem_make_request() that
> sends an async flush operation over virtio to the host. Don't try to
> use flush hint addresses for this, they don't have the proper
> semantics. The guest should be allowed to issue the flush and receive
> the completion asynchronously rather than taking a vm exist and
> blocking on that request.

That is my feeling, too. A slower IO device benefits
greatly from an asynchronous flush mechanism.

--=20
All rights reversed
--=-0yV1qDWO2FxT0D2yrVqZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJZd7E3AAoJEM553pKExN6DyR0H/jCXdUHi8A0l9aysr2waOPQ+
IjABA2T0vyG9QqufzE268g9NO7W9a79k0wcwvtU8S6P/7MUE6DU8ZLDvbQW+M3Td
VxBL9DmthzJFJy8/3EGvTUU+sEB1Qm8EeGu844ME8Ea6/rPHJwjHG/shnmocHeyl
G4Mpvc+zzz2WvZSwpsWtodon7jYfWY7NpPHp/JjwMfIVTErTFpSDZsTKpneFs9aC
s2EwM5WyuLlGt9bEPhQe9eQMiGeHsz5hLnO/9HdUZ8Let61bCGrZ5gn+yg0FHit7
lvQFPh1FxjWdFiRNYcAtFOATHWsNhhMWgRUZ2+GX3JKABDa+/LVaRYqtFDErmz8=
=usoe
-----END PGP SIGNATURE-----

--=-0yV1qDWO2FxT0D2yrVqZ--
