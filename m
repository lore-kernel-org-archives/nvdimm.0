Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7CACF21E08197
 for <linux-nvdimm@lists.01.org>; Fri, 30 Mar 2018 17:52:53 -0700 (PDT)
Subject: [PATCH 1/2] acpi/libnvdimm: rework ARS query and removing blocking
 on timeout at init
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 30 Mar 2018 17:52:52 -0700
Message-ID: <152245757217.54599.588915759449280143.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On initialization we are going to set bit 1 of Start ARS DSM flag. This
allows us to retrieve the data from the previous scrub without starting a
scrub. This is to obtain any badblocks on all the DIMMs that does not have
scrubbing started by the BIOS. Previously we block surfacing the regions
until ARS is completed on all regions. That has been removed and we will
now do scrubbing in the background with a delayed workqueue. The delayed
workqueue will be scheduled starting at 1 second delay and doubled every
time it has to be rescheduled up to 30 minutes delay. The reschedule will
no longer be timing out.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/core.c |  263 ++++++++++++++++++++++------------------------
 drivers/acpi/nfit/nfit.h |   14 ++
 2 files changed, 135 insertions(+), 142 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 33c13324e265..32670b82fbfc 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -35,10 +35,6 @@ static bool force_enable_dimms;
 module_param(force_enable_dimms, bool, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(force_enable_dimms, "Ignore _STA (ACPI DIMM device) status");
 
-static unsigned int scrub_timeout = NFIT_ARS_TIMEOUT;
-module_param(scrub_timeout, uint, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(scrub_timeout, "Initial scrub timeout in seconds");
-
 /* after three payloads of overflow, it's dead jim */
 static unsigned int scrub_overflow_abort = 3;
 module_param(scrub_overflow_abort, uint, S_IRUGO|S_IWUSR);
@@ -1250,7 +1246,8 @@ static ssize_t scrub_show(struct device *dev,
 		struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 
 		rc = sprintf(buf, "%d%s", acpi_desc->scrub_count,
-				(work_busy(&acpi_desc->work)) ? "+\n" : "\n");
+				(work_busy(&acpi_desc->dwork.work)) ?
+				"+\n" : "\n");
 	}
 	device_unlock(dev);
 	return rc;
@@ -2799,86 +2796,6 @@ static int acpi_nfit_query_poison(struct acpi_nfit_desc *acpi_desc,
 	return 0;
 }
 
-static void acpi_nfit_async_scrub(struct acpi_nfit_desc *acpi_desc,
-		struct nfit_spa *nfit_spa)
-{
-	struct acpi_nfit_system_address *spa = nfit_spa->spa;
-	unsigned int overflow_retry = scrub_overflow_abort;
-	u64 init_ars_start = 0, init_ars_len = 0;
-	struct device *dev = acpi_desc->dev;
-	unsigned int tmo = scrub_timeout;
-	int rc;
-
-	if (!nfit_spa->ars_required || !nfit_spa->nd_region)
-		return;
-
-	rc = ars_start(acpi_desc, nfit_spa);
-	/*
-	 * If we timed out the initial scan we'll still be busy here,
-	 * and will wait another timeout before giving up permanently.
-	 */
-	if (rc < 0 && rc != -EBUSY)
-		return;
-
-	do {
-		u64 ars_start, ars_len;
-
-		if (acpi_desc->cancel)
-			break;
-		rc = acpi_nfit_query_poison(acpi_desc, nfit_spa);
-		if (rc == -ENOTTY)
-			break;
-		if (rc == -EBUSY && !tmo) {
-			dev_warn(dev, "range %d ars timeout, aborting\n",
-					spa->range_index);
-			break;
-		}
-
-		if (rc == -EBUSY) {
-			/*
-			 * Note, entries may be appended to the list
-			 * while the lock is dropped, but the workqueue
-			 * being active prevents entries being deleted /
-			 * freed.
-			 */
-			mutex_unlock(&acpi_desc->init_mutex);
-			ssleep(1);
-			tmo--;
-			mutex_lock(&acpi_desc->init_mutex);
-			continue;
-		}
-
-		/* we got some results, but there are more pending... */
-		if (rc == -ENOSPC && overflow_retry--) {
-			if (!init_ars_len) {
-				init_ars_len = acpi_desc->ars_status->length;
-				init_ars_start = acpi_desc->ars_status->address;
-			}
-			rc = ars_continue(acpi_desc);
-		}
-
-		if (rc < 0) {
-			dev_warn(dev, "range %d ars continuation failed\n",
-					spa->range_index);
-			break;
-		}
-
-		if (init_ars_len) {
-			ars_start = init_ars_start;
-			ars_len = init_ars_len;
-		} else {
-			ars_start = acpi_desc->ars_status->address;
-			ars_len = acpi_desc->ars_status->length;
-		}
-		dev_dbg(dev, "spa range: %d ars from %#llx + %#llx complete\n",
-				spa->range_index, ars_start, ars_len);
-		/* notify the region about new poison entries */
-		nvdimm_region_notify(nfit_spa->nd_region,
-				NVDIMM_REVALIDATE_POISON);
-		break;
-	} while (1);
-}
-
 static void acpi_nfit_scrub(struct work_struct *work)
 {
 	struct device *dev;
@@ -2887,37 +2804,57 @@ static void acpi_nfit_scrub(struct work_struct *work)
 	u64 init_scrub_address = 0;
 	bool init_ars_done = false;
 	struct acpi_nfit_desc *acpi_desc;
-	unsigned int tmo = scrub_timeout;
 	unsigned int overflow_retry = scrub_overflow_abort;
+	int ars_needed = 0;
 
-	acpi_desc = container_of(work, typeof(*acpi_desc), work);
+	acpi_desc = container_of(work, typeof(*acpi_desc), dwork.work);
 	dev = acpi_desc->dev;
 
-	/*
-	 * We scrub in 2 phases.  The first phase waits for any platform
-	 * firmware initiated scrubs to complete and then we go search for the
-	 * affected spa regions to mark them scanned.  In the second phase we
-	 * initiate a directed scrub for every range that was not scrubbed in
-	 * phase 1. If we're called for a 'rescan', we harmlessly pass through
-	 * the first phase, but really only care about running phase 2, where
-	 * regions can be notified of new poison.
-	 */
-
-	/* process platform firmware initiated scrubs */
  retry:
 	mutex_lock(&acpi_desc->init_mutex);
 	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
 		struct nd_cmd_ars_status *ars_status;
-		struct acpi_nfit_system_address *spa;
-		u64 ars_start, ars_len;
+		struct acpi_nfit_system_address *spa = nfit_spa->spa;
+		u64 ars_start_addr, ars_len;
 		int rc;
 
 		if (acpi_desc->cancel)
-			break;
+			goto out;
 
-		if (nfit_spa->nd_region)
+		if (nfit_spa->ars_state == NFIT_ARS_STATE_COMPLETE ||
+			nfit_spa->ars_state == NFIT_ARS_STATE_UNSUPPORTED ||
+			nfit_spa->ars_state == NFIT_ARS_STATE_FAILED)
 			continue;
 
+		if (nfit_spa->ars_state == NFIT_ARS_STATE_REQUESTED) {
+			dev_dbg(dev, "Range %d starting ARS\n",
+					spa->range_index);
+			rc = ars_start(acpi_desc, nfit_spa);
+			if (rc == -EBUSY) {
+				queue_delayed_work(nfit_wq, &acpi_desc->dwork,
+						acpi_desc->scrub_timeout * HZ);
+				/*
+				 * Increase timeout for next time around.
+				 * We'll max it at 30mins.
+				 */
+				dev_dbg(dev, "Range %d ARS start busy. reschedule in %u seconds\n",
+						spa->range_index,
+						acpi_desc->scrub_timeout);
+				acpi_desc->scrub_timeout =
+					min_t(unsigned int,
+						acpi_desc->scrub_timeout * 2,
+						1800);
+				goto out;
+			}
+			if (rc < 0) {
+				dev_dbg(dev, "Range %d ARS start failed.\n",
+						spa->range_index);
+				nfit_spa->ars_state = NFIT_ARS_STATE_FAILED;
+				continue;
+			}
+			nfit_spa->ars_state = NFIT_ARS_STATE_IN_PROGRESS;
+		}
+
 		if (init_ars_done) {
 			/*
 			 * No need to re-query, we're now just
@@ -2930,23 +2867,30 @@ static void acpi_nfit_scrub(struct work_struct *work)
 
 		if (rc == -ENOTTY) {
 			/* no ars capability, just register spa and move on */
+			nfit_spa->ars_state = NFIT_ARS_STATE_UNSUPPORTED;
 			acpi_nfit_register_region(acpi_desc, nfit_spa);
 			continue;
 		}
 
-		if (rc == -EBUSY && !tmo) {
-			/* fallthrough to directed scrub in phase 2 */
-			dev_warn(dev, "timeout awaiting ars results, continuing...\n");
-			break;
-		} else if (rc == -EBUSY) {
-			mutex_unlock(&acpi_desc->init_mutex);
-			ssleep(1);
-			tmo--;
-			goto retry;
+		if (rc == -EBUSY) {
+			nfit_spa->ars_state = NFIT_ARS_STATE_IN_PROGRESS;
+			queue_delayed_work(nfit_wq, &acpi_desc->dwork,
+					acpi_desc->scrub_timeout * HZ);
+			/*
+			 * Increase timeout for next time around. We'll max
+			 * it at 30mins
+			 */
+			dev_dbg(dev, "Range %d ARS query busy. reschedule in %u seconds\n",
+					spa->range_index,
+					acpi_desc->scrub_timeout);
+			acpi_desc->scrub_timeout = min_t(unsigned int,
+					acpi_desc->scrub_timeout * 2, 1800);
+			goto out;
 		}
 
 		/* we got some results, but there are more pending... */
 		if (rc == -ENOSPC && overflow_retry--) {
+			nfit_spa->ars_state = NFIT_ARS_STATE_IN_PROGRESS;
 			ars_status = acpi_desc->ars_status;
 			/*
 			 * Record the original scrub range, so that we
@@ -2965,57 +2909,86 @@ static void acpi_nfit_scrub(struct work_struct *work)
 		}
 
 		if (rc < 0) {
-			/*
-			 * Initial scrub failed, we'll give it one more
-			 * try below...
-			 */
-			break;
+			nfit_spa->ars_state = NFIT_ARS_STATE_FAILED;
+			dev_warn(dev, "Range %d ars continuation failed\n",
+					spa->range_index);
+			continue;
 		}
 
 		/* We got some final results, record completed ranges */
 		ars_status = acpi_desc->ars_status;
 		if (init_scrub_length) {
-			ars_start = init_scrub_address;
-			ars_len = ars_start + init_scrub_length;
+			ars_start_addr = init_scrub_address;
+			ars_len = ars_start_addr + init_scrub_length;
 		} else {
-			ars_start = ars_status->address;
+			ars_start_addr = ars_status->address;
 			ars_len = ars_status->length;
 		}
-		spa = nfit_spa->spa;
 
 		if (!init_ars_done) {
 			init_ars_done = true;
-			dev_dbg(dev, "init scrub %#llx + %#llx complete\n",
-					ars_start, ars_len);
+			dev_dbg(dev, "Scrub %#llx + %#llx complete\n",
+					ars_start_addr, ars_len);
 		}
-		if (ars_start <= spa->address && ars_start + ars_len
-				>= spa->address + spa->length)
+
+		if (ars_start_addr <= spa->address && ars_start_addr + ars_len
+				>= spa->address + spa->length &&
+				!nfit_spa->nd_region) {
 			acpi_nfit_register_region(acpi_desc, nfit_spa);
+			dev_dbg(dev, "Range %d register region\n",
+				nfit_spa->spa->range_index);
+		}
+
+		dev_dbg(dev, "Range %d ARS done\n", spa->range_index);
+		nfit_spa->ars_state = NFIT_ARS_STATE_COMPLETE;
+		acpi_desc->scrub_timeout = 1;
+		if (nfit_spa->nd_region)
+			nvdimm_region_notify(nfit_spa->nd_region,
+					NVDIMM_REVALIDATE_POISON);
 	}
 
 	/*
 	 * For all the ranges not covered by an initial scrub we still
-	 * want to see if there are errors, but it's ok to discover them
-	 * asynchronously.
+	 * want to see if there are errors
 	 */
 	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
+		if (nfit_spa->nd_region)
+			continue;
+
 		/*
-		 * Flag all the ranges that still need scrubbing, but
-		 * register them now to make data available.
+		 * If we are going through here first time and region
+		 * is not registered, we know BIOS has not scrubbed
+		 * the range and we need to request scrubbing. Otherwise
+		 * we'll just go ahead and register the region.
 		 */
-		if (!nfit_spa->nd_region) {
-			nfit_spa->ars_required = 1;
+		if (!acpi_desc->init_complete) {
+			dev_dbg(dev, "Range %d requested for ARS\n",
+				nfit_spa->spa->range_index);
+			nfit_spa->ars_state = NFIT_ARS_STATE_REQUESTED;
+			ars_needed++;
+		} else {
 			acpi_nfit_register_region(acpi_desc, nfit_spa);
+			dev_dbg(dev, "Range %d register region\n",
+				nfit_spa->spa->range_index);
 		}
 	}
-	acpi_desc->init_complete = 1;
 
 	list_for_each_entry(nfit_spa, &acpi_desc->spas, list)
-		acpi_nfit_async_scrub(acpi_desc, nfit_spa);
+		dev_dbg(dev, "Range %d ars state: %d\n",
+				nfit_spa->spa->range_index,
+				nfit_spa->ars_state);
+	acpi_desc->init_complete = 1;
+	if (ars_needed) {
+		queue_delayed_work(nfit_wq, &acpi_desc->dwork, 0);
+		goto out;
+	} else
+		acpi_desc->ars_start_flags = 0;
+
 	acpi_desc->scrub_count++;
-	acpi_desc->ars_start_flags = 0;
 	if (acpi_desc->scrub_count_state)
 		sysfs_notify_dirent(acpi_desc->scrub_count_state);
+
+out:
 	mutex_unlock(&acpi_desc->init_mutex);
 }
 
@@ -3032,9 +3005,13 @@ static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
 				return rc;
 		}
 
-	acpi_desc->ars_start_flags = 0;
+	/*
+	 * At initialization, we are going to grab all the known errors
+	 * instead of starting ARS.
+	 */
+	acpi_desc->ars_start_flags = ND_ARS_RETURN_PREV_DATA;
 	if (!acpi_desc->cancel)
-		queue_work(nfit_wq, &acpi_desc->work);
+		queue_delayed_work(nfit_wq, &acpi_desc->dwork, 0);
 	return 0;
 }
 
@@ -3230,7 +3207,7 @@ static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
 	 * just needs guarantees that any ars it initiates are not
 	 * interrupted by any intervening start reqeusts from userspace.
 	 */
-	if (work_busy(&acpi_desc->work))
+	if (work_busy(&acpi_desc->dwork.work))
 		return -EBUSY;
 
 	return 0;
@@ -3241,7 +3218,7 @@ int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc, u8 flags)
 	struct device *dev = acpi_desc->dev;
 	struct nfit_spa *nfit_spa;
 
-	if (work_busy(&acpi_desc->work))
+	if (work_busy(&acpi_desc->dwork.work))
 		return -EBUSY;
 
 	mutex_lock(&acpi_desc->init_mutex);
@@ -3256,10 +3233,14 @@ int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc, u8 flags)
 		if (nfit_spa_type(spa) != NFIT_SPA_PM)
 			continue;
 
-		nfit_spa->ars_required = 1;
+		if (nfit_spa->ars_state == NFIT_ARS_STATE_UNSUPPORTED ||
+			nfit_spa->ars_state == NFIT_ARS_STATE_FAILED)
+			continue;
+
+		nfit_spa->ars_state = NFIT_ARS_STATE_REQUESTED;
 	}
 	acpi_desc->ars_start_flags = flags;
-	queue_work(nfit_wq, &acpi_desc->work);
+	queue_delayed_work(nfit_wq, &acpi_desc->dwork, 0);
 	dev_dbg(dev, "ars_scan triggered\n");
 	mutex_unlock(&acpi_desc->init_mutex);
 
@@ -3290,7 +3271,8 @@ void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
 	INIT_LIST_HEAD(&acpi_desc->dimms);
 	INIT_LIST_HEAD(&acpi_desc->list);
 	mutex_init(&acpi_desc->init_mutex);
-	INIT_WORK(&acpi_desc->work, acpi_nfit_scrub);
+	acpi_desc->scrub_timeout = 1;
+	INIT_DELAYED_WORK(&acpi_desc->dwork, acpi_nfit_scrub);
 }
 EXPORT_SYMBOL_GPL(acpi_nfit_desc_init);
 
@@ -3314,6 +3296,7 @@ void acpi_nfit_shutdown(void *data)
 
 	mutex_lock(&acpi_desc->init_mutex);
 	acpi_desc->cancel = 1;
+	cancel_delayed_work_sync(&acpi_desc->dwork);
 	mutex_unlock(&acpi_desc->init_mutex);
 
 	/*
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index ac9c49463731..dde28f33a371 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -117,10 +117,19 @@ enum nfit_dimm_notifiers {
 	NFIT_NOTIFY_DIMM_HEALTH = 0x81,
 };
 
+enum nfit_ars_state {
+	NFIT_ARS_STATE_IDLE = 0,
+	NFIT_ARS_STATE_REQUESTED,
+	NFIT_ARS_STATE_IN_PROGRESS,
+	NFIT_ARS_STATE_COMPLETE,
+	NFIT_ARS_STATE_UNSUPPORTED,
+	NFIT_ARS_STATE_FAILED,
+};
+
 struct nfit_spa {
 	struct list_head list;
 	struct nd_region *nd_region;
-	unsigned int ars_required:1;
+	enum nfit_ars_state ars_state;
 	u32 clear_err_unit;
 	u32 max_ars;
 	struct acpi_nfit_system_address spa[0];
@@ -191,7 +200,7 @@ struct acpi_nfit_desc {
 	u8 ars_start_flags;
 	struct nd_cmd_ars_status *ars_status;
 	size_t ars_status_size;
-	struct work_struct work;
+	struct delayed_work dwork;
 	struct list_head list;
 	struct kernfs_node *scrub_count_state;
 	unsigned int scrub_count;
@@ -202,6 +211,7 @@ struct acpi_nfit_desc {
 	unsigned long bus_cmd_force_en;
 	unsigned long bus_nfit_cmd_force_en;
 	unsigned int platform_cap;
+	unsigned int scrub_timeout;
 	int (*blk_do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,
 			void *iobuf, u64 len, int rw);
 };

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
