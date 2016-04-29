Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 22FFD1A1F71
 for <linux-nvdimm@lists.01.org>; Thu, 28 Apr 2016 19:43:38 -0700 (PDT)
Subject: [PATCH v11 5/5] nfit: add sysfs dimm 'family' and 'dsm_mask'
 attributes
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Apr 2016 19:42:49 -0700
Message-ID: <146189776923.29835.5521802180709532725.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146189774241.29835.12947278159500915461.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146189774241.29835.12947278159500915461.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, rafael.j.wysocki@intel.com
List-ID: <linux-nvdimm@lists.01.org>

Communicate the command format and suppported functions to userspace
tooling.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 30801fe3367b..24549ba217b5 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -897,6 +897,30 @@ static ssize_t serial_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(serial);
 
+static ssize_t family_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+
+	if (nfit_mem->family < 0)
+		return -ENXIO;
+	return sprintf(buf, "%d\n", nfit_mem->family);
+}
+static DEVICE_ATTR_RO(family);
+
+static ssize_t dsm_mask_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+
+	if (nfit_mem->family < 0)
+		return -ENXIO;
+	return sprintf(buf, "%#lx\n", nfit_mem->dsm_mask);
+}
+static DEVICE_ATTR_RO(dsm_mask);
+
 static ssize_t flags_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -920,6 +944,8 @@ static struct attribute *acpi_nfit_dimm_attributes[] = {
 	&dev_attr_serial.attr,
 	&dev_attr_rev_id.attr,
 	&dev_attr_flags.attr,
+	&dev_attr_family.attr,
+	&dev_attr_dsm_mask.attr,
 	NULL,
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
