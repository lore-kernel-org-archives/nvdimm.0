Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 2/5] dax: increase granularity of dax_clear_blocks()
 operations
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Oct 2015 13:10:26 -0400
Message-ID: <20151022171026.38343.6371.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20151022171015.38343.72043.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151022171015.38343.72043.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, willy@linux.intel.com, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

dax_clear_blocks is currently performing a cond_resched() after every
PAGE_SIZE memset.  We need not check so frequently, for example md-raid
only calls cond_resched() at stripe granularity.  Also, in preparation
for introducing a dax_map_atomic() operation that temporarily pins a dax
mapping move the call to cond_resched() to the outer loop.

Reviewed-by: Jan Kara <jack@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 5dc33d788d50..f8e543839e5c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/uio.h>
 #include <linux/vmstat.h>
+#include <linux/sizes.h>
 
 int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 {
@@ -38,24 +39,20 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 	do {
 		void __pmem *addr;
 		unsigned long pfn;
-		long count;
+		long count, sz;
 
-		count = bdev_direct_access(bdev, sector, &addr, &pfn, size);
+		sz = min_t(long, size, SZ_1M);
+		count = bdev_direct_access(bdev, sector, &addr, &pfn, sz);
 		if (count < 0)
 			return count;
-		BUG_ON(size < count);
-		while (count > 0) {
-			unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
-			if (pgsz > count)
-				pgsz = count;
-			clear_pmem(addr, pgsz);
-			addr += pgsz;
-			size -= pgsz;
-			count -= pgsz;
-			BUG_ON(pgsz & 511);
-			sector += pgsz / 512;
-			cond_resched();
-		}
+		if (count < sz)
+			sz = count;
+		clear_pmem(addr, sz);
+		addr += sz;
+		size -= sz;
+		BUG_ON(sz & 511);
+		sector += sz / 512;
+		cond_resched();
 	} while (size);
 
 	wmb_pmem();

