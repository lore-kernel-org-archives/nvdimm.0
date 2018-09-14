Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 352EF21962301
 for <linux-nvdimm@lists.01.org>; Fri, 14 Sep 2018 13:35:25 -0700 (PDT)
Date: Fri, 14 Sep 2018 13:35:06 -0700
From: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH v2 05/17] compat_ioctl: move more drivers to
 generic_compat_ioctl_ptrarg
Message-ID: <20180914203506.GE35251@wrath>
References: <20180912150142.157913-1-arnd@arndb.de>
 <20180912151134.436719-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180912151134.436719-1-arnd@arndb.de>
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

On Wed, Sep 12, 2018 at 05:08:52PM +0200, Arnd Bergmann wrote:
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
...
>  drivers/platform/x86/wmi.c                  | 2 +-
...
>  static void link_event_work(struct work_struct *work)
> diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
> index 04791ea5d97b..e4d0697e07d6 100644
> --- a/drivers/platform/x86/wmi.c
> +++ b/drivers/platform/x86/wmi.c
> @@ -886,7 +886,7 @@ static const struct file_operations wmi_fops = {
>  	.read		= wmi_char_read,
>  	.open		= wmi_char_open,
>  	.unlocked_ioctl	= wmi_ioctl,
> -	.compat_ioctl	= wmi_ioctl,
> +	.compat_ioctl	= generic_compat_ioctl_ptrarg,
>  };

For platform/drivers/x86:

Acked-by: Darren Hart (VMware) <dvhart@infradead.org>

As for a longer term solution, would it be possible to init fops in such
a way that the compat_ioctl call defaults to generic_compat_ioctl_ptrarg
so we don't have to duplicate this boilerplate for every ioctl fops
structure?

-- 
Darren Hart
VMware Open Source Technology Center
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
