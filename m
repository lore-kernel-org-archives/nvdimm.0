Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Content-Type: multipart/signed; boundary="Apple-Mail=_29505F4B-67B1-4A11-A0F5-E97EA94963CA"; protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [LSF/MM TOPIC] Badblocks checking/representation in filesystems
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <CAOvWMLYMR-VvAVNuVjXPC-woxY6afQX5-hMC=Vj2p=3AGj9tyA@mail.gmail.com>
Date: Tue, 17 Jan 2017 17:16:22 -0700
Message-Id: <1BAF6FD6-1FDB-4F7C-A915-891F46E78B8C@dilger.ca>
References: <at1mp6pou4lenesjdgh22k4p.1484345585589@email.android.com> <b9rbflutjt10mb4ofherta8j.1484345610771@email.android.com> <SN2PR04MB2191756EABCB0E9DAA3B5328887B0@SN2PR04MB2191.namprd04.prod.outlook.com> <20170114004910.GA4880@omniknight.lm.intel.com> <20170117063355.GL14033@birch.djwong.org> <20170117213549.GB4880@omniknight.lm.intel.com> <CAOvWMLYMR-VvAVNuVjXPC-woxY6afQX5-hMC=Vj2p=3AGj9tyA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andiry Xu <andiry@gmail.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Viacheslav Dubeyko <slava@dubeyko.com>
List-ID: <linux-nvdimm@lists.01.org>


--Apple-Mail=_29505F4B-67B1-4A11-A0F5-E97EA94963CA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 17, 2017, at 3:15 PM, Andiry Xu <andiry@gmail.com> wrote:
> On Tue, Jan 17, 2017 at 1:35 PM, Vishal Verma =
<vishal.l.verma@intel.com> wrote:
>> On 01/16, Darrick J. Wong wrote:
>>> On Fri, Jan 13, 2017 at 05:49:10PM -0700, Vishal Verma wrote:
>>>> On 01/14, Slava Dubeyko wrote:
>>>>>=20
>>>>> ---- Original Message ----
>>>>> Subject: [LSF/MM TOPIC] Badblocks checking/representation in =
filesystems
>>>>> Sent: Jan 13, 2017 1:40 PM
>>>>> From: "Verma, Vishal L" <vishal.l.verma@intel.com>
>>>>> To: lsf-pc@lists.linux-foundation.org
>>>>> Cc: linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, =
linux-fsdevel@vger.kernel.org
>>>>>=20
>>>>>> The current implementation of badblocks, where we consult the
>>>>>> badblocks list for every IO in the block driver works, and is a
>>>>>> last option failsafe, but from a user perspective, it isn't the
>>>>>> easiest interface to work with.
>>>>>=20
>>>>> As I remember, FAT and HFS+ specifications contain description of =
bad blocks
>>>>> (physical sectors) table. I believe that this table was used for =
the case of
>>>>> floppy media. But, finally, this table becomes to be the =
completely obsolete
>>>>> artefact because mostly storage devices are reliably enough. Why =
do you need
>>>=20
>>> ext4 has a badblocks inode to own all the bad spots on disk, but =
ISTR it
>>> doesn't support(??) extents or 64-bit filesystems, and might just be =
a
>>> vestigial organ at this point.  XFS doesn't have anything to track =
bad
>>> blocks currently....
>>>=20
>>>>> in exposing the bad blocks on the file system level?  Do you =
expect that next
>>>>> generation of NVM memory will be so unreliable that file system =
needs to manage
>>>>> bad blocks? What's about erasure coding schemes? Do file system =
really need to suffer
>>>>> from the bad block issue?
>>>>>=20
>>>>> Usually, we are using LBAs and it is the responsibility of storage =
device to map
>>>>> a bad physical block/page/sector into valid one. Do you mean that =
we have
>>>>> access to physical NVM memory address directly? But it looks like =
that we can
>>>>> have a "bad block" issue even we will access data into page =
cache's memory
>>>>> page (if we will use NVM memory for page cache, of course). So, =
what do you
>>>>> imply by "bad block" issue?
>>>>=20
>>>> We don't have direct physical access to the device's address space, =
in
>>>> the sense the device is still free to perform remapping of chunks =
of NVM
>>>> underneath us. The problem is that when a block or address range =
(as
>>>> small as a cache line) goes bad, the device maintains a poison bit =
for
>>>> every affected cache line. Behind the scenes, it may have already
>>>> remapped the range, but the cache line poison has to be kept so =
that
>>>> there is a notification to the user/owner of the data that =
something has
>>>> been lost. Since NVM is byte addressable memory sitting on the =
memory
>>>> bus, such a poisoned cache line results in memory errors and =
SIGBUSes.
>>>> Compared to tradational storage where an app will get nice and =
friendly
>>>> (relatively speaking..) -EIOs. The whole badblocks implementation =
was
>>>> done so that the driver can intercept IO (i.e. reads) to _known_ =
bad
>>>> locations, and short-circuit them with an EIO. If the driver =
doesn't
>>>> catch these, the reads will turn into a memory bus access, and the
>>>> poison will cause a SIGBUS.
>>>=20
>>> "driver" ... you mean XFS?  Or do you mean the thing that makes pmem
>>> look kind of like a traditional block device? :)
>>=20
>> Yes, the thing that makes pmem look like a block device :) --
>> drivers/nvdimm/pmem.c
>>=20
>>>=20
>>>> This effort is to try and make this badblock checking smarter - and =
try
>>>> and reduce the penalty on every IO to a smaller range, which only =
the
>>>> filesystem can do.
>>>=20
>>> Though... now that XFS merged the reverse mapping support, I've been
>>> wondering if there'll be a resubmission of the device errors =
callback?
>>> It still would be useful to be able to inform the user that part of
>>> their fs has gone bad, or, better yet, if the buffer is still in =
memory
>>> someplace else, just write it back out.
>>>=20
>>> Or I suppose if we had some kind of raid1 set up between memories we
>>> could read one of the other copies and rewrite it into the failing
>>> region immediately.
>>=20
>> Yes, that is kind of what I was hoping to accomplish via this
>> discussion. How much would filesystems want to be involved in this =
sort
>> of badblocks handling, if at all. I can refresh my patches that =
provide
>> the fs notification, but that's the easy bit, and a starting point.
>>=20
>=20
> I have some questions. Why moving badblock handling to file system
> level avoid the checking phase? In file system level for each I/O I
> still have to check the badblock list, right? Do you mean during mount
> it can go through the pmem device and locates all the data structures
> mangled by badblocks and handle them accordingly, so that during
> normal running the badblocks will never be accessed? Or, if there is
> replicataion/snapshot support, use a copy to recover the badblocks?

With ext4 badblocks, the main outcome is that the bad blocks would be
pemanently marked in the allocation bitmap as being used, and they would
never be allocated to a file, so they should never be accessed unless
doing a full device scan (which ext4 and e2fsck never do).  That would
avoid the need to check every I/O against the bad blocks list, if the
driver knows that the filesystem will handle this.

The one caveat is that ext4 only allows 32-bit block numbers in the
badblocks list, since this feature hasn't been used in a long time.
This is good for up to 16TB filesystems, but if there was a demand to
use this feature again it would be possible allow 64-bit block numbers.

Cheers, Andreas






--Apple-Mail=_29505F4B-67B1-4A11-A0F5-E97EA94963CA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWH6z13Kl2rkXzB/gAQj/JBAAmhaeZgpXMbthrDFsV9YUmkPZtrPptiYj
tiMQlJvSo5xpdt0eVVeYhJRX73cc9fbgt4h8soxx1noIoQg8c1TQqU4DazHuhX0R
geAhDNTkyFrtEY92vAABM4s1nzDQG4EZ8C6bniwQASR9QZhlCgATW6hIM7lv62C8
vWUL+Ym0NLNcH3dsi/qd28rSG/p9xQlJyyQjDoU0rePbuWzI7QlmGyfB6QTmvTl5
K9lhV3MafVPRte1IOvJcr16nDqsRgCRQ/XYob+Fw9yUVpy1LzOuWsvxEI19/3i1Z
hV0n0B3TANIk6BKjkZvsmtbi0eksNRzSigt5pzNoG2loaB9RT8zXhpZxbN6aFoHF
If1friETgvRuPwxOJGF7hMb6OOQMF8DjiJqCzPMOMAeR5LEEVNDuNa5Gw6gWNHGK
D47T41f/kAypXvYJBMBtG21OADHmKsAq56neCGEPiRqYQgBpfWC7AKDBeiBoZTre
YwwqYMHpnXOTLPeTcLHqHT8KM+CZ9GlW+IOlUDPpTCQSGnXITAMMeZmVdNtvh0K8
XGTyQroTiWeqqv9s2Ym5mV2rVmq3oNGB8/NRPs7GPUYUEOF+jST4Bru7sSdmo+LH
+1yPwSronOy7u8VcvF21S+eh1xaf8l5msozYg7zCQNm5x2mK8FreTE7aJ8uun3YJ
VCmN0Nty0bE=
=HWez
-----END PGP SIGNATURE-----

--Apple-Mail=_29505F4B-67B1-4A11-A0F5-E97EA94963CA--
