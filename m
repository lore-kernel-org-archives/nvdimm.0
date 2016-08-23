Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 521081A1E30
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 14:56:51 -0700 (PDT)
Subject: [PATCH 3/3] tools/testing/nvdimm: unit test for acpi_nvdimm_notify()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Aug 2016 14:54:27 -0700
Message-ID: <147198926765.3136.15304034940920273330.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147198925154.3136.14739108342311837939.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147198925154.3136.14739108342311837939.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Trigger an nmemX/nfit/flags attribute to fire an event whenever a
smart-threshold DSM is received.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c         |   10 ++++++--
 drivers/acpi/nfit/nfit.h         |    1 +
 tools/testing/nvdimm/test/nfit.c |   45 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 65f155db4283..91ed148784c3 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1248,7 +1248,7 @@ static struct nvdimm *acpi_nfit_dimm_by_handle(struct acpi_nfit_desc *acpi_desc,
 	return NULL;
 }
 
-static void __acpi_nvdimm_notify(struct device *dev, u32 event)
+void __acpi_nvdimm_notify(struct device *dev, u32 event)
 {
 	struct nfit_mem *nfit_mem;
 	struct acpi_nfit_desc *acpi_desc;
@@ -1274,6 +1274,7 @@ static void __acpi_nvdimm_notify(struct device *dev, u32 event)
 	if (nfit_mem && nfit_mem->flags_attr)
 		sysfs_notify_dirent(nfit_mem->flags_attr);
 }
+EXPORT_SYMBOL_GPL(__acpi_nvdimm_notify);
 
 static void acpi_nvdimm_notify(acpi_handle handle, u32 event, void *data)
 {
@@ -2485,10 +2486,13 @@ static void acpi_nfit_destruct(void *data)
 	 * notifications.
 	 */
 	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
+		struct acpi_device *adev_dimm = nfit_mem->adev;
+
 		sysfs_put(nfit_mem->flags_attr);
 		nfit_mem->flags_attr = NULL;
-		acpi_remove_notify_handler(nfit_mem->adev->handle,
-				ACPI_DEVICE_NOTIFY, acpi_nvdimm_notify);
+		if (adev_dimm)
+			acpi_remove_notify_handler(adev_dimm->handle,
+					ACPI_DEVICE_NOTIFY, acpi_nvdimm_notify);
 	}
 	device_unlock(bus_dev);
 
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 13195824778c..bb101170cd0b 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -233,5 +233,6 @@ static inline struct acpi_nfit_desc *to_acpi_desc(
 const u8 *to_nfit_uuid(enum nfit_uuids id);
 int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *nfit, acpi_size sz);
 void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event);
+void __acpi_nvdimm_notify(struct device *dev, u32 event);
 void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev);
 #endif /* __NFIT_H__ */
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 8d79c75d3cae..99ea68674f0a 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -161,6 +161,7 @@ struct nfit_test {
 		unsigned long deadline;
 		spinlock_t lock;
 	} ars_state;
+	struct device *dimm_dev[NUM_DCR];
 };
 
 static struct nfit_test *to_nfit_test(struct device *dev)
@@ -430,6 +431,9 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 			break;
 		case ND_CMD_SMART_THRESHOLD:
 			rc = nfit_test_cmd_smart_threshold(buf, buf_len);
+			device_lock(&t->pdev.dev);
+			__acpi_nvdimm_notify(t->dimm_dev[i], 0x81);
+			device_unlock(&t->pdev.dev);
 			break;
 		default:
 			return -ENOTTY;
@@ -566,6 +570,18 @@ static int ars_state_init(struct device *dev, struct ars_state *ars_state)
 	return 0;
 }
 
+static void put_dimms(void *data)
+{
+	struct device **dimm_dev = data;
+	int i;
+
+	for (i = 0; i < NUM_DCR; i++)
+		if (dimm_dev[i])
+			device_unregister(dimm_dev[i]);
+}
+
+static struct class *nfit_test_dimm;
+
 static int nfit_test0_alloc(struct nfit_test *t)
 {
 	size_t nfit_size = sizeof(struct acpi_nfit_system_address) * NUM_SPA
@@ -621,6 +637,15 @@ static int nfit_test0_alloc(struct nfit_test *t)
 	if (!t->_fit)
 		return -ENOMEM;
 
+	if (devm_add_action_or_reset(&t->pdev.dev, put_dimms, t->dimm_dev))
+		return -ENOMEM;
+	for (i = 0; i < NUM_DCR; i++) {
+		t->dimm_dev[i] = device_create(nfit_test_dimm, &t->pdev.dev, 0,
+				NULL, "test_dimm%d", i);
+		if (!t->dimm_dev[i])
+			return -ENOMEM;
+	}
+
 	return ars_state_init(&t->pdev.dev, &t->ars_state);
 }
 
@@ -1414,6 +1439,7 @@ static int nfit_test_probe(struct platform_device *pdev)
 	struct acpi_nfit_desc *acpi_desc;
 	struct device *dev = &pdev->dev;
 	struct nfit_test *nfit_test;
+	struct nfit_mem *nfit_mem;
 	union acpi_object *obj;
 	int rc;
 
@@ -1493,6 +1519,20 @@ static int nfit_test_probe(struct platform_device *pdev)
 	obj->buffer.pointer = nfit_test->nfit_buf;
 	*(nfit_test->_fit) = obj;
 	__acpi_nfit_notify(&pdev->dev, nfit_test, 0x80);
+
+	/* associate dimm devices with nfit_mem data for notification testing */
+	mutex_lock(&acpi_desc->init_mutex);
+	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
+		u32 nfit_handle = __to_nfit_memdev(nfit_mem)->device_handle;
+		int i;
+
+		for (i = 0; i < NUM_DCR; i++)
+			if (nfit_handle == handle[i])
+				dev_set_drvdata(nfit_test->dimm_dev[i],
+						nfit_mem);
+	}
+	mutex_unlock(&acpi_desc->init_mutex);
+
 	return 0;
 }
 
@@ -1526,6 +1566,10 @@ static __init int nfit_test_init(void)
 {
 	int rc, i;
 
+	nfit_test_dimm = class_create(THIS_MODULE, "nfit_test_dimm");
+	if (IS_ERR(nfit_test_dimm))
+		return PTR_ERR(nfit_test_dimm);
+
 	nfit_test_setup(nfit_test_lookup);
 
 	for (i = 0; i < NUM_NFITS; i++) {
@@ -1592,6 +1636,7 @@ static __exit void nfit_test_exit(void)
 	for (i = 0; i < NUM_NFITS; i++)
 		platform_device_unregister(&instances[i]->pdev);
 	nfit_test_teardown();
+	class_destroy(nfit_test_dimm);
 }
 
 module_init(nfit_test_init);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
