Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3428.houston.hp.com (g4t3428.houston.hp.com [15.201.208.56])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B57C61A1F68
 for <linux-nvdimm@lists.01.org>; Wed,  9 Mar 2016 10:54:55 -0800 (PST)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 4/4] ACPI: Change NFIT driver to insert new resource
Date: Wed,  9 Mar 2016 12:47:06 -0700
Message-Id: <1457552826-13987-4-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1457552826-13987-1-git-send-email-toshi.kani@hpe.com>
References: <1457552826-13987-1-git-send-email-toshi.kani@hpe.com>
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
To: mingo@kernel.org, bp@suse.de, dan.j.williams@intel.com, rjw@rjwysocki.net, akpm@linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6 defines persistent memory (PMEM) ranges in multiple
firmware interfaces, e820, EFI, and ACPI NFIT table.  This EFI
change, however, leads to hit a bug in the grub bootloader, which
treats EFI_PERSISTENT_MEMORY type as regular memory and corrupts
stored user data [1].

Therefore, BIOS may set generic reserved type in e820 and EFI to
cover PMEM ranges.  The kernel can initialize PMEM ranges from
ACPI NFIT table alone.

This scheme causes a problem in the iomem table, though.  On x86,
for instance, e820_reserve_resources() initializes top-level entries
(iomem_resource.child) from the e820 table at early boot-time.
This creates "reserved" entry for a PMEM range, which does not allow
region_intersects() to check with PMEM type.

Change acpi_nfit_register_region() to call acpi_nfit_insert_resource(),
which calls insert_resource() to insert a PMEM entry from NFIT when
the iomem table does not have a PMEM entry already.  That is, when
a PMEM range is marked as reserved type in e820, it inserts
"Persistent Memory" entry, which results as follows.

 + "Persistent Memory"
    + "reserved"

This allows the EINJ driver, which calls region_intersects() to check
PMEM ranges, to work continuously even if BIOS sets reserved type
(or sets nothing) to PMEM ranges in e820 and EFI.

[1]: https://lists.gnu.org/archive/html/grub-devel/2015-11/msg00209.html
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/acpi/nfit.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 35947ac..d5c78f2 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1571,6 +1571,48 @@ static int ars_status_process_records(struct nvdimm_bus *nvdimm_bus,
 	return 0;
 }
 
+static void acpi_nfit_remove_resource(void *data)
+{
+	struct resource *res = data;
+
+	remove_resource(res);
+}
+
+static int acpi_nfit_insert_resource(struct acpi_nfit_desc *acpi_desc,
+		struct nd_region_desc *ndr_desc)
+{
+	struct resource *res, *nd_res = ndr_desc->res;
+	int is_pmem, ret;
+
+	/* No operation if the region is already registered as PMEM */
+	is_pmem = region_intersects(nd_res->start, resource_size(nd_res),
+				IORESOURCE_MEM, IORES_DESC_PERSISTENT_MEMORY);
+	if (is_pmem == REGION_INTERSECTS)
+		return 0;
+
+	res = devm_kzalloc(acpi_desc->dev, sizeof(*res), GFP_KERNEL);
+	if (!res)
+		return -ENOMEM;
+
+	res->name = "Persistent Memory";
+	res->start = nd_res->start;
+	res->end = nd_res->end;
+	res->flags = IORESOURCE_MEM;
+	res->desc = IORES_DESC_PERSISTENT_MEMORY;
+
+	ret = insert_resource(&iomem_resource, res);
+	if (ret)
+		return ret;
+
+	ret = devm_add_action(acpi_desc->dev, acpi_nfit_remove_resource, res);
+	if (ret) {
+		remove_resource(res);
+		return ret;
+	}
+
+	return 0;
+}
+
 static int acpi_nfit_find_poison(struct acpi_nfit_desc *acpi_desc,
 		struct nd_region_desc *ndr_desc)
 {
@@ -1788,6 +1830,12 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 
 	nvdimm_bus = acpi_desc->nvdimm_bus;
 	if (nfit_spa_type(spa) == NFIT_SPA_PM) {
+		rc = acpi_nfit_insert_resource(acpi_desc, ndr_desc);
+		if (rc)
+			dev_warn(acpi_desc->dev,
+				"failed to insert pmem resource to iomem: %d\n",
+				rc);
+
 		rc = acpi_nfit_find_poison(acpi_desc, ndr_desc);
 		if (rc) {
 			dev_err(acpi_desc->dev,
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
