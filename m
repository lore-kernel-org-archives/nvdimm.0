Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/2] coredump: add DAX filtering for ELF coredumps
Date: Mon,  5 Oct 2015 16:33:36 -0600
Message-Id: <1444084417-19192-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1444084417-19192-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1444084417-19192-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Add two new flags to the existing coredump mechanism for ELF files to
allow us to explicitly filter DAX mappings.  This is desirable because
DAX mappings, like hugetlb mappings, have the potential to be very
large.

Update the coredump_filter documentation in
Documentation/filesystems/proc.txt so that it addresses the new DAX
coredump flags.  Also update the documented default value of
coredump_filter to be consistent with the core(5) man page.  The
documentation being updated talks about bit 4, Dump ELF headers, which
is enabled if CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is turned on in the
kernel config.  This kernel config option defaults to "y" if both ELF
binaries and coredump are enabled.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 Documentation/filesystems/proc.txt | 22 ++++++++++++----------
 fs/binfmt_elf.c                    | 10 ++++++++++
 include/linux/sched.h              |  4 +++-
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index d411ca6..6f887cf 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1598,16 +1598,16 @@ Documentation/accounting.
 ---------------------------------------------------------------
 When a process is dumped, all anonymous memory is written to a core file as
 long as the size of the core file isn't limited. But sometimes we don't want
-to dump some memory segments, for example, huge shared memory. Conversely,
-sometimes we want to save file-backed memory segments into a core file, not
-only the individual files.
+to dump some memory segments, for example, huge shared memory or DAX.
+Conversely, sometimes we want to save file-backed memory segments into a core
+file, not only the individual files.
 
 /proc/<pid>/coredump_filter allows you to customize which memory segments
 will be dumped when the <pid> process is dumped. coredump_filter is a bitmask
 of memory types. If a bit of the bitmask is set, memory segments of the
 corresponding memory type are dumped, otherwise they are not dumped.
 
-The following 7 memory types are supported:
+The following 9 memory types are supported:
   - (bit 0) anonymous private memory
   - (bit 1) anonymous shared memory
   - (bit 2) file-backed private memory
@@ -1616,20 +1616,22 @@ The following 7 memory types are supported:
             effective only if the bit 2 is cleared)
   - (bit 5) hugetlb private memory
   - (bit 6) hugetlb shared memory
+  - (bit 7) DAX private memory
+  - (bit 8) DAX shared memory
 
   Note that MMIO pages such as frame buffer are never dumped and vDSO pages
   are always dumped regardless of the bitmask status.
 
-  Note bit 0-4 doesn't effect any hugetlb memory. hugetlb memory are only
-  effected by bit 5-6.
+  Note that bits 0-4 don't affect hugetlb or DAX memory. hugetlb memory is
+  only affected by bit 5-6, and DAX is only affected by bits 7-8.
 
-Default value of coredump_filter is 0x23; this means all anonymous memory
-segments and hugetlb private memory are dumped.
+The default value of coredump_filter is 0x33; this means all anonymous memory
+segments, ELF header pages and hugetlb private memory are dumped.
 
 If you don't want to dump all shared memory segments attached to pid 1234,
-write 0x21 to the process's proc file.
+write 0x31 to the process's proc file.
 
-  $ echo 0x21 > /proc/1234/coredump_filter
+  $ echo 0x31 > /proc/1234/coredump_filter
 
 When a new process is created, the process inherits the bitmask status from its
 parent. It is useful to set up coredump_filter before the program runs.
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 6b65996..5f399ea 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -35,6 +35,7 @@
 #include <linux/utsname.h>
 #include <linux/coredump.h>
 #include <linux/sched.h>
+#include <linux/dax.h>
 #include <asm/uaccess.h>
 #include <asm/param.h>
 #include <asm/page.h>
@@ -1236,6 +1237,15 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 	if (vma->vm_flags & VM_DONTDUMP)
 		return 0;
 
+	/* support for DAX */
+	if (vma_is_dax(vma)) {
+		if ((vma->vm_flags & VM_SHARED) && FILTER(DAX_SHARED))
+			goto whole;
+		if (!(vma->vm_flags & VM_SHARED) && FILTER(DAX_PRIVATE))
+			goto whole;
+		return 0;
+	}
+
 	/* Hugetlb memory check */
 	if (vma->vm_flags & VM_HUGETLB) {
 		if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED))
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b7b9501..3c02d92 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -483,9 +483,11 @@ static inline int get_dumpable(struct mm_struct *mm)
 #define MMF_DUMP_ELF_HEADERS	6
 #define MMF_DUMP_HUGETLB_PRIVATE 7
 #define MMF_DUMP_HUGETLB_SHARED  8
+#define MMF_DUMP_DAX_PRIVATE	9
+#define MMF_DUMP_DAX_SHARED	10
 
 #define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
-#define MMF_DUMP_FILTER_BITS	7
+#define MMF_DUMP_FILTER_BITS	9
 #define MMF_DUMP_FILTER_MASK \
 	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
 #define MMF_DUMP_FILTER_DEFAULT \
-- 
2.1.0

