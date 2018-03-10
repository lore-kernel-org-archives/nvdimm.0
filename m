Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x242.google.com (mail-pf0-x242.google.com
 [IPv6:2607:f8b0:400e:c00::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4095222603B1B
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:40 -0800 (PST)
Received: by mail-pf0-x242.google.com with SMTP id h19so2612510pfd.12
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:59 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 35/83] Journal: Lite journal helper routines.
Date: Sat, 10 Mar 2018 10:18:16 -0800
Message-Id: <1520705944-6723-36-git-send-email-jix024@eng.ucsd.edu>
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

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/Makefile  |   2 +-
 fs/nova/journal.c | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+), 1 deletion(-)
 create mode 100644 fs/nova/journal.c

diff --git a/fs/nova/Makefile b/fs/nova/Makefile
index b3638a4..4aeadea 100644
--- a/fs/nova/Makefile
+++ b/fs/nova/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_NOVA_FS) += nova.o
 
-nova-y := balloc.o bbuild.o inode.o log.o rebuild.o stats.o super.o
+nova-y := balloc.o bbuild.o inode.o journal.o log.o rebuild.o stats.o super.o
diff --git a/fs/nova/journal.c b/fs/nova/journal.c
new file mode 100644
index 0000000..75d590f
--- /dev/null
+++ b/fs/nova/journal.c
@@ -0,0 +1,108 @@
+/*
+ * NOVA journaling facility.
+ *
+ * This file contains journaling code to guarantee the atomicity of directory
+ * operations that span multiple inodes (unlink, rename, etc).
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ * Copyright 2012-2013 Intel Corporation
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/vfs.h>
+#include <linux/uaccess.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include "nova.h"
+#include "journal.h"
+
+/**************************** Lite journal ******************************/
+
+static inline void
+nova_print_lite_transaction(struct nova_lite_journal_entry *entry)
+{
+	nova_dbg("Entry %p: Type %llu, data1 0x%llx, data2 0x%llx\n, checksum %u\n",
+			entry, entry->type,
+			entry->data1, entry->data2, entry->csum);
+}
+
+static inline int nova_update_journal_entry_csum(struct super_block *sb,
+	struct nova_lite_journal_entry *entry)
+{
+	u32 crc = 0;
+
+	crc = nova_crc32c(~0, (__u8 *)entry,
+			(sizeof(struct nova_lite_journal_entry)
+			 - sizeof(__le32)));
+
+	entry->csum = cpu_to_le32(crc);
+	nova_flush_buffer(entry, sizeof(struct nova_lite_journal_entry), 0);
+	return 0;
+}
+
+static inline int nova_check_entry_integrity(struct super_block *sb,
+	struct nova_lite_journal_entry *entry)
+{
+	u32 crc = 0;
+
+	crc = nova_crc32c(~0, (__u8 *)entry,
+			(sizeof(struct nova_lite_journal_entry)
+			 - sizeof(__le32)));
+
+	if (entry->csum == cpu_to_le32(crc))
+		return 0;
+	else
+		return 1;
+}
+
+// Get the next journal entry.  Journal entries are stored in a circular
+// buffer.  They live a 1-page circular buffer.
+//
+// TODO: Add check to ensure that the journal doesn't grow too large.
+static inline u64 next_lite_journal(u64 curr_p)
+{
+	size_t size = sizeof(struct nova_lite_journal_entry);
+
+	if ((curr_p & (PAGE_SIZE - 1)) + size >= PAGE_SIZE)
+		return (curr_p & PAGE_MASK);
+
+	return curr_p + size;
+}
+
+// Walk the journal for one CPU, and verify the checksum on each entry.
+static int nova_check_journal_entries(struct super_block *sb,
+	struct journal_ptr_pair *pair)
+{
+	struct nova_lite_journal_entry *entry;
+	u64 temp;
+	int ret;
+
+	temp = pair->journal_head;
+	while (temp != pair->journal_tail) {
+		entry = (struct nova_lite_journal_entry *)nova_get_block(sb,
+									temp);
+		ret = nova_check_entry_integrity(sb, entry);
+		if (ret) {
+			nova_dbg("Entry %p checksum failure\n", entry);
+			nova_print_lite_transaction(entry);
+			return ret;
+		}
+		temp = next_lite_journal(temp);
+	}
+
+	return 0;
+}
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
