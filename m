Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C0802267F11B
 for <linux-nvdimm@lists.01.org>; Mon,  9 Apr 2018 13:10:11 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [ndctl PATCH 1/2] ndctl: s/memory/fsdax/ in some user visible places
Date: Mon,  9 Apr 2018 14:09:19 -0600
Message-Id: <20180409200920.20177-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding on to the work started by:

commit ebb4fb605e68 ("ndctl, create-namespace: introduce "fsdax" and "devdax" modes")

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 Documentation/ndctl/ndctl-inject-error.txt | 2 +-
 ndctl/namespace.c                          | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/ndctl/ndctl-inject-error.txt b/Documentation/ndctl/ndctl-inject-error.txt
index 01f6c22..94c4e69 100644
--- a/Documentation/ndctl/ndctl-inject-error.txt
+++ b/Documentation/ndctl/ndctl-inject-error.txt
@@ -45,7 +45,7 @@ OPTIONS
 
 	NOTE: The offset is interpreted in different ways based on the "mode"
 	of the namespace. For "raw" mode, the offset is the base namespace
-	offset. For "memory" mode (i.e. a "pfn" namespace), the offset is
+	offset. For "fsdax" mode (i.e. a "pfn" namespace), the offset is
 	relative to the user-visible part of the namespace, and the offset
 	introduced by the kernel's metadata will be accounted for. For a
 	"sector" mode namespace (i.e. a "BTT" namespace), the offset is
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index f2c5644..e619dc1 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -103,7 +103,7 @@ OPT_STRING('n', "name", &param.name, "name", \
 OPT_STRING('s', "size", &param.size, "size", \
 	"specify the namespace size in bytes (default: available capacity)"), \
 OPT_STRING('m', "mode", &param.mode, "operation-mode", \
-	"specify a mode for the namespace, 'sector', 'memory', or 'raw'"), \
+	"specify a mode for the namespace, 'sector', 'fsdax', or 'raw'"), \
 OPT_STRING('M', "map", &param.map, "memmap-location", \
 	"specify 'mem' or 'dev' for the location of the memmap"), \
 OPT_STRING('l', "sector-size", &param.sector_size, "lba-size", \
@@ -696,7 +696,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 
 		if (ndns && p->mode != NDCTL_NS_MODE_MEMORY
 			&& p->mode != NDCTL_NS_MODE_DAX) {
-			debug("%s: --map= only valid for memory mode namespace\n",
+			debug("%s: --map= only valid for fsdax mode namespace\n",
 				ndctl_namespace_get_devname(ndns));
 			return -EINVAL;
 		}
@@ -709,10 +709,10 @@ static int validate_namespace_options(struct ndctl_region *region,
 		struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
 
 		if (!pfn && param.mode_default) {
-			debug("%s memory mode not available\n", region_name);
+			debug("%s fsdax mode not available\n", region_name);
 			p->mode = NDCTL_NS_MODE_RAW;
 		} else if (!pfn) {
-			error("operation failed, %s memory mode not available\n",
+			error("operation failed, %s fsdax mode not available\n",
 					region_name);
 			return -EINVAL;
 		}
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
