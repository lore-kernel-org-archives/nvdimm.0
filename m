Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AF3B1225E966D
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 15:30:45 -0700 (PDT)
Subject: [PATCH 4/4] acpi/nfit: allow knob to disable ARS being issued at
 kernel boot
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 29 Mar 2018 15:37:25 -0700
Message-ID: <152236304498.35558.9795379174339167399.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <152236282506.35558.2067249639136170490.stgit@djiang5-desk3.ch.intel.com>
References: <152236282506.35558.2067249639136170490.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-acpi@vger.kernel.org, tony.luck@intel.com, rjw@rjwysocki.net, lenb@kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding a kernel module parameter no_start_ars in order to bypass kernel
initiating scrubbing ARS.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/core.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 668d040bf108..21b73ff444f4 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -55,6 +55,10 @@ module_param(default_dsm_family, int, S_IRUGO);
 MODULE_PARM_DESC(default_dsm_family,
 		"Try this DSM type first when identifying NVDIMM family");
 
+static int no_start_ars = 0;
+module_param(no_start_ars, int, S_IRUGO);
+MODULE_PARM_DESC(no_start_ars, "Disable kernel from initiate ARS at boot");
+
 LIST_HEAD(acpi_descs);
 DEFINE_MUTEX(acpi_desc_lock);
 
@@ -2959,10 +2963,13 @@ static void acpi_nfit_scrub(struct work_struct *work)
 
 	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
 		if (nfit_spa->ars_state == NFIT_ARS_STATE_IDLE) {
-			dev_dbg(dev, "range %d set for ARS\n",
-				nfit_spa->spa->range_index);
-			nfit_spa->ars_state = NFIT_ARS_STATE_REQUESTED;
-			ars_needed++;
+			if (!no_start_ars) {
+				dev_dbg(dev, "range %d set for ARS\n",
+					nfit_spa->spa->range_index);
+				nfit_spa->ars_state =
+					NFIT_ARS_STATE_REQUESTED;
+				ars_needed++;
+			}
 		}
 	}
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
