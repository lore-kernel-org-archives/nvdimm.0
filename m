Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9BCA81A1E0B
 for <linux-nvdimm@lists.01.org>; Tue, 27 Sep 2016 09:43:45 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 6/6] dax: Avoid page invalidation races and unnecessary radix
 tree traversals
Date: Tue, 27 Sep 2016 18:43:35 +0200
Message-Id: <1474994615-29553-7-git-send-email-jack@suse.cz>
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

Currently each filesystem (possibly through generic_file_direct_write()
or iomap_dax_rw()) takes care of invalidating page tables and evicting
hole pages from the radix tree when write(2) to the file happens. This
invalidation is only necessary when there is some block allocation
resulting from write(2). Furthermore in current place the invalidation
is racy wrt page fault instantiating a hole page just after we have
invalidated it.

So perform the page invalidation inside dax_do_io() where we can do it
only when really necessary and after blocks have been allocated so
nobody will be instantiating new hole pages anymore.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index c8a639d2214e..2f69ca891aab 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -186,6 +186,18 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 				 */
 				WARN_ON_ONCE(rw == WRITE &&
 					     buffer_unwritten(bh));
+				/*
+				 * Write can allocate block for an area which
+				 * has a hole page mapped into page tables. We
+				 * have to tear down these mappings so that
+				 * data written by write(2) is visible in mmap.
+				 */
+				if (buffer_new(bh) &&
+				    inode->i_mapping->nrpages) {
+					invalidate_inode_pages2_range(
+						  inode->i_mapping, page,
+						  (bh_max - 1) >> PAGE_SHIFT);
+				}
 			} else {
 				unsigned done = bh->b_size -
 						(bh_max - (pos - first));
@@ -1410,6 +1422,17 @@ iomap_dax_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED))
 		return -EIO;
 
+	/*
+	 * Write can allocate block for an area which has a hole page mapped
+	 * into page tables. We have to tear down these mappings so that data
+	 * written by write(2) is visible in mmap.
+	 */
+	if (iomap->flags & IOMAP_F_NEW && inode->i_mapping->nrpages) {
+		invalidate_inode_pages2_range(inode->i_mapping,
+					      pos >> PAGE_SHIFT,
+					      (end - 1) >> PAGE_SHIFT);
+	}
+
 	while (pos < end) {
 		unsigned offset = pos & (PAGE_SIZE - 1);
 		struct blk_dax_ctl dax = { 0 };
@@ -1469,23 +1492,6 @@ iomap_dax_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iov_iter_rw(iter) == WRITE)
 		flags |= IOMAP_WRITE;
 
-	/*
-	 * Yes, even DAX files can have page cache attached to them:  A zeroed
-	 * page is inserted into the pagecache when we have to serve a write
-	 * fault on a hole.  It should never be dirtied and can simply be
-	 * dropped from the pagecache once we get real data for the page.
-	 *
-	 * XXX: This is racy against mmap, and there's nothing we can do about
-	 * it. We'll eventually need to shift this down even further so that
-	 * we can check if we allocated blocks over a hole first.
-	 */
-	if (mapping->nrpages) {
-		ret = invalidate_inode_pages2_range(mapping,
-				pos >> PAGE_SHIFT,
-				(pos + iov_iter_count(iter) - 1) >> PAGE_SHIFT);
-		WARN_ON_ONCE(ret);
-	}
-
 	while (iov_iter_count(iter)) {
 		ret = iomap_apply(inode, pos, iov_iter_count(iter), flags, ops,
 				iter, iomap_dax_actor);
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
