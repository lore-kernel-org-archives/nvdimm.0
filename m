Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDFC17E4
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 02:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646102989; x=1677638989;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0ejWEtzYFXkVmMw+7/8/byv2i/2ikDMzQlZB6daiDkE=;
  b=dGg7PM0O7tBQWA4MC6tCu0QkTTqEbMeaw4y3PDm03xYhzx7nIIYBSK+1
   95buvFXuRZrwnG10iXwwwlWC2SOVFwkyX9g15qku61edGP8J9XT7KMkFV
   BcGfx0JkppBEUwm/PlGQuZkQs7Ets8BtJ1gXbgY1Wuf2FL/Pyiv66dP5x
   +Cu9wqfYMXfy87S4xUAhza7t4+xbxTMV+YCdfFhuKscsOdEwPP+cKOAIm
   KEWdhGuOQSQxjfYTpiD7GELu5F/mMCgiqJ7DSWrQ86XCh2RbPEKMH9D4V
   ecZ/ELyE8nMws+xpGX4jyKNIuqAOA67j6IUFdogXLTpydpcwis0BnXEFH
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="253232914"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="253232914"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:49:48 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="544943085"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:49:48 -0800
Subject: [PATCH 11/11] device-core: Introduce a per-subsystem lockdep_mutex
From: Dan Williams <dan.j.williams@intel.com>
To: gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Ben Widawsky <ben.widawsky@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Mon, 28 Feb 2022 18:49:48 -0800
Message-ID: <164610298807.2682974.4215886933533996734.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164610292916.2682974.12924748003366352335.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164610292916.2682974.12924748003366352335.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In order for multiple subsystems to convey their device_lock ordering
constraints, each needs their own exclusive mutex. Rather than select a
subsystem to validate at compile-time, allow for simultaneous
validation of multiple subsystems.

Note that the reason the mutex_init() for the various subsystem
device-locks is unrolled in device_lockdep_init(), vs a DEVICE_LOCK_MAX
loop, is to give each lock a unique lock_class_key and name in reports.
That approach is not elegant, and not scalable, but it seems the best
that can be done given lockdep's expectations.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/base/core.c      |    6 +--
 drivers/cxl/acpi.c       |    2 +
 drivers/cxl/cxl.h        |    4 +-
 drivers/cxl/port.c       |    2 +
 drivers/nvdimm/nd-core.h |    5 ++-
 include/linux/device.h   |   83 ++++++++++++++++++++++++++++++++++++++--------
 lib/Kconfig.debug        |   24 -------------
 7 files changed, 76 insertions(+), 50 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 96430fa5152e..fae3073fd9c6 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2864,11 +2864,7 @@ void device_initialize(struct device *dev)
 	kobject_init(&dev->kobj, &device_ktype);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	mutex_init(&dev->mutex);
-#ifdef CONFIG_PROVE_LOCKING
-	mutex_init(&dev->lockdep_mutex);
-	dev->lock_class = -1;
-#endif
-	lockdep_set_novalidate_class(&dev->mutex);
+	device_lockdep_init(dev);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
 	device_pm_init(dev);
diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 7fa7bf6088cd..218c4367c39f 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -313,7 +313,7 @@ static int cxl_acpi_probe(struct platform_device *pdev)
 	struct acpi_device *adev = ACPI_COMPANION(host);
 	struct cxl_cfmws_context ctx;
 
-	device_set_lock_class(&pdev->dev, CXL_ROOT_LOCK);
+	device_set_lock_class(&pdev->dev, DEVICE_LOCK_CXL, CXL_ROOT_LOCK);
 	root_port = devm_cxl_add_port(host, host, CXL_RESOURCE_NONE, NULL);
 	if (IS_ERR(root_port))
 		return PTR_ERR(root_port);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 5179b6bb1b36..70a12bfd71b5 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -510,7 +510,7 @@ enum cxl_lock_class {
 	 */
 };
 
-#ifdef CONFIG_PROVE_CXL_LOCKING
+#ifdef CONFIG_PROVE_LOCKING
 static inline int clamp_lock_class(struct device *dev, int lock_class)
 {
 	if (lock_class >= MAX_LOCKDEP_SUBCLASSES) {
@@ -547,7 +547,7 @@ static inline int cxl_lock_class(struct device *dev)
 
 static inline void cxl_set_lock_class(struct device *dev)
 {
-	device_set_lock_class(dev, cxl_lock_class(dev));
+	device_set_lock_class(dev, DEVICE_LOCK_CXL, cxl_lock_class(dev));
 }
 #else
 static inline void cxl_set_lock_class(struct device *dev)
diff --git a/drivers/cxl/port.c b/drivers/cxl/port.c
index fdb62ed06433..f3c11a780bed 100644
--- a/drivers/cxl/port.c
+++ b/drivers/cxl/port.c
@@ -17,7 +17,7 @@
  * firmware) are managed in this drivers context. Each driver instance
  * is responsible for tearing down the driver context of immediate
  * descendant ports. The locking for this is validated by
- * CONFIG_PROVE_CXL_LOCKING.
+ * CONFIG_PROVE_LOCKING.
  *
  * The primary service this driver provides is presenting APIs to other
  * drivers to utilize the decoders, and indicating to userspace (via bind
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 40065606a6e6..3754603e2ace 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -185,7 +185,7 @@ static inline void devm_nsio_disable(struct device *dev,
 }
 #endif
 
-#ifdef CONFIG_PROVE_NVDIMM_LOCKING
+#ifdef CONFIG_PROVE_LOCKING
 extern struct class *nd_class;
 
 enum {
@@ -217,7 +217,8 @@ static inline int nvdimm_lock_class(struct device *dev)
 
 static inline void nvdimm_set_lock_class(struct device *dev)
 {
-	device_set_lock_class(dev, nvdimm_lock_class(dev));
+	device_set_lock_class(dev, DEVICE_LOCK_NVDIMM,
+			      nvdimm_lock_class(dev));
 }
 #else
 static inline void nvdimm_set_lock_class(struct device *dev)
diff --git a/include/linux/device.h b/include/linux/device.h
index e313ff21d670..5cc8e4cf764f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -386,6 +386,16 @@ struct dev_msi_info {
 #endif
 };
 
+enum device_lock_subsys {
+#if IS_ENABLED(CONFIG_LIBNVDIMM)
+	DEVICE_LOCK_NVDIMM,
+#endif
+#if IS_ENABLED(CONFIG_CXL_BUS)
+	DEVICE_LOCK_CXL,
+#endif
+	DEVICE_LOCK_MAX,
+};
+
 /**
  * struct device - The basic device structure
  * @parent:	The device's "parent" device, the device to which it is attached.
@@ -400,7 +410,7 @@ struct dev_msi_info {
  * 		This identifies the device type and carries type-specific
  * 		information.
  * @mutex:	Mutex to synchronize calls to its driver.
- * @lockdep_mutex: An optional debug lock that a subsystem can use as a
+ * @lockdep_mutex: A set of optional debug locks that subsystem can use as a
  * 		peer lock to gain localized lockdep coverage of the device_lock.
  * @lock_class: per-subsystem annotated device lock class
  * @bus:	Type of bus device is on.
@@ -501,8 +511,9 @@ struct device {
 	void		*driver_data;	/* Driver data, set and get with
 					   dev_set_drvdata/dev_get_drvdata */
 #ifdef CONFIG_PROVE_LOCKING
-	struct mutex		lockdep_mutex;
+	struct mutex		lockdep_mutex[DEVICE_LOCK_MAX];
 	int			lock_class;
+	int			lock_subsys;
 #endif
 	struct mutex		mutex;	/* mutex to synchronize calls to
 					 * its driver.
@@ -790,35 +801,55 @@ static inline void device_unlock(struct device *dev)
 	mutex_unlock(&dev->mutex);
 }
 
-static inline void device_set_lock_class(struct device *dev, int lock_class)
+static inline void device_set_lock_class(struct device *dev,
+					 enum device_lock_subsys subssys,
+					 int lock_class)
+{
+}
+
+static inline void device_lockdep_init(struct device *dev)
 {
 }
 #else
+static inline struct mutex *device_lockdep_mutex(struct device *dev)
+{
+	if (dev->lock_subsys < 0)
+		return NULL;
+	if (dev->lock_class < 0)
+		return NULL;
+	return &dev->lockdep_mutex[dev->lock_subsys];
+}
+
 static inline void device_lock(struct device *dev)
 {
-	lockdep_assert_not_held(&dev->lockdep_mutex);
+	struct mutex *lockdep_mutex = device_lockdep_mutex(dev);
+
+	if (lockdep_mutex)
+		lockdep_assert_not_held(lockdep_mutex);
 
 	mutex_lock(&dev->mutex);
-	if (dev->lock_class >= 0)
-		mutex_lock_nested(&dev->lockdep_mutex, dev->lock_class);
+	if (lockdep_mutex)
+		mutex_lock_nested(lockdep_mutex, dev->lock_class);
 }
 
 static inline int device_lock_interruptible(struct device *dev)
 {
 	int rc = mutex_lock_interruptible(&dev->mutex);
+	struct mutex *lockdep_mutex = device_lockdep_mutex(dev);
 
-	if (rc || dev->lock_class < 0)
+	if (rc || !lockdep_mutex)
 		return rc;
 
-	return mutex_lock_interruptible_nested(&dev->lockdep_mutex,
-					       dev->lock_class);
+	return mutex_lock_interruptible_nested(lockdep_mutex, dev->lock_class);
 }
 
 static inline int device_trylock(struct device *dev)
 {
+	struct mutex *lockdep_mutex = device_lockdep_mutex(dev);
+
 	if (mutex_trylock(&dev->mutex)) {
-		if (dev->lock_class >= 0)
-			mutex_lock_nested(&dev->lockdep_mutex, dev->lock_class);
+		if (lockdep_mutex)
+			mutex_lock_nested(lockdep_mutex, dev->lock_class);
 		return 1;
 	}
 
@@ -827,20 +858,28 @@ static inline int device_trylock(struct device *dev)
 
 static inline void device_unlock(struct device *dev)
 {
+	struct mutex *lockdep_mutex = device_lockdep_mutex(dev);
+
 	if (dev->lock_class >= 0)
-		mutex_unlock(&dev->lockdep_mutex);
+		mutex_unlock(lockdep_mutex);
 	mutex_unlock(&dev->mutex);
 }
 
-static inline void device_set_lock_class(struct device *dev, int lock_class)
+static inline void device_set_lock_class(struct device *dev,
+					 enum device_lock_subsys subsys,
+					 int lock_class)
 {
+	if (subsys < 0)
+		return;
+
 	if (dev->lock_class < 0 && lock_class > 0) {
 		if (mutex_is_locked(&dev->mutex)) {
 			/*
 			 * device_unlock() will unlock lockdep_mutex now that
 			 * lock_class is set, so take the paired lock now
 			 */
-			mutex_lock_nested(&dev->lockdep_mutex, lock_class);
+			mutex_lock_nested(&dev->lockdep_mutex[subsys],
+					  lock_class);
 		}
 	} else if (dev->lock_class >= 0 && lock_class < 0) {
 		if (mutex_is_locked(&dev->mutex)) {
@@ -849,10 +888,24 @@ static inline void device_set_lock_class(struct device *dev, int lock_class)
 			 * that lock_class is disabled, so drop the paired lock
 			 * now.
 			 */
-			mutex_unlock(&dev->lockdep_mutex);
+			mutex_unlock(&dev->lockdep_mutex[subsys]);
 		}
 	}
 	dev->lock_class = lock_class;
+	dev->lock_subsys = subsys;
+}
+
+static inline void device_lockdep_init(struct device *dev)
+{
+#if IS_ENABLED(CONFIG_CXL_BUS)
+	mutex_init(&dev->lockdep_mutex[DEVICE_LOCK_CXL]);
+#endif
+#if IS_ENABLED(CONFIG_LIBNVDIMM)
+	mutex_init(&dev->lockdep_mutex[DEVICE_LOCK_NVDIMM]);
+#endif
+	dev->lock_subsys = -1;
+	dev->lock_class = -1;
+	lockdep_set_novalidate_class(&dev->mutex);
 }
 #endif
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a4bd109f6178..14b89aa37c5c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1516,30 +1516,6 @@ config CSD_LOCK_WAIT_DEBUG
 	  include the IPI handler function currently executing (if any)
 	  and relevant stack traces.
 
-choice
-	prompt "Lock debugging: prove subsystem device_lock() correctness"
-	depends on PROVE_LOCKING
-	help
-	  For subsystems that have instrumented their usage of the device_lock()
-	  with nested annotations, enable lock dependency checking. The locking
-	  hierarchy 'subclass' identifiers are not compatible across
-	  sub-systems, so only one can be enabled at a time.
-
-config PROVE_NVDIMM_LOCKING
-	bool "NVDIMM"
-	depends on LIBNVDIMM
-	help
-	  Enable lockdep to validate libnvdimm subsystem usage of the
-	  device lock.
-
-config PROVE_CXL_LOCKING
-	bool "CXL"
-	depends on CXL_BUS
-	help
-	  Enable lockdep to validate CXL subsystem usage of the device lock.
-
-endchoice
-
 endmenu # lock debugging
 
 config TRACE_IRQFLAGS

