Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F41701A1F60
 for <linux-nvdimm@lists.01.org>; Wed, 11 May 2016 02:59:23 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 6/7] dax: Remove pointless writeback from dax_do_io()
Date: Wed, 11 May 2016 11:58:52 +0200
Message-Id: <1462960733-29634-7-git-send-email-jack@suse.cz>
In-Reply-To: <1462960733-29634-1-git-send-email-jack@suse.cz>
References: <1462960733-29634-1-git-send-email-jack@suse.cz>
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
To: linux-nvdimm@lists.01.org
Cc: Ted Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

dax_do_io() is calling filemap_write_and_wait() if DIO_LOCKING flags is
set. Presumably this was copied over from direct IO code. However DAX
inodes have no pagecache pages to write so the call is pointless. Remove
it.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7c0036dd1570..237581441bc1 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -268,15 +268,8 @@ ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
 	memset(&bh, 0, sizeof(bh));
 	bh.b_bdev = inode->i_sb->s_bdev;
 
-	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ) {
-		struct address_space *mapping = inode->i_mapping;
+	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ)
 		inode_lock(inode);
-		retval = filemap_write_and_wait_range(mapping, pos, end - 1);
-		if (retval) {
-			inode_unlock(inode);
-			goto out;
-		}
-	}
 
 	/* Protects against truncate */
 	if (!(flags & DIO_SKIP_DIO_COUNT))
@@ -297,7 +290,6 @@ ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
 
 	if (!(flags & DIO_SKIP_DIO_COUNT))
 		inode_dio_end(inode);
- out:
 	return retval;
 }
 EXPORT_SYMBOL_GPL(dax_do_io);
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
