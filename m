Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2001:1868:205::9])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E43E817B2
 for <linux-nvdimm@lists.01.org>; Tue, 10 Jan 2017 07:48:17 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] dax: assert that i_rwsem is held exclusive for writes
Date: Tue, 10 Jan 2017 16:48:08 +0100
Message-Id: <1484063288-18255-3-git-send-email-hch@lst.de>
In-Reply-To: <1484063288-18255-1-git-send-email-hch@lst.de>
References: <1484063288-18255-1-git-send-email-hch@lst.de>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Make sure all callers follow the same locking protocol, given that DAX
transparantly replaced the normal buffered I/O path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 5c74f60..04734da 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1061,8 +1061,12 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t pos = iocb->ki_pos, ret = 0, done = 0;
 	unsigned flags = 0;
 
-	if (iov_iter_rw(iter) == WRITE)
+	if (iov_iter_rw(iter) == WRITE) {
+		lockdep_assert_held_exclusive(&inode->i_rwsem);
 		flags |= IOMAP_WRITE;
+	} else {
+		lockdep_assert_held(&inode->i_rwsem);
+	}
 
 	while (iov_iter_count(iter)) {
 		ret = iomap_apply(inode, pos, iov_iter_count(iter), flags, ops,
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
