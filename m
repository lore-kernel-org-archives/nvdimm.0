Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 7B6DE1A1E4C
 for <linux-nvdimm@lists.01.org>; Sat,  4 Jun 2016 13:54:17 -0700 (PDT)
Subject: [PATCH 08/13] fs/dax: remove wmb_pmem()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 04 Jun 2016 13:53:15 -0700
Message-ID: <146507359516.8347.7034634737785410916.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Flushing posted-write queues is now deferred to REQ_FLUSH context, or
otherwise handled by an ADR event at the platform level.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 761495bf5eb9..434f421da660 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -147,7 +147,7 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 		      struct buffer_head *bh)
 {
 	loff_t pos = start, max = start, bh_max = start;
-	bool hole = false, need_wmb = false;
+	bool hole = false;
 	struct block_device *bdev = NULL;
 	int rw = iov_iter_rw(iter), rc;
 	long map_len = 0;
@@ -213,7 +213,6 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 
 		if (iov_iter_rw(iter) == WRITE) {
 			len = copy_from_iter_pmem(dax.addr, max - pos, iter);
-			need_wmb = true;
 		} else if (!hole)
 			len = copy_to_iter((void __force *) dax.addr, max - pos,
 					iter);
@@ -230,8 +229,6 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 			dax.addr += len;
 	}
 
-	if (need_wmb)
-		wmb_pmem();
 	dax_unmap_atomic(bdev, &dax);
 
 	return (pos == start) ? rc : pos - start;
@@ -783,7 +780,6 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 				return ret;
 		}
 	}
-	wmb_pmem();
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
@@ -1227,7 +1223,6 @@ int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
 		if (dax_map_atomic(bdev, &dax) < 0)
 			return PTR_ERR(dax.addr);
 		clear_pmem(dax.addr + offset, length);
-		wmb_pmem();
 		dax_unmap_atomic(bdev, &dax);
 	}
 	return 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
