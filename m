Return-Path: <linux-ext4-owner@vger.kernel.org>
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <9F35007B-F0D9-4FB9-A52D-604E410AB389@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_4386D1D9-DA47-4905-8319-C80A4D7BBB8D";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Unexpected writes seen on a Read-only, DAX enabled EXT4 fs
Date: Mon, 11 Sep 2017 14:31:41 -0600
In-Reply-To: <20170911182112.GA20005@linux.intel.com>
References: <2036030243.251059.1504977026265.ref@mail.yahoo.com>
 <2036030243.251059.1504977026265@mail.yahoo.com>
 <20170911182112.GA20005@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Soccer Liu <soccer_liu@yahoo.com>, linux-ext4@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


--Apple-Mail=_4386D1D9-DA47-4905-8319-C80A4D7BBB8D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 11, 2017, at 12:21 PM, Ross Zwisler =
<ross.zwisler@linux.intel.com> wrote:
>=20
> On Sat, Sep 09, 2017 at 05:10:26PM +0000, Soccer Liu wrote:
>> Hi:
>>   I was surprised to see a few write operations called into
>> ext4_dax_huge_fault with FAULT_FLAG_WRITE set on vmf->flags
>> Are those writes expected at all?
>> static int ext4_dax_huge_fault(struct vm_fault *vmf,
>> enum page_entry_size pe_size)
>> {
>> ...
>> bool write =3D vmf->flags & FAULT_FLAG_WRITE;
>> Based on the following Mount documentation below, I did mount this =
ext fs
>> with ro and noloadAre there any other options that I could use to =
totally
>> eliminate those unexpected writes?
>>=20
>>   - -r, --read-only
>>      - Mount the filesystem read-only. A synonym is -o ro.Note that,
>>      depending on the filesystem type, state and kernel behavior, the
>>      system may still write to the device. For example, Ext3 or ext4 =
will
>>      replay itsjournal if the filesystem is dirty. To prevent this =
kind of
>>      write access, you may want to mount ext3 or ext4 filesystem with
>>      "ro,noload" mount options or setthe block device to read-only =
mode,
>>      see command blockdev(8).  -
>>=20
>> Related DMESG output...
>>=20
>> [    0.891653] EXT4-fs (pmem0): DAX enabled. Warning: EXPERIMENTAL, =
use at your own risk
>> [    0.892736] EXT4-fs (pmem0): mounted filesystem without journal. =
Opts: noload,dax
>> [    0.898293] EXT4-fs (sda): mounted filesystem without journal. =
Opts: (null)
>> [    0.902574] random: fast init done
>> [    0.926157] IPVS: ftp: loaded support on port[0] =3D 21
>> // My private debug messages
>> [    0.997224] EXT4-fs (pmem0): write is 1 handle =3D =
0xffffffffffffffe2 <--read-only device
>> [    0.998052] EXT4-fs (pmem0): write is 1 handle =3D =
0xffffffffffffffe2
>> [    0.998787] EXT4-fs (pmem0): write is 1 handle =3D =
0xffffffffffffffe2
>> [    0.999720] EXT4-fs (pmem0): write is 0 handle =3D 0x0
>> [    1.004626] EXT4-fs (pmem0): write is 0 handle =3D 0x0
>> [    1.005359] EXT4-fs (pmem0): write is 0 handle =3D 0x0
>> [    1.006128] EXT4-fs (pmem0): write is 0 handle =3D 0x0
>> [    1.006824] EXT4-fs (pmem0): write is 0 handle =3D 0x0
>> [    1.007499] EXT4-fs (pmem0): write is 0 handle =3D 0x0
>> [    1.008149] EXT4-fs (pmem0): write is 0 handle =3D 0x0
>> [    7.320626] random: crng init done
>> [   18.780447] EXT4-fs: 53 callbacks suppressed
>> [   18.781900] EXT4-fs (pmem0): write is 0 handle =3D 0x0
>> [   18.783392] EXT4-fs (pmem0): write is 0 handle =3D 0x0
>> [   18.790661] EXT4-fs (pmem0): write is 0 handle =3D 0x0
>> [   18.792042] EXT4-fs (pmem0): write is 0 handle =3D 0x0
>> [   18.793321] EXT4-fs (pmem0): write is 0 handle =3D 0x0
>> [   18.795005] EXT4-fs (pmem0): write is 0 handle =3D 0x0
>> [   18.795204] EXT4-fs (pmem0): write is 1 handle =3D =
0xffffffffffffffe2
>> [   18.795209] EXT4-fs (pmem0): write is 1 handle =3D =
0xffffffffffffffe2
>> [   18.795213] EXT4-fs (pmem0): write is 1 handle =3D =
0xffffffffffffffe2
>> [   18.795257] EXT4-fs (pmem0): write is 0 handle =3D 0x0
>=20
> Adding the ext4 list.
>=20
> I'm pretty sure that this is ext4/mm behavior that is independent of =
DAX.  DAX
> doesn't really have any impact on whether or not write page faults =
happen on a
> RO ext4 filesystem, though this fix from Randy Dodgen:
>=20
> https://www.spinics.net/lists/linux-ext4/msg58075.html
>=20
> shows that FAULT_FLAG_WRITE can be set on DAX read-only ext4 mounts =
when
> executing binaries, though in this case the write is going to a COW =
page.

Also, ext4 journal recovery will be done on the filesystem regardless of
whether it is mounted read-only or not.

Cheers, Andreas






--Apple-Mail=_4386D1D9-DA47-4905-8319-C80A4D7BBB8D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZtvKupIg59Q01vtYRAnhCAKCSEg0OISl85E+41hcng9ILkMIz/gCgzdf4
feN/9cgg0xKiPi+rUq0e50k=
=VzIH
-----END PGP SIGNATURE-----

--Apple-Mail=_4386D1D9-DA47-4905-8319-C80A4D7BBB8D--
