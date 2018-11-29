Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 856C421196229
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 16:32:17 -0800 (PST)
Subject: [driver-core PATCH v7 2/9] driver core: Establish clear order of
 operations for deferred probe and remove
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 28 Nov 2018 16:32:16 -0800
Message-ID: <154345153672.18040.3771035148218843351.stgit@ahduyck-desk1.amr.corp.intel.com>
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

Add an additional bit flag to the device struct named async_probe. This
additional flag allows us to guarantee ordering between probe and remove
operations.

This allows us to guarantee that if we execute a remove operation on a
given interface it will not attempt to update the driver member
asynchronously following the earlier operation. Previously this guarantee
was not present and could result in us attempting to remove a driver from
an interface only to have it attempt to attach the driver later when we
finally complete the deferred asynchronous probe call.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/base/dd.c      |   16 ++++++++++++++++
 include/linux/device.h |    3 +++
 2 files changed, 19 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 88713f182086..ef3f70a7cb5a 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -774,6 +774,10 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 
 	device_lock(dev);
 
+	/* nothing to do if async_probe has been cleared */
+	if (!dev->async_probe)
+		goto out_unlock;
+
 	if (dev->parent)
 		pm_runtime_get_sync(dev->parent);
 
@@ -785,6 +789,9 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 	if (dev->parent)
 		pm_runtime_put(dev->parent);
 
+	/* We made our attempt at an async_probe, clear the flag */
+	dev->async_probe = false;
+out_unlock:
 	device_unlock(dev);
 
 	put_device(dev);
@@ -829,6 +836,7 @@ static int __device_attach(struct device *dev, bool allow_async)
 			 */
 			dev_dbg(dev, "scheduling asynchronous probe\n");
 			get_device(dev);
+			dev->async_probe = true;
 			async_schedule(__device_attach_async_helper, dev);
 		} else {
 			pm_request_idle(dev);
@@ -929,6 +937,14 @@ static void __device_release_driver(struct device *dev, struct device *parent)
 {
 	struct device_driver *drv;
 
+	/*
+	 * In the event that we are asked to release the driver on an
+	 * interface that is still waiting on a probe we can just terminate
+	 * the probe by setting async_probe to false. When the async call
+	 * is finally completed it will see this state and just exit.
+	 */
+	dev->async_probe = false;
+
 	drv = dev->driver;
 	if (drv) {
 		while (device_links_busy(dev)) {
diff --git a/include/linux/device.h b/include/linux/device.h
index 1b25c7a43f4c..4d2eb2c74149 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -957,6 +957,8 @@ struct dev_links_info {
  *              device.
  * @dma_coherent: this particular device is dma coherent, even if the
  *		architecture supports non-coherent devices.
+ * @async_probe: This device has an asynchronous probe event pending. Should
+ *		 only be updated while holding device lock.
  *
  * At the lowest level, every device in a Linux system is represented by an
  * instance of struct device. The device structure contains the information
@@ -1051,6 +1053,7 @@ struct device {
     defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
 	bool			dma_coherent:1;
 #endif
+	bool			async_probe:1;
 };
 
 static inline struct device *kobj_to_dev(struct kobject *kobj)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
