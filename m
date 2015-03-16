Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 5/6] pmem: Clean up includes
Date: Mon, 16 Mar 2015 15:12:59 -0600
Message-Id: <1426540380-24503-6-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1426540380-24503-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1426540380-24503-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, riel@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk
Cc: hch@infradead.org
Cc: riel@redhat.com
---
 drivers/block/pmem.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index d63bc96..8f39ef4 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -16,17 +16,15 @@
  * Copyright (C) 2007 Novell Inc.
  */
 
+#include <asm/cacheflush.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/fs.h>
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

