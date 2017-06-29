Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3077921A143C6
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 15:59:30 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] libnvdimm, btt: fix btt_rw_page not returning errors
Date: Thu, 29 Jun 2017 16:59:11 -0600
Message-Id: <20170629225911.7896-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

btt_rw_page was not propagating errors frm btt_do_bvec, resulting in any
IO errors via the rw_page path going unnoticed. the pmem driver recently
fixed this in e10624f pmem: fail io-requests to known bad blocks
but same problem in BTT went neglected.

Fixes: 5212e11 nd_btt: atomic sector updates
Cc: <stable@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/btt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 7ca11df..4e56e72 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1248,10 +1248,13 @@ static int btt_rw_page(struct block_device *bdev, sector_t sector,
 		struct page *page, bool is_write)
 {
 	struct btt *btt = bdev->bd_disk->private_data;
+	int rc;
 
-	btt_do_bvec(btt, NULL, page, PAGE_SIZE, 0, is_write, sector);
-	page_endio(page, is_write, 0);
-	return 0;
+	rc = btt_do_bvec(btt, NULL, page, PAGE_SIZE, 0, is_write, sector);
+	if (rc == 0)
+		page_endio(page, is_write, 0);
+
+	return rc;
 }
 
 
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
