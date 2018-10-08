Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B625F2114083E
 for <linux-nvdimm@lists.01.org>; Mon,  8 Oct 2018 16:56:37 -0700 (PDT)
Subject: [PATCH v12 12/12] acpi,
 nfit: Move acpi_nfit_get_security_ops() to generic location
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 08 Oct 2018 16:56:36 -0700
Message-ID: <153904299685.60070.3336606945357072947.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153904272246.60070.6230977215877367778.stgit@djiang5-desk3.ch.intel.com>
References: <153904272246.60070.6230977215877367778.stgit@djiang5-desk3.ch.intel.com>
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
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Dan Williams <dan.j.williams@intel.com>

In anticipation of other DIMMs adding security operations support, don't
require them to edit intel.h. Instead have intel.h optionally arrange
for intel_security_ops to be NULL or not based on build parameters.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c  |   10 ++++++++++
 drivers/acpi/nfit/intel.c |    3 ++-
 drivers/acpi/nfit/intel.h |   18 +++---------------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index e5f7c664a7c8..b7773c70ee81 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1835,6 +1835,16 @@ static void shutdown_dimm_notify(void *data)
 	mutex_unlock(&acpi_desc->init_mutex);
 }
 
+static const struct nvdimm_security_ops *acpi_nfit_get_security_ops(int family)
+{
+        switch (family) {
+        case NVDIMM_FAMILY_INTEL:
+                return intel_security_ops;
+        default:
+                return NULL;
+        }
+}
+
 static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 {
 	struct nfit_mem *nfit_mem;
diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 70bccb0c57e2..8d2413810a5f 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -358,7 +358,7 @@ static int intel_dimm_security_state(struct nvdimm *nvdimm,
 	return rc;
 }
 
-const struct nvdimm_security_ops intel_security_ops = {
+static const struct nvdimm_security_ops __intel_security_ops = {
 	.state = intel_dimm_security_state,
 	.unlock = intel_dimm_security_unlock,
 	.change_key = intel_dimm_security_update_passphrase,
@@ -366,3 +366,4 @@ const struct nvdimm_security_ops intel_security_ops = {
 	.freeze_lock = intel_dimm_security_freeze_lock,
 	.erase = intel_dimm_security_erase,
 };
+const struct nvdimm_security_ops *intel_security_ops = &__intel_security_ops;
diff --git a/drivers/acpi/nfit/intel.h b/drivers/acpi/nfit/intel.h
index f9ac718776ca..f831084f95fa 100644
--- a/drivers/acpi/nfit/intel.h
+++ b/drivers/acpi/nfit/intel.h
@@ -8,7 +8,7 @@
 
 #ifdef CONFIG_X86
 
-extern const struct nvdimm_security_ops intel_security_ops;
+extern const struct nvdimm_security_ops *intel_security_ops;
 
 #define ND_INTEL_STATUS_SIZE		4
 #define ND_INTEL_PASSPHRASE_SIZE	32
@@ -64,19 +64,7 @@ struct nd_intel_overwrite {
 struct nd_intel_query_overwrite {
 	u32 status;
 } __packed;
+#else /* CONFIG_X86 */
+#define intel_security_ops (NULL)
 #endif /* CONFIG_X86 */
-
-static inline const struct nvdimm_security_ops *
-acpi_nfit_get_security_ops(int family)
-{
-	switch (family) {
-#ifdef CONFIG_X86
-	case NVDIMM_FAMILY_INTEL:
-		return &intel_security_ops;
-#endif
-	default:
-		return NULL;
-	}
-}
-
 #endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
