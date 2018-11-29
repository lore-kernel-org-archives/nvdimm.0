Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D1C8C21196229
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 16:32:22 -0800 (PST)
Subject: [driver-core PATCH v7 3/9] device core: Consolidate locking and
 unlocking of parent and device
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 28 Nov 2018 16:32:21 -0800
Message-ID: <154345154182.18040.12736221516488918534.stgit@ahduyck-desk1.amr.corp.intel.com>
In-Reply-To: <154345118835.18040.17186161872550839244.stgit@ahduyck-desk1.amr.corp.intel.com>
References: <154345118835.18040.17186161872550839244.stgit@ahduyck-desk1.amr.corp.intel.com>
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
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: len.brown@intel.com, bvanassche@acm.org, linux-pm@vger.kernel.org, alexander.h.duyck@linux.intel.com, linux-nvdimm@lists.01.org, jiangshanlai@gmail.com, mcgrof@kernel.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org, rafael@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Try to consolidate all of the locking and unlocking of both the parent and
device when attaching or removing a driver from a given device.

To do that I first consolidated the lock pattern into two functions
__device_driver_lock and __device_driver_unlock. After doing that I then
created functions specific to attaching and detaching the driver while
acquiring these locks. By doing this I was able to reduce the number of
spots where we touch need_parent_lock from 12 down to 4.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/base/base.h |    2 +
 drivers/base/bus.c  |   23 ++-----------
 drivers/base/dd.c   |   91 ++++++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 77 insertions(+), 39 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 7a419a7a6235..3f22ebd6117a 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -124,6 +124,8 @@ extern int driver_add_groups(struct device_driver *drv,
 			     const struct attribute_group **groups);
 extern void driver_remove_groups(struct device_driver *drv,
 				 const struct attribute_group **groups);
+int device_driver_attach(struct device_driver *drv, struct device *dev);
+void device_driver_detach(struct device *dev);
 
 extern char *make_class_name(const char *name, struct kobject *kobj);
 
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 8bfd27ec73d6..8a630f9bd880 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -184,11 +184,7 @@ static ssize_t unbind_store(struct device_driver *drv, const char *buf,
 
 	dev = bus_find_device_by_name(bus, NULL, buf);
 	if (dev && dev->driver == drv) {
-		if (dev->parent && dev->bus->need_parent_lock)
-			device_lock(dev->parent);
-		device_release_driver(dev);
-		if (dev->parent && dev->bus->need_parent_lock)
-			device_unlock(dev->parent);
+		device_driver_detach(dev);
 		err = count;
 	}
 	put_device(dev);
@@ -211,13 +207,7 @@ static ssize_t bind_store(struct device_driver *drv, const char *buf,
 
 	dev = bus_find_device_by_name(bus, NULL, buf);
 	if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
-		if (dev->parent && bus->need_parent_lock)
-			device_lock(dev->parent);
-		device_lock(dev);
-		err = driver_probe_device(drv, dev);
-		device_unlock(dev);
-		if (dev->parent && bus->need_parent_lock)
-			device_unlock(dev->parent);
+		err = device_driver_attach(drv, dev);
 
 		if (err > 0) {
 			/* success */
@@ -769,13 +759,8 @@ EXPORT_SYMBOL_GPL(bus_rescan_devices);
  */
 int device_reprobe(struct device *dev)
 {
-	if (dev->driver) {
-		if (dev->parent && dev->bus->need_parent_lock)
-			device_lock(dev->parent);
-		device_release_driver(dev);
-		if (dev->parent && dev->bus->need_parent_lock)
-			device_unlock(dev->parent);
-	}
+	if (dev->driver)
+		device_driver_detach(dev);
 	return bus_rescan_devices_helper(dev, NULL);
 }
 EXPORT_SYMBOL_GPL(device_reprobe);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index ef3f70a7cb5a..d2515520569e 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -875,6 +875,60 @@ void device_initial_probe(struct device *dev)
 	__device_attach(dev, true);
 }
 
+/*
+ * __device_driver_lock - acquire locks needed to manipulate dev->drv
+ * @dev: Device we will update driver info for
+ * @parent: Parent device. Needed if the bus requires parent lock
+ *
+ * This function will take the required locks for manipulating dev->drv.
+ * Normally this will just be the @dev lock, but when called for a USB
+ * interface, @parent lock will be held as well.
+ */
+static void __device_driver_lock(struct device *dev, struct device *parent)
+{
+	if (parent && dev->bus->need_parent_lock)
+		device_lock(parent);
+	device_lock(dev);
+}
+
+/*
+ * __device_driver_unlock - release locks needed to manipulate dev->drv
+ * @dev: Device we will update driver info for
+ * @parent: Parent device. Needed if the bus requires parent lock
+ *
+ * This function will release the required locks for manipulating dev->drv.
+ * Normally this will just be the the @dev lock, but when called for a
+ * USB interface, @parent lock will be released as well.
+ */
+static void __device_driver_unlock(struct device *dev, struct device *parent)
+{
+	device_unlock(dev);
+	if (parent && dev->bus->need_parent_lock)
+		device_unlock(parent);
+}
+
+/**
+ * device_driver_attach - attach a specific driver to a specific device
+ * @drv: Driver to attach
+ * @dev: Device to attach it to
+ *
+ * Manually attach driver to a device. Will acquire both @dev lock and
+ * @dev->parent lock if needed.
+ */
+int device_driver_attach(struct device_driver *drv, struct device *dev)
+{
+	int ret = 0;
+
+	__device_driver_lock(dev, dev->parent);
+
+	if (!dev->driver)
+		ret = driver_probe_device(drv, dev);
+
+	__device_driver_unlock(dev, dev->parent);
+
+	return ret;
+}
+
 static int __driver_attach(struct device *dev, void *data)
 {
 	struct device_driver *drv = data;
@@ -902,14 +956,7 @@ static int __driver_attach(struct device *dev, void *data)
 		return ret;
 	} /* ret > 0 means positive match */
 
-	if (dev->parent && dev->bus->need_parent_lock)
-		device_lock(dev->parent);
-	device_lock(dev);
-	if (!dev->driver)
-		driver_probe_device(drv, dev);
-	device_unlock(dev);
-	if (dev->parent && dev->bus->need_parent_lock)
-		device_unlock(dev->parent);
+	device_driver_attach(drv, dev);
 
 	return 0;
 }
@@ -948,15 +995,11 @@ static void __device_release_driver(struct device *dev, struct device *parent)
 	drv = dev->driver;
 	if (drv) {
 		while (device_links_busy(dev)) {
-			device_unlock(dev);
-			if (parent)
-				device_unlock(parent);
+			__device_driver_unlock(dev, parent);
 
 			device_links_unbind_consumers(dev);
-			if (parent)
-				device_lock(parent);
 
-			device_lock(dev);
+			__device_driver_lock(dev, parent);
 			/*
 			 * A concurrent invocation of the same function might
 			 * have released the driver successfully while this one
@@ -1009,16 +1052,12 @@ void device_release_driver_internal(struct device *dev,
 				    struct device_driver *drv,
 				    struct device *parent)
 {
-	if (parent && dev->bus->need_parent_lock)
-		device_lock(parent);
+	__device_driver_lock(dev, parent);
 
-	device_lock(dev);
 	if (!drv || drv == dev->driver)
 		__device_release_driver(dev, parent);
 
-	device_unlock(dev);
-	if (parent && dev->bus->need_parent_lock)
-		device_unlock(parent);
+	__device_driver_unlock(dev, parent);
 }
 
 /**
@@ -1043,6 +1082,18 @@ void device_release_driver(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(device_release_driver);
 
+/**
+ * device_driver_detach - detach driver from a specific device
+ * @dev: device to detach driver from
+ *
+ * Detach driver from device. Will acquire both @dev lock and @dev->parent
+ * lock if needed.
+ */
+void device_driver_detach(struct device *dev)
+{
+	device_release_driver_internal(dev, NULL, dev->parent);
+}
+
 /**
  * driver_detach - detach driver from all devices it controls.
  * @drv: driver.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
