Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7EA23D9
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 06:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649829742; x=1681365742;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mfj3RQD/VbNG6IA6CbK1hSm+Veq8Lr6khP2wJSf72E8=;
  b=jiPtpW2cP47yXJg404cBEEjpQBhVsMotagt9dVN0l0mziek2mWS8Tnja
   Id6iDoUO3UNqZ+JqqmD0zbN5MsBEbNnk/C3rsosXOhF0saT3MHaeFLTCZ
   fUiIda5UhWhkVo2NsPfewu+EEMEPHy6yidAloqx74J92E1HvJ+dxu0gAZ
   tDhQP6iYiap6Alu83gJl+cWokYdmtSc1WsO9WbMvoP7TEn5ACo5l7W5dm
   7lVG97nIDZECFXrhUUu72aB/aWkpfTiHAI5j8Eg3PYqDcbjTpNGKvh3aS
   DmF8DhwvD+bt+SMh6EY9yzqtPewmY1p5SHbyMB5I9WKgUj77rSpqRGyx/
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="262335054"
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="262335054"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:02:16 -0700
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="623559363"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:02:16 -0700
Subject: [PATCH v2 09/12] ACPI: NFIT: Drop nfit_device_lock()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Dave Jiang <dave.jiang@intel.com>, Kevin Tian <kevin.tian@intel.com>,
 peterz@infradead.org, alison.schofield@intel.com, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Date: Tue, 12 Apr 2022 23:02:15 -0700
Message-ID: <164982973591.684294.5429843723059577546.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for the libnvdimm subsystem switching to device-core
common lockdep validation. Delete nfit_device_lock() which will need to
be replaced with an implementation that specifies a non-zero lock class.

Note this reverts back to the default state of unvalidated
device_lock(), until a lock class for ACPI NFIT devices is added.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   30 +++++++++++++++---------------
 drivers/acpi/nfit/nfit.h |   24 ------------------------
 2 files changed, 15 insertions(+), 39 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index fe61f617a943..ae5f4acf2675 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1230,7 +1230,7 @@ static ssize_t hw_error_scrub_store(struct device *dev,
 	if (rc)
 		return rc;
 
-	nfit_device_lock(dev);
+	device_lock(dev);
 	nd_desc = dev_get_drvdata(dev);
 	if (nd_desc) {
 		struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
@@ -1247,7 +1247,7 @@ static ssize_t hw_error_scrub_store(struct device *dev,
 			break;
 		}
 	}
-	nfit_device_unlock(dev);
+	device_unlock(dev);
 	if (rc)
 		return rc;
 	return size;
@@ -1267,10 +1267,10 @@ static ssize_t scrub_show(struct device *dev,
 	ssize_t rc = -ENXIO;
 	bool busy;
 
-	nfit_device_lock(dev);
+	device_lock(dev);
 	nd_desc = dev_get_drvdata(dev);
 	if (!nd_desc) {
-		nfit_device_unlock(dev);
+		device_unlock(dev);
 		return rc;
 	}
 	acpi_desc = to_acpi_desc(nd_desc);
@@ -1287,7 +1287,7 @@ static ssize_t scrub_show(struct device *dev,
 	}
 
 	mutex_unlock(&acpi_desc->init_mutex);
-	nfit_device_unlock(dev);
+	device_unlock(dev);
 	return rc;
 }
 
@@ -1304,14 +1304,14 @@ static ssize_t scrub_store(struct device *dev,
 	if (val != 1)
 		return -EINVAL;
 
-	nfit_device_lock(dev);
+	device_lock(dev);
 	nd_desc = dev_get_drvdata(dev);
 	if (nd_desc) {
 		struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 
 		rc = acpi_nfit_ars_rescan(acpi_desc, ARS_REQ_LONG);
 	}
-	nfit_device_unlock(dev);
+	device_unlock(dev);
 	if (rc)
 		return rc;
 	return size;
@@ -1697,9 +1697,9 @@ static void acpi_nvdimm_notify(acpi_handle handle, u32 event, void *data)
 	struct acpi_device *adev = data;
 	struct device *dev = &adev->dev;
 
-	nfit_device_lock(dev->parent);
+	device_lock(dev->parent);
 	__acpi_nvdimm_notify(dev, event);
-	nfit_device_unlock(dev->parent);
+	device_unlock(dev->parent);
 }
 
 static bool acpi_nvdimm_has_method(struct acpi_device *adev, char *method)
@@ -3152,8 +3152,8 @@ static int acpi_nfit_flush_probe(struct nvdimm_bus_descriptor *nd_desc)
 	struct device *dev = acpi_desc->dev;
 
 	/* Bounce the device lock to flush acpi_nfit_add / acpi_nfit_notify */
-	nfit_device_lock(dev);
-	nfit_device_unlock(dev);
+	device_lock(dev);
+	device_unlock(dev);
 
 	/* Bounce the init_mutex to complete initial registration */
 	mutex_lock(&acpi_desc->init_mutex);
@@ -3305,8 +3305,8 @@ void acpi_nfit_shutdown(void *data)
 	 * acpi_nfit_ars_rescan() submissions have had a chance to
 	 * either submit or see ->cancel set.
 	 */
-	nfit_device_lock(bus_dev);
-	nfit_device_unlock(bus_dev);
+	device_lock(bus_dev);
+	device_unlock(bus_dev);
 
 	flush_workqueue(nfit_wq);
 }
@@ -3449,9 +3449,9 @@ EXPORT_SYMBOL_GPL(__acpi_nfit_notify);
 
 static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
 {
-	nfit_device_lock(&adev->dev);
+	device_lock(&adev->dev);
 	__acpi_nfit_notify(&adev->dev, adev->handle, event);
-	nfit_device_unlock(&adev->dev);
+	device_unlock(&adev->dev);
 }
 
 static const struct acpi_device_id acpi_nfit_ids[] = {
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 50882bdbeb96..6023ad61831a 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -337,30 +337,6 @@ static inline struct acpi_nfit_desc *to_acpi_desc(
 	return container_of(nd_desc, struct acpi_nfit_desc, nd_desc);
 }
 
-#ifdef CONFIG_PROVE_LOCKING
-static inline void nfit_device_lock(struct device *dev)
-{
-	device_lock(dev);
-	mutex_lock(&dev->lockdep_mutex);
-}
-
-static inline void nfit_device_unlock(struct device *dev)
-{
-	mutex_unlock(&dev->lockdep_mutex);
-	device_unlock(dev);
-}
-#else
-static inline void nfit_device_lock(struct device *dev)
-{
-	device_lock(dev);
-}
-
-static inline void nfit_device_unlock(struct device *dev)
-{
-	device_unlock(dev);
-}
-#endif
-
 const guid_t *to_nfit_uuid(enum nfit_uuids id);
 int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *nfit, acpi_size sz);
 void acpi_nfit_shutdown(void *data);

