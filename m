Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x242.google.com (mail-pf0-x242.google.com
 [IPv6:2607:f8b0:400e:c00::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5FCC122646306
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:16 -0800 (PST)
Received: by mail-pf0-x242.google.com with SMTP id h11so2617868pfn.4
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:35 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 65/83] File operation: read.
Date: Sat, 10 Mar 2018 10:18:46 -0800
Message-Id: <1520705944-6723-66-git-send-email-jix024@eng.ucsd.edu>
In-Reply-To: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: coughlan@redhat.com, miklos@szeredi.hu, Andiry Xu <jix024@cs.ucsd.edu>, david@fromorbit.com, jack@suse.com, swanson@cs.ucsd.edu, swhiteho@redhat.com, andiry.xu@gmail.com
List-ID: <linux-nvdimm@lists.01.org>

From: Andiry Xu <jix024@cs.ucsd.edu>

NOVA is a DAX file system and does not use page cache.
For read, NOVA looks up the file write entry by searching the radix tree,
and copies data from pmem pages to user buffer directly.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/file.c | 144 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 144 insertions(+)

diff --git a/fs/nova/file.c b/fs/nova/file.c
index f60fdf3..842da45 100644
--- a/fs/nova/file.c
+++ b/fs/nova/file.c
@@ -113,9 +113,153 @@ static int nova_open(struct inode *inode, struct file *filp)
 	return generic_file_open(inode, filp);
 }
 
+static ssize_t
+do_dax_mapping_read(struct file *filp, char __user *buf,
+	size_t len, loff_t *ppos)
+{
+	struct inode *inode = filp->f_mapping->host;
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_file_write_entry *entry;
+	pgoff_t index, end_index;
+	unsigned long offset;
+	loff_t isize, pos;
+	size_t copied = 0, error = 0;
+	timing_t memcpy_time;
+
+	pos = *ppos;
+	index = pos >> PAGE_SHIFT;
+	offset = pos & ~PAGE_MASK;
+
+	if (!access_ok(VERIFY_WRITE, buf, len)) {
+		error = -EFAULT;
+		goto out;
+	}
+
+	isize = i_size_read(inode);
+	if (!isize)
+		goto out;
+
+	nova_dbgv("%s: inode %lu, offset %lld, count %lu, size %lld\n",
+		__func__, inode->i_ino,	pos, len, isize);
+
+	if (len > isize - pos)
+		len = isize - pos;
+
+	if (len <= 0)
+		goto out;
+
+	end_index = (isize - 1) >> PAGE_SHIFT;
+	do {
+		unsigned long nr, left;
+		unsigned long nvmm;
+		void *dax_mem = NULL;
+		int zero = 0;
+
+		/* nr is the maximum number of bytes to copy from this page */
+		if (index >= end_index) {
+			if (index > end_index)
+				goto out;
+			nr = ((isize - 1) & ~PAGE_MASK) + 1;
+			if (nr <= offset)
+				goto out;
+		}
+
+		entry = nova_get_write_entry(sb, sih, index);
+		if (unlikely(entry == NULL)) {
+			nova_dbgv("Required extent not found: pgoff %lu, inode size %lld\n",
+				index, isize);
+			nr = PAGE_SIZE;
+			zero = 1;
+			goto memcpy;
+		}
+
+		/* Find contiguous blocks */
+		if (index < entry->pgoff ||
+			index - entry->pgoff >= entry->num_pages) {
+			nova_err(sb, "%s ERROR: %lu, entry pgoff %llu, num %u, blocknr %llu\n",
+				__func__, index, entry->pgoff,
+				entry->num_pages, entry->block >> PAGE_SHIFT);
+			return -EINVAL;
+		}
+		if (entry->reassigned == 0) {
+			nr = (entry->num_pages - (index - entry->pgoff))
+				* PAGE_SIZE;
+		} else {
+			nr = PAGE_SIZE;
+		}
+
+		nvmm = get_nvmm(sb, sih, entry, index);
+		dax_mem = nova_get_block(sb, (nvmm << PAGE_SHIFT));
+
+memcpy:
+		nr = nr - offset;
+		if (nr > len - copied)
+			nr = len - copied;
+
+		NOVA_START_TIMING(memcpy_r_nvmm_t, memcpy_time);
+
+		if (!zero)
+			left = __copy_to_user(buf + copied,
+						dax_mem + offset, nr);
+		else
+			left = __clear_user(buf + copied, nr);
+
+		NOVA_END_TIMING(memcpy_r_nvmm_t, memcpy_time);
+
+		if (left) {
+			nova_dbg("%s ERROR!: bytes %lu, left %lu\n",
+				__func__, nr, left);
+			error = -EFAULT;
+			goto out;
+		}
+
+		copied += (nr - left);
+		offset += (nr - left);
+		index += offset >> PAGE_SHIFT;
+		offset &= ~PAGE_MASK;
+	} while (copied < len);
+
+out:
+	*ppos = pos + copied;
+	if (filp)
+		file_accessed(filp);
+
+	NOVA_STATS_ADD(read_bytes, copied);
+
+	nova_dbgv("%s returned %zu\n", __func__, copied);
+	return copied ? copied : error;
+}
+
+/*
+ * Wrappers. We need to use the read lock to avoid
+ * concurrent truncate operation. No problem for write because we held
+ * lock.
+ */
+static ssize_t nova_dax_file_read(struct file *filp, char __user *buf,
+			    size_t len, loff_t *ppos)
+{
+	struct inode *inode = filp->f_mapping->host;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	ssize_t res;
+	timing_t dax_read_time;
+
+	NOVA_START_TIMING(dax_read_t, dax_read_time);
+	inode_lock_shared(inode);
+	sih_lock_shared(sih);
+	res = do_dax_mapping_read(filp, buf, len, ppos);
+	sih_unlock_shared(sih);
+	inode_unlock_shared(inode);
+	NOVA_END_TIMING(dax_read_t, dax_read_time);
+	return res;
+}
+
 
 const struct file_operations nova_dax_file_operations = {
 	.llseek		= nova_llseek,
+	.read		= nova_dax_file_read,
 	.open		= nova_open,
 	.fsync		= nova_fsync,
 	.flush		= nova_flush,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
