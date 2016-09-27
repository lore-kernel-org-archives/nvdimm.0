Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED8061A1E47
 for <linux-nvdimm@lists.01.org>; Tue, 27 Sep 2016 09:43:49 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/6] ext4: Remove clearing of BH_New bit for zeroed blocks
Date: Tue, 27 Sep 2016 18:43:32 +0200
Message-Id: <1474994615-29553-4-git-send-email-jack@suse.cz>
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

So far we did not return BH_New buffers from ext4_dax_get_block()
because that would trigger racy zeroing in DAX code. This zeroing is
gone these days so we can remove the workaround.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 87150122d361..7ccd6fd7819d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3298,11 +3298,6 @@ int ext4_dax_get_block(struct inode *inode, sector_t iblock,
 		if (ret < 0)
 			return ret;
 	}
-	/*
-	 * At least for now we have to clear BH_New so that DAX code
-	 * doesn't attempt to zero blocks again in a racy way.
-	 */
-	clear_buffer_new(bh_result);
 	return 0;
 }
 #else
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
