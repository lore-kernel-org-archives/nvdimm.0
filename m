Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD77281D11
 for <linux-nvdimm@lists.01.org>; Tue,  1 Nov 2016 14:22:11 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 02/11] ext4: Allow unaligned unlocked DAX IO
Date: Tue,  1 Nov 2016 22:06:12 +0100
Message-Id: <1478034381-19037-3-git-send-email-jack@suse.cz>
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

Currently we don't allow unaligned writes without inode_lock. This is
because zeroing of partial blocks could cause data corruption for racing
unaligned writes to the same block. However DAX handles zeroing during
block allocation and thus zeroing of partial blocks cannot race. Allow
DAX unaligned IO to run without inode_lock.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index a6a7becb9465..55f8b922b76d 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -161,7 +161,8 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	iocb->private = &overwrite;
 	/* Check whether we do a DIO overwrite or not */
-	if (o_direct && ext4_should_dioread_nolock(inode) && !unaligned_aio &&
+	if (((o_direct && !unaligned_aio) || IS_DAX(inode)) &&
+	    ext4_should_dioread_nolock(inode) &&
 	    ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from)))
 		overwrite = 1;
 
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
