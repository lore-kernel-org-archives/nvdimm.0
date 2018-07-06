Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E1D0F203369E6
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 11:30:11 -0700 (PDT)
Subject: [PATCH] acpi, nfit: Fix scrub idle detection
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 Jul 2018 11:20:13 -0700
Message-ID: <153090121374.28055.14156217568809004334.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The notification of scrub completion happens within the scrub workqueue.
That can clearly race someone running scrub_show() and work_busy()
before the workqueue has a chance to flush the recently completed work.
Add a flag to reliably indicate the idle vs busy state. Without this
change applications using poll(2) to wait for scrub-completion may
falsely wakeup and read ARS as being busy even though the thread is
going idle and then hang indefinitely.

Fixes: bc6ba8085842 ("nfit, address-range-scrub: rework and simplify ARS...")
Cc: <stable@vger.kernel.org>
Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Lukasz Dorau <lukasz.dorau@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   37 ++++++++++++++++++++++++++-----------
 drivers/acpi/nfit/nfit.h |    1 +
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 471402cee1f1..cd26484d1cee 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1275,7 +1275,7 @@ static ssize_t scrub_show(struct device *dev,
 
 		mutex_lock(&acpi_desc->init_mutex);
 		rc = sprintf(buf, "%d%s", acpi_desc->scrub_count,
-				work_busy(&acpi_desc->dwork.work)
+				acpi_desc->scrub_busy
 				&& !acpi_desc->cancel ? "+\n" : "\n");
 		mutex_unlock(&acpi_desc->init_mutex);
 	}
@@ -2941,6 +2941,25 @@ static unsigned int __acpi_nfit_scrub(struct acpi_nfit_desc *acpi_desc,
 	return 0;
 }
 
+static void sched_ars(struct acpi_nfit_desc *acpi_desc, unsigned int tmo)
+{
+	lockdep_assert_held(&acpi_desc->init_mutex);
+
+	acpi_desc->scrub_busy = 1;
+	acpi_desc->scrub_tmo = tmo;
+	queue_delayed_work(nfit_wq, &acpi_desc->dwork, tmo * HZ);
+}
+
+static void notify_ars_done(struct acpi_nfit_desc *acpi_desc)
+{
+	lockdep_assert_held(&acpi_desc->init_mutex);
+
+	acpi_desc->scrub_busy = 0;
+	acpi_desc->scrub_count++;
+	if (acpi_desc->scrub_count_state)
+		sysfs_notify_dirent(acpi_desc->scrub_count_state);
+}
+
 static void acpi_nfit_scrub(struct work_struct *work)
 {
 	struct acpi_nfit_desc *acpi_desc;
@@ -2951,14 +2970,10 @@ static void acpi_nfit_scrub(struct work_struct *work)
 	mutex_lock(&acpi_desc->init_mutex);
 	query_rc = acpi_nfit_query_poison(acpi_desc);
 	tmo = __acpi_nfit_scrub(acpi_desc, query_rc);
-	if (tmo) {
-		queue_delayed_work(nfit_wq, &acpi_desc->dwork, tmo * HZ);
-		acpi_desc->scrub_tmo = tmo;
-	} else {
-		acpi_desc->scrub_count++;
-		if (acpi_desc->scrub_count_state)
-			sysfs_notify_dirent(acpi_desc->scrub_count_state);
-	}
+	if (tmo)
+		sched_ars(acpi_desc, tmo);
+	else
+		notify_ars_done(acpi_desc);
 	memset(acpi_desc->ars_status, 0, acpi_desc->max_ars);
 	mutex_unlock(&acpi_desc->init_mutex);
 }
@@ -3039,7 +3054,7 @@ static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
 			break;
 		}
 
-	queue_delayed_work(nfit_wq, &acpi_desc->dwork, 0);
+	sched_ars(acpi_desc, 0);
 	return 0;
 }
 
@@ -3241,7 +3256,7 @@ int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc, unsigned long flags)
 		}
 	}
 	if (scheduled) {
-		queue_delayed_work(nfit_wq, &acpi_desc->dwork, 0);
+		sched_ars(acpi_desc, 0);
 		dev_dbg(dev, "ars_scan triggered\n");
 	}
 	mutex_unlock(&acpi_desc->init_mutex);
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 7d15856a739f..a97ff42fe311 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -203,6 +203,7 @@ struct acpi_nfit_desc {
 	unsigned int max_ars;
 	unsigned int scrub_count;
 	unsigned int scrub_mode;
+	unsigned int scrub_busy:1;
 	unsigned int cancel:1;
 	unsigned long dimm_cmd_force_en;
 	unsigned long bus_cmd_force_en;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
