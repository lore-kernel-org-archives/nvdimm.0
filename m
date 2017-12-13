Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22A4E220EE136
 for <linux-nvdimm@lists.01.org>; Wed, 13 Dec 2017 01:09:21 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext4: Fix ENOSPC handling in DAX page fault handler
Date: Wed, 13 Dec 2017 10:13:52 +0100
Message-Id: <20171213091352.23448-3-jack@suse.cz>
In-Reply-To: <20171213091352.23448-1-jack@suse.cz>
References: <20171213091352.23448-1-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, Ted Tso <tytso@mit.edu>
List-ID: <linux-nvdimm@lists.01.org>

When allocation of underlying block for a page fault fails, we fail the
fault with SIGBUS. However we may well hit ENOSPC just due to lots of
free blocks being held by the running / committing transaction. So
propagate the error from ext4_iomap_begin() and implement do standard
allocation retry loop in ext4_dax_huge_fault().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 1c7cd882d998..fb6f023622fe 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -280,7 +280,8 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 static int ext4_dax_huge_fault(struct vm_fault *vmf,
 		enum page_entry_size pe_size)
 {
-	int result;
+	int result, error = 0;
+	int retries = 0;
 	handle_t *handle = NULL;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct super_block *sb = inode->i_sb;
@@ -304,6 +305,7 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 		sb_start_pagefault(sb);
 		file_update_time(vmf->vma->vm_file);
 		down_read(&EXT4_I(inode)->i_mmap_sem);
+retry:
 		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
 					       EXT4_DATA_TRANS_BLOCKS(sb));
 		if (IS_ERR(handle)) {
@@ -314,9 +316,13 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 	} else {
 		down_read(&EXT4_I(inode)->i_mmap_sem);
 	}
-	result = dax_iomap_fault(vmf, pe_size, &pfn, NULL, &ext4_iomap_ops);
+	result = dax_iomap_fault(vmf, pe_size, &pfn, &error, &ext4_iomap_ops);
 	if (write) {
 		ext4_journal_stop(handle);
+
+		if ((result & VM_FAULT_ERROR) && error == -ENOSPC &&
+		    ext4_should_retry_alloc(sb, &retries))
+			goto retry;
 		/* Handling synchronous page fault? */
 		if (result & VM_FAULT_NEEDDSYNC)
 			result = dax_finish_sync_fault(vmf, pe_size, pfn);
-- 
2.12.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
