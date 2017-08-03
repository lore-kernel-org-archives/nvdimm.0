Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x244.google.com (mail-pf0-x244.google.com
 [IPv6:2607:f8b0:400e:c00::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB09F21E1DAD9
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 00:47:10 -0700 (PDT)
Received: by mail-pf0-x244.google.com with SMTP id c65so796926pfl.0
 for <linux-nvdimm@lists.01.org>; Thu, 03 Aug 2017 00:49:22 -0700 (PDT)
From: Steven Swanson <swanson@eng.ucsd.edu>
Subject: [RFC 10/16] NOVA: File data protection
Date: Thu, 03 Aug 2017 00:49:19 -0700
Message-ID: <150174655944.104003.4237300023971685800.stgit@hn>
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

Nova protects data and metadat from corruption due to media errors and
scribbles -- software errors in the kernels that may overwrite Nova data.

Replication
-----------

Nova replicates all PMEM metadata structures (there are a few exceptions.  They
are WIP).  For structure, there is a primary and an alternate (denoted as
alter in the code).  To ensure that Nova can recover a consistent copy of the
data in case of a failure, Nova first updates the primary, and issues a persist
barrier to ensure that data is written to NVMM.  Then it does the same for the
alternate.

Detection
---------

Nova uses two techniques to detect data corruption.  For media errors, Nova
should always uses memcpy_from_pmem() to read data from PMEM, usually by
copying the PMEM data structure into DRAM.

To detect software-caused corruption, Nova uses CRC32 checksums.  All the PMEM
data structures in Nova include csum field for this purpose.  Nova also
computes CRC32 checksums each 512-byte slice of each data page.

The checksums are stored in dedicated pages in each CPU's allocation region.

                                                          replica
                                                 parity   parity
					         page	  page
            +---+---+---+---+---+---+---+---+    +---+    +---+
data page 0 | 0 | 1 | 0 | 0 | 1 | 1 | 1 | 0 |    | 0 |    | 0 |
            +---+---+---+---+---+---+---+---+    +---+    +---+
data page 1 | 0 | 1 | 0 | 0 | 1 | 1 | 1 | 1 |    | 1 |    | 1 |
            +---+---+---+---+---+---+---+---+    +---+    +---+
data page 2 | 0 | 1 | 0 | 1 | 0 | 1 | 1 | 0 |    | 0 |    | 0 |
            +---+---+---+---+---+---+---+---+    +---+    +---+
data page 3 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 |    | 0 |    | 0 |
            +---+---+---+---+---+---+---+---+    +---+    +---+
    ...                    ...                    ...      ...

Recovery
--------

Nova uses replication to support recovery of metadata structures and
RAID4-style parity to recover corrupted data.

If Nova detects corruption of a metadata structure, it restores the structure
using the replica.

If it detects a corrupt slice of data page, it uses RAID4-style recovery to
restore it.  The CRC32 checksums for the page slices are replicated.

Cautious allocation
-------------------

To maximize its resilience to software scribbles, Nova allocate metadata
structures and their replicas far from one another.  It tries to allocate the
primary copy at a low address and the replica at a high address within the PMEM
region.

Write Protection
----------------

Finally, Nova supports can prevent unintended writes PMEM by mapping the entire
PMEM device as read-only and then disabling _all_ write protection by clearing
the WP bit the CR0 control register when Nova needs to perform a write.  The
wprotect mount-time option controls this behavior.

To map the PMEM device as read-only, we have added a readonly module command
line option to nd_pmem.  There is probably a better approach to achieving this
goal.

The changes to nd_pmem are included in a later patch in this series.

Signed-off-by: Steven Swanson <swanson@cs.ucsd.edu>
---
 fs/nova/checksum.c |  912 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/mprotect.c |  604 ++++++++++++++++++++++++++++++++++
 fs/nova/mprotect.h |  190 +++++++++++
 fs/nova/parity.c   |  411 +++++++++++++++++++++++
 4 files changed, 2117 insertions(+)
 create mode 100644 fs/nova/checksum.c
 create mode 100644 fs/nova/mprotect.c
 create mode 100644 fs/nova/mprotect.h
 create mode 100644 fs/nova/parity.c

diff --git a/fs/nova/checksum.c b/fs/nova/checksum.c
new file mode 100644
index 000000000000..092164a80d40
--- /dev/null
+++ b/fs/nova/checksum.c
@@ -0,0 +1,912 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Checksum related methods.
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
+
+#include "nova.h"
+#include "inode.h"
+
+static int nova_get_entry_copy(struct super_block *sb, void *entry,
+	u32 *entry_csum, size_t *entry_size, void *entry_copy)
+{
+	u8 type;
+	struct nova_dentry *dentry;
+	int ret = 0;
+
+	ret = memcpy_mcsafe(&type, entry, sizeof(u8));
+	if (ret < 0)
+		return ret;
+
+	switch (type) {
+	case DIR_LOG:
+		dentry = DENTRY(entry_copy);
+		ret = memcpy_mcsafe(dentry, entry, NOVA_DENTRY_HEADER_LEN);
+		if (ret < 0 || dentry->de_len > NOVA_MAX_ENTRY_LEN)
+			break;
+		*entry_size = dentry->de_len;
+		ret = memcpy_mcsafe((u8 *) dentry + NOVA_DENTRY_HEADER_LEN,
+					(u8 *) entry + NOVA_DENTRY_HEADER_LEN,
+					*entry_size - NOVA_DENTRY_HEADER_LEN);
+		if (ret < 0)
+			break;
+		*entry_csum = dentry->csum;
+		break;
+	case FILE_WRITE:
+		*entry_size = sizeof(struct nova_file_write_entry);
+		ret = memcpy_mcsafe(entry_copy, entry, *entry_size);
+		if (ret < 0)
+			break;
+		*entry_csum = WENTRY(entry_copy)->csum;
+		break;
+	case SET_ATTR:
+		*entry_size = sizeof(struct nova_setattr_logentry);
+		ret = memcpy_mcsafe(entry_copy, entry, *entry_size);
+		if (ret < 0)
+			break;
+		*entry_csum = SENTRY(entry_copy)->csum;
+		break;
+	case LINK_CHANGE:
+		*entry_size = sizeof(struct nova_link_change_entry);
+		ret = memcpy_mcsafe(entry_copy, entry, *entry_size);
+		if (ret < 0)
+			break;
+		*entry_csum = LCENTRY(entry_copy)->csum;
+		break;
+	case MMAP_WRITE:
+		*entry_size = sizeof(struct nova_mmap_entry);
+		ret = memcpy_mcsafe(entry_copy, entry, *entry_size);
+		if (ret < 0)
+			break;
+		*entry_csum = MMENTRY(entry_copy)->csum;
+		break;
+	case SNAPSHOT_INFO:
+		*entry_size = sizeof(struct nova_snapshot_info_entry);
+		ret = memcpy_mcsafe(entry_copy, entry, *entry_size);
+		if (ret < 0)
+			break;
+		*entry_csum = SNENTRY(entry_copy)->csum;
+		break;
+	default:
+		*entry_csum = 0;
+		*entry_size = 0;
+		nova_dbg("%s: unknown or unsupported entry type (%d) for checksum, 0x%llx\n",
+			 __func__, type, (u64)entry);
+		ret = -EINVAL;
+		dump_stack();
+		break;
+	}
+
+	return ret;
+}
+
+/* Calculate the entry checksum. */
+static u32 nova_calc_entry_csum(void *entry)
+{
+	u8 type;
+	u32 csum = 0;
+	size_t entry_len, check_len;
+	void *csum_addr, *remain;
+	timing_t calc_time;
+
+	NOVA_START_TIMING(calc_entry_csum_t, calc_time);
+
+	/* Entry is checksummed excluding its csum field. */
+	type = nova_get_entry_type(entry);
+	switch (type) {
+	/* nova_dentry has variable length due to its name. */
+	case DIR_LOG:
+		entry_len =  DENTRY(entry)->de_len;
+		csum_addr = &DENTRY(entry)->csum;
+		break;
+	case FILE_WRITE:
+		entry_len = sizeof(struct nova_file_write_entry);
+		csum_addr = &WENTRY(entry)->csum;
+		break;
+	case SET_ATTR:
+		entry_len = sizeof(struct nova_setattr_logentry);
+		csum_addr = &SENTRY(entry)->csum;
+		break;
+	case LINK_CHANGE:
+		entry_len = sizeof(struct nova_link_change_entry);
+		csum_addr = &LCENTRY(entry)->csum;
+		break;
+	case MMAP_WRITE:
+		entry_len = sizeof(struct nova_mmap_entry);
+		csum_addr = &MMENTRY(entry)->csum;
+		break;
+	case SNAPSHOT_INFO:
+		entry_len = sizeof(struct nova_snapshot_info_entry);
+		csum_addr = &SNENTRY(entry)->csum;
+		break;
+	default:
+		entry_len = 0;
+		csum_addr = NULL;
+		nova_dbg("%s: unknown or unsupported entry type (%d) for checksum, 0x%llx\n",
+			 __func__, type, (u64) entry);
+		break;
+	}
+
+	if (entry_len > 0) {
+		check_len = ((u8 *) csum_addr) - ((u8 *) entry);
+		csum = nova_crc32c(NOVA_INIT_CSUM, entry, check_len);
+		check_len = entry_len - (check_len + NOVA_META_CSUM_LEN);
+		if (check_len > 0) {
+			remain = ((u8 *) csum_addr) + NOVA_META_CSUM_LEN;
+			csum = nova_crc32c(csum, remain, check_len);
+		}
+
+		if (check_len < 0) {
+			nova_dbg("%s: checksum run-length error %ld < 0",
+				__func__, check_len);
+		}
+	}
+
+	NOVA_END_TIMING(calc_entry_csum_t, calc_time);
+	return csum;
+}
+
+/* Update the log entry checksum. */
+void nova_update_entry_csum(void *entry)
+{
+	u8  type;
+	u32 csum;
+	size_t entry_len = CACHELINE_SIZE;
+
+	if (metadata_csum == 0)
+		goto flush;
+
+	type = nova_get_entry_type(entry);
+	csum = nova_calc_entry_csum(entry);
+
+	switch (type) {
+	case DIR_LOG:
+		DENTRY(entry)->csum = cpu_to_le32(csum);
+		entry_len = DENTRY(entry)->de_len;
+		break;
+	case FILE_WRITE:
+		WENTRY(entry)->csum = cpu_to_le32(csum);
+		entry_len = sizeof(struct nova_file_write_entry);
+		break;
+	case SET_ATTR:
+		SENTRY(entry)->csum = cpu_to_le32(csum);
+		entry_len = sizeof(struct nova_setattr_logentry);
+		break;
+	case LINK_CHANGE:
+		LCENTRY(entry)->csum = cpu_to_le32(csum);
+		entry_len = sizeof(struct nova_link_change_entry);
+		break;
+	case MMAP_WRITE:
+		MMENTRY(entry)->csum = cpu_to_le32(csum);
+		entry_len = sizeof(struct nova_mmap_entry);
+		break;
+	case SNAPSHOT_INFO:
+		SNENTRY(entry)->csum = cpu_to_le32(csum);
+		entry_len = sizeof(struct nova_snapshot_info_entry);
+		break;
+	default:
+		entry_len = 0;
+		nova_dbg("%s: unknown or unsupported entry type (%d), 0x%llx\n",
+			__func__, type, (u64) entry);
+		break;
+	}
+
+flush:
+	if (entry_len > 0)
+		nova_flush_buffer(entry, entry_len, 0);
+
+}
+
+int nova_update_alter_entry(struct super_block *sb, void *entry)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	void *alter_entry;
+	u64 curr, alter_curr;
+	u32 entry_csum;
+	size_t size;
+	char entry_copy[NOVA_MAX_ENTRY_LEN];
+	int ret;
+
+	if (metadata_csum == 0)
+		return 0;
+
+	curr = nova_get_addr_off(sbi, entry);
+	alter_curr = alter_log_entry(sb, curr);
+	if (alter_curr == 0) {
+		nova_err(sb, "%s: log page tail error detected\n", __func__);
+		return -EIO;
+	}
+	alter_entry = (void *)nova_get_block(sb, alter_curr);
+
+	ret = nova_get_entry_copy(sb, entry, &entry_csum, &size, entry_copy);
+	if (ret)
+		return ret;
+
+	ret = memcpy_to_pmem_nocache(alter_entry, entry_copy, size);
+	return ret;
+}
+
+/* media error: repair the poison radius that the entry belongs to */
+static int nova_repair_entry_pr(struct super_block *sb, void *entry)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	int ret;
+	u64 entry_off, alter_off;
+	void *entry_pr, *alter_pr;
+
+	entry_off = nova_get_addr_off(sbi, entry);
+	alter_off = alter_log_entry(sb, entry_off);
+	if (alter_off == 0) {
+		nova_err(sb, "%s: log page tail error detected\n", __func__);
+		goto fail;
+	}
+
+	entry_pr = (void *) nova_get_block(sb, entry_off & POISON_MASK);
+	alter_pr = (void *) nova_get_block(sb, alter_off & POISON_MASK);
+
+	if (entry_pr == NULL || alter_pr == NULL)
+		BUG();
+
+	nova_memunlock_range(sb, entry_pr, POISON_RADIUS);
+	ret = memcpy_mcsafe(entry_pr, alter_pr, POISON_RADIUS);
+	nova_memlock_range(sb, entry_pr, POISON_RADIUS);
+	nova_flush_buffer(entry_pr, POISON_RADIUS, 0);
+
+	/* alter_entry shows media error during memcpy */
+	if (ret < 0)
+		goto fail;
+
+	nova_dbg("%s: entry media error repaired\n", __func__);
+	return 0;
+
+fail:
+	nova_err(sb, "%s: unrecoverable media error detected\n", __func__);
+	return -1;
+}
+
+static int nova_repair_entry(struct super_block *sb, void *bad, void *good,
+	size_t entry_size)
+{
+	int ret;
+
+	nova_memunlock_range(sb, bad, entry_size);
+	ret = memcpy_to_pmem_nocache(bad, good, entry_size);
+	nova_memlock_range(sb, bad, entry_size);
+
+	if (ret == 0)
+		nova_dbg("%s: entry error repaired\n", __func__);
+
+	return ret;
+}
+
+/* Verify the log entry checksum and get a copy in DRAM. */
+bool nova_verify_entry_csum(struct super_block *sb, void *entry, void *entryc)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	int ret = 0;
+	u64 entry_off, alter_off;
+	void *alter;
+	size_t entry_size, alter_size;
+	u32 entry_csum, alter_csum;
+	u32 entry_csum_calc, alter_csum_calc;
+	char entry_copy[NOVA_MAX_ENTRY_LEN];
+	char alter_copy[NOVA_MAX_ENTRY_LEN];
+	timing_t verify_time;
+
+	if (metadata_csum == 0)
+		return true;
+
+	NOVA_START_TIMING(verify_entry_csum_t, verify_time);
+
+	ret = nova_get_entry_copy(sb, entry, &entry_csum, &entry_size,
+				  entry_copy);
+	if (ret < 0) { /* media error */
+		ret = nova_repair_entry_pr(sb, entry);
+		if (ret < 0)
+			goto fail;
+		/* try again */
+		ret = nova_get_entry_copy(sb, entry, &entry_csum, &entry_size,
+						entry_copy);
+		if (ret < 0)
+			goto fail;
+	}
+
+	entry_off = nova_get_addr_off(sbi, entry);
+	alter_off = alter_log_entry(sb, entry_off);
+	if (alter_off == 0) {
+		nova_err(sb, "%s: log page tail error detected\n", __func__);
+		goto fail;
+	}
+
+	alter = (void *) nova_get_block(sb, alter_off);
+	ret = nova_get_entry_copy(sb, alter, &alter_csum, &alter_size,
+					alter_copy);
+	if (ret < 0) { /* media error */
+		ret = nova_repair_entry_pr(sb, alter);
+		if (ret < 0)
+			goto fail;
+		/* try again */
+		ret = nova_get_entry_copy(sb, alter, &alter_csum, &alter_size,
+						alter_copy);
+		if (ret < 0)
+			goto fail;
+	}
+
+	/* no media errors, now verify the checksums */
+	entry_csum = le32_to_cpu(entry_csum);
+	alter_csum = le32_to_cpu(alter_csum);
+	entry_csum_calc = nova_calc_entry_csum(entry_copy);
+	alter_csum_calc = nova_calc_entry_csum(alter_copy);
+
+	if (entry_csum != entry_csum_calc && alter_csum != alter_csum_calc) {
+		nova_err(sb, "%s: both entry and its replica fail checksum verification\n",
+			 __func__);
+		goto fail;
+	} else if (entry_csum != entry_csum_calc) {
+		nova_dbg("%s: entry %p checksum error, trying to repair using the replica\n",
+			 __func__, entry);
+		ret = nova_repair_entry(sb, entry, alter_copy, alter_size);
+		if (ret != 0)
+			goto fail;
+
+		memcpy(entryc, alter_copy, alter_size);
+	} else if (alter_csum != alter_csum_calc) {
+		nova_dbg("%s: entry replica %p checksum error, trying to repair using the primary\n",
+			 __func__, alter);
+		ret = nova_repair_entry(sb, alter, entry_copy, entry_size);
+		if (ret != 0)
+			goto fail;
+
+		memcpy(entryc, entry_copy, entry_size);
+	} else {
+		/* now both entries pass checksum verification and the primary
+		 * is trusted if their buffers don't match
+		 */
+		if (memcmp(entry_copy, alter_copy, entry_size)) {
+			nova_dbg("%s: entry replica %p error, trying to repair using the primary\n",
+				 __func__, alter);
+			ret = nova_repair_entry(sb, alter, entry_copy,
+						entry_size);
+			if (ret != 0)
+				goto fail;
+		}
+
+		memcpy(entryc, entry_copy, entry_size);
+	}
+
+	NOVA_END_TIMING(verify_entry_csum_t, verify_time);
+	return true;
+
+fail:
+	nova_err(sb, "%s: unable to repair entry errors\n", __func__);
+
+	NOVA_END_TIMING(verify_entry_csum_t, verify_time);
+	return false;
+}
+
+/* media error: repair the poison radius that the inode belongs to */
+static int nova_repair_inode_pr(struct super_block *sb,
+	struct nova_inode *bad_pi, struct nova_inode *good_pi)
+{
+	int ret;
+	void *bad_pr, *good_pr;
+
+	bad_pr = (void *)((u64) bad_pi & POISON_MASK);
+	good_pr = (void *)((u64) good_pi & POISON_MASK);
+
+	if (bad_pr == NULL || good_pr == NULL)
+		BUG();
+
+	nova_memunlock_range(sb, bad_pr, POISON_RADIUS);
+	ret = memcpy_mcsafe(bad_pr, good_pr, POISON_RADIUS);
+	nova_memlock_range(sb, bad_pr, POISON_RADIUS);
+	nova_flush_buffer(bad_pr, POISON_RADIUS, 0);
+
+	/* good_pi shows media error during memcpy */
+	if (ret < 0)
+		goto fail;
+
+	nova_dbg("%s: inode media error repaired\n", __func__);
+	return 0;
+
+fail:
+	nova_err(sb, "%s: unrecoverable media error detected\n", __func__);
+	return -1;
+}
+
+static int nova_repair_inode(struct super_block *sb, struct nova_inode *bad_pi,
+	struct nova_inode *good_copy)
+{
+	int ret;
+
+	nova_memunlock_inode(sb, bad_pi);
+	ret = memcpy_to_pmem_nocache(bad_pi, good_copy,
+					sizeof(struct nova_inode));
+	nova_memlock_inode(sb, bad_pi);
+
+	if (ret == 0)
+		nova_dbg("%s: inode %llu error repaired\n", __func__,
+					good_copy->nova_ino);
+
+	return ret;
+}
+
+/*
+ * Check nova_inode and get a copy in DRAM.
+ * If we are going to update (write) the inode, we don't need to check the
+ * alter inode if the major inode checks ok. If we are going to read or rebuild
+ * the inode, also check the alter even if the major inode checks ok.
+ */
+int nova_check_inode_integrity(struct super_block *sb, u64 ino, u64 pi_addr,
+	u64 alter_pi_addr, struct nova_inode *pic, int check_replica)
+{
+	struct nova_inode *pi, *alter_pi, alter_copy, *alter_pic;
+	int inode_bad, alter_bad;
+	int ret;
+
+	pi = (struct nova_inode *)nova_get_block(sb, pi_addr);
+
+	ret = memcpy_mcsafe(pic, pi, sizeof(struct nova_inode));
+
+	if (metadata_csum == 0)
+		return ret;
+
+	alter_pi = (struct nova_inode *)nova_get_block(sb, alter_pi_addr);
+
+	if (ret < 0) { /* media error */
+		ret = nova_repair_inode_pr(sb, pi, alter_pi);
+		if (ret < 0)
+			goto fail;
+		/* try again */
+		ret = memcpy_mcsafe(pic, pi, sizeof(struct nova_inode));
+		if (ret < 0)
+			goto fail;
+	}
+
+	inode_bad = nova_check_inode_checksum(pic);
+
+	if (!inode_bad && !check_replica)
+		return 0;
+
+	alter_pic = &alter_copy;
+	ret = memcpy_mcsafe(alter_pic, alter_pi, sizeof(struct nova_inode));
+	if (ret < 0) { /* media error */
+		if (inode_bad)
+			goto fail;
+		ret = nova_repair_inode_pr(sb, alter_pi, pi);
+		if (ret < 0)
+			goto fail;
+		/* try again */
+		ret = memcpy_mcsafe(alter_pic, alter_pi,
+					sizeof(struct nova_inode));
+		if (ret < 0)
+			goto fail;
+	}
+
+	alter_bad = nova_check_inode_checksum(alter_pic);
+
+	if (inode_bad && alter_bad) {
+		nova_err(sb, "%s: both inode and its replica fail checksum verification\n",
+			 __func__);
+		goto fail;
+	} else if (inode_bad) {
+		nova_dbg("%s: inode %llu checksum error, trying to repair using the replica\n",
+			 __func__, ino);
+		ret = nova_repair_inode(sb, pi, alter_pic);
+		if (ret != 0)
+			goto fail;
+
+		memcpy(pic, alter_pic, sizeof(struct nova_inode));
+	} else if (alter_bad) {
+		nova_dbg("%s: inode replica %llu checksum error, trying to repair using the primary\n",
+			 __func__, ino);
+		ret = nova_repair_inode(sb, alter_pi, pic);
+		if (ret != 0)
+			goto fail;
+	} else if (memcmp(pic, alter_pic, sizeof(struct nova_inode))) {
+		nova_dbg("%s: inode replica %llu is stale, trying to repair using the primary\n",
+			 __func__, ino);
+		ret = nova_repair_inode(sb, alter_pi, pic);
+		if (ret != 0)
+			goto fail;
+	}
+
+	return 0;
+
+fail:
+	nova_err(sb, "%s: unable to repair inode errors\n", __func__);
+
+	return -EIO;
+}
+
+static int nova_update_stripe_csum(struct super_block *sb, unsigned long strps,
+	unsigned long strp_nr, u8 *strp_ptr, int zero)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	size_t strp_size = NOVA_STRIPE_SIZE;
+	unsigned long strp;
+	u32 csum;
+	u32 crc[8];
+	void *csum_addr, *csum_addr1;
+	void *src_addr;
+
+	while (strps >= 8) {
+		if (zero) {
+			src_addr = sbi->zero_csum;
+			goto copy;
+		}
+
+		crc[0] = cpu_to_le32(nova_crc32c(NOVA_INIT_CSUM,
+				strp_ptr, strp_size));
+		crc[1] = cpu_to_le32(nova_crc32c(NOVA_INIT_CSUM,
+				strp_ptr + strp_size, strp_size));
+		crc[2] = cpu_to_le32(nova_crc32c(NOVA_INIT_CSUM,
+				strp_ptr + strp_size * 2, strp_size));
+		crc[3] = cpu_to_le32(nova_crc32c(NOVA_INIT_CSUM,
+				strp_ptr + strp_size * 3, strp_size));
+		crc[4] = cpu_to_le32(nova_crc32c(NOVA_INIT_CSUM,
+				strp_ptr + strp_size * 4, strp_size));
+		crc[5] = cpu_to_le32(nova_crc32c(NOVA_INIT_CSUM,
+				strp_ptr + strp_size * 5, strp_size));
+		crc[6] = cpu_to_le32(nova_crc32c(NOVA_INIT_CSUM,
+				strp_ptr + strp_size * 6, strp_size));
+		crc[7] = cpu_to_le32(nova_crc32c(NOVA_INIT_CSUM,
+				strp_ptr + strp_size * 7, strp_size));
+
+		src_addr = crc;
+copy:
+		csum_addr = nova_get_data_csum_addr(sb, strp_nr, 0);
+		csum_addr1 = nova_get_data_csum_addr(sb, strp_nr, 1);
+
+		nova_memunlock_range(sb, csum_addr, NOVA_DATA_CSUM_LEN * 8);
+		if (support_clwb) {
+			memcpy(csum_addr, src_addr, NOVA_DATA_CSUM_LEN * 8);
+			memcpy(csum_addr1, src_addr, NOVA_DATA_CSUM_LEN * 8);
+		} else {
+			memcpy_to_pmem_nocache(csum_addr, src_addr,
+						NOVA_DATA_CSUM_LEN * 8);
+			memcpy_to_pmem_nocache(csum_addr1, src_addr,
+						NOVA_DATA_CSUM_LEN * 8);
+		}
+		nova_memlock_range(sb, csum_addr, NOVA_DATA_CSUM_LEN * 8);
+		if (support_clwb) {
+			nova_flush_buffer(csum_addr,
+					  NOVA_DATA_CSUM_LEN * 8, 0);
+			nova_flush_buffer(csum_addr1,
+					  NOVA_DATA_CSUM_LEN * 8, 0);
+		}
+
+		strp_nr += 8;
+		strps -= 8;
+		if (!zero)
+			strp_ptr += strp_size * 8;
+	}
+
+	for (strp = 0; strp < strps; strp++) {
+		if (zero)
+			csum = sbi->zero_csum[0];
+		else
+			csum = nova_crc32c(NOVA_INIT_CSUM, strp_ptr, strp_size);
+
+		csum = cpu_to_le32(csum);
+		csum_addr = nova_get_data_csum_addr(sb, strp_nr, 0);
+		csum_addr1 = nova_get_data_csum_addr(sb, strp_nr, 1);
+
+		nova_memunlock_range(sb, csum_addr, NOVA_DATA_CSUM_LEN);
+		memcpy_to_pmem_nocache(csum_addr, &csum, NOVA_DATA_CSUM_LEN);
+		memcpy_to_pmem_nocache(csum_addr1, &csum, NOVA_DATA_CSUM_LEN);
+		nova_memlock_range(sb, csum_addr, NOVA_DATA_CSUM_LEN);
+
+		strp_nr += 1;
+		if (!zero)
+			strp_ptr += strp_size;
+	}
+
+	return 0;
+}
+
+/* Checksums a sequence of contiguous file write data stripes within one block
+ * and writes the checksum values to nvmm.
+ *
+ * The block buffer to compute checksums should reside in dram (more trusted),
+ * not in nvmm (less trusted).
+ *
+ * Checksum is calculated over a whole stripe.
+ *
+ * block:   block buffer with user data and possibly partial head-tail block
+ *          - should be in kernel memory (dram) to avoid page faults
+ * blocknr: destination nvmm block number where the block is written to
+ *          - used to derive checksum value addresses
+ * offset:  byte offset of user data in the block buffer
+ * bytes:   number of user data bytes in the block buffer
+ * zero:    if the user data is all zero
+ */
+int nova_update_block_csum(struct super_block *sb,
+	struct nova_inode_info_header *sih, u8 *block, unsigned long blocknr,
+	size_t offset, size_t bytes, int zero)
+{
+	u8 *strp_ptr;
+	size_t blockoff;
+	unsigned int strp_shift = NOVA_STRIPE_SHIFT;
+	unsigned int strp_index, strp_offset;
+	unsigned long strps, strp_nr;
+	timing_t block_csum_time;
+
+	NOVA_START_TIMING(block_csum_t, block_csum_time);
+	blockoff = nova_get_block_off(sb, blocknr, sih->i_blk_type);
+
+	/* strp_index: stripe index within the block buffer
+	 * strp_offset: stripe offset within the block buffer
+	 *
+	 * strps: number of stripes touched by user data (need new checksums)
+	 * strp_nr: global stripe number converted from blocknr and offset
+	 * strp_ptr: pointer to stripes in the block buffer
+	 */
+	strp_index = offset >> strp_shift;
+	strp_offset = offset - (strp_index << strp_shift);
+
+	strps = ((strp_offset + bytes - 1) >> strp_shift) + 1;
+	strp_nr = (blockoff + offset) >> strp_shift;
+	strp_ptr = block + (strp_index << strp_shift);
+
+	nova_update_stripe_csum(sb, strps, strp_nr, strp_ptr, zero);
+
+	NOVA_END_TIMING(block_csum_t, block_csum_time);
+
+	return 0;
+}
+
+int nova_update_pgoff_csum(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_entry *entry,
+	unsigned long pgoff, int zero)
+{
+	void *dax_mem = NULL;
+	u64 blockoff;
+	size_t strp_size = NOVA_STRIPE_SIZE;
+	unsigned int strp_shift = NOVA_STRIPE_SHIFT;
+	unsigned long strp_nr;
+	int count;
+
+	count = blk_type_to_size[sih->i_blk_type] / strp_size;
+
+	blockoff = nova_find_nvmm_block(sb, sih, entry, pgoff);
+
+	/* Truncated? */
+	if (blockoff == 0)
+		return 0;
+
+	dax_mem = nova_get_block(sb, blockoff);
+
+	strp_nr = blockoff >> strp_shift;
+
+	nova_update_stripe_csum(sb, count, strp_nr, dax_mem, zero);
+
+	return 0;
+}
+
+/* Verify checksums of requested data bytes starting from offset of blocknr.
+ *
+ * Only a whole stripe can be checksum verified.
+ *
+ * blocknr: container blocknr for the first stripe to be verified
+ * offset:  byte offset within the block associated with blocknr
+ * bytes:   number of contiguous bytes to be verified starting from offset
+ *
+ * return: true or false
+ */
+bool nova_verify_data_csum(struct super_block *sb,
+	struct nova_inode_info_header *sih, unsigned long blocknr,
+	size_t offset, size_t bytes)
+{
+	void *blockptr, *strp_ptr;
+	size_t blockoff, blocksize = nova_inode_blk_size(sih);
+	size_t strp_size = NOVA_STRIPE_SIZE;
+	unsigned int strp_shift = NOVA_STRIPE_SHIFT;
+	unsigned int strp_index;
+	unsigned long strp, strps, strp_nr;
+	void *strip = NULL;
+	u32 csum_calc, csum_nvmm0, csum_nvmm1;
+	u32 *csum_addr0, *csum_addr1;
+	int error;
+	bool match;
+	timing_t verify_time;
+
+	NOVA_START_TIMING(verify_data_csum_t, verify_time);
+
+	/* Only a whole stripe can be checksum verified.
+	 * strps: # of stripes to be checked since offset.
+	 */
+	strps = ((offset + bytes - 1) >> strp_shift)
+		- (offset >> strp_shift) + 1;
+
+	blockoff = nova_get_block_off(sb, blocknr, sih->i_blk_type);
+	blockptr = nova_get_block(sb, blockoff);
+
+	/* strp_nr: global stripe number converted from blocknr and offset
+	 * strp_ptr: virtual address of the 1st stripe
+	 * strp_index: stripe index within a block
+	 */
+	strp_nr = (blockoff + offset) >> strp_shift;
+	strp_index = offset >> strp_shift;
+	strp_ptr = blockptr + (strp_index << strp_shift);
+
+	strip = kmalloc(strp_size, GFP_KERNEL);
+	if (strip == NULL)
+		return false;
+
+	match = true;
+	for (strp = 0; strp < strps; strp++) {
+		csum_addr0 = nova_get_data_csum_addr(sb, strp_nr, 0);
+		csum_nvmm0 = le32_to_cpu(*csum_addr0);
+
+		csum_addr1 = nova_get_data_csum_addr(sb, strp_nr, 1);
+		csum_nvmm1 = le32_to_cpu(*csum_addr1);
+
+		error = memcpy_mcsafe(strip, strp_ptr, strp_size);
+		if (error < 0) {
+			nova_dbg("%s: media error in data strip detected!\n",
+				__func__);
+			match = false;
+		} else {
+			csum_calc = nova_crc32c(NOVA_INIT_CSUM, strip,
+						strp_size);
+			match = (csum_calc == csum_nvmm0) ||
+				(csum_calc == csum_nvmm1);
+		}
+
+		if (!match) {
+			/* Getting here, data is considered corrupted.
+			 *
+			 * if: csum_nvmm0 == csum_nvmm1
+			 *     both csums good, run data recovery
+			 * if: csum_nvmm0 != csum_nvmm1
+			 *     at least one csum is corrupted, also need to run
+			 *     data recovery to see if one csum is still good
+			 */
+			nova_dbg("%s: nova data corruption detected! inode %lu, strp %lu of %lu, block offset %lu, stripe nr %lu, csum calc 0x%08x, csum nvmm 0x%08x, csum nvmm replica 0x%08x\n",
+				__func__, sih->ino, strp, strps, blockoff,
+				strp_nr, csum_calc, csum_nvmm0, csum_nvmm1);
+
+			if (data_parity == 0) {
+				nova_dbg("%s: no data redundancy available, can not repair data corruption!\n",
+					 __func__);
+				break;
+			}
+
+			nova_dbg("%s: nova data recovery begins\n", __func__);
+
+			error = nova_restore_data(sb, blocknr, strp_index,
+					strip, error, csum_nvmm0, csum_nvmm1,
+					&csum_calc);
+			if (error) {
+				nova_dbg("%s: nova data recovery fails!\n",
+						__func__);
+				dump_stack();
+				break;
+			}
+
+			/* Getting here, data corruption is repaired and the
+			 * good checksum is stored in csum_calc.
+			 */
+			nova_dbg("%s: nova data recovery success!\n", __func__);
+			match = true;
+		}
+
+		/* Getting here, match must be true, otherwise already breaking
+		 * out the for loop. Data is known good, either it's good in
+		 * nvmm, or good after recovery.
+		 */
+		if (csum_nvmm0 != csum_nvmm1) {
+			/* Getting here, data is known good but one checksum is
+			 * considered corrupted.
+			 */
+			nova_dbg("%s: nova checksum corruption detected! inode %lu, strp %lu of %lu, block offset %lu, stripe nr %lu, csum calc 0x%08x, csum nvmm 0x%08x, csum nvmm replica 0x%08x\n",
+				__func__, sih->ino, strp, strps, blockoff,
+				strp_nr, csum_calc, csum_nvmm0, csum_nvmm1);
+
+			nova_memunlock_range(sb, csum_addr0,
+							NOVA_DATA_CSUM_LEN);
+			if (csum_nvmm0 != csum_calc) {
+				csum_nvmm0 = cpu_to_le32(csum_calc);
+				memcpy_to_pmem_nocache(csum_addr0, &csum_nvmm0,
+							NOVA_DATA_CSUM_LEN);
+			}
+
+			if (csum_nvmm1 != csum_calc) {
+				csum_nvmm1 = cpu_to_le32(csum_calc);
+				memcpy_to_pmem_nocache(csum_addr1, &csum_nvmm1,
+							NOVA_DATA_CSUM_LEN);
+			}
+			nova_memlock_range(sb, csum_addr0, NOVA_DATA_CSUM_LEN);
+
+			nova_dbg("%s: nova checksum corruption repaired!\n",
+								__func__);
+		}
+
+		/* Getting here, the data stripe and both checksum copies are
+		 * known good. Continue to the next stripe.
+		 */
+		strp_nr    += 1;
+		strp_index += 1;
+		strp_ptr   += strp_size;
+		if (strp_index == (blocksize >> strp_shift)) {
+			blocknr += 1;
+			blockoff += blocksize;
+			strp_index = 0;
+		}
+
+	}
+
+	if (strip != NULL)
+		kfree(strip);
+
+	NOVA_END_TIMING(verify_data_csum_t, verify_time);
+
+	return match;
+}
+
+int nova_update_truncated_block_csum(struct super_block *sb,
+	struct inode *inode, loff_t newsize) {
+
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	unsigned long offset = newsize & (sb->s_blocksize - 1);
+	unsigned long pgoff, length;
+	u64 nvmm;
+	char *nvmm_addr, *strp_addr, *tail_strp = NULL;
+	unsigned int strp_size = NOVA_STRIPE_SIZE;
+	unsigned int strp_shift = NOVA_STRIPE_SHIFT;
+	unsigned int strp_index, strp_offset;
+	unsigned long strps, strp_nr;
+
+	length = sb->s_blocksize - offset;
+	pgoff = newsize >> sb->s_blocksize_bits;
+
+	nvmm = nova_find_nvmm_block(sb, sih, NULL, pgoff);
+	if (nvmm == 0)
+		return -EFAULT;
+
+	nvmm_addr = (char *)nova_get_block(sb, nvmm);
+
+	strp_index = offset >> strp_shift;
+	strp_offset = offset - (strp_index << strp_shift);
+
+	strps = ((strp_offset + length - 1) >> strp_shift) + 1;
+	strp_nr = (nvmm + offset) >> strp_shift;
+	strp_addr = nvmm_addr + (strp_index << strp_shift);
+
+	if (strp_offset > 0) {
+		/* Copy to DRAM to catch MCE. */
+		tail_strp = kzalloc(strp_size, GFP_KERNEL);
+		if (tail_strp == NULL)
+			return -ENOMEM;
+
+		if (memcpy_mcsafe(tail_strp, strp_addr, strp_offset) < 0)
+			return -EIO;
+
+		nova_update_stripe_csum(sb, 1, strp_nr, tail_strp, 0);
+
+		strps--;
+		strp_nr++;
+	}
+
+	if (strps > 0)
+		nova_update_stripe_csum(sb, strps, strp_nr, NULL, 1);
+
+	if (tail_strp != NULL)
+		kfree(tail_strp);
+
+	return 0;
+}
+
diff --git a/fs/nova/mprotect.c b/fs/nova/mprotect.c
new file mode 100644
index 000000000000..4b58786f401e
--- /dev/null
+++ b/fs/nova/mprotect.c
@@ -0,0 +1,604 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Memory protection for the filesystem pages.
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
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/io.h>
+#include "nova.h"
+#include "inode.h"
+
+static inline void wprotect_disable(void)
+{
+	unsigned long cr0_val;
+
+	cr0_val = read_cr0();
+	cr0_val &= (~X86_CR0_WP);
+	write_cr0(cr0_val);
+}
+
+static inline void wprotect_enable(void)
+{
+	unsigned long cr0_val;
+
+	cr0_val = read_cr0();
+	cr0_val |= X86_CR0_WP;
+	write_cr0(cr0_val);
+}
+
+/* FIXME: Assumes that we are always called in the right order.
+ * nova_writeable(vaddr, size, 1);
+ * nova_writeable(vaddr, size, 0);
+ */
+int nova_writeable(void *vaddr, unsigned long size, int rw)
+{
+	static unsigned long flags;
+	timing_t wprotect_time;
+
+	NOVA_START_TIMING(wprotect_t, wprotect_time);
+	if (rw) {
+		local_irq_save(flags);
+		wprotect_disable();
+	} else {
+		wprotect_enable();
+		local_irq_restore(flags);
+	}
+	NOVA_END_TIMING(wprotect_t, wprotect_time);
+	return 0;
+}
+
+int nova_dax_mem_protect(struct super_block *sb, void *vaddr,
+			  unsigned long size, int rw)
+{
+	if (!nova_is_wprotected(sb))
+		return 0;
+	return nova_writeable(vaddr, size, rw);
+}
+
+int nova_get_vma_overlap_range(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct vm_area_struct *vma,
+	unsigned long entry_pgoff, unsigned long entry_pages,
+	unsigned long *start_pgoff, unsigned long *num_pages)
+{
+	unsigned long vma_pgoff;
+	unsigned long vma_pages;
+	unsigned long end_pgoff;
+
+	vma_pgoff = vma->vm_pgoff;
+	vma_pages = (vma->vm_end - vma->vm_start) >> sb->s_blocksize_bits;
+
+	if (vma_pgoff + vma_pages <= entry_pgoff ||
+				entry_pgoff + entry_pages <= vma_pgoff)
+		return 0;
+
+	*start_pgoff = vma_pgoff > entry_pgoff ? vma_pgoff : entry_pgoff;
+	end_pgoff = (vma_pgoff + vma_pages) > (entry_pgoff + entry_pages) ?
+			entry_pgoff + entry_pages : vma_pgoff + vma_pages;
+	*num_pages = end_pgoff - *start_pgoff;
+	return 1;
+}
+
+static int nova_update_dax_mapping(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct vm_area_struct *vma,
+	struct nova_file_write_entry *entry, unsigned long start_pgoff,
+	unsigned long num_pages)
+{
+	struct address_space *mapping = vma->vm_file->f_mapping;
+	void **pentry;
+	unsigned long curr_pgoff;
+	unsigned long blocknr, start_blocknr;
+	unsigned long value, new_value;
+	int i;
+	int ret = 0;
+	timing_t update_time;
+
+	NOVA_START_TIMING(update_mapping_t, update_time);
+
+	start_blocknr = nova_get_blocknr(sb, entry->block, sih->i_blk_type);
+	spin_lock_irq(&mapping->tree_lock);
+	for (i = 0; i < num_pages; i++) {
+		curr_pgoff = start_pgoff + i;
+		blocknr = start_blocknr + i;
+
+		pentry = radix_tree_lookup_slot(&mapping->page_tree,
+						curr_pgoff);
+		if (pentry) {
+			value = (unsigned long)radix_tree_deref_slot(pentry);
+			/* 9 = sector shift (3) + RADIX_DAX_SHIFT (6) */
+			new_value = (blocknr << 9) | (value & 0xff);
+			nova_dbgv("%s: pgoff %lu, entry 0x%lx, new 0x%lx\n",
+						__func__, curr_pgoff,
+						value, new_value);
+			radix_tree_replace_slot(&sih->tree, pentry,
+						(void *)new_value);
+			radix_tree_tag_set(&mapping->page_tree, curr_pgoff,
+						PAGECACHE_TAG_DIRTY);
+		}
+	}
+
+	spin_unlock_irq(&mapping->tree_lock);
+
+	NOVA_END_TIMING(update_mapping_t, update_time);
+	return ret;
+}
+
+static int nova_update_entry_pfn(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct vm_area_struct *vma,
+	struct nova_file_write_entry *entry, unsigned long start_pgoff,
+	unsigned long num_pages)
+{
+	unsigned long newflags;
+	unsigned long addr;
+	unsigned long size;
+	unsigned long pfn;
+	pgprot_t new_prot;
+	int ret;
+	timing_t update_time;
+
+	NOVA_START_TIMING(update_pfn_t, update_time);
+
+	addr = vma->vm_start + ((start_pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+	pfn = nova_get_pfn(sb, entry->block) + start_pgoff - entry->pgoff;
+	size = num_pages << PAGE_SHIFT;
+
+	nova_dbgv("%s: addr 0x%lx, size 0x%lx\n", __func__,
+			addr, size);
+
+	newflags = vma->vm_flags | VM_WRITE;
+	new_prot = vm_get_page_prot(newflags);
+
+	ret = remap_pfn_range(vma, addr, pfn, size, new_prot);
+
+	NOVA_END_TIMING(update_pfn_t, update_time);
+	return ret;
+}
+
+static int nova_dax_mmap_update_mapping(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct vm_area_struct *vma,
+	struct nova_file_write_entry *entry_data)
+{
+	unsigned long start_pgoff, num_pages = 0;
+	int ret;
+
+	ret = nova_get_vma_overlap_range(sb, sih, vma, entry_data->pgoff,
+						entry_data->num_pages,
+						&start_pgoff, &num_pages);
+	if (ret == 0)
+		return ret;
+
+
+	NOVA_STATS_ADD(mapping_updated_pages, num_pages);
+
+	ret = nova_update_dax_mapping(sb, sih, vma, entry_data,
+						start_pgoff, num_pages);
+	if (ret) {
+		nova_err(sb, "update DAX mapping return %d\n", ret);
+		return ret;
+	}
+
+	ret = nova_update_entry_pfn(sb, sih, vma, entry_data,
+						start_pgoff, num_pages);
+	if (ret)
+		nova_err(sb, "update_pfn return %d\n", ret);
+
+
+	return ret;
+}
+
+static int nova_dax_cow_mmap_handler(struct super_block *sb,
+	struct vm_area_struct *vma, struct nova_inode_info_header *sih,
+	u64 begin_tail)
+{
+	struct nova_file_write_entry *entry;
+	struct nova_file_write_entry *entryc, entry_copy;
+	u64 curr_p = begin_tail;
+	size_t entry_size = sizeof(struct nova_file_write_entry);
+	int ret = 0;
+	timing_t update_time;
+
+	NOVA_START_TIMING(mmap_handler_t, update_time);
+	entryc = (metadata_csum == 0) ? entry : &entry_copy;
+	while (curr_p && curr_p != sih->log_tail) {
+		if (is_last_entry(curr_p, entry_size))
+			curr_p = next_log_page(sb, curr_p);
+
+		if (curr_p == 0) {
+			nova_err(sb, "%s: File inode %lu log is NULL!\n",
+				__func__, sih->ino);
+			ret = -EINVAL;
+			break;
+		}
+
+		entry = (struct nova_file_write_entry *)
+					nova_get_block(sb, curr_p);
+
+		if (metadata_csum == 0)
+			entryc = entry;
+		else if (!nova_verify_entry_csum(sb, entry, entryc)) {
+			ret = -EIO;
+			curr_p += entry_size;
+			continue;
+		}
+
+		if (nova_get_entry_type(entryc) != FILE_WRITE) {
+			/* for debug information, still use nvmm entry */
+			nova_dbg("%s: entry type is not write? %d\n",
+				__func__, nova_get_entry_type(entry));
+			curr_p += entry_size;
+			continue;
+		}
+
+		ret = nova_dax_mmap_update_mapping(sb, sih, vma, entryc);
+		if (ret)
+			break;
+
+		curr_p += entry_size;
+	}
+
+	NOVA_END_TIMING(mmap_handler_t, update_time);
+	return ret;
+}
+
+static int nova_get_dax_cow_range(struct super_block *sb,
+	struct vm_area_struct *vma, unsigned long address,
+	unsigned long *start_blk, int *num_blocks)
+{
+	int base = 1;
+	unsigned long vma_blocks;
+	unsigned long pgoff;
+	unsigned long start_pgoff;
+
+	vma_blocks = (vma->vm_end - vma->vm_start) >> sb->s_blocksize_bits;
+
+	/* Read ahead, avoid sequential page faults */
+	if (vma_blocks >= 4096)
+		base = 4096;
+
+	pgoff = (address - vma->vm_start) >> sb->s_blocksize_bits;
+	start_pgoff = pgoff & ~(base - 1);
+	*start_blk = vma->vm_pgoff + start_pgoff;
+	*num_blocks = (base > vma_blocks - start_pgoff) ?
+			vma_blocks - start_pgoff : base;
+	nova_dbgv("%s: start block %lu, %d blocks\n",
+			__func__, *start_blk, *num_blocks);
+	return 0;
+}
+
+int nova_mmap_to_new_blocks(struct vm_area_struct *vma,
+	unsigned long address)
+{
+	struct address_space *mapping = vma->vm_file->f_mapping;
+	struct inode *inode = mapping->host;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct super_block *sb = inode->i_sb;
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_inode *pi;
+	struct nova_file_write_entry *entry;
+	struct nova_file_write_entry *entryc, entry_copy;
+	struct nova_file_write_entry entry_data;
+	struct nova_inode_update update;
+	unsigned long start_blk, end_blk;
+	unsigned long entry_pgoff;
+	unsigned long from_blocknr = 0;
+	unsigned long blocknr = 0;
+	unsigned long avail_blocks;
+	unsigned long copy_blocks;
+	int num_blocks = 0;
+	u64 from_blockoff, to_blockoff;
+	size_t copied;
+	int allocated = 0;
+	void *from_kmem;
+	void *to_kmem;
+	size_t bytes;
+	timing_t memcpy_time;
+	u64 begin_tail = 0;
+	u64 epoch_id;
+	u64 entry_size;
+	u32 time;
+	timing_t mmap_cow_time;
+	int ret = 0;
+
+	NOVA_START_TIMING(mmap_cow_t, mmap_cow_time);
+
+	nova_get_dax_cow_range(sb, vma, address, &start_blk, &num_blocks);
+
+	end_blk = start_blk + num_blocks;
+	if (start_blk >= end_blk) {
+		NOVA_END_TIMING(mmap_cow_t, mmap_cow_time);
+		return 0;
+	}
+
+	if (sbi->snapshot_taking) {
+		/* Block CoW mmap until snapshot taken completes */
+		NOVA_STATS_ADD(dax_cow_during_snapshot, 1);
+		wait_event_interruptible(sbi->snapshot_mmap_wait,
+					sbi->snapshot_taking == 0);
+	}
+
+	inode_lock(inode);
+
+	pi = nova_get_inode(sb, inode);
+
+	nova_dbgv("%s: inode %lu, start pgoff %lu, end pgoff %lu\n",
+			__func__, inode->i_ino, start_blk, end_blk);
+
+	time = current_time(inode).tv_sec;
+
+	epoch_id = nova_get_epoch_id(sb);
+	update.tail = pi->log_tail;
+	update.alter_tail = pi->alter_log_tail;
+
+	entryc = (metadata_csum == 0) ? entry : &entry_copy;
+
+	while (start_blk < end_blk) {
+		entry = nova_get_write_entry(sb, sih, start_blk);
+		if (!entry) {
+			nova_dbgv("%s: Found hole: pgoff %lu\n",
+					__func__, start_blk);
+
+			/* Jump the hole */
+			entry = nova_find_next_entry(sb, sih, start_blk);
+			if (!entry)
+				break;
+
+			if (metadata_csum == 0)
+				entryc = entry;
+			else if (!nova_verify_entry_csum(sb, entry, entryc))
+				break;
+
+			start_blk = entryc->pgoff;
+			if (start_blk >= end_blk)
+				break;
+		} else {
+			if (metadata_csum == 0)
+				entryc = entry;
+			else if (!nova_verify_entry_csum(sb, entry, entryc))
+				break;
+		}
+
+		if (entryc->epoch_id == epoch_id) {
+			/* Someone has done it for us. */
+			break;
+		}
+
+		from_blocknr = get_nvmm(sb, sih, entryc, start_blk);
+		from_blockoff = nova_get_block_off(sb, from_blocknr,
+						pi->i_blk_type);
+		from_kmem = nova_get_block(sb, from_blockoff);
+
+		if (entryc->reassigned == 0)
+			avail_blocks = entryc->num_pages -
+					(start_blk - entryc->pgoff);
+		else
+			avail_blocks = 1;
+
+		if (avail_blocks > end_blk - start_blk)
+			avail_blocks = end_blk - start_blk;
+
+		allocated = nova_new_data_blocks(sb, sih, &blocknr, start_blk,
+					 avail_blocks, ALLOC_NO_INIT, ANY_CPU,
+					 ALLOC_FROM_HEAD);
+
+		nova_dbgv("%s: alloc %d blocks @ %lu\n", __func__,
+						allocated, blocknr);
+
+		if (allocated <= 0) {
+			nova_dbg("%s alloc blocks failed!, %d\n",
+						__func__, allocated);
+			ret = allocated;
+			goto out;
+		}
+
+		to_blockoff = nova_get_block_off(sb, blocknr,
+						pi->i_blk_type);
+		to_kmem = nova_get_block(sb, to_blockoff);
+		entry_pgoff = start_blk;
+
+		copy_blocks = allocated;
+
+		bytes = sb->s_blocksize * copy_blocks;
+
+		/* Now copy from user buf */
+		NOVA_START_TIMING(memcpy_w_wb_t, memcpy_time);
+		nova_memunlock_range(sb, to_kmem, bytes);
+		copied = bytes - memcpy_to_pmem_nocache(to_kmem, from_kmem,
+							bytes);
+		nova_memlock_range(sb, to_kmem, bytes);
+		NOVA_END_TIMING(memcpy_w_wb_t, memcpy_time);
+
+		if (copied == bytes) {
+			start_blk += copy_blocks;
+		} else {
+			nova_dbg("%s ERROR!: bytes %lu, copied %lu\n",
+				__func__, bytes, copied);
+			ret = -EFAULT;
+			goto out;
+		}
+
+		entry_size = cpu_to_le64(inode->i_size);
+
+		nova_init_file_write_entry(sb, sih, &entry_data,
+					epoch_id, entry_pgoff, copy_blocks,
+					blocknr, time, entry_size);
+
+		ret = nova_append_file_write_entry(sb, pi, inode,
+					&entry_data, &update);
+		if (ret) {
+			nova_dbg("%s: append inode entry failed\n",
+					__func__);
+			ret = -ENOSPC;
+			goto out;
+		}
+
+		if (begin_tail == 0)
+			begin_tail = update.curr_entry;
+	}
+
+	if (begin_tail == 0)
+		goto out;
+
+	nova_memunlock_inode(sb, pi);
+	nova_update_inode(sb, inode, pi, &update, 1);
+	nova_memlock_inode(sb, pi);
+
+	/* Update file tree */
+	ret = nova_reassign_file_tree(sb, sih, begin_tail);
+	if (ret)
+		goto out;
+
+
+	/* Update pfn and prot */
+	ret = nova_dax_cow_mmap_handler(sb, vma, sih, begin_tail);
+	if (ret)
+		goto out;
+
+
+	sih->trans_id++;
+
+out:
+	if (ret < 0)
+		nova_cleanup_incomplete_write(sb, sih, blocknr, allocated,
+						begin_tail, update.tail);
+
+	inode_unlock(inode);
+	NOVA_END_TIMING(mmap_cow_t, mmap_cow_time);
+	return ret;
+}
+
+static int nova_set_vma_read(struct vm_area_struct *vma)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long oldflags = vma->vm_flags;
+	unsigned long newflags;
+	pgprot_t new_page_prot;
+
+	down_write(&mm->mmap_sem);
+
+	newflags = oldflags & (~VM_WRITE);
+	if (oldflags == newflags)
+		goto out;
+
+	nova_dbgv("Set vma %p read, start 0x%lx, end 0x%lx\n",
+				vma, vma->vm_start,
+				vma->vm_end);
+
+	new_page_prot = vm_get_page_prot(newflags);
+	change_protection(vma, vma->vm_start, vma->vm_end,
+				new_page_prot, 0, 0);
+	vma->original_write = 1;
+
+out:
+	up_write(&mm->mmap_sem);
+
+	return 0;
+}
+
+static inline bool pgoff_in_vma(struct vm_area_struct *vma,
+	unsigned long pgoff)
+{
+	unsigned long num_pages;
+
+	num_pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+
+	if (pgoff >= vma->vm_pgoff && pgoff < vma->vm_pgoff + num_pages)
+		return true;
+
+	return false;
+}
+
+bool nova_find_pgoff_in_vma(struct inode *inode, unsigned long pgoff)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct vma_item *item;
+	struct rb_node *temp;
+	bool ret = false;
+
+	if (sih->num_vmas == 0)
+		return ret;
+
+	temp = rb_first(&sih->vma_tree);
+	while (temp) {
+		item = container_of(temp, struct vma_item, node);
+		temp = rb_next(temp);
+		if (pgoff_in_vma(item->vma, pgoff)) {
+			ret = true;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int nova_set_sih_vmas_readonly(struct nova_inode_info_header *sih)
+{
+	struct vma_item *item;
+	struct rb_node *temp;
+	timing_t set_read_time;
+
+	NOVA_START_TIMING(set_vma_read_t, set_read_time);
+
+	temp = rb_first(&sih->vma_tree);
+	while (temp) {
+		item = container_of(temp, struct vma_item, node);
+		temp = rb_next(temp);
+		nova_set_vma_read(item->vma);
+	}
+
+	NOVA_END_TIMING(set_vma_read_t, set_read_time);
+	return 0;
+}
+
+int nova_set_vmas_readonly(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_inode_info_header *sih;
+
+	nova_dbgv("%s\n", __func__);
+	mutex_lock(&sbi->vma_mutex);
+	list_for_each_entry(sih, &sbi->mmap_sih_list, list)
+		nova_set_sih_vmas_readonly(sih);
+	mutex_unlock(&sbi->vma_mutex);
+
+	return 0;
+}
+
+#if 0
+int nova_destroy_vma_tree(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct vma_item *item;
+	struct rb_node *temp;
+
+	nova_dbgv("%s\n", __func__);
+	mutex_lock(&sbi->vma_mutex);
+	temp = rb_first(&sbi->vma_tree);
+	while (temp) {
+		item = container_of(temp, struct vma_item, node);
+		temp = rb_next(temp);
+		rb_erase(&item->node, &sbi->vma_tree);
+		kfree(item);
+	}
+	mutex_unlock(&sbi->vma_mutex);
+
+	return 0;
+}
+#endif
diff --git a/fs/nova/mprotect.h b/fs/nova/mprotect.h
new file mode 100644
index 000000000000..e28243caae52
--- /dev/null
+++ b/fs/nova/mprotect.h
@@ -0,0 +1,190 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Memory protection definitions for the NOVA filesystem.
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
+#ifndef __WPROTECT_H
+#define __WPROTECT_H
+
+#include <linux/fs.h>
+#include "nova_def.h"
+#include "super.h"
+
+extern void nova_error_mng(struct super_block *sb, const char *fmt, ...);
+
+static inline int nova_range_check(struct super_block *sb, void *p,
+					 unsigned long len)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	if (p < sbi->virt_addr ||
+			p + len > sbi->virt_addr + sbi->initsize) {
+		nova_err(sb, "access pmem out of range: pmem range %p - %p, access range %p - %p\n",
+				sbi->virt_addr,
+				sbi->virt_addr + sbi->initsize,
+				p, p + len);
+		dump_stack();
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+extern int nova_writeable(void *vaddr, unsigned long size, int rw);
+
+static inline int nova_is_protected(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = (struct nova_sb_info *)sb->s_fs_info;
+
+	if (wprotect)
+		return wprotect;
+
+	return sbi->s_mount_opt & NOVA_MOUNT_PROTECT;
+}
+
+static inline int nova_is_wprotected(struct super_block *sb)
+{
+	return nova_is_protected(sb);
+}
+
+static inline void
+__nova_memunlock_range(void *p, unsigned long len)
+{
+	/*
+	 * NOTE: Ideally we should lock all the kernel to be memory safe
+	 * and avoid to write in the protected memory,
+	 * obviously it's not possible, so we only serialize
+	 * the operations at fs level. We can't disable the interrupts
+	 * because we could have a deadlock in this path.
+	 */
+	nova_writeable(p, len, 1);
+}
+
+static inline void
+__nova_memlock_range(void *p, unsigned long len)
+{
+	nova_writeable(p, len, 0);
+}
+
+static inline void nova_memunlock_range(struct super_block *sb, void *p,
+					 unsigned long len)
+{
+	if (nova_range_check(sb, p, len))
+		return;
+
+	if (nova_is_protected(sb))
+		__nova_memunlock_range(p, len);
+}
+
+static inline void nova_memlock_range(struct super_block *sb, void *p,
+				       unsigned long len)
+{
+	if (nova_is_protected(sb))
+		__nova_memlock_range(p, len);
+}
+
+static inline void nova_memunlock_super(struct super_block *sb)
+{
+	struct nova_super_block *ps = nova_get_super(sb);
+
+	if (nova_is_protected(sb))
+		__nova_memunlock_range(ps, NOVA_SB_SIZE);
+}
+
+static inline void nova_memlock_super(struct super_block *sb)
+{
+	struct nova_super_block *ps = nova_get_super(sb);
+
+	if (nova_is_protected(sb))
+		__nova_memlock_range(ps, NOVA_SB_SIZE);
+}
+
+static inline void nova_memunlock_reserved(struct super_block *sb,
+					 struct nova_super_block *ps)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	if (nova_is_protected(sb))
+		__nova_memunlock_range(ps,
+			sbi->head_reserved_blocks * NOVA_DEF_BLOCK_SIZE_4K);
+}
+
+static inline void nova_memlock_reserved(struct super_block *sb,
+				       struct nova_super_block *ps)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	if (nova_is_protected(sb))
+		__nova_memlock_range(ps,
+			sbi->head_reserved_blocks * NOVA_DEF_BLOCK_SIZE_4K);
+}
+
+static inline void nova_memunlock_journal(struct super_block *sb)
+{
+	void *addr = nova_get_block(sb, NOVA_DEF_BLOCK_SIZE_4K * JOURNAL_START);
+
+	if (nova_range_check(sb, addr, NOVA_DEF_BLOCK_SIZE_4K))
+		return;
+
+	if (nova_is_protected(sb))
+		__nova_memunlock_range(addr, NOVA_DEF_BLOCK_SIZE_4K);
+}
+
+static inline void nova_memlock_journal(struct super_block *sb)
+{
+	void *addr = nova_get_block(sb, NOVA_DEF_BLOCK_SIZE_4K * JOURNAL_START);
+
+	if (nova_is_protected(sb))
+		__nova_memlock_range(addr, NOVA_DEF_BLOCK_SIZE_4K);
+}
+
+static inline void nova_memunlock_inode(struct super_block *sb,
+					 struct nova_inode *pi)
+{
+	if (nova_range_check(sb, pi, NOVA_INODE_SIZE))
+		return;
+
+	if (nova_is_protected(sb))
+		__nova_memunlock_range(pi, NOVA_INODE_SIZE);
+}
+
+static inline void nova_memlock_inode(struct super_block *sb,
+				       struct nova_inode *pi)
+{
+	/* nova_sync_inode(pi); */
+	if (nova_is_protected(sb))
+		__nova_memlock_range(pi, NOVA_INODE_SIZE);
+}
+
+static inline void nova_memunlock_block(struct super_block *sb, void *bp)
+{
+	if (nova_range_check(sb, bp, sb->s_blocksize))
+		return;
+
+	if (nova_is_protected(sb))
+		__nova_memunlock_range(bp, sb->s_blocksize);
+}
+
+static inline void nova_memlock_block(struct super_block *sb, void *bp)
+{
+	if (nova_is_protected(sb))
+		__nova_memlock_range(bp, sb->s_blocksize);
+}
+
+
+#endif
diff --git a/fs/nova/parity.c b/fs/nova/parity.c
new file mode 100644
index 000000000000..1f2f8b4d6c0e
--- /dev/null
+++ b/fs/nova/parity.c
@@ -0,0 +1,411 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Parity related methods.
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
+
+#include "nova.h"
+
+static int nova_calculate_block_parity(struct super_block *sb, u8 *parity,
+	u8 *block)
+{
+	unsigned int strp, num_strps, i, j;
+	size_t strp_size = NOVA_STRIPE_SIZE;
+	unsigned int strp_shift = NOVA_STRIPE_SHIFT;
+	u64 xor;
+
+	num_strps = sb->s_blocksize >> strp_shift;
+	if (static_cpu_has(X86_FEATURE_XMM2)) { // sse2 128b
+		for (i = 0; i < strp_size; i += 16) {
+			asm volatile("movdqa %0, %%xmm0" : : "m" (block[i]));
+			for (strp = 1; strp < num_strps; strp++) {
+				j = (strp << strp_shift) + i;
+				asm volatile(
+					"movdqa     %0, %%xmm1\n"
+					"pxor   %%xmm1, %%xmm0\n"
+					: : "m" (block[j])
+				);
+			}
+			asm volatile("movntdq %%xmm0, %0" : "=m" (parity[i]));
+		}
+	} else { // common 64b
+		for (i = 0; i < strp_size; i += 8) {
+			xor = *((u64 *) &block[i]);
+			for (strp = 1; strp < num_strps; strp++) {
+				j = (strp << strp_shift) + i;
+				xor ^= *((u64 *) &block[j]);
+			}
+			*((u64 *) &parity[i]) = xor;
+		}
+	}
+
+	return 0;
+}
+
+/* Compute parity for a whole data block and write the parity stripe to nvmm
+ *
+ * The block buffer to compute checksums should reside in dram (more trusted),
+ * not in nvmm (less trusted).
+ *
+ * block:   block buffer with user data and possibly partial head-tail block
+ *          - should be in kernel memory (dram) to avoid page faults
+ * blocknr: destination nvmm block number where the block is written to
+ *          - used to derive the parity stripe address
+
+ * If the modified content is less than a stripe size (small writes), it's
+ * possible to re-compute the parity only using the difference of the modified
+ * stripe, without re-computing for the whole block.
+
+static int nova_update_block_parity(struct super_block *sb,
+	struct nova_inode_info_header *sih, void *block, unsigned long blocknr,
+	size_t offset, size_t bytes, int zero)
+
+ */
+static int nova_update_block_parity(struct super_block *sb, u8 *block,
+	unsigned long blocknr, int zero)
+{
+	size_t strp_size = NOVA_STRIPE_SIZE;
+	void *parity, *nvmmptr;
+	int ret = 0;
+	timing_t block_parity_time;
+
+	NOVA_START_TIMING(block_parity_t, block_parity_time);
+
+	parity = kmalloc(strp_size, GFP_KERNEL);
+	if (parity == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (block == NULL) {
+		nova_dbg("%s: block pointer error\n", __func__);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (unlikely(zero))
+		memset(parity, 0, strp_size);
+	else
+		nova_calculate_block_parity(sb, parity, block);
+
+	nvmmptr = nova_get_parity_addr(sb, blocknr);
+
+	nova_memunlock_range(sb, nvmmptr, strp_size);
+	memcpy_to_pmem_nocache(nvmmptr, parity, strp_size);
+	nova_memlock_range(sb, nvmmptr, strp_size);
+
+	// TODO: The parity stripe is better checksummed for higher reliability.
+out:
+	if (parity != NULL)
+		kfree(parity);
+
+	NOVA_END_TIMING(block_parity_t, block_parity_time);
+
+	return 0;
+}
+
+int nova_update_pgoff_parity(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_entry *entry,
+	unsigned long pgoff, int zero)
+{
+	unsigned long blocknr;
+	void *dax_mem = NULL;
+	u64 blockoff;
+
+	blockoff = nova_find_nvmm_block(sb, sih, entry, pgoff);
+	/* Truncated? */
+	if (blockoff == 0)
+		return 0;
+
+	dax_mem = nova_get_block(sb, blockoff);
+
+	blocknr = nova_get_blocknr(sb, blockoff, sih->i_blk_type);
+	nova_update_block_parity(sb, dax_mem, blocknr, zero);
+
+	return 0;
+}
+
+/* Update block checksums and/or parity.
+ *
+ * Since this part of computing is along the critical path, unroll by 8 to gain
+ * performance if possible. This unrolling applies to stripe width of 8 and
+ * whole block writes.
+ */
+#define CSUM0 NOVA_INIT_CSUM
+int nova_update_block_csum_parity(struct super_block *sb,
+	struct nova_inode_info_header *sih, u8 *block, unsigned long blocknr,
+	size_t offset, size_t bytes)
+{
+	unsigned int i, strp_offset, num_strps;
+	size_t csum_size = NOVA_DATA_CSUM_LEN;
+	size_t strp_size = NOVA_STRIPE_SIZE;
+	unsigned int strp_shift = NOVA_STRIPE_SHIFT;
+	unsigned long strp_nr, blockoff, blocksize = sb->s_blocksize;
+	void *nvmmptr, *nvmmptr1;
+	u32 crc[8];
+	u64 qwd[8], *parity = NULL;
+	u64 acc[8] = {CSUM0, CSUM0, CSUM0, CSUM0, CSUM0, CSUM0, CSUM0, CSUM0};
+	bool unroll_csum = false, unroll_parity = false;
+	int ret = 0;
+	timing_t block_csum_parity_time;
+
+	NOVA_STATS_ADD(block_csum_parity, 1);
+
+	blockoff = nova_get_block_off(sb, blocknr, sih->i_blk_type);
+	strp_nr = blockoff >> strp_shift;
+
+	strp_offset = offset & (strp_size - 1);
+	num_strps = ((strp_offset + bytes - 1) >> strp_shift) + 1;
+
+	unroll_parity = (blocksize / strp_size == 8) && (num_strps == 8);
+	unroll_csum = unroll_parity && static_cpu_has(X86_FEATURE_XMM4_2);
+
+	/* unrolled-by-8 implementation */
+	if (unroll_csum || unroll_parity) {
+		NOVA_START_TIMING(block_csum_parity_t, block_csum_parity_time);
+		if (data_parity > 0) {
+			parity = kmalloc(strp_size, GFP_KERNEL);
+			if (parity == NULL) {
+				nova_err(sb, "%s: buffer allocation error\n",
+								__func__);
+				ret = -ENOMEM;
+				NOVA_END_TIMING(block_csum_parity_t,
+						block_csum_parity_time);
+				goto out;
+			}
+		}
+		for (i = 0; i < strp_size / 8; i++) {
+			qwd[0] = *((u64 *) (block));
+			qwd[1] = *((u64 *) (block + 1 * strp_size));
+			qwd[2] = *((u64 *) (block + 2 * strp_size));
+			qwd[3] = *((u64 *) (block + 3 * strp_size));
+			qwd[4] = *((u64 *) (block + 4 * strp_size));
+			qwd[5] = *((u64 *) (block + 5 * strp_size));
+			qwd[6] = *((u64 *) (block + 6 * strp_size));
+			qwd[7] = *((u64 *) (block + 7 * strp_size));
+
+			if (data_csum > 0 && unroll_csum) {
+				nova_crc32c_qword(qwd[0], acc[0]);
+				nova_crc32c_qword(qwd[1], acc[1]);
+				nova_crc32c_qword(qwd[2], acc[2]);
+				nova_crc32c_qword(qwd[3], acc[3]);
+				nova_crc32c_qword(qwd[4], acc[4]);
+				nova_crc32c_qword(qwd[5], acc[5]);
+				nova_crc32c_qword(qwd[6], acc[6]);
+				nova_crc32c_qword(qwd[7], acc[7]);
+			}
+
+			if (data_parity > 0) {
+				parity[i] = qwd[0] ^ qwd[1] ^ qwd[2] ^ qwd[3] ^
+					    qwd[4] ^ qwd[5] ^ qwd[6] ^ qwd[7];
+			}
+
+			block += 8;
+		}
+		if (data_csum > 0 && unroll_csum) {
+			crc[0] = cpu_to_le32((u32) acc[0]);
+			crc[1] = cpu_to_le32((u32) acc[1]);
+			crc[2] = cpu_to_le32((u32) acc[2]);
+			crc[3] = cpu_to_le32((u32) acc[3]);
+			crc[4] = cpu_to_le32((u32) acc[4]);
+			crc[5] = cpu_to_le32((u32) acc[5]);
+			crc[6] = cpu_to_le32((u32) acc[6]);
+			crc[7] = cpu_to_le32((u32) acc[7]);
+
+			nvmmptr = nova_get_data_csum_addr(sb, strp_nr, 0);
+			nvmmptr1 = nova_get_data_csum_addr(sb, strp_nr, 1);
+			nova_memunlock_range(sb, nvmmptr, csum_size * 8);
+			memcpy_to_pmem_nocache(nvmmptr, crc, csum_size * 8);
+			memcpy_to_pmem_nocache(nvmmptr1, crc, csum_size * 8);
+			nova_memlock_range(sb, nvmmptr, csum_size * 8);
+		}
+
+		if (data_parity > 0) {
+			nvmmptr = nova_get_parity_addr(sb, blocknr);
+			nova_memunlock_range(sb, nvmmptr, strp_size);
+			memcpy_to_pmem_nocache(nvmmptr, parity, strp_size);
+			nova_memlock_range(sb, nvmmptr, strp_size);
+		}
+
+		if (parity != NULL)
+			kfree(parity);
+		NOVA_END_TIMING(block_csum_parity_t, block_csum_parity_time);
+	}
+
+	if (data_csum > 0 && !unroll_csum)
+		nova_update_block_csum(sb, sih, block, blocknr,
+					offset, bytes, 0);
+	if (data_parity > 0 && !unroll_parity)
+		nova_update_block_parity(sb, block, blocknr, 0);
+
+out:
+	return 0;
+}
+
+/* Restore a stripe of data.
+ *
+ * When this function is called, the two corresponding checksum copies are also
+ * given. After recovery the restored data stripe is checksum-verified using the
+ * given checksums. If any one matches, data recovery is considered successful
+ * and the restored stripe is written to nvmm to repair the corrupted data.
+ *
+ * If recovery succeeded, the known good checksum is returned by csum_good, and
+ * the caller will also check if any checksum restoration is necessary.
+ */
+int nova_restore_data(struct super_block *sb, unsigned long blocknr,
+	unsigned int badstrip_id, void *badstrip, int nvmmerr, u32 csum0,
+	u32 csum1, u32 *csum_good)
+{
+	unsigned int i, num_strps;
+	size_t strp_size = NOVA_STRIPE_SIZE;
+	unsigned int strp_shift = NOVA_STRIPE_SHIFT;
+	size_t blockoff, offset;
+	u8 *blockptr, *stripptr, *block, *parity, *strip;
+	u32 csum_calc;
+	bool success = false;
+	timing_t restore_time;
+	int ret = 0;
+
+	NOVA_START_TIMING(restore_data_t, restore_time);
+	blockoff = nova_get_block_off(sb, blocknr, NOVA_BLOCK_TYPE_4K);
+	blockptr = nova_get_block(sb, blockoff);
+	stripptr = blockptr + (badstrip_id << strp_shift);
+
+	block = kmalloc(sb->s_blocksize, GFP_KERNEL);
+	strip = kmalloc(strp_size, GFP_KERNEL);
+	if (block == NULL || strip == NULL) {
+		nova_err(sb, "%s: buffer allocation error\n", __func__);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	parity = nova_get_parity_addr(sb, blocknr);
+	if (parity == NULL) {
+		nova_err(sb, "%s: parity address error\n", __func__);
+		ret = -EIO;
+		goto out;
+	}
+
+	num_strps = sb->s_blocksize >> strp_shift;
+	for (i = 0; i < num_strps; i++) {
+		offset = i << strp_shift;
+		if (i == badstrip_id)
+			/* parity strip has media errors */
+			ret = memcpy_mcsafe(block + offset,
+						parity, strp_size);
+		else
+			/* another data strip has media errors */
+			ret = memcpy_mcsafe(block + offset,
+						blockptr + offset, strp_size);
+		if (ret < 0) {
+			/* media error happens during recovery */
+			nova_err(sb, "%s: unrecoverable media error detected\n",
+					__func__);
+			goto out;
+		}
+	}
+
+	nova_calculate_block_parity(sb, strip, block);
+	for (i = 0; i < strp_size; i++) {
+		/* i indicates the amount of good bytes in badstrip.
+		 * if corruption is contained within one strip, the i = 0 pass
+		 * can restore the strip; otherwise we need to test every i to
+		 * check if there is a unaligned but recoverable corruption,
+		 * i.e. a scribble corrupting two adjacent strips but the
+		 * scribble size is no larger than the strip size.
+		 */
+		memcpy(strip, badstrip, i);
+
+		csum_calc = nova_crc32c(NOVA_INIT_CSUM, strip, strp_size);
+		if (csum_calc == csum0 || csum_calc == csum1) {
+			success = true;
+			break;
+		}
+
+		/* media error, no good bytes in badstrip */
+		if (nvmmerr)
+			break;
+
+		/* corruption happens to the last strip must be contained within
+		 * the strip; if the corruption goes beyond the block boundary,
+		 * that's not the concern of this recovery call.
+		 */
+		if (badstrip_id == num_strps - 1)
+			break;
+	}
+
+	if (success) {
+		/* recovery success, repair the bad nvmm data */
+		nova_memunlock_range(sb, stripptr, strp_size);
+		memcpy_to_pmem_nocache(stripptr, strip, strp_size);
+		nova_memlock_range(sb, stripptr, strp_size);
+
+		/* return the good checksum */
+		*csum_good = csum_calc;
+	} else {
+		/* unrecoverable data corruption */
+		ret = -EIO;
+	}
+
+out:
+	if (block != NULL)
+		kfree(block);
+	if (strip != NULL)
+		kfree(strip);
+
+	NOVA_END_TIMING(restore_data_t, restore_time);
+	return ret;
+}
+
+int nova_update_truncated_block_parity(struct super_block *sb,
+	struct inode *inode, loff_t newsize)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	unsigned long pgoff, blocknr;
+	unsigned long blocksize = sb->s_blocksize;
+	u64 nvmm;
+	char *nvmm_addr, *block;
+	u8 btype = sih->i_blk_type;
+	int ret = 0;
+
+	pgoff = newsize >> sb->s_blocksize_bits;
+
+	nvmm = nova_find_nvmm_block(sb, sih, NULL, pgoff);
+	if (nvmm == 0)
+		return -EFAULT;
+
+	nvmm_addr = (char *)nova_get_block(sb, nvmm);
+
+	blocknr = nova_get_blocknr(sb, nvmm, btype);
+
+	/* Copy to DRAM to catch MCE. */
+	block = kmalloc(blocksize, GFP_KERNEL);
+	if (block == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (memcpy_mcsafe(block, nvmm_addr, blocksize) < 0) {
+		ret = -EIO;
+		goto out;
+	}
+
+	nova_update_block_parity(sb, block, blocknr, 0);
+out:
+	if (block != NULL)
+		kfree(block);
+	return ret;
+}
+

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
