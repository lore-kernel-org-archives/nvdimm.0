Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED6A521F3B412
 for <linux-nvdimm@lists.01.org>; Sun, 29 Oct 2017 12:51:48 -0700 (PDT)
Subject: [PATCH 1/2] acpi, nfit: hide unknown commands from nmemX/commands
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 29 Oct 2017 12:49:13 -0700
Message-ID: <150930655324.21067.13218039967325456169.stgit@dwillia2-desk3.amr.corp.intel.com>
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
 drivers/acpi/nfit/core.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index ebe0857ac346..e0059949700d 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1769,8 +1769,22 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
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
+			cmd_mask |= nfit_mem->dsm_mask & (1 << ND_CMD_SMART
+					| 1 << ND_CMD_SMART_THRESHOLD
+					| 1 << ND_CMD_DIMM_FLAGS
+					| 1 << ND_CMD_GET_CONFIG_SIZE
+					| 1 << ND_CMD_GET_CONFIG_DATA
+					| 1 << ND_CMD_SET_CONFIG_DATA
+					| 1 << ND_CMD_VENDOR_EFFECT_LOG_SIZE
+					| 1 << ND_CMD_VENDOR_EFFECT_LOG
+					| 1 << ND_CMD_VENDOR);
+		}
 
 		if (nfit_mem->has_lsi)
 			set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
