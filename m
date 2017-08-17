Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 716992095B9ED
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 09:06:02 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 10/13] mm: Wire up MAP_SYNC
Date: Thu, 17 Aug 2017 18:08:12 +0200
Message-Id: <20170817160815.30466-11-jack@suse.cz>
In-Reply-To: <20170817160815.30466-1-jack@suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
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
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Pretty crude for now...

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c                  | 2 ++
 include/linux/mm.h              | 1 +
 include/linux/mman.h            | 3 ++-
 include/uapi/asm-generic/mman.h | 1 +
 mm/mmap.c                       | 5 +++++
 5 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index f84bb29e941e..850037e140d7 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -340,6 +340,8 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
 	} else {
 		vma->vm_ops = &ext4_file_vm_ops;
+		if (vma->vm_flags & VM_SYNC)
+			return -EOPNOTSUPP;
 	}
 	return 0;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index fa036093e76c..d0fb385414a4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -188,6 +188,7 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
 #define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
+#define VM_SYNC		0x00800000	/* Synchronous page faults */
 #define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
 #define VM_ARCH_2	0x02000000
 #define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
diff --git a/include/linux/mman.h b/include/linux/mman.h
index c8367041fafd..c38279b651e5 100644
--- a/include/linux/mman.h
+++ b/include/linux/mman.h
@@ -86,7 +86,8 @@ calc_vm_flag_bits(unsigned long flags)
 {
 	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
 	       _calc_vm_trans(flags, MAP_DENYWRITE,  VM_DENYWRITE ) |
-	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    );
+	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    ) |
+	       _calc_vm_trans(flags, MAP_SYNC,	     VM_SYNC      );
 }
 
 unsigned long vm_commit_limit(void);
diff --git a/include/uapi/asm-generic/mman.h b/include/uapi/asm-generic/mman.h
index 7162cd4cca73..00e55627d2df 100644
--- a/include/uapi/asm-generic/mman.h
+++ b/include/uapi/asm-generic/mman.h
@@ -12,6 +12,7 @@
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
+#define MAP_SYNC	0x80000		/* perform synchronous page faults for the mapping */
 
 /* Bits [26:31] are reserved, see mman-common.h for MAP_HUGETLB usage */
 
diff --git a/mm/mmap.c b/mm/mmap.c
index f19efcf75418..18453c04b09f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1423,12 +1423,17 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 				return -ENODEV;
 			if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
 				return -EINVAL;
+			if (!(vm_flags & VM_SHARED) && (vm_flags & VM_SYNC))
+				return -EINVAL;
 			break;
 
 		default:
 			return -EINVAL;
 		}
 	} else {
+		if (vm_flags & VM_SYNC)
+			return -EINVAL;
+
 		switch (flags & MAP_TYPE) {
 		case MAP_SHARED:
 			if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
-- 
2.12.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
