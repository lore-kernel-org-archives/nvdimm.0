Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 57B9E1A1EE0
 for <linux-nvdimm@lists.01.org>; Wed, 14 Sep 2016 23:57:42 -0700 (PDT)
Subject: [PATCH v2 2/3] mm, dax: add VM_DAX flag for DAX VMAs
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Sep 2016 23:54:38 -0700
Message-ID: <147392247875.9873.4205533916442000884.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147392246509.9873.17750323049785100997.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147392246509.9873.17750323049785100997.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-mm@kvack.org
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, npiggin@gmail.com, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The DAX property, page cache bypass, of a VMA is only detectable via the
vma_is_dax() helper to check the S_DAX inode flag.  However, this is
only available internal to the kernel and is a property that userspace
applications would like to interrogate.

Yes, this new VM_DAX flag is only available on 64-bit, but the
expectation is that the capacities of persistent memory devices are too
large for 32-bit platforms.  While there is usage of DAX on 32-bit, that
usage is primarily driven by DAX's replacement of XIP.  XIP is a memory
saving technique for embedded devices to execute out of DAX, but in that
usage the application does not need to discern if page cache is present
or not.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c  |    2 +-
 fs/Kconfig         |    1 +
 fs/ext2/file.c     |    2 +-
 fs/ext4/file.c     |    2 +-
 fs/proc/task_mmu.c |    1 +
 fs/xfs/xfs_file.c  |    2 +-
 include/linux/mm.h |   10 ++++++++++
 7 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 88fad2519907..1cb4117870bd 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -528,7 +528,7 @@ static int dax_dev_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	kref_get(&dax_dev->kref);
 	vma->vm_ops = &dax_dev_vm_ops;
-	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE | VM_SYNC;
+	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE | VM_SYNC | VM_DAX;
 	return 0;
 
 }
diff --git a/fs/Kconfig b/fs/Kconfig
index 2bc7ad775842..6d9afe4c1710 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -38,6 +38,7 @@ config FS_DAX
 	bool "Direct Access (DAX) support"
 	depends on MMU
 	depends on !(ARM || MIPS || SPARC)
+	select ARCH_USES_HIGH_VMA_FLAGS if 64BIT
 	help
 	  Direct Access (DAX) can be used on memory-backed block devices.
 	  If the block device supports DAX and the filesystem supports DAX,
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 5efeefe17abb..b9c829cf427c 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -118,7 +118,7 @@ static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
 
 	file_accessed(file);
 	vma->vm_ops = &ext2_dax_vm_ops;
-	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE | VM_DAX;
 	return 0;
 }
 #else
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 261ac3734c58..7a777f1bbde3 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -312,7 +312,7 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 	file_accessed(file);
 	if (IS_DAX(file_inode(file))) {
 		vma->vm_ops = &ext4_dax_vm_ops;
-		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE | VM_DAX;
 	} else {
 		vma->vm_ops = &ext4_file_vm_ops;
 	}
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 03a65ac7f222..b9b9dc059e19 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -677,6 +677,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 #endif
 #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
 		[ilog2(VM_SYNC)]	= "sn",
+		[ilog2(VM_DAX)]		= "dx",
 #endif
 	};
 	size_t i;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e612a0233710..80ed83405683 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1644,7 +1644,7 @@ xfs_file_mmap(
 	file_accessed(filp);
 	vma->vm_ops = &xfs_file_vm_ops;
 	if (IS_DAX(file_inode(filp)))
-		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE | VM_DAX;
 	return 0;
 }
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f3f6df6bb498..5930402596c0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -204,11 +204,13 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HIGH_ARCH_BIT_2	34
 #define VM_HIGH_ARCH_BIT_3	35
 #define VM_HIGH_ARCH_BIT_4	36
+#define VM_HIGH_ARCH_BIT_5	37
 #define VM_HIGH_ARCH_0	BIT(VM_HIGH_ARCH_BIT_0)
 #define VM_HIGH_ARCH_1	BIT(VM_HIGH_ARCH_BIT_1)
 #define VM_HIGH_ARCH_2	BIT(VM_HIGH_ARCH_BIT_2)
 #define VM_HIGH_ARCH_3	BIT(VM_HIGH_ARCH_BIT_3)
 #define VM_HIGH_ARCH_4	BIT(VM_HIGH_ARCH_BIT_4)
+#define VM_HIGH_ARCH_5	BIT(VM_HIGH_ARCH_BIT_5)
 #endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
 
 #if defined(CONFIG_X86)
@@ -243,8 +245,16 @@ extern unsigned int kobjsize(const void *objp);
  * synced before fault handler returns to userspace
  */
 #define VM_SYNC		VM_HIGH_ARCH_4
+/*
+ * Mapping is not indirected through the page-cache, accesses hit memory
+ * media directly*.
+ *
+ * (*) a fileystem may map the zero-page into holes of a file.
+ */
+#define VM_DAX		VM_HIGH_ARCH_5
 #else
 #define VM_SYNC		0
+#define VM_DAX		0
 #endif
 
 #ifndef VM_GROWSUP

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
