From: Rik van Riel <riel@redhat.com>
Subject: Re: KVM "fake DAX" flushing interface - discussion
Date: Wed, 26 Jul 2017 17:27:33 -0400
Message-ID: <1501104453.26846.45.camel@redhat.com>
References: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
         <CAPcyv4hpbk0jgp+mA=q05zVBV8ZSZvCvV68JJ4gjE3QhK70d1w@mail.gmail.com>
         <20170724102330.GE652@quack2.suse.cz>
         <1157879323.33809400.1500897967669.JavaMail.zimbra@redhat.com>
         <20170724123752.GN652@quack2.suse.cz>
         <1888117852.34216619.1500992835767.JavaMail.zimbra@redhat.com>
         <CAPcyv4in28F3FOVKp9abvrggxPuXdbGynF5=ZvBXCrywoa06JA@mail.gmail.com>
         <1501016375.26846.21.camel@redhat.com>
         <1063764405.34607875.1501076841865.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-JYusrPMC9q1mTsTTcAte"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1063764405.34607875.1501076841865.JavaMail.zimbra@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Pankaj Gupta <pagupta@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Stefan Hajnoczi <stefanha@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, kvm-devel <kvm@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, ross zwisler <ross.zwisler@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, Haozhong Zhang <haozhong.zhang@intel.com>, Ross Zwisler <ross.zwisler@intel.com>
List-Id: linux-nvdimm@lists.01.org


--=-JYusrPMC9q1mTsTTcAte
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-07-26 at 09:47 -0400, Pankaj Gupta wrote:
> >=20
> Just want to summarize here(high level):
>=20
> This will require implementing new 'virtio-pmem' device which
> presents=C2=A0
> a DAX address range(like pmem) to guest with read/write(direct
> access)
> & device flush functionality. Also, qemu should implement
> corresponding
> support for flush using virtio.
>=20
Alternatively, the existing pmem code, with
a flush-only block device on the side, which
is somehow associated with the pmem device.

I wonder which alternative leads to the least
code duplication, and the least maintenance
hassle going forward.

--=20
All rights reversed
--=-JYusrPMC9q1mTsTTcAte
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJZeQlFAAoJEM553pKExN6DiSQH/1hmL95ousOGG7V/6Q2fhd+M
0PxKilryMGxgkwyqCJlYtsOlkgJfwr5BHNdQpyy0FEuUC6zbv1hQN9bcKmhjS7Ay
ix4JJ7Cc2GwYFO28olqdD3m8/kZZ4colOuJQH8aT+i/kxm1jHA4Sny0eqTkmblLG
SMAQlVIDlQjsMryknymzriiv9aCV0IEDWfUqcvidWH0mpf1TixGxAi0nosQAkzPz
8iCbsUt5ZiGNhbWIWIloIvMZwtFOW8rf+p/DwT9X3Rp8cCdCimHJDB9VnAugUnBP
v+a/pXGYaTiyyFm8dEIURNRLKufHlrZ/AORWGNjsPwpsTakcjLZuDg6B9wsBR80=
=KCNx
-----END PGP SIGNATURE-----

--=-JYusrPMC9q1mTsTTcAte--
