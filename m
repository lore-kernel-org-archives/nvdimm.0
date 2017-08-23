Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 25FF22095DC99
 for <linux-nvdimm@lists.01.org>; Tue, 22 Aug 2017 20:35:17 -0700 (PDT)
Received: by mail-pg0-x243.google.com with SMTP id y129so524426pgy.3
 for <linux-nvdimm@lists.01.org>; Tue, 22 Aug 2017 20:37:50 -0700 (PDT)
From: rdodgen@gmail.com
Subject: [PATCH v2] Fix ext4 fault handling when mounted with -o dax,ro
Date: Tue, 22 Aug 2017 20:37:04 -0700
Message-Id: <bea6897723e5bf09d893b2ca40263a894a284a5a.1503459187.git.dodgen@google.com>
In-Reply-To: <20170822222434.146233-1-dodgen@google.com>
References: <20170822222434.146233-1-dodgen@google.com>
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

This changes replicates some check from dax_iomap_fault to more
precisely reason about when a journal-write is needed.

It might be the case that this could be better handled in
ext4_iomap_begin / ext4_iomap_end (called via iomap_ops inside
dax_iomap_fault). These is some overlap already (e.g. grabbing journal
handles).

Signed-off-by: Randy Dodgen <dodgen@google.com>
---

I'm resending for some DMARC-proofing (thanks Ted for the explanation), a
missing Signed-off-by, and some extra cc's. Oops!

 fs/ext4/file.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 0d7cf0cc9b87..d512fb85a3e3 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -279,7 +279,31 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 	handle_t *handle = NULL;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct super_block *sb = inode->i_sb;
-	bool write = vmf->flags & FAULT_FLAG_WRITE;
+	bool write;
+
+	/*
+	 * We have to distinguish real writes from writes which will result in a
+	 * COW page
+	 * - COW writes need to fall-back to installing PTEs. See
+	 *   dax_iomap_pmd_fault.
+	 * - COW writes should *not* poke the journal (the file will not be
+	 *   changed). Doing so would cause unintended failures when mounted
+	 *   read-only.
+	 */
+	if (pe_size == PE_SIZE_PTE) {
+		/* See dax_iomap_pte_fault. */
+		write = (vmf->flags & FAULT_FLAG_WRITE) && !vmf->cow_page;
+	} else if (pe_size == PE_SIZE_PMD) {
+		/* See dax_iomap_pmd_fault. */
+		write = vmf->flags & FAULT_FLAG_WRITE;
+		if (write && !(vmf->vma->vm_flags & VM_SHARED)) {
+			split_huge_pmd(vmf->vma, vmf->pmd, vmf->address);
+			count_vm_event(THP_FAULT_FALLBACK);
+			return VM_FAULT_FALLBACK;
+		}
+	} else {
+		return VM_FAULT_FALLBACK;
+	}
 
 	if (write) {
 		sb_start_pagefault(sb);
-- 
2.14.1.480.gb18f417b89-goog

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
