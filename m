From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH 3/3] nvdimm: platform capabilities command
 line option
Date: Mon, 30 Apr 2018 12:39:05 +0100
Message-ID: <20180430113905.GJ4002@stefanha-x1.localdomain>
References: <20180427215314.23168-1-ross.zwisler@linux.intel.com>
	<20180427215314.23168-3-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LG0Ll82vYr46+VA1"
Return-path: <qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <20180427215314.23168-3-ross.zwisler@linux.intel.com>
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


--LG0Ll82vYr46+VA1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 27, 2018 at 03:53:14PM -0600, Ross Zwisler wrote:
> Add a device command line option to allow the user to control the Platform
> Capabilities Structure in the virtualized NFIT.
>=20
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  docs/nvdimm.txt         | 22 ++++++++++++++++++++++
>  hw/acpi/nvdimm.c        | 29 +++++++++++++++++++++++++----
>  hw/mem/nvdimm.c         | 28 ++++++++++++++++++++++++++++
>  include/hw/mem/nvdimm.h |  6 ++++++
>  4 files changed, 81 insertions(+), 4 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--LG0Ll82vYr46+VA1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJa5wBZAAoJEJykq7OBq3PIgSwH/jdArigadKjwVEC8XJJFB+vs
9mBMvZiLjolxAy/hCJfna2CrYBtR/RxTUT3aSGWufp2LtRNUG5VnEXFHtMW4Yxqx
arW1W6fgq9K7w42+3fSbZf/mq+9yXbhq2V6I/4W2WDuW3+upDpTnNkR2tkf9LebB
If808A9CdGSTBg9i5kwyy3ALz7exE5iMdBHBpDoBs5/+Bkn9LU0jZvWw5qMwqfL3
ZHkcB5XWu5pQbHYyLAV3dDrvd1vZCd6XcZMa0Mg4RzufzBYdmOLMudF5zXbQDGFt
duxbvaHm/CImLlF1p2kaOvyzMa0DEmZu/ggibXjXMR2EBqE8vX6gnkpJji6T7hA=
=JkUR
-----END PGP SIGNATURE-----

--LG0Ll82vYr46+VA1--
