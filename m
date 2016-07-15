Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id B33271A1F04
 for <linux-nvdimm@lists.01.org>; Fri, 15 Jul 2016 12:37:09 -0700 (PDT)
Subject: [PATCH v2 2/2] nfit: cleanup acpi_nfit_init calling convention
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Jul 2016 12:34:11 -0700
Message-ID: <146861116893.16732.16345540619016632023.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146861106687.16732.18123746119721100494.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146861106687.16732.18123746119721100494.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Pass the nfit buffer as a parameter rather than hanging it off of
acpi_desc.

Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v1:

* Reflowed based on fixups done to patch1, no other changes.

 drivers/acpi/nfit.c              |   48 +++++++++++++-------------------------
 drivers/acpi/nfit.h              |    3 +-
 tools/testing/nvdimm/test/nfit.c |    7 +++---
 3 files changed, 22 insertions(+), 36 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index cbdbe13bdbe8..4173cf0033c2 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -2237,12 +2237,11 @@ static int acpi_nfit_check_deletions(struct acpi_nfit_desc *acpi_desc,
 	return 0;
 }
 
-int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
+int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
 {
 	struct device *dev = acpi_desc->dev;
 	struct nfit_table_prev prev;
 	const void *end;
-	u8 *data;
 	int rc;
 
 	mutex_lock(&acpi_desc->init_mutex);
@@ -2267,7 +2266,6 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 	list_cut_position(&prev.flushes, &acpi_desc->flushes,
 				acpi_desc->flushes.prev);
 
-	data = (u8 *) acpi_desc->nfit;
 	end = data + sz;
 	while (!IS_ERR_OR_NULL(data))
 		data = add_table(acpi_desc, &prev, data, end);
@@ -2407,40 +2405,30 @@ static int acpi_nfit_add(struct acpi_device *adev)
 	if (!acpi_desc->nvdimm_bus)
 		return -ENOMEM;
 
-	/*
-	 * Save the acpi header for later and then skip it,
-	 * making nfit point to the first nfit table header.
-	 */
+	/* Save the acpi header for exporting the revision via sysfs */
 	acpi_desc->acpi_header = *tbl;
-	acpi_desc->nfit = (void *) tbl + sizeof(struct acpi_table_nfit);
-	sz -= sizeof(struct acpi_table_nfit);
 
 	/* Evaluate _FIT and override with that if present */
 	status = acpi_evaluate_object(adev->handle, "_FIT", NULL, &buf);
 	if (ACPI_SUCCESS(status) && buf.length > 0) {
-		union acpi_object *obj;
-		/*
-		 * Adjust for the acpi_object header of the _FIT
-		 */
-		obj = buf.pointer;
-		if (obj->type == ACPI_TYPE_BUFFER) {
-			acpi_desc->nfit =
-				(struct acpi_nfit_header *)obj->buffer.pointer;
-			sz = obj->buffer.length;
-			rc = acpi_nfit_init(acpi_desc, sz);
-		} else
+		union acpi_object *obj = buf.pointer;
+
+		if (obj->type == ACPI_TYPE_BUFFER)
+			rc = acpi_nfit_init(acpi_desc, obj->buffer.pointer,
+					obj->buffer.length);
+		else
 			dev_dbg(dev, "%s invalid type %d, ignoring _FIT\n",
 				 __func__, (int) obj->type);
-		acpi_desc->nfit = NULL;
 		kfree(buf.pointer);
 	} else
-		rc = acpi_nfit_init(acpi_desc, sz);
+		/* skip over the lead-in header table */
+		rc = acpi_nfit_init(acpi_desc, (void *) tbl
+				+ sizeof(struct acpi_table_nfit),
+				sz - sizeof(struct acpi_table_nfit));
 
-	if (rc) {
+	if (rc)
 		nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
-		return rc;
-	}
-	return 0;
+	return rc;
 }
 
 static int acpi_nfit_remove(struct acpi_device *adev)
@@ -2457,8 +2445,8 @@ static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
 {
 	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(&adev->dev);
 	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object *obj;
 	struct device *dev = &adev->dev;
+	union acpi_object *obj;
 	acpi_status status;
 	int ret;
 
@@ -2496,14 +2484,12 @@ static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
 
 	obj = buf.pointer;
 	if (obj->type == ACPI_TYPE_BUFFER) {
-		acpi_desc->nfit =
-			(struct acpi_nfit_header *)obj->buffer.pointer;
-		ret = acpi_nfit_init(acpi_desc, obj->buffer.length);
+		ret = acpi_nfit_init(acpi_desc, obj->buffer.pointer,
+				obj->buffer.length);
 		if (ret)
 			dev_err(dev, "failed to merge updated NFIT\n");
 	} else
 		dev_err(dev, "Invalid _FIT\n");
-	acpi_desc->nfit = NULL;
 	kfree(buf.pointer);
 
  out_unlock:
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 80fb2c0ac8bf..5179eba97a47 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -135,7 +135,6 @@ struct nfit_mem {
 struct acpi_nfit_desc {
 	struct nvdimm_bus_descriptor nd_desc;
 	struct acpi_table_header acpi_header;
-	struct acpi_nfit_header *nfit;
 	struct mutex init_mutex;
 	struct list_head memdevs;
 	struct list_head flushes;
@@ -201,6 +200,6 @@ static inline struct acpi_nfit_desc *to_acpi_desc(
 }
 
 const u8 *to_nfit_uuid(enum nfit_uuids id);
-int acpi_nfit_init(struct acpi_nfit_desc *nfit, acpi_size sz);
+int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *nfit, acpi_size sz);
 void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev);
 #endif /* __NFIT_H__ */
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index ff09a28890ed..52df3c20231d 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -1458,7 +1458,6 @@ static int nfit_test_probe(struct platform_device *pdev)
 	nfit_test->setup(nfit_test);
 	acpi_desc = &nfit_test->acpi_desc;
 	acpi_nfit_desc_init(acpi_desc, &pdev->dev);
-	acpi_desc->nfit = nfit_test->nfit_buf;
 	acpi_desc->blk_do_io = nfit_test_blk_do_io;
 	nd_desc = &acpi_desc->nd_desc;
 	nd_desc->provider_name = NULL;
@@ -1467,7 +1466,8 @@ static int nfit_test_probe(struct platform_device *pdev)
 	if (!acpi_desc->nvdimm_bus)
 		return -ENXIO;
 
-	rc = acpi_nfit_init(acpi_desc, nfit_test->nfit_size);
+	rc = acpi_nfit_init(acpi_desc, nfit_test->nfit_buf,
+			nfit_test->nfit_size);
 	if (rc) {
 		nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
 		return rc;
@@ -1479,7 +1479,8 @@ static int nfit_test_probe(struct platform_device *pdev)
 	nfit_test->setup_hotplug = 1;
 	nfit_test->setup(nfit_test);
 
-	rc = acpi_nfit_init(acpi_desc, nfit_test->nfit_size);
+	rc = acpi_nfit_init(acpi_desc, nfit_test->nfit_buf,
+			nfit_test->nfit_size);
 	if (rc) {
 		nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
 		return rc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
