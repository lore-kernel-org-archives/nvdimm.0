Return-Path: <linux-ext4-owner@vger.kernel.org>
Date: Tue, 12 Sep 2017 11:03:49 +0200
From: Simon Ruderich <simon@ruderich.org>
Subject: Re: Unexpected writes seen on a Read-only, DAX enabled EXT4 fs
Message-ID: <20170912090349.6ow4bv56px2uoqw3@ruderich.org>
References: <2036030243.251059.1504977026265.ref@mail.yahoo.com>
 <2036030243.251059.1504977026265@mail.yahoo.com>
 <20170911182112.GA20005@linux.intel.com>
 <9F35007B-F0D9-4FB9-A52D-604E410AB389@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512; protocol="application/pgp-signature"; boundary="=_zucker.schokokeks.org-32653-1505207029-0001-2"
Content-Disposition: inline
In-Reply-To: <9F35007B-F0D9-4FB9-A52D-604E410AB389@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Soccer Liu <soccer_liu@yahoo.com>, linux-ext4@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_zucker.schokokeks.org-32653-1505207029-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 11, 2017 at 02:31:41PM -0600, Andreas Dilger wrote:
> On Sep 11, 2017, at 12:21 PM, Ross Zwisler wrote:
>>
>> On Sat, Sep 09, 2017 at 05:10:26PM +0000, Soccer Liu wrote:
>>> [snip]
>>>
>>> Based on the following Mount documentation below, I did mount this ext =
fs
>>> with ro and noloadAre there any other options that I could use to total=
ly
>>> eliminate those unexpected writes?
>
> [snip]
>
> Also, ext4 journal recovery will be done on the filesystem regardless of
> whether it is mounted read-only or not.

I thought the noload option should prevent journal recovery and
thus be truly read-only. At least it worked on a read-only device
for me.

Regards
Simon
--=20
+ privacy is necessary
+ using gnupg http://gnupg.org
+ public key id: 0x92FEFDB7E44C32F9

--=_zucker.schokokeks.org-32653-1505207029-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEO7rfWMMObpFkF3n0kv79t+RMMvkFAlm3oukACgkQkv79t+RM
MvkljhAAgL8vaZnFbstn2XSYgs7IZCUABJLur5cKUUwUFryZ/WDzWAQATaZvXh3V
PP0i4X+sTKGMQPOqseu2mScFk+eauceN+T3NGkgGn9r3q95AbamLt7JPd/dnK1oG
rRUB/kkEJlP69UAYbZQLgPcjzywy8RTqpntUWhFpNa9Kp/4KbreqR8vIJGL8Atzp
gr1WC+mH7f6jwD4J/cB7NVRxReFgS3pY/dXm2JJvCMPcHE0x9dRSLtgE9jPSYktK
ztMYXj243fJ+KCr1swlY8+UAfdvr2kpWXONGlcA33fPXVV90tBtnjSiXkm7Tm+fa
+ZEmSOnCVGqKfVnWMJY6A9icrNv1lcMAAI7yt4YZXYCfiBG/9Bz3Zz36GNLKv46s
zT0fsHNlBME/p8DsIOOIY4I2xTeDwsCwDcBmKb4lt1ylE8sgqjd1NGLW9WhoLFxj
FN0Vk7zbuh6XDTowC2knfz2cZdYdtbqLmZHkXquuDRfPpASkoPUzkZZfHni0OpTT
bNV+QNMs8ulZjMkfXun8LpwVaXdIq1hv82Xl5bfaRNCdaxG3JNHuCIaR6BetstNb
L+AdPHrDoiZmOxhDW5RsHVVZMNe5ygQ1ENnUe6thIUa2A1V5djkDdraK/WG6BL3r
YYF+OZ3K+ZpebTMpGgqGye+W7H2Jwrjjqeo0GBfv/yf+M1WKY/Y=
=xnvw
-----END PGP SIGNATURE-----

--=_zucker.schokokeks.org-32653-1505207029-0001-2--
