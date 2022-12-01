Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8FD10782
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 21:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669930425; x=1701466425;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BqH45mypQtF0LG+gkAuLq67kmBCx6TYNU3kQpg3SGAM=;
  b=lHIzO+n90/PDBFvtp5ALe0fJZuXvp8Qz/v+8v5XtVU8Y1RTxyuYzN3tV
   Bl80TU+raJLI+jZKPSXkTVD4RZ2DoshxXUk0Ts+MexPL2M4Dskfsa+2bs
   yGDpfByj4DwwbAftcVLSd+CF9a6lBJwwHtxnwT42ExD2n1jZOtp5MogrW
   oFAh5Uh5HYCQepNwXwqQCH/sdlCnFhGfZnrFedqy/ayEq1HjbtBSfhexU
   AD1SOUYIxaPoGK/E6zmZVohVmTe3miqKEuwSN/7MxFTUOjg5qokrDT6Wc
   4n7XJQDn/Bj3CtrgJiguI5QnDLTqIO0LoJ/1q3p953TV05FspTWyKk2eo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="313443178"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="313443178"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:33:44 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="675594759"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="675594759"
Received: from navarrof-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.177.235])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:33:43 -0800
Subject: [PATCH v6 04/12] cxl/pmem: Remove the cxl_pmem_wq and related
 infrastructure
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Robert Richter <rrichter@amd.com>, alison.schofield@intel.com,
 rrichter@amd.com, terry.bowman@amd.com, bhelgaas@google.com,
 dave.jiang@intel.com, nvdimm@lists.linux.dev
Date: Thu, 01 Dec 2022 13:33:43 -0800
Message-ID: <166993042335.1882361.17022872468068436287.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Now that cxl_nvdimm and cxl_pmem_region objects are torn down
sychronously with the removal of either the bridge, or an endpoint, the
cxl_pmem_wq infrastructure can be jettisoned.

Tested-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/pmem.c |   22 -------
 drivers/cxl/cxl.h       |   17 ------
 drivers/cxl/pmem.c      |  143 -----------------------------------------------
 3 files changed, 1 insertion(+), 181 deletions(-)

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index 4d36805079ad..16446473d814 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -99,7 +99,6 @@ static struct cxl_nvdimm_bridge *cxl_nvdimm_bridge_alloc(struct cxl_port *port)
 
 	dev = &cxl_nvb->dev;
 	cxl_nvb->port = port;
-	cxl_nvb->state = CXL_NVB_NEW;
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &cxl_nvdimm_bridge_key);
 	device_set_pm_not_required(dev);
@@ -117,28 +116,7 @@ static struct cxl_nvdimm_bridge *cxl_nvdimm_bridge_alloc(struct cxl_port *port)
 static void unregister_nvb(void *_cxl_nvb)
 {
 	struct cxl_nvdimm_bridge *cxl_nvb = _cxl_nvb;
-	bool flush;
 
-	/*
-	 * If the bridge was ever activated then there might be in-flight state
-	 * work to flush. Once the state has been changed to 'dead' then no new
-	 * work can be queued by user-triggered bind.
-	 */
-	device_lock(&cxl_nvb->dev);
-	flush = cxl_nvb->state != CXL_NVB_NEW;
-	cxl_nvb->state = CXL_NVB_DEAD;
-	device_unlock(&cxl_nvb->dev);
-
-	/*
-	 * Even though the device core will trigger device_release_driver()
-	 * before the unregister, it does not know about the fact that
-	 * cxl_nvdimm_bridge_driver defers ->remove() work. So, do the driver
-	 * release not and flush it before tearing down the nvdimm device
-	 * hierarchy.
-	 */
-	device_release_driver(&cxl_nvb->dev);
-	if (flush)
-		flush_work(&cxl_nvb->state_work);
 	device_unregister(&cxl_nvb->dev);
 }
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index fc6083b0e467..f0ca2d768385 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -400,34 +400,17 @@ struct cxl_region {
 	struct cxl_region_params params;
 };
 
-/**
- * enum cxl_nvdimm_brige_state - state machine for managing bus rescans
- * @CXL_NVB_NEW: Set at bridge create and after cxl_pmem_wq is destroyed
- * @CXL_NVB_DEAD: Set at brige unregistration to preclude async probing
- * @CXL_NVB_ONLINE: Target state after successful ->probe()
- * @CXL_NVB_OFFLINE: Target state after ->remove() or failed ->probe()
- */
-enum cxl_nvdimm_brige_state {
-	CXL_NVB_NEW,
-	CXL_NVB_DEAD,
-	CXL_NVB_ONLINE,
-	CXL_NVB_OFFLINE,
-};
-
 struct cxl_nvdimm_bridge {
 	int id;
 	struct device dev;
 	struct cxl_port *port;
 	struct nvdimm_bus *nvdimm_bus;
 	struct nvdimm_bus_descriptor nd_desc;
-	struct work_struct state_work;
-	enum cxl_nvdimm_brige_state state;
 };
 
 struct cxl_nvdimm {
 	struct device dev;
 	struct cxl_memdev *cxlmd;
-	struct cxl_nvdimm_bridge *bridge;
 };
 
 struct cxl_pmem_region_mapping {
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 76cf54eeb310..0910367a3ead 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -11,13 +11,6 @@
 #include "cxlmem.h"
 #include "cxl.h"
 
-/*
- * Ordered workqueue for cxl nvdimm device arrival and departure
- * to coordinate bus rescans when a bridge arrives and trigger remove
- * operations when the bridge is removed.
- */
-static struct workqueue_struct *cxl_pmem_wq;
-
 static __read_mostly DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
 
 static void clear_exclusive(void *cxlds)
@@ -191,105 +184,6 @@ static void unregister_nvdimm_bus(void *_cxl_nvb)
 	nvdimm_bus_unregister(nvdimm_bus);
 }
 
-static bool online_nvdimm_bus(struct cxl_nvdimm_bridge *cxl_nvb)
-{
-	if (cxl_nvb->nvdimm_bus)
-		return true;
-	cxl_nvb->nvdimm_bus =
-		nvdimm_bus_register(&cxl_nvb->dev, &cxl_nvb->nd_desc);
-	return cxl_nvb->nvdimm_bus != NULL;
-}
-
-static int cxl_nvdimm_release_driver(struct device *dev, void *cxl_nvb)
-{
-	struct cxl_nvdimm *cxl_nvd;
-
-	if (!is_cxl_nvdimm(dev))
-		return 0;
-
-	cxl_nvd = to_cxl_nvdimm(dev);
-	if (cxl_nvd->bridge != cxl_nvb)
-		return 0;
-
-	device_release_driver(dev);
-	return 0;
-}
-
-static void offline_nvdimm_bus(struct cxl_nvdimm_bridge *cxl_nvb,
-			       struct nvdimm_bus *nvdimm_bus)
-{
-	if (!nvdimm_bus)
-		return;
-
-	/*
-	 * Set the state of cxl_nvdimm devices to unbound / idle before
-	 * nvdimm_bus_unregister() rips the nvdimm objects out from
-	 * underneath them.
-	 */
-	bus_for_each_dev(&cxl_bus_type, NULL, cxl_nvb,
-			 cxl_nvdimm_release_driver);
-	nvdimm_bus_unregister(nvdimm_bus);
-}
-
-static void cxl_nvb_update_state(struct work_struct *work)
-{
-	struct cxl_nvdimm_bridge *cxl_nvb =
-		container_of(work, typeof(*cxl_nvb), state_work);
-	struct nvdimm_bus *victim_bus = NULL;
-	bool release = false, rescan = false;
-
-	device_lock(&cxl_nvb->dev);
-	switch (cxl_nvb->state) {
-	case CXL_NVB_ONLINE:
-		if (!online_nvdimm_bus(cxl_nvb)) {
-			dev_err(&cxl_nvb->dev,
-				"failed to establish nvdimm bus\n");
-			release = true;
-		} else
-			rescan = true;
-		break;
-	case CXL_NVB_OFFLINE:
-	case CXL_NVB_DEAD:
-		victim_bus = cxl_nvb->nvdimm_bus;
-		cxl_nvb->nvdimm_bus = NULL;
-		break;
-	default:
-		break;
-	}
-	device_unlock(&cxl_nvb->dev);
-
-	if (release)
-		device_release_driver(&cxl_nvb->dev);
-	if (rescan) {
-		int rc = bus_rescan_devices(&cxl_bus_type);
-
-		dev_dbg(&cxl_nvb->dev, "rescan: %d\n", rc);
-	}
-	offline_nvdimm_bus(cxl_nvb, victim_bus);
-
-	put_device(&cxl_nvb->dev);
-}
-
-static void cxl_nvdimm_bridge_state_work(struct cxl_nvdimm_bridge *cxl_nvb)
-{
-	/*
-	 * Take a reference that the workqueue will drop if new work
-	 * gets queued.
-	 */
-	get_device(&cxl_nvb->dev);
-	if (!queue_work(cxl_pmem_wq, &cxl_nvb->state_work))
-		put_device(&cxl_nvb->dev);
-}
-
-static void cxl_nvdimm_bridge_remove(struct device *dev)
-{
-	struct cxl_nvdimm_bridge *cxl_nvb = to_cxl_nvdimm_bridge(dev);
-
-	if (cxl_nvb->state == CXL_NVB_ONLINE)
-		cxl_nvb->state = CXL_NVB_OFFLINE;
-	cxl_nvdimm_bridge_state_work(cxl_nvb);
-}
-
 static int cxl_nvdimm_bridge_probe(struct device *dev)
 {
 	struct cxl_nvdimm_bridge *cxl_nvb = to_cxl_nvdimm_bridge(dev);
@@ -306,15 +200,12 @@ static int cxl_nvdimm_bridge_probe(struct device *dev)
 	if (!cxl_nvb->nvdimm_bus)
 		return -ENOMEM;
 
-	INIT_WORK(&cxl_nvb->state_work, cxl_nvb_update_state);
-
 	return devm_add_action_or_reset(dev, unregister_nvdimm_bus, cxl_nvb);
 }
 
 static struct cxl_driver cxl_nvdimm_bridge_driver = {
 	.name = "cxl_nvdimm_bridge",
 	.probe = cxl_nvdimm_bridge_probe,
-	.remove = cxl_nvdimm_bridge_remove,
 	.id = CXL_DEVICE_NVDIMM_BRIDGE,
 	.drv = {
 		.suppress_bind_attrs = true,
@@ -453,31 +344,6 @@ static struct cxl_driver cxl_pmem_region_driver = {
 	},
 };
 
-/*
- * Return all bridges to the CXL_NVB_NEW state to invalidate any
- * ->state_work referring to the now destroyed cxl_pmem_wq.
- */
-static int cxl_nvdimm_bridge_reset(struct device *dev, void *data)
-{
-	struct cxl_nvdimm_bridge *cxl_nvb;
-
-	if (!is_cxl_nvdimm_bridge(dev))
-		return 0;
-
-	cxl_nvb = to_cxl_nvdimm_bridge(dev);
-	device_lock(dev);
-	cxl_nvb->state = CXL_NVB_NEW;
-	device_unlock(dev);
-
-	return 0;
-}
-
-static void destroy_cxl_pmem_wq(void)
-{
-	destroy_workqueue(cxl_pmem_wq);
-	bus_for_each_dev(&cxl_bus_type, NULL, NULL, cxl_nvdimm_bridge_reset);
-}
-
 static __init int cxl_pmem_init(void)
 {
 	int rc;
@@ -485,13 +351,9 @@ static __init int cxl_pmem_init(void)
 	set_bit(CXL_MEM_COMMAND_ID_SET_SHUTDOWN_STATE, exclusive_cmds);
 	set_bit(CXL_MEM_COMMAND_ID_SET_LSA, exclusive_cmds);
 
-	cxl_pmem_wq = alloc_ordered_workqueue("cxl_pmem", 0);
-	if (!cxl_pmem_wq)
-		return -ENXIO;
-
 	rc = cxl_driver_register(&cxl_nvdimm_bridge_driver);
 	if (rc)
-		goto err_bridge;
+		return rc;
 
 	rc = cxl_driver_register(&cxl_nvdimm_driver);
 	if (rc)
@@ -507,8 +369,6 @@ static __init int cxl_pmem_init(void)
 	cxl_driver_unregister(&cxl_nvdimm_driver);
 err_nvdimm:
 	cxl_driver_unregister(&cxl_nvdimm_bridge_driver);
-err_bridge:
-	destroy_cxl_pmem_wq();
 	return rc;
 }
 
@@ -517,7 +377,6 @@ static __exit void cxl_pmem_exit(void)
 	cxl_driver_unregister(&cxl_pmem_region_driver);
 	cxl_driver_unregister(&cxl_nvdimm_driver);
 	cxl_driver_unregister(&cxl_nvdimm_bridge_driver);
-	destroy_cxl_pmem_wq();
 }
 
 MODULE_LICENSE("GPL v2");

