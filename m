Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B7AD81A1E27
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 14:56:40 -0700 (PDT)
Subject: [PATCH 1/3] tools/testing/nvdimm: unit test for acpi_nfit_notify()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Aug 2016 14:54:17 -0700
Message-ID: <147198925710.3136.16040023302705799007.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

We have had a couple bugs in this implementation in the past and before
we add another ->notify() implementation for nvdimm devices, lets allow
this routine to be exercised via nfit_test.

Rewrite acpi_nfit_notify() in terms of a generic struct device and
acpi_handle parameter, and then implement a mock acpi_evaluate_object()
that returns a _FIT payload.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c          |   25 ++++++++++++++-----------
 drivers/acpi/nfit/nfit.h          |    1 +
 tools/testing/nvdimm/Kbuild       |    1 +
 tools/testing/nvdimm/test/iomap.c |   17 +++++++++++++++++
 tools/testing/nvdimm/test/nfit.c  |   21 +++++++++++++++------
 5 files changed, 48 insertions(+), 17 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 4a363bed89b3..8120e8218f93 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2670,11 +2670,10 @@ static int acpi_nfit_remove(struct acpi_device *adev)
 	return 0;
 }
 
-static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
+void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
 {
-	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(&adev->dev);
+	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(dev);
 	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
-	struct device *dev = &adev->dev;
 	union acpi_object *obj;
 	acpi_status status;
 	int ret;
@@ -2684,18 +2683,17 @@ static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
 	if (event != NFIT_NOTIFY_UPDATE)
 		return;
 
-	device_lock(dev);
 	if (!dev->driver) {
 		/* dev->driver may be null if we're being removed */
 		dev_dbg(dev, "%s: no driver found for dev\n", __func__);
-		goto out_unlock;
+		return;
 	}
 
 	if (!acpi_desc) {
 		acpi_desc = devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);
 		if (!acpi_desc)
-			goto out_unlock;
-		acpi_nfit_desc_init(acpi_desc, &adev->dev);
+			return;
+		acpi_nfit_desc_init(acpi_desc, dev);
 	} else {
 		/*
 		 * Finish previous registration before considering new
@@ -2705,10 +2703,10 @@ static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
 	}
 
 	/* Evaluate _FIT */
-	status = acpi_evaluate_object(adev->handle, "_FIT", NULL, &buf);
+	status = acpi_evaluate_object(handle, "_FIT", NULL, &buf);
 	if (ACPI_FAILURE(status)) {
 		dev_err(dev, "failed to evaluate _FIT\n");
-		goto out_unlock;
+		return;
 	}
 
 	obj = buf.pointer;
@@ -2720,9 +2718,14 @@ static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
 	} else
 		dev_err(dev, "Invalid _FIT\n");
 	kfree(buf.pointer);
+}
+EXPORT_SYMBOL_GPL(__acpi_nfit_notify);
 
- out_unlock:
-	device_unlock(dev);
+static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
+{
+	device_lock(&adev->dev);
+	__acpi_nfit_notify(&adev->dev, adev->handle, event);
+	device_unlock(&adev->dev);
 }
 
 static const struct acpi_device_id acpi_nfit_ids[] = {
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 51d23f130d86..52370347fb0e 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -227,5 +227,6 @@ static inline struct acpi_nfit_desc *to_acpi_desc(
 
 const u8 *to_nfit_uuid(enum nfit_uuids id);
 int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *nfit, acpi_size sz);
+void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event);
 void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev);
 #endif /* __NFIT_H__ */
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index ad6dd0543019..582db95127ed 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -13,6 +13,7 @@ ldflags-y += --wrap=__release_region
 ldflags-y += --wrap=devm_memremap_pages
 ldflags-y += --wrap=insert_resource
 ldflags-y += --wrap=remove_resource
+ldflags-y += --wrap=acpi_evaluate_object
 
 DRIVERS := ../../../drivers
 NVDIMM_SRC := $(DRIVERS)/nvdimm
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index c29f8dca9e67..dae5b9b6d186 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/pfn_t.h>
+#include <linux/acpi.h>
 #include <linux/io.h>
 #include <linux/mm.h>
 #include "nfit_test.h"
@@ -276,4 +277,20 @@ void __wrap___devm_release_region(struct device *dev, struct resource *parent,
 }
 EXPORT_SYMBOL(__wrap___devm_release_region);
 
+acpi_status __wrap_acpi_evaluate_object(acpi_handle handle, acpi_string path,
+		struct acpi_object_list *p, struct acpi_buffer *buf)
+{
+	struct nfit_test_resource *nfit_res = get_nfit_res((long) handle);
+	union acpi_object **obj;
+
+	if (!nfit_res || strcmp(path, "_FIT") || !buf)
+		return acpi_evaluate_object(handle, path, p, buf);
+
+	obj = nfit_res->buf;
+	buf->length = sizeof(union acpi_object);
+	buf->pointer = *obj;
+	return AE_OK;
+}
+EXPORT_SYMBOL(__wrap_acpi_evaluate_object);
+
 MODULE_LICENSE("GPL v2");
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index dd48f421844c..8d79c75d3cae 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -154,6 +154,8 @@ struct nfit_test {
 	int (*alloc)(struct nfit_test *t);
 	void (*setup)(struct nfit_test *t);
 	int setup_hotplug;
+	union acpi_object **_fit;
+	dma_addr_t _fit_dma;
 	struct ars_state {
 		struct nd_cmd_ars_status *ars_status;
 		unsigned long deadline;
@@ -615,6 +617,10 @@ static int nfit_test0_alloc(struct nfit_test *t)
 			return -ENOMEM;
 	}
 
+	t->_fit = test_alloc(t, sizeof(union acpi_object **), &t->_fit_dma);
+	if (!t->_fit)
+		return -ENOMEM;
+
 	return ars_state_init(&t->pdev.dev, &t->ars_state);
 }
 
@@ -1408,6 +1414,7 @@ static int nfit_test_probe(struct platform_device *pdev)
 	struct acpi_nfit_desc *acpi_desc;
 	struct device *dev = &pdev->dev;
 	struct nfit_test *nfit_test;
+	union acpi_object *obj;
 	int rc;
 
 	nfit_test = to_nfit_test(&pdev->dev);
@@ -1475,15 +1482,17 @@ static int nfit_test_probe(struct platform_device *pdev)
 	if (nfit_test->setup != nfit_test0_setup)
 		return 0;
 
-	flush_work(&acpi_desc->work);
 	nfit_test->setup_hotplug = 1;
 	nfit_test->setup(nfit_test);
 
-	rc = acpi_nfit_init(acpi_desc, nfit_test->nfit_buf,
-			nfit_test->nfit_size);
-	if (rc)
-		return rc;
-
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+	obj->type = ACPI_TYPE_BUFFER;
+	obj->buffer.length = nfit_test->nfit_size;
+	obj->buffer.pointer = nfit_test->nfit_buf;
+	*(nfit_test->_fit) = obj;
+	__acpi_nfit_notify(&pdev->dev, nfit_test, 0x80);
 	return 0;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
