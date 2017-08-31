Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 34A9B20958BD1
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 14:07:19 -0700 (PDT)
Subject: [PATCH] libnvdimm, nfit: export an 'ecc_unit_size' sysfs attribute
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 Aug 2017 14:03:38 -0700
Message-ID: <150421341855.29628.5348977066074602199.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When the nfit driver initializes it runs an ARS (Address Range Scrub)
operation across every pmem range. Part of that process involves
determining the ARS capabilities of a given address range. One of the
capabilities that is reported is the 'Clear Uncorrectable Error Range
Length Unit Size' (see: ACPI 6.2 section 9.20.7.4 Function Index 1 -
Query ARS Capabilities). This property is of interest to userspace
software as it indicates the boundary at which the NVDIMM may need to
perform read-modify-write cycles to maintain ECC blocks.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 2c5608b92578..03105648f9b1 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1674,8 +1674,19 @@ static ssize_t range_index_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(range_index);
 
+static ssize_t ecc_unit_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+	struct nfit_spa *nfit_spa = nd_region_provider_data(nd_region);
+
+	return sprintf(buf, "%d\n", nfit_spa->clear_err_unit);
+}
+static DEVICE_ATTR_RO(ecc_unit_size);
+
 static struct attribute *acpi_nfit_region_attributes[] = {
 	&dev_attr_range_index.attr,
+	&dev_attr_ecc_unit_size.attr,
 	NULL,
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
