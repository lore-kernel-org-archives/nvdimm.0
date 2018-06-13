From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [RFC PATCH 1/1] nvdimm: let qemu requiring section
 alignment of pmem resource.
Date: Wed, 13 Jun 2018 15:16:05 +0100
Message-ID: <20180613141605.GT24528@stefanha-x1.localdomain>
References: <e74aee54657de6f8d643a92ba21f467db149c2c8.1528714312.git.yi.z.zhang@linux.intel.com>
	<20180611162630.GH17756@stefanha-x1.localdomain>
	<CAPcyv4jJSYiCu_qNWgU8KR3sFQE032Uu6LCQq-CTxF0jpkooiA@mail.gmail.com>
	<20180612150425.hjydg5cbtlllzh67@HZ>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yypaS3FvPkEUiGyo"
Return-path: <qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <20180612150425.hjydg5cbtlllzh67@HZ>
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
To: Haozhong Zhang <hzzhan9@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Michael S. Tsirkin" <mst@redhat.com>, Qemu Developers <qemu-devel@nongnu.org>, Zhang Yi <yi.z.zhang@linux.intel.com>, yu.c.zhang@linux.intel.com, Igor Mammedov <imammedo@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Eduardo Habkost <ehabkost@redhat.com>
List-Id: linux-nvdimm@lists.01.org


--yypaS3FvPkEUiGyo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 12, 2018 at 11:04:25PM +0800, Haozhong Zhang wrote:
> On 06/11/18 19:55, Dan Williams wrote:
> > On Mon, Jun 11, 2018 at 9:26 AM, Stefan Hajnoczi <stefanha@redhat.com> =
wrote:
> > > On Mon, Jun 11, 2018 at 06:54:25PM +0800, Zhang Yi wrote:
> > >> Nvdimm driver use Memory hot-plug APIs to map it's pmem resource,
> > >> which at a section granularity.
> > >>
> > >> When QEMU emulated the vNVDIMM device, decrease the label-storage,
> > >> QEMU will put the vNVDIMMs directly next to one another in physical
> > >> address space, which means that the boundary between them won't
> > >> align to the 128 MB memory section size.
> > >
> > > I'm having a hard time parsing this.
> > >
> > > Where does the "128 MB memory section size" come from?  ACPI?
> > > A chipset-specific value?
> > >
> >=20
> > The devm_memremap_pages() implementation use the memory hotplug core
> > to allocate the 'struct page' array/map for persistent memory. Memory
> > hotplug can only be performed in terms of sections, 128MB on x86_64.
>=20
> IIUC, it also affects the normal RAM hotplug to a Linux VM on QEMU. If
> that is the case, it will be helpful to lift this option to pc-dimm.

I agree.  There should be one place in QEMU for the machine-specific
hotplug memory alignment value.

It would be best to track down the property of the hardware that
determines these alignment values instead of letting current Linux
software limitations determine QEMU's behavior.  That way we know that
QEMU emulates real hardware accurately and will work with any guest OS.
I imagine it depends on the chipset (i.e. QEMU machine type).

If it proves hard to pinpoint the hardware limit, then please include a
comment in the code explaining that a value that works with Linux guests
is being used for now.  This will allow people reading the code to
understand where this behavior comes from.

Stefan

--yypaS3FvPkEUiGyo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJbISclAAoJEJykq7OBq3PIFkgIAI1azCPPD0eZkKwcHEAq4kUD
+eqZt1g5YbI+911Enz+wXWP3ryTwDXKsVOiwqHcG17ha5g7u4L57AdV/PHl/pUjy
tWv3WFd+ivuNhHBcOaWbu4kFStJ+oBoLTC5T4xqFLoPvsqX0DMEzNPRqQ16VYHp9
iIP1GJFynwdwYQZNImcl1/5PYkrWSn7REKfSrJ9YRIXJWWyDDkAQVcaJrCScirrn
7aOFHVBqK5YtKPLwZLdptVBzMIdYpwK1oa5UA8cccvdcWDmoT3twpgPJ0MCawRaV
SJV6jKCiHauf/sfjBdPDUsctn7VEsOc4KW7kxwEY2vcLwm9RUC+83EeyjDpIf60=
=Nc9t
-----END PGP SIGNATURE-----

--yypaS3FvPkEUiGyo--
