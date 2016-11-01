Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E79A281D3D
 for <linux-nvdimm@lists.01.org>; Tue,  1 Nov 2016 14:22:13 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/11] ext4: Avoid split extents for DAX writes
Date: Tue,  1 Nov 2016 22:06:17 +0100
Message-Id: <1478034381-19037-8-git-send-email-jack@suse.cz>
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

Currently mapping of blocks for DAX writes happen with
EXT4_GET_BLOCKS_PRE_IO flag set. That has a result that each
ext4_map_blocks() call creates a separate written extent, although it
could be merged to the neighboring extents in the extent tree.  The
reason for using this flag is that in case the extent is unwritten, we
need to convert it to written one and zero it out. However this "convert
mapped range to written" operation is already implemented by
ext4_map_blocks() for the case of data writes into unwritten extent. So
just use flags for that mode of operation, simplify the code, and avoid
unnecessary split extents.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d07d003ebce2..635518dde20e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3346,7 +3346,6 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 			return PTR_ERR(handle);
 
 		ret = ext4_map_blocks(handle, inode, &map,
-				      EXT4_GET_BLOCKS_PRE_IO |
 				      EXT4_GET_BLOCKS_CREATE_ZERO);
 		if (ret < 0) {
 			ext4_journal_stop(handle);
@@ -3355,22 +3354,6 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 				goto retry;
 			return ret;
 		}
-		/* For DAX writes we need to zero out unwritten extents */
-		if (map.m_flags & EXT4_MAP_UNWRITTEN) {
-			/*
-			 * We are protected by i_mmap_sem or i_rwsem so we know
-			 * block cannot go away from under us even though we
-			 * dropped i_data_sem. Convert extent to written and
-			 * write zeros there.
-			 */
-			ret = ext4_map_blocks(handle, inode, &map,
-					      EXT4_GET_BLOCKS_CONVERT |
-					      EXT4_GET_BLOCKS_CREATE_ZERO);
-			if (ret < 0) {
-				ext4_journal_stop(handle);
-				return ret;
-			}
-		}
 	}
 
 	iomap->flags = 0;
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
