Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AF36022618161
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 15:49:15 -0700 (PDT)
Subject: [PATCH 2/5] tools/testing/nvdimm: allow custom error code injection
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Apr 2018 15:39:19 -0700
Message-ID: <152339995956.16061.8063508678567328863.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Given that libnvdimm driver stack takes specific actions on DIMM command
error codes like -EACCES, provide a facility to inject custom failures.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |   38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index cb166be4918d..dc6cf5630280 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -138,6 +138,7 @@ static u32 handle[] = {
 };
 
 static unsigned long dimm_fail_cmd_flags[NUM_DCR];
+static int dimm_fail_cmd_code[NUM_DCR];
 
 struct nfit_test_fw {
 	enum intel_fw_update_state state;
@@ -892,8 +893,11 @@ static int get_dimm(struct nfit_mem *nfit_mem, unsigned int func)
 	if (i >= ARRAY_SIZE(handle))
 		return -ENXIO;
 
-	if ((1 << func) & dimm_fail_cmd_flags[i])
+	if ((1 << func) & dimm_fail_cmd_flags[i]) {
+		if (dimm_fail_cmd_code[i])
+			return dimm_fail_cmd_code[i];
 		return -EIO;
+	}
 
 	return i;
 }
@@ -1225,8 +1229,40 @@ static ssize_t fail_cmd_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(fail_cmd);
 
+static ssize_t fail_cmd_code_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	int dimm = dimm_name_to_id(dev);
+
+	if (dimm < 0)
+		return dimm;
+
+	return sprintf(buf, "%d\n", dimm_fail_cmd_code[dimm]);
+}
+
+static ssize_t fail_cmd_code_store(struct device *dev, struct device_attribute *attr,
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
+	dimm_fail_cmd_code[dimm] = val;
+	return size;
+}
+static DEVICE_ATTR_RW(fail_cmd_code);
+
+
 static struct attribute *nfit_test_dimm_attributes[] = {
 	&dev_attr_fail_cmd.attr,
+	&dev_attr_fail_cmd_code.attr,
 	&dev_attr_handle.attr,
 	NULL,
 };

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
