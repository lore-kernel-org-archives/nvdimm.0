Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA54C2118B7A5
 for <linux-nvdimm@lists.01.org>; Mon,  5 Nov 2018 13:12:11 -0800 (PST)
Subject: [driver-core PATCH v5 6/9] driver core: Probe devices
 asynchronously instead of the driver
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Mon, 05 Nov 2018 13:12:10 -0800
Message-ID: <154145232994.29224.4383053368766089653.stgit@ahduyck-desk1.jf.intel.com>
In-Reply-To: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
References: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
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
Cc: len.brown@intel.com, bvanassche@acm.org, linux-pm@vger.kernel.org, alexander.h.duyck@linux.intel.com, rafael@kernel.org, jiangshanlai@gmail.com, linux-nvdimm@lists.01.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

This change makes it so that we probe devices asynchronously instead of the
driver. This results in us seeing the same behavior if the device is
registered before the driver or after. This way we can avoid serializing
the initialization should the driver not be loaded until after the devices
have already been added.

The motivation behind this is that if we have a set of devices that
take a significant amount of time to load we can greatly reduce the time to
load by processing them in parallel instead of one at a time. In addition,
each device can exist on a different node so placing a single thread on one
CPU to initialize all of the devices for a given driver can result in poor
performance on a system with multiple nodes.

I am using the driver_data member of the device struct to store the driver
pointer while we wait on the deferred probe call. This should be safe to do
as the value will either be set to NULL on a failed probe or driver load
followed by unload, or the driver value itself will be set on a successful
driver load. In addition I have used the async_probe flag to add additional
protection as it will be cleared if someone overwrites the driver_data
member as a part of loading the driver.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/base/bus.c     |   23 +++------------------
 drivers/base/dd.c      |   52 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |   26 +++++++++++++++++++++++-
 3 files changed, 80 insertions(+), 21 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 8a630f9bd880..0cd2eadd0816 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -606,17 +606,6 @@ static ssize_t uevent_store(struct device_driver *drv, const char *buf,
 }
 static DRIVER_ATTR_WO(uevent);
 
-static void driver_attach_async(void *_drv, async_cookie_t cookie)
-{
-	struct device_driver *drv = _drv;
-	int ret;
-
-	ret = driver_attach(drv);
-
-	pr_debug("bus: '%s': driver %s async attach completed: %d\n",
-		 drv->bus->name, drv->name, ret);
-}
-
 /**
  * bus_add_driver - Add a driver to the bus.
  * @drv: driver.
@@ -649,15 +638,9 @@ int bus_add_driver(struct device_driver *drv)
 
 	klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
 	if (drv->bus->p->drivers_autoprobe) {
-		if (driver_allows_async_probing(drv)) {
-			pr_debug("bus: '%s': probing driver %s asynchronously\n",
-				drv->bus->name, drv->name);
-			async_schedule(driver_attach_async, drv);
-		} else {
-			error = driver_attach(drv);
-			if (error)
-				goto out_unregister;
-		}
+		error = driver_attach(drv);
+		if (error)
+			goto out_unregister;
 	}
 	module_add_driver(drv->owner, drv);
 
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index ed19cf0d6f9a..2fdfe45bb6ea 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -808,6 +808,7 @@ static int __device_attach(struct device *dev, bool allow_async)
 			ret = 1;
 		else {
 			dev->driver = NULL;
+			dev_set_drvdata(dev, NULL);
 			ret = 0;
 		}
 	} else {
@@ -925,6 +926,32 @@ int device_driver_attach(struct device_driver *drv, struct device *dev)
 	return ret;
 }
 
+static void __driver_attach_async_helper(void *_dev, async_cookie_t cookie)
+{
+	struct device *dev = _dev;
+	struct device_driver *drv;
+
+	__device_driver_lock(dev, dev->parent);
+
+	/*
+	 * If someone attempted to bind a driver either successfully or
+	 * unsuccessfully before we got here we should just skip the driver
+	 * probe call.
+	 */
+	drv = dev_get_drv_async(dev);
+	if (drv && !dev->driver)
+		driver_probe_device(drv, dev);
+
+	/* We made our attempt at an async_probe, clear the flag */
+	dev->async_probe = false;
+
+	__device_driver_unlock(dev, dev->parent);
+
+	put_device(dev);
+
+	dev_dbg(dev, "async probe completed\n");
+}
+
 static int __driver_attach(struct device *dev, void *data)
 {
 	struct device_driver *drv = data;
@@ -952,6 +979,25 @@ static int __driver_attach(struct device *dev, void *data)
 		return ret;
 	} /* ret > 0 means positive match */
 
+	if (driver_allows_async_probing(drv)) {
+		/*
+		 * Instead of probing the device synchronously we will
+		 * probe it asynchronously to allow for more parallelism.
+		 *
+		 * We only take the device lock here in order to guarantee
+		 * that the dev->driver and driver_data fields are protected
+		 */
+		dev_dbg(dev, "scheduling asynchronous probe\n");
+		device_lock(dev);
+		if (!dev->driver) {
+			get_device(dev);
+			dev_set_drv_async(dev, drv);
+			async_schedule(__driver_attach_async_helper, dev);
+		}
+		device_unlock(dev);
+		return 0;
+	}
+
 	device_driver_attach(drv, dev);
 
 	return 0;
@@ -1049,6 +1095,12 @@ void device_release_driver_internal(struct device *dev,
 {
 	__device_driver_lock(dev, parent);
 
+	/*
+	 * We shouldn't need to add a check for any pending async_probe here
+	 * because the only caller that will pass us a driver, driver_detach,
+	 * should have been called after the driver was removed from the bus
+	 * and will call async_synchronize_full before we get to this point.
+	 */
 	if (!drv || drv == dev->driver)
 		__device_release_driver(dev, parent);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index fc7091d436c2..4d9a39769081 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -910,7 +910,9 @@ struct dev_links_info {
  * 		variants, which GPIO pins act in what additional roles, and so
  * 		on.  This shrinks the "Board Support Packages" (BSPs) and
  * 		minimizes board-specific #ifdefs in drivers.
- * @driver_data: Private pointer for driver specific info.
+ * @driver_data: Private pointer for driver specific info if driver is
+ *		non-NULL. Pointer to deferred driver to be attached if driver
+ *		is NULL.
  * @links:	Links to suppliers and consumers of this device.
  * @power:	For device power management.
  *		See Documentation/driver-api/pm/devices.rst for details.
@@ -1116,9 +1118,31 @@ static inline void *dev_get_drvdata(const struct device *dev)
 
 static inline void dev_set_drvdata(struct device *dev, void *data)
 {
+	/*
+	 * clear async_probe to prevent us from attempting to read driver_data
+	 * as a driver. We can reset this to true for the one case where we are
+	 * using this to record an actual driver.
+	 */
+	dev->async_probe = false;
 	dev->driver_data = data;
 }
 
+static inline struct device_driver *dev_get_drv_async(const struct device *dev)
+{
+	return dev->async_probe ? dev->driver_data : NULL;
+}
+
+static inline void dev_set_drv_async(struct device *dev,
+				     struct device_driver *drv)
+{
+	/*
+	 * Set async_probe to true indicating we are waiting for this data to be
+	 * loaded as a potential driver.
+	 */
+	dev->driver_data = drv;
+	dev->async_probe = true;
+}
+
 static inline struct pm_subsys_data *dev_to_psd(struct device *dev)
 {
 	return dev ? dev->power.subsys_data : NULL;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
