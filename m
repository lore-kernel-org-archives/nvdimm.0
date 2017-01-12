Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1EA6D81C1C
 for <linux-nvdimm@lists.01.org>; Thu, 12 Jan 2017 09:43:11 -0800 (PST)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v5] DAX: enable iostat for read/write
Date: Thu, 12 Jan 2017 11:38:48 -0700
Message-Id: <20170112183848.23159-1-toshi.kani@hpe.com>
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
To: akpm@linux-foundation.org, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

DAX IO path does not support iostat, but its metadata IO path does.
Therefore, iostat shows metadata IO statistics only, which has been
confusing to users.

Add iostat support to the DAX read/write path.

Note, iostat still does not support the DAX mmap path as it allows
user applications to access directly.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
---
v5:
 - Add a flag in case 'start' is 0 after 'jiffies' rolls over.
   (Dan Williams)
 - Fix a signed/unsigned conversion. (Joe Perches)
---
 fs/dax.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 5c74f60..a3e406a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1058,12 +1058,24 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 {
 	struct address_space *mapping = iocb->ki_filp->f_mapping;
 	struct inode *inode = mapping->host;
+	struct gendisk *disk = inode->i_sb->s_bdev->bd_disk;
 	loff_t pos = iocb->ki_pos, ret = 0, done = 0;
 	unsigned flags = 0;
+	unsigned long start = 0;
+	int do_acct = blk_queue_io_stat(disk->queue);
 
 	if (iov_iter_rw(iter) == WRITE)
 		flags |= IOMAP_WRITE;
 
+	if (do_acct) {
+		sector_t sec = iov_iter_count(iter) >> 9;
+
+		start = jiffies;
+		generic_start_io_acct(iov_iter_rw(iter),
+				      min_t(unsigned long, 1, sec),
+				      &disk->part0);
+	}
+
 	while (iov_iter_count(iter)) {
 		ret = iomap_apply(inode, pos, iov_iter_count(iter), flags, ops,
 				iter, dax_iomap_actor);
@@ -1073,6 +1085,9 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		done += ret;
 	}
 
+	if (do_acct)
+		generic_end_io_acct(iov_iter_rw(iter), &disk->part0, start);
+
 	iocb->ki_pos += done;
 	return done ? done : ret;
 }
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
