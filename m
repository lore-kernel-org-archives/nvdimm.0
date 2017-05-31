Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 55D6921B03878
 for <linux-nvdimm@lists.01.org>; Wed, 31 May 2017 09:18:52 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/24] xfs: remove uuid_getnodeuniq and xfs_uu_t
Date: Wed, 31 May 2017 18:18:15 +0200
Message-Id: <20170531161826.23243-14-hch@lst.de>
In-Reply-To: <20170531161826.23243-1-hch@lst.de>
References: <20170531161826.23243-1-hch@lst.de>
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

Opencode uuid_getnodeuniq in the only caller, and directly decode
the uuid_t representation instead of using a structure cast for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/uuid.c      | 25 -------------------------
 fs/xfs/uuid.h      |  1 -
 fs/xfs/xfs_mount.c |  5 ++++-
 3 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
index 29ed78c8637b..737c186ea98b 100644
--- a/fs/xfs/uuid.c
+++ b/fs/xfs/uuid.c
@@ -17,31 +17,6 @@
  */
 #include <xfs.h>
 
-/* IRIX interpretation of an uuid_t */
-typedef struct {
-	__be32	uu_timelow;
-	__be16	uu_timemid;
-	__be16	uu_timehi;
-	__be16	uu_clockseq;
-	__be16	uu_node[3];
-} xfs_uu_t;
-
-/*
- * uuid_getnodeuniq - obtain the node unique fields of a UUID.
- *
- * This is not in any way a standard or condoned UUID function;
- * it just something that's needed for user-level file handles.
- */
-void
-uuid_getnodeuniq(uuid_t *uuid, int fsid [2])
-{
-	xfs_uu_t *uup = (xfs_uu_t *)uuid;
-
-	fsid[0] = (be16_to_cpu(uup->uu_clockseq) << 16) |
-		   be16_to_cpu(uup->uu_timemid);
-	fsid[1] = be32_to_cpu(uup->uu_timelow);
-}
-
 int
 uuid_is_nil(uuid_t *uuid)
 {
diff --git a/fs/xfs/uuid.h b/fs/xfs/uuid.h
index 86bbed071e79..5aea49bf0963 100644
--- a/fs/xfs/uuid.h
+++ b/fs/xfs/uuid.h
@@ -19,6 +19,5 @@
 #define __XFS_SUPPORT_UUID_H__
 
 extern int uuid_is_nil(uuid_t *uuid);
-extern void uuid_getnodeuniq(uuid_t *uuid, int fsid [2]);
 
 #endif	/* __XFS_SUPPORT_UUID_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2eaf81859166..51f7d03ef86c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -793,7 +793,10 @@ xfs_mountfs(
 	 *  Copies the low order bits of the timestamp and the randomly
 	 *  set "sequence" number out of a UUID.
 	 */
-	uuid_getnodeuniq(&sbp->sb_uuid, mp->m_fixedfsid);
+	mp->m_fixedfsid[0] =
+		(get_unaligned_be16(&sbp->sb_uuid.b[8]) << 16) |
+		 get_unaligned_be16(&sbp->sb_uuid.b[4]);
+	mp->m_fixedfsid[1] = get_unaligned_be32(&sbp->sb_uuid.b[0]);
 
 	mp->m_dmevmask = 0;	/* not persistent; set after each mount */
 
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
