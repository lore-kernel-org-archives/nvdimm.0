Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B4A621196239
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 16:32:27 -0800 (PST)
Subject: [driver-core PATCH v7 4/9] driver core: Probe devices
 asynchronously instead of the driver
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 28 Nov 2018 16:32:26 -0800
Message-ID: <154345154692.18040.8161459765233879389.stgit@ahduyck-desk1.amr.corp.intel.com>
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

Probe devices asynchronously instead of the driver. This results in us
seeing the same behavior if the device is registered before the driver or
after. This way we can avoid serializing the initialization should the
driver not be loaded until after the devices have already been added.

The motivation behind this is that if we have a set of devices that
take a significant amount of time to load we can greatly reduce the time to
load by processing them in parallel instead of one at a time. In addition,
each device can exist on a different node so placing a single thread on one
CPU to initialize all of the devices for a given driver can result in poor
performance on a system with multiple nodes.

This approach can reduce the time needed to scan SCSI LUNs significantly.
The only way to realize that speedup is by enabling more concurrency which
is what is achieved with this patch.

To achieve this it was necessary to add a new member "async_driver" to the
device_private structure to store the driver pointer while we wait on the
deferred probe call.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/base/base.h |    2 +
 drivers/base/bus.c  |   23 ++---------------
 drivers/base/dd.c   |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 73 insertions(+), 21 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 3f22ebd6117a..c95384a8e53c 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -64,6 +64,7 @@ struct driver_private {
  *	binding of drivers which were unable to get all the resources needed by
  *	the device; typically because it depends on another driver getting
  *	probed first.
+ * @async_driver - pointer to device driver awaiting probe via async_probe
  * @device - pointer back to the struct device that this structure is
  * associated with.
  *
@@ -75,6 +76,7 @@ struct device_private {
 	struct klist_node knode_driver;
 	struct klist_node knode_bus;
 	struct list_head deferred_probe;
+	struct device_driver *async_driver;
 	struct device *device;
 };
 #define to_device_private_parent(obj)	\
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
index d2515520569e..036c8ffa522f 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -674,6 +674,22 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
 	return ret;
 }
 
+static inline struct device_driver *dev_get_drv_async(const struct device *dev)
+{
+	return dev->async_probe ? dev->p->async_driver : NULL;
+}
+
+static inline void dev_set_drv_async(struct device *dev,
+				     struct device_driver *drv)
+{
+	/*
+	 * Set async_probe to true indicating we are waiting for this data to be
+	 * loaded as a potential driver.
+	 */
+	dev->p->async_driver = drv;
+	dev->async_probe = true;
+}
+
 bool driver_allows_async_probing(struct device_driver *drv)
 {
 	switch (drv->probe_type) {
@@ -836,7 +852,7 @@ static int __device_attach(struct device *dev, bool allow_async)
 			 */
 			dev_dbg(dev, "scheduling asynchronous probe\n");
 			get_device(dev);
-			dev->async_probe = true;
+			dev_set_drv_async(dev, NULL);
 			async_schedule(__device_attach_async_helper, dev);
 		} else {
 			pm_request_idle(dev);
@@ -929,6 +945,32 @@ int device_driver_attach(struct device_driver *drv, struct device *dev)
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
@@ -956,6 +998,25 @@ static int __driver_attach(struct device *dev, void *data)
 		return ret;
 	} /* ret > 0 means positive match */
 
+	if (driver_allows_async_probing(drv)) {
+		/*
+		 * Instead of probing the device synchronously we will
+		 * probe it asynchronously to allow for more parallelism.
+		 *
+		 * We only take the device lock here in order to guarantee
+		 * that the dev->driver and async_driver fields are protected
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
@@ -1054,6 +1115,12 @@ void device_release_driver_internal(struct device *dev,
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
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
