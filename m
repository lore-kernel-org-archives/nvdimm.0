Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B9C1D1A2156
 for <linux-nvdimm@lists.01.org>; Mon, 18 Apr 2016 14:35:51 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 02/18] ext4: Fix race in transient ENOSPC detection
Date: Mon, 18 Apr 2016 23:35:25 +0200
Message-Id: <1461015341-20153-3-git-send-email-jack@suse.cz>
In-Reply-To: <1461015341-20153-1-git-send-email-jack@suse.cz>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When there are blocks to free in the running transaction, block
allocator can return ENOSPC although the filesystem has some blocks to
free. We use ext4_should_retry_alloc() to force commit of the current
transaction and return whether anything was committed so that it makes
sense to retry the allocation. However the transaction may get committed
after block allocation fails but before we call
ext4_should_retry_alloc(). So ext4_should_retry_alloc() returns false
because there is nothing to commit and we wrongly return ENOSPC.

Fix the race by unconditionally returning 1 from ext4_should_retry_alloc()
when we tried to commit a transaction. This should not add any
unnecessary retries since we had a transaction running a while ago when
trying to allocate blocks and we want to retry the allocation once that
transaction has committed anyway.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/balloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index fe1f50fe764f..3020fd70c392 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -610,7 +610,8 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
 
 	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
 
-	return jbd2_journal_force_commit_nested(EXT4_SB(sb)->s_journal);
+	jbd2_journal_force_commit_nested(EXT4_SB(sb)->s_journal);
+	return 1;
 }
 
 /*
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
