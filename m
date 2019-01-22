Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [driver-core PATCH v10 1/9] driver core: Establish order of
 operations for device_add and device_del via bitflag
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Tue, 22 Jan 2019 10:39:10 -0800
Message-ID: <154818235081.18753.1278409711806099880.stgit@ahduyck-desk1.amr.corp.intel.com>
In-Reply-To: <154818223154.18753.12374915684623789884.stgit@ahduyck-desk1.amr.corp.intel.com>
References: <154818223154.18753.12374915684623789884.stgit@ahduyck-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: mcgrof@kernel.org, linux-nvdimm@lists.01.org, tj@kernel.org, akpm@linux-foundation.org, linux-pm@vger.kernel.org, jiangshanlai@gmail.com, rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz, zwisler@kernel.org, dan.j.williams@intel.com, dave.jiang@intel.com, bvanassche@acm.org, alexander.h.duyck@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

Add an additional bit flag to the device_private struct named "dead".

This additional flag provides a guarantee that when a device_del is
executed on a given interface an async worker will not attempt to attach
the driver following the earlier device_del call. Previously this
guarantee was not present and could result in the device_del call
attempting to remove a driver from an interface only to have the async
worker attempt to probe the driver later when it finally completes the
asynchronous probe call.

One additional change added was that I pulled the check for dev->driver
out of the __device_attach_driver call and instead placed it in the
__device_attach_async_helper call. This was motivated by the fact that the
only other caller of this, __device_attach, had already taken the
device_lock() and checked for dev->driver. Instead of testing for this
twice in this path it makes more sense to just consolidate the dev->dead
and dev->driver checks together into one set of checks.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/base/base.h |    4 ++++
 drivers/base/core.c |   11 +++++++++++
 drivers/base/dd.c   |   22 +++++++++++-----------
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 37329a668935..7ca475af8953 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -67,6 +67,9 @@ struct driver_private {
  *	probed first.
  * @device - pointer back to the struct device that this structure is
  * associated with.
+ * @dead - This device is currently either in the process of or has been
+ *	removed from the system. Any asynchronous events scheduled for this
+ *	device should exit without taking any action.
  *
  * Nothing outside of the driver core should ever touch these fields.
  */
@@ -78,6 +81,7 @@ struct device_private {
 	struct klist_node knode_class;
 	struct list_head deferred_probe;
 	struct device *device;
+	u8 dead:1;
 };
 #define to_device_private_parent(obj)	\
 	container_of(obj, struct device_private, knode_parent)
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4a4b6f8cbc4f..c9a82e367480 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2080,6 +2080,17 @@ void device_del(struct device *dev)
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
+	dev->p->dead = true;
+	device_unlock(dev);
+
 	/* Notify clients of device removal.  This call must come
 	 * before dpm_sysfs_remove().
 	 */
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 8ac10af17c00..636cd16b1b62 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -731,15 +731,6 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
 	bool async_allowed;
 	int ret;
 
-	/*
-	 * Check if device has already been claimed. This may
-	 * happen with driver loading, device discovery/registration,
-	 * and deferred probe processing happens all at once with
-	 * multiple threads.
-	 */
-	if (dev->driver)
-		return -EBUSY;
-
 	ret = driver_match_device(drv, dev);
 	if (ret == 0) {
 		/* no match */
@@ -774,6 +765,15 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 
 	device_lock(dev);
 
+	/*
+	 * Check if device has already been removed or claimed. This may
+	 * happen with driver loading, device discovery/registration,
+	 * and deferred probe processing happens all at once with
+	 * multiple threads.
+	 */
+	if (dev->p->dead || dev->driver)
+		goto out_unlock;
+
 	if (dev->parent)
 		pm_runtime_get_sync(dev->parent);
 
@@ -784,7 +784,7 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 
 	if (dev->parent)
 		pm_runtime_put(dev->parent);
-
+out_unlock:
 	device_unlock(dev);
 
 	put_device(dev);
@@ -897,7 +897,7 @@ static int __driver_attach(struct device *dev, void *data)
 	if (dev->parent && dev->bus->need_parent_lock)
 		device_lock(dev->parent);
 	device_lock(dev);
-	if (!dev->driver)
+	if (!dev->p->dead && !dev->driver)
 		driver_probe_device(drv, dev);
 	device_unlock(dev);
 	if (dev->parent && dev->bus->need_parent_lock)
