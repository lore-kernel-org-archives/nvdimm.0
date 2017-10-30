Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7654C21F3B3E7
 for <linux-nvdimm@lists.01.org>; Mon, 30 Oct 2017 13:49:37 -0700 (PDT)
Subject: [PATCH v2 1/2] acpi, nfit: hide unknown commands from nmemX/commands
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 30 Oct 2017 13:47:03 -0700
Message-ID: <150939642330.4577.10714458271356489094.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150939641796.4577.379718469071595984.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150939641796.4577.379718469071595984.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

For vendor specific commands that do not have a common kernel
translation, hide them from nmemX/commands. For example, the following
results from new enabling to probe for support of the new
NVDIMM_FAMILY_INTEL DSMs specified in v1.6 of the command specification
[1]:

    # cat /sys/bus/nd/devices/nmem0/commands
    smart smart_thresh flags get_size get_data set_data effect_size
    effect_log vendor cmd_call unknown unknown unknown unknown unknown
    unknown unknown unknown

[1]: https://pmem.io/documents/NVDIMM_DSM_Interface-V1.6.pdf

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   10 ++++++++--
 drivers/acpi/nfit/nfit.h |    6 ++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index ebe0857ac346..444832b372ec 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1769,8 +1769,14 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		 * userspace interface.
 		 */
 		cmd_mask = 1UL << ND_CMD_CALL;
-		if (nfit_mem->family == NVDIMM_FAMILY_INTEL)
-			cmd_mask |= nfit_mem->dsm_mask;
+		if (nfit_mem->family == NVDIMM_FAMILY_INTEL) {
+			/*
+			 * These commands have a 1:1 correspondence
+			 * between DSM payload and libnvdimm ioctl
+			 * payload format.
+			 */
+			cmd_mask |= nfit_mem->dsm_mask & NVDIMM_STANDARD_CMDMASK;
+		}
 
 		if (nfit_mem->has_lsi)
 			set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 3976d649f27c..b987196bf132 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -38,6 +38,12 @@
 		| ACPI_NFIT_MEM_RESTORE_FAILED | ACPI_NFIT_MEM_FLUSH_FAILED \
 		| ACPI_NFIT_MEM_NOT_ARMED | ACPI_NFIT_MEM_MAP_FAILED)
 
+#define NVDIMM_STANDARD_CMDMASK \
+(1 << ND_CMD_SMART | 1 << ND_CMD_SMART_THRESHOLD | 1 << ND_CMD_DIMM_FLAGS \
+ | 1 << ND_CMD_GET_CONFIG_SIZE | 1 << ND_CMD_GET_CONFIG_DATA \
+ | 1 << ND_CMD_SET_CONFIG_DATA | 1 << ND_CMD_VENDOR_EFFECT_LOG_SIZE \
+ | 1 << ND_CMD_VENDOR_EFFECT_LOG | 1 << ND_CMD_VENDOR)
+
 enum nfit_uuids {
 	/* for simplicity alias the uuid index with the family id */
 	NFIT_DEV_DIMM = NVDIMM_FAMILY_INTEL,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
