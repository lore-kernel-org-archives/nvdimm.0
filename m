Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 03BF92110939E
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jun 2018 17:47:23 -0700 (PDT)
Subject: [PATCH 2/3] acpi,
 nfit: Prefer _DSM over _LSR for namespace label reads
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Jun 2018 17:37:25 -0700
Message-ID: <152902304504.10541.15111766266820956936.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152902303439.10541.13027910074116606464.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152902303439.10541.13027910074116606464.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The _LSR method indicates locked status via error-code-3 returned in the
_LSR payload. When any error is returned the payload of _LSR is
truncated to a zero-length buffer.

The _DSM path in comparison allows system software to retrieve the
locked status *and* namespace label area contents.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index e2235ed3e4be..5ce3b0221073 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1694,7 +1694,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 {
 	struct acpi_device *adev, *adev_dimm;
 	struct device *dev = acpi_desc->dev;
-	unsigned long dsm_mask;
+	unsigned long dsm_mask, label_mask;
 	const guid_t *guid;
 	int i;
 	int family = -1;
@@ -1766,6 +1766,16 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 					1ULL << i))
 			set_bit(i, &nfit_mem->dsm_mask);
 
+	/*
+	 * Prefer the NVDIMM_FAMILY_INTEL label read commands if present
+	 * due to their better semantics handling locked capacity.
+	 */
+	label_mask = 1 << ND_CMD_GET_CONFIG_SIZE | 1 << ND_CMD_GET_CONFIG_DATA
+		| 1 << ND_CMD_SET_CONFIG_DATA;
+	if (family == NVDIMM_FAMILY_INTEL
+			&& (dsm_mask & label_mask) == label_mask)
+		return 0;
+
 	if (acpi_nvdimm_has_method(adev_dimm, "_LSI")
 			&& acpi_nvdimm_has_method(adev_dimm, "_LSR")) {
 		dev_dbg(dev, "%s: has _LSR\n", dev_name(&adev_dimm->dev));

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
