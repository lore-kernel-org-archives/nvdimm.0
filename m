Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56F9D81D4A
 for <linux-nvdimm@lists.01.org>; Tue,  1 Nov 2016 14:22:15 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 10/11] ext2: Use iomap_zero_range() for zeroing truncated page
 in DAX path
Date: Tue,  1 Nov 2016 22:06:20 +0100
Message-Id: <1478034381-19037-11-git-send-email-jack@suse.cz>
In-Reply-To: <1478034381-19037-1-git-send-email-jack@suse.cz>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Currently the last user of ext2_get_blocks() for DAX inodes was
dax_truncate_page(). Convert that to iomap_zero_range() so that all DAX
IO uses the iomap path.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 335cd1e1f902..b723666124a7 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -846,6 +846,9 @@ struct iomap_ops ext2_iomap_ops = {
 	.iomap_begin		= ext2_iomap_begin,
 	.iomap_end		= ext2_iomap_end,
 };
+#else
+/* Define empty ops for !CONFIG_FS_DAX case to avoid ugly ifdefs */
+struct iomap_ops ext2_iomap_ops;
 #endif /* CONFIG_FS_DAX */
 
 int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
@@ -1289,9 +1292,11 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 
 	inode_dio_wait(inode);
 
-	if (IS_DAX(inode))
-		error = dax_truncate_page(inode, newsize, ext2_get_block);
-	else if (test_opt(inode->i_sb, NOBH))
+	if (IS_DAX(inode)) {
+		error = iomap_zero_range(inode, newsize,
+					 PAGE_ALIGN(newsize) - newsize, NULL,
+					 &ext2_iomap_ops);
+	} else if (test_opt(inode->i_sb, NOBH))
 		error = nobh_truncate_page(inode->i_mapping,
 				newsize, ext2_get_block);
 	else
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
