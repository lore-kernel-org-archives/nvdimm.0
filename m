Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C7C2211B76B1
 for <linux-nvdimm@lists.01.org>; Mon, 28 Jan 2019 21:34:48 -0800 (PST)
Subject: [PATCH] nfit: Fix nfit_intel_shutdown_status() command submission
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 28 Jan 2019 21:22:10 -0800
Message-ID: <154873933011.295327.10921465390915828081.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The implementation is broken in all the ways the unit test did not touch:

1/ The local definition of in_buf and in_obj violated C99 initializer
   expectations for zeroing. By only initializing 2 out of the three
   struct members the compiler was free to zero-initialize the remaining
   entry even though the aliased location in the union was initialized.

2/ The implementation made assumptions about the state of the 'smart'
   payload after command execution that are satisfied by
   acpi_nfit_ctl(), but not acpi_evaluate_dsm().

3/ populate_shutdown_status() is skipped on Intel NVDIMMs due to the early
   return for skipping the common _LS{I,R,W} enabling.

4/ The input length should be zero.

This breakage was missed due to the unit test implementation only
testing the case where nfit_intel_shutdown_status() returns a valid
payload.

Much of this complexity would be saved if acpi_nfit_ctl() could be used, but
that currently requires a 'struct nvdimm *' argument and one is not created
until later in the init process. The health result is needed before the device
is created because the payload gates whether the nmemX/nfit/dirty_shutdown
property is visible in sysfs.

Cc: <stable@vger.kernel.org>
Fixes: 0ead11181fe0 ("acpi, nfit: Collect shutdown status")
Reported-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index e18ade5d74e9..0a49c57334cc 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1759,14 +1759,14 @@ static bool acpi_nvdimm_has_method(struct acpi_device *adev, char *method)
 
 __weak void nfit_intel_shutdown_status(struct nfit_mem *nfit_mem)
 {
+	struct device *dev = &nfit_mem->adev->dev;
 	struct nd_intel_smart smart = { 0 };
 	union acpi_object in_buf = {
-		.type = ACPI_TYPE_BUFFER,
-		.buffer.pointer = (char *) &smart,
-		.buffer.length = sizeof(smart),
+		.buffer.type = ACPI_TYPE_BUFFER,
+		.buffer.length = 0,
 	};
 	union acpi_object in_obj = {
-		.type = ACPI_TYPE_PACKAGE,
+		.package.type = ACPI_TYPE_PACKAGE,
 		.package.count = 1,
 		.package.elements = &in_buf,
 	};
@@ -1781,8 +1781,15 @@ __weak void nfit_intel_shutdown_status(struct nfit_mem *nfit_mem)
 		return;
 
 	out_obj = acpi_evaluate_dsm(handle, guid, revid, func, &in_obj);
-	if (!out_obj)
+	if (!out_obj || out_obj->type != ACPI_TYPE_BUFFER
+			|| out_obj->buffer.length < sizeof(smart)) {
+		dev_dbg(dev->parent, "%s: failed to retrieve initial health\n",
+				dev_name(dev));
+		ACPI_FREE(out_obj);
 		return;
+	}
+	memcpy(&smart, out_obj->buffer.pointer, sizeof(smart));
+	ACPI_FREE(out_obj);
 
 	if (smart.flags & ND_INTEL_SMART_SHUTDOWN_VALID) {
 		if (smart.shutdown_state)
@@ -1793,7 +1800,6 @@ __weak void nfit_intel_shutdown_status(struct nfit_mem *nfit_mem)
 		set_bit(NFIT_MEM_DIRTY_COUNT, &nfit_mem->flags);
 		nfit_mem->dirty_shutdown = smart.shutdown_count;
 	}
-	ACPI_FREE(out_obj);
 }
 
 static void populate_shutdown_status(struct nfit_mem *nfit_mem)
@@ -1915,18 +1921,19 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		| 1 << ND_CMD_SET_CONFIG_DATA;
 	if (family == NVDIMM_FAMILY_INTEL
 			&& (dsm_mask & label_mask) == label_mask)
-		return 0;
-
-	if (acpi_nvdimm_has_method(adev_dimm, "_LSI")
-			&& acpi_nvdimm_has_method(adev_dimm, "_LSR")) {
-		dev_dbg(dev, "%s: has _LSR\n", dev_name(&adev_dimm->dev));
-		set_bit(NFIT_MEM_LSR, &nfit_mem->flags);
-	}
+		/* skip _LS{I,R,W} enabling */;
+	else {
+		if (acpi_nvdimm_has_method(adev_dimm, "_LSI")
+				&& acpi_nvdimm_has_method(adev_dimm, "_LSR")) {
+			dev_dbg(dev, "%s: has _LSR\n", dev_name(&adev_dimm->dev));
+			set_bit(NFIT_MEM_LSR, &nfit_mem->flags);
+		}
 
-	if (test_bit(NFIT_MEM_LSR, &nfit_mem->flags)
-			&& acpi_nvdimm_has_method(adev_dimm, "_LSW")) {
-		dev_dbg(dev, "%s: has _LSW\n", dev_name(&adev_dimm->dev));
-		set_bit(NFIT_MEM_LSW, &nfit_mem->flags);
+		if (test_bit(NFIT_MEM_LSR, &nfit_mem->flags)
+				&& acpi_nvdimm_has_method(adev_dimm, "_LSW")) {
+			dev_dbg(dev, "%s: has _LSW\n", dev_name(&adev_dimm->dev));
+			set_bit(NFIT_MEM_LSW, &nfit_mem->flags);
+		}
 	}
 
 	populate_shutdown_status(nfit_mem);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
