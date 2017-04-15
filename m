Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9FDE42194EB6C
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 19:40:16 -0700 (PDT)
Subject: [PATCH v2 16/33] block,
 dax: convert bdev_dax_supported() to dax_direct_access()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 19:34:32 -0700
Message-ID: <149222367263.32363.14488170568085010560.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149222358726.32363.15876405696577002849.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149222358726.32363.15876405696577002849.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Kill of the final user of bdev_direct_access() and struct blk_dax_ctl.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/block_dev.c |   48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2f7885712575..ecbdc8f9f718 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -788,35 +788,43 @@ EXPORT_SYMBOL(bdev_dax_pgoff);
  */
 int bdev_dax_supported(struct super_block *sb, int blocksize)
 {
-	struct blk_dax_ctl dax = {
-		.sector = 0,
-		.size = PAGE_SIZE,
-	};
-	int err;
+	struct block_device *bdev = sb->s_bdev;
+	struct dax_device *dax_dev;
+	pgoff_t pgoff;
+	int err, id;
+	void *kaddr;
+	pfn_t pfn;
+	long len;
 
 	if (blocksize != PAGE_SIZE) {
 		vfs_msg(sb, KERN_ERR, "error: unsupported blocksize for dax");
 		return -EINVAL;
 	}
 
-	err = bdev_direct_access(sb->s_bdev, &dax);
-	if (err < 0) {
-		switch (err) {
-		case -EOPNOTSUPP:
-			vfs_msg(sb, KERN_ERR,
-				"error: device does not support dax");
-			break;
-		case -EINVAL:
-			vfs_msg(sb, KERN_ERR,
-				"error: unaligned partition for dax");
-			break;
-		default:
-			vfs_msg(sb, KERN_ERR,
-				"error: dax access failed (%d)", err);
-		}
+	err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
+	if (err) {
+		vfs_msg(sb, KERN_ERR, "error: unaligned partition for dax");
 		return err;
 	}
 
+	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
+	if (!dax_dev) {
+		vfs_msg(sb, KERN_ERR, "error: device does not support dax");
+		return -EOPNOTSUPP;
+	}
+
+	id = dax_read_lock();
+	len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
+	dax_read_unlock(id);
+
+	put_dax(dax_dev);
+
+	if (len < 1) {
+		vfs_msg(sb, KERN_ERR,
+				"error: dax access failed (%d)", len);
+		return len < 0 ? len : -EIO;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(bdev_dax_supported);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
