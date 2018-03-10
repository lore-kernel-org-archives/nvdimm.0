Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x242.google.com (mail-pf0-x242.google.com
 [IPv6:2607:f8b0:400e:c00::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5FE812253FB7A
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:41 -0800 (PST)
Received: by mail-pf0-x242.google.com with SMTP id 68so2619767pfx.3
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:00 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 36/83] Journal: Lite journal recovery.
Date: Sat, 10 Mar 2018 10:18:17 -0800
Message-Id: <1520705944-6723-37-git-send-email-jix024@eng.ucsd.edu>
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
 fs/nova/journal.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/fs/nova/journal.c b/fs/nova/journal.c
index 75d590f..f31de97 100644
--- a/fs/nova/journal.c
+++ b/fs/nova/journal.c
@@ -106,3 +106,58 @@ static int nova_check_journal_entries(struct super_block *sb,
 
 	return 0;
 }
+
+/**************************** Journal Recovery ******************************/
+
+static void nova_undo_journal_entry(struct super_block *sb,
+	struct nova_lite_journal_entry *entry)
+{
+	u64 addr, value;
+
+	addr = le64_to_cpu(entry->data1);
+	value = le64_to_cpu(entry->data2);
+
+	*(u64 *)nova_get_block(sb, addr) = (u64)value;
+	nova_flush_buffer((void *)nova_get_block(sb, addr), CACHELINE_SIZE, 0);
+}
+
+static void nova_undo_lite_journal_entry(struct super_block *sb,
+	struct nova_lite_journal_entry *entry)
+{
+	u64 type;
+
+	type = le64_to_cpu(entry->type);
+
+	switch (type) {
+	case JOURNAL_INODE:
+		/* Currently unused */
+		break;
+	case JOURNAL_ENTRY:
+		nova_undo_journal_entry(sb, entry);
+		break;
+	default:
+		nova_dbg("%s: unknown data type %llu\n", __func__, type);
+		break;
+	}
+}
+
+/* Roll back all journal enries */
+static int nova_recover_lite_journal(struct super_block *sb,
+	struct journal_ptr_pair *pair)
+{
+	struct nova_lite_journal_entry *entry;
+	u64 temp;
+
+	temp = pair->journal_head;
+	while (temp != pair->journal_tail) {
+		entry = (struct nova_lite_journal_entry *)nova_get_block(sb,
+									temp);
+		nova_undo_lite_journal_entry(sb, entry);
+		temp = next_lite_journal(temp);
+	}
+
+	pair->journal_tail = pair->journal_head;
+	nova_flush_buffer(&pair->journal_head, CACHELINE_SIZE, 1);
+
+	return 0;
+}
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
