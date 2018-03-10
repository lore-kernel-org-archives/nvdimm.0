Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x241.google.com (mail-pf0-x241.google.com
 [IPv6:2607:f8b0:400e:c00::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C521022603AE4
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:31 -0800 (PST)
Received: by mail-pf0-x241.google.com with SMTP id f80so2617490pfa.8
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:50 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 28/83] Add NOVA address space operations
Date: Sat, 10 Mar 2018 10:18:09 -0800
Message-Id: <1520705944-6723-29-git-send-email-jix024@eng.ucsd.edu>
In-Reply-To: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: coughlan@redhat.com, miklos@szeredi.hu, Andiry Xu <jix024@cs.ucsd.edu>, david@fromorbit.com, jack@suse.com, swanson@cs.ucsd.edu, swhiteho@redhat.com, andiry.xu@gmail.com
List-ID: <linux-nvdimm@lists.01.org>

From: Andiry Xu <jix024@cs.ucsd.edu>

direct_IO and writepages support.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/inode.c | 24 ++++++++++++++++++++++++
 fs/nova/inode.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/fs/nova/inode.c b/fs/nova/inode.c
index 7c10d0e..a30b6aa 100644
--- a/fs/nova/inode.c
+++ b/fs/nova/inode.c
@@ -175,6 +175,7 @@ static int nova_read_inode(struct super_block *sb, struct inode *inode,
 	}
 
 	inode->i_blocks = sih->i_blocks;
+	inode->i_mapping->a_ops = &nova_aops_dax;
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
@@ -488,3 +489,26 @@ int nova_free_inuse_inode(struct super_block *sb, unsigned long ino)
 	return ret;
 }
 
+static ssize_t nova_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
+{
+	/* DAX does not support direct IO */
+	return -EIO;
+}
+
+static int nova_writepages(struct address_space *mapping,
+	struct writeback_control *wbc)
+{
+	int ret;
+	timing_t wp_time;
+
+	NOVA_START_TIMING(write_pages_t, wp_time);
+	ret = dax_writeback_mapping_range(mapping,
+			mapping->host->i_sb->s_bdev, wbc);
+	NOVA_END_TIMING(write_pages_t, wp_time);
+	return ret;
+}
+
+const struct address_space_operations nova_aops_dax = {
+	.writepages		= nova_writepages,
+	.direct_IO		= nova_direct_IO,
+};
diff --git a/fs/nova/inode.h b/fs/nova/inode.h
index 497343d..e00b3b9 100644
--- a/fs/nova/inode.h
+++ b/fs/nova/inode.h
@@ -221,6 +221,7 @@ static inline int nova_persist_inode(struct nova_inode *pi)
 }
 
 
+extern const struct address_space_operations nova_aops_dax;
 int nova_init_inode_inuse_list(struct super_block *sb);
 int nova_init_inode_table(struct super_block *sb);
 int nova_get_inode_address(struct super_block *sb, u64 ino,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
