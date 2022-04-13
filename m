Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AC523CA
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 06:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649829713; x=1681365713;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+8KRmXihZjR6F7KMu/IkyUTy0vLDDknlzWwTKsgw244=;
  b=c3gDtoCbjfmsR3X4oBZA/iwoA9ZOCSSX1NuBiPp2MFKZz0OkYkw+NskZ
   0mxkOTleyiucQZ3j/FTl7Oqio3a6c0/ZAOkLhJTsXcj0VVrDOCs6Drfz1
   tubtLmNu5garBAOqzs1AKT48bFNYthA3kWrLP9SDwjI5U88vocFGgcaMS
   X2TUcz8m4pORc5TwvfKa6z8kqIZK3nHJeJMOzh+rkt0qZHzL21eEsjXt0
   SPGuiH3YxpnXhmDU1TdaVc8p5yhLEZq8RzWwrwpmtSqmPjyAj/jsxdnDZ
   n77ckc9Z3ePLcg2AGRn95BzlloD4d0OH6sw5EB3Nd/aWx4ewoyrBIUUE3
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="262025876"
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="262025876"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:01:33 -0700
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="590632232"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:01:33 -0700
Subject: [PATCH v2 01/12] device-core: Move device_lock() lockdep init to a
 helper
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Kevin Tian <kevin.tian@intel.com>,
 peterz@infradead.org, vishal.l.verma@intel.com, alison.schofield@intel.com,
 gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Tue, 12 Apr 2022 23:01:33 -0700
Message-ID: <164982969345.684294.10649947254613843363.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for new infrastructure to support lockdep validation of
device_lock() usage across driver subsystems, add a
device_lockdep_init() helper to contain those updates.

Suggested-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/base/core.c    |    5 +----
 include/linux/device.h |   13 +++++++++++++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 3d6430eb0c6a..cb782299ae44 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2864,10 +2864,7 @@ void device_initialize(struct device *dev)
 	kobject_init(&dev->kobj, &device_ktype);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	mutex_init(&dev->mutex);
-#ifdef CONFIG_PROVE_LOCKING
-	mutex_init(&dev->lockdep_mutex);
-#endif
-	lockdep_set_novalidate_class(&dev->mutex);
+	device_lockdep_init(dev);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
 	device_pm_init(dev);
diff --git a/include/linux/device.h b/include/linux/device.h
index 93459724dcde..af2576ace130 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -762,6 +762,19 @@ static inline bool dev_pm_test_driver_flags(struct device *dev, u32 flags)
 	return !!(dev->power.driver_flags & flags);
 }
 
+#ifdef CONFIG_PROVE_LOCKING
+static inline void device_lockdep_init(struct device *dev)
+{
+	mutex_init(&dev->lockdep_mutex);
+	lockdep_set_novalidate_class(&dev->mutex);
+}
+#else
+static inline void device_lockdep_init(struct device *dev)
+{
+	lockdep_set_novalidate_class(&dev->mutex);
+}
+#endif
+
 static inline void device_lock(struct device *dev)
 {
 	mutex_lock(&dev->mutex);

