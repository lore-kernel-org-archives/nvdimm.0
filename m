Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <54108F64.9080201@plexistor.com>
Date: Wed, 10 Sep 2014 20:50:28 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH] SQUASHME: pmem: Add MODULE_ALIAS
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <540F1EC6.4000504@plexistor.com>
In-Reply-To: <540F1EC6.4000504@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Boaz Harrosh <boaz@plexistor.com>

This is customary and will become useful soon with udev and events

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/pmem.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index 4a9d65e..f63cb31 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -432,5 +430,6 @@ static void __exit pmem_exit(void)
 
 MODULE_AUTHOR("Ross Zwisler <ross.zwisler@linux.intel.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("pmem");
 module_init(pmem_init);
 module_exit(pmem_exit);
-- 
1.9.3


