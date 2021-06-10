Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE306D10
	for <nvdimm@lists.linux.dev>; Thu, 10 Jun 2021 22:26:16 +0000 (UTC)
IronPort-SDR: NXV5Y9x2AEjUBB70zflla6+PcXsV2XxpUZZT/Prcrdm3MxrOymAKnoIX9MSTi8TKh8JjCMG6cX
 pF0nQLpkSUUg==
X-IronPort-AV: E=McAfee;i="6200,9189,10011"; a="192528682"
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="192528682"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 15:26:14 -0700
IronPort-SDR: YU84HpYpCs1XEnh91CIuloVvU4S+J5aIQIXPoHcnjJYJ92CFytP1DshsGXgqCSyxTh+75+KfYf
 AZdx+5NLouXw==
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="402828411"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 15:26:14 -0700
Subject: [PATCH 3/5] libnvdimm: Export nvdimm shutdown helper,
 nvdimm_delete()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, ben.widawsky@intel.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com, linux-kernel@vger.kernel.org
Date: Thu, 10 Jun 2021 15:26:14 -0700
Message-ID: <162336397425.2462439.17244700627659096367.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com>
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

