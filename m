From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH 1/3] nvdimm: fix typo in label-size
 definition
Date: Mon, 30 Apr 2018 12:38:58 +0100
Message-ID: <20180430113858.GH4002@stefanha-x1.localdomain>
References: <20180427215314.23168-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G44BJl3Aq1QbV/QL"
Return-path: <qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <20180427215314.23168-1-ross.zwisler@linux.intel.com>
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


--G44BJl3Aq1QbV/QL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 27, 2018 at 03:53:12PM -0600, Ross Zwisler wrote:
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Fixes: commit da6789c27c2e ("nvdimm: add a macro for property "label-size"")
> Cc: Haozhong Zhang <haozhong.zhang@intel.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  hw/mem/nvdimm.c         | 2 +-
>  include/hw/mem/nvdimm.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--G44BJl3Aq1QbV/QL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJa5wBSAAoJEJykq7OBq3PIk/kH/RoW13NFOdFjOsF/XyAMK+iO
Gs7ZV9VWu/1Mh/mR7SJkp0IXI9ugKD35Rwo+C9AWSBbecGs4FBkmgK8891OhAFLe
yN5cNNcTJX3zUFxtMV3UwhfjIcsR3v5AJNC4g3hWaB0z3XvCeN9aXh6FUTMQPH2H
6+eR3Tq3s3tTfC+BDAAMq1+xv2mlKmKa34pAWLpjrz9ui5mVVm//3cxc3HWlwErZ
ae3a4IfwcguhD1M/gclnrtrJxyQUN5ZgX8+QqFrzhtw9SYL9FycXQ46anUt11NVM
eKbux2EVi5z9kf15eP30pud2YmxkPtwDKFz50uW29jUM0lpON3Ja5741ivR5bKI=
=Q9lk
-----END PGP SIGNATURE-----

--G44BJl3Aq1QbV/QL--
