Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 12 Sep 2018 13:01:31 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v2 05/17] compat_ioctl: move more drivers to
 generic_compat_ioctl_ptrarg
Message-ID: <20180912130131.2c6581d5@coco.lan>
In-Reply-To: <20180912151134.436719-1-arnd@arndb.de>
References: <20180912150142.157913-1-arnd@arndb.de>
        <20180912151134.436719-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-fsdevel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, qat-linux@intel.com, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org, linux-iio@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Em Wed, 12 Sep 2018 17:08:52 +0200
Arnd Bergmann <arnd@arndb.de> escreveu:

> The .ioctl and .compat_ioctl file operations have the same prototype so
> they can both point to the same function, which works great almost all
> the time when all the commands are compatible.
>=20
> One exception is the s390 architecture, where a compat pointer is only
> 31 bit wide, and converting it into a 64-bit pointer requires calling
> compat_ptr(). Most drivers here will ever run in s390, but since we now
> have a generic helper for it, it's easy enough to use it consistently.
>=20
> I double-checked all these drivers to ensure that all ioctl arguments
> are used as pointers or are ignored, but are not interpreted as integer
> values.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

>  drivers/media/rc/lirc_dev.c                 | 4 +---

> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> index f862f1b7f996..077209f414ed 100644
> --- a/drivers/media/rc/lirc_dev.c
> +++ b/drivers/media/rc/lirc_dev.c
> @@ -730,9 +730,7 @@ static const struct file_operations lirc_fops =3D {
>  	.owner		=3D THIS_MODULE,
>  	.write		=3D ir_lirc_transmit_ir,
>  	.unlocked_ioctl	=3D ir_lirc_ioctl,
> -#ifdef CONFIG_COMPAT
> -	.compat_ioctl	=3D ir_lirc_ioctl,
> -#endif
> +	.compat_ioctl	=3D generic_compat_ioctl_ptrarg,
>  	.read		=3D ir_lirc_read,
>  	.poll		=3D ir_lirc_poll,
>  	.open		=3D ir_lirc_open,

Adding an infrared remote controller to a s390 mainframe sounds fun :-)

I suspect that one could implement it on a s390 platform=20
using gpio-ir-recv and/or gpio-ir-tx drivers. Perhaps one possible
practical usage would be to let the mainframe to send remote
controller codes to adjust the air conditioning system ;-)

=46rom lirc driver's PoV, there's nothing that really prevents one to
do that and use lirc API, and the driver is generic enough to work
on any hardware platform.

I didn't check the implementation of generic_compat_ioctl_ptrarg(),
but assuming it is ok,

Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Thanks,
Mauro
