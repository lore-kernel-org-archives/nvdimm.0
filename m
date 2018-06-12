From: Haozhong Zhang <hzzhan9@gmail.com>
Subject: Re: [RFC PATCH 1/1] nvdimm: let qemu requiring section
 alignment of pmem resource.
Date: Tue, 12 Jun 2018 23:04:25 +0800
Message-ID: <20180612150425.hjydg5cbtlllzh67@HZ>
References: <e74aee54657de6f8d643a92ba21f467db149c2c8.1528714312.git.yi.z.zhang@linux.intel.com>
	<20180611162630.GH17756@stefanha-x1.localdomain>
	<CAPcyv4jJSYiCu_qNWgU8KR3sFQE032Uu6LCQq-CTxF0jpkooiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dlcfb4jwfpzqzf5l"
Return-path: <qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4jJSYiCu_qNWgU8KR3sFQE032Uu6LCQq-CTxF0jpkooiA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Zhang Yi <yi.z.zhang@linux.intel.com>
Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Michael S. Tsirkin" <mst@redhat.com>, Qemu Developers <qemu-devel@nongnu.org>, yu.c.zhang@linux.intel.com, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Eduardo Habkost <ehabkost@redhat.com>
List-Id: linux-nvdimm@lists.01.org


--dlcfb4jwfpzqzf5l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06/11/18 19:55, Dan Williams wrote:
> On Mon, Jun 11, 2018 at 9:26 AM, Stefan Hajnoczi <stefanha@redhat.com> wr=
ote:
> > On Mon, Jun 11, 2018 at 06:54:25PM +0800, Zhang Yi wrote:
> >> Nvdimm driver use Memory hot-plug APIs to map it's pmem resource,
> >> which at a section granularity.
> >>
> >> When QEMU emulated the vNVDIMM device, decrease the label-storage,
> >> QEMU will put the vNVDIMMs directly next to one another in physical
> >> address space, which means that the boundary between them won't
> >> align to the 128 MB memory section size.
> >
> > I'm having a hard time parsing this.
> >
> > Where does the "128 MB memory section size" come from?  ACPI?
> > A chipset-specific value?
> >
>=20
> The devm_memremap_pages() implementation use the memory hotplug core
> to allocate the 'struct page' array/map for persistent memory. Memory
> hotplug can only be performed in terms of sections, 128MB on x86_64.

IIUC, it also affects the normal RAM hotplug to a Linux VM on QEMU. If
that is the case, it will be helpful to lift this option to pc-dimm.

Thanks,
Haozhong

> There is some limited support for allowing devm_memremap_pages() to
> overlap 'System RAM' within a given section, but it does not currently
> support multiple devm_memremap_pages() calls overlapping within the
> same section. There is currently a kernel bug where we do not handle
> this unsupported configuration gracefully. The fix will cause
> configurations configurations that try to overlap 2 persistent memory
> ranges in the same section to fail.
>=20
> The proposed fix is trying to make sure that QEMU does not run afoul
> of this constraint.
>=20
> There is currently no line of sight to reduce the minimum memory
> hotplug alignment size to less than 128M. Also, as other architectures
> outside of x86_64 add devm_memremap_pages() support, the minimum
> section alignment constraint might change and is a property of a guest
> OS. My understanding is that some guest OSes might expect an even
> larger persistent memory minimum alignment.
>=20

--dlcfb4jwfpzqzf5l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEr9A2n0Sq9CPUvBJWWSn3ETy7JRYFAlsf4PkACgkQWSn3ETy7
JRYJHQ//Tb9Bo6PFjSUUJMyxnbH962VdzCj3YEMZgXCaCtEazxSYhQj5m7iiK3E9
Ul7b8Uk9d61nsHCkVmk90wQK/86jpYVgvEha2d4rx+TaEH+lCaSiQS257NHvOVeF
hmsU1wIqW2jjIP/uhT8KaasHVSzB1rES6cPjrB8XcyH/vOlec7lbnBCS5VzdWgEa
QKdYec5r6E5D7Iy3fvupVV61nmeeiPokSY1fGm0BsxehXPGtBCe6fRNbxTTX0Hd7
gEDLr7F3b1OldWa2P3ASdNkKVV9qraQV7luk2t56NnKUKkXet9kCdBky4T/+02eS
X7JKdkKrXdvsRBWhwqvjPPFC7KbHevHNIFDK4G7eCqEVvdVGCHrVsnlLqAlr7ZKh
3u8dS7AS8tGQff+2CNOt/u3keTuulBL8vIHx3p70MfTuTrabhXhLy2RRetKSVbgN
5lGPAtZ+Ki7RgxFdKJsd1yDQbC5e7mRrva35EotYz/Xhz1ePIbqCihx2mOCjBc+2
hVL61qRmp2+GLAe3rMU6iExuW7AUCyyC0Q8NslPr2WqepMVQITgwK69GHM1v1gWy
1xVPVkCe2DaZcjMk9+U50uWnIu/sF86maZgxiflfMsxpfZihVerI5ziCOPRG6+pn
z9ie+nVjpCLrHCo4tIVh1KLEZrILJJFFSWqVBkI66fLsao7jevQ=
=E1PP
-----END PGP SIGNATURE-----

--dlcfb4jwfpzqzf5l--
