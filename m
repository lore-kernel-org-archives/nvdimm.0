Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E441B81D3C
 for <linux-nvdimm@lists.01.org>; Tue,  1 Nov 2016 14:22:13 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/11] ext4: Convert DAX faults to iomap infrastructure
Date: Tue,  1 Nov 2016 22:06:18 +0100
Message-Id: <1478034381-19037-9-git-send-email-jack@suse.cz>
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

Convert DAX faults to use iomap infrastructure. We would not have to start
transaction in ext4_dax_fault() anymore since ext4_iomap_begin takes
care of that but so far we do that to avoid lock inversion of
transaction start with DAX entry lock which gets acquired in
dax_iomap_fault() before calling ->iomap_begin handler.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/file.c  |  9 +++++----
 fs/ext4/inode.c | 18 ++++++++++++++++++
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 098b39910001..2714eb6174ab 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3272,6 +3272,7 @@ static inline bool ext4_aligned_io(struct inode *inode, loff_t off, loff_t len)
 }
 
 extern struct iomap_ops ext4_iomap_ops;
+extern struct iomap_ops ext4_iomap_fault_ops;
 
 #endif	/* __KERNEL__ */
 
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index d7ab0e90d1b8..da44e49c8276 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -273,7 +273,7 @@ static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (IS_ERR(handle))
 		result = VM_FAULT_SIGBUS;
 	else
-		result = dax_fault(vma, vmf, ext4_dax_get_block);
+		result = dax_iomap_fault(vma, vmf, &ext4_iomap_fault_ops);
 
 	if (write) {
 		if (!IS_ERR(handle))
@@ -307,9 +307,10 @@ static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 
 	if (IS_ERR(handle))
 		result = VM_FAULT_SIGBUS;
-	else
-		result = dax_pmd_fault(vma, addr, pmd, flags,
-					 ext4_dax_get_block);
+	else {
+		result = dax_iomap_pmd_fault(vma, addr, pmd, flags,
+					     &ext4_iomap_fault_ops);
+	}
 
 	if (write) {
 		if (!IS_ERR(handle))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 635518dde20e..001fef06ea97 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3419,11 +3419,29 @@ static int ext4_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+/*
+ * For faults we don't allocate any blocks outside of isize and we don't want
+ * to change it so we use a dedicated function for it...
+ */
+static int ext4_iomap_fault_end(struct inode *inode, loff_t offset,
+				loff_t length, ssize_t written, unsigned flags,
+				struct iomap *iomap)
+{
+	if (flags & IOMAP_WRITE)
+		ext4_journal_stop(ext4_journal_current_handle());
+	return 0;
+}
+
 struct iomap_ops ext4_iomap_ops = {
 	.iomap_begin		= ext4_iomap_begin,
 	.iomap_end		= ext4_iomap_end,
 };
 
+struct iomap_ops ext4_iomap_fault_ops = {
+	.iomap_begin		= ext4_iomap_begin,
+	.iomap_end		= ext4_iomap_fault_end,
+};
+
 #else
 /* Just define empty function, it will never get called. */
 int ext4_dax_get_block(struct inode *inode, sector_t iblock,
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
