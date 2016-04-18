Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27B721A2281
 for <linux-nvdimm@lists.01.org>; Mon, 18 Apr 2016 14:35:53 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 05/18] ext2: Avoid DAX zeroing to corrupt data
Date: Mon, 18 Apr 2016 23:35:28 +0200
Message-Id: <1461015341-20153-6-git-send-email-jack@suse.cz>
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

Currently ext2 zeroes any data blocks allocated for DAX inode however it
still returns them as BH_New. Thus DAX code zeroes them again in
dax_insert_mapping() which can possibly overwrite the data that has been
already stored to those blocks by a racing dax_io(). Avoid marking
pre-zeroed buffers as new.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 6bd58e6ff038..1f07b758b968 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -745,11 +745,11 @@ static int ext2_get_blocks(struct inode *inode,
 			mutex_unlock(&ei->truncate_mutex);
 			goto cleanup;
 		}
-	}
+	} else
+		set_buffer_new(bh_result);
 
 	ext2_splice_branch(inode, iblock, partial, indirect_blks, count);
 	mutex_unlock(&ei->truncate_mutex);
-	set_buffer_new(bh_result);
 got_it:
 	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
 	if (count > blocks_to_boundary)
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
