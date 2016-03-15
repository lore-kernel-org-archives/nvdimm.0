Return-Path: <linux-kernel-owner@vger.kernel.org>
From: NeilBrown <neilb@suse.com>
Date: Wed, 16 Mar 2016 09:15:25 +1100
Subject: Re: [PATCH 0/4] Remove un-needed 'major' registration when alloc_disk(0) is used.
In-Reply-To: <20160314225017.GC19926@linux.intel.com>
References: <20160309215702.20904.61407.stgit@noble> <20160314225017.GC19926@linux.intel.com>
Message-ID: <878u1jgzgi.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Keith Busch <keith.busch@intel.com>, Maxim Levitsky <maximlevitsky@gmail.com>, Vishal Verma <vishal.l.verma@intel.com>, Jens Axboe <axboe@fb.com>, Dan Williams <dan.j.williams@intel.com>, linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 15 2016, Ross Zwisler wrote:

> On Thu, Mar 10, 2016 at 08:59:28AM +1100, NeilBrown wrote:
>> When alloc_disk(0) is used, the ->major number is ignored and
>> irrelevant.  Yet several drivers register a major number anyway.
>>=20
>> This series of patches removes the pointless registrations.  The pmem
>> driver also does this, but a patch has already been sent for that
>> driver.
>>=20
>> Note that I am not in a position to test these beyond simple compile
>> testing.
>>=20
>> Thanks,
>> NeilBrown
>>=20
>>=20
>> ---
>>=20
>> NeilBrown (4):
>>       nvdimm/blk: don't allocate unused major device number
>>       nvdimm/btt: don't allocate unused major device number
>>       memstick: don't allocate unused major for ms_block
>>       NVMe: don't allocate unused nvme_major
>>=20
>>=20
>>  drivers/memstick/core/ms_block.c |   17 ++---------------
>>  drivers/nvdimm/blk.c             |   18 +-----------------
>>  drivers/nvdimm/btt.c             |   19 ++-----------------
>>  drivers/nvme/host/core.c         |   16 +---------------
>>  4 files changed, 6 insertions(+), 64 deletions(-)
>
> There are several other drivers that allocate a major, but then use it for
> some small number of minors (1 for null_blk.c and 16 for virtio_blk.c).  =
They
> both have GENHD_FL_EXT_DEVT set, so I think what happens is that after we
> exhaust the allocated minors they hop over to having BLOCK_EXT_MAJOR as a
> major and a dynamically assigned minor.

null_blk looks like it would be safe to convert - it is just used for
testing.  Jens Axboe would probably know for sure.

virtio_blk is a much older and there may will be code which has some
sort of expectations about minor numbers.  I think it would not be worth
the risks to change it.

>
> It seems like these could easily be converted in the same way so they'd u=
se
> BLOCK_EXT_MAJOR for their major and have a bunch of dynamically assigned
> minors.
>
> Does this break something I'm not seeing?
>
> Yay for this series, by the way. :)=20

Thanks... two are in -next now (thank Dan) - I might poke the other two
in a week or two if nothing happens.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW6Il9AAoJEDnsnt1WYoG5kY8P/iSs/+Vii0CWVrSkvvYIcLyq
wVIarn5PskLtInvaST0sVzVnbUzAE08oKtmMRLKuAcRy3jQIZoh6l5XVqye7YHfv
1hDJA8RrUwuTrTeWexNQgoxPEPBqAQQIi+LWePnkAhcHxyhZF8SVuyHTUpGFPV15
TC4VCBTrotTpX4+EsG4y/TfGau4PNENZQaGiVrYwM/a8TI9I9G5mUC4G7VZE4wlY
B+ujNOj0UUO6DyOBecLxwHLHcWsVOWXeVXn6wMlE/Vix7jKT2+OhnlAQrW5TISxr
KL3dezlhBuE99tza0hnStgr9K33T49K7LGLatMPmJFNK0owTwtR4jwLTZWPeMVF/
SUOjTbYXrL34w4SPeID7FDiPpOLqMOKgIpRC1zqf4UM9gLoRYIvu1BIJ/Ab84uOk
Mz3/wwlWJjx4pHWBUZYE8WZyLLaO34vS0EXX1MhFJzJ9ZVwhMeHVzyyfJSv2xukV
mwAEN7UTt0iS0M3WH2GURc/I91LU1Rk2dxs5R61wU6blI5lZlD3SByV5A7o2rKV0
8TpXvgd3c98FNURHZnLMveBgdibZ6LAku1yLM3oJDpu4h0w18AzsZXM99IWwNIuk
sF3S8xDOD6BJpjGqjIQ8WwEBzOtqBTdvxyhJACVyr1XEHTKwC19u1jGmrgjhAFcR
kQnapfOCFfmoP8gZYA2L
=1TEC
-----END PGP SIGNATURE-----
--=-=-=--
