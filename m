Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <BE1492A6-DF52-428C-A3CE-E91F0ACC0ADA@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_2D7C58E8-FE16-4F7C-A1F8-8624FDED109F";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: ioctl FIBMAP for dax gone in v4.17-rc1
Date: Tue, 17 Apr 2018 11:40:00 -0600
In-Reply-To: <20180417165756.GC24738@magnolia>
References: <20180417144059.nwbbynhgq3k3i63q@XZHOUW.usersys.redhat.com>
 <20180417161056.GA24257@infradead.org>
 <CAPcyv4i05nP=wmOMwKFbdwqBrYXpcPBCmR4g2b4w8vOZaCBEnQ@mail.gmail.com>
 <20180417165756.GC24738@magnolia>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@infradead.org>, Xiong Zhou <xzhou@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, fstests <fstests@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


--Apple-Mail=_2D7C58E8-FE16-4F7C-A1F8-8624FDED109F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 17, 2018, at 10:57 AM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Tue, Apr 17, 2018 at 09:53:47AM -0700, Dan Williams wrote:
>> On Tue, Apr 17, 2018 at 9:10 AM, Christoph Hellwig =
<hch@infradead.org> wrote:
>>> On Tue, Apr 17, 2018 at 10:40:59PM +0800, Xiong Zhou wrote:
>>>> We got these in v4.17-rc1:
>>>> 6e2608d xfs, dax: introduce xfs_dax_aops
>>>> fb094c9 ext2, dax: introduce ext2_dax_aops
>>>> 5f0663b ext4, dax: introduce ext4_dax_aops
>>>>=20
>>>> And we don't have ->bmap call in these aops, which may lead
>>>> to the ioctl call failure.
>>>>=20
>>>> Do we have any plan of adding/supporting it ?
>>>>=20
>>>> xfstests generic/223 covers this issue. If we are not going
>>>> to support this call for dax, we need to fix the testcase.
>>>=20
>>> Not supporting ->bmap is a good thing as it is hightly dangerous.
>>=20
>> I take this to mean "don't fix, it is another casualty of dax being
>> experimental and it won't be coming back". I can get on board with
>> that.
>>=20
>> Otherwise, I was about to send a series adding bmap to =
{xfs,ext2,ext4}_dax_ops.
>=20
> Frankly I'd rather see the swapfile code learn how to iomap and then =
we
> can get rid of bmap in xfs entirely.

Is anyone still using LILO to boot?  It needed FIBMAP support to map the
kernel image for booting.  I don't know if Grub needs FIBMAP support for
the early boot stages or not (it has minimal filesystem support in the
later stages), but it would be a shame if it wasn't possible to boot an
all-NVRAM system as a result of a missing ->bmap() method.  Alternately,
convince the Grub folks to use FIEMAP if that is available...

Cheers, Andreas






--Apple-Mail=_2D7C58E8-FE16-4F7C-A1F8-8624FDED109F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlrWMXAACgkQcqXauRfM
H+CMBw/+PBeTCNKe7szYdY6UEqwF4CNrgbMz8pQvTZXiFnyZWRP/SxUOQ/sMQB4p
8zN/P1aV5MjyYGGyKA3+zpw5TM9af6a/guaJ74EM0cSJI1/GSKdR81YsILo0+RS9
Hue8AnlMQc+PguNvIytDVebvxNfC7Sv+Pt/6FqCEy8LGjEOtRdg0k3KBUyfBAOBY
P+CRGtd0Y0PlJ6oGhBCz10VsK4i/GNvfc2CG9UZU3u7sfGX7pWIU8lTYPXRrqfBW
QkU90sOPYYr4odc7DHvYnc/JjdvQ2HbDXAdRzyzEk66lV9u/SfIhzG/HZmqUd6St
964lXbHtHk0Dg6szPSH9PdmWydaqlLzMQhsxQQnCHe8bK0b9gAjqz/KJ8nTDJC+c
kLJqLAeftDdlqZNI/bqs91GHwEOWnh6ANp4DaDIcpKwCLpMxuwa90DlpkdCbcv6l
QR/KnHDA0/xooWiwj9qK2rOaKPorzf/A/HSE7uKNlOtjOQ62XfKLpKePxq//udtx
VfKVXx2iIVVOzNfHMjbOJWjm/FTfV4hzRC7qVSA71vhjk4v0vpUpJjjdle8LdktQ
nFJDqbEYN/E3No/o4z+FLVxRbQC6T8X/eyt+BMowBkYhoMoTm17yNkIrmuid8Rj7
jOCRT6wfJz3yfVu3N4XjN38tULYgn0i3wtjeCt3ANuYgfgG2rFg=
=qByV
-----END PGP SIGNATURE-----

--Apple-Mail=_2D7C58E8-FE16-4F7C-A1F8-8624FDED109F--
