Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324436D15
	for <nvdimm@lists.linux.dev>; Tue, 15 Jun 2021 23:18:23 +0000 (UTC)
IronPort-SDR: U92jtE5RBsa40V1BhWOhs7yuXx8LhhCzzze/kxMchWaIbPGLBnWNPQi4J0Z2A4/qy7WIbuMyO8
 iDyCNcny6XlQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="203061478"
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="203061478"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 16:18:23 -0700
IronPort-SDR: r748HdJYtg+sBq0nJ7tGTL1LmktZtEHFcZ6HpbK8dr5Zu8qUaDeoZzOVxBxSO27gPWGvoGnTur
 UhZ76JkPMWFg==
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="421280523"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 16:18:22 -0700
Subject: [PATCH v2 3/5] libnvdimm: Export nvdimm shutdown helper,
 nvdimm_delete()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Date: Tue, 15 Jun 2021 16:18:22 -0700
Message-ID: <162379910271.2993820.2955889139842401250.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162379908663.2993820.16543025953842049041.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162379908663.2993820.16543025953842049041.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

CXL is a hotplug bus and arranges for nvdimm devices to be dynamically
discovered and removed. The libnvdimm core manages shutdown of nvdimm
security operations when the device is unregistered. That functionality
is moved to nvdimm_delete() and invoked by the CXL-to-nvdimm glue code.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/162336397425.2462439.17244700627659096367.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c       |   19 ++++---------------
 drivers/nvdimm/dimm_devs.c |   18 ++++++++++++++++++
 include/linux/libnvdimm.h  |    1 +
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 3a777d0073b7..a11821df83b5 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -396,21 +396,10 @@ static int child_unregister(struct device *dev, void *data)
 	if (dev->class)
 		return 0;
 
-	if (is_nvdimm(dev)) {
-		struct nvdimm *nvdimm = to_nvdimm(dev);
-		bool dev_put = false;
-
-		/* We are shutting down. Make state frozen artificially. */
-		nvdimm_bus_lock(dev);
-		set_bit(NVDIMM_SECURITY_FROZEN, &nvdimm->sec.flags);
-		if (test_and_clear_bit(NDD_WORK_PENDING, &nvdimm->flags))
-			dev_put = true;
-		nvdimm_bus_unlock(dev);
-		cancel_delayed_work_sync(&nvdimm->dwork);
-		if (dev_put)
-			put_device(dev);
-	}
-	nd_device_unregister(dev, ND_SYNC);
+	if (is_nvdimm(dev))
+		nvdimm_delete(to_nvdimm(dev));
+	else
+		nd_device_unregister(dev, ND_SYNC);
 
 	return 0;
 }
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 9d208570d059..dc7449a40003 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -642,6 +642,24 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 }
 EXPORT_SYMBOL_GPL(__nvdimm_create);
 
+void nvdimm_delete(struct nvdimm *nvdimm)
+{
+	struct device *dev = &nvdimm->dev;
+	bool dev_put = false;
+
+	/* We are shutting down. Make state frozen artificially. */
+	nvdimm_bus_lock(dev);
+	set_bit(NVDIMM_SECURITY_FROZEN, &nvdimm->sec.flags);
+	if (test_and_clear_bit(NDD_WORK_PENDING, &nvdimm->flags))
+		dev_put = true;
+	nvdimm_bus_unlock(dev);
+	cancel_delayed_work_sync(&nvdimm->dwork);
+	if (dev_put)
+		put_device(dev);
+	nd_device_unregister(dev, ND_SYNC);
+}
+EXPORT_SYMBOL_GPL(nvdimm_delete);
+
 static void shutdown_security_notify(void *data)
 {
 	struct nvdimm *nvdimm = data;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 89b69e645ac7..7074aa9af525 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -278,6 +278,7 @@ static inline struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 	return __nvdimm_create(nvdimm_bus, provider_data, groups, flags,
 			cmd_mask, num_flush, flush_wpq, NULL, NULL, NULL);
 }
+void nvdimm_delete(struct nvdimm *nvdimm);
 
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);

