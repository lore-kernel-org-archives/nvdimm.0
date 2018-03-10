Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x241.google.com (mail-pl0-x241.google.com
 [IPv6:2607:f8b0:400e:c01::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F38321E082A6
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:13:58 -0800 (PST)
Received: by mail-pl0-x241.google.com with SMTP id f23-v6so7023447plr.10
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:17 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 02/83] Add nova_def.h.
Date: Sat, 10 Mar 2018 10:17:43 -0800
Message-Id: <1520705944-6723-3-git-send-email-jix024@eng.ucsd.edu>
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

This file defines NOVA filesystem macros and routines to persist updates
by using Intel persistent memory instruction CLWB or clflush.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/nova_def.h | 128 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)
 create mode 100644 fs/nova/nova_def.h

diff --git a/fs/nova/nova_def.h b/fs/nova/nova_def.h
new file mode 100644
index 0000000..1cbed6f
--- /dev/null
+++ b/fs/nova/nova_def.h
@@ -0,0 +1,128 @@
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
+#define MAX_CPUS 1024
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
+#endif /* _LINUX_NOVA_DEF_H */
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
