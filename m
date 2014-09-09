Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <540F2197.2000803@plexistor.com>
Date: Tue, 09 Sep 2014 18:49:43 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 8/9] SQUASHME: pmem: Fixs to getgeo
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <540F1EC6.4000504@plexistor.com>
In-Reply-To: <540F1EC6.4000504@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org
Cc: Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Boaz Harrosh <boaz@plexistor.com>

With current values fdisk does the wrong thing. On small disks
it will offer 40 (20K) as first possible sector.
With this patch fdisk will offer 8 (4k) as possible first
sector, which is what we want.

Note that current code had a BUG with anything bigger than
64G because hd_geometry->cylinders is ushort and it would
overflow at this value. Anyway capacity is not calculated
through getgeo so it does not matter what we set for cylinders.

I have tested with cfdisk parted/gparted and they behave the
same after this patch, with fdisk I have better expected behavior
after this patch.

Is there any other test I need to perform that might be affected
by this?

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/pmem.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index b415b61..600d225 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -40,10 +40,16 @@ struct pmem_device {
 
 static int pmem_getgeo(struct block_device *bd, struct hd_geometry *geo)
 {
-	/* some standard values */
-	geo->heads = 1 << 6;
-	geo->sectors = 1 << 5;
-	geo->cylinders = get_capacity(bd->bd_disk) >> 11;
+	/* Just tell fdisk to get out of the way. The CHS math here is so
+	 * convoluted and does not make any sense at all. With all 1s
+	 * The math just gets out of the way.
+	 * When doing the usual lying to fdisk with the (64,32,X) common at the
+	 * rest of the Kernel, fdisk will offer 34 as first sector, with this
+	 * here plus the  4K physical_block_size it will offer 8 (4K)
+	 */
+	geo->heads = 1;
+	geo->sectors = 1;
+	geo->cylinders = 1;
 	return 0;
 }
 
-- 
1.9.3

