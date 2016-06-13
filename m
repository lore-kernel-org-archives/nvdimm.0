Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6AD401A1E30
 for <linux-nvdimm@lists.01.org>; Mon, 13 Jun 2016 15:32:19 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 4/6] dm-linear: Add linear_direct_access()
Date: Mon, 13 Jun 2016 16:21:35 -0600
Message-Id: <1465856497-19698-5-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
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
To: agk@redhat.com, snitzer@redhat.com, dan.j.williams@intel.com
Cc: axboe@kernel.dk, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk
List-ID: <linux-nvdimm@lists.01.org>

Change dm-linear to implement direct_access function,
linear_direct_access(), which maps sector and calls
direct_access function of its target device.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/md/dm-linear.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 05c35aa..49bd7d2 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -141,6 +141,22 @@ static int linear_iterate_devices(struct dm_target *ti,
 	return fn(ti, lc->dev, lc->start, ti->len, data);
 }
 
+static long linear_direct_access(struct dm_target *ti, sector_t sector,
+		void __pmem **kaddr, pfn_t *pfn, long size)
+{
+	struct linear_c *lc;
+	struct block_device *tbdev;
+	const struct block_device_operations *tops;
+	sector_t tsector;
+
+	lc = ti->private;
+	tbdev = lc->dev->bdev;
+	tops = tbdev->bd_disk->fops;
+	tsector = linear_map_sector(ti, sector);
+
+	return tops->direct_access(tbdev, tsector, kaddr, pfn, size);
+}
+
 static struct target_type linear_target = {
 	.name   = "linear",
 	.version = {1, 2, 1},
@@ -151,6 +167,7 @@ static struct target_type linear_target = {
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
