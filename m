Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id B95021A1F2D
 for <linux-nvdimm@lists.01.org>; Mon, 25 Apr 2016 12:51:01 -0700 (PDT)
Subject: [ndctl PATCH 2/7] ndctl,
 create-namespace: check for ZONE_DEVICE=n kernels
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Apr 2016 12:49:59 -0700
Message-ID: <146161379994.21779.2908319412060950116.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146161378966.21779.1219526957524644729.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146161378966.21779.1219526957524644729.stgit@dwillia2-desk3.amr.corp.intel.com>
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

When a kernel does not support ZONE_DEVICE it is unable to support
pfn-device configurations.  Use the absence of a pfn-seed as the
indicator of this configuration to fail the operation with an error
rather than crashing.

Reported-by: Linda Knippers <linda.knippers@hpe.com>
Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 builtin-xaction-namespace.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/builtin-xaction-namespace.c b/builtin-xaction-namespace.c
index 97bb36525d7c..40f62822facd 100644
--- a/builtin-xaction-namespace.c
+++ b/builtin-xaction-namespace.c
@@ -38,6 +38,7 @@ static bool verbose;
 static bool force;
 static struct parameters {
 	bool do_scan;
+	bool mode_default;
 	const char *bus;
 	const char *map;
 	const char *type;
@@ -153,6 +154,7 @@ static int set_defaults(enum namespace_action mode)
 			param.mode = "memory";
 		else
 			param.mode = "safe";
+		param.mode_default = true;
 	}
 
 	if (param.map) {
@@ -265,10 +267,13 @@ static bool do_setup_pfn(struct ndctl_namespace *ndns,
 	if (p->mode != NDCTL_NS_MODE_MEMORY)
 		return false;
 
-	if (ndctl_namespace_get_mode(ndns) != NDCTL_NS_MODE_MEMORY)
-		return true;
-
-	if (p->loc == NDCTL_PFN_LOC_PMEM)
+	/*
+	 * Dynamically allocated namespaces always require a pfn
+	 * instance, and a pfn device is required to place the memmap
+	 * array in device memory.
+	 */
+	if (!ndns || ndctl_namespace_get_mode(ndns) != NDCTL_NS_MODE_MEMORY
+			|| p->loc == NDCTL_PFN_LOC_PMEM)
 		return true;
 
 	return false;
@@ -330,6 +335,7 @@ static int is_namespace_active(struct ndctl_namespace *ndns)
 
 /*
  * validate_namespace_options - init parameters for setup_namespace
+ * @region: parent of the namespace to create / reconfigure
  * @ndns: specified when we are reconfiguring, NULL otherwise
  * @p: parameters to fill
  *
@@ -342,8 +348,8 @@ static int is_namespace_active(struct ndctl_namespace *ndns)
  * the target namespace we need to do basic sanity checks here for
  * pmem-only attributes specified for blk namespace and vice versa.
  */
-static int validate_namespace_options(struct ndctl_namespace *ndns,
-		struct parsed_parameters *p)
+static int validate_namespace_options(struct ndctl_region *region,
+		struct ndctl_namespace *ndns, struct parsed_parameters *p)
 {
 	int rc = 0;
 
@@ -428,6 +434,19 @@ static int validate_namespace_options(struct ndctl_namespace *ndns,
 	} else if (p->mode == NDCTL_NS_MODE_MEMORY)
 		p->loc = NDCTL_PFN_LOC_PMEM;
 
+	/* check if we need, and whether the kernel supports, pfn devices */
+	if (do_setup_pfn(ndns, p)) {
+		struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
+
+		if (!pfn && param.mode_default) {
+			debug("memory mode not available\n");
+			p->mode = NDCTL_NS_MODE_RAW;
+		} else if (!pfn) {
+			error("operation failed, memory mode not available\n");
+			return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 
@@ -438,7 +457,7 @@ static int namespace_create(struct ndctl_region *region)
 	struct ndctl_namespace *ndns;
 	struct parsed_parameters p;
 
-	if (validate_namespace_options(NULL, &p))
+	if (validate_namespace_options(region, NULL, &p))
 		return -EINVAL;
 
 	if (ndctl_region_get_ro(region)) {
@@ -578,7 +597,7 @@ static int namespace_reconfig(struct ndctl_region *region,
 	struct parsed_parameters p;
 	int rc;
 
-	if (validate_namespace_options(ndns, &p))
+	if (validate_namespace_options(region, ndns, &p))
 		return -EINVAL;
 
 	rc = namespace_destroy(region, ndns);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
