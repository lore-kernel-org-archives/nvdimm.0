Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ADB3A1A1E18
 for <linux-nvdimm@lists.01.org>; Tue, 27 Sep 2016 09:43:45 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/6] xfs: Set BH_New for allocated DAX blocks in
 __xfs_get_blocks()
Date: Tue, 27 Sep 2016 18:43:33 +0200
Message-Id: <1474994615-29553-5-git-send-email-jack@suse.cz>
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

So far we did not set BH_New for newly allocated blocks for DAX inodes
in __xfs_get_blocks() because we wanted to avoid zeroing done in generic
DAX code which was racy. Now the zeroing is gone so we can remove this
workaround and return BH_New for newly allocated blocks. DAX will use this
information to properly update mappings of the file.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_aops.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4a28fa91e3b1..b25b7b5a1e6e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1245,11 +1245,8 @@ __xfs_get_blocks(
 		goto out_unlock;
 	}
 
-	if (IS_DAX(inode) && create) {
+	if (IS_DAX(inode) && create)
 		ASSERT(!ISUNWRITTEN(&imap));
-		/* zeroing is not needed at a higher layer */
-		new = 0;
-	}
 
 	/* trim mapping down to size requested */
 	xfs_map_trim_size(inode, iblock, bh_result, &imap, offset, size);
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
