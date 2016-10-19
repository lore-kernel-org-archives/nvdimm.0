Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 41AAD1A1E6E
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 07:21:30 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 1/2] DAX: enable iostat for read/write
Date: Wed, 19 Oct 2016 08:19:43 -0600
Message-Id: <1476886784-24644-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1476886784-24644-1-git-send-email-toshi.kani@hpe.com>
References: <1476886784-24644-1-git-send-email-toshi.kani@hpe.com>
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
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
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
---
 fs/dax.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 014defd..2646969 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -265,9 +265,12 @@ ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
 	ssize_t retval = -EINVAL;
 	loff_t pos = iocb->ki_pos;
 	loff_t end = pos + iov_iter_count(iter);
+	struct gendisk *disk;
+	unsigned long start = 0;
 
 	memset(&bh, 0, sizeof(bh));
 	bh.b_bdev = inode->i_sb->s_bdev;
+	disk = bh.b_bdev->bd_disk;
 
 	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ)
 		inode_lock(inode);
@@ -276,8 +279,20 @@ ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
 	if (!(flags & DIO_SKIP_DIO_COUNT))
 		inode_dio_begin(inode);
 
+	if (blk_queue_io_stat(disk->queue)) {
+		int sec = iov_iter_count(iter) >> 9;
+
+		start = jiffies;
+		generic_start_io_acct(iov_iter_rw(iter),
+				      (!sec) ? 1 : sec, &disk->part0);
+	}
+
 	retval = dax_io(inode, iter, pos, end, get_block, &bh);
 
+	if (start)
+		generic_end_io_acct(iov_iter_rw(iter),
+				    &disk->part0, start);
+
 	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ)
 		inode_unlock(inode);
 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
