Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH 7/8] dax: guarantee page aligned results from
 bdev_direct_access()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 17 Nov 2015 12:16:30 -0800
Message-ID: <20151117201630.15053.53812.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
References: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-block@vger.kernel.org, willy@linux.intel.com, ross.zwisler@linux.intel.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

If a ->direct_access() implementation ever returns a map count less than
PAGE_SIZE, catch the error in bdev_direct_access().  This simplifies
error checking in upper layers.

Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/block_dev.c |    2 ++
 fs/dax.c       |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index bb0dfb1c7af1..e2cc681d4afe 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -475,6 +475,8 @@ long bdev_direct_access(struct block_device *bdev, sector_t sector,
 	avail = ops->direct_access(bdev, sector, addr, pfn);
 	if (!avail)
 		return -ERANGE;
+	if (avail > 0 && avail & ~PAGE_MASK)
+		return -ENXIO;
 	return min(avail, size);
 }
 EXPORT_SYMBOL_GPL(bdev_direct_access);
diff --git a/fs/dax.c b/fs/dax.c
index e11d88835bb2..6e498c2570bf 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -52,7 +52,6 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 		sz = min_t(long, count, SZ_1M);
 		clear_pmem(addr, sz);
 		size -= sz;
-		BUG_ON(sz & 511);
 		sector += sz / 512;
 		cond_resched();
 	} while (size);

