Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7B617E4
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 02:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646102973; x=1677638973;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dKqV9Xtx7Ao68rbouYZAIKnCg8z1qKxZcx94UG+yU6E=;
  b=WiW2SUPFiK5y39j3zGb40633OxqlZPMkrYOVqsaaV/ULhsIqr9u0WKqE
   12h3wbVvxGOdDVChr5hygNubSdcOIQhPxct/yI0+SKiqdnaGkrSFas6rD
   VcNyT7Q7vwFfEYLTB4f6qwz+STW0vtKyPYgIqmOcRt7H8CFxZWgJV6RpE
   80SA39W+zqIDpBymaIL2GISqzQ0uKBbAkhue8EDOzdZEv6ql9yRQO/3yW
   ha7X1Y6GWIY8JU/EiwnuaDWc5AO+bnnd85mDcJAwskuxSx/PuS7aAr3Pw
   OmfNfLXLtvej48bEBjgloN4INaAOjF3fLwWFYu9slBhP9yRTzmvWzHc50
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="316256544"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="316256544"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:49:32 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="708892236"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:49:32 -0800
Subject: [PATCH 08/11] ACPI: NFIT: Drop nfit_device_lock()
From: Dan Williams <dan.j.williams@intel.com>
To: gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 alison.schofield@intel.com, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Mon, 28 Feb 2022 18:49:32 -0800
Message-ID: <164610297271.2682974.2282625073149152598.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164610292916.2682974.12924748003366352335.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164610292916.2682974.12924748003366352335.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   30 +++++++++++++++---------------
 drivers/acpi/nfit/nfit.h |   24 ------------------------
 2 files changed, 15 insertions(+), 39 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index e5d7f2bda13f..315fccdbfd84 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1305,7 +1305,7 @@ static ssize_t hw_error_scrub_store(struct device *dev,
 	if (rc)
 		return rc;
 
-	nfit_device_lock(dev);
+	device_lock(dev);
 	nd_desc = dev_get_drvdata(dev);
 	if (nd_desc) {
 		struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
@@ -1322,7 +1322,7 @@ static ssize_t hw_error_scrub_store(struct device *dev,
 			break;
 		}
 	}
-	nfit_device_unlock(dev);
+	device_unlock(dev);
 	if (rc)
 		return rc;
 	return size;
@@ -1342,10 +1342,10 @@ static ssize_t scrub_show(struct device *dev,
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
@@ -1362,7 +1362,7 @@ static ssize_t scrub_show(struct device *dev,
 	}
 
 	mutex_unlock(&acpi_desc->init_mutex);
-	nfit_device_unlock(dev);
+	device_unlock(dev);
 	return rc;
 }
 
@@ -1379,14 +1379,14 @@ static ssize_t scrub_store(struct device *dev,
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
@@ -1774,9 +1774,9 @@ static void acpi_nvdimm_notify(acpi_handle handle, u32 event, void *data)
 	struct acpi_device *adev = data;
 	struct device *dev = &adev->dev;
 
-	nfit_device_lock(dev->parent);
+	device_lock(dev->parent);
 	__acpi_nvdimm_notify(dev, event);
-	nfit_device_unlock(dev->parent);
+	device_unlock(dev->parent);
 }
 
 static bool acpi_nvdimm_has_method(struct acpi_device *adev, char *method)
@@ -3532,8 +3532,8 @@ static int acpi_nfit_flush_probe(struct nvdimm_bus_descriptor *nd_desc)
 	struct device *dev = acpi_desc->dev;
 
 	/* Bounce the device lock to flush acpi_nfit_add / acpi_nfit_notify */
-	nfit_device_lock(dev);
-	nfit_device_unlock(dev);
+	device_lock(dev);
+	device_unlock(dev);
 
 	/* Bounce the init_mutex to complete initial registration */
 	mutex_lock(&acpi_desc->init_mutex);
@@ -3686,8 +3686,8 @@ void acpi_nfit_shutdown(void *data)
 	 * acpi_nfit_ars_rescan() submissions have had a chance to
 	 * either submit or see ->cancel set.
 	 */
-	nfit_device_lock(bus_dev);
-	nfit_device_unlock(bus_dev);
+	device_lock(bus_dev);
+	device_unlock(bus_dev);
 
 	flush_workqueue(nfit_wq);
 }
@@ -3830,9 +3830,9 @@ EXPORT_SYMBOL_GPL(__acpi_nfit_notify);
 
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
index c674f3df9be7..2c16a2dafb15 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -343,30 +343,6 @@ static inline struct acpi_nfit_desc *to_acpi_desc(
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

