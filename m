Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64F8C20958BC3
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 17:33:33 -0700 (PDT)
Subject: [PATCH] ndctl, create-namespace: support sector size settings for pmem
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 Aug 2017 17:29:53 -0700
Message-ID: <150422579319.8329.10494234762055238152.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Starting with v1.2 namespace label support it is permissible for pmem
namespaces to have a sector size. Per UEFI 2.7 the default should be 4K
for inter-OS compatibility.

Reported-by: Juston Li <juston.li@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/namespace.c |   35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 55645d868b60..115119a84431 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -248,12 +248,6 @@ static int set_defaults(enum namespace_action mode)
 			error("invalid sector size: %s\n", param.sector_size);
 			rc = -EINVAL;
 		}
-
-		if (param.type && param.mode && strcmp(param.type, "pmem") == 0
-				&& strcmp(param.mode, "safe") != 0) {
-			error("'pmem' namespaces do not support setting 'sector size'\n");
-			rc = -EINVAL;
-		}
 	} else if (!param.reconfig
 			&& ((param.type && strcmp(param.type, "blk") == 0)
 				|| (param.mode
@@ -360,7 +354,7 @@ static int setup_namespace(struct ndctl_region *region,
 		try(ndctl_namespace, set_size, ndns, p->size);
 	}
 
-	if (ndctl_namespace_get_type(ndns) == ND_DEVICE_NAMESPACE_BLK)
+	if (p->sector_size && p->sector_size < UINT_MAX)
 		try(ndctl_namespace, set_sector_size, ndns, p->sector_size);
 
 	uuid_generate(uuid);
@@ -394,6 +388,13 @@ static int setup_namespace(struct ndctl_region *region,
 	} else if (p->mode == NDCTL_NS_MODE_SAFE) {
 		struct ndctl_btt *btt = ndctl_region_get_btt_seed(region);
 
+		/*
+		 * Handle the case of btt on a pmem namespace where the
+		 * pmem kernel support is pre-v1.2 namespace labels
+		 * support (does not support sector size settings).
+		 */
+		if (p->sector_size == UINT_MAX)
+			p->sector_size = 4096;
 		try(ndctl_btt, set_uuid, btt, uuid);
 		try(ndctl_btt, set_sector_size, btt, p->sector_size);
 		try(ndctl_btt, set_namespace, btt, ndns);
@@ -632,11 +633,23 @@ static int validate_namespace_options(struct ndctl_region *region,
 
 		if (btt)
 			p->sector_size = ndctl_btt_get_sector_size(btt);
-		else if (ndctl_namespace_get_type(ndns)
-				== ND_DEVICE_NAMESPACE_BLK)
+		else
 			p->sector_size = ndctl_namespace_get_sector_size(ndns);
-		else if (p->mode == NDCTL_NS_MODE_SAFE)
-				p->sector_size = 4096;
+	} else {
+		struct ndctl_namespace *seed;
+
+		seed = ndctl_region_get_namespace_seed(region);
+		if (ndctl_namespace_get_type(seed) == ND_DEVICE_NAMESPACE_BLK)
+			debug("%s: set_defaults() should preclude this?\n",
+				ndctl_region_get_devname(region));
+		/*
+		 * Pick a default sector size for a pmem namespace based
+		 * on what the kernel supports.
+		 */
+		if (ndctl_namespace_get_num_sector_sizes(seed) == 0)
+			p->sector_size = UINT_MAX;
+		else
+			p->sector_size = 512;
 	}
 
 	if (param.map) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
