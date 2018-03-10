Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x244.google.com (mail-pf0-x244.google.com
 [IPv6:2607:f8b0:400e:c00::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4EF892258AF16
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:23 -0800 (PST)
Received: by mail-pf0-x244.google.com with SMTP id h19so2612350pfd.12
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:42 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 21/83] Add log structure.
Date: Sat, 10 Mar 2018 10:18:02 -0800
Message-Id: <1520705944-6723-22-git-send-email-jix024@eng.ucsd.edu>
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

NOVA log is a singly linked list of 4KB pmem pages.
Each log page consists of two parts: 4064 bytes for log entries,
and 32 bytes for page tail structure. Page tail contains metadata
about the log page and the address of the next log page in the
linked list.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/log.h  | 187 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/nova.h |   1 +
 2 files changed, 188 insertions(+)
 create mode 100644 fs/nova/log.h

diff --git a/fs/nova/log.h b/fs/nova/log.h
new file mode 100644
index 0000000..61586a3
--- /dev/null
+++ b/fs/nova/log.h
@@ -0,0 +1,187 @@
+#ifndef __LOG_H
+#define __LOG_H
+
+#include "balloc.h"
+#include "inode.h"
+
+/* ======================= Log entry ========================= */
+/* Inode entry in the log */
+
+#define	MAIN_LOG	0
+#define	ALTER_LOG	1
+
+#define	PAGE_OFFSET_MASK	4095
+#define	BLOCK_OFF(p)	((p) & ~PAGE_OFFSET_MASK)
+
+#define	ENTRY_LOC(p)	((p) & PAGE_OFFSET_MASK)
+
+#define	LOG_BLOCK_TAIL	4064
+#define	PAGE_TAIL(p)	(BLOCK_OFF(p) + LOG_BLOCK_TAIL)
+
+/*
+ * Log page state and pointers to next page and the replica page
+ */
+struct nova_inode_page_tail {
+	__le32	invalid_entries;
+	__le32	num_entries;
+	__le64	epoch_id;	/* For snapshot list page */
+	__le64	padding;
+	__le64	next_page;
+} __attribute((__packed__));
+
+/* Fit in PAGE_SIZE */
+struct	nova_inode_log_page {
+	char padding[LOG_BLOCK_TAIL];
+	struct nova_inode_page_tail page_tail;
+} __attribute((__packed__));
+
+
+enum nova_entry_type {
+	FILE_WRITE = 1,
+	DIR_LOG,
+	SET_ATTR,
+	LINK_CHANGE,
+	NEXT_PAGE,
+};
+
+static inline u8 nova_get_entry_type(void *p)
+{
+	u8 type;
+	int rc;
+
+	rc = memcpy_mcsafe(&type, p, sizeof(u8));
+	if (rc)
+		return rc;
+
+	return type;
+}
+
+static inline void nova_set_entry_type(void *p, enum nova_entry_type type)
+{
+	*(u8 *)p = type;
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
+static inline void nova_inc_page_invalid_entries(struct super_block *sb,
+	u64 curr)
+{
+	struct nova_inode_log_page *curr_page;
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
+	}
+
+	nova_flush_buffer(&curr_page->page_tail,
+				sizeof(struct nova_inode_page_tail), 0);
+}
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
+
+
+#endif
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index 0992f50..f5b4ec8 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -301,6 +301,7 @@ static inline u64 nova_get_epoch_id(struct super_block *sb)
 }
 
 #include "inode.h"
+#include "log.h"
 
 /* A node in the RB tree representing a range of pages */
 struct nova_range_node {
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
