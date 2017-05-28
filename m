Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6861621A16EE9
 for <linux-nvdimm@lists.01.org>; Sun, 28 May 2017 03:19:30 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/22] xfs: use uuid_be to implement the uuid_t type
Date: Sun, 28 May 2017 13:19:49 +0300
Message-Id: <20170528102008.30276-4-hch@lst.de>
In-Reply-To: <20170528102008.30276-1-hch@lst.de>
References: <20170528102008.30276-1-hch@lst.de>
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
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-block@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Use the generic Linux definition to implement our UUID type, this will
allow using more generic infrastructure in the future.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/uuid.h      | 4 ----
 fs/xfs/xfs_linux.h | 3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/uuid.h b/fs/xfs/uuid.h
index 104db0f3bed6..4f1441ba4fa5 100644
--- a/fs/xfs/uuid.h
+++ b/fs/xfs/uuid.h
@@ -18,10 +18,6 @@
 #ifndef __XFS_SUPPORT_UUID_H__
 #define __XFS_SUPPORT_UUID_H__
 
-typedef struct {
-	unsigned char	__u_bits[16];
-} uuid_t;
-
 extern int uuid_is_nil(uuid_t *uuid);
 extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
 extern void uuid_getnodeuniq(uuid_t *uuid, int fsid [2]);
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 044fb0e15390..89ee5ec66837 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -19,6 +19,7 @@
 #define __XFS_LINUX__
 
 #include <linux/types.h>
+#include <linux/uuid.h>
 
 /*
  * Kernel specific type declarations for XFS
@@ -38,6 +39,8 @@ typedef __s64			xfs_daddr_t;	/* <disk address> type */
 typedef __u32			xfs_dev_t;
 typedef __u32			xfs_nlink_t;
 
+typedef uuid_be			uuid_t;
+
 #include "xfs_types.h"
 
 #include "kmem.h"
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
