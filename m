Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B583B2195DA6F
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 00:25:10 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] ext4: Return back to starting transaction in
 ext4_dax_huge_fault()
Date: Fri,  5 May 2017 09:24:59 +0200
Message-Id: <20170505072500.25692-4-jack@suse.cz>
In-Reply-To: <20170505072500.25692-1-jack@suse.cz>
References: <20170505072500.25692-1-jack@suse.cz>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

DAX will return to locking exceptional entry before mapping blocks
for a page fault to fix possible races with concurrent writes. To avoid
lock inversion between exceptional entry lock and transaction start,
start the transaction already in ext4_dax_huge_fault().

Fixes: 9f141d6ef6258a3a37a045842d9ba7e68f368956
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index cefa9835f275..831fd6beebf0 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -257,6 +257,7 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 		enum page_entry_size pe_size)
 {
 	int result;
+	handle_t *handle = NULL;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct super_block *sb = inode->i_sb;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
@@ -264,12 +265,24 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 	if (write) {
 		sb_start_pagefault(sb);
 		file_update_time(vmf->vma->vm_file);
+		down_read(&EXT4_I(inode)->i_mmap_sem);
+		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
+					       EXT4_DATA_TRANS_BLOCKS(sb));
+	} else {
+		down_read(&EXT4_I(inode)->i_mmap_sem);
 	}
-	down_read(&EXT4_I(inode)->i_mmap_sem);
-	result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops);
-	up_read(&EXT4_I(inode)->i_mmap_sem);
-	if (write)
+	if (!IS_ERR(handle))
+		result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops);
+	else
+		result = VM_FAULT_SIGBUS;
+	if (write) {
+		if (!IS_ERR(handle))
+			ext4_journal_stop(handle);
+		up_read(&EXT4_I(inode)->i_mmap_sem);
 		sb_end_pagefault(sb);
+	} else {
+		up_read(&EXT4_I(inode)->i_mmap_sem);
+	}
 
 	return result;
 }
-- 
2.12.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
