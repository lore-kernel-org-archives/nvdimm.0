Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 186481A1EEE
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 14:09:20 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v5 12/17] dax: add dax_iomap_sector() helper function
Date: Fri,  7 Oct 2016 15:08:59 -0600
Message-Id: <1475874544-24842-13-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

To be able to correctly calculate the sector from a file position and a
struct iomap there is a complex little bit of logic that currently happens
in both dax_iomap_actor() and dax_iomap_fault().  This will need to be
repeated yet again in the DAX PMD fault handler when it is added, so break
it out into a helper function.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 982ccbb..7689ab0 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1023,6 +1023,11 @@ int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
 EXPORT_SYMBOL_GPL(dax_truncate_page);
 
 #ifdef CONFIG_FS_IOMAP
+static inline sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
+{
+	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
+}
+
 static loff_t
 dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		struct iomap *iomap)
@@ -1048,8 +1053,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		struct blk_dax_ctl dax = { 0 };
 		ssize_t map_len;
 
-		dax.sector = iomap->blkno +
-			(((pos & PAGE_MASK) - iomap->offset) >> 9);
+		dax.sector = dax_iomap_sector(iomap, pos);
 		dax.size = (length + offset + PAGE_SIZE - 1) & PAGE_MASK;
 		map_len = dax_map_atomic(iomap->bdev, &dax);
 		if (map_len < 0) {
@@ -1186,7 +1190,7 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		goto unlock_entry;
 	}
 
-	sector = iomap.blkno + (((pos & PAGE_MASK) - iomap.offset) >> 9);
+	sector = dax_iomap_sector(&iomap, pos);
 
 	if (vmf->cow_page) {
 		switch (iomap.type) {
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
