From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: Questions about vNVDIMM on qemu/KVM
Date: Fri, 1 Jun 2018 12:54:29 +0100
Message-ID: <20180601115429.GL8687@stefanha-x1.localdomain>
References: <20180523140809.622F.E1E9C6FF@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2EnvhqpWJq810sZn"
Return-path: <qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <20180523140809.622F.E1E9C6FF@jp.fujitsu.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org
Sender: "Qemu-devel"
	<qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Pankaj Gupta <pagupta@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, qemu-devel@nongnu.org, NVDIMM-ML <linux-nvdimm@lists.01.org>
List-Id: linux-nvdimm@lists.01.org


--2EnvhqpWJq810sZn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 23, 2018 at 02:08:12PM +0900, Yasunori Goto wrote:
> Hello,

CCing Pankaj, who is developing virtio-pmem and may have comments beyond
what has already been discussed.

> I'm investigating status of vNVDIMM on qemu/KVM,
> and I have some questions about it. I'm glad if anyone answer them.
>=20
> In my understanding, qemu/KVM has a feature to show NFIT for guest,
> and it will be still updated about platform capability with this patch se=
t.
> https://lists.gnu.org/archive/html/qemu-devel/2018-05/msg04756.html
>=20
> And libvirt also supports this feature with <memory model=3D'nvdimm'>
> https://libvirt.org/formatdomain.html#elementsMemory
>=20
>=20
> However, virtio-pmem is developing now, and it is better
> for archtectures to detect regions of NVDIMM without ACPI (like s390x)
> In addition, It is also necessary to flush guest contents on vNVDIMM
> who has a backend-file.=20
>=20
>=20
> Q1) Does ACPI.NFIT bus of qemu/kvm remain with virtio-pmem?=20
>     How do each roles become it if both NFIT and virtio-pmem will be avai=
lable?
>     If my understanding is correct, both NFIT and virtio-pmem is used to
>     detect vNVDIMM regions, but only one seems to be necessary....
>=20
>     Otherwize, is the NFIT bus just for keeping compatibility,=20
>     and virtio-pmem is promising way?
>=20
>    =20
> Q2) What bus is(will be?) created for virtio-pmem?
>     I could confirm the bus of NFIT is created with <memory model=3D'nvdi=
mm'>,
>     and I heard other bus will be created for virtio-pmem, but I could not
>     find what bus is created concretely.
>     ---
>       # ndctl list -B
>       {
>          "provider":"ACPI.NFIT",
>          "dev":"ndbus0"
>       }
>     ---
>   =20
>     I think it affects what operations user will be able to, and what=20
>     notification is necessary for vNVDIMM.=20
>     ACPI defines some operations like namespace controll, and notification
>     for NVDIMM health status or others.
>     (I suppose that other status notification might be necessary for vNVD=
IMM,
>      but I'm not sure yet...)
>=20
> If my understanding is wrong, please correct me.
>=20
> Thanks,
> ---
> Yasunori Goto
>=20
>=20
>=20

--2EnvhqpWJq810sZn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJbETP1AAoJEJykq7OBq3PIAToH/0iQQq1xrjtmm9Pei8pYlY+X
nyA9L2Q4VhEla9wurFPtksJrKq8aDjou/JwaciD4LNqKWBXR0WNp5j7HNDFe6Jez
4Kax0uUrCra7PKnFr4fK6EZq7JJF/3gT+Pkr0r2Q/hBLCGYgeMjVN2fnIV3Hyl3p
ZeKfluimW/8rfCsZxqorRRcZCo6//pJtnTx+HEbmThD5RIeFtAN7yK1rNzWMMWYr
Ncmb69ktN0CC2kn7pCF5VfjaSrM1MUFcpUXTGU5ENE5pQ+ox0gggh38jSmVm1XUu
24gDBZxnm3QIVGiYOVFisalpxDlkGcIAJA0OhGbI38hzkTLiEbCBl0zyf5IUB3c=
=xGxs
-----END PGP SIGNATURE-----

--2EnvhqpWJq810sZn--
