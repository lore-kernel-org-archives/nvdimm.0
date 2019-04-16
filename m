Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5FC3A212108E6
 for <linux-nvdimm@lists.01.org>; Tue, 16 Apr 2019 09:42:18 -0700 (PDT)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 05/18] btrfs: return whether extent is nocow or not
Date: Tue, 16 Apr 2019 11:41:41 -0500
Message-Id: <20190416164154.30390-6-rgoldwyn@suse.de>
In-Reply-To: <20190416164154.30390-1-rgoldwyn@suse.de>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
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
To: linux-btrfs@vger.kernel.org
Cc: kilobyte@angband.pl, jack@suse.cz, darrick.wong@oracle.com, nborisov@suse.com, linux-nvdimm@lists.01.org, david@fromorbit.com, dsterba@suse.cz, willy@infradead.org, linux-fsdevel@vger.kernel.org, hch@lst.de, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

We require this to make sure we return type IOMAP_DAX_COW in
iomap structure, in the later patches.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ctree.h | 2 +-
 fs/btrfs/inode.c | 9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b7bbe5130a3b..050f30165531 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3278,7 +3278,7 @@ struct inode *btrfs_iget_path(struct super_block *s, struct btrfs_key *location,
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *was_new);
 int btrfs_get_extent_map_write(struct extent_map **map, struct buffer_head *bh,
-		struct inode *inode, u64 start, u64 len);
+		struct inode *inode, u64 start, u64 len, bool *nocow);
 struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 				    struct page *page, size_t pg_offset,
 				    u64 start, u64 end, int create);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 80184d0c3b52..06764d89490f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7499,12 +7499,15 @@ static int btrfs_get_blocks_direct_read(struct extent_map *em,
 int btrfs_get_extent_map_write(struct extent_map **map,
 		struct buffer_head *bh,
 		struct inode *inode,
-		u64 start, u64 len)
+		u64 start, u64 len, bool *nocow)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct extent_map *em = *map;
 	int ret = 0;
 
+	if (nocow)
+		*nocow = false;
+
 	/*
 	 * We don't allocate a new extent in the following cases
 	 *
@@ -7553,6 +7556,8 @@ int btrfs_get_extent_map_write(struct extent_map **map,
 			 */
 			btrfs_free_reserved_data_space_noquota(inode, start,
 							       len);
+			if (nocow)
+				*nocow = true;
 			/* skip COW */
 			goto out;
 		}
@@ -7579,7 +7584,7 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 	struct extent_map *em;
 
 	ret = btrfs_get_extent_map_write(map, bh_result, inode,
-			start, len);
+			start, len, NULL);
 	if (ret < 0)
 		return ret;
 	em = *map;
-- 
2.16.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
