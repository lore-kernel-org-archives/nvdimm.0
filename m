Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F6017E4
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 02:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646102938; x=1677638938;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5s4C1XoxbbWcTd1M501STQqQFqAZkTdnQMPZcJvB8f4=;
  b=Z6tNHaNvmYJ5fR73A32M99D0iCgynGi3S3oSvEJEFEJfMGWsplr1jmaK
   E/4CIvexHJ610JmktTFL3dngwJ8dLXS3pohkz/1hSL1b4LZbfOG5RRm+H
   VCAG3FSxFvTZMz52mZedICnaD5IqgFrAhBefY6kgFdzmFA3noJWBA9ZMK
   Cx911E4w6i1uYwwwJYYWmB2fbuqtyBifDwZVaTQ+50XC93EF0lC5YYjhm
   qRkH9kuL/J1dDwwUezJ8dNlY5Mn/5XyyDLbZJCBtE+MzQo4N73VAmF8gx
   2RkP/LNyx4498jzlytwxJYu2T9Jcz2FriVO0ild/9sFHR5Jjmph+uCY1x
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="251873198"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="251873198"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:48:55 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="544942973"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:48:54 -0800
Subject: [PATCH 01/11] device-core: Enable lockdep validation
From: Dan Williams <dan.j.williams@intel.com>
To: gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, vishal.l.verma@intel.com,
 alison.schofield@intel.com, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Mon, 28 Feb 2022 18:48:54 -0800
Message-ID: <164610293458.2682974.15975217569862336908.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The @lockdep_mutex attribute of 'struct device' was introduced to allow
subsystems to wrap their usage of device_lock() with a local definition
that adds nested annotations and lockdep validation. However, that
approach leaves lockdep blind to the device_lock usage in the
device-core. Instead of requiring the subsystem to replace device_lock()
teach the core device_lock() to consider a subsystem specified lock
class.

While this enables increased coverage of the device_lock() it is still
limited to one subsystem at a time unless / until a unique
"lockdep_mutex" is added for each subsystem that wants a distinct lock
class number space.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/base/core.c    |    1 +
 include/linux/device.h |   73 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7bb957b11861..96430fa5152e 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2866,6 +2866,7 @@ void device_initialize(struct device *dev)
 	mutex_init(&dev->mutex);
 #ifdef CONFIG_PROVE_LOCKING
 	mutex_init(&dev->lockdep_mutex);
+	dev->lock_class = -1;
 #endif
 	lockdep_set_novalidate_class(&dev->mutex);
 	spin_lock_init(&dev->devres_lock);
diff --git a/include/linux/device.h b/include/linux/device.h
index 93459724dcde..e313ff21d670 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -402,6 +402,7 @@ struct dev_msi_info {
  * @mutex:	Mutex to synchronize calls to its driver.
  * @lockdep_mutex: An optional debug lock that a subsystem can use as a
  * 		peer lock to gain localized lockdep coverage of the device_lock.
+ * @lock_class: per-subsystem annotated device lock class
  * @bus:	Type of bus device is on.
  * @driver:	Which driver has allocated this
  * @platform_data: Platform data specific to the device.
@@ -501,6 +502,7 @@ struct device {
 					   dev_set_drvdata/dev_get_drvdata */
 #ifdef CONFIG_PROVE_LOCKING
 	struct mutex		lockdep_mutex;
+	int			lock_class;
 #endif
 	struct mutex		mutex;	/* mutex to synchronize calls to
 					 * its driver.
@@ -762,6 +764,12 @@ static inline bool dev_pm_test_driver_flags(struct device *dev, u32 flags)
 	return !!(dev->power.driver_flags & flags);
 }
 
+static inline void device_lock_assert(struct device *dev)
+{
+	lockdep_assert_held(&dev->mutex);
+}
+
+#ifndef CONFIG_PROVE_LOCKING
 static inline void device_lock(struct device *dev)
 {
 	mutex_lock(&dev->mutex);
@@ -782,10 +790,71 @@ static inline void device_unlock(struct device *dev)
 	mutex_unlock(&dev->mutex);
 }
 
-static inline void device_lock_assert(struct device *dev)
+static inline void device_set_lock_class(struct device *dev, int lock_class)
 {
-	lockdep_assert_held(&dev->mutex);
 }
+#else
+static inline void device_lock(struct device *dev)
+{
+	lockdep_assert_not_held(&dev->lockdep_mutex);
+
+	mutex_lock(&dev->mutex);
+	if (dev->lock_class >= 0)
+		mutex_lock_nested(&dev->lockdep_mutex, dev->lock_class);
+}
+
+static inline int device_lock_interruptible(struct device *dev)
+{
+	int rc = mutex_lock_interruptible(&dev->mutex);
+
+	if (rc || dev->lock_class < 0)
+		return rc;
+
+	return mutex_lock_interruptible_nested(&dev->lockdep_mutex,
+					       dev->lock_class);
+}
+
+static inline int device_trylock(struct device *dev)
+{
+	if (mutex_trylock(&dev->mutex)) {
+		if (dev->lock_class >= 0)
+			mutex_lock_nested(&dev->lockdep_mutex, dev->lock_class);
+		return 1;
+	}
+
+	return 0;
+}
+
+static inline void device_unlock(struct device *dev)
+{
+	if (dev->lock_class >= 0)
+		mutex_unlock(&dev->lockdep_mutex);
+	mutex_unlock(&dev->mutex);
+}
+
+static inline void device_set_lock_class(struct device *dev, int lock_class)
+{
+	if (dev->lock_class < 0 && lock_class > 0) {
+		if (mutex_is_locked(&dev->mutex)) {
+			/*
+			 * device_unlock() will unlock lockdep_mutex now that
+			 * lock_class is set, so take the paired lock now
+			 */
+			mutex_lock_nested(&dev->lockdep_mutex, lock_class);
+		}
+	} else if (dev->lock_class >= 0 && lock_class < 0) {
+		if (mutex_is_locked(&dev->mutex)) {
+			/*
+			 * device_unlock() will no longer drop lockdep_mutex now
+			 * that lock_class is disabled, so drop the paired lock
+			 * now.
+			 */
+			mutex_unlock(&dev->lockdep_mutex);
+		}
+	}
+	dev->lock_class = lock_class;
+}
+#endif
 
 static inline struct device_node *dev_of_node(struct device *dev)
 {

