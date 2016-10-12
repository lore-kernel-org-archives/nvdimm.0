Return-Path: <owner-linux-mm@kvack.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v6 02/17] ext4: tell DAX the size of allocation holes
Date: Wed, 12 Oct 2016 16:50:07 -0600
Message-Id: <20161012225022.15507-3-ross.zwisler@linux.intel.com>
In-Reply-To: <20161012225022.15507-1-ross.zwisler@linux.intel.com>
References: <20161012225022.15507-1-ross.zwisler@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When DAX calls _ext4_get_block() and the file offset points to a hole we
currently don't set bh->b_size.  This is current worked around via
buffer_size_valid() in fs/dax.c.

_ext4_get_block() has the hole size information from ext4_map_blocks(), so
populate bh->b_size so we can remove buffer_size_valid() in a later patch.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0900cb4..9075fac 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -759,6 +759,9 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
 		ext4_update_bh_state(bh, map.m_flags);
 		bh->b_size = inode->i_sb->s_blocksize * map.m_len;
 		ret = 0;
+	} else if (ret == 0) {
+		/* hole case, need to fill in bh->b_size */
+		bh->b_size = inode->i_sb->s_blocksize * map.m_len;
 	}
 	return ret;
 }
-- 
2.9.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
