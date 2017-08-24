Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 652A82095B9E7
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 08:19:48 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] xfs: support for synchronous DAX faults
Date: Thu, 24 Aug 2017 17:22:07 +0200
Message-Id: <20170824152207.30729-4-hch@lst.de>
In-Reply-To: <20170824152207.30729-1-hch@lst.de>
References: <20170824152207.30729-1-hch@lst.de>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Return IOMAP_F_NEEDDSYNC from xfs_file_iomap_begin() for a synchronous
write fault when inode is pinned, and has dirty fields other than the
timestamps.  In xfs_filemap_huge_fault() we then detect this case and
call dax_finish_sync_fault() to make sure all metadata is committed, and
to insert the page table entry.

Note that this will also dirty corresponding radix tree entry which is
what we want - fsync(2) will still provide data integrity guarantees for
applications not using userspace flushing. And applications using
userspace flushing can avoid calling fsync(2) and thus avoid the
performance overhead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c  | 6 +++++-
 fs/xfs/xfs_iomap.c | 5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 460ca9639e66..5c3597b7dbf9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1031,7 +1031,11 @@ __xfs_filemap_fault(
 
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	if (IS_DAX(inode)) {
-		ret = dax_iomap_fault(vmf, pe_size, NULL, &xfs_iomap_ops);
+		pfn_t pfn;
+
+		ret = dax_iomap_fault(vmf, pe_size, &pfn, &xfs_iomap_ops);
+		if (ret & VM_FAULT_NEEDDSYNC)
+			ret = dax_finish_sync_fault(vmf, pe_size, pfn);
 	} else {
 		if (write_fault)
 			ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 813394c62849..e7c762c8fe27 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -33,6 +33,7 @@
 #include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
+#include "xfs_inode_item.h"
 #include "xfs_iomap.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
@@ -1085,6 +1086,10 @@ xfs_file_iomap_begin(
 		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
 	}
 
+	if ((flags & IOMAP_WRITE) && xfs_ipincount(ip) &&
+	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
+		iomap->flags |= IOMAP_F_NEEDDSYNC;
+
 	xfs_bmbt_to_iomap(ip, iomap, &imap);
 
 	/* optionally associate a dax device with the iomap bdev */
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
