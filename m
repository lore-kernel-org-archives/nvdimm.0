From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH 2/3] nvdimm,
 acpi: add NFIT platform capabilities
Date: Mon, 30 Apr 2018 12:39:02 +0100
Message-ID: <20180430113902.GI4002@stefanha-x1.localdomain>
References: <20180427215314.23168-1-ross.zwisler@linux.intel.com>
	<20180427215314.23168-2-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xQR6quUbZ63TTuTU"
Return-path: <qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <20180427215314.23168-2-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: qemu-devel@nongnu.org, Haozhong Zhang <haozhong.zhang@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Eduardo Habkost <ehabkost@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>
List-Id: linux-nvdimm@lists.01.org


--xQR6quUbZ63TTuTU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 27, 2018 at 03:53:13PM -0600, Ross Zwisler wrote:
> Add support for the NFIT Platform Capabilities Structure, newly added in
> ACPI 6.2 Errata A.
>=20
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  hw/acpi/nvdimm.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--xQR6quUbZ63TTuTU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJa5wBWAAoJEJykq7OBq3PI/6kIAJT2MRlgKUVaKWYkyecnWp/v
WFGK86jol88gIW8df6c4AdN+bOB62FxclaaP0AgtkKLOlXfgmKcaGAqo1c051BCR
Bn9QDyCTm/V3SjqS37c/bsewwAx0DvsGV3lmn/8B3dtFoT+fL7M5SIQwH/BT/hKb
5pnrJZxBt3Q82VFpVxQSVXXzBpN/gL9z00sB8EcolGjZvMUQP59/1EqJdDnjcd6u
IbG/G1Utafqb3RRJAlpS57mSQxNPctRa3Yht10On1NPmNN8dZaMiJJwFDLUtsNcM
GWopcE+KldtCcWrvoOAJc7kSRtnKne21CjeNgVq8If86m4RNUsf5GEe1H2n1Vp4=
=AdNt
-----END PGP SIGNATURE-----

--xQR6quUbZ63TTuTU--
