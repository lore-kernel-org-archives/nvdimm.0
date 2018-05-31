Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 77188210C9968
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 16:36:33 -0700 (PDT)
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net
 [16.220.97.129])
 by g9t5009.houston.hpe.com (Postfix) with ESMTP id 5734C12D
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 23:36:32 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH] nvdimm: preserve read-only setting for pmem devices
Date: Thu, 31 May 2018 18:36:36 -0500
Message-Id: <20180531233636.7775-1-elliott@hpe.com>
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

The pmem driver don't honor a forced read-only setting for very long:
	$ blockdev --setro /dev/pmem0
	$ blockdev --getro /dev/pmem0
	1

followed by various commands like these:
	$ blockdev --rereadpt /dev/pmem0
	or
	$ mkfs.ext4 /dev/pmem0

results in this in the kernel serial log:
	 nd_pmem namespace0.0: region0 read-write, marking pmem0 read-write

with the read-only setting lost:
	$ blockdev --getro /dev/pmem0
	0

That's from bus.c nvdimm_revalidate_disk(), which always applies the
setting from nd_region (which is initially based on the ACPI NFIT
NVDIMM state flags not_armed bit).

In contrast, commit 20bd1d026aac ("scsi: sd: Keep disk read-only when
re-reading partition") fixed this issue for SCSI devices to preserve
the previous setting if it was set to read-only.

This patch modifies bus.c to preserve any previous read-only setting.
It also eliminates the kernel serial log print except for cases where
read-write is changed to read-only, so it doesn't print read-only to
read-only non-changes.

Signed-off-by: Robert Elliott <elliott@hpe.com>
---
 drivers/nvdimm/bus.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index a64023690cad..87762afa45b0 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -566,14 +566,17 @@ int nvdimm_revalidate_disk(struct gendisk *disk)
 {
 	struct device *dev = disk_to_dev(disk)->parent;
 	struct nd_region *nd_region = to_nd_region(dev->parent);
-	const char *pol = nd_region->ro ? "only" : "write";
+	int disk_ro = get_disk_ro(disk);
 
-	if (nd_region->ro == get_disk_ro(disk))
+	/* upgrade to read-only if the region is read-only
+	 * preserve as read-only if the disk is already read-only
+	 */
+	if (disk_ro || nd_region->ro == disk_ro)
 		return 0;
 
-	dev_info(dev, "%s read-%s, marking %s read-%s\n",
-			dev_name(&nd_region->dev), pol, disk->disk_name, pol);
-	set_disk_ro(disk, nd_region->ro);
+	dev_info(dev, "%s read-only, marking %s read-only\n",
+			dev_name(&nd_region->dev), disk->disk_name);
+	set_disk_ro(disk, 1);
 
 	return 0;
 
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
