Return-Path: <linux-ext4-owner@vger.kernel.org>
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <5F58D3F5-D93B-4648-AE01-8A46956FBB4B@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_731D3B21-257E-4633-80D4-CB7DD9B217F4";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
Date: Thu, 7 Sep 2017 15:26:10 -0600
In-Reply-To: <20170907211303.GA23212@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
 <20170906170754.GB17663@linux.intel.com>
 <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
 <20170907211303.GA23212@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Eric Sandeen <sandeen@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>


--Apple-Mail=_731D3B21-257E-4633-80D4-CB7DD9B217F4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 7, 2017, at 3:13 PM, Ross Zwisler <ross.zwisler@linux.intel.com> =
wrote:
>=20
> On Thu, Sep 07, 2017 at 01:54:45PM -0700, Dan Williams wrote:
>> On Wed, Sep 6, 2017 at 10:07 AM, Ross Zwisler
>> <ross.zwisler@linux.intel.com> wrote:
>>> On Tue, Sep 05, 2017 at 09:12:35PM -0500, Eric Sandeen wrote:
>>>> On 9/5/17 5:35 PM, Ross Zwisler wrote:
>>>>> The original intent of this series was to add a per-inode DAX flag =
to ext4
>>>>> so that it would be consistent with XFS.  In my travels I found =
and fixed
>>>>> several related issues in both ext4 and XFS.
>>>>=20
>>>> Hi Ross -
>>>>=20
>>>> hch had a lot of reasons to nuke the dax flag from orbit, and we =
just
>>>> /disabled/ it in xfs due to its habit of crashing the kernel...
>>>=20
>>> Ah, sorry, I wasn't CC'd on those threads and missed them.  For any =
interested
>>> bystanders:
>>>=20
>>> https://www.spinics.net/lists/linux-ext4/msg57840.html
>>> https://www.spinics.net/lists/linux-xfs/msg09831.html
>>> https://www.spinics.net/lists/linux-xfs/msg10124.html
>>>=20
>>>> so a couple questions:
>>>>=20
>>>> 1) does this series pass hch's "test the per-inode DAX flag" =
fstest?
>>>=20
>>> Nope, it has the exact same problems as the XFS per-inode DAX flag.
>>>=20
>>>> 2) do we have an agreement that we need this flag at all, or is =
this
>>>>   just a parity item because xfs has^whad a per-inode flag?
>>>=20
>>> It was for parity, and because it allows admins finer grained =
control over
>>> their system.  Basically all things discussed in response to Lukas's =
original
>>> patch in the first link above.
>>=20
>> I think it's more than parity. When pmem is slower than page cache it
>> is actively harmful to have DAX enabled globally for a filesystem. =
So,
>> not only should we push for per-inode DAX control, we should also =
push
>> to deprecate the mount option. I agree with Christoph that we should
>> try to automatically and transparently enable DAX where it makes
>> sense, but we also need a finer-grained mechanism than a mount flag =
to
>> force the behavior one way or the other.
>=20
> Yep, agreed.  I'll play with how to make this work after I've sorted =
out all
> the data corruptions I've found. :)

It seems that the majority of problems are from enabling/disabling S_DAX
on an inode that already has dirty data.  However, I wonder if this =
could
be prevented at runtime, and only allow S_DAX to be set when the inode =
is
first instantiated, and wouldn't be allowed to change after that?  =
Setting
or clearing the per-inode DAX flag might still be allowed, but it =
wouldn't
be enabled until the inode is next fetched into cache?  Similarly, for
inodes that have conflicting features (e.g. inline data or encryption)
would not be allowed to enable S_DAX.

My assumption here is that it is possible to fall back to always using
page cache for such inodes, and flush the data to pmem via the block
interface for inodes that don't have S_DAX set?

That would allow the vast majority of cases to work out of the box, or =
in
a few rare cases where the DAX feature is being changed (e.g. inline =
data
inode on disk growing to external disk blocks) would use the page cache
until such a time that the inode is dropped from cache and reloaded (at
worst the next remount).

Cheers, Andreas






--Apple-Mail=_731D3B21-257E-4633-80D4-CB7DD9B217F4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZsblzpIg59Q01vtYRAnABAKDJDRHlR0nDJAoSc7jm75W+nhjS5ACfU3Uy
EvECK/H68rvmzhmF9bjQzfo=
=Or3G
-----END PGP SIGNATURE-----

--Apple-Mail=_731D3B21-257E-4633-80D4-CB7DD9B217F4--
