From: Eric Blake <eblake@redhat.com>
Subject: Re: [ndctl PATCH 0/8] dimm label space initialization
 support
Date: Wed, 19 Oct 2016 13:42:56 -0500
Message-ID: <6ceb7075-71fc-b725-8a1c-a7d8c727770e@redhat.com>
References: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="VAdnoSlUGIlqos2ARlCErFQNOCXDFtxf3"
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: "Qemu-devel" <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@ml01.01.org
Cc: vishal.l.verma@intel.com, qemu-devel@nongnu.org
List-Id: linux-nvdimm@lists.01.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VAdnoSlUGIlqos2ARlCErFQNOCXDFtxf3
From: Eric Blake <eblake@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@ml01.01.org
Cc: vishal.l.verma@intel.com, qemu-devel@nongnu.org
Message-ID: <6ceb7075-71fc-b725-8a1c-a7d8c727770e@redhat.com>
Subject: Re: [Qemu-devel] [ndctl PATCH 0/8] dimm label space initialization
 support
References: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/19/2016 11:47 AM, Dan Williams wrote:
> The 4.9 kernel added support for sub-dividing PMEM.  With this kernel
> patch [1] on top of that baseline, the PMEM-sub-division support can be=

> enabled for QEMU-KVM and any other platforms that advertise both un-ali=
ased
> PMEM regions and support for the label DSM commands [2].
>=20
> Given this increasing need to perform a label management operation
> across a set of DIMMs this update also adds glob(3) support.  For
> example you can now write commands like:
>=20
>     ndctl zero-labels nmem[2-4]

This is slightly scary, as it depends on the user not having any file
named nmem2, nmem3, or nmem4 in the current working directory.  Your
example should probably encourage proper shell quoting, as in:

ndctl zero-labels 'nmem[2-4]'

>=20
> ...as a shorthand for:
>=20
>     ndctl zero-labels nmem2 nmem3 nmem4

By the way, depending on the user's shell, they can already have
shorthand as in:

ndctl zero-labels nmem{2,3,4}

where the shell does the expansion instead of you having to do a glob
after the fact.  Which makes me wonder if this syntactic sugar is worth
maintaining.


--=20
Eric Blake   eblake redhat com    +1-919-301-3266
Libvirt virtualization library http://libvirt.org


--VAdnoSlUGIlqos2ARlCErFQNOCXDFtxf3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCAAGBQJYB76wAAoJEKeha0olJ0Nq4dEH+wTklu4jBEUjUrGrmG+3EDdq
X4keNPEvgK1bno2gKv/VndKuROtXTbpzMsw3fGL0zX/iBmtZilL1XDzrESU/xy+J
G949RwVKB3NZRK01vl2Ko6X4B19izFhHqPCZJAT3394skpuP6LY11Y2loipKP4Fd
lzJHVVesljIjpDhx9XvVhQ9IPaDZbltBPrfeUZnNvBZjqdKfdPztELfEZUWJDdJ+
Xq9WmXKmXDJwD3USTPOIWNcwlDywv1XMDVZ+fGhGI5BV6hb94IXNJmJFtvhytj6A
aO+NXEYkkID3NapKlmHMxg2LYIwI7icNR2S9OfQ/sGdiOZS6on7RNiJjjd8k6tg=
=R90b
-----END PGP SIGNATURE-----

--VAdnoSlUGIlqos2ARlCErFQNOCXDFtxf3--
