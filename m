Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 155AC1A1F4D
 for <linux-nvdimm@lists.01.org>; Wed,  9 Mar 2016 14:05:43 -0800 (PST)
From: NeilBrown <neilb@suse.com>
Date: Thu, 10 Mar 2016 08:59:28 +1100
Subject: [PATCH 3/4] memstick: don't allocate unused major for ms_block
Message-ID: <20160309215928.20904.10315.stgit@noble>
In-Reply-To: <20160309215702.20904.61407.stgit@noble>
References: <20160309215702.20904.61407.stgit@noble>
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
To: Keith Busch <keith.busch@intel.com>, Maxim Levitsky <maximlevitsky@gmail.com>, Vishal Verma <vishal.l.verma@intel.com>, Jens Axboe <axboe@fb.com>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

When alloc_disk(0) is used the ->major number is completely ignored.
All devices are allocated with a major of BLOCK_EXT_MAJOR.

So remove registration and deregistration of 'major'.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/memstick/core/ms_block.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index 84abf9d3c24e..3d086f1d1234 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -2340,23 +2340,11 @@ static struct memstick_driver msb_driver = {
 	.resume   = msb_resume
 };
 
-static int major;
-
 static int __init msb_init(void)
 {
-	int rc = register_blkdev(0, DRIVER_NAME);
-
-	if (rc < 0) {
-		pr_err("failed to register major (error %d)\n", rc);
-		return rc;
-	}
-
-	major = rc;
-	rc = memstick_register_driver(&msb_driver);
-	if (rc) {
-		unregister_blkdev(major, DRIVER_NAME);
+	int rc = memstick_register_driver(&msb_driver);
+	if (rc)
 		pr_err("failed to register memstick driver (error %d)\n", rc);
-	}
 
 	return rc;
 }
@@ -2364,7 +2352,6 @@ static int __init msb_init(void)
 static void __exit msb_exit(void)
 {
 	memstick_unregister_driver(&msb_driver);
-	unregister_blkdev(major, DRIVER_NAME);
 	idr_destroy(&msb_disk_idr);
 }
 


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
