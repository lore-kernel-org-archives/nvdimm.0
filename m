Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 12/18] btrfs: allow MAP_SYNC mmap
Date: Tue, 16 Apr 2019 11:41:48 -0500
Message-Id: <20190416164154.30390-13-rgoldwyn@suse.de>
In-Reply-To: <20190416164154.30390-1-rgoldwyn@suse.de>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, david@fromorbit.com, willy@infradead.org, hch@lst.de, darrick.wong@oracle.com, kilobyte@angband.pl, dsterba@suse.cz, nborisov@suse.com, linux-nvdimm@lists.01.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Adam Borowski <kilobyte@angband.pl>

Used by userspace to detect DAX.
[rgoldwyn@suse.com: Added CONFIG_FS_DAX around mmap_supported_flags]
Signed-off-by: Adam Borowski <kilobyte@angband.pl>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9d5a3c99a6b9..362a9cf9dcb2 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -16,6 +16,7 @@
 #include <linux/btrfs.h>
 #include <linux/uio.h>
 #include <linux/iversion.h>
+#include <linux/mman.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -3319,6 +3320,9 @@ const struct file_operations btrfs_file_operations = {
 	.splice_read	= generic_file_splice_read,
 	.write_iter	= btrfs_file_write_iter,
 	.mmap		= btrfs_file_mmap,
+#ifdef CONFIG_FS_DAX
+	.mmap_supported_flags = MAP_SYNC,
+#endif
 	.open		= btrfs_file_open,
 	.release	= btrfs_release_file,
 	.fsync		= btrfs_sync_file,
-- 
2.16.4
