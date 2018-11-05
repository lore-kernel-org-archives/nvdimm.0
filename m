Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 091A82118B7A5
 for <linux-nvdimm@lists.01.org>; Mon,  5 Nov 2018 13:12:06 -0800 (PST)
Subject: [driver-core PATCH v5 5/9] driver core: Establish clear order of
 operations for deferred probe and remove
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Mon, 05 Nov 2018 13:12:04 -0800
Message-ID: <154145232484.29224.1635232599636954462.stgit@ahduyck-desk1.jf.intel.com>
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

This patch adds an additional bit to the device struct named async_probe.
This additional bit allows us to guarantee ordering between probe and
remove operations.

This allows us to guarantee that if we execute a remove operation or a
driver load attempt on a given interface it will not attempt to update the
driver member asynchronously following the earlier operation. Previously
this guarantee was not present and could result in us attempting to remove
a driver from an interface only to have it show up later when it is
asynchronously loaded.

One change I made in addition is I replaced the use of "bool X:1" to define
the bitfield to a "u8 X:1" setup in order to resolve some checkpatch
warnings.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/base/dd.c      |  104 +++++++++++++++++++++++++++---------------------
 include/linux/device.h |    9 ++--
 2 files changed, 64 insertions(+), 49 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index e74cefeb5b69..ed19cf0d6f9a 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -472,6 +472,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		 drv->bus->name, __func__, drv->name, dev_name(dev));
 	WARN_ON(!list_empty(&dev->devres_head));
 
+	/* clear async_probe flag as we are no longer deferring driver load */
+	dev->async_probe = false;
 re_probe:
 	dev->driver = drv;
 
@@ -771,6 +773,10 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 
 	device_lock(dev);
 
+	/* nothing to do if async_probe has been cleared */
+	if (!dev->async_probe)
+		goto out_unlock;
+
 	if (dev->parent)
 		pm_runtime_get_sync(dev->parent);
 
@@ -781,7 +787,7 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 
 	if (dev->parent)
 		pm_runtime_put(dev->parent);
-
+out_unlock:
 	device_unlock(dev);
 
 	put_device(dev);
@@ -826,6 +832,7 @@ static int __device_attach(struct device *dev, bool allow_async)
 			 */
 			dev_dbg(dev, "scheduling asynchronous probe\n");
 			get_device(dev);
+			dev->async_probe = true;
 			async_schedule(__device_attach_async_helper, dev);
 		} else {
 			pm_request_idle(dev);
@@ -971,62 +978,69 @@ EXPORT_SYMBOL_GPL(driver_attach);
  */
 static void __device_release_driver(struct device *dev, struct device *parent)
 {
-	struct device_driver *drv;
+	struct device_driver *drv = dev->driver;
 
-	drv = dev->driver;
-	if (drv) {
-		while (device_links_busy(dev)) {
-			__device_driver_unlock(dev, parent);
+	/*
+	 * In the event that we are asked to release the driver on an
+	 * interface that is still waiting on a probe we can just terminate
+	 * the probe by setting async_probe to false. When the async call
+	 * is finally completed it will see this state and just exit.
+	 */
+	dev->async_probe = false;
+	if (!drv)
+		return;
 
-			device_links_unbind_consumers(dev);
+	while (device_links_busy(dev)) {
+		__device_driver_unlock(dev, parent);
 
-			__device_driver_lock(dev, parent);
-			/*
-			 * A concurrent invocation of the same function might
-			 * have released the driver successfully while this one
-			 * was waiting, so check for that.
-			 */
-			if (dev->driver != drv)
-				return;
-		}
+		device_links_unbind_consumers(dev);
 
-		pm_runtime_get_sync(dev);
-		pm_runtime_clean_up_links(dev);
+		__device_driver_lock(dev, parent);
+		/*
+		 * A concurrent invocation of the same function might
+		 * have released the driver successfully while this one
+		 * was waiting, so check for that.
+		 */
+		if (dev->driver != drv)
+			return;
+	}
 
-		driver_sysfs_remove(dev);
+	pm_runtime_get_sync(dev);
+	pm_runtime_clean_up_links(dev);
 
-		if (dev->bus)
-			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
-						     BUS_NOTIFY_UNBIND_DRIVER,
-						     dev);
+	driver_sysfs_remove(dev);
 
-		pm_runtime_put_sync(dev);
+	if (dev->bus)
+		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
+					     BUS_NOTIFY_UNBIND_DRIVER,
+					     dev);
 
-		if (dev->bus && dev->bus->remove)
-			dev->bus->remove(dev);
-		else if (drv->remove)
-			drv->remove(dev);
+	pm_runtime_put_sync(dev);
 
-		device_links_driver_cleanup(dev);
-		arch_teardown_dma_ops(dev);
+	if (dev->bus && dev->bus->remove)
+		dev->bus->remove(dev);
+	else if (drv->remove)
+		drv->remove(dev);
 
-		devres_release_all(dev);
-		dev->driver = NULL;
-		dev_set_drvdata(dev, NULL);
-		if (dev->pm_domain && dev->pm_domain->dismiss)
-			dev->pm_domain->dismiss(dev);
-		pm_runtime_reinit(dev);
-		dev_pm_set_driver_flags(dev, 0);
+	device_links_driver_cleanup(dev);
+	arch_teardown_dma_ops(dev);
+
+	devres_release_all(dev);
+	dev->driver = NULL;
+	dev_set_drvdata(dev, NULL);
+	if (dev->pm_domain && dev->pm_domain->dismiss)
+		dev->pm_domain->dismiss(dev);
+	pm_runtime_reinit(dev);
+	dev_pm_set_driver_flags(dev, 0);
 
-		klist_remove(&dev->p->knode_driver);
-		device_pm_check_callbacks(dev);
-		if (dev->bus)
-			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
-						     BUS_NOTIFY_UNBOUND_DRIVER,
-						     dev);
+	klist_remove(&dev->p->knode_driver);
+	device_pm_check_callbacks(dev);
+	if (dev->bus)
+		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
+					     BUS_NOTIFY_UNBOUND_DRIVER,
+					     dev);
 
-		kobject_uevent(&dev->kobj, KOBJ_UNBIND);
-	}
+	kobject_uevent(&dev->kobj, KOBJ_UNBIND);
 }
 
 void device_release_driver_internal(struct device *dev,
diff --git a/include/linux/device.h b/include/linux/device.h
index 1b25c7a43f4c..fc7091d436c2 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1043,14 +1043,15 @@ struct device {
 	struct iommu_group	*iommu_group;
 	struct iommu_fwspec	*iommu_fwspec;
 
-	bool			offline_disabled:1;
-	bool			offline:1;
-	bool			of_node_reused:1;
+	u8			offline_disabled:1;
+	u8			offline:1;
+	u8			of_node_reused:1;
 #if defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE) || \
     defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU) || \
     defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
-	bool			dma_coherent:1;
+	u8			dma_coherent:1;
 #endif
+	u8			async_probe:1;
 };
 
 static inline struct device *kobj_to_dev(struct kobject *kobj)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
