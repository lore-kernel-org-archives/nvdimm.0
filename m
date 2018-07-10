Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B728208F78DC
 for <linux-nvdimm@lists.01.org>; Tue, 10 Jul 2018 15:09:46 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v2 1/2] src/: add license and copyright info to files
Date: Tue, 10 Jul 2018 16:09:41 -0600
Message-Id: <20180710220942.21074-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20180710220942.21074-1-ross.zwisler@linux.intel.com>
References: <20180710220942.21074-1-ross.zwisler@linux.intel.com>
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
To: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add copyright and license info to files that I've authored in src/.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 src/t_ext4_dax_inline_corruption.c  | 2 ++
 src/t_ext4_dax_journal_corruption.c | 2 ++
 src/t_mmap_cow_race.c               | 2 ++
 src/t_mmap_stale_pmd.c              | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/src/t_ext4_dax_inline_corruption.c b/src/t_ext4_dax_inline_corruption.c
index b52bcc0d..e1a39a6c 100644
--- a/src/t_ext4_dax_inline_corruption.c
+++ b/src/t_ext4_dax_inline_corruption.c
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Intel Corporation. */
 #include <errno.h>
 #include <fcntl.h>
 #include <stdio.h>
diff --git a/src/t_ext4_dax_journal_corruption.c b/src/t_ext4_dax_journal_corruption.c
index fccef8f5..ba7a96e4 100644
--- a/src/t_ext4_dax_journal_corruption.c
+++ b/src/t_ext4_dax_journal_corruption.c
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Intel Corporation. */
 #include <errno.h>
 #include <fcntl.h>
 #include <stdio.h>
diff --git a/src/t_mmap_cow_race.c b/src/t_mmap_cow_race.c
index 207ba425..5941fcf3 100644
--- a/src/t_mmap_cow_race.c
+++ b/src/t_mmap_cow_race.c
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2017 Intel Corporation. */
 #include <errno.h>
 #include <fcntl.h>
 #include <libgen.h>
diff --git a/src/t_mmap_stale_pmd.c b/src/t_mmap_stale_pmd.c
index 6a52201c..a139d8ac 100644
--- a/src/t_mmap_stale_pmd.c
+++ b/src/t_mmap_stale_pmd.c
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2017 Intel Corporation. */
 #include <errno.h>
 #include <fcntl.h>
 #include <libgen.h>
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
