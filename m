From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 4/4] dm linear: add DAX support
Date: Thu, 23 Jun 2016 17:05:53 -0400
Message-ID: <1466715953-40692-5-git-send-email-snitzer@redhat.com>
References: <1466715953-40692-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1466715953-40692-1-git-send-email-snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, toshi.kani-ZPxbGqLxI0U@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

From: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>

Change dm-linear to implement direct_access function,
linear_direct_access(), which maps sector and calls direct_access
function of its physical target device.

Signed-off-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Signed-off-by: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/md/dm-linear.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 05c35aa..6d35dd4 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -141,9 +141,27 @@ static int linear_iterate_devices(struct dm_target *ti,
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
@@ -151,6 +169,7 @@ static struct target_type linear_target = {
 	.status = linear_status,
 	.prepare_ioctl = linear_prepare_ioctl,
 	.iterate_devices = linear_iterate_devices,
+	.direct_access = linear_direct_access,
 };
 
 int __init dm_linear_init(void)
-- 
2.7.4 (Apple Git-66)
