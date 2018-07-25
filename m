Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 04BE920337377
 for <linux-nvdimm@lists.01.org>; Wed, 25 Jul 2018 13:59:42 -0700 (PDT)
Subject: [PATCH v6 09/11] nfit_test: add context to dimm_dev for nfit_test
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 25 Jul 2018 13:59:21 -0700
Message-ID: <153255236183.51274.17097887120485862881.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
References: <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
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
Cc: alison.schofield@intel.com, keescook@chromium.org, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In order to access the nfit_test context via sideband sysfs knobs, the
dimm_dev needs to be more than struct device in order to point back to
struct nfit_test. Wrapping the original struct device with a struct
nfit_dimm_dev and saving the nfit_test as private driver data. Also
changing the nfit_mem to be a member of struct nfit_dimm_dev instead of
saving as private driver data of that device. This is in preparation for
adding security DSM support and allowing the locking of DIMMs for testing
via sideband.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |   41 +++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 18157b0c0d0d..7b3ce2194889 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -150,6 +150,11 @@ struct nfit_test_fw {
 	u64 end_time;
 };
 
+struct nfit_dimm_dev {
+	struct device dev;
+	struct nfit_mem *nfit_mem;
+};
+
 struct nfit_test {
 	struct acpi_nfit_desc acpi_desc;
 	struct platform_device pdev;
@@ -181,7 +186,7 @@ struct nfit_test {
 		unsigned long deadline;
 		spinlock_t lock;
 	} ars_state;
-	struct device *dimm_dev[NUM_DCR];
+	struct nfit_dimm_dev dimm_dev[NUM_DCR];
 	struct nd_intel_smart *smart;
 	struct nd_intel_smart_threshold *smart_threshold;
 	struct badrange badrange;
@@ -981,7 +986,8 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 						&t->smart_threshold[i -
 							t->dcr_idx],
 						&t->smart[i - t->dcr_idx],
-						&t->pdev.dev, t->dimm_dev[i]);
+						&t->pdev.dev,
+						&t->dimm_dev[i].dev);
 				break;
 			case ND_INTEL_SMART_INJECT:
 				rc = nfit_test_cmd_smart_inject(buf,
@@ -989,7 +995,8 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 						&t->smart_threshold[i -
 							t->dcr_idx],
 						&t->smart[i - t->dcr_idx],
-						&t->pdev.dev, t->dimm_dev[i]);
+						&t->pdev.dev,
+						&t->dimm_dev[i].dev);
 				break;
 			default:
 				return -ENOTTY;
@@ -1187,8 +1194,7 @@ static void put_dimms(void *data)
 	int i;
 
 	for (i = 0; i < t->num_dcr; i++)
-		if (t->dimm_dev[i])
-			device_unregister(t->dimm_dev[i]);
+		device_unregister(&t->dimm_dev[i].dev);
 }
 
 static struct class *nfit_test_dimm;
@@ -1290,19 +1296,27 @@ static const struct attribute_group *nfit_test_dimm_attribute_groups[] = {
 	NULL,
 };
 
+static void dimm_dev_release(struct device *dev)
+{
+}
+
 static int nfit_test_dimm_init(struct nfit_test *t)
 {
-	int i;
+	int i, rc;
 
 	if (devm_add_action_or_reset(&t->pdev.dev, put_dimms, t))
 		return -ENOMEM;
 	for (i = 0; i < t->num_dcr; i++) {
-		t->dimm_dev[i] = device_create_with_groups(nfit_test_dimm,
-				&t->pdev.dev, 0, NULL,
-				nfit_test_dimm_attribute_groups,
-				"test_dimm%d", i + t->dcr_idx);
-		if (!t->dimm_dev[i])
-			return -ENOMEM;
+		t->dimm_dev[i].dev.parent = &t->pdev.dev;
+		dev_set_name(&t->dimm_dev[i].dev, "test_dimm%d",
+				i + t->dcr_idx);
+		t->dimm_dev[i].dev.class = nfit_test_dimm;
+		t->dimm_dev[i].dev.groups = nfit_test_dimm_attribute_groups;
+		t->dimm_dev[i].dev.release = dimm_dev_release;
+		rc = device_register(&t->dimm_dev[i].dev);
+		if (rc < 0)
+			return rc;
+		dev_set_drvdata(&t->dimm_dev[i].dev, t);
 	}
 	return 0;
 }
@@ -2665,8 +2679,7 @@ static int nfit_test_probe(struct platform_device *pdev)
 
 		for (i = 0; i < NUM_DCR; i++)
 			if (nfit_handle == handle[i])
-				dev_set_drvdata(nfit_test->dimm_dev[i],
-						nfit_mem);
+				nfit_test->dimm_dev[i].nfit_mem = nfit_mem;
 	}
 	mutex_unlock(&acpi_desc->init_mutex);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
