Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id B4B721A1F26
 for <linux-nvdimm@lists.01.org>; Fri, 25 Mar 2016 15:00:45 -0700 (PDT)
Subject: [PATCH] libnvdimm, blk: quiet i/o error reporting
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Mar 2016 14:59:41 -0700
Message-ID: <20160325215310.31923.81368.stgit@dwillia2-desk3.jf.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

I/O errors events have the potential to be a high frequency and a log
message for each event can swamp the system.  This message is also
redundant with upper layer error reporting.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Previously this was folded into "[PATCH 08/13] libnvdimm, blk: move i/o
infrastructure to nd_namespace_blk", but it deserves to be its own
change.

 drivers/nvdimm/blk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index c8635b3d88a8..26d039879ba2 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -189,7 +189,7 @@ static blk_qc_t nd_blk_make_request(struct request_queue *q, struct bio *bio)
 		err = nd_blk_do_bvec(blk_dev, bip, bvec.bv_page, len,
 					bvec.bv_offset, rw, iter.bi_sector);
 		if (err) {
-			dev_info(&blk_dev->nsblk->common.dev,
+			dev_dbg(&blk_dev->nsblk->common.dev,
 					"io error in %s sector %lld, len %d,\n",
 					(rw == READ) ? "READ" : "WRITE",
 					(unsigned long long) iter.bi_sector, len);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
