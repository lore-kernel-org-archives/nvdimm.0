Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 05/10] ACPI: switch to use generic UUID API
Date: Wed, 17 Feb 2016 14:17:23 +0200
Message-Id: <1455711448-124103-6-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, David Airlie <airlied@linux.ie>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Mathias Nyman <mathias.nyman@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Lv Zheng <lv.zheng@intel.com>, Mark Brown <broonie@kernel.org>, Zhang Rui <rui.zhang@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org, linux-api@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Instead of opencoding the existing library functions let's use them directly.

The conversion fixes a potential bug in int340x_thermal as well since we have
to use memcmp() on binary data.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/acpi/acpi_extlog.c                        |  8 +++---
 drivers/acpi/bus.c                                | 29 ++-----------------
 drivers/acpi/nfit.c                               | 34 +++++++++++------------
 drivers/acpi/nfit.h                               |  3 +-
 drivers/acpi/utils.c                              |  4 +--
 drivers/char/tpm/tpm_crb.c                        |  9 +++---
 drivers/char/tpm/tpm_ppi.c                        | 20 ++++++-------
 drivers/gpu/drm/i915/intel_acpi.c                 | 14 ++++------
 drivers/gpu/drm/nouveau/nouveau_acpi.c            | 20 ++++++-------
 drivers/gpu/drm/nouveau/nvkm/subdev/mxm/base.c    |  9 +++---
 drivers/hid/i2c-hid/i2c-hid.c                     |  9 +++---
 drivers/iommu/dmar.c                              | 11 ++++----
 drivers/pci/pci-acpi.c                            | 11 ++++----
 drivers/pci/pci-label.c                           |  4 +--
 drivers/thermal/int340x_thermal/int3400_thermal.c |  6 ++--
 drivers/usb/host/xhci-pci.c                       |  9 +++---
 include/acpi/acpi_bus.h                           | 10 ++++---
 include/linux/acpi.h                              |  2 +-
 include/linux/pci-acpi.h                          |  2 +-
 sound/soc/intel/skylake/skl-nhlt.c                |  7 +++--
 20 files changed, 92 insertions(+), 129 deletions(-)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index b3842ff..a3a25ec 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -45,7 +45,9 @@ struct extlog_l1_head {
 
 static int old_edac_report_status;
 
-static u8 extlog_dsm_uuid[] __initdata = "663E35AF-CC10-41A4-88EA-5470AF055295";
+static uuid_le extlog_dsm_uuid __initdata =
+	UUID_LE(0x663E35AF, 0xCC10, 0x41A4,
+		0x88, 0xEA, 0x54, 0x70, 0xAF, 0x05, 0x52, 0x95);
 
 /* L1 table related physical address */
 static u64 elog_base;
@@ -182,12 +184,10 @@ out:
 
 static bool __init extlog_get_l1addr(void)
 {
-	u8 uuid[16];
+	uuid_le *uuid = &extlog_dsm_uuid;
 	acpi_handle handle;
 	union acpi_object *obj;
 
-	acpi_str_to_uuid(extlog_dsm_uuid, uuid);
-
 	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle)))
 		return false;
 	if (!acpi_check_dsm(handle, uuid, EXTLOG_DSM_REV, 1 << EXTLOG_FN_ADDR))
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 891c42d..80db48b 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -192,42 +192,19 @@ static void acpi_print_osc_error(acpi_handle handle,
 	printk("\n");
 }
 
-acpi_status acpi_str_to_uuid(char *str, u8 *uuid)
-{
-	int i;
-	static int opc_map_to_uuid[16] = {6, 4, 2, 0, 11, 9, 16, 14, 19, 21,
-		24, 26, 28, 30, 32, 34};
-
-	if (strlen(str) != 36)
-		return AE_BAD_PARAMETER;
-	for (i = 0; i < 36; i++) {
-		if (i == 8 || i == 13 || i == 18 || i == 23) {
-			if (str[i] != '-')
-				return AE_BAD_PARAMETER;
-		} else if (!isxdigit(str[i]))
-			return AE_BAD_PARAMETER;
-	}
-	for (i = 0; i < 16; i++) {
-		uuid[i] = hex_to_bin(str[opc_map_to_uuid[i]]) << 4;
-		uuid[i] |= hex_to_bin(str[opc_map_to_uuid[i] + 1]);
-	}
-	return AE_OK;
-}
-EXPORT_SYMBOL_GPL(acpi_str_to_uuid);
-
 acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context)
 {
 	acpi_status status;
 	struct acpi_object_list input;
 	union acpi_object in_params[4];
 	union acpi_object *out_obj;
-	u8 uuid[16];
+	uuid_le uuid;
 	u32 errors;
 	struct acpi_buffer output = {ACPI_ALLOCATE_BUFFER, NULL};
 
 	if (!context)
 		return AE_ERROR;
-	if (ACPI_FAILURE(acpi_str_to_uuid(context->uuid_str, uuid)))
+	if (uuid_le_to_bin(context->uuid_str, &uuid))
 		return AE_ERROR;
 	context->ret.length = ACPI_ALLOCATE_BUFFER;
 	context->ret.pointer = NULL;
@@ -237,7 +214,7 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context)
 	input.pointer = in_params;
 	in_params[0].type 		= ACPI_TYPE_BUFFER;
 	in_params[0].buffer.length 	= 16;
-	in_params[0].buffer.pointer	= uuid;
+	in_params[0].buffer.pointer	= (char *)&uuid;
 	in_params[1].type 		= ACPI_TYPE_INTEGER;
 	in_params[1].integer.value 	= context->rev;
 	in_params[2].type 		= ACPI_TYPE_INTEGER;
diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index ad6d8c6..3beb99b 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -43,11 +43,11 @@ struct nfit_table_prev {
 	struct list_head flushes;
 };
 
-static u8 nfit_uuid[NFIT_UUID_MAX][16];
+static uuid_le nfit_uuid[NFIT_UUID_MAX];
 
-const u8 *to_nfit_uuid(enum nfit_uuids id)
+const uuid_le *to_nfit_uuid(enum nfit_uuids id)
 {
-	return nfit_uuid[id];
+	return &nfit_uuid[id];
 }
 EXPORT_SYMBOL(to_nfit_uuid);
 
@@ -83,7 +83,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	const char *cmd_name, *dimm_name;
 	unsigned long dsm_mask;
 	acpi_handle handle;
-	const u8 *uuid;
+	const uuid_le *uuid;
 	u32 offset;
 	int rc, i;
 
@@ -225,7 +225,7 @@ static int nfit_spa_type(struct acpi_nfit_system_address *spa)
 	int i;
 
 	for (i = 0; i < NFIT_UUID_MAX; i++)
-		if (memcmp(to_nfit_uuid(i), spa->range_guid, 16) == 0)
+		if (!uuid_le_cmp(*to_nfit_uuid(i), *(uuid_le *)spa->range_guid))
 			return i;
 	return -1;
 }
@@ -829,7 +829,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 {
 	struct acpi_device *adev, *adev_dimm;
 	struct device *dev = acpi_desc->dev;
-	const u8 *uuid = to_nfit_uuid(NFIT_DEV_DIMM);
+	const uuid_le *uuid = to_nfit_uuid(NFIT_DEV_DIMM);
 	int i;
 
 	nfit_mem->dsm_mask = acpi_desc->dimm_dsm_force_en;
@@ -909,7 +909,7 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 {
 	struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
-	const u8 *uuid = to_nfit_uuid(NFIT_DEV_BUS);
+	const uuid_le *uuid = to_nfit_uuid(NFIT_DEV_BUS);
 	struct acpi_device *adev;
 	int i;
 
@@ -2079,16 +2079,16 @@ static __init int nfit_init(void)
 	BUILD_BUG_ON(sizeof(struct acpi_nfit_control_region) != 80);
 	BUILD_BUG_ON(sizeof(struct acpi_nfit_data_region) != 40);
 
-	acpi_str_to_uuid(UUID_VOLATILE_MEMORY, nfit_uuid[NFIT_SPA_VOLATILE]);
-	acpi_str_to_uuid(UUID_PERSISTENT_MEMORY, nfit_uuid[NFIT_SPA_PM]);
-	acpi_str_to_uuid(UUID_CONTROL_REGION, nfit_uuid[NFIT_SPA_DCR]);
-	acpi_str_to_uuid(UUID_DATA_REGION, nfit_uuid[NFIT_SPA_BDW]);
-	acpi_str_to_uuid(UUID_VOLATILE_VIRTUAL_DISK, nfit_uuid[NFIT_SPA_VDISK]);
-	acpi_str_to_uuid(UUID_VOLATILE_VIRTUAL_CD, nfit_uuid[NFIT_SPA_VCD]);
-	acpi_str_to_uuid(UUID_PERSISTENT_VIRTUAL_DISK, nfit_uuid[NFIT_SPA_PDISK]);
-	acpi_str_to_uuid(UUID_PERSISTENT_VIRTUAL_CD, nfit_uuid[NFIT_SPA_PCD]);
-	acpi_str_to_uuid(UUID_NFIT_BUS, nfit_uuid[NFIT_DEV_BUS]);
-	acpi_str_to_uuid(UUID_NFIT_DIMM, nfit_uuid[NFIT_DEV_DIMM]);
+	uuid_le_to_bin(UUID_VOLATILE_MEMORY, &nfit_uuid[NFIT_SPA_VOLATILE]);
+	uuid_le_to_bin(UUID_PERSISTENT_MEMORY, &nfit_uuid[NFIT_SPA_PM]);
+	uuid_le_to_bin(UUID_CONTROL_REGION, &nfit_uuid[NFIT_SPA_DCR]);
+	uuid_le_to_bin(UUID_DATA_REGION, &nfit_uuid[NFIT_SPA_BDW]);
+	uuid_le_to_bin(UUID_VOLATILE_VIRTUAL_DISK, &nfit_uuid[NFIT_SPA_VDISK]);
+	uuid_le_to_bin(UUID_VOLATILE_VIRTUAL_CD, &nfit_uuid[NFIT_SPA_VCD]);
+	uuid_le_to_bin(UUID_PERSISTENT_VIRTUAL_DISK, &nfit_uuid[NFIT_SPA_PDISK]);
+	uuid_le_to_bin(UUID_PERSISTENT_VIRTUAL_CD, &nfit_uuid[NFIT_SPA_PCD]);
+	uuid_le_to_bin(UUID_NFIT_BUS, &nfit_uuid[NFIT_DEV_BUS]);
+	uuid_le_to_bin(UUID_NFIT_DIMM, &nfit_uuid[NFIT_DEV_DIMM]);
 
 	return acpi_bus_register_driver(&acpi_nfit_driver);
 }
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 3d549a3..88b73e8 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -16,7 +16,6 @@
 #define __NFIT_H__
 #include <linux/libnvdimm.h>
 #include <linux/types.h>
-#include <linux/uuid.h>
 #include <linux/acpi.h>
 #include <acpi/acuuid.h>
 
@@ -180,7 +179,7 @@ static inline struct acpi_nfit_desc *to_acpi_desc(
 	return container_of(nd_desc, struct acpi_nfit_desc, nd_desc);
 }
 
-const u8 *to_nfit_uuid(enum nfit_uuids id);
+const uuid_le *to_nfit_uuid(enum nfit_uuids id);
 int acpi_nfit_init(struct acpi_nfit_desc *nfit, acpi_size sz);
 extern const struct attribute_group *acpi_nfit_attribute_groups[];
 #endif /* __NFIT_H__ */
diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index f2f9873..a56a995 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -629,7 +629,7 @@ acpi_status acpi_evaluate_lck(acpi_handle handle, int lock)
  * some old BIOSes do expect a buffer or an integer etc.
  */
 union acpi_object *
-acpi_evaluate_dsm(acpi_handle handle, const u8 *uuid, int rev, int func,
+acpi_evaluate_dsm(acpi_handle handle, const uuid_le *uuid, int rev, int func,
 		  union acpi_object *argv4)
 {
 	acpi_status ret;
@@ -678,7 +678,7 @@ EXPORT_SYMBOL(acpi_evaluate_dsm);
  * functions. Currently only support 64 functions at maximum, should be
  * enough for now.
  */
-bool acpi_check_dsm(acpi_handle handle, const u8 *uuid, int rev, u64 funcs)
+bool acpi_check_dsm(acpi_handle handle, const uuid_le *uuid, int rev, u64 funcs)
 {
 	int i;
 	u64 mask = 0;
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 916332c..57e6e82 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -24,10 +24,9 @@
 
 #define ACPI_SIG_TPM2 "TPM2"
 
-static const u8 CRB_ACPI_START_UUID[] = {
-	/* 0000 */ 0xAB, 0x6C, 0xBF, 0x6B, 0x63, 0x54, 0x14, 0x47,
-	/* 0008 */ 0xB7, 0xCD, 0xF0, 0x20, 0x3C, 0x03, 0x68, 0xD4
-};
+static const uuid_le crb_acpi_start_uuid =
+	UUID_LE(0x6BBF6CAB, 0x5463, 0x4714,
+		0xB7, 0xCD, 0xF0, 0x20, 0x3C, 0x03, 0x68, 0xD4);
 
 enum crb_defaults {
 	CRB_ACPI_START_REVISION_ID = 1,
@@ -127,7 +126,7 @@ static int crb_do_acpi_start(struct tpm_chip *chip)
 	int rc;
 
 	obj = acpi_evaluate_dsm(chip->acpi_dev_handle,
-				CRB_ACPI_START_UUID,
+				&crb_acpi_start_uuid,
 				CRB_ACPI_START_REVISION_ID,
 				CRB_ACPI_START_INDEX,
 				NULL);
diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 692a2c6..7cf6824 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -32,20 +32,16 @@
 #define PPI_VS_REQ_START	128
 #define PPI_VS_REQ_END		255
 
-static const u8 tpm_ppi_uuid[] = {
-	0xA6, 0xFA, 0xDD, 0x3D,
-	0x1B, 0x36,
-	0xB4, 0x4E,
-	0xA4, 0x24,
-	0x8D, 0x10, 0x08, 0x9D, 0x16, 0x53
-};
+static const uuid_le tpm_ppi_uuid =
+	UUID_LE(0x3DDDFAA6, 0x361B, 0x4EB4,
+		0xA4, 0x24, 0x8D, 0x10, 0x08, 0x9D, 0x16, 0x53);
 
 static inline union acpi_object *
 tpm_eval_dsm(acpi_handle ppi_handle, int func, acpi_object_type type,
 	     union acpi_object *argv4)
 {
 	BUG_ON(!ppi_handle);
-	return acpi_evaluate_dsm_typed(ppi_handle, tpm_ppi_uuid,
+	return acpi_evaluate_dsm_typed(ppi_handle, &tpm_ppi_uuid,
 				       TPM_PPI_REVISION_ID,
 				       func, argv4, type);
 }
@@ -107,7 +103,7 @@ static ssize_t tpm_store_ppi_request(struct device *dev,
 	 * is updated with function index from SUBREQ to SUBREQ2 since PPI
 	 * version 1.1
 	 */
-	if (acpi_check_dsm(chip->acpi_dev_handle, tpm_ppi_uuid,
+	if (acpi_check_dsm(chip->acpi_dev_handle, &tpm_ppi_uuid,
 			   TPM_PPI_REVISION_ID, 1 << TPM_PPI_FN_SUBREQ2))
 		func = TPM_PPI_FN_SUBREQ2;
 
@@ -268,7 +264,7 @@ static ssize_t show_ppi_operations(acpi_handle dev_handle, char *buf, u32 start,
 		"User not required",
 	};
 
-	if (!acpi_check_dsm(dev_handle, tpm_ppi_uuid, TPM_PPI_REVISION_ID,
+	if (!acpi_check_dsm(dev_handle, &tpm_ppi_uuid, TPM_PPI_REVISION_ID,
 			    1 << TPM_PPI_FN_GETOPR))
 		return -EPERM;
 
@@ -341,12 +337,12 @@ void tpm_add_ppi(struct tpm_chip *chip)
 	if (!chip->acpi_dev_handle)
 		return;
 
-	if (!acpi_check_dsm(chip->acpi_dev_handle, tpm_ppi_uuid,
+	if (!acpi_check_dsm(chip->acpi_dev_handle, &tpm_ppi_uuid,
 			    TPM_PPI_REVISION_ID, 1 << TPM_PPI_FN_VERSION))
 		return;
 
 	/* Cache PPI version string. */
-	obj = acpi_evaluate_dsm_typed(chip->acpi_dev_handle, tpm_ppi_uuid,
+	obj = acpi_evaluate_dsm_typed(chip->acpi_dev_handle, &tpm_ppi_uuid,
 				      TPM_PPI_REVISION_ID, TPM_PPI_FN_VERSION,
 				      NULL, ACPI_TYPE_STRING);
 	if (obj) {
diff --git a/drivers/gpu/drm/i915/intel_acpi.c b/drivers/gpu/drm/i915/intel_acpi.c
index eb638a1..72bfe6c 100644
--- a/drivers/gpu/drm/i915/intel_acpi.c
+++ b/drivers/gpu/drm/i915/intel_acpi.c
@@ -15,13 +15,9 @@ static struct intel_dsm_priv {
 	acpi_handle dhandle;
 } intel_dsm_priv;
 
-static const u8 intel_dsm_guid[] = {
-	0xd3, 0x73, 0xd8, 0x7e,
-	0xd0, 0xc2,
-	0x4f, 0x4e,
-	0xa8, 0x54,
-	0x0f, 0x13, 0x17, 0xb0, 0x1c, 0x2c
-};
+static const uuid_le intel_dsm_guid =
+	UUID_LE(0x7ed873d3, 0xc2d0, 0x4e4f,
+		0xa8, 0x54, 0x0f, 0x13, 0x17, 0xb0, 0x1c, 0x2c);
 
 static char *intel_dsm_port_name(u8 id)
 {
@@ -80,7 +76,7 @@ static void intel_dsm_platform_mux_info(void)
 	int i;
 	union acpi_object *pkg, *connector_count;
 
-	pkg = acpi_evaluate_dsm_typed(intel_dsm_priv.dhandle, intel_dsm_guid,
+	pkg = acpi_evaluate_dsm_typed(intel_dsm_priv.dhandle, &intel_dsm_guid,
 			INTEL_DSM_REVISION_ID, INTEL_DSM_FN_PLATFORM_MUX_INFO,
 			NULL, ACPI_TYPE_PACKAGE);
 	if (!pkg) {
@@ -118,7 +114,7 @@ static bool intel_dsm_pci_probe(struct pci_dev *pdev)
 	if (!dhandle)
 		return false;
 
-	if (!acpi_check_dsm(dhandle, intel_dsm_guid, INTEL_DSM_REVISION_ID,
+	if (!acpi_check_dsm(dhandle, &intel_dsm_guid, INTEL_DSM_REVISION_ID,
 			    1 << INTEL_DSM_FN_PLATFORM_MUX_INFO)) {
 		DRM_DEBUG_KMS("no _DSM method for intel device\n");
 		return false;
diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index cdf5227..52ee9a3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -61,15 +61,13 @@ bool nouveau_is_v1_dsm(void) {
 #define NOUVEAU_DSM_HAS_OPT 0x2
 
 #ifdef CONFIG_VGA_SWITCHEROO
-static const char nouveau_dsm_muid[] = {
-	0xA0, 0xA0, 0x95, 0x9D, 0x60, 0x00, 0x48, 0x4D,
-	0xB3, 0x4D, 0x7E, 0x5F, 0xEA, 0x12, 0x9F, 0xD4,
-};
+static const uuid_le nouveau_dsm_muid =
+	UUID_LE(0x9D95A0A0, 0x0060, 0x4D48,
+		0xB3, 0x4D, 0x7E, 0x5F, 0xEA, 0x12, 0x9F, 0xD4);
 
-static const char nouveau_op_dsm_muid[] = {
-	0xF8, 0xD8, 0x86, 0xA4, 0xDA, 0x0B, 0x1B, 0x47,
-	0xA7, 0x2B, 0x60, 0x42, 0xA6, 0xB5, 0xBE, 0xE0,
-};
+static const uuid_le nouveau_op_dsm_muid =
+	UUID_LE(0xA486D8F8, 0x0BDA, 0x471B,
+		0xA7, 0x2B, 0x60, 0x42, 0xA6, 0xB5, 0xBE, 0xE0);
 
 static int nouveau_optimus_dsm(acpi_handle handle, int func, int arg, uint32_t *result)
 {
@@ -87,7 +85,7 @@ static int nouveau_optimus_dsm(acpi_handle handle, int func, int arg, uint32_t *
 		args_buff[i] = (arg >> i * 8) & 0xFF;
 
 	*result = 0;
-	obj = acpi_evaluate_dsm_typed(handle, nouveau_op_dsm_muid, 0x00000100,
+	obj = acpi_evaluate_dsm_typed(handle, &nouveau_op_dsm_muid, 0x00000100,
 				      func, &argv4, ACPI_TYPE_BUFFER);
 	if (!obj) {
 		acpi_handle_info(handle, "failed to evaluate _DSM\n");
@@ -137,7 +135,7 @@ static int nouveau_dsm(acpi_handle handle, int func, int arg)
 		.integer.value = arg,
 	};
 
-	obj = acpi_evaluate_dsm_typed(handle, nouveau_dsm_muid, 0x00000102,
+	obj = acpi_evaluate_dsm_typed(handle, &nouveau_dsm_muid, 0x00000102,
 				      func, &argv4, ACPI_TYPE_INTEGER);
 	if (!obj) {
 		acpi_handle_info(handle, "failed to evaluate _DSM\n");
@@ -224,7 +222,7 @@ static int nouveau_dsm_pci_probe(struct pci_dev *pdev)
 	if (!acpi_has_method(dhandle, "_DSM"))
 		return false;
 
-	if (acpi_check_dsm(dhandle, nouveau_dsm_muid, 0x00000102,
+	if (acpi_check_dsm(dhandle, &nouveau_dsm_muid, 0x00000102,
 			   1 << NOUVEAU_DSM_POWER))
 		retval |= NOUVEAU_DSM_HAS_MUX;
 
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/mxm/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/mxm/base.c
index 9700a76..5fe45e9 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/mxm/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/mxm/base.c
@@ -81,10 +81,9 @@ mxm_shadow_dsm(struct nvkm_mxm *mxm, u8 version)
 {
 	struct nvkm_subdev *subdev = &mxm->subdev;
 	struct nvkm_device *device = subdev->device;
-	static char muid[] = {
-		0x00, 0xA4, 0x04, 0x40, 0x7D, 0x91, 0xF2, 0x4C,
-		0xB8, 0x9C, 0x79, 0xB6, 0x2F, 0xD5, 0x56, 0x65
-	};
+	static uuid_le muid =
+		UUID_LE(0x4004A400, 0x917D, 0x4CF2,
+			0xB8, 0x9C, 0x79, 0xB6, 0x2F, 0xD5, 0x56, 0x65);
 	u32 mxms_args[] = { 0x00000000 };
 	union acpi_object argv4 = {
 		.buffer.type = ACPI_TYPE_BUFFER,
@@ -105,7 +104,7 @@ mxm_shadow_dsm(struct nvkm_mxm *mxm, u8 version)
 	 * unless you pass in exactly the version it supports..
 	 */
 	rev = (version & 0xf0) << 4 | (version & 0x0f);
-	obj = acpi_evaluate_dsm(handle, muid, rev, 0x00000010, &argv4);
+	obj = acpi_evaluate_dsm(handle, &muid, rev, 0x00000010, &argv4);
 	if (!obj) {
 		nvkm_debug(subdev, "DSM MXMS failed\n");
 		return false;
diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index b921693..291bacf 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -871,10 +871,9 @@ static const struct acpi_gpio_mapping i2c_hid_acpi_gpios[] = {
 static int i2c_hid_acpi_pdata(struct i2c_client *client,
 		struct i2c_hid_platform_data *pdata)
 {
-	static u8 i2c_hid_guid[] = {
-		0xF7, 0xF6, 0xDF, 0x3C, 0x67, 0x42, 0x55, 0x45,
-		0xAD, 0x05, 0xB3, 0x0A, 0x3D, 0x89, 0x38, 0xDE,
-	};
+	static uuid_le i2c_hid_guid =
+		UUID_LE(0x3CDFF6F7, 0x4267, 0x4555,
+			0xAD, 0x05, 0xB3, 0x0A, 0x3D, 0x89, 0x38, 0xDE);
 	union acpi_object *obj;
 	struct acpi_device *adev;
 	acpi_handle handle;
@@ -884,7 +883,7 @@ static int i2c_hid_acpi_pdata(struct i2c_client *client,
 	if (!handle || acpi_bus_get_device(handle, &adev))
 		return -ENODEV;
 
-	obj = acpi_evaluate_dsm_typed(handle, i2c_hid_guid, 1, 1, NULL,
+	obj = acpi_evaluate_dsm_typed(handle, &i2c_hid_guid, 1, 1, NULL,
 				      ACPI_TYPE_INTEGER);
 	if (!obj) {
 		dev_err(&client->dev, "device _DSM execution failed\n");
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index fb092f3..1b4509e 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1783,10 +1783,9 @@ IOMMU_INIT_POST(detect_intel_iommu);
  * for Directed-IO Architecture Specifiction, Rev 2.2, Section 8.8
  * "Remapping Hardware Unit Hot Plug".
  */
-static u8 dmar_hp_uuid[] = {
-	/* 0000 */    0xA6, 0xA3, 0xC1, 0xD8, 0x9B, 0xBE, 0x9B, 0x4C,
-	/* 0008 */    0x91, 0xBF, 0xC3, 0xCB, 0x81, 0xFC, 0x5D, 0xAF
-};
+static uuid_le dmar_hp_uuid =
+	UUID_LE(0xD8C1A3A6, 0xBE9B, 0x4C9B,
+		0x91, 0xBF, 0xC3, 0xCB, 0x81, 0xFC, 0x5D, 0xAF);
 
 /*
  * Currently there's only one revision and BIOS will not check the revision id,
@@ -1799,7 +1798,7 @@ static u8 dmar_hp_uuid[] = {
 
 static inline bool dmar_detect_dsm(acpi_handle handle, int func)
 {
-	return acpi_check_dsm(handle, dmar_hp_uuid, DMAR_DSM_REV_ID, 1 << func);
+	return acpi_check_dsm(handle, &dmar_hp_uuid, DMAR_DSM_REV_ID, 1 << func);
 }
 
 static int dmar_walk_dsm_resource(acpi_handle handle, int func,
@@ -1818,7 +1817,7 @@ static int dmar_walk_dsm_resource(acpi_handle handle, int func,
 	if (!dmar_detect_dsm(handle, func))
 		return 0;
 
-	obj = acpi_evaluate_dsm_typed(handle, dmar_hp_uuid, DMAR_DSM_REV_ID,
+	obj = acpi_evaluate_dsm_typed(handle, &dmar_hp_uuid, DMAR_DSM_REV_ID,
 				      func, NULL, ACPI_TYPE_BUFFER);
 	if (!obj)
 		return -ENODEV;
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 9a033e8..c129da3 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -24,10 +24,9 @@
  * The UUID is defined in the PCI Firmware Specification available here:
  * https://www.pcisig.com/members/downloads/pcifw_r3_1_13Dec10.pdf
  */
-const u8 pci_acpi_dsm_uuid[] = {
-	0xd0, 0x37, 0xc9, 0xe5, 0x53, 0x35, 0x7a, 0x4d,
-	0x91, 0x17, 0xea, 0x4d, 0x19, 0xc3, 0x43, 0x4d
-};
+const uuid_le pci_acpi_dsm_uuid =
+	UUID_LE(0xe5c937d0, 0x3553, 0x4d7a,
+		0x91, 0x17, 0xea, 0x4d, 0x19, 0xc3, 0x43, 0x4d);
 
 phys_addr_t acpi_pci_root_get_mcfg_addr(acpi_handle handle)
 {
@@ -558,7 +557,7 @@ void acpi_pci_add_bus(struct pci_bus *bus)
 	if (!pci_is_root_bus(bus))
 		return;
 
-	obj = acpi_evaluate_dsm(ACPI_HANDLE(bus->bridge), pci_acpi_dsm_uuid, 3,
+	obj = acpi_evaluate_dsm(ACPI_HANDLE(bus->bridge), &pci_acpi_dsm_uuid, 3,
 				RESET_DELAY_DSM, NULL);
 	if (!obj)
 		return;
@@ -623,7 +622,7 @@ static void pci_acpi_optimize_delay(struct pci_dev *pdev,
 	if (bridge->ignore_reset_delay)
 		pdev->d3cold_delay = 0;
 
-	obj = acpi_evaluate_dsm(handle, pci_acpi_dsm_uuid, 3,
+	obj = acpi_evaluate_dsm(handle, &pci_acpi_dsm_uuid, 3,
 				FUNCTION_DELAY_DSM, NULL);
 	if (!obj)
 		return;
diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index 0ae74d9..05d94d7 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -172,7 +172,7 @@ static int dsm_get_label(struct device *dev, char *buf,
 	if (!handle)
 		return -1;
 
-	obj = acpi_evaluate_dsm(handle, pci_acpi_dsm_uuid, 0x2,
+	obj = acpi_evaluate_dsm(handle, &pci_acpi_dsm_uuid, 0x2,
 				DEVICE_LABEL_DSM, NULL);
 	if (!obj)
 		return -1;
@@ -212,7 +212,7 @@ static bool device_has_dsm(struct device *dev)
 	if (!handle)
 		return false;
 
-	return !!acpi_check_dsm(handle, pci_acpi_dsm_uuid, 0x2,
+	return !!acpi_check_dsm(handle, &pci_acpi_dsm_uuid, 0x2,
 				1 << DEVICE_LABEL_DSM);
 }
 
diff --git a/drivers/thermal/int340x_thermal/int3400_thermal.c b/drivers/thermal/int340x_thermal/int3400_thermal.c
index 5836e55..47f54bc 100644
--- a/drivers/thermal/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/int340x_thermal/int3400_thermal.c
@@ -141,10 +141,10 @@ static int int3400_thermal_get_uuids(struct int3400_thermal_priv *priv)
 		}
 
 		for (j = 0; j < INT3400_THERMAL_MAXIMUM_UUID; j++) {
-			u8 uuid[16];
+			uuid_le u;
 
-			acpi_str_to_uuid(int3400_thermal_uuids[j], uuid);
-			if (!strncmp(uuid, objb->buffer.pointer, 16)) {
+			uuid_le_to_bin(int3400_thermal_uuids[j], &u);
+			if (!uuid_le_cmp(u, *(uuid_le *)objb->buffer.pointer)) {
 				priv->uuid_bitmap |= (1 << j);
 				break;
 			}
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index f0640b7..4290e94 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -191,13 +191,12 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 #ifdef CONFIG_ACPI
 static void xhci_pme_acpi_rtd3_enable(struct pci_dev *dev)
 {
-	static const u8 intel_dsm_uuid[] = {
-		0xb7, 0x0c, 0x34, 0xac,	0x01, 0xe9, 0xbf, 0x45,
-		0xb7, 0xe6, 0x2b, 0x34, 0xec, 0x93, 0x1e, 0x23,
-	};
+	static const uuid_le intel_dsm_uuid =
+		UUID_LE(0xac340cb7, 0xe901, 0x45bf,
+			0xb7, 0xe6, 0x2b, 0x34, 0xec, 0x93, 0x1e, 0x23);
 	union acpi_object *obj;
 
-	obj = acpi_evaluate_dsm(ACPI_HANDLE(&dev->dev), intel_dsm_uuid, 3, 1,
+	obj = acpi_evaluate_dsm(ACPI_HANDLE(&dev->dev), &intel_dsm_uuid, 3, 1,
 				NULL);
 	ACPI_FREE(obj);
 }
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 14362a8..b4b6fa2 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -61,13 +61,15 @@ bool acpi_ata_match(acpi_handle handle);
 bool acpi_bay_match(acpi_handle handle);
 bool acpi_dock_match(acpi_handle handle);
 
-bool acpi_check_dsm(acpi_handle handle, const u8 *uuid, int rev, u64 funcs);
-union acpi_object *acpi_evaluate_dsm(acpi_handle handle, const u8 *uuid,
+bool acpi_check_dsm(acpi_handle handle, const uuid_le *uuid, int rev,
+		    u64 funcs);
+union acpi_object *acpi_evaluate_dsm(acpi_handle handle, const uuid_le *uuid,
 			int rev, int func, union acpi_object *argv4);
 
 static inline union acpi_object *
-acpi_evaluate_dsm_typed(acpi_handle handle, const u8 *uuid, int rev, int func,
-			union acpi_object *argv4, acpi_object_type type)
+acpi_evaluate_dsm_typed(acpi_handle handle, const uuid_le *uuid, int rev,
+			int func, union acpi_object *argv4,
+			acpi_object_type type)
 {
 	union acpi_object *obj;
 
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 06ed7e5..7d1939d 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -39,6 +39,7 @@
 #include <linux/dynamic_debug.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/uuid.h>
 
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
@@ -430,7 +431,6 @@ struct acpi_osc_context {
 	struct acpi_buffer ret;		/* free by caller if success */
 };
 
-acpi_status acpi_str_to_uuid(char *str, u8 *uuid);
 acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 
 /* Indexes into _OSC Capabilities Buffer (DWORDs 2 & 3 are device-specific) */
diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
index 89ab057..861a779 100644
--- a/include/linux/pci-acpi.h
+++ b/include/linux/pci-acpi.h
@@ -101,7 +101,7 @@ static inline void acpiphp_remove_slots(struct pci_bus *bus) { }
 static inline void acpiphp_check_host_bridge(struct acpi_device *adev) { }
 #endif
 
-extern const u8 pci_acpi_dsm_uuid[];
+extern const uuid_le pci_acpi_dsm_uuid;
 #define DEVICE_LABEL_DSM	0x07
 #define RESET_DELAY_DSM		0x08
 #define FUNCTION_DELAY_DSM	0x09
diff --git a/sound/soc/intel/skylake/skl-nhlt.c b/sound/soc/intel/skylake/skl-nhlt.c
index 6e4b21c..ac1b641 100644
--- a/sound/soc/intel/skylake/skl-nhlt.c
+++ b/sound/soc/intel/skylake/skl-nhlt.c
@@ -20,8 +20,9 @@
 #include "skl.h"
 
 /* Unique identification for getting NHLT blobs */
-static u8 OSC_UUID[16] = {0x6E, 0x88, 0x9F, 0xA6, 0xEB, 0x6C, 0x94, 0x45,
-				0xA4, 0x1F, 0x7B, 0x5D, 0xCE, 0x24, 0xC5, 0x53};
+static uuid_le osc_uuid =
+	UUID_LE(0xA69F886E, 0x6CEB, 0x4594,
+		0xA4, 0x1F, 0x7B, 0x5D, 0xCE, 0x24, 0xC5, 0x53);
 
 #define DSDT_NHLT_PATH "\\_SB.PCI0.HDAS"
 
@@ -36,7 +37,7 @@ void *skl_nhlt_init(struct device *dev)
 		return NULL;
 	}
 
-	obj = acpi_evaluate_dsm(handle, OSC_UUID, 1, 1, NULL);
+	obj = acpi_evaluate_dsm(handle, &osc_uuid, 1, 1, NULL);
 	if (obj && obj->type == ACPI_TYPE_BUFFER) {
 		nhlt_ptr = (struct nhlt_resource_desc  *)obj->buffer.pointer;
 
-- 
2.7.0
