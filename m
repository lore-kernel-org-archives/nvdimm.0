Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C99EF2122C2E8
 for <linux-nvdimm@lists.01.org>; Mon, 29 Apr 2019 10:27:31 -0700 (PDT)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 12/18] btrfs: allow MAP_SYNC mmap
Date: Mon, 29 Apr 2019 12:26:43 -0500
Message-Id: <20190429172649.8288-13-rgoldwyn@suse.de>
In-Reply-To: <20190429172649.8288-1-rgoldwyn@suse.de>
References: <20190429172649.8288-1-rgoldwyn@suse.de>
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

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
