Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <540F1F6F.7090905@plexistor.com>
Date: Tue, 09 Sep 2014 18:40:31 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 1/9] SQUASHME: pmem: Remove unused #include headers
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <540F1EC6.4000504@plexistor.com>
In-Reply-To: <540F1EC6.4000504@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org
Cc: Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Boaz Harrosh <boaz@plexistor.com>

Removed:
-#include <linux/bio.h>
-#include <linux/fs.h>

These two are included in linux/blkdev.h

-#include <linux/highmem.h>
-#include <linux/major.h>
-#include <linux/uaccess.h>

These 3 are not used anymore

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/pmem.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index d63bc96..8b0b9b0 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -16,17 +16,12 @@
  * Copyright (C) 2007 Novell Inc.
  */
 
-#include <linux/bio.h>
 #include <linux/blkdev.h>
-#include <linux/fs.h>
 #include <linux/hdreg.h>
-#include <linux/highmem.h>
 #include <linux/init.h>
-#include <linux/major.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
-#include <linux/uaccess.h>
 
 #define SECTOR_SHIFT		9
 #define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
-- 
1.9.3

