Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 903D71A1E5F
 for <linux-nvdimm@lists.01.org>; Tue, 13 Sep 2016 18:32:01 -0700 (PDT)
Subject: [PATCH 2/2] tools/testing/nvdimm: test get_config_size DSM failures
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Sep 2016 18:28:58 -0700
Message-ID: <147381653820.13555.4462846098098492278.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147381652762.13555.2547727388390513900.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147381652762.13555.2547727388390513900.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Add an nfit_test specific attribute for gating whether a get_config_size
DSM, or any DSM for that matter, succeeds or fails.  The get_config_size
DSM is initial motivation since that is the first command libnvdimm core
issues to determine the state of the namespace label area.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |   79 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 99ea68674f0a..e5404f1b8f90 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -132,6 +132,8 @@ static u32 handle[NUM_DCR] = {
 	[4] = NFIT_DIMM_HANDLE(0, 1, 0, 0, 0),
 };
 
+static unsigned long dimm_fail_cmd_flags[NUM_DCR];
+
 struct nfit_test {
 	struct acpi_nfit_desc acpi_desc;
 	struct platform_device pdev;
@@ -414,6 +416,9 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		if (i >= ARRAY_SIZE(handle))
 			return -ENXIO;
 
+		if ((1 << func) & dimm_fail_cmd_flags[i])
+			return -EIO;
+
 		switch (func) {
 		case ND_CMD_GET_CONFIG_SIZE:
 			rc = nfit_test_cmd_get_config_size(buf, buf_len);
@@ -582,6 +587,74 @@ static void put_dimms(void *data)
 
 static struct class *nfit_test_dimm;
 
+static int dimm_name_to_id(struct device *dev)
+{
+	int dimm;
+
+	if (sscanf(dev_name(dev), "test_dimm%d", &dimm) != 1
+			|| dimm >= NUM_DCR || dimm < 0)
+		return -ENXIO;
+	return dimm;
+}
+
+
+static ssize_t handle_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	int dimm = dimm_name_to_id(dev);
+
+	if (dimm < 0)
+		return dimm;
+
+	return sprintf(buf, "%#lx", handle[dimm]);
+}
+DEVICE_ATTR_RO(handle);
+
+static ssize_t fail_cmd_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	int dimm = dimm_name_to_id(dev);
+
+	if (dimm < 0)
+		return dimm;
+
+	return sprintf(buf, "%#lx\n", dimm_fail_cmd_flags[dimm]);
+}
+
+static ssize_t fail_cmd_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t size)
+{
+	int dimm = dimm_name_to_id(dev);
+	unsigned long val;
+	ssize_t rc;
+
+	if (dimm < 0)
+		return dimm;
+
+	rc = kstrtol(buf, 0, &val);
+	if (rc)
+		return rc;
+
+	dimm_fail_cmd_flags[dimm] = val;
+	return size;
+}
+static DEVICE_ATTR_RW(fail_cmd);
+
+static struct attribute *nfit_test_dimm_attributes[] = {
+	&dev_attr_fail_cmd.attr,
+	&dev_attr_handle.attr,
+	NULL,
+};
+
+static struct attribute_group nfit_test_dimm_attribute_group = {
+	.attrs = nfit_test_dimm_attributes,
+};
+
+static const struct attribute_group *nfit_test_dimm_attribute_groups[] = {
+	&nfit_test_dimm_attribute_group,
+	NULL,
+};
+
 static int nfit_test0_alloc(struct nfit_test *t)
 {
 	size_t nfit_size = sizeof(struct acpi_nfit_system_address) * NUM_SPA
@@ -640,8 +713,10 @@ static int nfit_test0_alloc(struct nfit_test *t)
 	if (devm_add_action_or_reset(&t->pdev.dev, put_dimms, t->dimm_dev))
 		return -ENOMEM;
 	for (i = 0; i < NUM_DCR; i++) {
-		t->dimm_dev[i] = device_create(nfit_test_dimm, &t->pdev.dev, 0,
-				NULL, "test_dimm%d", i);
+		t->dimm_dev[i] = device_create_with_groups(nfit_test_dimm,
+				&t->pdev.dev, 0, NULL,
+				nfit_test_dimm_attribute_groups,
+				"test_dimm%d", i);
 		if (!t->dimm_dev[i])
 			return -ENOMEM;
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
