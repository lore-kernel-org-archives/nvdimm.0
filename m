Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 321B820958966
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 13:53:54 -0700 (PDT)
Subject: [ndctl PATCH 6/6] ndctl,
 create-namespace: set pmem namespace sector size
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 05 Jul 2017 13:49:07 -0700
Message-ID: <149928774707.25150.9359431758968306936.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149928771519.25150.13314997328838983545.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149928771519.25150.13314997328838983545.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Starting with v1.2 namespace labels, the "lbasize" field is expected to
be non-zero for all namespace types.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/namespace.c |   40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index c28d00193a62..778a65d02c2a 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -244,18 +244,14 @@ static int set_defaults(enum namespace_action mode)
 			error("invalid sector size: %s\n", param.sector_size);
 			rc = -EINVAL;
 		}
-
-		if (param.type && param.mode && strcmp(param.type, "pmem") == 0
-				&& strcmp(param.mode, "safe") != 0) {
-			error("'pmem' namespaces do not support setting 'sector size'\n");
-			rc = -EINVAL;
-		}
-	} else if (!param.reconfig
-			&& ((param.type && strcmp(param.type, "blk") == 0)
+	} else if (!param.reconfig) {
+		if ((param.type && strcmp(param.type, "blk") == 0)
 				|| (param.mode
-					&& strcmp(param.mode, "safe") == 0))) {
+					&& strcmp(param.mode, "safe") == 0))
 			/* default sector size for blk-type or safe-mode */
 			param.sector_size = "4096";
+		else
+			param.sector_size = "512";
 	}
 
 	return rc;
@@ -356,7 +352,7 @@ static int setup_namespace(struct ndctl_region *region,
 		try(ndctl_namespace, set_size, ndns, p->size);
 	}
 
-	if (ndctl_namespace_get_type(ndns) == ND_DEVICE_NAMESPACE_BLK)
+	if (p->sector_size)
 		try(ndctl_namespace, set_sector_size, ndns, p->sector_size);
 
 	uuid_generate(uuid);
@@ -608,22 +604,36 @@ static int validate_namespace_options(struct ndctl_region *region,
 				if (ndctl_namespace_get_supported_sector_size(seed, i)
 						== p->sector_size)
 					break;
-			if (i >= num) {
+			if (i >= num)
 				debug("%s: does not support namespace sector_size %lu\n",
 						region_name, p->sector_size);
+
+			/*
+			 * Pre-4.13 kernels did not support sector sizes
+			 * for pmem namespaces. Revert to the zero
+			 * default in that case.
+			 */
+			if (i >= num && ndctl_region_get_type(region)
+					!= ND_DEVICE_REGION_BLK
+					&& (p->sector_size == 512
+						|| p->sector_size == 4096)) {
+				debug("%s: revert to default sector size\n",
+						region_name);
+				p->sector_size = 0;
+			} else if (i >= num)
 				return -EINVAL;
-			}
 		}
 	} else if (ndns) {
 		struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
 
 		if (btt)
 			p->sector_size = ndctl_btt_get_sector_size(btt);
-		else if (ndctl_namespace_get_type(ndns)
-				== ND_DEVICE_NAMESPACE_BLK)
-			p->sector_size = ndctl_namespace_get_sector_size(ndns);
 		else if (p->mode == NDCTL_NS_MODE_SAFE)
 				p->sector_size = 4096;
+		else
+			p->sector_size = ndctl_namespace_get_sector_size(ndns);
+		if (p->sector_size == UINT_MAX)
+			p->sector_size = 0;
 	}
 
 	if (param.map) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
