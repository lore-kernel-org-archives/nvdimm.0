Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ADAFB1A1DF4
 for <linux-nvdimm@lists.01.org>; Tue, 20 Sep 2016 13:47:35 -0700 (PDT)
Subject: [PATCH] dm flakey: add DAX support
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 20 Sep 2016 13:47:34 -0700
Message-ID: <147440445480.62486.9559239844115396323.stgit@djiang5-desk3.ch.intel.com>
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
To: snitzer@redhat.com, agk@redhat.com
Cc: dm-devel@redhat.com, fstests@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Change dm-flakey to implement direct_access function,
flakey_direct_access(), which maps sector and calls direct_access
function of its physical target device. This pretty much is a copy
from DM Linear.

This allows fs with DAX to pass in xfstests. It does not actually introduce
data corruption and dropping writes unlike the non-DAX path. The main
reason is due to the I/O path being out of dmflakey's control once
direct_access() has been called. The the existing implementation cannot
be adapted to DAX I/O path. The error injection will be introduced at a
later date with more thought.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/md/dm-flakey.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 6a2e8dd..cf182a7 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -408,9 +408,27 @@ static int flakey_iterate_devices(struct dm_target *ti, iterate_devices_callout_
 	return fn(ti, fc->dev, fc->start, ti->len, data);
 }
 
+static long flakey_direct_access(struct dm_target *ti, sector_t sector,
+				 void **kaddr, pfn_t *pfn, long size)
+{
+	struct flakey_c *fc = ti->private;
+	struct block_device *bdev = fc->dev->bdev;
+	struct blk_dax_ctl dax = {
+		.sector = flakey_map_sector(ti, sector),
+		.size = size,
+	};
+	long ret;
+
+	ret = bdev_direct_access(bdev, &dax);
+	*kaddr = dax.addr;
+	*pfn = dax.pfn;
+
+	return ret;
+}
+
 static struct target_type flakey_target = {
 	.name   = "flakey",
-	.version = {1, 3, 1},
+	.version = {1, 4, 0},
 	.module = THIS_MODULE,
 	.ctr    = flakey_ctr,
 	.dtr    = flakey_dtr,
@@ -419,6 +437,7 @@ static struct target_type flakey_target = {
 	.status = flakey_status,
 	.prepare_ioctl = flakey_prepare_ioctl,
 	.iterate_devices = flakey_iterate_devices,
+	.direct_access = flakey_direct_access,
 };
 
 static int __init dm_flakey_init(void)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
