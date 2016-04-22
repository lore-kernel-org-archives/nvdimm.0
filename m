Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 2D6281A2217
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 12:48:33 -0700 (PDT)
Subject: [ndctl PATCH 8/8] ndctl,
 create-namespace: check for ZONE_DEVICE=n kernels
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Apr 2016 12:47:43 -0700
Message-ID: <146135446379.4228.7996799346697687015.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146135442234.4228.904225076597683142.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146135442234.4228.904225076597683142.stgit@dwillia2-desk3.amr.corp.intel.com>
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
 builtin-xaction-namespace.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/builtin-xaction-namespace.c b/builtin-xaction-namespace.c
index 6ae8d7aee849..6ff969cd696e 100644
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
@@ -428,6 +430,22 @@ static int validate_namespace_options(struct ndctl_namespace *ndns,
 	} else if (p->mode == NDCTL_NS_MODE_MEMORY)
 		p->loc = NDCTL_PFN_LOC_PMEM;
 
+	/* check if we need, and whether the kernel supports, pfn devices */
+	if (do_setup_pfn(ndns, p)) {
+		struct ndctl_region *region;
+		struct ndctl_pfn *pfn;
+
+		region = ndctl_namespace_get_region(ndns);
+		pfn = ndctl_region_get_pfn_seed(region);
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
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
