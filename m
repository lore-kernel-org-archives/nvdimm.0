Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 990471A1DF5
 for <linux-nvdimm@lists.01.org>; Tue, 27 Sep 2016 09:43:45 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/6] dax: Do not warn about BH_New buffers
Date: Tue, 27 Sep 2016 18:43:30 +0200
Message-Id: <1474994615-29553-2-git-send-email-jack@suse.cz>
In-Reply-To: <1474994615-29553-1-git-send-email-jack@suse.cz>
References: <1474994615-29553-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Filesystems will return BH_New buffers to dax code to indicate freshly
allocated blocks which will then trigger synchronization of file
mappings in page tables with actual block mappings. So do not warn about
returned BH_New buffers.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 233f548d298e..1542653e8aa1 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -158,8 +158,6 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 		.addr = ERR_PTR(-EIO),
 	};
 	unsigned blkbits = inode->i_blkbits;
-	sector_t file_blks = (i_size_read(inode) + (1 << blkbits) - 1)
-								>> blkbits;
 
 	if (rw == READ)
 		end = min(end, i_size_read(inode));
@@ -186,9 +184,8 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 				 * We allow uninitialized buffers for writes
 				 * beyond EOF as those cannot race with faults
 				 */
-				WARN_ON_ONCE(
-					(buffer_new(bh) && block < file_blks) ||
-					(rw == WRITE && buffer_unwritten(bh)));
+				WARN_ON_ONCE(rw == WRITE &&
+					     buffer_unwritten(bh));
 			} else {
 				unsigned done = bh->b_size -
 						(bh_max - (pos - first));
@@ -985,7 +982,7 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	}
 
 	/* Filesystem should not return unwritten buffers to us! */
-	WARN_ON_ONCE(buffer_unwritten(&bh) || buffer_new(&bh));
+	WARN_ON_ONCE(buffer_unwritten(&bh));
 	error = dax_insert_mapping(mapping, bh.b_bdev, to_sector(&bh, inode),
 			bh.b_size, &entry, vma, vmf);
  unlock_entry:
@@ -1094,7 +1091,7 @@ int dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		if (get_block(inode, block, &bh, 1) != 0)
 			return VM_FAULT_SIGBUS;
 		alloc = true;
-		WARN_ON_ONCE(buffer_unwritten(&bh) || buffer_new(&bh));
+		WARN_ON_ONCE(buffer_unwritten(&bh));
 	}
 
 	bdev = bh.b_bdev;
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
