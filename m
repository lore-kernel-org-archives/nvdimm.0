Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BE1F681D12
 for <linux-nvdimm@lists.01.org>; Tue,  1 Nov 2016 14:22:11 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 05/11] ext4: Use iomap for zeroing blocks in DAX mode
Date: Tue,  1 Nov 2016 22:06:15 +0100
Message-Id: <1478034381-19037-6-git-send-email-jack@suse.cz>
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

Use iomap infrastructure for zeroing blocks when in DAX mode.
ext4_iomap_begin() handles read requests just fine and that's all that
is needed for iomap_zero_range().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cc10145ea98b..ac26a390f14c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3844,8 +3844,10 @@ static int ext4_block_zero_page_range(handle_t *handle,
 	if (length > max || length < 0)
 		length = max;
 
-	if (IS_DAX(inode))
-		return dax_zero_page_range(inode, from, length, ext4_get_block);
+	if (IS_DAX(inode)) {
+		return iomap_zero_range(inode, from, length, NULL,
+					&ext4_iomap_ops);
+	}
 	return __ext4_block_zero_page_range(handle, mapping, from, length);
 }
 
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
