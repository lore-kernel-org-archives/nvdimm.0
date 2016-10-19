Return-Path: <owner-linux-mm@kvack.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v8 05/16] dax: remove the last BUG_ON() from fs/dax.c
Date: Wed, 19 Oct 2016 13:34:24 -0600
Message-Id: <1476905675-32581-6-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1476905675-32581-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1476905675-32581-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Don't take down the kernel if we get an invalid 'from' and 'length'
argument pair.  Just warn once and return an error.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index e52e754..219fa2b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1194,7 +1194,8 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 	/* Block boundary? Nothing to do */
 	if (!length)
 		return 0;
-	BUG_ON((offset + length) > PAGE_SIZE);
+	if (WARN_ON_ONCE((offset + length) > PAGE_SIZE))
+		return -EINVAL;
 
 	memset(&bh, 0, sizeof(bh));
 	bh.b_bdev = inode->i_sb->s_bdev;
-- 
2.7.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
