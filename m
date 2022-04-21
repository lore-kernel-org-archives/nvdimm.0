Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C0F1FC9
	for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 15:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650555404; x=1682091404;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qo8mEyXyeD/WLpM5PUEvAxSmJze8tzwfv5FGI2P5jME=;
  b=ODkfnlHnBNWcVt3toGsc/Qc4thyWrjAFLQkQTEgi/Lu5yYDcCYW59WJw
   LWmqMVdGg798UHqfmvtjV+U9+fqUxkRx61Il6ozDjhV3X5fTtJM6YHD5m
   MXo/jDINHhkRz09rDGegTMCjRTjZFo932+8Kz6xAe3HAVA8Nu4a9rVKxt
   4pv8TlizBIfSdatwJzeKKcEHXrO4SXnw1D2fYO8b61he0fSeOT6iNIQO/
   FVjTMhVP+DsWPMij9JUAxCX2FloTnmQZ4TYLB98iNumDBdscdSgx1s/To
   vwV+D6Qyj15Qan0bgQelFNxjWAsithlvY5EemiJHuN5dRxS7YS1DVJie7
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="246290639"
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="246290639"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 08:33:46 -0700
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="866382131"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 08:33:45 -0700
Subject: [PATCH v3 7/8] device-core: Kill the lockdep_mutex
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 vishal.l.verma@intel.com, alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Date: Thu, 21 Apr 2022 08:33:45 -0700
Message-ID: <165055522548.3745911.14298368286915484086.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <165055518776.3745911.9346998911322224736.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <165055518776.3745911.9346998911322224736.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Per Peter [1], the lockdep API has native support for all the use cases
lockdep_mutex was attempting to enable. Now that all lockdep_mutex users
have been converted to those APIs, drop this lock.

Link: https://lore.kernel.org/r/Ylf0dewci8myLvoW@hirez.programming.kicks-ass.net [1]
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/base/core.c    |    3 ---
 include/linux/device.h |    5 -----
 2 files changed, 8 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 3d6430eb0c6a..2eede2ec3d64 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2864,9 +2864,6 @@ void device_initialize(struct device *dev)
 	kobject_init(&dev->kobj, &device_ktype);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	mutex_init(&dev->mutex);
-#ifdef CONFIG_PROVE_LOCKING
-	mutex_init(&dev->lockdep_mutex);
-#endif
 	lockdep_set_novalidate_class(&dev->mutex);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
diff --git a/include/linux/device.h b/include/linux/device.h
index 82c9d307e7bd..c00ab223da50 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -400,8 +400,6 @@ struct dev_msi_info {
  * 		This identifies the device type and carries type-specific
  * 		information.
  * @mutex:	Mutex to synchronize calls to its driver.
- * @lockdep_mutex: An optional debug lock that a subsystem can use as a
- * 		peer lock to gain localized lockdep coverage of the device_lock.
  * @bus:	Type of bus device is on.
  * @driver:	Which driver has allocated this
  * @platform_data: Platform data specific to the device.
@@ -499,9 +497,6 @@ struct device {
 					   core doesn't touch it */
 	void		*driver_data;	/* Driver data, set and get with
 					   dev_set_drvdata/dev_get_drvdata */
-#ifdef CONFIG_PROVE_LOCKING
-	struct mutex		lockdep_mutex;
-#endif
 	struct mutex		mutex;	/* mutex to synchronize calls to
 					 * its driver.
 					 */

