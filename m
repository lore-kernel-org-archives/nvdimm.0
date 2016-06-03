Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pa0-x241.google.com (mail-pa0-x241.google.com
 [IPv6:2607:f8b0:400e:c03::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E6541A1E7F
 for <linux-nvdimm@lists.01.org>; Fri,  3 Jun 2016 00:16:01 -0700 (PDT)
Received: by mail-pa0-x241.google.com with SMTP id fg1so5280207pad.3
 for <linux-nvdimm@lists.01.org>; Fri, 03 Jun 2016 00:15:44 -0700 (PDT)
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH] libnvdimm,
 nfit: treat volatile virtual CD region as read-only pmem
Date: Fri,  3 Jun 2016 15:13:35 +0800
Message-Id: <1464938015-5489-1-git-send-email-jlee@suse.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Lee, Chun-Yi" <jlee@suse.com>, linux-acpi@vger.kernel.org, Gary Lin <GLin@suse.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patch adds codes to treat a volatile virtual CD region as a
read-only pmem region, then read-only /dev/pmem* device can be mounted
with iso9660.

It's useful to work with the httpboot in EFI firmware to pull a remote
ISO file to the local memory region for booting and installation.

Wiki page of UEFI HTTPBoot with OVMF:
	https://en.opensuse.org/UEFI_HTTPBoot_with_OVMF

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Cc: Gary Lin <GLin@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
---
 drivers/acpi/nfit.c          |  8 +++++++-
 drivers/nvdimm/region_devs.c | 26 +++++++++++++++++++++++++-
 include/linux/libnvdimm.h    |  2 ++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 2215fc8..b100a17 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1949,6 +1949,7 @@ static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
 	switch (nfit_spa_type(spa)) {
 	case NFIT_SPA_PM:
 	case NFIT_SPA_VOLATILE:
+	case NFIT_SPA_VCD:
 		nd_mapping->start = memdev->address;
 		nd_mapping->size = memdev->region_size;
 		break;
@@ -1995,7 +1996,7 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	if (nfit_spa->nd_region)
 		return 0;
 
-	if (spa->range_index == 0) {
+	if (spa->range_index == 0 && nfit_spa_type(spa) != NFIT_SPA_VCD) {
 		dev_dbg(acpi_desc->dev, "%s: detected invalid spa index\n",
 				__func__);
 		return 0;
@@ -2059,6 +2060,11 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 				ndr_desc);
 		if (!nfit_spa->nd_region)
 			rc = -ENOMEM;
+	} else if (nfit_spa_type(spa) == NFIT_SPA_VCD) {
+		nfit_spa->nd_region = nvdimm_vcd_region_create(nvdimm_bus,
+				ndr_desc);
+		if (!nfit_spa->nd_region)
+			rc = -ENOMEM;
 	}
 
  out:
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 40fcfea..f155941 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -56,9 +56,19 @@ static struct device_type nd_volatile_device_type = {
 	.release = nd_region_release,
 };
 
+static struct device_type nd_vcd_device_type = {
+	.name = "nd_vcd",
+	.release = nd_region_release,
+};
+
+bool is_nd_vcd(struct device *dev)
+{
+	return dev ? dev->type == &nd_vcd_device_type : false;
+}
+
 bool is_nd_pmem(struct device *dev)
 {
-	return dev ? dev->type == &nd_pmem_device_type : false;
+	return dev ? dev->type == &nd_pmem_device_type || is_nd_vcd(dev) : false;
 }
 
 bool is_nd_blk(struct device *dev)
@@ -338,6 +348,9 @@ static ssize_t read_only_store(struct device *dev,
 	int rc = strtobool(buf, &ro);
 	struct nd_region *nd_region = to_nd_region(dev);
 
+	if (is_nd_vcd(dev))
+		return -ENXIO;
+
 	if (rc)
 		return rc;
 
@@ -687,6 +700,9 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 			ro = 1;
 	}
 
+	if (dev_type == &nd_vcd_device_type)
+		ro = 1;
+
 	if (dev_type == &nd_blk_device_type) {
 		struct nd_blk_region_desc *ndbr_desc;
 		struct nd_blk_region *ndbr;
@@ -774,6 +790,14 @@ struct nd_region *nvdimm_pmem_region_create(struct nvdimm_bus *nvdimm_bus,
 }
 EXPORT_SYMBOL_GPL(nvdimm_pmem_region_create);
 
+struct nd_region *nvdimm_vcd_region_create(struct nvdimm_bus *nvdimm_bus,
+		struct nd_region_desc *ndr_desc)
+{
+	return nd_region_create(nvdimm_bus, ndr_desc, &nd_vcd_device_type,
+			__func__);
+}
+EXPORT_SYMBOL_GPL(nvdimm_vcd_region_create);
+
 struct nd_region *nvdimm_blk_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc)
 {
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 0c3c30c..0a1f949 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -145,6 +145,8 @@ u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
 int nvdimm_bus_check_dimm_count(struct nvdimm_bus *nvdimm_bus, int dimm_count);
 struct nd_region *nvdimm_pmem_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc);
+struct nd_region *nvdimm_vcd_region_create(struct nvdimm_bus *nvdimm_bus,
+		struct nd_region_desc *ndr_desc);
 struct nd_region *nvdimm_blk_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc);
 struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
