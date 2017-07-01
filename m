Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C2B5021BADADB
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 17:33:33 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] check-namespace: Updates for UEFI 2.7 (BTT v2.0)
Date: Fri, 30 Jun 2017 18:33:20 -0600
Message-Id: <20170701003321.13360-1-vishal.l.verma@intel.com>
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

Update the check-namespace command to check/detect both v1.1 and v2.0
BTTs. Also update the btt-check.sh test to work for both.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/check.c     | 94 +++++++++++++++++++++++++++++++++++++++++++++----------
 ndctl/check.h     |  5 ++-
 test/btt-check.sh |  4 +--
 3 files changed, 83 insertions(+), 20 deletions(-)

diff --git a/ndctl/check.c b/ndctl/check.c
index 3775c2e..0b564ed 100644
--- a/ndctl/check.c
+++ b/ndctl/check.c
@@ -766,14 +766,29 @@ static void btt_remove_mappings(struct btt_chk *bttc)
 	}
 }
 
-static int btt_recover_first_sb(struct btt_chk *bttc)
+static int btt_sb_get_expected_offset(struct btt_sb *btt_sb)
+{
+	u16 version_major, version_minor;
+
+	version_major = le16_to_cpu(btt_sb->version_major);
+	version_minor = le16_to_cpu(btt_sb->version_minor);
+
+	if (version_major == 1 && version_minor == 1)
+		return BTT1_START_OFFSET;
+	else if (version_major == 2 && version_minor == 0)
+		return BTT2_START_OFFSET;
+	else
+		return -ENXIO;
+}
+
+static int __btt_recover_first_sb(struct btt_chk *bttc, int off)
 {
 	int rc, est_arenas = 0;
 	u64 offset, remaining;
 	struct btt_sb *btt_sb;
 
 	/* Estimate the number of arenas */
-	remaining = bttc->rawsize - bttc->start_off;
+	remaining = bttc->rawsize - off;
 	while (remaining) {
 		if (remaining < ARENA_MIN_SIZE && est_arenas == 0)
 			return -EINVAL;
@@ -800,7 +815,7 @@ static int btt_recover_first_sb(struct btt_chk *bttc)
 	if (btt_sb == NULL)
 		return -ENOMEM;
 	/* Read the original first info block into btt_sb[0] */
-	rc = btt_read_info(bttc, &btt_sb[0], bttc->start_off);
+	rc = btt_read_info(bttc, &btt_sb[0], off);
 	if (rc)
 		goto out;
 
@@ -809,13 +824,26 @@ static int btt_recover_first_sb(struct btt_chk *bttc)
 		offset = rounddown(bttc->rawsize - remaining, SZ_4K) -
 			BTT_INFO_SIZE;
 	else
-		offset = ARENA_MAX_SIZE - BTT_INFO_SIZE + bttc->start_off;
+		offset = ARENA_MAX_SIZE - BTT_INFO_SIZE + off;
 
 	info(bttc, "Attempting recover info-block from end-of-arena offset %#lx\n",
 		offset);
 	rc = btt_info_read_verify(bttc, &btt_sb[1], offset);
 	if (rc == 0) {
-		rc = btt_write_info(bttc, &btt_sb[1], bttc->start_off);
+		int expected_offset = btt_sb_get_expected_offset(&btt_sb[1]);
+
+		/*
+		 * The fact that the btt_sb is self-consistent doesn't tell us
+		 * what BTT version it was, if restoring from the end of the
+		 * arena. (i.e. a consistent sb may be found for any valid
+		 * start offset). Use the version information in the sb to
+		 * determine what the expected start offset is.
+		 */
+		if ((expected_offset < 0) || (expected_offset != off)) {
+			rc = -ENXIO;
+			goto out;
+		}
+		rc = btt_write_info(bttc, &btt_sb[1], off);
 		goto out;
 	}
 
@@ -844,7 +872,7 @@ static int btt_recover_first_sb(struct btt_chk *bttc)
 		btt_sb[1].checksum = btt_sb[0].checksum;
 		rc = btt_info_verify(bttc, &btt_sb[1]);
 		if (rc == 0) {
-			rc = btt_write_info(bttc, &btt_sb[1], bttc->start_off);
+			rc = btt_write_info(bttc, &btt_sb[1], off);
 			goto out;
 		}
 	}
@@ -855,7 +883,7 @@ static int btt_recover_first_sb(struct btt_chk *bttc)
 	 */
 	offset = le32_to_cpu(btt_sb[0].info2off);
 	if (offset > min(bttc->rawsize - BTT_INFO_SIZE,
-			ARENA_MAX_SIZE - BTT_INFO_SIZE + bttc->start_off)) {
+			ARENA_MAX_SIZE - BTT_INFO_SIZE + off)) {
 		rc = -ENXIO;
 		goto out;
 	}
@@ -863,9 +891,9 @@ static int btt_recover_first_sb(struct btt_chk *bttc)
 		info(bttc, "Attempting to recover info-block from info2 offset %#lx\n",
 			offset);
 		rc = btt_info_read_verify(bttc, &btt_sb[1],
-			offset + bttc->start_off);
+			offset + off);
 		if (rc == 0) {
-			rc = btt_write_info(bttc, &btt_sb[1], bttc->start_off);
+			rc = btt_write_info(bttc, &btt_sb[1], off);
 			goto out;
 		}
 	} else
@@ -875,6 +903,25 @@ static int btt_recover_first_sb(struct btt_chk *bttc)
 	return rc;
 }
 
+static int btt_recover_first_sb(struct btt_chk *bttc)
+{
+	int offsets[BTT_NUM_OFFSETS] = {
+		BTT1_START_OFFSET,
+		BTT2_START_OFFSET,
+	};
+	int i, rc;
+
+	for (i = 0; i < BTT_NUM_OFFSETS; i++) {
+		rc = __btt_recover_first_sb(bttc, offsets[i]);
+		if (rc == 0) {
+			bttc->start_off = offsets[i];
+			return rc;
+		}
+	}
+
+	return rc;
+}
+
 int namespace_check(struct ndctl_namespace *ndns, struct check_opts *opts)
 {
 	const char *devname = ndctl_namespace_get_devname(ndns);
@@ -902,7 +949,6 @@ int namespace_check(struct ndctl_namespace *ndns, struct check_opts *opts)
 	}
 
 	bttc->opts = opts;
-	bttc->start_off = BTT_START_OFFSET;
 	bttc->sys_page_size = sysconf(_SC_PAGESIZE);
 	bttc->rawsize = ndctl_namespace_get_size(ndns);
 	ndctl_namespace_get_uuid(ndns, bttc->parent_uuid);
@@ -980,17 +1026,31 @@ int namespace_check(struct ndctl_namespace *ndns, struct check_opts *opts)
 		goto out_close;
 	}
 
-	rc = btt_info_read_verify(bttc, btt_sb, bttc->start_off);
+	/* Try reading a BTT1 info block first */
+	rc = btt_info_read_verify(bttc, btt_sb, BTT1_START_OFFSET);
+	if (rc == 0)
+		bttc->start_off = BTT1_START_OFFSET;
 	if (rc) {
-		rc = btt_recover_first_sb(bttc);
+		/* Try reading a BTT2 info block */
+		rc = btt_info_read_verify(bttc, btt_sb, BTT2_START_OFFSET);
+		if (rc == 0)
+			bttc->start_off = BTT2_START_OFFSET;
 		if (rc) {
-			err(bttc, "Unable to recover any BTT info blocks\n");
-			goto out_close;
+			rc = btt_recover_first_sb(bttc);
+			if (rc) {
+				err(bttc, "Unable to recover any BTT info blocks\n");
+				goto out_close;
+			}
+			/*
+			 * btt_recover_first_sb will have set bttc->start_off
+			 * based on the version it found
+			 */
+			rc = btt_info_read_verify(bttc, btt_sb, bttc->start_off);
+			if (rc)
+				goto out_close;
 		}
-		rc = btt_info_read_verify(bttc, btt_sb, bttc->start_off);
-		if (rc)
-			goto out_close;
 	}
+
 	rc = btt_discover_arenas(bttc);
 	if (rc)
 		goto out_close;
diff --git a/ndctl/check.h b/ndctl/check.h
index f0200db..00b11b2 100644
--- a/ndctl/check.h
+++ b/ndctl/check.h
@@ -27,9 +27,12 @@
 #define ARENA_MIN_SIZE (1UL << 24)	/* 16 MB */
 #define ARENA_MAX_SIZE (1ULL << 39)	/* 512 GB */
 #define BTT_INFO_SIZE 4096
-#define BTT_START_OFFSET 4096
 #define IB_FLAG_ERROR_MASK 0x00000001
 
+#define BTT_NUM_OFFSETS 2
+#define BTT1_START_OFFSET 4096
+#define BTT2_START_OFFSET 0
+
 struct log_entry {
 	le32 lba;
 	le32 old_map;
diff --git a/test/btt-check.sh b/test/btt-check.sh
index 5ec224b..d309448 100755
--- a/test/btt-check.sh
+++ b/test/btt-check.sh
@@ -146,10 +146,10 @@ test_bad_info()
 	echo "=== ${FUNCNAME[0]} ==="
 	set_raw
 	echo "wiping info block"
-	dd if=/dev/zero of=/dev/$raw_bdev bs=$bs count=1 seek=1
+	dd if=/dev/zero of=/dev/$raw_bdev bs=$bs count=2 seek=0
 	unset_raw
 	$ndctl disable-namespace $dev
-	$ndctl check-namespace $dev 2>&1 | grep "info block at offset 0x1000 needs to be restored"
+	$ndctl check-namespace $dev 2>&1 | grep -E "info block at offset .* needs to be restored"
 	$ndctl check-namespace --repair $dev
 	$ndctl enable-namespace $dev
 	post_repair_test
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
