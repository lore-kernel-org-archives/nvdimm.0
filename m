Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 28FC01A1EC9
 for <linux-nvdimm@lists.01.org>; Fri, 15 Jul 2016 12:35:42 -0700 (PDT)
Subject: [PATCH v2 1/2] nfit: fix _FIT evaluation memory leak
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Jul 2016 12:32:43 -0700
Message-ID: <146861106687.16732.18123746119721100494.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Xiao Guangrong <guangrong.xiao@intel.com>, stable@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

acpi_evaluate_object() allocates memory. Free the buffer allocated
during acpi_nfit_add().  Also, make it clear that ->nfit is not used
outside of acpi_nfit_init() context.

Cc: <stable@vger.kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Xiao Guangrong <guangrong.xiao@intel.com>
Reported-by: Haozhong Zhang <haozhong.zhang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Change since v1:

* Fix unitialized use of 'rc' (Haozhong)
* Clarify that their is no use-after-free problem in acpi_nfit_notify()
  (Xiao)

 drivers/acpi/nfit.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index d89a02d9ed10..cbdbe13bdbe8 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -2390,7 +2390,7 @@ static int acpi_nfit_add(struct acpi_device *adev)
 	struct acpi_table_header *tbl;
 	acpi_status status = AE_OK;
 	acpi_size sz;
-	int rc;
+	int rc = 0;
 
 	status = acpi_get_table_with_size(ACPI_SIG_NFIT, 0, &tbl, &sz);
 	if (ACPI_FAILURE(status)) {
@@ -2427,12 +2427,15 @@ static int acpi_nfit_add(struct acpi_device *adev)
 			acpi_desc->nfit =
 				(struct acpi_nfit_header *)obj->buffer.pointer;
 			sz = obj->buffer.length;
+			rc = acpi_nfit_init(acpi_desc, sz);
 		} else
 			dev_dbg(dev, "%s invalid type %d, ignoring _FIT\n",
 				 __func__, (int) obj->type);
-	}
+		acpi_desc->nfit = NULL;
+		kfree(buf.pointer);
+	} else
+		rc = acpi_nfit_init(acpi_desc, sz);
 
-	rc = acpi_nfit_init(acpi_desc, sz);
 	if (rc) {
 		nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
 		return rc;
@@ -2454,7 +2457,6 @@ static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
 {
 	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(&adev->dev);
 	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
-	struct acpi_nfit_header *nfit_saved;
 	union acpi_object *obj;
 	struct device *dev = &adev->dev;
 	acpi_status status;
@@ -2492,21 +2494,16 @@ static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
 		goto out_unlock;
 	}
 
-	nfit_saved = acpi_desc->nfit;
 	obj = buf.pointer;
 	if (obj->type == ACPI_TYPE_BUFFER) {
 		acpi_desc->nfit =
 			(struct acpi_nfit_header *)obj->buffer.pointer;
 		ret = acpi_nfit_init(acpi_desc, obj->buffer.length);
-		if (ret) {
-			/* Merge failed, restore old nfit, and exit */
-			acpi_desc->nfit = nfit_saved;
+		if (ret)
 			dev_err(dev, "failed to merge updated NFIT\n");
-		}
-	} else {
-		/* Bad _FIT, restore old nfit */
+	} else
 		dev_err(dev, "Invalid _FIT\n");
-	}
+	acpi_desc->nfit = NULL;
 	kfree(buf.pointer);
 
  out_unlock:

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
