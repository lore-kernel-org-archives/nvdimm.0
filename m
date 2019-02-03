Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D5F80211BB8DC
 for <linux-nvdimm@lists.01.org>; Sun,  3 Feb 2019 11:41:28 -0800 (PST)
Subject: [PATCH] acpi/nfit: Require opt-in for read-only label configurations
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 03 Feb 2019 11:28:50 -0800
Message-ID: <154922213038.3561630.15221922065373676874.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <CAPcyv4iMau=fvOfubDvK=cg5v5287TvXqBCm=p8nqbz2es6YEg@mail.gmail.com>
References: <CAPcyv4iMau=fvOfubDvK=cg5v5287TvXqBCm=p8nqbz2es6YEg@mail.gmail.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Recent fixes to command handling enabled Linux to read label
configurations that it could not before. Unfortunately that means that
configurations that were operating in label-less mode will be broken as
the kernel ignores the existing namespace configuration and tries to
honor the new found labels.

Fortunately this seems limited to a case where Linux can quirk the
behavior and maintain the existing label-less semantics by default.
When the platform does not emit an _LSW method, disable all label access
methods. Provide a 'force_labels' module parameter to allow read-only
label operation.

Fixes: 11189c1089da ("acpi/nfit: Fix command-supported detection")
Reported-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 811c399a3a76..5b5e802de7b8 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -56,6 +56,10 @@ static bool no_init_ars;
 module_param(no_init_ars, bool, 0644);
 MODULE_PARM_DESC(no_init_ars, "Skip ARS run at nfit init time");
 
+static bool force_labels;
+module_param(force_labels, bool, 0444);
+MODULE_PARM_DESC(force_labels, "Opt-in to labels despite missing methods");
+
 LIST_HEAD(acpi_descs);
 DEFINE_MUTEX(acpi_desc_lock);
 
@@ -1916,6 +1920,19 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 			dev_dbg(dev, "%s: has _LSW\n", dev_name(&adev_dimm->dev));
 			set_bit(NFIT_MEM_LSW, &nfit_mem->flags);
 		}
+
+		/*
+		 * Quirk read-only label configurations to preserve
+		 * access to label-less namespaces by default.
+		 */
+		if (!test_bit(NFIT_MEM_LSW, &nfit_mem->flags)
+				&& !force_labels) {
+			dev_dbg(dev, "%s: No _LSW, disable labels\n",
+					dev_name(&adev_dimm->dev));
+			clear_bit(NFIT_MEM_LSR, &nfit_mem->flags);
+		} else
+			dev_dbg(dev, "%s: Force enable labels\n",
+					dev_name(&adev_dimm->dev));
 	}
 
 	populate_shutdown_status(nfit_mem);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
