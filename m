From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: Querying the size of devdax devices from userspace
Date: Fri, 8 Feb 2019 09:53:13 +0800
Message-ID: <20190208015313.GA16257@stefanha-x1.localdomain>
References: <20190204075023.GA15322@stefanha-x1.localdomain>
	<CAPcyv4huSKQueADyF5wJPWxMdLAn6yvEqWyMZfWPVQ4vQ_X0RA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Return-path: <qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4huSKQueADyF5wJPWxMdLAn6yvEqWyMZfWPVQ4vQ_X0RA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Zhang Yi <yi.z.zhang@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>, Qemu Developers <qemu-devel@nongnu.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-Id: linux-nvdimm@lists.01.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 04, 2019 at 12:06:32AM -0800, Dan Williams wrote:
> On Sun, Feb 3, 2019 at 11:56 PM Stefan Hajnoczi <stefanha@redhat.com> wro=
te:
> >
> > How can userspace applications query the size of devdax character
> > devices?
> >
> > stat(1) doesn't know how large the device is:
> >
> >   # stat /dev/dax0.0
> >     File: /dev/dax0.0
> >     Size: 0             Blocks: 0          IO Block: 4096   character s=
pecial file
> >   Device: 6h/6d Inode: 56764       Links: 1     Device type: fa,d
> >
> > ndctl(1) finds out by digging in /sys:
> >
> >   # ndctl list
> >   [
> >     {
> >       "dev":"namespace0.0",
> >       "mode":"devdax",
> >       "map":"dev",
> >       "size":2111832064,
> >       "uuid":"235acf4d-503f-46be-bf64-f26faf9777ef",
> >       "chardev":"dax0.0"
> >     }
> >   ]
> >
> > I'm not sure how to do it without enumerating all nvdimms in /sys.  Is
> > there a mapping from devdax major/minor number to a /sys path?
> >
> > The use case I have in mind is that QEMU currently takes the size as a
> > command-line parameter.  The failure mode is ugly when users get this
> > value wrong: the guest gets a softlockup and there is no error message
> > on the host side.
> >
> > I'd like QEMU to detect the size or at least reject size values that are
> > too large.  In order to do that userspace needs a convenient way of
> > querying the size.  Any ideas?
>=20
> You're looking for /sys/dev/char. That will wake you from major:minor
> to sysfs. Perhaps borrow fio's implementation for the same:
>=20
>    http://git.kernel.dk/cgit/fio/tree/engines/dev-dax.c#n258

Excellent, thanks!

Stefan

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJcXOEJAAoJEJykq7OBq3PIp7gH/2N8132TeleBKZLsNiZfBrFH
ug3Vj9gDR7xsSDjJX0NQkZGaQCF8+rQ4wcvR3ls+aWCkD6IbfISOzRwlzxYxpIIh
jJAdTbp+ZryBxvivRFLCuOO0Y2QmuVDfxvbOK6KO9NhvFbD5vjcRV1lWh99oGDjQ
0fdA0QbHaoRM7fN4XGzW6moTfyFTDeDamkz4T8+HrGSb4R8w0eHm9brbgGnn64Nt
1RLR8Rsxwzu+rvDdiS5cEJ4arnE17yJ2FE9uybkJ5NyHognqdim721BPsf41c+Nc
Unje4mQuthCq7CoN3UxP3uOcI9PVmgvrKREIgQnx61in4RK1xSNJPD76R4n9RQg=
=+kVP
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
