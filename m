Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1636E2112B1D3
 for <linux-nvdimm@lists.01.org>; Wed, 12 Sep 2018 08:11:54 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 05/17] compat_ioctl: move more drivers to
 generic_compat_ioctl_ptrarg
Date: Wed, 12 Sep 2018 17:08:52 +0200
Message-Id: <20180912151134.436719-1-arnd@arndb.de>
In-Reply-To: <20180912150142.157913-1-arnd@arndb.de>
References: <20180912150142.157913-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: viro@zeniv.linux.org.uk
Cc: linux-fbdev@vger.kernel.org, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-nvme@lists.infradead.org, platform-driver-x86@vger.kernel.org, sparclinux@vger.kernel.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, qat-linux@intel.com, amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org, linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org, ceph-devel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>, linux-btrfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The .ioctl and .compat_ioctl file operations have the same prototype so
they can both point to the same function, which works great almost all
the time when all the commands are compatible.

One exception is the s390 architecture, where a compat pointer is only
31 bit wide, and converting it into a 64-bit pointer requires calling
compat_ptr(). Most drivers here will ever run in s390, but since we now
have a generic helper for it, it's easy enough to use it consistently.

I double-checked all these drivers to ensure that all ioctl arguments
are used as pointers or are ignored, but are not interpreted as integer
values.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/android/binder.c                    | 2 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c | 2 +-
 drivers/dma-buf/dma-buf.c                   | 4 +---
 drivers/dma-buf/sw_sync.c                   | 2 +-
 drivers/dma-buf/sync_file.c                 | 2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c    | 2 +-
 drivers/hid/hidraw.c                        | 4 +---
 drivers/iio/industrialio-core.c             | 2 +-
 drivers/infiniband/core/uverbs_main.c       | 4 ++--
 drivers/media/rc/lirc_dev.c                 | 4 +---
 drivers/mfd/cros_ec_dev.c                   | 4 +---
 drivers/misc/vmw_vmci/vmci_host.c           | 2 +-
 drivers/nvdimm/bus.c                        | 4 ++--
 drivers/nvme/host/core.c                    | 2 +-
 drivers/pci/switch/switchtec.c              | 2 +-
 drivers/platform/x86/wmi.c                  | 2 +-
 drivers/rpmsg/rpmsg_char.c                  | 4 ++--
 drivers/sbus/char/display7seg.c             | 2 +-
 drivers/sbus/char/envctrl.c                 | 4 +---
 drivers/scsi/3w-xxxx.c                      | 4 +---
 drivers/scsi/cxlflash/main.c                | 2 +-
 drivers/scsi/esas2r/esas2r_main.c           | 2 +-
 drivers/scsi/pmcraid.c                      | 4 +---
 drivers/staging/android/ion/ion.c           | 4 +---
 drivers/staging/vme/devices/vme_user.c      | 2 +-
 drivers/tee/tee_core.c                      | 2 +-
 drivers/usb/class/cdc-wdm.c                 | 2 +-
 drivers/usb/class/usbtmc.c                  | 4 +---
 drivers/video/fbdev/ps3fb.c                 | 2 +-
 drivers/virt/fsl_hypervisor.c               | 2 +-
 fs/btrfs/super.c                            | 2 +-
 fs/ceph/dir.c                               | 2 +-
 fs/ceph/file.c                              | 2 +-
 fs/fuse/dev.c                               | 2 +-
 fs/notify/fanotify/fanotify_user.c          | 2 +-
 fs/userfaultfd.c                            | 2 +-
 net/rfkill/core.c                           | 2 +-
 37 files changed, 40 insertions(+), 58 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index d58763b6b009..d2464f5759f8 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -5576,7 +5576,7 @@ static const struct file_operations binder_fops = {
 	.owner = THIS_MODULE,
 	.poll = binder_poll,
 	.unlocked_ioctl = binder_ioctl,
-	.compat_ioctl = binder_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 	.mmap = binder_mmap,
 	.open = binder_open,
 	.flush = binder_flush,
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index abc7a7f64d64..8ff77a70addc 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -68,7 +68,7 @@ static long adf_ctl_ioctl(struct file *fp, unsigned int cmd, unsigned long arg);
 static const struct file_operations adf_ctl_ops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = adf_ctl_ioctl,
-	.compat_ioctl = adf_ctl_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 };
 
 struct adf_ctl_drv_info {
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 13884474d158..a6d7dc4cf7e9 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -325,9 +325,7 @@ static const struct file_operations dma_buf_fops = {
 	.llseek		= dma_buf_llseek,
 	.poll		= dma_buf_poll,
 	.unlocked_ioctl	= dma_buf_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= dma_buf_ioctl,
-#endif
+	.compat_ioctl	= generic_compat_ioctl_ptrarg,
 };
 
 /*
diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 53c1d6d36a64..bc810506d487 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -419,5 +419,5 @@ const struct file_operations sw_sync_debugfs_fops = {
 	.open           = sw_sync_debugfs_open,
 	.release        = sw_sync_debugfs_release,
 	.unlocked_ioctl = sw_sync_ioctl,
-	.compat_ioctl	= sw_sync_ioctl,
+	.compat_ioctl	= generic_compat_ioctl_ptrarg,
 };
diff --git a/drivers/dma-buf/sync_file.c b/drivers/dma-buf/sync_file.c
index 35dd06479867..1c64ed60c658 100644
--- a/drivers/dma-buf/sync_file.c
+++ b/drivers/dma-buf/sync_file.c
@@ -488,5 +488,5 @@ static const struct file_operations sync_file_fops = {
 	.release = sync_file_release,
 	.poll = sync_file_poll,
 	.unlocked_ioctl = sync_file_ioctl,
-	.compat_ioctl = sync_file_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 };
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 297b36c26a05..1d7b1e3c3ebe 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -47,7 +47,7 @@ static const char kfd_dev_name[] = "kfd";
 static const struct file_operations kfd_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = kfd_ioctl,
-	.compat_ioctl = kfd_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 	.open = kfd_open,
 	.mmap = kfd_mmap,
 };
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 4a44e48e08b2..e44b64812850 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -476,9 +476,7 @@ static const struct file_operations hidraw_ops = {
 	.release =      hidraw_release,
 	.unlocked_ioctl = hidraw_ioctl,
 	.fasync =	hidraw_fasync,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl   = hidraw_ioctl,
-#endif
+	.compat_ioctl   = generic_compat_ioctl_ptrarg,
 	.llseek =	noop_llseek,
 };
 
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index a062cfddc5af..22844b94b0e9 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1630,7 +1630,7 @@ static const struct file_operations iio_buffer_fileops = {
 	.owner = THIS_MODULE,
 	.llseek = noop_llseek,
 	.unlocked_ioctl = iio_ioctl,
-	.compat_ioctl = iio_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 };
 
 static int iio_check_unique_scan_index(struct iio_dev *indio_dev)
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 823beca448e1..f4755c1c9cfa 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -930,7 +930,7 @@ static const struct file_operations uverbs_fops = {
 	.release = ib_uverbs_close,
 	.llseek	 = no_llseek,
 	.unlocked_ioctl = ib_uverbs_ioctl,
-	.compat_ioctl = ib_uverbs_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 };
 
 static const struct file_operations uverbs_mmap_fops = {
@@ -941,7 +941,7 @@ static const struct file_operations uverbs_mmap_fops = {
 	.release = ib_uverbs_close,
 	.llseek	 = no_llseek,
 	.unlocked_ioctl = ib_uverbs_ioctl,
-	.compat_ioctl = ib_uverbs_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 };
 
 static struct ib_client uverbs_client = {
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index f862f1b7f996..077209f414ed 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -730,9 +730,7 @@ static const struct file_operations lirc_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ir_lirc_transmit_ir,
 	.unlocked_ioctl	= ir_lirc_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= ir_lirc_ioctl,
-#endif
+	.compat_ioctl	= generic_compat_ioctl_ptrarg,
 	.read		= ir_lirc_read,
 	.poll		= ir_lirc_poll,
 	.open		= ir_lirc_open,
diff --git a/drivers/mfd/cros_ec_dev.c b/drivers/mfd/cros_ec_dev.c
index 999dac752bcc..35a04bcf55da 100644
--- a/drivers/mfd/cros_ec_dev.c
+++ b/drivers/mfd/cros_ec_dev.c
@@ -258,9 +258,7 @@ static const struct file_operations fops = {
 	.release = ec_device_release,
 	.read = ec_device_read,
 	.unlocked_ioctl = ec_device_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = ec_device_ioctl,
-#endif
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 };
 
 static void cros_ec_sensors_register(struct cros_ec_dev *ec)
diff --git a/drivers/misc/vmw_vmci/vmci_host.c b/drivers/misc/vmw_vmci/vmci_host.c
index 83e0c95d20a4..1308f889e53b 100644
--- a/drivers/misc/vmw_vmci/vmci_host.c
+++ b/drivers/misc/vmw_vmci/vmci_host.c
@@ -983,7 +983,7 @@ static const struct file_operations vmuser_fops = {
 	.release	= vmci_host_close,
 	.poll		= vmci_host_poll,
 	.unlocked_ioctl	= vmci_host_unlocked_ioctl,
-	.compat_ioctl	= vmci_host_unlocked_ioctl,
+	.compat_ioctl	= generic_compat_ioctl_ptrarg,
 };
 
 static struct miscdevice vmci_host_miscdev = {
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 8aae6dcc839f..7449cbc55df7 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -1133,7 +1133,7 @@ static const struct file_operations nvdimm_bus_fops = {
 	.owner = THIS_MODULE,
 	.open = nd_open,
 	.unlocked_ioctl = nd_ioctl,
-	.compat_ioctl = nd_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 	.llseek = noop_llseek,
 };
 
@@ -1141,7 +1141,7 @@ static const struct file_operations nvdimm_fops = {
 	.owner = THIS_MODULE,
 	.open = nd_open,
 	.unlocked_ioctl = nvdimm_ioctl,
-	.compat_ioctl = nvdimm_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 	.llseek = noop_llseek,
 };
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index dd8ec1dd9219..2d986f573a29 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2579,7 +2579,7 @@ static const struct file_operations nvme_dev_fops = {
 	.owner		= THIS_MODULE,
 	.open		= nvme_dev_open,
 	.unlocked_ioctl	= nvme_dev_ioctl,
-	.compat_ioctl	= nvme_dev_ioctl,
+	.compat_ioctl	= generic_compat_ioctl_ptrarg,
 };
 
 static ssize_t nvme_sysfs_reset(struct device *dev,
diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index 9940cc70f38b..4296919c784e 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -967,7 +967,7 @@ static const struct file_operations switchtec_fops = {
 	.read = switchtec_dev_read,
 	.poll = switchtec_dev_poll,
 	.unlocked_ioctl = switchtec_dev_ioctl,
-	.compat_ioctl = switchtec_dev_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 };
 
 static void link_event_work(struct work_struct *work)
diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 04791ea5d97b..e4d0697e07d6 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -886,7 +886,7 @@ static const struct file_operations wmi_fops = {
 	.read		= wmi_char_read,
 	.open		= wmi_char_open,
 	.unlocked_ioctl	= wmi_ioctl,
-	.compat_ioctl	= wmi_ioctl,
+	.compat_ioctl	= generic_compat_ioctl_ptrarg,
 };
 
 static int wmi_dev_probe(struct device *dev)
diff --git a/drivers/rpmsg/rpmsg_char.c b/drivers/rpmsg/rpmsg_char.c
index a76b963a7e50..02aefb2b2d47 100644
--- a/drivers/rpmsg/rpmsg_char.c
+++ b/drivers/rpmsg/rpmsg_char.c
@@ -285,7 +285,7 @@ static const struct file_operations rpmsg_eptdev_fops = {
 	.write = rpmsg_eptdev_write,
 	.poll = rpmsg_eptdev_poll,
 	.unlocked_ioctl = rpmsg_eptdev_ioctl,
-	.compat_ioctl = rpmsg_eptdev_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 };
 
 static ssize_t name_show(struct device *dev, struct device_attribute *attr,
@@ -446,7 +446,7 @@ static const struct file_operations rpmsg_ctrldev_fops = {
 	.open = rpmsg_ctrldev_open,
 	.release = rpmsg_ctrldev_release,
 	.unlocked_ioctl = rpmsg_ctrldev_ioctl,
-	.compat_ioctl = rpmsg_ctrldev_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 };
 
 static void rpmsg_ctrldev_release_device(struct device *dev)
diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 5c8ed7350a04..064fe7247eb2 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -155,7 +155,7 @@ static long d7s_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 static const struct file_operations d7s_fops = {
 	.owner =		THIS_MODULE,
 	.unlocked_ioctl =	d7s_ioctl,
-	.compat_ioctl =		d7s_ioctl,
+	.compat_ioctl =		generic_compat_ioctl_ptrarg,
 	.open =			d7s_open,
 	.release =		d7s_release,
 	.llseek = noop_llseek,
diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
index 56e962a01493..a26665ccea56 100644
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
@@ -714,9 +714,7 @@ static const struct file_operations envctrl_fops = {
 	.owner =		THIS_MODULE,
 	.read =			envctrl_read,
 	.unlocked_ioctl =	envctrl_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl =		envctrl_ioctl,
-#endif
+	.compat_ioctl =		generic_compat_ioctl_ptrarg,
 	.open =			envctrl_open,
 	.release =		envctrl_release,
 	.llseek =		noop_llseek,
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 471366945bd4..86c9f22a152f 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1047,9 +1047,7 @@ static int tw_chrdev_open(struct inode *inode, struct file *file)
 static const struct file_operations tw_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= tw_chrdev_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl   = tw_chrdev_ioctl,
-#endif
+	.compat_ioctl   = generic_compat_ioctl_ptrarg,
 	.open		= tw_chrdev_open,
 	.release	= NULL,
 	.llseek		= noop_llseek,
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 6637116529aa..d968efeb50e8 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -3596,7 +3596,7 @@ static const struct file_operations cxlflash_chr_fops = {
 	.owner          = THIS_MODULE,
 	.open           = cxlflash_chr_open,
 	.unlocked_ioctl	= cxlflash_chr_ioctl,
-	.compat_ioctl	= cxlflash_chr_ioctl,
+	.compat_ioctl	= generic_compat_ioctl_ptrarg,
 };
 
 /**
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index c07118617d89..95142292e702 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -614,7 +614,7 @@ static int __init esas2r_init(void)
 
 /* Handle ioctl calls to "/proc/scsi/esas2r/ATTOnode" */
 static const struct file_operations esas2r_proc_fops = {
-	.compat_ioctl	= esas2r_proc_ioctl,
+	.compat_ioctl	= generic_compat_ioctl_ptrarg,
 	.unlocked_ioctl = esas2r_proc_ioctl,
 };
 
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 4e86994e10e8..8a8c73d3bdad 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3999,9 +3999,7 @@ static const struct file_operations pmcraid_fops = {
 	.open = pmcraid_chr_open,
 	.fasync = pmcraid_chr_fasync,
 	.unlocked_ioctl = pmcraid_chr_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = pmcraid_chr_ioctl,
-#endif
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 	.llseek = noop_llseek,
 };
 
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 99073325b0c0..ef727c235392 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -484,9 +484,7 @@ int ion_query_heaps(struct ion_heap_query *query)
 static const struct file_operations ion_fops = {
 	.owner          = THIS_MODULE,
 	.unlocked_ioctl = ion_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= ion_ioctl,
-#endif
+	.compat_ioctl	= generic_compat_ioctl_ptrarg,
 };
 
 static int debug_shrink_set(void *data, u64 val)
diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 6a33aaa1a49f..568700ffd2f2 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -494,7 +494,7 @@ static const struct file_operations vme_user_fops = {
 	.write = vme_user_write,
 	.llseek = vme_user_llseek,
 	.unlocked_ioctl = vme_user_unlocked_ioctl,
-	.compat_ioctl = vme_user_unlocked_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 	.mmap = vme_user_mmap,
 };
 
diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index dd46b758852a..cb79f28be894 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -670,7 +670,7 @@ static const struct file_operations tee_fops = {
 	.open = tee_open,
 	.release = tee_release,
 	.unlocked_ioctl = tee_ioctl,
-	.compat_ioctl = tee_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 };
 
 static void tee_release_device(struct device *dev)
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index bec581fb7c63..6e4998c8e64f 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -724,7 +724,7 @@ static const struct file_operations wdm_fops = {
 	.release =	wdm_release,
 	.poll =		wdm_poll,
 	.unlocked_ioctl = wdm_ioctl,
-	.compat_ioctl = wdm_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 	.llseek =	noop_llseek,
 };
 
diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 83ffa5a14c3d..d5da47c4c462 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -1460,9 +1460,7 @@ static const struct file_operations fops = {
 	.open		= usbtmc_open,
 	.release	= usbtmc_release,
 	.unlocked_ioctl	= usbtmc_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= usbtmc_ioctl,
-#endif
+	.compat_ioctl	= generic_compat_ioctl_ptrarg,
 	.fasync         = usbtmc_fasync,
 	.poll           = usbtmc_poll,
 	.llseek		= default_llseek,
diff --git a/drivers/video/fbdev/ps3fb.c b/drivers/video/fbdev/ps3fb.c
index 5ed2db39d823..f9f8ffaf1c4a 100644
--- a/drivers/video/fbdev/ps3fb.c
+++ b/drivers/video/fbdev/ps3fb.c
@@ -949,7 +949,7 @@ static struct fb_ops ps3fb_ops = {
 	.fb_mmap	= ps3fb_mmap,
 	.fb_blank	= ps3fb_blank,
 	.fb_ioctl	= ps3fb_ioctl,
-	.fb_compat_ioctl = ps3fb_ioctl
+	.fb_compat_ioctl = generic_compat_ioctl_ptrarg,
 };
 
 static const struct fb_fix_screeninfo ps3fb_fix = {
diff --git a/drivers/virt/fsl_hypervisor.c b/drivers/virt/fsl_hypervisor.c
index 8ba726e600e9..406b7e492214 100644
--- a/drivers/virt/fsl_hypervisor.c
+++ b/drivers/virt/fsl_hypervisor.c
@@ -703,7 +703,7 @@ static const struct file_operations fsl_hv_fops = {
 	.poll = fsl_hv_poll,
 	.read = fsl_hv_read,
 	.unlocked_ioctl = fsl_hv_ioctl,
-	.compat_ioctl = fsl_hv_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 };
 
 static struct miscdevice fsl_hv_misc_dev = {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6601c9aa5e35..2b5a8ad86305 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2352,7 +2352,7 @@ static const struct super_operations btrfs_super_ops = {
 static const struct file_operations btrfs_ctl_fops = {
 	.open = btrfs_control_open,
 	.unlocked_ioctl	 = btrfs_control_ioctl,
-	.compat_ioctl = btrfs_control_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 	.owner	 = THIS_MODULE,
 	.llseek = noop_llseek,
 };
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index da73f29d7faa..eb869fe6774d 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1489,7 +1489,7 @@ const struct file_operations ceph_dir_fops = {
 	.open = ceph_open,
 	.release = ceph_release,
 	.unlocked_ioctl = ceph_ioctl,
-	.compat_ioctl = ceph_ioctl,
+	.compat_ioctl = generic_compat_ioctl_ptrarg,
 	.fsync = ceph_fsync,
 	.lock = ceph_lock,
 	.flock = ceph_flock,
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 92ab20433682..85094042cfac 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1842,7 +1842,7 @@ const struct file_operations ceph_file_fops = {
 	.splice_read = generic_file_splice_read,
 	.splice_write = iter_file_splice_write,
 	.unlocked_ioctl = ceph_ioctl,
-	.compat_ioctl	= ceph_ioctl,
+	.compat_ioctl	= generic_compat_ioctl_ptrarg,
 	.fallocate	= ceph_fallocate,
 };
 
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 11ea2c4a38ab..a6d4a24963ed 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2258,7 +2258,7 @@ const struct file_operations fuse_dev_operations = {
 	.release	= fuse_dev_release,
 	.fasync		= fuse_dev_fasync,
 	.unlocked_ioctl = fuse_dev_ioctl,
-	.compat_ioctl   = fuse_dev_ioctl,
+	.compat_ioctl   = generic_compat_ioctl_ptrarg,
 };
 EXPORT_SYMBOL_GPL(fuse_dev_operations);
 
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 69054886915b..fc4193b384cf 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -447,7 +447,7 @@ static const struct file_operations fanotify_fops = {
 	.fasync		= NULL,
 	.release	= fanotify_release,
 	.unlocked_ioctl	= fanotify_ioctl,
-	.compat_ioctl	= fanotify_ioctl,
+	.compat_ioctl	= generic_compat_ioctl_ptrarg,
 	.llseek		= noop_llseek,
 };
 
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index bfa0ec69f924..bc9118b58a8a 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1878,7 +1878,7 @@ static const struct file_operations userfaultfd_fops = {
 	.poll		= userfaultfd_poll,
 	.read		= userfaultfd_read,
 	.unlocked_ioctl = userfaultfd_ioctl,
-	.compat_ioctl	= userfaultfd_ioctl,
+	.compat_ioctl	= generic_compat_ioctl_ptrarg,
 	.llseek		= noop_llseek,
 };
 
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 1355f5ca8d22..ba68b53f58ab 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1323,7 +1323,7 @@ static const struct file_operations rfkill_fops = {
 	.release	= rfkill_fop_release,
 #ifdef CONFIG_RFKILL_INPUT
 	.unlocked_ioctl	= rfkill_fop_ioctl,
-	.compat_ioctl	= rfkill_fop_ioctl,
+	.compat_ioctl	= generic_compat_ioctl_ptrarg,
 #endif
 	.llseek		= no_llseek,
 };
-- 
2.18.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
