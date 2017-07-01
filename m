Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9ABCC21BADADB
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 17:33:02 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] libnvdimm, btt: convert some info messages to warn/err
Date: Fri, 30 Jun 2017 18:32:51 -0600
Message-Id: <20170701003252.13171-1-vishal.l.verma@intel.com>
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

Some critical messages such as IO errors, metadata failures were printed
with dev_info. Make them louder by upgrading them to dev_warn or
dev_error.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/btt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 4e56e72..2af329d 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -323,7 +323,7 @@ static int btt_log_read(struct arena_info *arena, u32 lane,
 
 	old_ent = btt_log_get_old(log);
 	if (old_ent < 0 || old_ent > 1) {
-		dev_info(to_dev(arena),
+		dev_err(to_dev(arena),
 				"log corruption (%d): lane %d seq [%d, %d]\n",
 			old_ent, lane, log[0].seq, log[1].seq);
 		/* TODO set error state? */
@@ -684,7 +684,7 @@ static int discover_arenas(struct btt *btt)
 				dev_info(to_dev(arena), "No existing arenas\n");
 				goto out;
 			} else {
-				dev_info(to_dev(arena),
+				dev_err(to_dev(arena),
 						"Found corrupted metadata!\n");
 				ret = -ENODEV;
 				goto out;
@@ -1227,7 +1227,7 @@ static blk_qc_t btt_make_request(struct request_queue *q, struct bio *bio)
 		err = btt_do_bvec(btt, bip, bvec.bv_page, len, bvec.bv_offset,
 				  op_is_write(bio_op(bio)), iter.bi_sector);
 		if (err) {
-			dev_info(&btt->nd_btt->dev,
+			dev_err(&btt->nd_btt->dev,
 					"io error in %s sector %lld, len %d,\n",
 					(op_is_write(bio_op(bio))) ? "WRITE" :
 					"READ",
@@ -1373,7 +1373,7 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 	}
 
 	if (btt->init_state != INIT_READY && nd_region->ro) {
-		dev_info(dev, "%s is read-only, unable to init btt metadata\n",
+		dev_warn(dev, "%s is read-only, unable to init btt metadata\n",
 				dev_name(&nd_region->dev));
 		return NULL;
 	} else if (btt->init_state != INIT_READY) {
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
