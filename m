Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 791362215BD8E
 for <linux-nvdimm@lists.01.org>; Tue, 30 Jan 2018 15:55:44 -0800 (PST)
Subject: [PATCH v3 2/4] acpi: nfit: add persistent memory control flag for
 nd_region
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 30 Jan 2018 17:01:18 -0700
Message-ID: <151735687890.34477.10539808986417857457.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151735668391.34477.11820724492631561208.stgit@djiang5-desk3.ch.intel.com>
References: <151735668391.34477.11820724492631561208.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Propagate the ADR attribute flag from the NFIT platform capabilities
sub-table to nd_region.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/core.c  |    3 +++
 include/linux/libnvdimm.h |    6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index bcf52bb93b65..b1616120ca57 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2668,6 +2668,9 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	if(acpi_desc->platform_cap & ACPI_NFIT_CAPABILITY_CACHE_FLUSH)
 		set_bit(ND_REGION_PERSIST_CACHE, &ndr_desc->flags);
 
+	if (acpi_desc->platform_cap & ACPI_NFIT_CAPABILITY_MEM_FLUSH)
+		set_bit(ND_REGION_PERSIST_MEMCTRL, &ndr_desc->flags);
+
 	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
 		struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
 		struct nd_mapping_desc *mapping;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index f2fc0da4da04..ff855ed965fb 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -52,6 +52,12 @@ enum {
 	 * system power loss.
 	 */
 	ND_REGION_PERSIST_CACHE = 1,
+	/*
+	 * Platform provides mechanisms to automatically flush outstanding
+	 * write data from memory controler to pmem on system power loss.
+	 * (ADR)
+	 */
+	ND_REGION_PERSIST_MEMCTRL = 2,
 
 	/* mark newly adjusted resources as requiring a label update */
 	DPA_RESOURCE_ADJUSTED = 1 << 0,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
