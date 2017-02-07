Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F419A81F71
 for <linux-nvdimm@lists.01.org>; Tue,  7 Feb 2017 15:47:55 -0800 (PST)
Subject: [PATCH] acpi,
 nfit: skip ARS on machine-check-recovery capable platforms
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 07 Feb 2017 15:43:50 -0800
Message-ID: <148651103020.2605.2544850985469410207.stgit@dwillia2-desk3.amr.corp.intel.com>
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

If the platform supports machine-check-recovery then there is little
reason to kick off opportunistic scrubs to collect a media error list.
That initial scrub is only useful when it might prevent a kernel panic
from consuming poison (a media error from memory).

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |    6 ++++--
 drivers/acpi/nfit/mce.c  |    7 +++++++
 drivers/acpi/nfit/nfit.h |    5 +++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 7361d00818e2..bbefd9516939 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2500,10 +2500,12 @@ static void acpi_nfit_scrub(struct work_struct *work)
 	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
 		/*
 		 * Flag all the ranges that still need scrubbing, but
-		 * register them now to make data available.
+		 * register them now to make data available. If the
+		 * platform supports machine-check recovery then we skip
+		 * these opportunistic scans.
 		 */
 		if (!nfit_spa->nd_region) {
-			nfit_spa->ars_required = 1;
+			nfit_spa->ars_required = is_ars_required();
 			acpi_nfit_register_region(acpi_desc, nfit_spa);
 		}
 	}
diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
index e5ce81c38eed..1e6f1e7100f9 100644
--- a/drivers/acpi/nfit/mce.c
+++ b/drivers/acpi/nfit/mce.c
@@ -92,6 +92,13 @@ static struct notifier_block nfit_mce_dec = {
 	.notifier_call	= nfit_handle_mce,
 };
 
+bool is_ars_required(void)
+{
+        if (static_branch_unlikely(&mcsafe_key))
+                return false;
+	return true;
+}
+
 void nfit_mce_register(void)
 {
 	mce_register_decode_chain(&nfit_mce_dec);
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index fc29c2e9832e..925f2a3d896e 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -211,6 +211,7 @@ int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc);
 #ifdef CONFIG_X86_MCE
 void nfit_mce_register(void);
 void nfit_mce_unregister(void);
+bool is_ars_required(void);
 #else
 static inline void nfit_mce_register(void)
 {
@@ -218,6 +219,10 @@ static inline void nfit_mce_register(void)
 static inline void nfit_mce_unregister(void)
 {
 }
+static inline bool is_ars_required(void)
+{
+	return true;
+}
 #endif
 
 int nfit_spa_type(struct acpi_nfit_system_address *spa);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
