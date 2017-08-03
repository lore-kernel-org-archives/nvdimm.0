Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x241.google.com (mail-pf0-x241.google.com
 [IPv6:2607:f8b0:400e:c00::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AE3B321E1DAD9
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 00:46:15 -0700 (PDT)
Received: by mail-pf0-x241.google.com with SMTP id p13so784623pfd.4
 for <linux-nvdimm@lists.01.org>; Thu, 03 Aug 2017 00:48:27 -0700 (PDT)
From: Steven Swanson <swanson@eng.ucsd.edu>
Subject: [RFC 02/16] NOVA: Superblock and fs layout
Date: Thu, 03 Aug 2017 00:48:23 -0700
Message-ID: <150174650378.104003.6922248271239298759.stgit@hn>
In-Reply-To: <150174646416.104003.14042713459553361884.stgit@hn>
References: <150174646416.104003.14042713459553361884.stgit@hn>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Steven Swanson <steven.swanson@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

FS Layout
======================

A Nova file systems resides in single PMEM device. Nova divides the device into
4KB blocks that are arrange like so:

 block
+-----------------------------------------------------+
|  0  | primary super block (struct nova_super_block) |
+-----------------------------------------------------+
|  1  | Reserved inodes                               |
+-----------------------------------------------------+
|  2  | reserved                                      |
+-----------------------------------------------------+
|  3  | Journal pointers                              |
+-----------------------------------------------------+
| 4-5 | Inode pointer tables                          |
+-----------------------------------------------------+
|  6  | reserved                                      |
+-----------------------------------------------------+
|  7  | reserved                                      |
+-----------------------------------------------------+
| ... | data pages                                    |
+-----------------------------------------------------+
| n-2 | replica reserved Inodes                       |
+-----------------------------------------------------+
| n-1 | replica super block                           |
+-----------------------------------------------------+


Superblock and Associated Structures
====================================

The beginning of the PMEM device hold the super block and its associated
tables.  These include reserved inodes, a table of pointers to the journals
Nova uses for complex operations, and pointers to inodes tables.  Nova
maintains replicas of the super block and reserved inodes in the last two
blocks of the PMEM area.

Signed-off-by: Steven Swanson <swanson@cs.ucsd.edu>
---
 fs/nova/nova.h     | 1137 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/nova_def.h |  154 +++++++
 fs/nova/super.c    | 1222 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/super.h    |  216 +++++++++
 4 files changed, 2729 insertions(+)
 create mode 100644 fs/nova/nova.h
 create mode 100644 fs/nova/nova_def.h
 create mode 100644 fs/nova/super.c
 create mode 100644 fs/nova/super.h

diff --git a/fs/nova/nova.h b/fs/nova/nova.h
new file mode 100644
index 000000000000..b0e9e19b53b7
--- /dev/null
+++ b/fs/nova/nova.h
@@ -0,0 +1,1137 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Definitions for the NOVA filesystem.
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ * Copyright 2012-2013 Intel Corporation
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#ifndef __NOVA_H
+#define __NOVA_H
+
+#include <linux/fs.h>
+#include <linux/dax.h>
+#include <linux/init.h>
+#include <linux/time.h>
+#include <linux/rtc.h>
+#include <linux/mm.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/sched.h>
+#include <linux/mutex.h>
+#include <linux/pagemap.h>
+#include <linux/backing-dev.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/rcupdate.h>
+#include <linux/types.h>
+#include <linux/rbtree.h>
+#include <linux/radix-tree.h>
+#include <linux/version.h>
+#include <linux/kthread.h>
+#include <linux/buffer_head.h>
+#include <linux/uio.h>
+#include <linux/pmem.h>
+#include <linux/iomap.h>
+#include <linux/crc32c.h>
+#include <asm/tlbflush.h>
+#include <linux/version.h>
+#include <linux/pfn_t.h>
+#include <linux/pagevec.h>
+
+#include "nova_def.h"
+#include "stats.h"
+#include "snapshot.h"
+
+#define PAGE_SHIFT_2M 21
+#define PAGE_SHIFT_1G 30
+
+
+/*
+ * Debug code
+ */
+#ifdef pr_fmt
+#undef pr_fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#endif
+
+/* #define nova_dbg(s, args...)		pr_debug(s, ## args) */
+#define nova_dbg(s, args ...)		pr_info(s, ## args)
+#define nova_dbg1(s, args ...)
+#define nova_err(sb, s, args ...)	nova_error_mng(sb, s, ## args)
+#define nova_warn(s, args ...)		pr_warn(s, ## args)
+#define nova_info(s, args ...)		pr_info(s, ## args)
+
+extern unsigned int nova_dbgmask;
+#define NOVA_DBGMASK_MMAPHUGE	       (0x00000001)
+#define NOVA_DBGMASK_MMAP4K	       (0x00000002)
+#define NOVA_DBGMASK_MMAPVERBOSE       (0x00000004)
+#define NOVA_DBGMASK_MMAPVVERBOSE      (0x00000008)
+#define NOVA_DBGMASK_VERBOSE	       (0x00000010)
+#define NOVA_DBGMASK_TRANSACTION       (0x00000020)
+
+#define nova_dbg_mmap4k(s, args ...)		 \
+	((nova_dbgmask & NOVA_DBGMASK_MMAP4K) ? nova_dbg(s, args) : 0)
+#define nova_dbg_mmapv(s, args ...)		 \
+	((nova_dbgmask & NOVA_DBGMASK_MMAPVERBOSE) ? nova_dbg(s, args) : 0)
+#define nova_dbg_mmapvv(s, args ...)		 \
+	((nova_dbgmask & NOVA_DBGMASK_MMAPVVERBOSE) ? nova_dbg(s, args) : 0)
+
+#define nova_dbg_verbose(s, args ...)		 \
+	((nova_dbgmask & NOVA_DBGMASK_VERBOSE) ? nova_dbg(s, ##args) : 0)
+#define nova_dbgv(s, args ...)	nova_dbg_verbose(s, ##args)
+#define nova_dbg_trans(s, args ...)		 \
+	((nova_dbgmask & NOVA_DBGMASK_TRANSACTION) ? nova_dbg(s, ##args) : 0)
+
+#define NOVA_ASSERT(x) do {\
+			       if (!(x))\
+				       nova_warn("assertion failed %s:%d: %s\n", \
+			       __FILE__, __LINE__, #x);\
+		       } while (0)
+
+#define nova_set_bit		       __test_and_set_bit_le
+#define nova_clear_bit		       __test_and_clear_bit_le
+#define nova_find_next_zero_bit	       find_next_zero_bit_le
+
+#define clear_opt(o, opt)	(o &= ~NOVA_MOUNT_ ## opt)
+#define set_opt(o, opt)		(o |= NOVA_MOUNT_ ## opt)
+#define test_opt(sb, opt)	(NOVA_SB(sb)->s_mount_opt & NOVA_MOUNT_ ## opt)
+
+#define NOVA_LARGE_INODE_TABLE_SIZE    (0x200000)
+/* NOVA size threshold for using 2M blocks for inode table */
+#define NOVA_LARGE_INODE_TABLE_THREASHOLD    (0x20000000)
+/*
+ * nova inode flags
+ *
+ * NOVA_EOFBLOCKS_FL	There are blocks allocated beyond eof
+ */
+#define NOVA_EOFBLOCKS_FL      0x20000000
+/* Flags that should be inherited by new inodes from their parent. */
+#define NOVA_FL_INHERITED (FS_SECRM_FL | FS_UNRM_FL | FS_COMPR_FL | \
+			    FS_SYNC_FL | FS_NODUMP_FL | FS_NOATIME_FL |	\
+			    FS_COMPRBLK_FL | FS_NOCOMP_FL | \
+			    FS_JOURNAL_DATA_FL | FS_NOTAIL_FL | FS_DIRSYNC_FL)
+/* Flags that are appropriate for regular files (all but dir-specific ones). */
+#define NOVA_REG_FLMASK (~(FS_DIRSYNC_FL | FS_TOPDIR_FL))
+/* Flags that are appropriate for non-directories/regular files. */
+#define NOVA_OTHER_FLMASK (FS_NODUMP_FL | FS_NOATIME_FL)
+#define NOVA_FL_USER_VISIBLE (FS_FL_USER_VISIBLE | NOVA_EOFBLOCKS_FL)
+
+/* IOCTLs */
+#define	NOVA_PRINT_TIMING		0xBCD00010
+#define	NOVA_CLEAR_STATS		0xBCD00011
+#define	NOVA_PRINT_LOG			0xBCD00013
+#define	NOVA_PRINT_LOG_BLOCKNODE	0xBCD00014
+#define	NOVA_PRINT_LOG_PAGES		0xBCD00015
+#define	NOVA_PRINT_FREE_LISTS		0xBCD00018
+
+
+#define	READDIR_END			(ULONG_MAX)
+#define	INVALID_CPU			(-1)
+#define	ANY_CPU				(65536)
+#define	FREE_BATCH			(16)
+#define	DEAD_ZONE_BLOCKS		(256)
+
+extern int measure_timing;
+extern int metadata_csum;
+extern int unsafe_metadata;
+extern int inplace_data_updates;
+extern int wprotect;
+extern int data_csum;
+extern int data_parity;
+extern int dram_struct_csum;
+
+extern unsigned int blk_type_to_shift[NOVA_BLOCK_TYPE_MAX];
+extern unsigned int blk_type_to_size[NOVA_BLOCK_TYPE_MAX];
+
+
+
+#define	MMAP_WRITE_BIT	0x20UL	// mmaped for write
+#define	IS_MAP_WRITE(p)	((p) & (MMAP_WRITE_BIT))
+#define	MMAP_ADDR(p)	((p) & (PAGE_MASK))
+
+
+/* Mask out flags that are inappropriate for the given type of inode. */
+static inline __le32 nova_mask_flags(umode_t mode, __le32 flags)
+{
+	flags &= cpu_to_le32(NOVA_FL_INHERITED);
+	if (S_ISDIR(mode))
+		return flags;
+	else if (S_ISREG(mode))
+		return flags & cpu_to_le32(NOVA_REG_FLMASK);
+	else
+		return flags & cpu_to_le32(NOVA_OTHER_FLMASK);
+}
+
+/* Update the crc32c value by appending a 64b data word. */
+#define nova_crc32c_qword(qword, crc) do { \
+	asm volatile ("crc32q %1, %0" \
+		: "=r" (crc) \
+		: "r" (qword), "0" (crc)); \
+	} while (0)
+
+static inline u32 nova_crc32c(u32 crc, const u8 *data, size_t len)
+{
+	u8 *ptr = (u8 *) data;
+	u64 acc = crc; /* accumulator, crc32c value in lower 32b */
+	u32 csum;
+
+	/* x86 instruction crc32 is part of SSE-4.2 */
+	if (static_cpu_has(X86_FEATURE_XMM4_2)) {
+		/* This inline assembly implementation should be equivalent
+		 * to the kernel's crc32c_intel_le_hw() function used by
+		 * crc32c(), but this performs better on test machines.
+		 */
+		while (len > 8) {
+			asm volatile(/* 64b quad words */
+				"crc32q (%1), %0"
+				: "=r" (acc)
+				: "r"  (ptr), "0" (acc)
+			);
+			ptr += 8;
+			len -= 8;
+		}
+
+		while (len > 0) {
+			asm volatile(/* trailing bytes */
+				"crc32b (%1), %0"
+				: "=r" (acc)
+				: "r"  (ptr), "0" (acc)
+			);
+			ptr++;
+			len--;
+		}
+
+		csum = (u32) acc;
+	} else {
+		/* The kernel's crc32c() function should also detect and use the
+		 * crc32 instruction of SSE-4.2. But calling in to this function
+		 * is about 3x to 5x slower than the inline assembly version on
+		 * some test machines.
+		 */
+		csum = crc32c(crc, data, len);
+	}
+
+	return csum;
+}
+
+/* uses CPU instructions to atomically write up to 8 bytes */
+static inline void nova_memcpy_atomic(void *dst, const void *src, u8 size)
+{
+	switch (size) {
+	case 1: {
+		volatile u8 *daddr = dst;
+		const u8 *saddr = src;
+		*daddr = *saddr;
+		break;
+	}
+	case 2: {
+		volatile __le16 *daddr = dst;
+		const u16 *saddr = src;
+		*daddr = cpu_to_le16(*saddr);
+		break;
+	}
+	case 4: {
+		volatile __le32 *daddr = dst;
+		const u32 *saddr = src;
+		*daddr = cpu_to_le32(*saddr);
+		break;
+	}
+	case 8: {
+		volatile __le64 *daddr = dst;
+		const u64 *saddr = src;
+		*daddr = cpu_to_le64(*saddr);
+		break;
+	}
+	default:
+		nova_dbg("error: memcpy_atomic called with %d bytes\n", size);
+		//BUG();
+	}
+}
+
+static inline int memcpy_to_pmem_nocache(void *dst, const void *src,
+	unsigned int size)
+{
+	int ret;
+
+	ret = __copy_from_user_inatomic_nocache(dst, src, size);
+
+	return ret;
+}
+
+
+/* assumes the length to be 4-byte aligned */
+static inline void memset_nt(void *dest, uint32_t dword, size_t length)
+{
+	uint64_t dummy1, dummy2;
+	uint64_t qword = ((uint64_t)dword << 32) | dword;
+
+	asm volatile ("movl %%edx,%%ecx\n"
+		"andl $63,%%edx\n"
+		"shrl $6,%%ecx\n"
+		"jz 9f\n"
+		"1:	 movnti %%rax,(%%rdi)\n"
+		"2:	 movnti %%rax,1*8(%%rdi)\n"
+		"3:	 movnti %%rax,2*8(%%rdi)\n"
+		"4:	 movnti %%rax,3*8(%%rdi)\n"
+		"5:	 movnti %%rax,4*8(%%rdi)\n"
+		"8:	 movnti %%rax,5*8(%%rdi)\n"
+		"7:	 movnti %%rax,6*8(%%rdi)\n"
+		"8:	 movnti %%rax,7*8(%%rdi)\n"
+		"leaq 64(%%rdi),%%rdi\n"
+		"decl %%ecx\n"
+		"jnz 1b\n"
+		"9:	movl %%edx,%%ecx\n"
+		"andl $7,%%edx\n"
+		"shrl $3,%%ecx\n"
+		"jz 11f\n"
+		"10:	 movnti %%rax,(%%rdi)\n"
+		"leaq 8(%%rdi),%%rdi\n"
+		"decl %%ecx\n"
+		"jnz 10b\n"
+		"11:	 movl %%edx,%%ecx\n"
+		"shrl $2,%%ecx\n"
+		"jz 12f\n"
+		"movnti %%eax,(%%rdi)\n"
+		"12:\n"
+		: "=D"(dummy1), "=d" (dummy2)
+		: "D" (dest), "a" (qword), "d" (length)
+		: "memory", "rcx");
+}
+
+
+#include "super.h" // Remove when we factor out these and other functions.
+
+/* Translate an offset the beginning of the Nova instance to a PMEM address.
+ *
+ * If this is part of a read-modify-write of the block,
+ * nova_memunlock_block() before calling!
+ */
+static inline void *nova_get_block(struct super_block *sb, u64 block)
+{
+	struct nova_super_block *ps = nova_get_super(sb);
+
+	return block ? ((void *)ps + block) : NULL;
+}
+
+static inline int nova_get_reference(struct super_block *sb, u64 block,
+	void *dram, void **nvmm, size_t size)
+{
+	int rc;
+
+	*nvmm = nova_get_block(sb, block);
+	rc = memcpy_mcsafe(dram, *nvmm, size);
+	return rc;
+}
+
+
+static inline u64
+nova_get_addr_off(struct nova_sb_info *sbi, void *addr)
+{
+	NOVA_ASSERT((addr >= sbi->virt_addr) &&
+			(addr < (sbi->virt_addr + sbi->initsize)));
+	return (u64)(addr - sbi->virt_addr);
+}
+
+static inline u64
+nova_get_block_off(struct super_block *sb, unsigned long blocknr,
+		    unsigned short btype)
+{
+	return (u64)blocknr << PAGE_SHIFT;
+}
+
+
+static inline u64 nova_get_epoch_id(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	return sbi->s_epoch_id;
+}
+
+static inline void nova_print_curr_epoch_id(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	u64 ret;
+
+	ret = sbi->s_epoch_id;
+	nova_dbg("Current epoch id: %llu\n", ret);
+}
+
+#include "inode.h"
+static inline int nova_get_head_tail(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih)
+{
+	struct nova_inode fake_pi;
+	int rc;
+
+	rc = memcpy_mcsafe(&fake_pi, pi, sizeof(struct nova_inode));
+	if (rc)
+		return rc;
+
+	sih->i_blk_type = fake_pi.i_blk_type;
+	sih->log_head = fake_pi.log_head;
+	sih->log_tail = fake_pi.log_tail;
+	sih->alter_log_head = fake_pi.alter_log_head;
+	sih->alter_log_tail = fake_pi.alter_log_tail;
+
+	return rc;
+}
+
+struct nova_range_node_lowhigh {
+	__le64 range_low;
+	__le64 range_high;
+};
+
+#define	RANGENODE_PER_PAGE	254
+
+/* A node in the RB tree representing a range of pages */
+struct nova_range_node {
+	struct rb_node node;
+	struct vm_area_struct *vma;
+	unsigned long mmap_entry;
+	unsigned long range_low;
+	unsigned long range_high;
+	u32	csum;		/* Protect vma, range low/high */
+};
+
+struct vma_item {
+	/* Reuse header of nova_range_node struct */
+	struct rb_node node;
+	struct vm_area_struct *vma;
+	unsigned long mmap_entry;
+};
+
+static inline u32 nova_calculate_range_node_csum(struct nova_range_node *node)
+{
+	u32 crc;
+
+	crc = nova_crc32c(~0, (__u8 *)&node->vma,
+			(unsigned long)&node->csum - (unsigned long)&node->vma);
+
+	return crc;
+}
+
+static inline int nova_update_range_node_checksum(struct nova_range_node *node)
+{
+	if (dram_struct_csum)
+		node->csum = nova_calculate_range_node_csum(node);
+
+	return 0;
+}
+
+static inline bool nova_range_node_checksum_ok(struct nova_range_node *node)
+{
+	bool ret;
+
+	if (dram_struct_csum == 0)
+		return true;
+
+	ret = node->csum == nova_calculate_range_node_csum(node);
+	if (!ret) {
+		nova_dbg("%s: checksum failure, vma %p, range low %lu, range high %lu, csum 0x%x\n",
+			 __func__, node->vma, node->range_low, node->range_high,
+			 node->csum);
+	}
+
+	return ret;
+}
+
+
+enum bm_type {
+	BM_4K = 0,
+	BM_2M,
+	BM_1G,
+};
+
+struct single_scan_bm {
+	unsigned long bitmap_size;
+	unsigned long *bitmap;
+};
+
+struct scan_bitmap {
+	struct single_scan_bm scan_bm_4K;
+	struct single_scan_bm scan_bm_2M;
+	struct single_scan_bm scan_bm_1G;
+};
+
+
+
+struct inode_map {
+	struct mutex		inode_table_mutex;
+	struct rb_root		inode_inuse_tree;
+	unsigned long		num_range_node_inode;
+	struct nova_range_node *first_inode_range;
+	int			allocated;
+	int			freed;
+};
+
+
+
+
+
+
+
+/* Old entry is freeable if it is appended after the latest snapshot */
+static inline int old_entry_freeable(struct super_block *sb, u64 epoch_id)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	if (epoch_id == sbi->s_epoch_id)
+		return 1;
+
+	return 0;
+}
+
+static inline int pass_mount_snapshot(struct super_block *sb, u64 epoch_id)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	if (epoch_id > sbi->mount_snapshot_epoch_id)
+		return 1;
+
+	return 0;
+}
+
+
+// BKDR String Hash Function
+static inline unsigned long BKDRHash(const char *str, int length)
+{
+	unsigned int seed = 131; // 31 131 1313 13131 131313 etc..
+	unsigned long hash = 0;
+	int i;
+
+	for (i = 0; i < length; i++)
+		hash = hash * seed + (*str++);
+
+	return hash;
+}
+
+
+#include "mprotect.h"
+
+#include "log.h"
+
+static inline struct nova_file_write_entry *
+nova_get_write_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih, unsigned long blocknr)
+{
+	struct nova_file_write_entry *entry;
+
+	entry = radix_tree_lookup(&sih->tree, blocknr);
+
+	return entry;
+}
+
+
+/*
+ * Find data at a file offset (pgoff) in the data pointed to by a write log
+ * entry.
+ */
+static inline unsigned long get_nvmm(struct super_block *sb,
+	struct nova_inode_info_header *sih,
+	struct nova_file_write_entry *entry, unsigned long pgoff)
+{
+	/* entry is already verified before this call and resides in dram
+	 * or we can do memcpy_mcsafe here but have to avoid double copy and
+	 * verification of the entry.
+	 */
+	if (entry->pgoff > pgoff || (unsigned long) entry->pgoff +
+			(unsigned long) entry->num_pages <= pgoff) {
+		struct nova_sb_info *sbi = NOVA_SB(sb);
+		u64 curr;
+
+		curr = nova_get_addr_off(sbi, entry);
+		nova_dbg("Entry ERROR: inode %lu, curr 0x%llx, pgoff %lu, entry pgoff %llu, num %u\n",
+			sih->ino,
+			curr, pgoff, entry->pgoff, entry->num_pages);
+		nova_print_nova_log_pages(sb, sih);
+		nova_print_nova_log(sb, sih);
+		NOVA_ASSERT(0);
+	}
+
+	return (unsigned long) (entry->block >> PAGE_SHIFT) + pgoff
+		- entry->pgoff;
+}
+
+bool nova_verify_entry_csum(struct super_block *sb, void *entry, void *entryc);
+
+static inline u64 nova_find_nvmm_block(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_entry *entry,
+	unsigned long blocknr)
+{
+	unsigned long nvmm;
+	struct nova_file_write_entry *entryc, entry_copy;
+
+	if (!entry) {
+		entry = nova_get_write_entry(sb, sih, blocknr);
+		if (!entry)
+			return 0;
+	}
+
+	/* Don't check entry here as someone else may be modifying it
+	 * when called from reset_vma_csum_parity
+	 */
+	entryc = &entry_copy;
+	if (memcpy_mcsafe(entryc, entry,
+			sizeof(struct nova_file_write_entry)) < 0)
+		return 0;
+
+	nvmm = get_nvmm(sb, sih, entryc, blocknr);
+	return nvmm << PAGE_SHIFT;
+}
+
+
+
+static inline unsigned long
+nova_get_numblocks(unsigned short btype)
+{
+	unsigned long num_blocks;
+
+	if (btype == NOVA_BLOCK_TYPE_4K) {
+		num_blocks = 1;
+	} else if (btype == NOVA_BLOCK_TYPE_2M) {
+		num_blocks = 512;
+	} else {
+		//btype == NOVA_BLOCK_TYPE_1G
+		num_blocks = 0x40000;
+	}
+	return num_blocks;
+}
+
+static inline unsigned long
+nova_get_blocknr(struct super_block *sb, u64 block, unsigned short btype)
+{
+	return block >> PAGE_SHIFT;
+}
+
+static inline unsigned long nova_get_pfn(struct super_block *sb, u64 block)
+{
+	return (NOVA_SB(sb)->phys_addr + block) >> PAGE_SHIFT;
+}
+
+static inline u64 next_log_page(struct super_block *sb, u64 curr)
+{
+	struct nova_inode_log_page *curr_page;
+	u64 next = 0;
+	int rc;
+
+	curr = BLOCK_OFF(curr);
+	curr_page = (struct nova_inode_log_page *)nova_get_block(sb, curr);
+	rc = memcpy_mcsafe(&next, &curr_page->page_tail.next_page,
+				sizeof(u64));
+	if (rc)
+		return rc;
+
+	return next;
+}
+
+static inline u64 alter_log_page(struct super_block *sb, u64 curr)
+{
+	struct nova_inode_log_page *curr_page;
+	u64 next = 0;
+	int rc;
+
+	if (metadata_csum == 0)
+		return 0;
+
+	curr = BLOCK_OFF(curr);
+	curr_page = (struct nova_inode_log_page *)nova_get_block(sb, curr);
+	rc = memcpy_mcsafe(&next, &curr_page->page_tail.alter_page,
+				sizeof(u64));
+	if (rc)
+		return rc;
+
+	return next;
+}
+
+#if 0
+static inline u64 next_log_page(struct super_block *sb, u64 curr_p)
+{
+	void *curr_addr = nova_get_block(sb, curr_p);
+	unsigned long page_tail = BLOCK_OFF((unsigned long)curr_addr)
+					+ LOG_BLOCK_TAIL;
+	return ((struct nova_inode_page_tail *)page_tail)->next_page;
+}
+
+static inline u64 alter_log_page(struct super_block *sb, u64 curr_p)
+{
+	void *curr_addr = nova_get_block(sb, curr_p);
+	unsigned long page_tail = BLOCK_OFF((unsigned long)curr_addr)
+					+ LOG_BLOCK_TAIL;
+	if (metadata_csum == 0)
+		return 0;
+
+	return ((struct nova_inode_page_tail *)page_tail)->alter_page;
+}
+#endif
+
+static inline u64 alter_log_entry(struct super_block *sb, u64 curr_p)
+{
+	u64 alter_page;
+	void *curr_addr = nova_get_block(sb, curr_p);
+	unsigned long page_tail = BLOCK_OFF((unsigned long)curr_addr)
+					+ LOG_BLOCK_TAIL;
+	if (metadata_csum == 0)
+		return 0;
+
+	alter_page = ((struct nova_inode_page_tail *)page_tail)->alter_page;
+	return alter_page + ENTRY_LOC(curr_p);
+}
+
+static inline void nova_set_next_page_flag(struct super_block *sb, u64 curr_p)
+{
+	void *p;
+
+	if (ENTRY_LOC(curr_p) >= LOG_BLOCK_TAIL)
+		return;
+
+	p = nova_get_block(sb, curr_p);
+	nova_set_entry_type(p, NEXT_PAGE);
+	nova_flush_buffer(p, CACHELINE_SIZE, 1);
+}
+
+static inline void nova_set_next_page_address(struct super_block *sb,
+	struct nova_inode_log_page *curr_page, u64 next_page, int fence)
+{
+	curr_page->page_tail.next_page = next_page;
+	nova_flush_buffer(&curr_page->page_tail,
+				sizeof(struct nova_inode_page_tail), 0);
+	if (fence)
+		PERSISTENT_BARRIER();
+}
+
+static inline void nova_set_page_num_entries(struct super_block *sb,
+	struct nova_inode_log_page *curr_page, int num, int flush)
+{
+	curr_page->page_tail.num_entries = num;
+	if (flush)
+		nova_flush_buffer(&curr_page->page_tail,
+				sizeof(struct nova_inode_page_tail), 0);
+}
+
+static inline void nova_set_page_invalid_entries(struct super_block *sb,
+	struct nova_inode_log_page *curr_page, int num, int flush)
+{
+	curr_page->page_tail.invalid_entries = num;
+	if (flush)
+		nova_flush_buffer(&curr_page->page_tail,
+				sizeof(struct nova_inode_page_tail), 0);
+}
+
+static inline void nova_inc_page_num_entries(struct super_block *sb,
+	u64 curr)
+{
+	struct nova_inode_log_page *curr_page;
+
+	curr = BLOCK_OFF(curr);
+	curr_page = (struct nova_inode_log_page *)nova_get_block(sb, curr);
+
+	curr_page->page_tail.num_entries++;
+	nova_flush_buffer(&curr_page->page_tail,
+				sizeof(struct nova_inode_page_tail), 0);
+}
+
+u64 nova_print_log_entry(struct super_block *sb, u64 curr);
+
+static inline void nova_inc_page_invalid_entries(struct super_block *sb,
+	u64 curr)
+{
+	struct nova_inode_log_page *curr_page;
+	u64 old_curr = curr;
+
+	curr = BLOCK_OFF(curr);
+	curr_page = (struct nova_inode_log_page *)nova_get_block(sb, curr);
+
+	curr_page->page_tail.invalid_entries++;
+	if (curr_page->page_tail.invalid_entries >
+			curr_page->page_tail.num_entries) {
+		nova_dbg("Page 0x%llx has %u entries, %u invalid\n",
+				curr,
+				curr_page->page_tail.num_entries,
+				curr_page->page_tail.invalid_entries);
+		nova_print_log_entry(sb, old_curr);
+	}
+
+	nova_flush_buffer(&curr_page->page_tail,
+				sizeof(struct nova_inode_page_tail), 0);
+}
+
+static inline void nova_set_alter_page_address(struct super_block *sb,
+	u64 curr, u64 alter_curr)
+{
+	struct nova_inode_log_page *curr_page;
+	struct nova_inode_log_page *alter_page;
+
+	if (metadata_csum == 0)
+		return;
+
+	curr_page = nova_get_block(sb, BLOCK_OFF(curr));
+	alter_page = nova_get_block(sb, BLOCK_OFF(alter_curr));
+
+	curr_page->page_tail.alter_page = alter_curr;
+	nova_flush_buffer(&curr_page->page_tail,
+				sizeof(struct nova_inode_page_tail), 0);
+
+	alter_page->page_tail.alter_page = curr;
+	nova_flush_buffer(&alter_page->page_tail,
+				sizeof(struct nova_inode_page_tail), 0);
+}
+
+#define	CACHE_ALIGN(p)	((p) & ~(CACHELINE_SIZE - 1))
+
+static inline bool is_last_entry(u64 curr_p, size_t size)
+{
+	unsigned int entry_end;
+
+	entry_end = ENTRY_LOC(curr_p) + size;
+
+	return entry_end > LOG_BLOCK_TAIL;
+}
+
+static inline bool goto_next_page(struct super_block *sb, u64 curr_p)
+{
+	void *addr;
+	u8 type;
+	int rc;
+
+	/* Each kind of entry takes at least 32 bytes */
+	if (ENTRY_LOC(curr_p) + 32 > LOG_BLOCK_TAIL)
+		return true;
+
+	addr = nova_get_block(sb, curr_p);
+	rc = memcpy_mcsafe(&type, addr, sizeof(u8));
+
+	if (rc < 0)
+		return true;
+
+	if (type == NEXT_PAGE)
+		return true;
+
+	return false;
+}
+
+static inline int is_dir_init_entry(struct super_block *sb,
+	struct nova_dentry *entry)
+{
+	if (entry->name_len == 1 && strncmp(entry->name, ".", 1) == 0)
+		return 1;
+	if (entry->name_len == 2 && strncmp(entry->name, "..", 2) == 0)
+		return 1;
+
+	return 0;
+}
+
+#include "balloc.h" // remove once we move the following functions away
+
+/* Checksum methods */
+static inline void *nova_get_data_csum_addr(struct super_block *sb, u64 strp_nr,
+	int replica)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
+	unsigned long blocknr;
+	void *data_csum_addr;
+	u64 blockoff;
+	int index;
+	int BLOCK_SHIFT = PAGE_SHIFT - NOVA_STRIPE_SHIFT;
+
+	if (!data_csum) {
+		nova_dbg("%s: Data checksum is disabled!\n", __func__);
+		return NULL;
+	}
+
+	blocknr = strp_nr >> BLOCK_SHIFT;
+	index = blocknr / sbi->per_list_blocks;
+
+	if (index >= sbi->cpus) {
+		nova_dbg("%s: Invalid blocknr %lu\n", __func__, blocknr);
+		return NULL;
+	}
+
+	strp_nr -= (index * sbi->per_list_blocks) << BLOCK_SHIFT;
+	free_list = nova_get_free_list(sb, index);
+	if (replica == 0)
+		blockoff = free_list->csum_start << PAGE_SHIFT;
+	else
+		blockoff = free_list->replica_csum_start << PAGE_SHIFT;
+
+	/* Range test */
+	if (((NOVA_DATA_CSUM_LEN * strp_nr) >> PAGE_SHIFT) >=
+			free_list->num_csum_blocks) {
+		nova_dbg("%s: Invalid strp number %llu, free list %d\n",
+				__func__, strp_nr, free_list->index);
+		return NULL;
+	}
+
+	data_csum_addr = (u8 *) nova_get_block(sb, blockoff)
+				+ NOVA_DATA_CSUM_LEN * strp_nr;
+
+	return data_csum_addr;
+}
+
+static inline void *nova_get_parity_addr(struct super_block *sb,
+	unsigned long blocknr)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
+	void *data_csum_addr;
+	u64 blockoff;
+	int index;
+	int BLOCK_SHIFT = PAGE_SHIFT - NOVA_STRIPE_SHIFT;
+
+	if (data_parity == 0) {
+		nova_dbg("%s: Data parity is disabled!\n", __func__);
+		return NULL;
+	}
+
+	index = blocknr / sbi->per_list_blocks;
+
+	if (index >= sbi->cpus) {
+		nova_dbg("%s: Invalid blocknr %lu\n", __func__, blocknr);
+		return NULL;
+	}
+
+	free_list = nova_get_free_list(sb, index);
+	blockoff = free_list->parity_start << PAGE_SHIFT;
+
+	/* Range test */
+	if (((blocknr - free_list->block_start) >> BLOCK_SHIFT) >=
+			free_list->num_parity_blocks) {
+		nova_dbg("%s: Invalid blocknr %lu, free list %d\n",
+				__func__, blocknr, free_list->index);
+		return NULL;
+	}
+
+	data_csum_addr = (u8 *) nova_get_block(sb, blockoff) +
+				((blocknr - free_list->block_start)
+				 << NOVA_STRIPE_SHIFT);
+
+	return data_csum_addr;
+}
+
+/* Function Prototypes */
+
+
+
+/* bbuild.c */
+inline void set_bm(unsigned long bit, struct scan_bitmap *bm,
+	enum bm_type type);
+void nova_save_blocknode_mappings_to_log(struct super_block *sb);
+void nova_save_inode_list_to_log(struct super_block *sb);
+void nova_init_header(struct super_block *sb,
+	struct nova_inode_info_header *sih, u16 i_mode);
+int nova_recovery(struct super_block *sb);
+
+/* checksum.c */
+void nova_update_entry_csum(void *entry);
+int nova_update_block_csum(struct super_block *sb,
+	struct nova_inode_info_header *sih, u8 *block, unsigned long blocknr,
+	size_t offset, size_t bytes, int zero);
+int nova_update_alter_entry(struct super_block *sb, void *entry);
+int nova_check_inode_integrity(struct super_block *sb, u64 ino, u64 pi_addr,
+	u64 alter_pi_addr, struct nova_inode *pic, int check_replica);
+int nova_update_pgoff_csum(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_entry *entry,
+	unsigned long pgoff, int zero);
+bool nova_verify_data_csum(struct super_block *sb,
+	struct nova_inode_info_header *sih, unsigned long blocknr,
+	size_t offset, size_t bytes);
+int nova_update_truncated_block_csum(struct super_block *sb,
+	struct inode *inode, loff_t newsize);
+
+/*
+ * Inodes and files operations
+ */
+
+/* dax.c */
+int nova_cleanup_incomplete_write(struct super_block *sb,
+	struct nova_inode_info_header *sih, unsigned long blocknr,
+	int allocated, u64 begin_tail, u64 end_tail);
+void nova_init_file_write_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_entry *entry,
+	u64 epoch_id, u64 pgoff, int num_pages, u64 blocknr, u32 time,
+	u64 size);
+int nova_reassign_file_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih, u64 begin_tail);
+unsigned long nova_check_existing_entry(struct super_block *sb,
+	struct inode *inode, unsigned long num_blocks, unsigned long start_blk,
+	struct nova_file_write_entry **ret_entry,
+	struct nova_file_write_entry *ret_entryc, int check_next, u64 epoch_id,
+	int *inplace, int locked);
+int nova_dax_get_blocks(struct inode *inode, sector_t iblock,
+	unsigned long max_blocks, u32 *bno, bool *new, bool *boundary,
+	int create, bool taking_lock);
+int nova_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+	unsigned int flags, struct iomap *iomap, bool taking_lock);
+int nova_iomap_end(struct inode *inode, loff_t offset, loff_t length,
+	ssize_t written, unsigned int flags, struct iomap *iomap);
+int nova_insert_write_vma(struct vm_area_struct *vma);
+
+int nova_check_overlap_vmas(struct super_block *sb,
+			    struct nova_inode_info_header *sih,
+			    unsigned long pgoff, unsigned long num_pages);
+int nova_handle_head_tail_blocks(struct super_block *sb,
+				 struct inode *inode, loff_t pos,
+				 size_t count, void *kmem);
+int nova_protect_file_data(struct super_block *sb, struct inode *inode,
+	loff_t pos, size_t count, const char __user *buf, unsigned long blocknr,
+	bool inplace);
+ssize_t nova_inplace_file_write(struct file *filp, const char __user *buf,
+				size_t len, loff_t *ppos);
+
+extern const struct vm_operations_struct nova_dax_vm_ops;
+
+
+/* dir.c */
+extern const struct file_operations nova_dir_operations;
+int nova_insert_dir_radix_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih, const char *name,
+	int namelen, struct nova_dentry *direntry);
+int nova_remove_dir_radix_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih, const char *name, int namelen,
+	int replay, struct nova_dentry **create_dentry);
+int nova_append_dentry(struct super_block *sb, struct nova_inode *pi,
+	struct inode *dir, struct dentry *dentry, u64 ino,
+	unsigned short de_len, struct nova_inode_update *update,
+	int link_change, u64 epoch_id);
+int nova_append_dir_init_entries(struct super_block *sb,
+	struct nova_inode *pi, u64 self_ino, u64 parent_ino, u64 epoch_id);
+int nova_add_dentry(struct dentry *dentry, u64 ino, int inc_link,
+	struct nova_inode_update *update, u64 epoch_id);
+int nova_remove_dentry(struct dentry *dentry, int dec_link,
+	struct nova_inode_update *update, u64 epoch_id);
+int nova_invalidate_dentries(struct super_block *sb,
+	struct nova_inode_update *update);
+void nova_print_dir_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih, unsigned long ino);
+void nova_delete_dir_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih);
+struct nova_dentry *nova_find_dentry(struct super_block *sb,
+	struct nova_inode *pi, struct inode *inode, const char *name,
+	unsigned long name_len);
+
+/* file.c */
+extern const struct inode_operations nova_file_inode_operations;
+extern const struct file_operations nova_dax_file_operations;
+extern const struct file_operations nova_wrap_file_operations;
+
+
+/* gc.c */
+int nova_inode_log_fast_gc(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih,
+	u64 curr_tail, u64 new_block, u64 alter_new_block, int num_pages,
+	int force_thorough);
+
+/* ioctl.c */
+extern long nova_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+#ifdef CONFIG_COMPAT
+extern long nova_compat_ioctl(struct file *file, unsigned int cmd,
+	unsigned long arg);
+#endif
+
+
+
+/* mprotect.c */
+extern int nova_dax_mem_protect(struct super_block *sb,
+				 void *vaddr, unsigned long size, int rw);
+int nova_get_vma_overlap_range(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct vm_area_struct *vma,
+	unsigned long entry_pgoff, unsigned long entry_pages,
+	unsigned long *start_pgoff, unsigned long *num_pages);
+int nova_mmap_to_new_blocks(struct vm_area_struct *vma,
+	unsigned long address);
+bool nova_find_pgoff_in_vma(struct inode *inode, unsigned long pgoff);
+int nova_set_vmas_readonly(struct super_block *sb);
+
+/* namei.c */
+extern const struct inode_operations nova_dir_inode_operations;
+extern const struct inode_operations nova_special_inode_operations;
+extern struct dentry *nova_get_parent(struct dentry *child);
+
+/* parity.c */
+int nova_update_pgoff_parity(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_entry *entry,
+	unsigned long pgoff, int zero);
+int nova_update_block_csum_parity(struct super_block *sb,
+	struct nova_inode_info_header *sih, u8 *block, unsigned long blocknr,
+	size_t offset, size_t bytes);
+int nova_restore_data(struct super_block *sb, unsigned long blocknr,
+	unsigned int badstrip_id, void *badstrip, int nvmmerr, u32 csum0,
+	u32 csum1, u32 *csum_good);
+int nova_update_truncated_block_parity(struct super_block *sb,
+	struct inode *inode, loff_t newsize);
+
+/* rebuild.c */
+int nova_reset_csum_parity_range(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_entry *entry,
+	unsigned long start_pgoff, unsigned long end_pgoff, int zero,
+	int check_entry);
+int nova_reset_mapping_csum_parity(struct super_block *sb,
+	struct inode *inode, struct address_space *mapping,
+	unsigned long start_pgoff, unsigned long end_pgoff);
+int nova_reset_vma_csum_parity(struct super_block *sb,
+	struct vma_item *item);
+int nova_rebuild_dir_inode_tree(struct super_block *sb,
+	struct nova_inode *pi, u64 pi_addr,
+	struct nova_inode_info_header *sih);
+int nova_rebuild_inode(struct super_block *sb, struct nova_inode_info *si,
+	u64 ino, u64 pi_addr, int rebuild_dir);
+int nova_restore_snapshot_table(struct super_block *sb, int just_init);
+
+/* snapshot.c */
+int nova_encounter_mount_snapshot(struct super_block *sb, void *addr,
+	u8 type);
+int nova_save_snapshots(struct super_block *sb);
+int nova_destroy_snapshot_infos(struct super_block *sb);
+int nova_restore_snapshot_entry(struct super_block *sb,
+	struct nova_snapshot_info_entry *entry, u64 curr_p, int just_init);
+int nova_mount_snapshot(struct super_block *sb);
+int nova_append_data_to_snapshot(struct super_block *sb,
+	struct nova_file_write_entry *entry, u64 nvmm, u64 num_pages,
+	u64 delete_epoch_id);
+int nova_append_inode_to_snapshot(struct super_block *sb,
+	struct nova_inode *pi);
+int nova_print_snapshots(struct super_block *sb, struct seq_file *seq);
+int nova_print_snapshot_lists(struct super_block *sb, struct seq_file *seq);
+int nova_delete_dead_inode(struct super_block *sb, u64 ino);
+int nova_create_snapshot(struct super_block *sb);
+int nova_delete_snapshot(struct super_block *sb, u64 epoch_id);
+int nova_snapshot_init(struct super_block *sb);
+
+
+/* symlink.c */
+int nova_block_symlink(struct super_block *sb, struct nova_inode *pi,
+	struct inode *inode, const char *symname, int len, u64 epoch_id);
+extern const struct inode_operations nova_symlink_inode_operations;
+
+/* sysfs.c */
+extern const char *proc_dirname;
+extern struct proc_dir_entry *nova_proc_root;
+void nova_sysfs_init(struct super_block *sb);
+void nova_sysfs_exit(struct super_block *sb);
+
+/* nova_stats.c */
+void nova_get_timing_stats(void);
+void nova_get_IO_stats(void);
+void nova_print_timing_stats(struct super_block *sb);
+void nova_clear_stats(struct super_block *sb);
+void nova_print_inode(struct nova_inode *pi);
+void nova_print_inode_log(struct super_block *sb, struct inode *inode);
+void nova_print_inode_log_pages(struct super_block *sb, struct inode *inode);
+int nova_check_inode_logs(struct super_block *sb, struct nova_inode *pi);
+void nova_print_free_lists(struct super_block *sb);
+
+/* perf.c */
+int nova_test_perf(struct super_block *sb, unsigned int func_id,
+	unsigned int poolmb, size_t size, unsigned int disks);
+
+#endif /* __NOVA_H */
diff --git a/fs/nova/nova_def.h b/fs/nova/nova_def.h
new file mode 100644
index 000000000000..61ade439e138
--- /dev/null
+++ b/fs/nova/nova_def.h
@@ -0,0 +1,154 @@
+/*
+ * FILE NAME include/linux/nova_fs.h
+ *
+ * BRIEF DESCRIPTION
+ *
+ * Definitions for the NOVA filesystem.
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ * Copyright 2012-2013 Intel Corporation
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#ifndef _LINUX_NOVA_DEF_H
+#define _LINUX_NOVA_DEF_H
+
+#include <linux/types.h>
+#include <linux/magic.h>
+
+#define	NOVA_SUPER_MAGIC	0x4E4F5641	/* NOVA */
+
+/*
+ * The NOVA filesystem constants/structures
+ */
+
+/*
+ * Mount flags
+ */
+#define NOVA_MOUNT_PROTECT      0x000001    /* wprotect CR0.WP */
+#define NOVA_MOUNT_XATTR_USER   0x000002    /* Extended user attributes */
+#define NOVA_MOUNT_POSIX_ACL    0x000004    /* POSIX Access Control Lists */
+#define NOVA_MOUNT_DAX          0x000008    /* Direct Access */
+#define NOVA_MOUNT_ERRORS_CONT  0x000010    /* Continue on errors */
+#define NOVA_MOUNT_ERRORS_RO    0x000020    /* Remount fs ro on errors */
+#define NOVA_MOUNT_ERRORS_PANIC 0x000040    /* Panic on errors */
+#define NOVA_MOUNT_HUGEMMAP     0x000080    /* Huge mappings with mmap */
+#define NOVA_MOUNT_HUGEIOREMAP  0x000100    /* Huge mappings with ioremap */
+#define NOVA_MOUNT_FORMAT       0x000200    /* was FS formatted on mount? */
+
+/*
+ * Maximal count of links to a file
+ */
+#define NOVA_LINK_MAX          32000
+
+#define NOVA_DEF_BLOCK_SIZE_4K 4096
+
+#define NOVA_INODE_BITS   7
+#define NOVA_INODE_SIZE   128    /* must be power of two */
+
+#define NOVA_NAME_LEN 255
+
+#define MAX_CPUS 64
+
+/* NOVA supported data blocks */
+#define NOVA_BLOCK_TYPE_4K     0
+#define NOVA_BLOCK_TYPE_2M     1
+#define NOVA_BLOCK_TYPE_1G     2
+#define NOVA_BLOCK_TYPE_MAX    3
+
+#define META_BLK_SHIFT 9
+
+/*
+ * Play with this knob to change the default block type.
+ * By changing the NOVA_DEFAULT_BLOCK_TYPE to 2M or 1G,
+ * we should get pretty good coverage in testing.
+ */
+#define NOVA_DEFAULT_BLOCK_TYPE NOVA_BLOCK_TYPE_4K
+
+
+/* ======================= Write ordering ========================= */
+
+#define CACHELINE_SIZE  (64)
+#define CACHELINE_MASK  (~(CACHELINE_SIZE - 1))
+#define CACHELINE_ALIGN(addr) (((addr)+CACHELINE_SIZE-1) & CACHELINE_MASK)
+
+
+static inline bool arch_has_clwb(void)
+{
+	return static_cpu_has(X86_FEATURE_CLWB);
+}
+
+extern int support_clwb;
+
+#define _mm_clflush(addr)\
+	asm volatile("clflush %0" : "+m" (*(volatile char *)(addr)))
+#define _mm_clflushopt(addr)\
+	asm volatile(".byte 0x66; clflush %0" : "+m" \
+		     (*(volatile char *)(addr)))
+#define _mm_clwb(addr)\
+	asm volatile(".byte 0x66; xsaveopt %0" : "+m" \
+		     (*(volatile char *)(addr)))
+
+/* Provides ordering from all previous clflush too */
+static inline void PERSISTENT_MARK(void)
+{
+	/* TODO: Fix me. */
+}
+
+static inline void PERSISTENT_BARRIER(void)
+{
+	asm volatile ("sfence\n" : : );
+}
+
+static inline void nova_flush_buffer(void *buf, uint32_t len, bool fence)
+{
+	uint32_t i;
+
+	len = len + ((unsigned long)(buf) & (CACHELINE_SIZE - 1));
+	if (support_clwb) {
+		for (i = 0; i < len; i += CACHELINE_SIZE)
+			_mm_clwb(buf + i);
+	} else {
+		for (i = 0; i < len; i += CACHELINE_SIZE)
+			_mm_clflush(buf + i);
+	}
+	/* Do a fence only if asked. We often don't need to do a fence
+	 * immediately after clflush because even if we get context switched
+	 * between clflush and subsequent fence, the context switch operation
+	 * provides implicit fence.
+	 */
+	if (fence)
+		PERSISTENT_BARRIER();
+}
+
+/* =============== Integrity and Recovery Parameters =============== */
+#define	NOVA_META_CSUM_LEN	(4)
+#define	NOVA_DATA_CSUM_LEN	(4)
+
+/* This is to set the initial value of checksum state register.
+ * For CRC32C this should not matter and can be set to any value.
+ */
+#define	NOVA_INIT_CSUM		(1)
+
+#define	ADDR_ALIGN(p, bytes)	((void *) (((unsigned long) p) & ~(bytes - 1)))
+
+/* Data stripe size in bytes and shift.
+ * In NOVA this size determines the size of a checksummed stripe, and it
+ * equals to the affordable lost size of data per block (page).
+ * Its value should be no less than the poison radius size of media errors.
+ *
+ * Support NOVA_STRIPE_SHIFT <= PAGE_SHIFT (NOVA file block size shift).
+ */
+#define POISON_RADIUS		(512)
+#define POISON_MASK		(~(POISON_RADIUS - 1))
+#define NOVA_STRIPE_SHIFT	(9) /* size should be no less than PR_SIZE */
+#define NOVA_STRIPE_SIZE	(1 << NOVA_STRIPE_SHIFT)
+
+#endif /* _LINUX_NOVA_DEF_H */
diff --git a/fs/nova/super.c b/fs/nova/super.c
new file mode 100644
index 000000000000..6be94edf116c
--- /dev/null
+++ b/fs/nova/super.c
@@ -0,0 +1,1222 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Super block operations.
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ * Copyright 2012-2013 Intel Corporation
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/parser.h>
+#include <linux/vfs.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/seq_file.h>
+#include <linux/mount.h>
+#include <linux/mm.h>
+#include <linux/ctype.h>
+#include <linux/bitops.h>
+#include <linux/magic.h>
+#include <linux/exportfs.h>
+#include <linux/random.h>
+#include <linux/cred.h>
+#include <linux/list.h>
+#include <linux/dax.h>
+#include "nova.h"
+#include "journal.h"
+#include "super.h"
+#include "inode.h"
+
+int measure_timing;
+int metadata_csum;
+int wprotect;
+int data_csum;
+int data_parity;
+int dram_struct_csum;
+int support_clwb;
+int inplace_data_updates;
+
+module_param(measure_timing, int, 0444);
+MODULE_PARM_DESC(measure_timing, "Timing measurement");
+
+module_param(metadata_csum, int, 0444);
+MODULE_PARM_DESC(metadata_csum, "Protect metadata structures with replication and checksums");
+
+module_param(wprotect, int, 0444);
+MODULE_PARM_DESC(wprotect, "Write-protect pmem region and use CR0.WP to allow updates");
+
+module_param(data_csum, int, 0444);
+MODULE_PARM_DESC(data_csum, "Detect corruption of data pages using checksum");
+
+module_param(data_parity, int, 0444);
+MODULE_PARM_DESC(data_parity, "Protect file data using RAID-5 style parity.");
+
+module_param(inplace_data_updates, int, 0444);
+MODULE_PARM_DESC(inplace_data_updates, "Perform data updates in-place (i.e., not atomically)");
+
+module_param(dram_struct_csum, int, 0444);
+MODULE_PARM_DESC(dram_struct_csum, "Protect key DRAM data structures with checksums");
+
+module_param(nova_dbgmask, int, 0444);
+MODULE_PARM_DESC(nova_dbgmask, "Control debugging output");
+
+static struct super_operations nova_sops;
+static const struct export_operations nova_export_ops;
+static struct kmem_cache *nova_inode_cachep;
+static struct kmem_cache *nova_range_node_cachep;
+static struct kmem_cache *nova_snapshot_info_cachep;
+
+/* FIXME: should the following variable be one per NOVA instance? */
+unsigned int nova_dbgmask;
+
+void nova_error_mng(struct super_block *sb, const char *fmt, ...)
+{
+	va_list args;
+
+	printk(KERN_CRIT "nova error: ");
+	va_start(args, fmt);
+	vprintk(fmt, args);
+	va_end(args);
+
+	if (test_opt(sb, ERRORS_PANIC))
+		panic("nova: panic from previous error\n");
+	if (test_opt(sb, ERRORS_RO)) {
+		printk(KERN_CRIT "nova err: remounting filesystem read-only");
+		sb->s_flags |= MS_RDONLY;
+	}
+}
+
+static void nova_set_blocksize(struct super_block *sb, unsigned long size)
+{
+	int bits;
+
+	/*
+	 * We've already validated the user input and the value here must be
+	 * between NOVA_MAX_BLOCK_SIZE and NOVA_MIN_BLOCK_SIZE
+	 * and it must be a power of 2.
+	 */
+	bits = fls(size) - 1;
+	sb->s_blocksize_bits = bits;
+	sb->s_blocksize = (1 << bits);
+}
+
+static int nova_get_nvmm_info(struct super_block *sb,
+	struct nova_sb_info *sbi)
+{
+	void *virt_addr = NULL;
+	pfn_t __pfn_t;
+	long size;
+	struct dax_device *dax_dev;
+	int ret;
+
+	ret = bdev_dax_supported(sb, PAGE_SIZE);
+	nova_dbg_verbose("%s: dax_supported = %d; bdev->super=0x%p",
+			 __func__, ret, sb->s_bdev->bd_super);
+	if (ret) {
+		nova_err(sb, "device does not support DAX\n");
+		return ret;
+	}
+
+	sbi->s_bdev = sb->s_bdev;
+
+	dax_dev = fs_dax_get_by_host(sb->s_bdev->bd_disk->disk_name);
+	if (!dax_dev) {
+		nova_err(sb, "Couldn't retrieve DAX device.\n");
+		return -EINVAL;
+	}
+	sbi->s_dax_dev = dax_dev;
+
+	size = dax_direct_access(sbi->s_dax_dev, 0, LONG_MAX/PAGE_SIZE,
+				 &virt_addr, &__pfn_t) * PAGE_SIZE;
+	if (size <= 0) {
+		nova_err(sb, "direct_access failed\n");
+		return -EINVAL;
+	}
+
+	sbi->virt_addr = virt_addr;
+
+	if (!sbi->virt_addr) {
+		nova_err(sb, "ioremap of the nova image failed(1)\n");
+		return -EINVAL;
+	}
+
+	sbi->phys_addr = pfn_t_to_pfn(__pfn_t) << PAGE_SHIFT;
+	sbi->initsize = size;
+	sbi->replica_reserved_inodes_addr = virt_addr + size -
+			(sbi->tail_reserved_blocks << PAGE_SHIFT);
+	sbi->replica_sb_addr = virt_addr + size - PAGE_SIZE;
+
+	nova_dbg("%s: dev %s, phys_addr 0x%llx, virt_addr %p, size %ld\n",
+		__func__, sbi->s_bdev->bd_disk->disk_name,
+		sbi->phys_addr, sbi->virt_addr, sbi->initsize);
+
+	return 0;
+}
+
+static loff_t nova_max_size(int bits)
+{
+	loff_t res;
+
+	res = (1ULL << 63) - 1;
+
+	if (res > MAX_LFS_FILESIZE)
+		res = MAX_LFS_FILESIZE;
+
+	nova_dbg_verbose("max file size %llu bytes\n", res);
+	return res;
+}
+
+enum {
+	Opt_bpi, Opt_init, Opt_snapshot, Opt_mode, Opt_uid,
+	Opt_gid, Opt_blocksize, Opt_wprotect,
+	Opt_err_cont, Opt_err_panic, Opt_err_ro,
+	Opt_dbgmask, Opt_err
+};
+
+static const match_table_t tokens = {
+	{ Opt_bpi,	     "bpi=%u"		  },
+	{ Opt_init,	     "init"		  },
+	{ Opt_snapshot,	     "snapshot=%u"	  },
+	{ Opt_mode,	     "mode=%o"		  },
+	{ Opt_uid,	     "uid=%u"		  },
+	{ Opt_gid,	     "gid=%u"		  },
+	{ Opt_wprotect,	     "wprotect"		  },
+	{ Opt_err_cont,	     "errors=continue"	  },
+	{ Opt_err_panic,     "errors=panic"	  },
+	{ Opt_err_ro,	     "errors=remount-ro"  },
+	{ Opt_dbgmask,	     "dbgmask=%u"	  },
+	{ Opt_err,	     NULL		  },
+};
+
+static int nova_parse_options(char *options, struct nova_sb_info *sbi,
+			       bool remount)
+{
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+	int option;
+	kuid_t uid;
+
+	if (!options)
+		return 0;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_bpi:
+			if (match_int(&args[0], &option))
+				goto bad_val;
+			if (remount && sbi->bpi)
+				goto bad_opt;
+			sbi->bpi = option;
+			break;
+		case Opt_uid:
+			if (match_int(&args[0], &option))
+				goto bad_val;
+			uid = make_kuid(current_user_ns(), option);
+			if (remount && !uid_eq(sbi->uid, uid))
+				goto bad_opt;
+			sbi->uid = uid;
+			break;
+		case Opt_gid:
+			if (match_int(&args[0], &option))
+				goto bad_val;
+			sbi->gid = make_kgid(current_user_ns(), option);
+			break;
+		case Opt_mode:
+			if (match_octal(&args[0], &option))
+				goto bad_val;
+			sbi->mode = option & 01777U;
+			break;
+		case Opt_init:
+			if (remount)
+				goto bad_opt;
+			set_opt(sbi->s_mount_opt, FORMAT);
+			break;
+		case Opt_snapshot:
+			if (match_int(&args[0], &option))
+				goto bad_val;
+			sbi->mount_snapshot = 1;
+			sbi->mount_snapshot_epoch_id = option;
+			break;
+		case Opt_err_panic:
+			clear_opt(sbi->s_mount_opt, ERRORS_CONT);
+			clear_opt(sbi->s_mount_opt, ERRORS_RO);
+			set_opt(sbi->s_mount_opt, ERRORS_PANIC);
+			break;
+		case Opt_err_ro:
+			clear_opt(sbi->s_mount_opt, ERRORS_CONT);
+			clear_opt(sbi->s_mount_opt, ERRORS_PANIC);
+			set_opt(sbi->s_mount_opt, ERRORS_RO);
+			break;
+		case Opt_err_cont:
+			clear_opt(sbi->s_mount_opt, ERRORS_RO);
+			clear_opt(sbi->s_mount_opt, ERRORS_PANIC);
+			set_opt(sbi->s_mount_opt, ERRORS_CONT);
+			break;
+		case Opt_wprotect:
+			if (remount)
+				goto bad_opt;
+			set_opt(sbi->s_mount_opt, PROTECT);
+			nova_info("NOVA: Enabling new Write Protection (CR0.WP)\n");
+			break;
+		case Opt_dbgmask:
+			if (match_int(&args[0], &option))
+				goto bad_val;
+			nova_dbgmask = option;
+			break;
+		default: {
+			goto bad_opt;
+		}
+		}
+	}
+
+	return 0;
+
+bad_val:
+	nova_info("Bad value '%s' for mount option '%s'\n", args[0].from,
+	       p);
+	return -EINVAL;
+bad_opt:
+	nova_info("Bad mount option: \"%s\"\n", p);
+	return -EINVAL;
+}
+
+
+/* Make sure we have enough space */
+static bool nova_check_size(struct super_block *sb, unsigned long size)
+{
+	unsigned long minimum_size;
+
+	/* space required for super block and root directory.*/
+	minimum_size = (HEAD_RESERVED_BLOCKS + TAIL_RESERVED_BLOCKS + 1)
+			  << sb->s_blocksize_bits;
+
+	if (size < minimum_size)
+		return false;
+
+	return true;
+}
+
+static inline int nova_check_super_checksum(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	u32 crc = 0;
+
+	// Check CRC but skip c_sum, which is the 4 bytes at the beginning
+	crc = nova_crc32c(~0, (__u8 *)sbi->nova_sb + sizeof(__le32),
+			sizeof(struct nova_super_block) - sizeof(__le32));
+
+	if (sbi->nova_sb->s_sum == cpu_to_le32(crc))
+		return 0;
+	else
+		return 1;
+}
+
+inline void nova_sync_super(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_super_block *super = nova_get_super(sb);
+	struct nova_super_block *super_redund;
+
+	nova_memunlock_super(sb);
+
+	super_redund = nova_get_redund_super(sb);
+
+	memcpy_to_pmem_nocache((void *)super, (void *)sbi->nova_sb,
+		sizeof(struct nova_super_block));
+	PERSISTENT_BARRIER();
+
+	memcpy_to_pmem_nocache((void *)super_redund, (void *)sbi->nova_sb,
+		sizeof(struct nova_super_block));
+	PERSISTENT_BARRIER();
+
+	nova_memlock_super(sb);
+}
+
+/* Update checksum for the DRAM copy */
+inline void nova_update_super_crc(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	u32 crc = 0;
+
+	sbi->nova_sb->s_wtime = cpu_to_le32(get_seconds());
+	sbi->nova_sb->s_sum = 0;
+	crc = nova_crc32c(~0, (__u8 *)sbi->nova_sb + sizeof(__le32),
+			sizeof(struct nova_super_block) - sizeof(__le32));
+	sbi->nova_sb->s_sum = cpu_to_le32(crc);
+}
+
+
+static inline void nova_update_mount_time(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	u64 mnt_write_time;
+
+	mnt_write_time = (get_seconds() & 0xFFFFFFFF);
+	mnt_write_time = mnt_write_time | (mnt_write_time << 32);
+
+	sbi->nova_sb->s_mtime = cpu_to_le64(mnt_write_time);
+	nova_update_super_crc(sb);
+
+	nova_sync_super(sb);
+}
+
+static struct nova_inode *nova_init(struct super_block *sb,
+				      unsigned long size)
+{
+	unsigned long blocksize;
+	struct nova_inode *root_i, *pi;
+	struct nova_super_block *super;
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_inode_update update;
+	u64 epoch_id;
+	timing_t init_time;
+
+	NOVA_START_TIMING(new_init_t, init_time);
+	nova_info("creating an empty nova of size %lu\n", size);
+	sbi->num_blocks = ((unsigned long)(size) >> PAGE_SHIFT);
+
+	nova_dbgv("nova: Default block size set to 4K\n");
+	sbi->blocksize = blocksize = NOVA_DEF_BLOCK_SIZE_4K;
+	nova_set_blocksize(sb, sbi->blocksize);
+
+	if (!nova_check_size(sb, size)) {
+		nova_warn("Specified NOVA size too small 0x%lx.\n", size);
+		return ERR_PTR(-EINVAL);
+	}
+
+	nova_dbgv("max file name len %d\n", (unsigned int)NOVA_NAME_LEN);
+
+	super = nova_get_super(sb);
+
+	nova_memunlock_reserved(sb, super);
+	/* clear out super-block and inode table */
+	memset_nt(super, 0, sbi->head_reserved_blocks * sbi->blocksize);
+
+	pi = nova_get_inode_by_ino(sb, NOVA_BLOCKNODE_INO);
+	pi->nova_ino = NOVA_BLOCKNODE_INO;
+	nova_flush_buffer(pi, CACHELINE_SIZE, 1);
+
+	pi = nova_get_inode_by_ino(sb, NOVA_SNAPSHOT_INO);
+	pi->nova_ino = NOVA_SNAPSHOT_INO;
+	nova_flush_buffer(pi, CACHELINE_SIZE, 1);
+
+	memset(&update, 0, sizeof(struct nova_inode_update));
+	nova_update_inode(sb, &sbi->snapshot_si->vfs_inode, pi, &update, 1);
+
+	nova_memlock_reserved(sb, super);
+
+	nova_init_blockmap(sb, 0);
+
+	if (nova_lite_journal_hard_init(sb) < 0) {
+		nova_err(sb, "Lite journal hard initialization failed\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (nova_init_inode_inuse_list(sb) < 0)
+		return ERR_PTR(-EINVAL);
+
+	if (nova_init_inode_table(sb) < 0)
+		return ERR_PTR(-EINVAL);
+
+
+	sbi->nova_sb->s_size = cpu_to_le64(size);
+	sbi->nova_sb->s_blocksize = cpu_to_le32(blocksize);
+	sbi->nova_sb->s_magic = cpu_to_le32(NOVA_SUPER_MAGIC);
+	sbi->nova_sb->s_epoch_id = 0;
+	sbi->nova_sb->s_metadata_csum = metadata_csum;
+	sbi->nova_sb->s_data_csum = data_csum;
+	sbi->nova_sb->s_data_parity = data_parity;
+	nova_update_super_crc(sb);
+
+	nova_sync_super(sb);
+
+	root_i = nova_get_inode_by_ino(sb, NOVA_ROOT_INO);
+	nova_dbgv("%s: Allocate root inode @ 0x%p\n", __func__, root_i);
+
+	nova_memunlock_inode(sb, root_i);
+	root_i->i_mode = cpu_to_le16(sbi->mode | S_IFDIR);
+	root_i->i_uid = cpu_to_le32(from_kuid(&init_user_ns, sbi->uid));
+	root_i->i_gid = cpu_to_le32(from_kgid(&init_user_ns, sbi->gid));
+	root_i->i_links_count = cpu_to_le16(2);
+	root_i->i_blk_type = NOVA_BLOCK_TYPE_4K;
+	root_i->i_flags = 0;
+	root_i->i_size = cpu_to_le64(sb->s_blocksize);
+	root_i->i_atime = root_i->i_mtime = root_i->i_ctime =
+		cpu_to_le32(get_seconds());
+	root_i->nova_ino = cpu_to_le64(NOVA_ROOT_INO);
+	root_i->valid = 1;
+	/* nova_sync_inode(root_i); */
+	nova_flush_buffer(root_i, sizeof(*root_i), false);
+	nova_memlock_inode(sb, root_i);
+
+	epoch_id = nova_get_epoch_id(sb);
+	nova_append_dir_init_entries(sb, root_i, NOVA_ROOT_INO,
+					NOVA_ROOT_INO, epoch_id);
+
+	PERSISTENT_MARK();
+	PERSISTENT_BARRIER();
+	NOVA_END_TIMING(new_init_t, init_time);
+	nova_info("NOVA initialization finish\n");
+	return root_i;
+}
+
+static inline void set_default_opts(struct nova_sb_info *sbi)
+{
+	set_opt(sbi->s_mount_opt, HUGEIOREMAP);
+	set_opt(sbi->s_mount_opt, ERRORS_CONT);
+	sbi->head_reserved_blocks = HEAD_RESERVED_BLOCKS;
+	sbi->tail_reserved_blocks = TAIL_RESERVED_BLOCKS;
+	sbi->cpus = num_online_cpus();
+	sbi->map_id = 0;
+}
+
+static void nova_root_check(struct super_block *sb, struct nova_inode *root_pi)
+{
+	if (!S_ISDIR(le16_to_cpu(root_pi->i_mode)))
+		nova_warn("root is not a directory!\n");
+}
+
+/* Check super block magic and checksum */
+static int nova_check_super(struct super_block *sb,
+	struct nova_super_block *ps)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	int rc;
+
+	rc = memcpy_mcsafe(sbi->nova_sb, ps,
+				sizeof(struct nova_super_block));
+
+	if (rc < 0)
+		return rc;
+
+	if (le32_to_cpu(sbi->nova_sb->s_magic) != NOVA_SUPER_MAGIC)
+		return -EIO;
+
+	if (nova_check_super_checksum(sb))
+		return -EIO;
+
+	return 0;
+}
+
+/* Check if we disable protection previously and enable it now */
+/* FIXME */
+static int nova_check_module_params(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	if (sbi->nova_sb->s_metadata_csum != metadata_csum) {
+		nova_dbg("%s metadata checksum\n",
+			sbi->nova_sb->s_metadata_csum ? "Enable" : "Disable");
+		metadata_csum = sbi->nova_sb->s_metadata_csum;
+	}
+
+	if (sbi->nova_sb->s_data_csum != data_csum) {
+		nova_dbg("%s data checksum\n",
+			sbi->nova_sb->s_data_csum ? "Enable" : "Disable");
+		data_csum = sbi->nova_sb->s_data_csum;
+	}
+
+	if (sbi->nova_sb->s_data_parity != data_parity) {
+		nova_dbg("%s data parity\n",
+			sbi->nova_sb->s_data_parity ? "Enable" : "Disable");
+		data_parity = sbi->nova_sb->s_data_parity;
+	}
+
+	return 0;
+}
+
+static int nova_check_integrity(struct super_block *sb)
+{
+	struct nova_super_block *super = nova_get_super(sb);
+	struct nova_super_block *super_redund;
+	int rc;
+
+	super_redund = nova_get_redund_super(sb);
+
+	/* Do sanity checks on the superblock */
+	rc = nova_check_super(sb, super);
+	if (rc < 0) {
+		rc = nova_check_super(sb, super_redund);
+		if (rc < 0) {
+			nova_err(sb, "Can't find a valid nova partition\n");
+			return rc;
+		} else
+			nova_warn("Error in super block: try to repair it with the other copy\n");
+		
+	}
+
+	nova_sync_super(sb);
+
+	nova_check_module_params(sb);
+	return 0;
+}
+
+static int nova_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct nova_inode *root_pi;
+	struct nova_sb_info *sbi = NULL;
+	struct inode *root_i = NULL;
+	struct inode_map *inode_map;
+	unsigned long blocksize;
+	size_t strp_size = NOVA_STRIPE_SIZE;
+	u32 random = 0;
+	int retval = -EINVAL;
+	int i;
+	timing_t mount_time;
+
+	NOVA_START_TIMING(mount_t, mount_time);
+
+	BUILD_BUG_ON(sizeof(struct nova_super_block) > NOVA_SB_SIZE);
+	BUILD_BUG_ON(sizeof(struct nova_inode) > NOVA_INODE_SIZE);
+	BUILD_BUG_ON(sizeof(struct nova_inode_log_page) != PAGE_SIZE);
+
+	BUILD_BUG_ON(sizeof(struct journal_ptr_pair) > CACHELINE_SIZE);
+	BUILD_BUG_ON(PAGE_SIZE/sizeof(struct journal_ptr_pair) < MAX_CPUS);
+	BUILD_BUG_ON(PAGE_SIZE/sizeof(struct nova_lite_journal_entry) <
+		     NOVA_MAX_JOURNAL_LENGTH);
+
+	BUILD_BUG_ON(sizeof(struct nova_inode_page_tail) +
+		     LOG_BLOCK_TAIL != PAGE_SIZE);
+
+	sbi = kzalloc(sizeof(struct nova_sb_info), GFP_KERNEL);
+	if (!sbi)
+		return -ENOMEM;
+	sbi->nova_sb = kzalloc(sizeof(struct nova_super_block), GFP_KERNEL);
+	if (!sbi->nova_sb) {
+		kfree(sbi);
+		return -ENOMEM;
+	}
+
+	sb->s_fs_info = sbi;
+	sbi->sb = sb;
+
+	set_default_opts(sbi);
+
+	/* Currently the log page supports 64 journal pointer pairs */
+	if (sbi->cpus > MAX_CPUS) {
+		nova_err(sb, "NOVA needs more log pointer pages to support more than "
+			  __stringify(MAX_CPUS) " cpus.\n");
+		goto out;
+	}
+
+	retval = nova_get_nvmm_info(sb, sbi);
+	if (retval) {
+		nova_err(sb, "%s: Failed to get nvmm info.",
+			 __func__);
+		goto out;
+	}
+
+
+	nova_dbg("measure timing %d, metadata checksum %d, inplace update %d, wprotect %d, data checksum %d, data parity %d, DRAM checksum %d\n",
+		measure_timing, metadata_csum,
+		inplace_data_updates, wprotect,	 data_csum,
+		data_parity, dram_struct_csum);
+
+	get_random_bytes(&random, sizeof(u32));
+	atomic_set(&sbi->next_generation, random);
+
+	/* Init with default values */
+	sbi->mode = (0755);
+	sbi->uid = current_fsuid();
+	sbi->gid = current_fsgid();
+	set_opt(sbi->s_mount_opt, DAX);
+	set_opt(sbi->s_mount_opt, HUGEIOREMAP);
+
+	mutex_init(&sbi->vma_mutex);
+	INIT_LIST_HEAD(&sbi->mmap_sih_list);
+
+	sbi->inode_maps = kcalloc(sbi->cpus, sizeof(struct inode_map),
+					GFP_KERNEL);
+	if (!sbi->inode_maps) {
+		retval = -ENOMEM;
+		nova_dbg("%s: Allocating inode maps failed.",
+			 __func__);
+		goto out;
+	}
+
+	for (i = 0; i < sbi->cpus; i++) {
+		inode_map = &sbi->inode_maps[i];
+		mutex_init(&inode_map->inode_table_mutex);
+		inode_map->inode_inuse_tree = RB_ROOT;
+	}
+
+	mutex_init(&sbi->s_lock);
+
+	sbi->zeroed_page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!sbi->zeroed_page) {
+		retval = -ENOMEM;
+		nova_dbg("%s: sbi->zeroed_page failed.",
+			 __func__);
+		goto out;
+	}
+
+	for (i = 0; i < 8; i++)
+		sbi->zero_csum[i] = nova_crc32c(NOVA_INIT_CSUM,
+				sbi->zeroed_page, strp_size);
+	sbi->zero_parity = kzalloc(strp_size, GFP_KERNEL);
+
+	if (!sbi->zero_parity) {
+		retval = -ENOMEM;
+		nova_err(sb, "%s: sbi->zero_parity failed.",
+			 __func__);
+		goto out;
+	}
+
+	sbi->snapshot_si = kmem_cache_alloc(nova_inode_cachep, GFP_NOFS);
+	nova_snapshot_init(sb);
+
+	retval = nova_parse_options(data, sbi, 0);
+	if (retval) {
+		nova_err(sb, "%s: Failed to parse nova command line options.",
+			 __func__);
+		goto out;
+	}
+
+	if (nova_alloc_block_free_lists(sb)) {
+		retval = -ENOMEM;
+		nova_err(sb, "%s: Failed to allocate block free lists.",
+			 __func__);
+		goto out;
+	}
+
+	nova_sysfs_init(sb);
+
+	/* Init a new nova instance */
+	if (sbi->s_mount_opt & NOVA_MOUNT_FORMAT) {
+		root_pi = nova_init(sb, sbi->initsize);
+		retval = -ENOMEM;
+		if (IS_ERR(root_pi)) {
+			nova_err(sb, "%s: root_pi error.",
+				 __func__);
+
+			goto out;
+		}
+		goto setup_sb;
+	}
+
+	nova_dbg_verbose("checking physical address 0x%016llx for nova image\n",
+		  (u64)sbi->phys_addr);
+
+	if (nova_check_integrity(sb) < 0) {
+		nova_dbg("Memory contains invalid nova %x:%x\n",
+			le32_to_cpu(sbi->nova_sb->s_magic), NOVA_SUPER_MAGIC);
+		goto out;
+	}
+
+	if (nova_lite_journal_soft_init(sb)) {
+		retval = -EINVAL;
+		nova_err(sb, "Lite journal initialization failed\n");
+		goto out;
+	}
+
+	if (sbi->mount_snapshot) {
+		retval = nova_mount_snapshot(sb);
+		if (retval) {
+			nova_err(sb, "Mount snapshot failed\n");
+			goto out;
+		}
+	}
+
+	blocksize = le32_to_cpu(sbi->nova_sb->s_blocksize);
+	nova_set_blocksize(sb, blocksize);
+
+	nova_dbg_verbose("blocksize %lu\n", blocksize);
+
+	/* Read the root inode */
+	root_pi = nova_get_inode_by_ino(sb, NOVA_ROOT_INO);
+
+	/* Check that the root inode is in a sane state */
+	nova_root_check(sb, root_pi);
+
+	/* Set it all up.. */
+setup_sb:
+	sb->s_magic = le32_to_cpu(sbi->nova_sb->s_magic);
+	sb->s_op = &nova_sops;
+	sb->s_maxbytes = nova_max_size(sb->s_blocksize_bits);
+	sb->s_time_gran = 1000000000; // 1 second.
+	sb->s_export_op = &nova_export_ops;
+	sb->s_xattr = NULL;
+	sb->s_flags |= MS_NOSEC;
+
+	/* If the FS was not formatted on this mount, scan the meta-data after
+	 * truncate list has been processed
+	 */
+	if ((sbi->s_mount_opt & NOVA_MOUNT_FORMAT) == 0)
+		nova_recovery(sb);
+
+	root_i = nova_iget(sb, NOVA_ROOT_INO);
+	if (IS_ERR(root_i)) {
+		retval = PTR_ERR(root_i);
+		nova_err(sb, "%s: failed to get root inode",
+			 __func__);
+
+		goto out;
+	}
+
+	sb->s_root = d_make_root(root_i);
+	if (!sb->s_root) {
+		nova_err(sb, "get nova root inode failed\n");
+		retval = -ENOMEM;
+		goto out;
+	}
+
+	if (!(sb->s_flags & MS_RDONLY))
+		nova_update_mount_time(sb);
+
+	nova_print_curr_epoch_id(sb);
+
+	retval = 0;
+	NOVA_END_TIMING(mount_t, mount_time);
+	return retval;
+out:
+	kfree(sbi->zeroed_page);
+	sbi->zeroed_page = NULL;
+
+	kfree(sbi->zero_parity);
+	sbi->zero_parity = NULL;
+
+	kfree(sbi->free_lists);
+	sbi->free_lists = NULL;
+
+	kfree(sbi->journal_locks);
+	sbi->journal_locks = NULL;
+
+	kfree(sbi->inode_maps);
+	sbi->inode_maps = NULL;
+
+	nova_sysfs_exit(sb);
+
+	kfree(sbi->nova_sb);
+	kfree(sbi);
+	return retval;
+}
+
+int nova_statfs(struct dentry *d, struct kstatfs *buf)
+{
+	struct super_block *sb = d->d_sb;
+	struct nova_sb_info *sbi = (struct nova_sb_info *)sb->s_fs_info;
+
+	buf->f_type = NOVA_SUPER_MAGIC;
+	buf->f_bsize = sb->s_blocksize;
+
+	buf->f_blocks = sbi->num_blocks;
+	buf->f_bfree = buf->f_bavail = nova_count_free_blocks(sb);
+	buf->f_files = LONG_MAX;
+	buf->f_ffree = LONG_MAX - sbi->s_inodes_used_count;
+	buf->f_namelen = NOVA_NAME_LEN;
+	nova_dbg_verbose("nova_stats: total 4k free blocks 0x%llx\n",
+		buf->f_bfree);
+	return 0;
+}
+
+static int nova_show_options(struct seq_file *seq, struct dentry *root)
+{
+	struct nova_sb_info *sbi = NOVA_SB(root->d_sb);
+
+	//seq_printf(seq, ",physaddr=0x%016llx", (u64)sbi->phys_addr);
+	//if (sbi->initsize)
+	//     seq_printf(seq, ",init=%luk", sbi->initsize >> 10);
+	//if (sbi->blocksize)
+	//	 seq_printf(seq, ",bs=%lu", sbi->blocksize);
+	//if (sbi->bpi)
+	//	seq_printf(seq, ",bpi=%lu", sbi->bpi);
+	if (sbi->mode != (0777 | S_ISVTX))
+		seq_printf(seq, ",mode=%03o", sbi->mode);
+	if (uid_valid(sbi->uid))
+		seq_printf(seq, ",uid=%u", from_kuid(&init_user_ns, sbi->uid));
+	if (gid_valid(sbi->gid))
+		seq_printf(seq, ",gid=%u", from_kgid(&init_user_ns, sbi->gid));
+	if (test_opt(root->d_sb, ERRORS_RO))
+		seq_puts(seq, ",errors=remount-ro");
+	if (test_opt(root->d_sb, ERRORS_PANIC))
+		seq_puts(seq, ",errors=panic");
+	/* memory protection disabled by default */
+	if (test_opt(root->d_sb, PROTECT))
+		seq_puts(seq, ",wprotect");
+	//if (test_opt(root->d_sb, DAX))
+	//	seq_puts(seq, ",dax");
+
+	return 0;
+}
+
+int nova_remount(struct super_block *sb, int *mntflags, char *data)
+{
+	unsigned long old_sb_flags;
+	unsigned long old_mount_opt;
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	int ret = -EINVAL;
+
+	/* Store the old options */
+	mutex_lock(&sbi->s_lock);
+	old_sb_flags = sb->s_flags;
+	old_mount_opt = sbi->s_mount_opt;
+
+	if (nova_parse_options(data, sbi, 1))
+		goto restore_opt;
+
+	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
+		      ((sbi->s_mount_opt & NOVA_MOUNT_POSIX_ACL) ?
+		       MS_POSIXACL : 0);
+
+	if ((*mntflags & MS_RDONLY) != (sb->s_flags & MS_RDONLY))
+		nova_update_mount_time(sb);
+
+	mutex_unlock(&sbi->s_lock);
+	ret = 0;
+	return ret;
+
+restore_opt:
+	sb->s_flags = old_sb_flags;
+	sbi->s_mount_opt = old_mount_opt;
+	mutex_unlock(&sbi->s_lock);
+	return ret;
+}
+
+static void nova_put_super(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct inode_map *inode_map;
+	int i;
+
+	nova_print_curr_epoch_id(sb);
+
+	/* It's unmount time, so unmap the nova memory */
+//	nova_print_free_lists(sb);
+	if (sbi->virt_addr) {
+		nova_save_snapshots(sb);
+		kmem_cache_free(nova_inode_cachep, sbi->snapshot_si);
+		nova_save_inode_list_to_log(sb);
+		/* Save everything before blocknode mapping! */
+		nova_save_blocknode_mappings_to_log(sb);
+		sbi->virt_addr = NULL;
+	}
+
+	nova_delete_free_lists(sb);
+
+	kfree(sbi->zeroed_page);
+	kfree(sbi->zero_parity);
+	nova_dbgmask = 0;
+	kfree(sbi->free_lists);
+	kfree(sbi->journal_locks);
+
+	for (i = 0; i < sbi->cpus; i++) {
+		inode_map = &sbi->inode_maps[i];
+		nova_dbgv("CPU %d: inode allocated %d, freed %d\n",
+			i, inode_map->allocated, inode_map->freed);
+	}
+
+	kfree(sbi->inode_maps);
+
+	nova_sysfs_exit(sb);
+
+	kfree(sbi->nova_sb);
+	kfree(sbi);
+	sb->s_fs_info = NULL;
+}
+
+inline void nova_free_range_node(struct nova_range_node *node)
+{
+	kmem_cache_free(nova_range_node_cachep, node);
+}
+
+
+inline void nova_free_inode_node(struct super_block *sb,
+	struct nova_range_node *node)
+{
+	nova_free_range_node(node);
+}
+
+inline void nova_free_vma_item(struct super_block *sb,
+	struct vma_item *item)
+{
+	nova_free_range_node((struct nova_range_node *)item);
+}
+
+inline struct snapshot_info *nova_alloc_snapshot_info(struct super_block *sb)
+{
+	struct snapshot_info *p;
+
+	p = (struct snapshot_info *)
+		kmem_cache_alloc(nova_snapshot_info_cachep, GFP_NOFS);
+	return p;
+}
+
+inline void nova_free_snapshot_info(struct snapshot_info *info)
+{
+	kmem_cache_free(nova_snapshot_info_cachep, info);
+}
+
+inline struct nova_range_node *nova_alloc_range_node(struct super_block *sb)
+{
+	struct nova_range_node *p;
+
+	p = (struct nova_range_node *)
+		kmem_cache_zalloc(nova_range_node_cachep, GFP_NOFS);
+	return p;
+}
+
+
+inline struct nova_range_node *nova_alloc_inode_node(struct super_block *sb)
+{
+	return nova_alloc_range_node(sb);
+}
+
+inline struct vma_item *nova_alloc_vma_item(struct super_block *sb)
+{
+	return (struct vma_item *)nova_alloc_range_node(sb);
+}
+
+
+static struct inode *nova_alloc_inode(struct super_block *sb)
+{
+	struct nova_inode_info *vi;
+
+	vi = kmem_cache_alloc(nova_inode_cachep, GFP_NOFS);
+	if (!vi)
+		return NULL;
+
+	vi->vfs_inode.i_version = 1;
+
+	return &vi->vfs_inode;
+}
+
+static void nova_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	struct nova_inode_info *vi = NOVA_I(inode);
+
+	nova_dbg_verbose("%s: ino %lu\n", __func__, inode->i_ino);
+	kmem_cache_free(nova_inode_cachep, vi);
+}
+
+static void nova_destroy_inode(struct inode *inode)
+{
+	nova_dbgv("%s: %lu\n", __func__, inode->i_ino);
+	call_rcu(&inode->i_rcu, nova_i_callback);
+}
+
+static void init_once(void *foo)
+{
+	struct nova_inode_info *vi = foo;
+
+	inode_init_once(&vi->vfs_inode);
+}
+
+
+static int __init init_rangenode_cache(void)
+{
+	nova_range_node_cachep = kmem_cache_create("nova_range_node_cache",
+					sizeof(struct nova_range_node),
+					0, (SLAB_RECLAIM_ACCOUNT |
+					SLAB_MEM_SPREAD), NULL);
+	if (nova_range_node_cachep == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static int __init init_snapshot_info_cache(void)
+{
+	nova_snapshot_info_cachep = kmem_cache_create(
+					"nova_snapshot_info_cache",
+					sizeof(struct snapshot_info),
+					0, (SLAB_RECLAIM_ACCOUNT |
+					SLAB_MEM_SPREAD), NULL);
+	if (nova_snapshot_info_cachep == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static int __init init_inodecache(void)
+{
+	nova_inode_cachep = kmem_cache_create("nova_inode_cache",
+					       sizeof(struct nova_inode_info),
+					       0, (SLAB_RECLAIM_ACCOUNT |
+						   SLAB_MEM_SPREAD), init_once);
+	if (nova_inode_cachep == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void destroy_inodecache(void)
+{
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before
+	 * we destroy cache.
+	 */
+	rcu_barrier();
+	kmem_cache_destroy(nova_inode_cachep);
+}
+
+static void destroy_rangenode_cache(void)
+{
+	kmem_cache_destroy(nova_range_node_cachep);
+}
+
+static void destroy_snapshot_info_cache(void)
+{
+	kmem_cache_destroy(nova_snapshot_info_cachep);
+}
+
+/*
+ * the super block writes are all done "on the fly", so the
+ * super block is never in a "dirty" state, so there's no need
+ * for write_super.
+ */
+static struct super_operations nova_sops = {
+	.alloc_inode	= nova_alloc_inode,
+	.destroy_inode	= nova_destroy_inode,
+	.write_inode	= nova_write_inode,
+	.dirty_inode	= nova_dirty_inode,
+	.evict_inode	= nova_evict_inode,
+	.put_super	= nova_put_super,
+	.statfs		= nova_statfs,
+	.remount_fs	= nova_remount,
+	.show_options	= nova_show_options,
+};
+
+static struct dentry *nova_mount(struct file_system_type *fs_type,
+				  int flags, const char *dev_name, void *data)
+{
+	return mount_bdev(fs_type, flags, dev_name, data, nova_fill_super);
+}
+
+static struct file_system_type nova_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "NOVA",
+	.mount		= nova_mount,
+	.kill_sb	= kill_block_super,
+};
+
+static struct inode *nova_nfs_get_inode(struct super_block *sb,
+					 u64 ino, u32 generation)
+{
+	struct inode *inode;
+
+	if (ino < NOVA_ROOT_INO)
+		return ERR_PTR(-ESTALE);
+
+	if (ino > LONG_MAX)
+		return ERR_PTR(-ESTALE);
+
+	inode = nova_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+
+	if (generation && inode->i_generation != generation) {
+		/* we didn't find the right inode.. */
+		iput(inode);
+		return ERR_PTR(-ESTALE);
+	}
+
+	return inode;
+}
+
+static struct dentry *nova_fh_to_dentry(struct super_block *sb,
+					 struct fid *fid, int fh_len,
+					 int fh_type)
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+				    nova_nfs_get_inode);
+}
+
+static struct dentry *nova_fh_to_parent(struct super_block *sb,
+					 struct fid *fid, int fh_len,
+					 int fh_type)
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+				    nova_nfs_get_inode);
+}
+
+static const struct export_operations nova_export_ops = {
+	.fh_to_dentry	= nova_fh_to_dentry,
+	.fh_to_parent	= nova_fh_to_parent,
+	.get_parent	= nova_get_parent,
+};
+
+static int __init init_nova_fs(void)
+{
+	int rc = 0;
+	timing_t init_time;
+
+	NOVA_START_TIMING(init_t, init_time);
+	nova_dbg("%s: %d cpus online\n", __func__, num_online_cpus());
+	if (arch_has_clwb())
+		support_clwb = 1;
+
+	nova_info("Arch new instructions support: CLWB %s\n",
+			support_clwb ? "YES" : "NO");
+
+	nova_proc_root = proc_mkdir(proc_dirname, NULL);
+
+	nova_dbg("Data structure size: inode %lu, log_page %lu, file_write_entry %lu, dir_entry(max) %d, setattr_entry %lu, link_change_entry %lu\n",
+		sizeof(struct nova_inode),
+		sizeof(struct nova_inode_log_page),
+		sizeof(struct nova_file_write_entry),
+		NOVA_DIR_LOG_REC_LEN(NOVA_NAME_LEN),
+		sizeof(struct nova_setattr_logentry),
+		sizeof(struct nova_link_change_entry));
+
+	rc = init_rangenode_cache();
+	if (rc)
+		return rc;
+
+	rc = init_inodecache();
+	if (rc)
+		goto out1;
+
+	rc = init_snapshot_info_cache();
+	if (rc)
+		goto out2;
+
+	rc = register_filesystem(&nova_fs_type);
+	if (rc)
+		goto out3;
+
+	NOVA_END_TIMING(init_t, init_time);
+	return 0;
+
+out3:
+	destroy_snapshot_info_cache();
+out2:
+	destroy_inodecache();
+out1:
+	destroy_rangenode_cache();
+	return rc;
+}
+
+static void __exit exit_nova_fs(void)
+{
+	unregister_filesystem(&nova_fs_type);
+	remove_proc_entry(proc_dirname, NULL);
+	destroy_snapshot_info_cache();
+	destroy_inodecache();
+	destroy_rangenode_cache();
+}
+
+MODULE_AUTHOR("Andiry Xu <jix024@cs.ucsd.edu>");
+MODULE_DESCRIPTION("NOVA: A Persistent Memory File System");
+MODULE_LICENSE("GPL");
+
+module_init(init_nova_fs)
+module_exit(exit_nova_fs)
diff --git a/fs/nova/super.h b/fs/nova/super.h
new file mode 100644
index 000000000000..8c0ffbf79e9b
--- /dev/null
+++ b/fs/nova/super.h
@@ -0,0 +1,216 @@
+#ifndef __SUPER_H
+#define __SUPER_H
+/*
+ * Structure of the NOVA super block in PMEM
+ *
+ * The fields are partitioned into static and dynamic fields. The static fields
+ * never change after file system creation. This was primarily done because
+ * nova_get_block() returns NULL if the block offset is 0 (helps in catching
+ * bugs). So if we modify any field using journaling (for consistency), we
+ * will have to modify s_sum which is at offset 0. So journaling code fails.
+ * This (static+dynamic fields) is a temporary solution and can be avoided
+ * once the file system becomes stable and nova_get_block() returns correct
+ * pointers even for offset 0.
+ */
+struct nova_super_block {
+	/* static fields. they never change after file system creation.
+	 * checksum only validates up to s_start_dynamic field below
+	 */
+	__le32		s_sum;			/* checksum of this sb */
+	__le32		s_magic;		/* magic signature */
+	__le32		s_padding32;
+	__le32		s_blocksize;		/* blocksize in bytes */
+	__le64		s_size;			/* total size of fs in bytes */
+	char		s_volume_name[16];	/* volume name */
+
+	/* all the dynamic fields should go here */
+	__le64		s_epoch_id;		/* Epoch ID */
+
+	/* s_mtime and s_wtime should be together and their order should not be
+	 * changed. we use an 8 byte write to update both of them atomically
+	 */
+	__le32		s_mtime;		/* mount time */
+	__le32		s_wtime;		/* write time */
+
+	/* Metadata and data protections */
+	u8		s_padding8;
+	u8		s_metadata_csum;
+	u8		s_data_csum;
+	u8		s_data_parity;
+} __attribute((__packed__));
+
+#define NOVA_SB_SIZE 512       /* must be power of two */
+
+/* ======================= Reserved blocks ========================= */
+
+/*
+ * The first block contains super blocks;
+ * The second block contains reserved inodes;
+ * The third block is reserved.
+ * The fourth block contains pointers to journal pages.
+ * The fifth/sixth block contains pointers to inode tables.
+ * The seventh/eighth blocks are void by now.
+ *
+ * If data protection is enabled, more blocks are reserverd for checksums and
+ * parities and the number is derived according to the whole storage size.
+ */
+#define	HEAD_RESERVED_BLOCKS	8
+
+#define SUPER_BLOCK_START       0 // Superblock
+#define	RESERVE_INODE_START	1 // Reserved inodes
+#define	JOURNAL_START		3 // journal pointer table
+#define	INODE_TABLE0_START	4 // inode table
+#define	INODE_TABLE1_START	5 // replica inode table
+
+/* For replica super block and replica reserved inodes */
+#define	TAIL_RESERVED_BLOCKS	2
+
+/* ======================= Reserved inodes ========================= */
+
+/* We have space for 31 reserved inodes */
+#define NOVA_ROOT_INO		(1)
+#define NOVA_INODETABLE_INO	(2)	/* Fake inode associated with inode
+					 * stroage.  We need this because our
+					 * allocator requires inode to be
+					 * associated with each allocation.
+					 * The data actually lives in linked
+					 * lists in INODE_TABLE0_START. */
+#define NOVA_BLOCKNODE_INO	(3)     /* Storage for allocator state */
+#define NOVA_LITEJOURNAL_INO	(4)     /* Storage for lightweight journals */
+#define NOVA_INODELIST1_INO	(5)     /* Storage for Inode free list */
+#define NOVA_SNAPSHOT_INO	(6)	/* Storage for snapshot state */
+#define NOVA_TEST_PERF_INO	(7)
+
+
+/* Normal inode starts at 32 */
+#define NOVA_NORMAL_INODE_START      (32)
+
+
+
+/*
+ * NOVA super-block data in DRAM
+ */
+struct nova_sb_info {
+	struct super_block *sb;			/* VFS super block */
+	struct nova_super_block *nova_sb;	/* DRAM copy of SB */
+	struct block_device *s_bdev;
+	struct dax_device *s_dax_dev;
+
+	/*
+	 * base physical and virtual address of NOVA (which is also
+	 * the pointer to the super block)
+	 */
+	phys_addr_t	phys_addr;
+	void		*virt_addr;
+	void		*replica_reserved_inodes_addr;
+	void		*replica_sb_addr;
+
+	unsigned long	num_blocks;
+
+	/* TODO: Remove this, since it's unused */
+	/*
+	 * Backing store option:
+	 * 1 = no load, 2 = no store,
+	 * else do both
+	 */
+	unsigned int	nova_backing_option;
+
+	/* Mount options */
+	unsigned long	bpi;
+	unsigned long	blocksize;
+	unsigned long	initsize;
+	unsigned long	s_mount_opt;
+	kuid_t		uid;    /* Mount uid for root directory */
+	kgid_t		gid;    /* Mount gid for root directory */
+	umode_t		mode;   /* Mount mode for root directory */
+	atomic_t	next_generation;
+	/* inode tracking */
+	unsigned long	s_inodes_used_count;
+	unsigned long	head_reserved_blocks;
+	unsigned long	tail_reserved_blocks;
+
+	struct mutex	s_lock;	/* protects the SB's buffer-head */
+
+	int cpus;
+	struct proc_dir_entry *s_proc;
+
+	/* Snapshot related */
+	struct nova_inode_info	*snapshot_si;
+	struct radix_tree_root	snapshot_info_tree;
+	int num_snapshots;
+	/* Current epoch. volatile guarantees visibility */
+	volatile u64 s_epoch_id;
+	volatile int snapshot_taking;
+
+	int mount_snapshot;
+	u64 mount_snapshot_epoch_id;
+
+	struct task_struct *snapshot_cleaner_thread;
+	wait_queue_head_t snapshot_cleaner_wait;
+	wait_queue_head_t snapshot_mmap_wait;
+	void *curr_clean_snapshot_info;
+
+	/* DAX-mmap snapshot structures */
+	struct mutex vma_mutex;
+	struct list_head mmap_sih_list;
+
+	/* ZEROED page for cache page initialized */
+	void *zeroed_page;
+
+	/* Checksum and parity for zero block */
+	u32 zero_csum[8];
+	void *zero_parity;
+
+	/* Per-CPU journal lock */
+	spinlock_t *journal_locks;
+
+	/* Per-CPU inode map */
+	struct inode_map	*inode_maps;
+
+	/* Decide new inode map id */
+	unsigned long map_id;
+
+	/* Per-CPU free block list */
+	struct free_list *free_lists;
+	unsigned long per_list_blocks;
+};
+
+static inline struct nova_sb_info *NOVA_SB(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+
+
+static inline struct nova_super_block
+*nova_get_redund_super(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	return (struct nova_super_block *)(sbi->replica_sb_addr);
+}
+
+
+/* If this is part of a read-modify-write of the super block,
+ * nova_memunlock_super() before calling!
+ */
+static inline struct nova_super_block *nova_get_super(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	return (struct nova_super_block *)sbi->virt_addr;
+}
+
+extern struct super_block *nova_read_super(struct super_block *sb, void *data,
+	int silent);
+extern int nova_statfs(struct dentry *d, struct kstatfs *buf);
+extern int nova_remount(struct super_block *sb, int *flags, char *data);
+void *nova_ioremap(struct super_block *sb, phys_addr_t phys_addr,
+	ssize_t size);
+extern struct nova_range_node *nova_alloc_range_node(struct super_block *sb);
+extern void nova_free_range_node(struct nova_range_node *node);
+extern void nova_update_super_crc(struct super_block *sb);
+extern void nova_sync_super(struct super_block *sb);
+
+struct snapshot_info *nova_alloc_snapshot_info(struct super_block *sb);
+#endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
