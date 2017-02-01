Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3034D81FC5
 for <linux-nvdimm@lists.01.org>; Wed,  1 Feb 2017 10:41:10 -0800 (PST)
Subject: [ndctl PATCH] ndctl, create-namespace: prefer the 0th namespace device
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 01 Feb 2017 10:37:04 -0800
Message-ID: <148597422464.21096.8605658477233872887.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Depending on initialization order the first seed device in a region may
not point to the first namespace. Always check if the first namespace is
available before falling back to the current seed.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-xaction-namespace.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 5743eeeb5bfb..46d651e86153 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -632,6 +632,18 @@ static int validate_namespace_options(struct ndctl_region *region,
 	return 0;
 }
 
+static struct ndctl_namespace *region_get_namespace(struct ndctl_region *region)
+{
+	struct ndctl_namespace *ndns;
+
+	/* prefer the 0th namespace if it is idle */
+	ndctl_namespace_foreach(region, ndns)
+		if (ndctl_namespace_get_id(ndns) == 0
+				&& !is_namespace_active(ndns))
+			return ndns;
+	return ndctl_region_get_namespace_seed(region);
+}
+
 static int namespace_create(struct ndctl_region *region)
 {
 	const char *devname = ndctl_region_get_devname(region);
@@ -660,7 +672,7 @@ static int namespace_create(struct ndctl_region *region)
 	if (p.size == 0)
 		p.size = available;
 
-	ndns = ndctl_region_get_namespace_seed(region);
+	ndns = region_get_namespace(region);
 	if (!ndns || is_namespace_active(ndns)) {
 		debug("%s: no %s namespace seed\n", devname,
 				ndns ? "idle" : "available");
@@ -794,7 +806,7 @@ static int namespace_reconfig(struct ndctl_region *region,
 	if (rc)
 		return rc;
 
-	ndns = ndctl_region_get_namespace_seed(region);
+	ndns = region_get_namespace(region);
 	if (!ndns || is_namespace_active(ndns)) {
 		debug("%s: no %s namespace seed\n",
 				ndctl_region_get_devname(region),

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
