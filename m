Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A31C421C8EFCE
 for <linux-nvdimm@lists.01.org>; Fri, 23 Jun 2017 19:17:52 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] libnvdimm, btt: BTT updates for UEFI 2.7 format
Date: Fri, 23 Jun 2017 20:17:36 -0600
Message-Id: <20170624021736.26632-1-vishal.l.verma@intel.com>
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

The UEFI 2.7 specification defines an updated BTT metadata format,
bumping the revision to 2.0. Add support for the new format, while
retaining compatibility for the old 1.1 format.

New BTTs will be created using the newest (2.0 as of this writing)
format.

Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Linda Knippers <linda.knippers@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/btt.c      | 28 ++++++++++++++++++++--------
 drivers/nvdimm/btt.h      |  7 +++++++
 drivers/nvdimm/btt_devs.c | 44 +++++++++++++++++++++++++++++++++++++++-----
 drivers/nvdimm/nd.h       |  1 +
 4 files changed, 67 insertions(+), 13 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 983718b..629c376 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -37,8 +37,8 @@ static int arena_read_bytes(struct arena_info *arena, resource_size_t offset,
 	struct nd_btt *nd_btt = arena->nd_btt;
 	struct nd_namespace_common *ndns = nd_btt->ndns;
 
-	/* arena offsets are 4K from the base of the device */
-	offset += SZ_4K;
+	/* arena offsets may be shifted from the base of the device */
+	offset += arena->nd_btt->initial_offset;
 	return nvdimm_read_bytes(ndns, offset, buf, n, flags);
 }
 
@@ -48,8 +48,8 @@ static int arena_write_bytes(struct arena_info *arena, resource_size_t offset,
 	struct nd_btt *nd_btt = arena->nd_btt;
 	struct nd_namespace_common *ndns = nd_btt->ndns;
 
-	/* arena offsets are 4K from the base of the device */
-	offset += SZ_4K;
+	/* arena offsets may be shifted from the base of the device */
+	offset += arena->nd_btt->initial_offset;
 	return nvdimm_write_bytes(ndns, offset, buf, n, flags);
 }
 
@@ -576,8 +576,10 @@ static struct arena_info *alloc_arena(struct btt *btt, size_t size,
 	arena->internal_lbasize = roundup(arena->external_lbasize,
 					INT_LBASIZE_ALIGNMENT);
 	arena->nfree = BTT_DEFAULT_NFREE;
-	arena->version_major = 1;
-	arena->version_minor = 1;
+
+	/* New BTTs will always be v2.0 */
+	arena->version_major = 2;
+	arena->version_minor = 0;
 
 	if (available % BTT_PG_SIZE)
 		available -= (available % BTT_PG_SIZE);
@@ -1425,18 +1427,28 @@ int nvdimm_namespace_attach_btt(struct nd_namespace_common *ndns)
 {
 	struct nd_btt *nd_btt = to_nd_btt(ndns->claim);
 	struct nd_region *nd_region;
+	struct btt_sb *btt_sb;
 	struct btt *btt;
 	size_t rawsize;
+	int btt_ver;
 
 	if (!nd_btt->uuid || !nd_btt->ndns || !nd_btt->lbasize) {
 		dev_dbg(&nd_btt->dev, "incomplete btt configuration\n");
 		return -ENODEV;
 	}
 
-	rawsize = nvdimm_namespace_capacity(ndns) - SZ_4K;
+	btt_sb = devm_kzalloc(&nd_btt->dev, sizeof(*btt_sb), GFP_KERNEL);
+	btt_ver = nd_btt_version(nd_btt, ndns, btt_sb);
+	if (btt_ver < 0) {
+		dev_err(&nd_btt->dev, "%s: set initial_offset = 0\n", __func__);
+		nd_btt->initial_offset = 0;
+	}
+
+	rawsize = nvdimm_namespace_capacity(ndns) - nd_btt->initial_offset;
 	if (rawsize < ARENA_MIN_SIZE) {
 		dev_dbg(&nd_btt->dev, "%s must be at least %ld bytes\n",
-				dev_name(&ndns->dev), ARENA_MIN_SIZE + SZ_4K);
+				dev_name(&ndns->dev),
+				ARENA_MIN_SIZE + nd_btt->initial_offset);
 		return -ENXIO;
 	}
 	nd_region = to_nd_region(nd_btt->dev.parent);
diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
index b2f8651..1845df2 100644
--- a/drivers/nvdimm/btt.h
+++ b/drivers/nvdimm/btt.h
@@ -44,6 +44,11 @@ enum btt_init_state {
 	INIT_READY
 };
 
+enum btt_versions {
+	ND_BTT_1_1 = 1,
+	ND_BTT_2_0
+};
+
 struct log_entry {
 	__le32 lba;
 	__le32 old_map;
@@ -184,5 +189,7 @@ struct btt {
 };
 
 bool nd_btt_arena_is_valid(struct nd_btt *nd_btt, struct btt_sb *super);
+int nd_btt_version(struct nd_btt *nd_btt, struct nd_namespace_common *ndns,
+		struct btt_sb *btt_sb);
 
 #endif
diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 31d875a..22e148a 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -260,20 +260,54 @@ bool nd_btt_arena_is_valid(struct nd_btt *nd_btt, struct btt_sb *super)
 }
 EXPORT_SYMBOL(nd_btt_arena_is_valid);
 
+int nd_btt_version(struct nd_btt *nd_btt, struct nd_namespace_common *ndns,
+		struct btt_sb *btt_sb)
+{
+	/*
+	 * At this point, the claim class can only be 'BTT' or 'NONE'. BTT
+	 * implies a BTT v2.0 and none implies v1.1
+	 */
+	if (ndns->claim_class == NVDIMM_CCLASS_BTT) {
+		/* Probe for BTT v2.0 */
+		if (nvdimm_read_bytes(ndns, 0, btt_sb, sizeof(*btt_sb), 0))
+			return -ENXIO;
+		if (!nd_btt_arena_is_valid(nd_btt, btt_sb))
+			return -ENODEV;
+		if ((le16_to_cpu(btt_sb->version_major) == 2) &&
+				(le16_to_cpu(btt_sb->version_minor) == 0)) {
+			nd_btt->initial_offset = 0;
+			return ND_BTT_2_0;
+		}
+	} else {
+		/* Probe for BTT v1.1 */
+		if (nvdimm_read_bytes(ndns, SZ_4K, btt_sb, sizeof(*btt_sb), 0))
+			return -ENXIO;
+		if (!nd_btt_arena_is_valid(nd_btt, btt_sb))
+			return -ENODEV;
+		if ((le16_to_cpu(btt_sb->version_major) == 1) &&
+				(le16_to_cpu(btt_sb->version_minor) == 1)) {
+			nd_btt->initial_offset = SZ_4K;
+			return ND_BTT_1_1;
+		}
+	}
+	return -ENXIO;
+}
+EXPORT_SYMBOL(nd_btt_version);
+
 static int __nd_btt_probe(struct nd_btt *nd_btt,
 		struct nd_namespace_common *ndns, struct btt_sb *btt_sb)
 {
+	int btt_ver;
+
 	if (!btt_sb || !ndns || !nd_btt)
 		return -ENODEV;
 
-	if (nvdimm_read_bytes(ndns, SZ_4K, btt_sb, sizeof(*btt_sb), 0))
-		return -ENXIO;
-
 	if (nvdimm_namespace_capacity(ndns) < SZ_16M)
 		return -ENXIO;
 
-	if (!nd_btt_arena_is_valid(nd_btt, btt_sb))
-		return -ENODEV;
+	btt_ver = nd_btt_version(nd_btt, ndns, btt_sb);
+	if (btt_ver < 0)
+		return btt_ver;
 
 	nd_btt->lbasize = le32_to_cpu(btt_sb->external_lbasize);
 	nd_btt->uuid = kmemdup(btt_sb->uuid, 16, GFP_KERNEL);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 8cabd83..474ad8a 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -194,6 +194,7 @@ struct nd_btt {
 	u64 size;
 	u8 *uuid;
 	int id;
+	int initial_offset;
 };
 
 enum nd_pfn_mode {
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
