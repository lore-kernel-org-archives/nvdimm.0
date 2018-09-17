Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E5C69211299A1
 for <linux-nvdimm@lists.01.org>; Mon, 17 Sep 2018 02:34:18 -0700 (PDT)
Date: Mon, 17 Sep 2018 10:33:48 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [PATCH v2 05/17] compat_ioctl: move more drivers to
 generic_compat_ioctl_ptrarg
Message-ID: <20180917103348.00003f31@huawei.com>
In-Reply-To: <20180912151134.436719-1-arnd@arndb.de>
References: <20180912150142.157913-1-arnd@arndb.de>
 <20180912151134.436719-1-arnd@arndb.de>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fbdev@vger.kernel.org, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-nvme@lists.infradead.org, platform-driver-x86@vger.kernel.org, sparclinux@vger.kernel.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, qat-linux@intel.com, amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org, linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org, ceph-devel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>, linux-btrfs@vger.kernel.org, viro@zeniv.linux.org.uk
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 12 Sep 2018 17:08:52 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> The .ioctl and .compat_ioctl file operations have the same prototype so
> they can both point to the same function, which works great almost all
> the time when all the commands are compatible.
> 
> One exception is the s390 architecture, where a compat pointer is only
> 31 bit wide, and converting it into a 64-bit pointer requires calling
> compat_ptr(). Most drivers here will ever run in s390, but since we now
> have a generic helper for it, it's easy enough to use it consistently.
> 
> I double-checked all these drivers to ensure that all ioctl arguments
> are used as pointers or are ignored, but are not interpreted as integer
> values.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

For IIO part.

Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Thanks,
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index a062cfddc5af..22844b94b0e9 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -1630,7 +1630,7 @@ static const struct file_operations iio_buffer_fileops = {
>  	.owner = THIS_MODULE,
>  	.llseek = noop_llseek,
>  	.unlocked_ioctl = iio_ioctl,
> -	.compat_ioctl = iio_ioctl,
> +	.compat_ioctl = generic_compat_ioctl_ptrarg,
>  };
>  

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
