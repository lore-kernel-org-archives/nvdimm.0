Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v5 1/7] brd: make rd_size static
Date: Tue, 18 Aug 2015 13:55:35 -0600
Message-Id: <1439927741-29580-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1439927741-29580-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1439927741-29580-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>
List-ID: <linux-nvdimm@lists.01.org>

Make rd_size static because it is local to drivers/block/brd.c

This was reported by sparse:

drivers/block/brd.c:445:5: warning: symbol 'rd_size' was not declared.
Should it be static?

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/brd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 64ab495..5750b39 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -442,7 +442,7 @@ static int rd_nr = CONFIG_BLK_DEV_RAM_COUNT;
 module_param(rd_nr, int, S_IRUGO);
 MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
 
-int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
+static int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
 module_param(rd_size, int, S_IRUGO);
 MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
 
-- 
2.1.0

