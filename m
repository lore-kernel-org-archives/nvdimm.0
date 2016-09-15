Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8AFA01A1EDC
 for <linux-nvdimm@lists.01.org>; Wed, 14 Sep 2016 23:57:37 -0700 (PDT)
Subject: [PATCH v2 1/3] mm, dax: add VM_SYNC flag for device-dax VMAs
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Sep 2016 23:54:33 -0700
Message-ID: <147392247341.9873.312027612778133485.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Introduce a new vma flag to indicate the property of device-dax VMAs
that, while file-backed, do not require notification to a filesystem
agent to sync metadata after a fault.  In particular this enables
persistent memory applications to know if they can commit transactions
to media via cpu instructions alone, or need to call back into the
kernel to synchronize metadata.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/Kconfig |    1 +
 drivers/dax/dax.c   |    2 +-
 fs/proc/task_mmu.c  |    3 +++
 include/linux/mm.h  |   21 +++++++++++++++++----
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index cedab7572de3..a4d99e637623 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -2,6 +2,7 @@ menuconfig DEV_DAX
 	tristate "DAX: direct access to differentiated memory"
 	default m if NVDIMM_DAX
 	depends on TRANSPARENT_HUGEPAGE
+	select ARCH_USES_HIGH_VMA_FLAGS if 64BIT
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
 	  latency...) memory via an mmap(2) capable character
diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 29f600f2c447..88fad2519907 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -528,7 +528,7 @@ static int dax_dev_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	kref_get(&dax_dev->kref);
 	vma->vm_ops = &dax_dev_vm_ops;
-	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE | VM_SYNC;
 	return 0;
 
 }
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index f6fa99eca515..03a65ac7f222 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -675,6 +675,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 		[ilog2(VM_PKEY_BIT2)]	= "",
 		[ilog2(VM_PKEY_BIT3)]	= "",
 #endif
+#ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
+		[ilog2(VM_SYNC)]	= "sn",
+#endif
 	};
 	size_t i;
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ef815b9cd426..f3f6df6bb498 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -198,14 +198,17 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
 
 #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
-#define VM_HIGH_ARCH_BIT_0	32	/* bit only usable on 64-bit architectures */
-#define VM_HIGH_ARCH_BIT_1	33	/* bit only usable on 64-bit architectures */
-#define VM_HIGH_ARCH_BIT_2	34	/* bit only usable on 64-bit architectures */
-#define VM_HIGH_ARCH_BIT_3	35	/* bit only usable on 64-bit architectures */
+/* bits below only usable on 64-bit architectures */
+#define VM_HIGH_ARCH_BIT_0	32
+#define VM_HIGH_ARCH_BIT_1	33
+#define VM_HIGH_ARCH_BIT_2	34
+#define VM_HIGH_ARCH_BIT_3	35
+#define VM_HIGH_ARCH_BIT_4	36
 #define VM_HIGH_ARCH_0	BIT(VM_HIGH_ARCH_BIT_0)
 #define VM_HIGH_ARCH_1	BIT(VM_HIGH_ARCH_BIT_1)
 #define VM_HIGH_ARCH_2	BIT(VM_HIGH_ARCH_BIT_2)
 #define VM_HIGH_ARCH_3	BIT(VM_HIGH_ARCH_BIT_3)
+#define VM_HIGH_ARCH_4	BIT(VM_HIGH_ARCH_BIT_4)
 #endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
 
 #if defined(CONFIG_X86)
@@ -234,6 +237,16 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_MPX		VM_ARCH_2
 #endif
 
+#ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
+/*
+ * The metadata for file-backed vma does not exist or is otherwise
+ * synced before fault handler returns to userspace
+ */
+#define VM_SYNC		VM_HIGH_ARCH_4
+#else
+#define VM_SYNC		0
+#endif
+
 #ifndef VM_GROWSUP
 # define VM_GROWSUP	VM_NONE
 #endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
