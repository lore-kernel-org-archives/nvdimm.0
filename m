Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 3ED911A1F6B
 for <linux-nvdimm@lists.01.org>; Thu, 28 Apr 2016 19:43:27 -0700 (PDT)
Subject: [PATCH v11 3/5] nfit: disable vendor specific commands
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Apr 2016 19:42:38 -0700
Message-ID: <146189775877.29835.10222495726082344157.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146189774241.29835.12947278159500915461.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146189774241.29835.12947278159500915461.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, rafael.j.wysocki@intel.com
List-ID: <linux-nvdimm@lists.01.org>

Module option to limit userspace to the publicly defined command set.
For cases where private DIMM commands may be interfering with the
kernel's handling of DIMM state this option can be set to block vendor
specific commands.

Cc: Jerry Hoemann <jerry.hoemann@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 710d3a07d178..30801fe3367b 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -45,6 +45,11 @@ module_param(scrub_overflow_abort, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(scrub_overflow_abort,
 		"Number of times we overflow ARS results before abort");
 
+static bool disable_vendor_specific;
+module_param(disable_vendor_specific, bool, S_IRUGO);
+MODULE_PARM_DESC(disable_vendor_specific,
+		"Limit commands to the publicly specified set\n");
+
 static struct workqueue_struct *nfit_wq;
 
 struct nfit_table_prev {
@@ -989,13 +994,17 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 
 	/* limit the supported commands to those that are publicly documented */
 	nfit_mem->family = i;
-	if (nfit_mem->family == NVDIMM_FAMILY_INTEL)
+	if (nfit_mem->family == NVDIMM_FAMILY_INTEL) {
 		dsm_mask = 0x3fe;
-	else if (nfit_mem->family == NVDIMM_FAMILY_HPE1)
+		if (disable_vendor_specific)
+			dsm_mask &= ~(1 << ND_CMD_VENDOR);
+	} else if (nfit_mem->family == NVDIMM_FAMILY_HPE1)
 		dsm_mask = 0x1c3c76;
-	else if (nfit_mem->family == NVDIMM_FAMILY_HPE2)
+	else if (nfit_mem->family == NVDIMM_FAMILY_HPE2) {
 		dsm_mask = 0x1fe;
-	else {
+		if (disable_vendor_specific)
+			dsm_mask &= ~(1 << 8);
+	} else {
 		dev_err(dev, "unknown dimm command family\n");
 		nfit_mem->family = -1;
 		return force_enable_dimms ? 0 : -ENODEV;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
