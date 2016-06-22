Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CAB101A1E21
 for <linux-nvdimm@lists.01.org>; Wed, 22 Jun 2016 17:05:50 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 3/3] dm linear: add DAX support
Date: Wed, 22 Jun 2016 17:54:54 -0600
Message-Id: <1466639694-25394-4-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1466639694-25394-1-git-send-email-toshi.kani@hpe.com>
References: <1466639694-25394-1-git-send-email-toshi.kani@hpe.com>
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
To: snitzer@redhat.com, axboe@kernel.dk, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk, agk@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Change dm-linear to implement direct_access function,
linear_direct_access(), which maps sector and calls direct_access
function of its physical target device.

Change dm-linear to sets 'dax_supported' when its target physical device
supports DAX.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/md/dm-linear.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 05c35aa..c7fdd1d 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -59,6 +59,8 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_same_bios = 1;
+	if (blk_queue_dax(lc->dev->bdev->bd_queue))
+		ti->dax_supported = true;
 	ti->private = lc;
 	return 0;
 
@@ -141,9 +143,27 @@ static int linear_iterate_devices(struct dm_target *ti,
 	return fn(ti, lc->dev, lc->start, ti->len, data);
 }
 
+static long linear_direct_access(struct dm_target *ti, sector_t sector,
+				 void __pmem **kaddr, pfn_t *pfn, long size)
+{
+	struct linear_c *lc = ti->private;
+	struct block_device *bdev = lc->dev->bdev;
+	struct blk_dax_ctl dax = {
+		.sector = linear_map_sector(ti, sector),
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
 static struct target_type linear_target = {
 	.name   = "linear",
-	.version = {1, 2, 1},
+	.version = {1, 3, 0},
 	.module = THIS_MODULE,
 	.ctr    = linear_ctr,
 	.dtr    = linear_dtr,
@@ -151,6 +171,7 @@ static struct target_type linear_target = {
 	.status = linear_status,
 	.prepare_ioctl = linear_prepare_ioctl,
 	.iterate_devices = linear_iterate_devices,
+	.direct_access = linear_direct_access,
 };
 
 int __init dm_linear_init(void)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
