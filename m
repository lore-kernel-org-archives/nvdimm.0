Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB49367B62;
	Tue,  2 Jun 2026 16:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780417770; cv=none; b=GAAgPsog2GW95nzkWtRqg0KCMA/wBBn4JkGS6BWJShqExG2vZ0jsjqo6MuwZBClyNxRRUpobkJUbVnEnlqV/4KSdjBUoNROXtPoxPhQXclCEkVyc5+Da0LCNmGifhoLF+NXcswceoX+dEyLOlXAMaxPGKB4u/RElqUMeHH+3J04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780417770; c=relaxed/simple;
	bh=oWr/Wvc9VzV6i67kN5rBVBLzSipoSIhYkfpuC7Fq/V8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T6dkbwDNG7lNvjXgjh59Zxr2RWUIZaxynd/A3Vi6nv91fws0nymvX+Riqrw9e+TdXMWk+GDFghhCtnM9snQwZ9oBBo2bEs7rQwtUpiazIjuups+P/gvCPH1gR5SXJ64gtiWVELwgvN4JFIIFTX1DrA4jRtEP9sLz8Q39oyD52Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KPKM5RB1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KPKM5RB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6857D1F00893;
	Tue,  2 Jun 2026 16:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780417769;
	bh=aE2AONd5sF6l2+LQ2uo+A+K2Ueps4oevFWCbnu447Hg=;
	h=From:To:Cc:Subject:Date;
	b=KPKM5RB18Bs25Z+5hfW7fGtxyn2kLXNBbiNBJDFKoQlbRi+Q9FXFPhrD/Y/QjAqwG
	 VXfNa80GMp5mfbLmmRcqvZl0ADXWe9YGVMhcKRYMuVccIY7ErT9VkRihPjn4l4dZAO
	 opTaTsAiLGSifv2CsbC4g6Hu2BxF512up+1Z5tlekYLeUoQPLmEnmwBTEPTww+ZJNU
	 F7auLUR6feqFtj+icCvoXCyazHhcucbsqVodYo/74aBGGpBxGICMBs7jqfDU5s2mb7
	 kk1OOErZADlcJAzg0nOG8KLqVgl3Z7OldlWcK2betHRkc+oBp6d+jBPfUVcthaBi/N
	 HcIS20XORzijA==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linux ACPI <linux-acpi@vger.kernel.org>
Cc: Dan Williams <djbw@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH v1] ACPI: NFIT: Fix possible issues related to driver cleanup
Date: Tue, 02 Jun 2026 18:29:25 +0200
Message-ID: <6000262.DvuYhMxLoT@rafael.j.wysocki>
Organization: Linux Kernel Development
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After commit 9b311b7313d6 ("ACPI: NFIT: Install Notify() handler before
getting NFIT table"), ACPI NFIT driver removal may deadlock if an ACPI
notify on the NFIT device is triggered concurrently.  A similar deadlock
may occur if an ACPI notify on the NFIT device is triggered during a
failing driver probe.  Moreover, if acpi_nfit_probe() returns 0 before
allocating the acpi_desc object, a use-after-free is possible during
driver removal and a NULL pointer dereference may occur in
acpi_nfit_uc_error_notify().

The deadlock is possible because acpi_dev_remove_notify_handler() calls
acpi_os_wait_events_complete() after removing the notify handler and the
driver core invokes it under the NFIT platform device lock which is also
acquired by acpi_nfit_notify().  Thus acpi_os_wait_events_complete() may
wait for acpi_nfit_notify() to complete, but the latter may not be able
to acquire the device lock which is being held by the driver core while
the former is running.

In turn, if acpi_nfit_probe() returns 0 before allocating the acpi_desc
object, acpi_desc may be allocated by acpi_nfit_update_notify(), in
which case no remove cleanup action is added, so delayed work items may
be processed and may attempt to operate on acpi_desc after it has been
freed.

The NULL pointer dereference in acpi_nfit_uc_error_notify() is
possible in the same case if platform firmware triggers a suprious
NFIT_NOTIFY_UC_MEMORY_ERROR notify on the NFIT device.

To address the deadlock, introduce a static mutex to be held instead of
the device lock across acpi_nfit_probe() and acpi_nfit_notify() to
prevent the latter from progressing until the former is complete.

However, this exposes the driver to a use-after-free on probe failures
and during removal because the acpi_desc object is freed before removing
the ACPI notify handler, so the latter may run after the former has been
freed and then it will access the freed memory via the NFIT device's
driver data pointer.

To prevent that from occurring, set the driver data pointer of the NFIT
device to an error pointer value during teardown (under the new lock)
and make the code using that pointer check it against an error value.

On top of that, to address the use-after-free issue mentioned above, add
a remove callback to the driver and make it call acpi_nfit_shutdown()
directly which ensures that the remove cleanup will be carried out
regardless of the way the acpi_desc object has been allocated.

Finally, address the possible NULL pointer dereference mentioned above
by making acpi_nfit_uc_error_notify() check acpi_desc against NULL in
addition to checking it against an error pointer value.

Fixes: 9b311b7313d6 ("ACPI: NFIT: Install Notify() handler before getting NFIT table")
Fixes: a61fe6f7902e ("nfit, tools/testing/nvdimm: unify common init for acpi_nfit_desc")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: All applicable <stable@vger.kernel.org>
---
 drivers/acpi/nfit/core.c |   56 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 10 deletions(-)

--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -56,6 +56,8 @@ MODULE_PARM_DESC(force_labels, "Opt-in t
 LIST_HEAD(acpi_descs);
 DEFINE_MUTEX(acpi_desc_lock);
 
+DEFINE_MUTEX(acpi_nfit_notify_lock);
+
 static struct workqueue_struct *nfit_wq;
 
 struct nfit_table_prev {
@@ -1692,7 +1694,7 @@ void __acpi_nvdimm_notify(struct device
 	}
 
 	acpi_desc = dev_get_drvdata(dev->parent);
-	if (!acpi_desc)
+	if (IS_ERR_OR_NULL(acpi_desc))
 		return;
 
 	/*
@@ -3156,11 +3158,13 @@ EXPORT_SYMBOL_GPL(acpi_nfit_init);
 static int acpi_nfit_flush_probe(struct nvdimm_bus_descriptor *nd_desc)
 {
 	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
-	struct device *dev = acpi_desc->dev;
 
-	/* Bounce the device lock to flush acpi_nfit_add / acpi_nfit_notify */
-	device_lock(dev);
-	device_unlock(dev);
+	/*
+	 * Bounce acpi_nfit_notify_lock to flush acpi_nfit_probe() /
+	 * acpi_nfit_notify()
+	 */
+	mutex_lock(&acpi_nfit_notify_lock);
+	mutex_unlock(&acpi_nfit_notify_lock);
 
 	/* Bounce the init_mutex to complete initial registration */
 	mutex_lock(&acpi_desc->init_mutex);
@@ -3293,9 +3297,9 @@ static void acpi_nfit_notify(acpi_handle
 {
 	struct device *dev = data;
 
-	device_lock(dev);
+	guard(mutex)(&acpi_nfit_notify_lock);
+
 	__acpi_nfit_notify(dev, handle, event);
-	device_unlock(dev);
 }
 
 static void acpi_nfit_remove_notify_handler(void *data)
@@ -3351,6 +3355,12 @@ static int acpi_nfit_probe(struct platfo
 	if (!adev)
 		return -ENODEV;
 
+	/*
+	 * Prevent acpi_nfit_notify() from progressing until the probe is
+	 * complete in case there is a concurrent event to process.
+	 */
+	guard(mutex)(&acpi_nfit_notify_lock);
+
 	rc = acpi_dev_install_notify_handler(adev, ACPI_DEVICE_NOTIFY,
 					     acpi_nfit_notify, dev);
 	if (rc)
@@ -3405,10 +3415,25 @@ static int acpi_nfit_probe(struct platfo
 				+ sizeof(struct acpi_table_nfit),
 				sz - sizeof(struct acpi_table_nfit));
 
+	/* On failure, make acpi_nfit_update_notify() bail out early */
 	if (rc)
-		return rc;
+		dev_set_drvdata(dev, ERR_PTR(-ENODEV));
 
-	return devm_add_action_or_reset(dev, acpi_nfit_shutdown, acpi_desc);
+	return rc;
+}
+
+static void acpi_nfit_remove(struct platform_device *pdev)
+{
+	struct acpi_nfit_desc *acpi_desc;
+
+	guard(mutex)(&acpi_nfit_notify_lock);
+
+	acpi_desc = platform_get_drvdata(pdev);
+	if (acpi_desc && acpi_desc->nvdimm_bus)
+		acpi_nfit_shutdown(acpi_desc);
+
+	/* Let acpi_nfit_update_notify() know that the driver is going away. */
+	platform_set_drvdata(pdev, ERR_PTR(-ENODEV));
 }
 
 static void acpi_nfit_update_notify(struct device *dev, acpi_handle handle)
@@ -3425,7 +3450,11 @@ static void acpi_nfit_update_notify(stru
 		return;
 	}
 
-	if (!acpi_desc) {
+	if (IS_ERR(acpi_desc)) {
+		/* Do nothing during teardown */
+		dev_dbg(dev, "driver teardown\n");
+		return;
+	} else if (!acpi_desc) {
 		acpi_desc = devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);
 		if (!acpi_desc)
 			return;
@@ -3460,6 +3489,12 @@ static void acpi_nfit_uc_error_notify(st
 {
 	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(dev);
 
+	/* Do nothing during teardown or when there is no acpi_desc */
+	if (IS_ERR_OR_NULL(acpi_desc)) {
+		dev_dbg(dev, "spurious notification or driver teardown\n");
+		return;
+	}
+
 	if (acpi_desc->scrub_mode == HW_ERROR_SCRUB_ON)
 		acpi_nfit_ars_rescan(acpi_desc, ARS_REQ_LONG);
 	else
@@ -3489,6 +3524,7 @@ MODULE_DEVICE_TABLE(acpi, acpi_nfit_ids)
 
 static struct platform_driver acpi_nfit_driver = {
 	.probe = acpi_nfit_probe,
+	.remove = acpi_nfit_remove,
 	.driver = {
 		.name = "acpi-nfit",
 		.acpi_match_table = acpi_nfit_ids,



