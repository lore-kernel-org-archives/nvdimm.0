Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5D47020886FE1
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 12:23:10 -0800 (PST)
Subject: [PATCH 5/6] nfit/ars: Introduce scrub_flags
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Feb 2019 12:10:32 -0800
Message-ID: <155017503212.944049.11691323017650346177.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155017500427.944049.2254497897075714747.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155017500427.944049.2254497897075714747.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for introducing a new flag to gate whether ARS results
are stale, convert the existing flags to an unsigned long with
enumerated values. This conversion allows the flags to be atomically
updated outside of ->init_mutex.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   39 +++++++++++++++++++++------------------
 drivers/acpi/nfit/nfit.h |    8 ++++++--
 2 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 7086c193aa81..612cf5d92e25 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1317,25 +1317,28 @@ static ssize_t scrub_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nvdimm_bus_descriptor *nd_desc;
+	struct acpi_nfit_desc *acpi_desc;
 	ssize_t rc = -ENXIO;
+	bool busy;
 
 	device_lock(dev);
 	nd_desc = dev_get_drvdata(dev);
-	if (nd_desc) {
-		struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
+	if (!nd_desc) {
+		device_unlock(dev);
+		return rc;
+	}
+	acpi_desc = to_acpi_desc(nd_desc);
 
-		mutex_lock(&acpi_desc->init_mutex);
-		rc = sprintf(buf, "%d%s", acpi_desc->scrub_count,
-				acpi_desc->scrub_busy
-				&& !acpi_desc->cancel ? "+\n" : "\n");
-		/* Allow an admin to poll the busy state at a higher rate */
-		if (acpi_desc->scrub_busy && !acpi_desc->cancel
-				&& capable(CAP_SYS_RAWIO)) {
-			acpi_desc->scrub_tmo = 1;
-			queue_delayed_work(nfit_wq, &acpi_desc->dwork, HZ);
-		}
-		mutex_unlock(&acpi_desc->init_mutex);
+	mutex_lock(&acpi_desc->init_mutex);
+	busy = test_bit(ARS_BUSY, &acpi_desc->scrub_flags)
+		&& !test_bit(ARS_CANCEL, &acpi_desc->scrub_flags);
+	rc = sprintf(buf, "%d%s", acpi_desc->scrub_count, busy ? "+\n" : "\n");
+	/* Allow an admin to poll the busy state at a higher rate */
+	if (busy && capable(CAP_SYS_RAWIO)) {
+		acpi_desc->scrub_tmo = 1;
+		queue_delayed_work(nfit_wq, &acpi_desc->dwork, HZ);
 	}
+	mutex_unlock(&acpi_desc->init_mutex);
 	device_unlock(dev);
 	return rc;
 }
@@ -3078,7 +3081,7 @@ static unsigned int __acpi_nfit_scrub(struct acpi_nfit_desc *acpi_desc,
 
 	lockdep_assert_held(&acpi_desc->init_mutex);
 
-	if (acpi_desc->cancel)
+	if (test_bit(ARS_CANCEL, &acpi_desc->scrub_flags))
 		return 0;
 
 	if (query_rc == -EBUSY) {
@@ -3152,7 +3155,7 @@ static void __sched_ars(struct acpi_nfit_desc *acpi_desc, unsigned int tmo)
 {
 	lockdep_assert_held(&acpi_desc->init_mutex);
 
-	acpi_desc->scrub_busy = 1;
+	set_bit(ARS_BUSY, &acpi_desc->scrub_flags);
 	/* note this should only be set from within the workqueue */
 	if (tmo)
 		acpi_desc->scrub_tmo = tmo;
@@ -3168,7 +3171,7 @@ static void notify_ars_done(struct acpi_nfit_desc *acpi_desc)
 {
 	lockdep_assert_held(&acpi_desc->init_mutex);
 
-	acpi_desc->scrub_busy = 0;
+	clear_bit(ARS_BUSY, &acpi_desc->scrub_flags);
 	acpi_desc->scrub_count++;
 	if (acpi_desc->scrub_count_state)
 		sysfs_notify_dirent(acpi_desc->scrub_count_state);
@@ -3457,7 +3460,7 @@ int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc,
 	struct nfit_spa *nfit_spa;
 
 	mutex_lock(&acpi_desc->init_mutex);
-	if (acpi_desc->cancel) {
+	if (test_bit(ARS_CANCEL, &acpi_desc->scrub_flags)) {
 		mutex_unlock(&acpi_desc->init_mutex);
 		return 0;
 	}
@@ -3536,7 +3539,7 @@ void acpi_nfit_shutdown(void *data)
 	mutex_unlock(&acpi_desc_lock);
 
 	mutex_lock(&acpi_desc->init_mutex);
-	acpi_desc->cancel = 1;
+	set_bit(ARS_CANCEL, &acpi_desc->scrub_flags);
 	cancel_delayed_work_sync(&acpi_desc->dwork);
 	mutex_unlock(&acpi_desc->init_mutex);
 
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 871fb3de3b30..897ce10192a0 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -210,6 +210,11 @@ struct nfit_mem {
 	int family;
 };
 
+enum scrub_flags {
+	ARS_BUSY,
+	ARS_CANCEL,
+};
+
 struct acpi_nfit_desc {
 	struct nvdimm_bus_descriptor nd_desc;
 	struct acpi_table_header acpi_header;
@@ -231,8 +236,7 @@ struct acpi_nfit_desc {
 	unsigned int max_ars;
 	unsigned int scrub_count;
 	unsigned int scrub_mode;
-	unsigned int scrub_busy:1;
-	unsigned int cancel:1;
+	unsigned long scrub_flags;
 	unsigned long dimm_cmd_force_en;
 	unsigned long bus_cmd_force_en;
 	unsigned long bus_nfit_cmd_force_en;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
