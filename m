Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 875A822489CAE
 for <linux-nvdimm@lists.01.org>; Wed, 21 Mar 2018 15:41:53 -0700 (PDT)
Subject: [PATCH] libnvdimm, nfit: fix persistence domain reporting
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 21 Mar 2018 15:39:18 -0700
Message-ID: <152167195887.4609.5407001869524973776.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The persistence domain is a point in the platform where once writes
reach that destination the platform claims it will make them persistent
relative to power loss. In the ACPI NFIT this is currently communicated
as 2 bits in the "NFIT - Platform Capabilities Structure". The bits
comprise a hierarchy, i.e. bit0 "CPU Cache Flush to NVDIMM Durability on
Power Loss Capable" implies bit1 "Memory Controller Flush to NVDIMM
Durability on Power Loss Capable".

Commit 96c3a239054a "libnvdimm: expose platform persistence attr..."
shows the persistence domain as flags, but it's really an enumerated
hierarchy.

Fix this newly introduced user ABI to show the closest available
persistence domain before userspace develops dependencies on seeing, or
needing to develop code to tolerate, the raw NFIT flags communicated
through the libnvdimm-generic region attribute.

Fixes: 96c3a239054a ("libnvdimm: expose platform persistence attr...")
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c     |   10 +++++++---
 drivers/nvdimm/region_devs.c |   10 ++++++----
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index bbe48ad20886..eb09ef55c38a 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2675,10 +2675,14 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	else
 		ndr_desc->numa_node = NUMA_NO_NODE;
 
-	if(acpi_desc->platform_cap & ACPI_NFIT_CAPABILITY_CACHE_FLUSH)
+	/*
+	 * Persistence domain bits are hierarchical, if
+	 * ACPI_NFIT_CAPABILITY_CACHE_FLUSH is set then
+	 * ACPI_NFIT_CAPABILITY_MEM_FLUSH is implied.
+	 */
+	if (acpi_desc->platform_cap & ACPI_NFIT_CAPABILITY_CACHE_FLUSH)
 		set_bit(ND_REGION_PERSIST_CACHE, &ndr_desc->flags);
-
-	if (acpi_desc->platform_cap & ACPI_NFIT_CAPABILITY_MEM_FLUSH)
+	else if (acpi_desc->platform_cap & ACPI_NFIT_CAPABILITY_MEM_FLUSH)
 		set_bit(ND_REGION_PERSIST_MEMCTRL, &ndr_desc->flags);
 
 	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index a8e9d428c0a5..1593e1806b16 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -532,11 +532,13 @@ static ssize_t persistence_domain_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nd_region *nd_region = to_nd_region(dev);
-	unsigned long flags = nd_region->flags;
 
-	return sprintf(buf, "%s%s\n",
-			flags & BIT(ND_REGION_PERSIST_CACHE) ? "cpu_cache " : "",
-			flags & BIT(ND_REGION_PERSIST_MEMCTRL) ? "memory_controller " : "");
+	if (test_bit(ND_REGION_PERSIST_CACHE, &nd_region->flags))
+		return sprintf(buf, "cpu_cache\n");
+	else if (test_bit(ND_REGION_PERSIST_MEMCTRL, &nd_region->flags))
+		return sprintf(buf, "memory_controller\n");
+	else
+		return sprintf(buf, "\n");
 }
 static DEVICE_ATTR_RO(persistence_domain);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
