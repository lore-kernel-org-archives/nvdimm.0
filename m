Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [driver-core PATCH v8 2/9] driver core: Establish order of
 operations for device_add and device_del via bitflag
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 05 Dec 2018 09:25:24 -0800
Message-ID: <154403072403.11544.10419282512791659652.stgit@ahduyck-desk1.jf.intel.com>
In-Reply-To: <154403054034.11544.3978949383914046587.stgit@ahduyck-desk1.jf.intel.com>
References: <154403054034.11544.3978949383914046587.stgit@ahduyck-desk1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: mcgrof@kernel.org, linux-nvdimm@lists.01.org, tj@kernel.org, akpm@linux-foundation.org, linux-pm@vger.kernel.org, jiangshanlai@gmail.com, rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz, zwisler@kernel.org, dan.j.williams@intel.com, dave.jiang@intel.com, bvanassche@acm.org, alexander.h.duyck@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

Add an additional bit flag to the device struct named "dead".

This additional flag provides a guarantee that when a device_del is
executed on a given interface an async worker will not attempt to attach
the driver following the earlier device_del call. Previously this
guarantee was not present and could result in the device_del call
attempting to remove a driver from an interface only to have the async
worker attempt to probe the driver later when it finally completes the
asynchronous probe call.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/base/core.c    |   11 +++++++++++
 drivers/base/dd.c      |    8 ++++++--
 include/linux/device.h |    5 +++++
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index f3e6ca4170b4..70358327303b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2075,6 +2075,17 @@ void device_del(struct device *dev)
 	struct kobject *glue_dir = NULL;
 	struct class_interface *class_intf;
 
+	/*
+	 * Hold the device lock and set the "dead" flag to guarantee that
+	 * the update behavior is consistent with the other bitfields near
+	 * it and that we cannot have an asynchronous probe routine trying
+	 * to run while we are tearing out the bus/class/sysfs from
+	 * underneath the device.
+	 */
+	device_lock(dev);
+	dev->dead = true;
+	device_unlock(dev);
+
 	/* Notify clients of device removal.  This call must come
 	 * before dpm_sysfs_remove().
 	 */
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 88713f182086..3bb8c3e0f3da 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -774,6 +774,10 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 
 	device_lock(dev);
 
+	/* device is or has been removed from the bus, just bail out */
+	if (dev->dead)
+		goto out_unlock;
+
 	if (dev->parent)
 		pm_runtime_get_sync(dev->parent);
 
@@ -784,7 +788,7 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 
 	if (dev->parent)
 		pm_runtime_put(dev->parent);
-
+out_unlock:
 	device_unlock(dev);
 
 	put_device(dev);
@@ -897,7 +901,7 @@ static int __driver_attach(struct device *dev, void *data)
 	if (dev->parent && dev->bus->need_parent_lock)
 		device_lock(dev->parent);
 	device_lock(dev);
-	if (!dev->driver)
+	if (!dev->dead && !dev->driver)
 		driver_probe_device(drv, dev);
 	device_unlock(dev);
 	if (dev->parent && dev->bus->need_parent_lock)
diff --git a/include/linux/device.h b/include/linux/device.h
index 4921a6192f6b..393704e5b602 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -957,6 +957,10 @@ struct dev_links_info {
  *              device.
  * @dma_coherent: this particular device is dma coherent, even if the
  *		architecture supports non-coherent devices.
+ * @dead:	This device is currently either in the process of or has
+ *		been removed from the system. Any asynchronous events
+ *		scheduled for this device should exit without taking any
+ *		action.
  *
  * At the lowest level, every device in a Linux system is represented by an
  * instance of struct device. The device structure contains the information
@@ -1051,6 +1055,7 @@ struct device {
     defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
 	bool			dma_coherent:1;
 #endif
+	bool			dead:1;
 };
 
 static inline struct device *kobj_to_dev(struct kobject *kobj)
