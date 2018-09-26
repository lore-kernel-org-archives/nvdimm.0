Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0FEFE21157438
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 14:51:52 -0700 (PDT)
Subject: [RFC workqueue/driver-core PATCH 3/5] driver core: Probe devices
 asynchronously instead of the driver
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 26 Sep 2018 14:51:49 -0700
Message-ID: <20180926215149.13512.51991.stgit@localhost.localdomain>
In-Reply-To: <20180926214433.13512.30289.stgit@localhost.localdomain>
References: <20180926214433.13512.30289.stgit@localhost.localdomain>
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
To: linux-nvdimm@lists.01.org, gregkh@linuxfoundation.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org, akpm@linux-foundation.org
Cc: len.brown@intel.com, rafael@kernel.org, jiangshanlai@gmail.com, pavel@ucw.cz, zwisler@kernel.org
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

One issue I can see with this patch is that I am using the
dev_set/get_drvdata functions to store the driver in the device while I am
waiting on the asynchronous init to complete. For now I am protecting it by
using the lack of a dev->driver and the device lock.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/base/bus.c |   23 +++--------------------
 drivers/base/dd.c  |   42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 8bfd27ec73d6..2a17bed657ec 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -616,17 +616,6 @@ static ssize_t uevent_store(struct device_driver *drv, const char *buf,
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
@@ -659,15 +648,9 @@ int bus_add_driver(struct device_driver *drv)
 
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
index 169412ee4ae8..5ba366c1cb83 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -864,6 +864,29 @@ void device_initial_probe(struct device *dev)
 	__device_attach(dev, true);
 }
 
+static void __driver_attach_async_helper(void *_dev, async_cookie_t cookie)
+{
+	struct device *dev = _dev;
+
+	if (dev->parent && dev->bus->need_parent_lock)
+		device_lock(dev->parent);
+	device_lock(dev);
+
+	if (!dev->driver) {
+		struct device_driver *drv = dev_get_drvdata(dev);
+
+		driver_probe_device(drv, dev);
+	}
+
+	dev_dbg(dev, "async probe completed\n");
+
+	device_unlock(dev);
+	if (dev->parent && dev->bus->need_parent_lock)
+		device_unlock(dev->parent);
+
+	put_device(dev);
+}
+
 static int __driver_attach(struct device *dev, void *data)
 {
 	struct device_driver *drv = data;
@@ -891,6 +914,25 @@ static int __driver_attach(struct device *dev, void *data)
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
+			dev_set_drvdata(dev, drv);
+			async_schedule(__driver_attach_async_helper, dev);
+		}
+		device_unlock(dev);
+		return 0;
+	}
+
 	if (dev->parent && dev->bus->need_parent_lock)
 		device_lock(dev->parent);
 	device_lock(dev);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
