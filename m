Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x241.google.com (mail-pg0-x241.google.com
 [IPv6:2607:f8b0:400e:c05::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4782A21E47D56
 for <linux-nvdimm@lists.01.org>; Wed, 23 Aug 2017 14:24:44 -0700 (PDT)
Received: by mail-pg0-x241.google.com with SMTP id w27so833130pge.4
 for <linux-nvdimm@lists.01.org>; Wed, 23 Aug 2017 14:27:18 -0700 (PDT)
From: rdodgen@gmail.com
Subject: [PATCH v3] Fix ext4 fault handling when mounted with -o dax,ro
Date: Wed, 23 Aug 2017 14:26:52 -0700
Message-Id: <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen@google.com>
In-Reply-To: <CAC9jV4pfQr=z9dHqtnTP8kAXGReeLDZWAAAfW2a7KRsK22UWkA@mail.gmail.com>
References: <CAC9jV4pfQr=z9dHqtnTP8kAXGReeLDZWAAAfW2a7KRsK22UWkA@mail.gmail.com>
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
To: tytso@mit.edu, linux-ext4@vger.kernel.org, ross.zwisler@linux.intel.com
Cc: Randy Dodgen <dodgen@google.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Randy Dodgen <dodgen@google.com>

If an ext4 filesystem is mounted with both the DAX and read-only
options, executables on that filesystem will fail to start (claiming
'Segmentation fault') due to the fault handler returning
VM_FAULT_SIGBUS.

This is due to the DAX fault handler (see ext4_dax_huge_fault)
attempting to write to the journal when FAULT_FLAG_WRITE is set. This is
the wrong behavior for write faults which will lead to a COW page; in
particular, this fails for readonly mounts.

This change avoids journal writes for faults that are expected to COW.

It might be the case that this could be better handled in
ext4_iomap_begin / ext4_iomap_end (called via iomap_ops inside
dax_iomap_fault). These is some overlap already (e.g. grabbing journal
handles).

Signed-off-by: Randy Dodgen <dodgen@google.com>
---

This version is simplified as suggested by Ross; all fault sizes and fallbacks
are handled by dax_iomap_fault.

 fs/ext4/file.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 0d7cf0cc9b87..dc1e1fb6b54c 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -279,7 +279,20 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 	handle_t *handle = NULL;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct super_block *sb = inode->i_sb;
-	bool write = vmf->flags & FAULT_FLAG_WRITE;
+
+	/*
+	 * We have to distinguish real writes from writes which will result in a
+	 * COW page; COW writes should *not* poke the journal (the file will not
+	 * be changed). Doing so would cause unintended failures when mounted
+	 * read-only.
+	 *
+	 * We check for VM_SHARED rather than vmf->cow_page since the latter is
+	 * unset for pe_size != PE_SIZE_PTE (i.e. only in do_cow_fault); for
+	 * other sizes, dax_iomap_fault will handle splitting / fallback so that
+	 * we eventually come back with a COW page.
+	 */
+	bool write = (vmf->flags & FAULT_FLAG_WRITE) &&
+		(vmf->vma->vm_flags & VM_SHARED);
 
 	if (write) {
 		sb_start_pagefault(sb);
-- 
2.14.1.342.g6490525c54-goog

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
