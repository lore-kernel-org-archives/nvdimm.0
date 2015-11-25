Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 3/7] dax: guarantee page aligned results from
 bdev_direct_access()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 25 Nov 2015 10:37:13 -0800
Message-ID: <20151125183713.12508.77457.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20151125183656.12508.52212.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151125183656.12508.52212.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>
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
index c25639e907bd..c9f813843939 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -489,6 +489,8 @@ long bdev_direct_access(struct block_device *bdev, sector_t sector,
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

