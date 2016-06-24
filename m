Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2355.austin.hpe.com (g2t2355.austin.hpe.com [15.233.44.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 222BE1A1DF5
 for <linux-nvdimm@lists.01.org>; Fri, 24 Jun 2016 11:24:09 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH] dm stripe: add DAX support
Date: Fri, 24 Jun 2016 12:23:30 -0600
Message-Id: <1466792610-30369-1-git-send-email-toshi.kani@hpe.com>
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
To: snitzer@redhat.com
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Change dm-stripe to implement direct_access function,
stripe_direct_access(), which maps bdev and sector and
calls direct_access function of its physical target device.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/md/dm-stripe.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 48f1c01..8925f6a 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -308,6 +308,30 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
+static long stripe_direct_access(struct dm_target *ti, sector_t sector,
+		void __pmem **kaddr, pfn_t *pfn, long size)
+{
+	struct stripe_c *sc;
+	struct block_device *bdev;
+	uint32_t stripe;
+	struct blk_dax_ctl dax = {
+		.size = size,
+	};
+	long ret;
+
+	sc = ti->private;
+	stripe_map_sector(sc, sector, &stripe, &dax.sector);
+
+	dax.sector += sc->stripe[stripe].physical_start;
+	bdev = sc->stripe[stripe].dev->bdev;
+
+	ret = bdev_direct_access(bdev, &dax);
+	*kaddr = dax.addr;
+	*pfn = dax.pfn;
+
+	return ret;
+}
+
 /*
  * Stripe status:
  *
@@ -425,6 +449,7 @@ static struct target_type stripe_target = {
 	.status = stripe_status,
 	.iterate_devices = stripe_iterate_devices,
 	.io_hints = stripe_io_hints,
+	.direct_access = stripe_direct_access,
 };
 
 int __init dm_stripe_init(void)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
