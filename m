Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 742411A1E2C
 for <linux-nvdimm@lists.01.org>; Mon, 15 Aug 2016 12:09:24 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/7] ext2: tell DAX the size of allocation holes
Date: Mon, 15 Aug 2016 13:09:12 -0600
Message-Id: <20160815190918.20672-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20160815190918.20672-1-ross.zwisler@linux.intel.com>
References: <20160815190918.20672-1-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When DAX calls ext2_get_block() and the file offset points to a hole we
currently don't set bh_result->b_size.  When we re-enable PMD faults DAX
will need bh_result->b_size to tell it the size of the hole so it can
decide whether to fault in a 4 KiB zero page or a 2 MiB zero page.

For ext2 we always want DAX to use 4 KiB zero pages, so we just tell DAX
that all holes are 4 KiB in size.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/ext2/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index d5c7d09..c6d9763 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -773,6 +773,12 @@ int ext2_get_block(struct inode *inode, sector_t iblock, struct buffer_head *bh_
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
+	} else if (ret == 0 && IS_DAX(inode)) {
+		/*
+		 * We have hit a hole.  Tell DAX it is 4k in size so that it
+		 * uses PTE faults.
+		 */
+		bh_result->b_size = PAGE_SIZE;
 	}
 	return ret;
 
-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
