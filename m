Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 759652034716F
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 06:05:04 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 01/17] mm: introduce MAP_SHARED_VALIDATE,
 a mechanism to safely define new mmap flags
Date: Thu, 19 Oct 2017 14:58:00 +0200
Message-Id: <20171019125817.11580-2-jack@suse.cz>
In-Reply-To: <20171019125817.11580-1-jack@suse.cz>
References: <20171019125817.11580-1-jack@suse.cz>
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
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Dan Williams <dan.j.williams@intel.com>

The mmap(2) syscall suffers from the ABI anti-pattern of not validating
unknown flags. However, proposals like MAP_SYNC need a mechanism to
define new behavior that is known to fail on older kernels without the
support. Define a new MAP_SHARED_VALIDATE flag pattern that is
guaranteed to fail on all legacy mmap implementations.

It is worth noting that the original proposal was for a standalone
MAP_VALIDATE flag. However, when that  could not be supported by all
archs Linus observed:

    I see why you *think* you want a bitmap. You think you want
    a bitmap because you want to make MAP_VALIDATE be part of MAP_SYNC
    etc, so that people can do

    ret = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED
		    | MAP_SYNC, fd, 0);

    and "know" that MAP_SYNC actually takes.

    And I'm saying that whole wish is bogus. You're fundamentally
    depending on special semantics, just make it explicit. It's already
    not portable, so don't try to make it so.

    Rename that MAP_VALIDATE as MAP_SHARED_VALIDATE, make it have a value
    of 0x3, and make people do

    ret = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED_VALIDATE
		    | MAP_SYNC, fd, 0);

    and then the kernel side is easier too (none of that random garbage
    playing games with looking at the "MAP_VALIDATE bit", but just another
    case statement in that map type thing.

    Boom. Done.

Similar to ->fallocate() we also want the ability to validate the
support for new flags on a per ->mmap() 'struct file_operations'
instance basis.  Towards that end arrange for flags to be generically
validated against a mmap_supported_flags exported by 'struct
file_operations'. By default all existing flags are implicitly
supported, but new flags require MAP_SHARED_VALIDATE and
per-instance-opt-in.

Cc: Jan Kara <jack@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 arch/alpha/include/uapi/asm/mman.h           |  1 +
 arch/mips/include/uapi/asm/mman.h            |  1 +
 arch/parisc/include/uapi/asm/mman.h          |  1 +
 arch/xtensa/include/uapi/asm/mman.h          |  1 +
 include/linux/fs.h                           |  1 +
 include/linux/mman.h                         | 39 ++++++++++++++++++++++++++++
 include/uapi/asm-generic/mman-common.h       |  1 +
 mm/mmap.c                                    | 21 +++++++++++++++
 tools/include/uapi/asm-generic/mman-common.h |  1 +
 9 files changed, 67 insertions(+)

diff --git a/arch/alpha/include/uapi/asm/mman.h b/arch/alpha/include/uapi/asm/mman.h
index 3b26cc62dadb..92823f24890b 100644
--- a/arch/alpha/include/uapi/asm/mman.h
+++ b/arch/alpha/include/uapi/asm/mman.h
@@ -14,6 +14,7 @@
 #define MAP_TYPE	0x0f		/* Mask for type of mapping (OSF/1 is _wrong_) */
 #define MAP_FIXED	0x100		/* Interpret addr exactly */
 #define MAP_ANONYMOUS	0x10		/* don't use a file */
+#define MAP_SHARED_VALIDATE 0x3		/* share + validate extension flags */
 
 /* not used by linux, but here to make sure we don't clash with OSF/1 defines */
 #define _MAP_HASSEMAPHORE 0x0200
diff --git a/arch/mips/include/uapi/asm/mman.h b/arch/mips/include/uapi/asm/mman.h
index da3216007fe0..c77689076577 100644
--- a/arch/mips/include/uapi/asm/mman.h
+++ b/arch/mips/include/uapi/asm/mman.h
@@ -30,6 +30,7 @@
 #define MAP_PRIVATE	0x002		/* Changes are private */
 #define MAP_TYPE	0x00f		/* Mask for type of mapping */
 #define MAP_FIXED	0x010		/* Interpret addr exactly */
+#define MAP_SHARED_VALIDATE 0x3		/* share + validate extension flags */
 
 /* not used by linux, but here to make sure we don't clash with ABI defines */
 #define MAP_RENAME	0x020		/* Assign page to file */
diff --git a/arch/parisc/include/uapi/asm/mman.h b/arch/parisc/include/uapi/asm/mman.h
index 775b5d5e41a1..36b688d52de3 100644
--- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -14,6 +14,7 @@
 #define MAP_TYPE	0x03		/* Mask for type of mapping */
 #define MAP_FIXED	0x04		/* Interpret addr exactly */
 #define MAP_ANONYMOUS	0x10		/* don't use a file */
+#define MAP_SHARED_VALIDATE 0x3		/* share + validate extension flags */
 
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
 #define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
diff --git a/arch/xtensa/include/uapi/asm/mman.h b/arch/xtensa/include/uapi/asm/mman.h
index b15b278aa314..ec597900eec7 100644
--- a/arch/xtensa/include/uapi/asm/mman.h
+++ b/arch/xtensa/include/uapi/asm/mman.h
@@ -37,6 +37,7 @@
 #define MAP_PRIVATE	0x002		/* Changes are private */
 #define MAP_TYPE	0x00f		/* Mask for type of mapping */
 #define MAP_FIXED	0x010		/* Interpret addr exactly */
+#define MAP_SHARED_VALIDATE 0x3		/* share + validate extension flags */
 
 /* not used by linux, but here to make sure we don't clash with ABI defines */
 #define MAP_RENAME	0x020		/* Assign page to file */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 13dab191a23e..57added3201d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1701,6 +1701,7 @@ struct file_operations {
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
+	unsigned long mmap_supported_flags;
 	int (*open) (struct inode *, struct file *);
 	int (*flush) (struct file *, fl_owner_t id);
 	int (*release) (struct inode *, struct file *);
diff --git a/include/linux/mman.h b/include/linux/mman.h
index c8367041fafd..94b63b4d71ff 100644
--- a/include/linux/mman.h
+++ b/include/linux/mman.h
@@ -7,6 +7,45 @@
 #include <linux/atomic.h>
 #include <uapi/linux/mman.h>
 
+/*
+ * Arrange for legacy / undefined architecture specific flags to be
+ * ignored by default in LEGACY_MAP_MASK.
+ */
+#ifndef MAP_32BIT
+#define MAP_32BIT 0
+#endif
+#ifndef MAP_HUGE_2MB
+#define MAP_HUGE_2MB 0
+#endif
+#ifndef MAP_HUGE_1GB
+#define MAP_HUGE_1GB 0
+#endif
+#ifndef MAP_UNINITIALIZED
+#define MAP_UNINITIALIZED 0
+#endif
+
+/*
+ * The historical set of flags that all mmap implementations implicitly
+ * support when a ->mmap_validate() op is not provided in file_operations.
+ */
+#define LEGACY_MAP_MASK (MAP_SHARED \
+		| MAP_PRIVATE \
+		| MAP_FIXED \
+		| MAP_ANONYMOUS \
+		| MAP_DENYWRITE \
+		| MAP_EXECUTABLE \
+		| MAP_UNINITIALIZED \
+		| MAP_GROWSDOWN \
+		| MAP_LOCKED \
+		| MAP_NORESERVE \
+		| MAP_POPULATE \
+		| MAP_NONBLOCK \
+		| MAP_STACK \
+		| MAP_HUGETLB \
+		| MAP_32BIT \
+		| MAP_HUGE_2MB \
+		| MAP_HUGE_1GB)
+
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern unsigned long sysctl_overcommit_kbytes;
diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index 203268f9231e..ac55d1c0ec0f 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -24,6 +24,7 @@
 #else
 # define MAP_UNINITIALIZED 0x0		/* Don't support this flag */
 #endif
+#define MAP_SHARED_VALIDATE 0x3		/* share + validate extension flags */
 
 /*
  * Flags for mlock
diff --git a/mm/mmap.c b/mm/mmap.c
index 680506faceae..d6bcb97dd84a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1387,9 +1387,30 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 
 	if (file) {
 		struct inode *inode = file_inode(file);
+		unsigned long flags_mask = file->f_op->mmap_supported_flags;
+
+		if (!flags_mask)
+			flags_mask = LEGACY_MAP_MASK;
 
 		switch (flags & MAP_TYPE) {
 		case MAP_SHARED:
+			/*
+			 * Silently ignore unsupported flags - MAP_SHARED has
+			 * traditionally behaved like that and we don't want
+			 * to break compatibility.
+			 */
+			flags &= flags_mask;
+			/*
+			 * Force use of MAP_SHARED_VALIDATE with non-legacy
+			 * flags. E.g. MAP_SYNC is dangerous to use with
+			 * MAP_SHARED as you don't know which consistency model
+			 * you will get.
+			 */
+			flags &= LEGACY_MAP_MASK;
+			/* fall through */
+		case MAP_SHARED_VALIDATE:
+			if (flags & ~flags_mask)
+				return -EOPNOTSUPP;
 			if ((prot&PROT_WRITE) && !(file->f_mode&FMODE_WRITE))
 				return -EACCES;
 
diff --git a/tools/include/uapi/asm-generic/mman-common.h b/tools/include/uapi/asm-generic/mman-common.h
index 203268f9231e..ac55d1c0ec0f 100644
--- a/tools/include/uapi/asm-generic/mman-common.h
+++ b/tools/include/uapi/asm-generic/mman-common.h
@@ -24,6 +24,7 @@
 #else
 # define MAP_UNINITIALIZED 0x0		/* Don't support this flag */
 #endif
+#define MAP_SHARED_VALIDATE 0x3		/* share + validate extension flags */
 
 /*
  * Flags for mlock
-- 
2.12.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
