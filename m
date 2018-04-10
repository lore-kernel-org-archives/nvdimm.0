Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF08B22618161
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 15:49:20 -0700 (PDT)
Subject: [PATCH 3/5] tools/testing/nvdimm: support nfit_test_dimm attributes
 under nfit_test.1
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Apr 2018 15:39:24 -0700
Message-ID: <152339996473.16061.5371900618490700760.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152339994885.16061.1760220735664848631.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152339994885.16061.1760220735664848631.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The nfit_test.1 bus provides a pmem topology without blk-aperture
enabling, so it presents different failure modes for label space
handling. Allow custom DSM command error injection.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |   43 ++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index dc6cf5630280..c8c88363311b 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -1166,12 +1166,12 @@ static int ars_state_init(struct device *dev, struct ars_state *ars_state)
 
 static void put_dimms(void *data)
 {
-	struct device **dimm_dev = data;
+	struct nfit_test *t = data;
 	int i;
 
-	for (i = 0; i < NUM_DCR; i++)
-		if (dimm_dev[i])
-			device_unregister(dimm_dev[i]);
+	for (i = 0; i < t->num_dcr; i++)
+		if (t->dimm_dev[i])
+			device_unregister(t->dimm_dev[i]);
 }
 
 static struct class *nfit_test_dimm;
@@ -1180,13 +1180,11 @@ static int dimm_name_to_id(struct device *dev)
 {
 	int dimm;
 
-	if (sscanf(dev_name(dev), "test_dimm%d", &dimm) != 1
-			|| dimm >= NUM_DCR || dimm < 0)
+	if (sscanf(dev_name(dev), "test_dimm%d", &dimm) != 1)
 		return -ENXIO;
 	return dimm;
 }
 
-
 static ssize_t handle_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
@@ -1259,7 +1257,6 @@ static ssize_t fail_cmd_code_store(struct device *dev, struct device_attribute *
 }
 static DEVICE_ATTR_RW(fail_cmd_code);
 
-
 static struct attribute *nfit_test_dimm_attributes[] = {
 	&dev_attr_fail_cmd.attr,
 	&dev_attr_fail_cmd_code.attr,
@@ -1276,6 +1273,23 @@ static const struct attribute_group *nfit_test_dimm_attribute_groups[] = {
 	NULL,
 };
 
+static int nfit_test_dimm_init(struct nfit_test *t)
+{
+	int i;
+
+	if (devm_add_action_or_reset(&t->pdev.dev, put_dimms, t))
+		return -ENOMEM;
+	for (i = 0; i < t->num_dcr; i++) {
+		t->dimm_dev[i] = device_create_with_groups(nfit_test_dimm,
+				&t->pdev.dev, 0, NULL,
+				nfit_test_dimm_attribute_groups,
+				"test_dimm%d", i + t->dcr_idx);
+		if (!t->dimm_dev[i])
+			return -ENOMEM;
+	}
+	return 0;
+}
+
 static void smart_init(struct nfit_test *t)
 {
 	int i;
@@ -1371,17 +1385,8 @@ static int nfit_test0_alloc(struct nfit_test *t)
 	if (!t->_fit)
 		return -ENOMEM;
 
-	if (devm_add_action_or_reset(&t->pdev.dev, put_dimms, t->dimm_dev))
+	if (nfit_test_dimm_init(t))
 		return -ENOMEM;
-	for (i = 0; i < NUM_DCR; i++) {
-		t->dimm_dev[i] = device_create_with_groups(nfit_test_dimm,
-				&t->pdev.dev, 0, NULL,
-				nfit_test_dimm_attribute_groups,
-				"test_dimm%d", i);
-		if (!t->dimm_dev[i])
-			return -ENOMEM;
-	}
-
 	smart_init(t);
 	return ars_state_init(&t->pdev.dev, &t->ars_state);
 }
@@ -1413,6 +1418,8 @@ static int nfit_test1_alloc(struct nfit_test *t)
 	if (!t->spa_set[1])
 		return -ENOMEM;
 
+	if (nfit_test_dimm_init(t))
+		return -ENOMEM;
 	smart_init(t);
 	return ars_state_init(&t->pdev.dev, &t->ars_state);
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
