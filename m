Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x242.google.com (mail-pf0-x242.google.com
 [IPv6:2607:f8b0:400e:c00::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 47D8121A143C1
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 01:14:28 -0700 (PDT)
Received: by mail-pf0-x242.google.com with SMTP id z6so3753068pfk.3
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 01:15:58 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 3/4] libndctl: Add helpers to check supported sector sizes
Date: Tue, 27 Jun 2017 18:15:30 +1000
Message-Id: <20170627081531.7389-3-oohall@gmail.com>
In-Reply-To: <20170627081531.7389-1-oohall@gmail.com>
References: <20170627081531.7389-1-oohall@gmail.com>
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

libndctl now has the ndctl_{dax|pfn}_supports_align() helper functions
for checking if PFN and DAX regions support a given alignment. The
sector size of a BTT region is similar to the region alignment so add an
equivilent helper to maintain a consistent API across region types.

Adds:
	ndctl_namespace_supports_sector_size()
	ndctl_btt_supports_sector_size()

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 ndctl/lib/libndctl.c   | 12 ++++++++++++
 ndctl/lib/libndctl.sym |  2 ++
 ndctl/libndctl.h.in    |  3 +++
 ndctl/namespace.c      | 30 ++++++++++++------------------
 4 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index d21d372891a4..9668d8c5d34e 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -3586,6 +3586,12 @@ NDCTL_EXPORT int ndctl_namespace_get_num_sector_sizes(struct ndctl_namespace *nd
 	return ndns->lbasize.num;
 }
 
+NDCTL_EXPORT int ndctl_namespace_supports_sector_size(
+		struct ndctl_namespace *ndns, unsigned long size)
+{
+	return sizes_contains(&ndns->lbasize, size);
+}
+
 NDCTL_EXPORT int ndctl_namespace_set_sector_size(struct ndctl_namespace *ndns,
 		unsigned int sector_size)
 {
@@ -3912,6 +3918,12 @@ NDCTL_EXPORT int ndctl_btt_get_num_sector_sizes(struct ndctl_btt *btt)
 	return btt->lbasize.num;
 }
 
+NDCTL_EXPORT int ndctl_btt_supports_sector_size(
+		struct ndctl_btt *btt, unsigned long size)
+{
+	return sizes_contains(&btt->lbasize, size);
+}
+
 NDCTL_EXPORT struct ndctl_namespace *ndctl_btt_get_namespace(struct ndctl_btt *btt)
 {
 	struct ndctl_ctx *ctx = ndctl_btt_get_ctx(btt);
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 547d1bf133c6..4039f7311222 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -192,6 +192,7 @@ global:
 	ndctl_namespace_get_sector_size;
 	ndctl_namespace_get_num_sector_sizes;
 	ndctl_namespace_set_sector_size;
+	ndctl_namespace_supports_sector_size;
 	ndctl_namespace_get_raw_mode;
 	ndctl_namespace_set_raw_mode;
 	ndctl_namespace_get_numa_node;
@@ -204,6 +205,7 @@ global:
 	ndctl_btt_get_supported_sector_size;
 	ndctl_btt_get_sector_size;
 	ndctl_btt_get_num_sector_sizes;
+	ndctl_btt_supports_sector_size;
 	ndctl_btt_get_namespace;
 	ndctl_btt_get_uuid;
 	ndctl_btt_get_size;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 1d0924999b03..feefb9653c88 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -513,6 +513,8 @@ int ndctl_namespace_set_size(struct ndctl_namespace *ndns,
 		unsigned long long size);
 unsigned int ndctl_namespace_get_supported_sector_size(
 		struct ndctl_namespace *ndns, int i);
+int ndctl_namespace_supports_sector_size(
+		struct ndctl_namespace *ndns, unsigned long size);
 unsigned int ndctl_namespace_get_sector_size(struct ndctl_namespace *ndns);
 int ndctl_namespace_get_num_sector_sizes(struct ndctl_namespace *ndns);
 int ndctl_namespace_set_sector_size(struct ndctl_namespace *ndns,
@@ -538,6 +540,7 @@ struct ndctl_ctx *ndctl_btt_get_ctx(struct ndctl_btt *btt);
 struct ndctl_bus *ndctl_btt_get_bus(struct ndctl_btt *btt);
 struct ndctl_region *ndctl_btt_get_region(struct ndctl_btt *btt);
 unsigned int ndctl_btt_get_id(struct ndctl_btt *btt);
+int ndctl_btt_supports_sector_size(struct ndctl_btt *btt, unsigned long size);
 unsigned int ndctl_btt_get_supported_sector_size(struct ndctl_btt *btt, int i);
 unsigned int ndctl_btt_get_sector_size(struct ndctl_btt *btt);
 int ndctl_btt_get_num_sector_sizes(struct ndctl_btt *btt);
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 895e39bb8c7d..0f402e8790a6 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -570,25 +570,21 @@ static int validate_namespace_options(struct ndctl_region *region,
 	}
 
 	if (param.sector_size) {
-		struct ndctl_btt *btt;
-		int num, i;
+		unsigned long long size = parse_size64(param.sector_size);
 
-		p->sector_size = parse_size64(param.sector_size);
-		btt = ndctl_region_get_btt_seed(region);
 		if (p->mode == NDCTL_NS_MODE_SAFE) {
+			struct ndctl_btt *btt =
+				ndctl_region_get_btt_seed(region);
+
 			if (!btt) {
 				debug("%s: does not support 'sector' mode\n",
 						region_name);
 				return -EINVAL;
 			}
-			num = ndctl_btt_get_num_sector_sizes(btt);
-			for (i = 0; i < num; i++)
-				if (ndctl_btt_get_supported_sector_size(btt, i)
-						== p->sector_size)
-					break;
-			if (i >= num) {
+
+			if (!ndctl_btt_supports_sector_size(btt, size)) {
 				debug("%s: does not support btt sector_size %lu\n",
-						region_name, p->sector_size);
+						region_name, size);
 				return -EINVAL;
 			}
 		} else {
@@ -596,17 +592,15 @@ static int validate_namespace_options(struct ndctl_region *region,
 
 			if (!seed)
 				seed = ndctl_region_get_namespace_seed(region);
-			num = ndctl_namespace_get_num_sector_sizes(seed);
-			for (i = 0; i < num; i++)
-				if (ndctl_namespace_get_supported_sector_size(seed, i)
-						== p->sector_size)
-					break;
-			if (i >= num) {
+
+			if (!ndctl_namespace_supports_sector_size(seed, size)) {
 				debug("%s: does not support namespace sector_size %lu\n",
-						region_name, p->sector_size);
+						region_name, size);
 				return -EINVAL;
 			}
 		}
+
+		p->sector_size = size;
 	} else if (ndns) {
 		struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
 
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
