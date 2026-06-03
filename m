Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E067C3557F3;
	Wed,  3 Jun 2026 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780509536; cv=none; b=HixAKj+6GLX4/sqpiBFuwGuVppQGSSKw3Ymum0nWTSaOLf208HCftqY151FBLVBShx4u5OAjs6vMvlE8Qmzf+WOomGo9Xu+1qlwgJyOQrJvw4lXlxuazHHes1oyUvhusVfqkhtXK+Pr1YILknt+xJFTqrr4hdbPmv619EtfbgB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780509536; c=relaxed/simple;
	bh=Zc8fXrb46LEoy8VwpRmWulRnHhMEcM0+RbdVfozF/rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ha/9BK3yBh1Jlin/1nOpxbunQM2BHtxV78/UWzPVPebP0k8T2WVSnIAHasYP1TckPxf7UmidvU7yuPP0sIN5phlE8OhpRuWkfwRCoqJsgPCgaKr4k7fenlGCZwCXt/dYQlyDr121y6SwWQf2Uxo3j2TGiHcw1wRYUDbFwqG4PAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LkbONOMe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LkbONOMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87CD1F00893;
	Wed,  3 Jun 2026 17:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780509534;
	bh=oiP2G/mtXOs9lAy77CtOPTk1mzyarWI2Su/UbBwV4qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LkbONOMerGGob3SND6C/mP2rsMxj+lQ7crJbQL0BGQTjzLkcU8fVkGcmooOAOaUzI
	 SwGT/b9WBDZSQSqCKQeXYX9F56FDmj5LsFMtOzXARMOHX7LiAom1qUiIDc0s7pSzGm
	 o25y80U19FDKG54LbAa/v0T0eZqavD1wgCKfoXVJw4Vij5Q+ufyKWIllcS+LOtkzDx
	 T5zrtLppsRwoT6PpWajY7+NPBvEPpc1E/AONRPdC6mGTQMAkM/Ozq2NSMoOVfw+SJF
	 pjPltsm9I5Gr3YwuoHFj2trzMi84UU1YA0w88jmbcASp5XZFElYC70JE7CTHNrf2KW
	 i6YYcRz3/JuCQ==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linux ACPI <linux-acpi@vger.kernel.org>
Cc: Dan Williams <djbw@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
 Xiang Chen <chenxiang66@hisilicon.com>
Subject:
 [PATCH v2 4/4] ACPI: NFIT: core: Fix possible deadlock and missing
 notifications
Date: Wed, 03 Jun 2026 19:58:23 +0200
Message-ID: <3420096.aeNJFYEL58@rafael.j.wysocki>
Organization: Linux Kernel Development
In-Reply-To: <5110904.31r3eYUQgx@rafael.j.wysocki>
References: <5110904.31r3eYUQgx@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

After commit 9b311b7313d6 ("ACPI: NFIT: Install Notify() handler before
getting NFIT table"), ACPI NFIT driver removal may deadlock if an ACPI
notify on the NFIT device is triggered concurrently.  A similar deadlock
may occur if an ACPI notify on the NFIT device is triggered during a
failing driver probe.

The deadlock is possible because acpi_dev_remove_notify_handler() calls
acpi_os_wait_events_complete() after removing the notify handler and the
driver core invokes it under the NFIT platform device lock which is also
acquired by acpi_nfit_notify().  Thus acpi_os_wait_events_complete() may
be waiting for acpi_nfit_notify() to complete, but the latter may not be
able to acquire the device lock which is being held by the driver core
while the former is being executed.

Moreover, after commit 03667e146f81 ("ACPI: NFIT: core: Convert the
driver to a platform one"), there are no sysfs notifications regarding
NVDIMM devices because __acpi_nvdimm_notify() always bails out after
checking the driver data pointer of the device's parent.  That parent
is the ACPI companion of the platform device used for driver binding,
so its driver data pointer is always NULL after the commit in question
which was overlooked by it.

A remedy for the deadlock is to use a special separate lock for ACPI
notify synchronization with driver probe and removal instead of the
device lock of the NFIT device, while a remedy for the second issue
is to populate the driver data pointer of the NFIT device's ACPI
companion when the driver is ready to operate, so do both these things.
However, since the new lock is not held across the entire teardown and
acpi_nfit_notify() should do nothing when teardown is in progress, make
it check the driver data pointer of the NFIT device's ACPI companion, in
analogy with the existing check in __acpi_nvdimm_notify(), and bail out
if that pointer is NULL.

Fixes: 9b311b7313d6 ("ACPI: NFIT: Install Notify() handler before getting NFIT table")
Fixes: 03667e146f81 ("ACPI: NFIT: core: Convert the driver to a platform one")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: All applicable <stable@vger.kernel.org>
---
 drivers/acpi/nfit/core.c | 63 ++++++++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index aaa84ae7a20e..cb771d9cadb2 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -56,6 +56,8 @@ MODULE_PARM_DESC(force_labels, "Opt-in to labels despite missing methods");
 LIST_HEAD(acpi_descs);
 DEFINE_MUTEX(acpi_desc_lock);
 
+DEFINE_MUTEX(acpi_notify_lock);
+
 static struct workqueue_struct *nfit_wq;
 
 struct nfit_table_prev {
@@ -1708,9 +1710,15 @@ static void acpi_nvdimm_notify(acpi_handle handle, u32 event, void *data)
 	struct acpi_device *adev = data;
 	struct device *dev = &adev->dev;
 
-	device_lock(dev->parent);
+	/*
+	 * Locking is needed here for synchronization with driver probe and
+	 * removal and the parent's driver data pointer is NULL when teardown
+	 * is in progress (while the parent here is expected to be the ACPI
+	 * companion of the platform device used for driver binding).
+	 */
+	guard(mutex)(&acpi_notify_lock);
+
 	__acpi_nvdimm_notify(dev, event);
-	device_unlock(dev->parent);
 }
 
 static bool acpi_nvdimm_has_method(struct acpi_device *adev, char *method)
@@ -3156,11 +3164,10 @@ EXPORT_SYMBOL_GPL(acpi_nfit_init);
 static int acpi_nfit_flush_probe(struct nvdimm_bus_descriptor *nd_desc)
 {
 	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
-	struct device *dev = acpi_desc->dev;
 
-	/* Bounce the device lock to flush acpi_nfit_add / acpi_nfit_notify */
-	device_lock(dev);
-	device_unlock(dev);
+	/* Bounce the notify lock to flush acpi_nfit_probe / acpi_nfit_notify */
+	mutex_lock(&acpi_notify_lock);
+	mutex_unlock(&acpi_notify_lock);
 
 	/* Bounce the init_mutex to complete initial registration */
 	mutex_lock(&acpi_desc->init_mutex);
@@ -3292,10 +3299,17 @@ static void acpi_nfit_put_table(void *table)
 static void acpi_nfit_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct device *dev = data;
+	struct acpi_device *adev = ACPI_COMPANION(dev);
 
-	device_lock(dev);
-	__acpi_nfit_notify(dev, handle, event);
-	device_unlock(dev);
+	/*
+	 * Locking is needed here for synchronization with driver probe and
+	 * removal and the ACPI companion's driver data pointer is NULL when
+	 * teardown is in progress.
+	 */
+	guard(mutex)(&acpi_notify_lock);
+
+	if (dev_get_drvdata(&adev->dev))
+		__acpi_nfit_notify(dev, handle, event);
 }
 
 void acpi_nfit_shutdown(void *data)
@@ -3337,11 +3351,18 @@ static int acpi_nfit_probe(struct platform_device *pdev)
 	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
 	struct acpi_nfit_desc *acpi_desc;
 	struct device *dev = &pdev->dev;
+	struct acpi_device *adev = ACPI_COMPANION(dev);
 	struct acpi_table_header *tbl;
 	acpi_status status = AE_OK;
 	acpi_size sz;
 	int rc = 0;
 
+	/*
+	 * Prevent acpi_nfit_notify() from progressing until the probe is
+	 * complete in case there is a concurrent event to process.
+	 */
+	guard(mutex)(&acpi_notify_lock);
+
 	rc = devm_acpi_install_notify_handler(dev, ACPI_DEVICE_NOTIFY,
 					      acpi_nfit_notify, dev);
 	if (rc)
@@ -3357,6 +3378,11 @@ static int acpi_nfit_probe(struct platform_device *pdev)
 		 * data in the format of a series of NFIT Structures.
 		 */
 		dev_dbg(dev, "failed to find NFIT at startup\n");
+		/*
+		 * Let acpi_nfit_update_notify() run in case it will need to
+		 * allocate the acpi_desc object.
+		 */
+		dev_set_drvdata(&adev->dev, dev);
 		return 0;
 	}
 
@@ -3374,7 +3400,7 @@ static int acpi_nfit_probe(struct platform_device *pdev)
 	acpi_desc->acpi_header = *tbl;
 
 	/* Evaluate _FIT and override with that if present */
-	status = acpi_evaluate_object(ACPI_HANDLE(dev), "_FIT", NULL, &buf);
+	status = acpi_evaluate_object(adev->handle, "_FIT", NULL, &buf);
 	if (ACPI_SUCCESS(status) && buf.length > 0) {
 		union acpi_object *obj = buf.pointer;
 
@@ -3391,14 +3417,27 @@ static int acpi_nfit_probe(struct platform_device *pdev)
 				+ sizeof(struct acpi_table_nfit),
 				sz - sizeof(struct acpi_table_nfit));
 
-	if (rc)
+	if (rc) {
 		acpi_nfit_shutdown(acpi_desc);
+		return rc;
+	}
 
-	return rc;
+	/*
+	 * Let notify handlers operate (the actual value of the ACPI companion's
+	 * driver data pointer does not matter here so long as it is not NULL).
+	 */
+	dev_set_drvdata(&adev->dev, dev);
+	return 0;
 }
 
 static void acpi_nfit_remove(struct platform_device *pdev)
 {
+	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
+
+	guard(mutex)(&acpi_notify_lock);
+
+	/* Make notify handlers bail out early going forward. */
+	dev_set_drvdata(&adev->dev, NULL);
 	acpi_nfit_shutdown(platform_get_drvdata(pdev));
 }
 
-- 
2.51.0




