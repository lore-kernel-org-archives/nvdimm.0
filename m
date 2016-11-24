Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E1BA181EE4
 for <linux-nvdimm@lists.01.org>; Thu, 24 Nov 2016 01:47:02 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/6] ext2: Return BH_New buffers for zeroed blocks
Date: Thu, 24 Nov 2016 10:46:31 +0100
Message-Id: <1479980796-26161-2-git-send-email-jack@suse.cz>
In-Reply-To: <1479980796-26161-1-git-send-email-jack@suse.cz>
References: <1479980796-26161-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

So far we did not return BH_New buffers from ext2_get_blocks() when we
allocated and zeroed-out a block for DAX inode to avoid racy zeroing in
DAX code. This zeroing is gone these days so we can remove the
workaround.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 046b642f3585..e626fe892c01 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -754,9 +754,8 @@ static int ext2_get_blocks(struct inode *inode,
 			mutex_unlock(&ei->truncate_mutex);
 			goto cleanup;
 		}
-	} else {
-		*new = true;
 	}
+	*new = true;
 
 	ext2_splice_branch(inode, iblock, partial, indirect_blks, count);
 	mutex_unlock(&ei->truncate_mutex);
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
