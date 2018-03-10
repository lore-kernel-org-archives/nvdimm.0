Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x243.google.com (mail-pf0-x243.google.com
 [IPv6:2607:f8b0:400e:c00::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C0C122603AE1
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:39 -0800 (PST)
Received: by mail-pf0-x243.google.com with SMTP id 17so2613917pfw.11
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:57 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 34/83] Journal: NOVA light weight journal definitions.
Date: Sat, 10 Mar 2018 10:18:15 -0800
Message-Id: <1520705944-6723-35-git-send-email-jix024@eng.ucsd.edu>
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

NOVA uses per-CPU lite journals to provide fast atomicity guarantees
for multi-log appending and multi-word inplace updates.

NOVA uses undo journaling. Each journal is a circular buffer
of 4KB pmem page. Two pointers, journal_head and journal_tail
reside in the reserved journal block, and point to the journal page.
If the two pointers are not equal, there are uncommitted transactions
and NOVA recovers the data by replaying the journal entries.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/bbuild.c  |  1 +
 fs/nova/journal.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/nova/log.c     |  1 +
 fs/nova/super.c   |  1 +
 4 files changed, 46 insertions(+)
 create mode 100644 fs/nova/journal.h

diff --git a/fs/nova/bbuild.c b/fs/nova/bbuild.c
index 66053cb..af1b352 100644
--- a/fs/nova/bbuild.c
+++ b/fs/nova/bbuild.c
@@ -25,6 +25,7 @@
 #include <linux/random.h>
 #include <linux/delay.h>
 #include "nova.h"
+#include "journal.h"
 #include "super.h"
 #include "inode.h"
 
diff --git a/fs/nova/journal.h b/fs/nova/journal.h
new file mode 100644
index 0000000..d1d0ffb
--- /dev/null
+++ b/fs/nova/journal.h
@@ -0,0 +1,43 @@
+#ifndef __JOURNAL_H
+#define __JOURNAL_H
+
+#include <linux/types.h>
+#include <linux/fs.h>
+#include "nova.h"
+#include "super.h"
+
+
+/* ======================= Lite journal ========================= */
+
+#define NOVA_MAX_JOURNAL_LENGTH 128
+
+#define	JOURNAL_INODE	1
+#define	JOURNAL_ENTRY	2
+
+/* Lightweight journal entry */
+struct nova_lite_journal_entry {
+	__le64 type;       // JOURNAL_INODE or JOURNAL_ENTRY
+	__le64 data1;
+	__le64 data2;
+	__le32 padding;
+	__le32 csum;
+} __attribute((__packed__));
+
+/* Head and tail pointers into a circular queue of journal entries.  There's
+ * one of these per CPU.
+ */
+struct journal_ptr_pair {
+	__le64 journal_head;
+	__le64 journal_tail;
+};
+
+static inline
+struct journal_ptr_pair *nova_get_journal_pointers(struct super_block *sb,
+	int cpu)
+{
+	return (struct journal_ptr_pair *)((char *)nova_get_block(sb,
+		NOVA_DEF_BLOCK_SIZE_4K * JOURNAL_START) + cpu * CACHELINE_SIZE);
+}
+
+
+#endif
diff --git a/fs/nova/log.c b/fs/nova/log.c
index bdd133e..f01b7c8 100644
--- a/fs/nova/log.c
+++ b/fs/nova/log.c
@@ -16,6 +16,7 @@
  */
 
 #include "nova.h"
+#include "journal.h"
 #include "inode.h"
 #include "log.h"
 
diff --git a/fs/nova/super.c b/fs/nova/super.c
index c0427fd..d73c202 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -38,6 +38,7 @@
 #include <linux/list.h>
 #include <linux/dax.h>
 #include "nova.h"
+#include "journal.h"
 #include "super.h"
 
 int measure_timing;
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
