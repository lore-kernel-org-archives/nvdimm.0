Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH] BTT: Change nd_btt_arena_is_valid() to verify UUID
Date: Thu, 17 Dec 2015 16:00:00 -0700
Message-Id: <1450393200-6802-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com, micah.parrish@hpe.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

When user unbinds a BTT disk and binds again with a different
sector size without wiping out the disk, a BTT disk is created
with a wrong size.

This is because the bind operation keeps the previous metadata,
which leads nd_btt->lbasize inconsistent with internal_lbasize
and external_lbasize in the arena.  A reboot also reattaches
the BTT from the previous metadata.

Change nd_btt_arena_is_valid() to check if nd_btt->uuid matches
with super->uuid when a new UUID is set for binding.  This
assures the bind operation writes the metadata with the values
specified by user.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Micah Parrish <micah.parrish@hpe.com>
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
---
 drivers/nvdimm/btt_devs.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index cb47751..176ea25 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -218,6 +218,8 @@ static bool uuid_is_null(u8 *uuid)
  * Check consistency of the btt info block with itself by validating
  * the checksum, and with the parent namespace by verifying the
  * parent_uuid contained in the info block with the one supplied in.
+ * When nd_btt->uuid is set for binding, verify if the metadata is
+ * stale.
  *
  * Returns:
  * false for an invalid info block, true for a valid one
@@ -234,6 +236,10 @@ bool nd_btt_arena_is_valid(struct nd_btt *nd_btt, struct btt_sb *super)
 		if (memcmp(super->parent_uuid, parent_uuid, 16) != 0)
 			return false;
 
+	if (nd_btt->uuid)
+		if (memcmp(super->uuid, nd_btt->uuid, 16) != 0)
+			return false;
+
 	checksum = le64_to_cpu(super->checksum);
 	super->checksum = 0;
 	if (checksum != nd_sb_checksum((struct nd_gen_sb *) super))
