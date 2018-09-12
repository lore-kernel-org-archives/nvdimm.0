Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 12 Sep 2018 09:56:39 -0600
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 05/17] compat_ioctl: move more drivers to
 generic_compat_ioctl_ptrarg
Message-ID: <20180912155639.GF5633@ziepe.ca>
References: <20180912150142.157913-1-arnd@arndb.de>
 <20180912151134.436719-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180912151134.436719-1-arnd@arndb.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, qat-linux@intel.com, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org, linux-iio@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org
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
>  drivers/android/binder.c                    | 2 +-
>  drivers/crypto/qat/qat_common/adf_ctl_drv.c | 2 +-
>  drivers/dma-buf/dma-buf.c                   | 4 +---
>  drivers/dma-buf/sw_sync.c                   | 2 +-
>  drivers/dma-buf/sync_file.c                 | 2 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_chardev.c    | 2 +-
>  drivers/hid/hidraw.c                        | 4 +---
>  drivers/iio/industrialio-core.c             | 2 +-
>  drivers/infiniband/core/uverbs_main.c       | 4 ++--
>  drivers/media/rc/lirc_dev.c                 | 4 +---
>  drivers/mfd/cros_ec_dev.c                   | 4 +---
>  drivers/misc/vmw_vmci/vmci_host.c           | 2 +-
>  drivers/nvdimm/bus.c                        | 4 ++--
>  drivers/nvme/host/core.c                    | 2 +-
>  drivers/pci/switch/switchtec.c              | 2 +-
>  drivers/platform/x86/wmi.c                  | 2 +-
>  drivers/rpmsg/rpmsg_char.c                  | 4 ++--
>  drivers/sbus/char/display7seg.c             | 2 +-
>  drivers/sbus/char/envctrl.c                 | 4 +---
>  drivers/scsi/3w-xxxx.c                      | 4 +---
>  drivers/scsi/cxlflash/main.c                | 2 +-
>  drivers/scsi/esas2r/esas2r_main.c           | 2 +-
>  drivers/scsi/pmcraid.c                      | 4 +---
>  drivers/staging/android/ion/ion.c           | 4 +---
>  drivers/staging/vme/devices/vme_user.c      | 2 +-
>  drivers/tee/tee_core.c                      | 2 +-
>  drivers/usb/class/cdc-wdm.c                 | 2 +-
>  drivers/usb/class/usbtmc.c                  | 4 +---
>  drivers/video/fbdev/ps3fb.c                 | 2 +-
>  drivers/virt/fsl_hypervisor.c               | 2 +-
>  fs/btrfs/super.c                            | 2 +-
>  fs/ceph/dir.c                               | 2 +-
>  fs/ceph/file.c                              | 2 +-
>  fs/fuse/dev.c                               | 2 +-
>  fs/notify/fanotify/fanotify_user.c          | 2 +-
>  fs/userfaultfd.c                            | 2 +-
>  net/rfkill/core.c                           | 2 +-
>  37 files changed, 40 insertions(+), 58 deletions(-)

> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> index 823beca448e1..f4755c1c9cfa 100644
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -930,7 +930,7 @@ static const struct file_operations uverbs_fops = {
>  	.release = ib_uverbs_close,
>  	.llseek	 = no_llseek,
>  	.unlocked_ioctl = ib_uverbs_ioctl,
> -	.compat_ioctl = ib_uverbs_ioctl,
> +	.compat_ioctl = generic_compat_ioctl_ptrarg,
>  };
>  
>  static const struct file_operations uverbs_mmap_fops = {
> @@ -941,7 +941,7 @@ static const struct file_operations uverbs_mmap_fops = {
>  	.release = ib_uverbs_close,
>  	.llseek	 = no_llseek,
>  	.unlocked_ioctl = ib_uverbs_ioctl,
> -	.compat_ioctl = ib_uverbs_ioctl,
> +	.compat_ioctl = generic_compat_ioctl_ptrarg,
>  };
>  
>  static struct ib_client uverbs_client = {

For uverbs:

Acked-by: Jason Gunthorpe <jgg@mellanox.com>

It is very strange, this patch did not appear in the RDMA patchworks,
I almost missed it  :|

Jason
