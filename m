Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH 6/8] dax: increase granularity of dax_clear_blocks()
 operations
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 17 Nov 2015 12:16:25 -0800
Message-ID: <20151117201625.15053.40904.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
References: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-block@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, willy@linux.intel.com, ross.zwisler@linux.intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

dax_clear_blocks is currently performing a cond_resched() after every
PAGE_SIZE memset.  We need not check so frequently, for example md-raid
only calls cond_resched() at stripe granularity.  Also, in preparation
for introducing a dax_map_atomic() operation that temporarily pins a dax
mapping move the call to cond_resched() to the outer loop.

Reviewed-by: Jan Kara <jack@suse.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 19492cc65a30..e11d88835bb2 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/uio.h>
 #include <linux/vmstat.h>
+#include <linux/sizes.h>
 
 /*
  * dax_clear_blocks() is called from within transaction context from XFS,
@@ -43,24 +44,17 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 	do {
 		void __pmem *addr;
 		unsigned long pfn;
-		long count;
+		long count, sz;
 
 		count = bdev_direct_access(bdev, sector, &addr, &pfn, size);
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
+		sz = min_t(long, count, SZ_1M);
+		clear_pmem(addr, sz);
+		size -= sz;
+		BUG_ON(sz & 511);
+		sector += sz / 512;
+		cond_resched();
 	} while (size);
 
 	wmb_pmem();

