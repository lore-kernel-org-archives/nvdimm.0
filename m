Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2FF10782
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 21:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669930429; x=1701466429;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rtHHKljNie92pYyqBhG1WgsKVo4aYatQ1SgLiSM6AVg=;
  b=nQxKTRQieT1HmIRBxrIyvm0RIioV+w6O+CA7pnVjzr6WeL+uMJQz7eJy
   PYFLvHatYTTKcyfnicAfekF2uGSSL6thkFMho6E+GhqJGu8ze0JH0cv9d
   cDPtVtIodTKOzLVbVw0l1QS494zV7Y43NfKtrCMmFWDLZla/XB6/Rxbaj
   yNM/JOWNJ2k5MRJ5qGiUxU1pUT3kTdClxzUtW4qk9YuZPn4O/F6sQntR+
   jGYkHugJ+2WX6KOjcfJ+u7qUtzlAIcNPVNd9u7ghxBp7VQqEiOPMnPCzP
   lGmtRggFHVETm9RWAPxDENN72vLvJPaiNGl20v2/5vqWTh8dOmep4vuk1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="313443210"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="313443210"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:33:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="675594765"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="675594765"
Received: from navarrof-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.177.235])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:33:49 -0800
Subject: [PATCH v6 05/12] cxl/acpi: Move rescan to the workqueue
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Robert Richter <rrichter@amd.com>, alison.schofield@intel.com,
 rrichter@amd.com, terry.bowman@amd.com, bhelgaas@google.com,
 dave.jiang@intel.com, nvdimm@lists.linux.dev
Date: Thu, 01 Dec 2022 13:33:48 -0800
Message-ID: <166993042884.1882361.5633723613683058881.stgit@dwillia2-xfh.jf.intel.com>
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

Now that the cxl_mem driver has a need to take the root device lock, the
cxl_bus_rescan() needs to run outside of the root lock context.

Tested-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/acpi.c      |   17 +++++++++++++++--
 drivers/cxl/core/port.c |   19 +++++++++++++++++--
 drivers/cxl/cxl.h       |    3 ++-
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index c540da0cbf1e..b8407b77aff6 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -511,7 +511,8 @@ static int cxl_acpi_probe(struct platform_device *pdev)
 		return rc;
 
 	/* In case PCI is scanned before ACPI re-trigger memdev attach */
-	return cxl_bus_rescan();
+	cxl_bus_rescan();
+	return 0;
 }
 
 static const struct acpi_device_id cxl_acpi_ids[] = {
@@ -535,7 +536,19 @@ static struct platform_driver cxl_acpi_driver = {
 	.id_table = cxl_test_ids,
 };
 
-module_platform_driver(cxl_acpi_driver);
+static int __init cxl_acpi_init(void)
+{
+	return platform_driver_register(&cxl_acpi_driver);
+}
+
+static void __exit cxl_acpi_exit(void)
+{
+	platform_driver_unregister(&cxl_acpi_driver);
+	cxl_bus_drain();
+}
+
+module_init(cxl_acpi_init);
+module_exit(cxl_acpi_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_IMPORT_NS(CXL);
 MODULE_IMPORT_NS(ACPI);
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 0d2f5eaaca7d..d225267c69bb 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1844,12 +1844,27 @@ static void cxl_bus_remove(struct device *dev)
 
 static struct workqueue_struct *cxl_bus_wq;
 
-int cxl_bus_rescan(void)
+static void cxl_bus_rescan_queue(struct work_struct *w)
 {
-	return bus_rescan_devices(&cxl_bus_type);
+	int rc = bus_rescan_devices(&cxl_bus_type);
+
+	pr_debug("CXL bus rescan result: %d\n", rc);
+}
+
+void cxl_bus_rescan(void)
+{
+	static DECLARE_WORK(rescan_work, cxl_bus_rescan_queue);
+
+	queue_work(cxl_bus_wq, &rescan_work);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_bus_rescan, CXL);
 
+void cxl_bus_drain(void)
+{
+	drain_workqueue(cxl_bus_wq);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_bus_drain, CXL);
+
 bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd)
 {
 	return queue_work(cxl_bus_wq, &cxlmd->detach_work);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index f0ca2d768385..281b1db5a271 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -552,7 +552,8 @@ int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
 			  struct cxl_dport *parent_dport);
 struct cxl_port *find_cxl_root(struct device *dev);
 int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
-int cxl_bus_rescan(void);
+void cxl_bus_rescan(void);
+void cxl_bus_drain(void);
 struct cxl_port *cxl_mem_find_port(struct cxl_memdev *cxlmd,
 				   struct cxl_dport **dport);
 bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd);

