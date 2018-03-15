Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <35F18E78-D604-4B3E-B73D-8DB88B648C78@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_BCD56DE1-C216-4C39-9DA3-B550D214E66F";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [RFC v2 03/83] Add super.h.
Date: Thu, 15 Mar 2018 14:04:17 -0600
In-Reply-To: <CAD4Szjt6URWFEuB_qZcnoQMqCLNwyCns0CCP==Su7iQOt=ddMw@mail.gmail.com>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
 <1520705944-6723-4-git-send-email-jix024@eng.ucsd.edu>
 <20180315045401.GB4860@magnolia>
 <CAD4SzjtHmBTisX6vQYuEnJf0fKsF==w5GHqsdks6xGv1go7Lzw@mail.gmail.com>
 <CAK8P3a1OJqHEOgiHk1ZQytGW7b1c2Nam5xjSxxkfx=h2x7f_mg@mail.gmail.com>
 <CAD4Szjt6URWFEuB_qZcnoQMqCLNwyCns0CCP==Su7iQOt=ddMw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andiry Xu <jix024@eng.ucsd.edu>
Cc: Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dan Williams <dan.j.williams@intel.com>, "Rudoff, Andy" <andy.rudoff@intel.com>, coughlan@redhat.com, Steven Swanson <swanson@cs.ucsd.edu>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, swhiteho@redhat.com, miklos@szeredi.hu, Jian Xu <andiry.xu@gmail.com>, Andiry Xu <jix024@cs.ucsd.edu>
List-ID: <linux-nvdimm@lists.01.org>


--Apple-Mail=_BCD56DE1-C216-4C39-9DA3-B550D214E66F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 15, 2018, at 11:51 AM, Andiry Xu <jix024@eng.ucsd.edu> wrote:
>=20
> On Thu, Mar 15, 2018 at 2:05 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Thu, Mar 15, 2018 at 7:11 AM, Andiry Xu <jix024@eng.ucsd.edu> =
wrote:
>>> On Wed, Mar 14, 2018 at 9:54 PM, Darrick J. Wong
>>> <darrick.wong@oracle.com> wrote:
>>>> On Sat, Mar 10, 2018 at 10:17:44AM -0800, Andiry Xu wrote:
>>=20
>>>>> +     /* s_mtime and s_wtime should be together and their order =
should not be
>>>>> +      * changed. we use an 8 byte write to update both of them =
atomically
>>>>> +      */
>>>>> +     __le32          s_mtime;                /* mount time */
>>>>> +     __le32          s_wtime;                /* write time */
>>>>=20
>>>> Hmmm, 32-bit timestamps?  2038 isn't that far away...
>>>>=20
>>>=20
>>> I will try fixing this in the next version.
>>=20
>> I would also recommend adding nanosecond-resolution timestamps.
>> In theory, a signed 64-bit nanosecond field is sufficient for each =
timestamp
>> (it's good for several hundred years), but the more common format =
uses
>> 64-bit seconds and 32-bit nanoseconds in other file systems.
>>=20
>> Unfortunately it looks, you will have to come up with a more =
sophisticated
>> update method above, even if you leave out the nanoseconds, you can't
>> easily rely on a 16-byte atomic update across architectures to deal =
with
>> the two 64-bit timestamps. For the superblock fields, you might be =
able
>> to get away with using second resolution, and then encoding the
>> timestamps as a signed 64-bit 'mkfs time' along with two unsigned
>> 32-bit times added on top, which gives you a range of 136 years mount
>> a file system after its creation.
>>=20
>=20
> I will take a look at other file systems.
>=20
> Superblock mtime is not a big problem as it is updated rarely. 64-bit
> seconds and 32-bit nanoseconds make the inode and log entry bigger,
> and updating file->atime cannot be done with a single 64bit update.
> That may be annoying and needs to use journaling.

If the 64-bit atomicity was really a performance issue, you could do
something like:

	__u32	time_high =3D seconds >> 32;
	__u64	time_low =3D seconds << 32 | nanoseconds;

and then you only need to update time_high with a journal operation if =
it
has changed from the current time_high value (about once every 140 =
years),
and the time_low can be set atomically.  It needs a few extra cycles =
each
time (hidden with an unlikely()) vs. just setting both, but that is a =
win
if it avoids other CPU or IO overhead.

Cheers, Andreas






--Apple-Mail=_BCD56DE1-C216-4C39-9DA3-B550D214E66F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlqq0cEACgkQcqXauRfM
H+DRCxAAsrmnJRLKprl2A1oLrDWNBQZFiPO1m+3BXcneIrHbr3WXS2bGPZp5Nv6W
DS6cmAXS1ZGkstxSTP+1vot59/Uh9KetE28sdvrzlwzk7/8eej53wQs04yVMAuh/
z416SkUInDEW7oKLMA+E8gL1u16l0RnBSaIkHunDd6NPWNQ3HR5NMWqivV0UpI2T
xT58NgQxwSS3zJpVgwnmwcY9l6sAhG0qyml542VLYtlHx4QNQuTmzdhY0rQhbKbp
mDS/XRgj5z26MqLQj2pGWzlGiHU6GyBTwvdg59mj3hTb4P29G24g33Cm4mOgm9Oc
8D1EmxQj1fzC+Y/rf5BF19lR8cr4BdPVEveHM8NmbOImu6ZVEPNUl7n7RYGV3aax
G0zEw9zswhNmuY445x+y2ZvaO+qTQO/qsKz8My4mHW0wkdoC3cHEjoUeUwQhYy0A
ucquJsRjysUj5c+luIj96XqudbgA7DGx85WXkvBc3doLWdQo2xIwgN6v4oNRrJEP
qRwu0EaQMZh3Ka2SGcxnS+lWRbH1CF1uQSqDLxzr3aniQLPd6NDfLVmn1Yy5CXrZ
6YrhdL9z6DC4A9FMJrDX22fnGxabYuxyehmTklXP6whX4gJ9w2XLVvlDoYqoWPW5
aUP/llSAHNMCzzR+qL3RPsbtfUftbAy0Yt6lJj5WG+R/yu63k5w=
=xcW6
-----END PGP SIGNATURE-----

--Apple-Mail=_BCD56DE1-C216-4C39-9DA3-B550D214E66F--
