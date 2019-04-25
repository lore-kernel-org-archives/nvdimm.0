From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v3 12/26] compat_ioctl: move more drivers to
 compat_ptr_ioctl
Date: Thu, 25 Apr 2019 12:21:53 -0300
Message-ID: <20190425122153.450fc094@coco.lan>
References: <20190416202013.4034148-1-arnd@arndb.de>
        <20190416202701.127745-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190416202701.127745-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, y2038@lists.linaro.org, linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Sterba <dsterba@suse.com>, Darren Hart <dvhart@infradead.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, devel@driverdev.osuosl.org, qat-linux@intel.com, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org, linux-iio@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-pci@vger
List-Id: linux-nvdimm@lists.01.org

Em Tue, 16 Apr 2019 22:25:33 +0200
Arnd Bergmann <arnd@arndb.de> escreveu:

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
> Acked-by: Jason Gunthorpe <jgg@mellanox.com>
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: David Sterba <dsterba@suse.com>
> Acked-by: Darren Hart (VMware) <dvhart@infradead.org>
> Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
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

If I understand your patch description well, using compat_ptr_ioctl
only works if the driver is not for s390, right?

In thesis, nothing prevents to use LIRC API on s390 - as this isn't
a driver but, instead, RC core feature to expose raw remote controller
codes to userspace.

Yet, lirc_dev will only work if the system has a remote controller driver.

Well, we don't have any for s390. Despite we don't have such driver, 
I can't possible see why someone would use a remote controller for a
mainframe :-p

Anyway, if someone ever come with such driver/usecase, reverting this
change (or adding an #ifdef to check if arch is 390) should be
pretty straight forward.

So:

Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>



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
>  drivers/virt/fsl_hypervisor.c               | 2 +-
>  fs/btrfs/super.c                            | 2 +-
>  fs/ceph/dir.c                               | 2 +-
>  fs/ceph/file.c                              | 2 +-
>  fs/fuse/dev.c                               | 2 +-
>  fs/notify/fanotify/fanotify_user.c          | 2 +-
>  fs/userfaultfd.c                            | 2 +-
>  net/rfkill/core.c                           | 2 +-
>  36 files changed, 39 insertions(+), 57 deletions(-)
> 
> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> index 4b9c7ca492e6..48109ade7234 100644
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -5998,7 +5998,7 @@ const struct file_operations binder_fops = {
>  	.owner = THIS_MODULE,
>  	.poll = binder_poll,
>  	.unlocked_ioctl = binder_ioctl,
> -	.compat_ioctl = binder_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  	.mmap = binder_mmap,
>  	.open = binder_open,
>  	.flush = binder_flush,
> diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
> index abc7a7f64d64..ef0e482ee04f 100644
> --- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
> +++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
> @@ -68,7 +68,7 @@ static long adf_ctl_ioctl(struct file *fp, unsigned int cmd, unsigned long arg);
>  static const struct file_operations adf_ctl_ops = {
>  	.owner = THIS_MODULE,
>  	.unlocked_ioctl = adf_ctl_ioctl,
> -	.compat_ioctl = adf_ctl_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  };
>  
>  struct adf_ctl_drv_info {
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 7c858020d14b..0cb336fe6324 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -325,9 +325,7 @@ static const struct file_operations dma_buf_fops = {
>  	.llseek		= dma_buf_llseek,
>  	.poll		= dma_buf_poll,
>  	.unlocked_ioctl	= dma_buf_ioctl,
> -#ifdef CONFIG_COMPAT
> -	.compat_ioctl	= dma_buf_ioctl,
> -#endif
> +	.compat_ioctl	= compat_ptr_ioctl,
>  };
>  
>  /*
> diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
> index 32dcf7b4c935..411de6a8a0ad 100644
> --- a/drivers/dma-buf/sw_sync.c
> +++ b/drivers/dma-buf/sw_sync.c
> @@ -419,5 +419,5 @@ const struct file_operations sw_sync_debugfs_fops = {
>  	.open           = sw_sync_debugfs_open,
>  	.release        = sw_sync_debugfs_release,
>  	.unlocked_ioctl = sw_sync_ioctl,
> -	.compat_ioctl	= sw_sync_ioctl,
> +	.compat_ioctl	= compat_ptr_ioctl,
>  };
> diff --git a/drivers/dma-buf/sync_file.c b/drivers/dma-buf/sync_file.c
> index 4f6305ca52c8..0949f91eb85f 100644
> --- a/drivers/dma-buf/sync_file.c
> +++ b/drivers/dma-buf/sync_file.c
> @@ -488,5 +488,5 @@ static const struct file_operations sync_file_fops = {
>  	.release = sync_file_release,
>  	.poll = sync_file_poll,
>  	.unlocked_ioctl = sync_file_ioctl,
> -	.compat_ioctl = sync_file_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  };
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
> index 083bd8114db1..5d6ac7885aa7 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
> @@ -49,7 +49,7 @@ static const char kfd_dev_name[] = "kfd";
>  static const struct file_operations kfd_fops = {
>  	.owner = THIS_MODULE,
>  	.unlocked_ioctl = kfd_ioctl,
> -	.compat_ioctl = kfd_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  	.open = kfd_open,
>  	.mmap = kfd_mmap,
>  };
> diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
> index 9fc51eff1079..e7284d38b66d 100644
> --- a/drivers/hid/hidraw.c
> +++ b/drivers/hid/hidraw.c
> @@ -476,9 +476,7 @@ static const struct file_operations hidraw_ops = {
>  	.release =      hidraw_release,
>  	.unlocked_ioctl = hidraw_ioctl,
>  	.fasync =	hidraw_fasync,
> -#ifdef CONFIG_COMPAT
> -	.compat_ioctl   = hidraw_ioctl,
> -#endif
> +	.compat_ioctl   = compat_ptr_ioctl,
>  	.llseek =	noop_llseek,
>  };
>  
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index 4700fd5d8c90..eed1bea257b4 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -1635,7 +1635,7 @@ static const struct file_operations iio_buffer_fileops = {
>  	.owner = THIS_MODULE,
>  	.llseek = noop_llseek,
>  	.unlocked_ioctl = iio_ioctl,
> -	.compat_ioctl = iio_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  };
>  
>  static int iio_check_unique_scan_index(struct iio_dev *indio_dev)
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> index 70b7d80431a9..ac4321d7c800 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -1120,7 +1120,7 @@ static const struct file_operations uverbs_fops = {
>  	.release = ib_uverbs_close,
>  	.llseek	 = no_llseek,
>  	.unlocked_ioctl = ib_uverbs_ioctl,
> -	.compat_ioctl = ib_uverbs_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  };
>  
>  static const struct file_operations uverbs_mmap_fops = {
> @@ -1131,7 +1131,7 @@ static const struct file_operations uverbs_mmap_fops = {
>  	.release = ib_uverbs_close,
>  	.llseek	 = no_llseek,
>  	.unlocked_ioctl = ib_uverbs_ioctl,
> -	.compat_ioctl = ib_uverbs_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  };
>  
>  static struct ib_client uverbs_client = {
> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> index f862f1b7f996..9ccc7e9cbc8e 100644
> --- a/drivers/media/rc/lirc_dev.c
> +++ b/drivers/media/rc/lirc_dev.c
> @@ -730,9 +730,7 @@ static const struct file_operations lirc_fops = {
>  	.owner		= THIS_MODULE,
>  	.write		= ir_lirc_transmit_ir,
>  	.unlocked_ioctl	= ir_lirc_ioctl,
> -#ifdef CONFIG_COMPAT
> -	.compat_ioctl	= ir_lirc_ioctl,
> -#endif
> +	.compat_ioctl	= compat_ptr_ioctl,
>  	.read		= ir_lirc_read,
>  	.poll		= ir_lirc_poll,
>  	.open		= ir_lirc_open,
> diff --git a/drivers/mfd/cros_ec_dev.c b/drivers/mfd/cros_ec_dev.c
> index d275deaecb12..4a602a40d75c 100644
> --- a/drivers/mfd/cros_ec_dev.c
> +++ b/drivers/mfd/cros_ec_dev.c
> @@ -251,9 +251,7 @@ static const struct file_operations fops = {
>  	.release = ec_device_release,
>  	.read = ec_device_read,
>  	.unlocked_ioctl = ec_device_ioctl,
> -#ifdef CONFIG_COMPAT
> -	.compat_ioctl = ec_device_ioctl,
> -#endif
> +	.compat_ioctl = compat_ptr_ioctl,
>  };
>  
>  static void cros_ec_class_release(struct device *dev)
> diff --git a/drivers/misc/vmw_vmci/vmci_host.c b/drivers/misc/vmw_vmci/vmci_host.c
> index 997f92543dd4..5bb406dabe85 100644
> --- a/drivers/misc/vmw_vmci/vmci_host.c
> +++ b/drivers/misc/vmw_vmci/vmci_host.c
> @@ -969,7 +969,7 @@ static const struct file_operations vmuser_fops = {
>  	.release	= vmci_host_close,
>  	.poll		= vmci_host_poll,
>  	.unlocked_ioctl	= vmci_host_unlocked_ioctl,
> -	.compat_ioctl	= vmci_host_unlocked_ioctl,
> +	.compat_ioctl	= compat_ptr_ioctl,
>  };
>  
>  static struct miscdevice vmci_host_miscdev = {
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 7bbff0af29b2..065ebd584482 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -1167,7 +1167,7 @@ static const struct file_operations nvdimm_bus_fops = {
>  	.owner = THIS_MODULE,
>  	.open = nd_open,
>  	.unlocked_ioctl = nd_ioctl,
> -	.compat_ioctl = nd_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  	.llseek = noop_llseek,
>  };
>  
> @@ -1175,7 +1175,7 @@ static const struct file_operations nvdimm_fops = {
>  	.owner = THIS_MODULE,
>  	.open = nd_open,
>  	.unlocked_ioctl = nvdimm_ioctl,
> -	.compat_ioctl = nvdimm_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  	.llseek = noop_llseek,
>  };
>  
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 2c43e12b70af..560929bee5ce 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -2739,7 +2739,7 @@ static const struct file_operations nvme_dev_fops = {
>  	.owner		= THIS_MODULE,
>  	.open		= nvme_dev_open,
>  	.unlocked_ioctl	= nvme_dev_ioctl,
> -	.compat_ioctl	= nvme_dev_ioctl,
> +	.compat_ioctl	= compat_ptr_ioctl,
>  };
>  
>  static ssize_t nvme_sysfs_reset(struct device *dev,
> diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
> index e22766c79fe9..3a54b4b616e2 100644
> --- a/drivers/pci/switch/switchtec.c
> +++ b/drivers/pci/switch/switchtec.c
> @@ -1006,7 +1006,7 @@ static const struct file_operations switchtec_fops = {
>  	.read = switchtec_dev_read,
>  	.poll = switchtec_dev_poll,
>  	.unlocked_ioctl = switchtec_dev_ioctl,
> -	.compat_ioctl = switchtec_dev_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  };
>  
>  static void link_event_work(struct work_struct *work)
> diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
> index 7b26b6ccf1a0..dded9cef42f4 100644
> --- a/drivers/platform/x86/wmi.c
> +++ b/drivers/platform/x86/wmi.c
> @@ -889,7 +889,7 @@ static const struct file_operations wmi_fops = {
>  	.read		= wmi_char_read,
>  	.open		= wmi_char_open,
>  	.unlocked_ioctl	= wmi_ioctl,
> -	.compat_ioctl	= wmi_ioctl,
> +	.compat_ioctl	= compat_ptr_ioctl,
>  };
>  
>  static int wmi_dev_probe(struct device *dev)
> diff --git a/drivers/rpmsg/rpmsg_char.c b/drivers/rpmsg/rpmsg_char.c
> index eea5ebbb5119..507bfe163883 100644
> --- a/drivers/rpmsg/rpmsg_char.c
> +++ b/drivers/rpmsg/rpmsg_char.c
> @@ -290,7 +290,7 @@ static const struct file_operations rpmsg_eptdev_fops = {
>  	.write_iter = rpmsg_eptdev_write_iter,
>  	.poll = rpmsg_eptdev_poll,
>  	.unlocked_ioctl = rpmsg_eptdev_ioctl,
> -	.compat_ioctl = rpmsg_eptdev_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  };
>  
>  static ssize_t name_show(struct device *dev, struct device_attribute *attr,
> @@ -451,7 +451,7 @@ static const struct file_operations rpmsg_ctrldev_fops = {
>  	.open = rpmsg_ctrldev_open,
>  	.release = rpmsg_ctrldev_release,
>  	.unlocked_ioctl = rpmsg_ctrldev_ioctl,
> -	.compat_ioctl = rpmsg_ctrldev_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  };
>  
>  static void rpmsg_ctrldev_release_device(struct device *dev)
> diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
> index a36e4cf1841d..c9f60656f54d 100644
> --- a/drivers/sbus/char/display7seg.c
> +++ b/drivers/sbus/char/display7seg.c
> @@ -155,7 +155,7 @@ static long d7s_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  static const struct file_operations d7s_fops = {
>  	.owner =		THIS_MODULE,
>  	.unlocked_ioctl =	d7s_ioctl,
> -	.compat_ioctl =		d7s_ioctl,
> +	.compat_ioctl =		compat_ptr_ioctl,
>  	.open =			d7s_open,
>  	.release =		d7s_release,
>  	.llseek = noop_llseek,
> diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
> index 1a6e7224017c..dd2dfa85fc68 100644
> --- a/drivers/sbus/char/envctrl.c
> +++ b/drivers/sbus/char/envctrl.c
> @@ -714,9 +714,7 @@ static const struct file_operations envctrl_fops = {
>  	.owner =		THIS_MODULE,
>  	.read =			envctrl_read,
>  	.unlocked_ioctl =	envctrl_ioctl,
> -#ifdef CONFIG_COMPAT
> -	.compat_ioctl =		envctrl_ioctl,
> -#endif
> +	.compat_ioctl =		compat_ptr_ioctl,
>  	.open =			envctrl_open,
>  	.release =		envctrl_release,
>  	.llseek =		noop_llseek,
> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> index 2b1e0d503020..fb6444d0409c 100644
> --- a/drivers/scsi/3w-xxxx.c
> +++ b/drivers/scsi/3w-xxxx.c
> @@ -1049,9 +1049,7 @@ static int tw_chrdev_open(struct inode *inode, struct file *file)
>  static const struct file_operations tw_fops = {
>  	.owner		= THIS_MODULE,
>  	.unlocked_ioctl	= tw_chrdev_ioctl,
> -#ifdef CONFIG_COMPAT
> -	.compat_ioctl   = tw_chrdev_ioctl,
> -#endif
> +	.compat_ioctl   = compat_ptr_ioctl,
>  	.open		= tw_chrdev_open,
>  	.release	= NULL,
>  	.llseek		= noop_llseek,
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 7096810fd222..e13d5de1d76e 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -3589,7 +3589,7 @@ static const struct file_operations cxlflash_chr_fops = {
>  	.owner          = THIS_MODULE,
>  	.open           = cxlflash_chr_open,
>  	.unlocked_ioctl	= cxlflash_chr_ioctl,
> -	.compat_ioctl	= cxlflash_chr_ioctl,
> +	.compat_ioctl	= compat_ptr_ioctl,
>  };
>  
>  /**
> diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
> index fdbda5c05aa0..80c5a235d193 100644
> --- a/drivers/scsi/esas2r/esas2r_main.c
> +++ b/drivers/scsi/esas2r/esas2r_main.c
> @@ -613,7 +613,7 @@ static int __init esas2r_init(void)
>  
>  /* Handle ioctl calls to "/proc/scsi/esas2r/ATTOnode" */
>  static const struct file_operations esas2r_proc_fops = {
> -	.compat_ioctl	= esas2r_proc_ioctl,
> +	.compat_ioctl	= compat_ptr_ioctl,
>  	.unlocked_ioctl = esas2r_proc_ioctl,
>  };
>  
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index e338d7a4f571..c0a1a1218c56 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -3988,9 +3988,7 @@ static const struct file_operations pmcraid_fops = {
>  	.open = pmcraid_chr_open,
>  	.fasync = pmcraid_chr_fasync,
>  	.unlocked_ioctl = pmcraid_chr_ioctl,
> -#ifdef CONFIG_COMPAT
> -	.compat_ioctl = pmcraid_chr_ioctl,
> -#endif
> +	.compat_ioctl = compat_ptr_ioctl,
>  	.llseek = noop_llseek,
>  };
>  
> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> index 92c2914239e3..1663c163edca 100644
> --- a/drivers/staging/android/ion/ion.c
> +++ b/drivers/staging/android/ion/ion.c
> @@ -567,9 +567,7 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  static const struct file_operations ion_fops = {
>  	.owner          = THIS_MODULE,
>  	.unlocked_ioctl = ion_ioctl,
> -#ifdef CONFIG_COMPAT
> -	.compat_ioctl	= ion_ioctl,
> -#endif
> +	.compat_ioctl	= compat_ptr_ioctl,
>  };
>  
>  static int debug_shrink_set(void *data, u64 val)
> diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
> index 6a33aaa1a49f..fd0ea4dbcb91 100644
> --- a/drivers/staging/vme/devices/vme_user.c
> +++ b/drivers/staging/vme/devices/vme_user.c
> @@ -494,7 +494,7 @@ static const struct file_operations vme_user_fops = {
>  	.write = vme_user_write,
>  	.llseek = vme_user_llseek,
>  	.unlocked_ioctl = vme_user_unlocked_ioctl,
> -	.compat_ioctl = vme_user_unlocked_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  	.mmap = vme_user_mmap,
>  };
>  
> diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> index 17c64fccbb10..eb97acf09868 100644
> --- a/drivers/tee/tee_core.c
> +++ b/drivers/tee/tee_core.c
> @@ -684,7 +684,7 @@ static const struct file_operations tee_fops = {
>  	.open = tee_open,
>  	.release = tee_release,
>  	.unlocked_ioctl = tee_ioctl,
> -	.compat_ioctl = tee_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  };
>  
>  static void tee_release_device(struct device *dev)
> diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
> index 9e9caff905d5..d48c032580d0 100644
> --- a/drivers/usb/class/cdc-wdm.c
> +++ b/drivers/usb/class/cdc-wdm.c
> @@ -724,7 +724,7 @@ static const struct file_operations wdm_fops = {
>  	.release =	wdm_release,
>  	.poll =		wdm_poll,
>  	.unlocked_ioctl = wdm_ioctl,
> -	.compat_ioctl = wdm_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  	.llseek =	noop_llseek,
>  };
>  
> diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
> index 4942122b2346..bbd0308b13f5 100644
> --- a/drivers/usb/class/usbtmc.c
> +++ b/drivers/usb/class/usbtmc.c
> @@ -2220,9 +2220,7 @@ static const struct file_operations fops = {
>  	.release	= usbtmc_release,
>  	.flush		= usbtmc_flush,
>  	.unlocked_ioctl	= usbtmc_ioctl,
> -#ifdef CONFIG_COMPAT
> -	.compat_ioctl	= usbtmc_ioctl,
> -#endif
> +	.compat_ioctl	= compat_ptr_ioctl,
>  	.fasync         = usbtmc_fasync,
>  	.poll           = usbtmc_poll,
>  	.llseek		= default_llseek,
> diff --git a/drivers/virt/fsl_hypervisor.c b/drivers/virt/fsl_hypervisor.c
> index 8ba726e600e9..fbf02bf60f62 100644
> --- a/drivers/virt/fsl_hypervisor.c
> +++ b/drivers/virt/fsl_hypervisor.c
> @@ -703,7 +703,7 @@ static const struct file_operations fsl_hv_fops = {
>  	.poll = fsl_hv_poll,
>  	.read = fsl_hv_read,
>  	.unlocked_ioctl = fsl_hv_ioctl,
> -	.compat_ioctl = fsl_hv_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  };
>  
>  static struct miscdevice fsl_hv_misc_dev = {
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 120e4340792a..162ea4b6b417 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2307,7 +2307,7 @@ static const struct super_operations btrfs_super_ops = {
>  static const struct file_operations btrfs_ctl_fops = {
>  	.open = btrfs_control_open,
>  	.unlocked_ioctl	 = btrfs_control_ioctl,
> -	.compat_ioctl = btrfs_control_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  	.owner	 = THIS_MODULE,
>  	.llseek = noop_llseek,
>  };
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 7c060cb22aa3..a493b957713f 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1785,7 +1785,7 @@ const struct file_operations ceph_dir_fops = {
>  	.open = ceph_open,
>  	.release = ceph_release,
>  	.unlocked_ioctl = ceph_ioctl,
> -	.compat_ioctl = ceph_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>  	.fsync = ceph_fsync,
>  	.lock = ceph_lock,
>  	.flock = ceph_flock,
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 9f53c3d99304..9b5fe7eee3c1 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -2112,7 +2112,7 @@ const struct file_operations ceph_file_fops = {
>  	.splice_read = generic_file_splice_read,
>  	.splice_write = iter_file_splice_write,
>  	.unlocked_ioctl = ceph_ioctl,
> -	.compat_ioctl	= ceph_ioctl,
> +	.compat_ioctl	= compat_ptr_ioctl,
>  	.fallocate	= ceph_fallocate,
>  	.copy_file_range = ceph_copy_file_range,
>  };
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 9971a35cf1ef..dcdb26068b71 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -2354,7 +2354,7 @@ const struct file_operations fuse_dev_operations = {
>  	.release	= fuse_dev_release,
>  	.fasync		= fuse_dev_fasync,
>  	.unlocked_ioctl = fuse_dev_ioctl,
> -	.compat_ioctl   = fuse_dev_ioctl,
> +	.compat_ioctl   = compat_ptr_ioctl,
>  };
>  EXPORT_SYMBOL_GPL(fuse_dev_operations);
>  
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index a90bb19dcfa2..a55aa029a308 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -523,7 +523,7 @@ static const struct file_operations fanotify_fops = {
>  	.fasync		= NULL,
>  	.release	= fanotify_release,
>  	.unlocked_ioctl	= fanotify_ioctl,
> -	.compat_ioctl	= fanotify_ioctl,
> +	.compat_ioctl	= compat_ptr_ioctl,
>  	.llseek		= noop_llseek,
>  };
>  
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 89800fc7dc9d..f93dcf8c996f 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -1901,7 +1901,7 @@ static const struct file_operations userfaultfd_fops = {
>  	.poll		= userfaultfd_poll,
>  	.read		= userfaultfd_read,
>  	.unlocked_ioctl = userfaultfd_ioctl,
> -	.compat_ioctl	= userfaultfd_ioctl,
> +	.compat_ioctl	= compat_ptr_ioctl,
>  	.llseek		= noop_llseek,
>  };
>  
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index abca57040f37..3b2f6ea44397 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -1323,7 +1323,7 @@ static const struct file_operations rfkill_fops = {
>  	.release	= rfkill_fop_release,
>  #ifdef CONFIG_RFKILL_INPUT
>  	.unlocked_ioctl	= rfkill_fop_ioctl,
> -	.compat_ioctl	= rfkill_fop_ioctl,
> +	.compat_ioctl	= compat_ptr_ioctl,
>  #endif
>  	.llseek		= no_llseek,
>  };



Thanks,
Mauro
