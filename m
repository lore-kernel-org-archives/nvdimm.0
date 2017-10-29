Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DBBC521F3B412
 for <linux-nvdimm@lists.01.org>; Sun, 29 Oct 2017 12:51:53 -0700 (PDT)
Subject: [PATCH 2/2] acpi, nfit: add support for NVDIMM_FAMILY_INTEL v1.6 DSMs
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 29 Oct 2017 12:49:18 -0700
Message-ID: <150930655869.21067.17370712774978208604.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150930654766.21067.7295669798909000270.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150930654766.21067.7295669798909000270.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Per v1.6 of the NVDIMM_FAMILY_INTEL command set [1] some of the new
commands require rev-id 2. In addition to enabling ND_CMD_CALL for these
new function numbers, add a lookup table for revision-ids by family
and function number.

[1]: http://pmem.io/documents/NVDIMM_DSM_Interface-V1.6.pdf

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
 drivers/acpi/nfit/nfit.h |   19 ++++++++++++++++++-
 2 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index e0059949700d..bef305080de3 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -370,6 +370,32 @@ static union acpi_object *acpi_label_info(acpi_handle handle)
 	return pkg_to_buf(buf.pointer);
 }
 
+static u8 nfit_dsm_revid(unsigned family, unsigned func)
+{
+	static const u8 revid_table[NVDIMM_FAMILY_MAX][32] = {
+		[NVDIMM_FAMILY_INTEL] = {
+			[NVDIMM_INTEL_GET_MODES] = 2,
+			[NVDIMM_INTEL_GET_FWINFO] = 2,
+			[NVDIMM_INTEL_START_FWUPDATE] = 2,
+			[NVDIMM_INTEL_SEND_FWUPDATE] = 2,
+			[NVDIMM_INTEL_FINISH_FWUPDATE] = 2,
+			[NVDIMM_INTEL_QUERY_FWUPDATE] = 2,
+			[NVDIMM_INTEL_SET_THRESHOLD] = 2,
+			[NVDIMM_INTEL_INJECT_ERROR] = 2,
+		},
+	};
+	u8 id;
+
+	if (family > NVDIMM_FAMILY_MAX)
+		return 0;
+	if (func > 31)
+		return 0;
+	id = revid_table[family][func];
+	if (id == 0)
+		return 1; /* default */
+	return id;
+}
+
 int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		unsigned int cmd, void *buf, unsigned int buf_len, int *cmd_rc)
 {
@@ -468,8 +494,15 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 
 		out_obj = acpi_label_write(handle, p->in_offset, p->in_length,
 				p->in_buf);
-	} else
-		out_obj = acpi_evaluate_dsm(handle, guid, 1, func, &in_obj);
+	} else {
+		u8 revid;
+
+		if (nfit_mem)
+			revid = nfit_dsm_revid(nfit_mem->family, func);
+		else
+			revid = 1;
+		out_obj = acpi_evaluate_dsm(handle, guid, revid, func, &in_obj);
+	}
 
 	if (!out_obj) {
 		dev_dbg(dev, "%s:%s _DSM failed cmd: %s\n", __func__, dimm_name,
@@ -1640,7 +1673,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	 * different command sets.  Note, that checking for function0 (bit0)
 	 * tells us if any commands are reachable through this GUID.
 	 */
-	for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_MSFT; i++)
+	for (i = 0; i <= NVDIMM_FAMILY_MAX; i++)
 		if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
 			if (family < 0 || i == default_dsm_family)
 				family = i;
@@ -1650,7 +1683,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	if (override_dsm_mask && !disable_vendor_specific)
 		dsm_mask = override_dsm_mask;
 	else if (nfit_mem->family == NVDIMM_FAMILY_INTEL) {
-		dsm_mask = 0x3fe;
+		dsm_mask = 0x7fbfe;
 		if (disable_vendor_specific)
 			dsm_mask &= ~(1 << ND_CMD_VENDOR);
 	} else if (nfit_mem->family == NVDIMM_FAMILY_HPE1) {
@@ -1670,7 +1703,9 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 
 	guid = to_nfit_uuid(nfit_mem->family);
 	for_each_set_bit(i, &dsm_mask, BITS_PER_LONG)
-		if (acpi_check_dsm(adev_dimm->handle, guid, 1, 1ULL << i))
+		if (acpi_check_dsm(adev_dimm->handle, guid,
+					nfit_dsm_revid(nfit_mem->family, i),
+					1ULL << i))
 			set_bit(i, &nfit_mem->dsm_mask);
 
 	obj = acpi_label_info(adev_dimm->handle);
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 3976d649f27c..a1f4086261f8 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -24,7 +24,7 @@
 /* ACPI 6.1 */
 #define UUID_NFIT_BUS "2f10e7a4-9e91-11e4-89d3-123b93f75cba"
 
-/* http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf */
+/* http://pmem.io/documents/NVDIMM_DSM_Interface-V1.6.pdf */
 #define UUID_NFIT_DIMM "4309ac30-0d11-11e4-9191-0800200c9a66"
 
 /* https://github.com/HewlettPackard/hpe-nvm/blob/master/Documentation/ */
@@ -38,6 +38,23 @@
 		| ACPI_NFIT_MEM_RESTORE_FAILED | ACPI_NFIT_MEM_FLUSH_FAILED \
 		| ACPI_NFIT_MEM_NOT_ARMED | ACPI_NFIT_MEM_MAP_FAILED)
 
+#define NVDIMM_FAMILY_MAX NVDIMM_FAMILY_MSFT
+
+/*
+ * Command numbers that the kernel needs to know about to handle
+ * non-default DSM revision ids
+ */
+enum nvdimm_family_cmds {
+	NVDIMM_INTEL_GET_MODES = 11,
+	NVDIMM_INTEL_GET_FWINFO = 12,
+	NVDIMM_INTEL_START_FWUPDATE = 13,
+	NVDIMM_INTEL_SEND_FWUPDATE = 14,
+	NVDIMM_INTEL_FINISH_FWUPDATE = 15,
+	NVDIMM_INTEL_QUERY_FWUPDATE = 16,
+	NVDIMM_INTEL_SET_THRESHOLD = 17,
+	NVDIMM_INTEL_INJECT_ERROR = 18,
+};
+
 enum nfit_uuids {
 	/* for simplicity alias the uuid index with the family id */
 	NFIT_DEV_DIMM = NVDIMM_FAMILY_INTEL,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
