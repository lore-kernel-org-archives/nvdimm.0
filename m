Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C34D02193930C
 for <linux-nvdimm@lists.01.org>; Sat,  1 Apr 2017 12:30:30 -0700 (PDT)
Subject: [PATCH] acpi, nfit: fix acpi_get_table leak
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 01 Apr 2017 12:25:20 -0700
Message-ID: <149107472042.16205.8935477753191459036.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, Lv Zheng <lv.zheng@intel.com>, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Calls to acpi_get_table() must be paired with acpi_put_table() to undo
the mapping established by acpi_tb_acquire_table().

Cc: <stable@vger.kernel.org>
Fixes: 6b11d1d67713 ("ACPI / osl: Remove acpi_get_table_with_size()/early_acpi_os_unmap_memory() users")
Cc: Lv Zheng <lv.zheng@intel.com>
Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index c8ea9d698cd0..6acfea69f061 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2818,6 +2818,11 @@ void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(acpi_nfit_desc_init);
 
+static void acpi_nfit_put_table(void *table)
+{
+	acpi_put_table(table);
+}
+
 static int acpi_nfit_add(struct acpi_device *adev)
 {
 	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
@@ -2834,6 +2839,10 @@ static int acpi_nfit_add(struct acpi_device *adev)
 		dev_dbg(dev, "failed to find NFIT at startup\n");
 		return 0;
 	}
+
+	rc = devm_add_action_or_reset(dev, acpi_nfit_put_table, tbl);
+	if (rc)
+		return rc;
 	sz = tbl->length;
 
 	acpi_desc = devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
