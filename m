Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CDB3481B01
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jan 2017 17:11:42 -0800 (PST)
Subject: [PATCH 2/9] ndctl,
 create-namespace: skip blk regions when scanning for memory or dax
 mode
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 09 Jan 2017 17:07:36 -0800
Message-ID: <148401045624.16217.15327641904969985006.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148401044568.16217.6942951063735168785.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148401044568.16217.6942951063735168785.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Treat blk regions as invalid capacity when the mode is a pmem-only mode
type.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-xaction-namespace.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 66e61c531fa6..b0dd341db829 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -432,15 +432,14 @@ static int validate_namespace_options(struct ndctl_region *region,
 		else
 			p->mode = NDCTL_NS_MODE_RAW;
 
-		if (ndns && ndctl_namespace_get_type(ndns)
-				== ND_DEVICE_NAMESPACE_BLK
+		if (ndctl_region_get_type(region) != ND_DEVICE_REGION_PMEM
 				&& (p->mode == NDCTL_NS_MODE_MEMORY
 					|| p->mode == NDCTL_NS_MODE_DAX)) {
-			debug("%s: blk namespace do not support %s mode\n",
-					ndctl_namespace_get_devname(ndns),
+			debug("blk %s does not support %s mode\n",
+					ndctl_region_get_devname(region),
 					p->mode == NDCTL_NS_MODE_MEMORY
 					? "memory" : "dax");
-				return -EINVAL;
+			return -EAGAIN;
 		}
 	} else if (ndns)
 		p->mode = ndctl_namespace_get_mode(ndns);
@@ -518,10 +517,12 @@ static int validate_namespace_options(struct ndctl_region *region,
 		struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
 
 		if (!pfn && param.mode_default) {
-			debug("memory mode not available\n");
+			debug("%s memory mode not available\n",
+					ndctl_region_get_devname(region));
 			p->mode = NDCTL_NS_MODE_RAW;
 		} else if (!pfn) {
-			error("operation failed, memory mode not available\n");
+			error("operation failed, %s memory mode not available\n",
+					ndctl_region_get_devname(region));
 			return -EINVAL;
 		}
 	}
@@ -531,7 +532,8 @@ static int validate_namespace_options(struct ndctl_region *region,
 		struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
 
 		if (!dax) {
-			error("operation failed, dax mode not available\n");
+			error("operation failed, %s dax mode not available\n",
+					ndctl_region_get_devname(region));
 			return -EINVAL;
 		}
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
