From: Eric Blake <eblake@redhat.com>
Subject: Re: [ndctl PATCH 0/8] dimm label space initialization
 support
Date: Wed, 19 Oct 2016 18:46:14 -0500
Message-ID: <708947f5-dfdc-d6c9-4523-7436959119f3@redhat.com>
References: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
	<6ceb7075-71fc-b725-8a1c-a7d8c727770e@redhat.com>
	<CAPcyv4gbRE-ALJM6EHv6fM3Kq02HeZFMLF5T63J5qaJmHWvQCg@mail.gmail.com>
	<CAPcyv4h3_OAef5n=tQ2vDXw=sntkZPTnyoeFdRQN6BKKx3q6SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="RvcCqcfwX8e49jaxU872cl8xp1F1jr9jp"
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <CAPcyv4h3_OAef5n=tQ2vDXw=sntkZPTnyoeFdRQN6BKKx3q6SA@mail.gmail.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: "Qemu-devel" <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@ml01.01.org>, qemu-devel@nongnu.org, Vishal L Verma <vishal.l.verma@intel.com>
List-Id: linux-nvdimm@lists.01.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RvcCqcfwX8e49jaxU872cl8xp1F1jr9jp
From: Eric Blake <eblake@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@ml01.01.org>,
 Vishal L Verma <vishal.l.verma@intel.com>, qemu-devel@nongnu.org
Message-ID: <708947f5-dfdc-d6c9-4523-7436959119f3@redhat.com>
Subject: Re: [Qemu-devel] [ndctl PATCH 0/8] dimm label space initialization
 support
References: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
 <6ceb7075-71fc-b725-8a1c-a7d8c727770e@redhat.com>
 <CAPcyv4gbRE-ALJM6EHv6fM3Kq02HeZFMLF5T63J5qaJmHWvQCg@mail.gmail.com>
 <CAPcyv4h3_OAef5n=tQ2vDXw=sntkZPTnyoeFdRQN6BKKx3q6SA@mail.gmail.com>
In-Reply-To: <CAPcyv4h3_OAef5n=tQ2vDXw=sntkZPTnyoeFdRQN6BKKx3q6SA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/19/2016 04:29 PM, Dan Williams wrote:
> On Wed, Oct 19, 2016 at 12:41 PM, Dan Williams <dan.j.williams@intel.co=
m> wrote:
>> On Wed, Oct 19, 2016 at 11:42 AM, Eric Blake <eblake@redhat.com> wrote=
:
>>> On 10/19/2016 11:47 AM, Dan Williams wrote:
>>>> The 4.9 kernel added support for sub-dividing PMEM.  With this kerne=
l
>>>> patch [1] on top of that baseline, the PMEM-sub-division support can=
 be
>>>> enabled for QEMU-KVM and any other platforms that advertise both un-=
aliased
>>>> PMEM regions and support for the label DSM commands [2].
>>>>
>>>> Given this increasing need to perform a label management operation
>>>> across a set of DIMMs this update also adds glob(3) support.  For
>>>> example you can now write commands like:
>>>>
>>>>     ndctl zero-labels nmem[2-4]
>>>
>>> This is slightly scary, as it depends on the user not having any file=

>>> named nmem2, nmem3, or nmem4 in the current working directory.  Your
>>> example should probably encourage proper shell quoting, as in:
>>>
>>> ndctl zero-labels 'nmem[2-4]'
>>
>> True.  Although, the glob is run against the list of present device
>> names in the system, so local files named nmem should change the
>> operation of the command.
>=20
> s/should/shouldn't/

You didn't get my complaint.  So let me demonstrate, using echo instead
of ndctl:

$ mkdir /tmp/foo
$ cd /tmp/foo
$ echo nmem[2-4]
nmem[2-4]
$ touch nmem3 nmem4
$ echo nmem[2-4]
nmem3 nmem4
$ echo 'nmem[2-4]'
nmem[2-4]

The problem is that the glob is liable to pre-expansion by the shell
UNLESS the user quotes the glob; meaning that the current working
directory controls whether ndctl even sees a glob in the first place.
If you are going to support globbing in ndctl out of laziness (since it
is indeed fewer characters to type [2-4] than it is to type {2..4}, plus
{2..4} is not supported by all shells), then you HAVE to document that
the user is responsible for quoting (omitting quoting usually does what
you want).  But by the time you quote to get the glob down to ndctl,
'[2-4]' is more typing than {2..4} expanded by the shell, at which point
were you really being lazy by adding globbing?

--=20
Eric Blake   eblake redhat com    +1-919-301-3266
Libvirt virtualization library http://libvirt.org


--RvcCqcfwX8e49jaxU872cl8xp1F1jr9jp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCAAGBQJYCAXGAAoJEKeha0olJ0Nq4iMIAJRi3NIKQoWxMn5r5SJLOAC0
TQukGF6rGfdmk4GWAbfevIEH9NEGgdcF3VF4hpDDqZbQNJuCHxngY0tdKB1C2EG/
pm0cvQssp99DVC1kJa6+t054HN8g8O1DCUP0Np9gArTpi4IW6yhJIedqzddB+Ggz
aijYJBKCZOvKWz+FF8hdwm9KlMxmt5pRJewrdpRl4dH2DKqONPst5e42maexC/Jd
6UPJt5jkBn0i/Muw/x7Ha8LhYOOFWlB1Daklk/KQ0mZgyUmjSFb3nq48zlur1jHi
93AU46USg0Qbh4bf0focffUInbpPTT7CVAH3WRu1aiijQXsuKgzvQj7nYtgbKco=
=t+jA
-----END PGP SIGNATURE-----

--RvcCqcfwX8e49jaxU872cl8xp1F1jr9jp--
