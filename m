Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D10FE21A04E04
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 11:02:53 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/16] xfs: use the common helper uuid_is_null()
Date: Wed, 10 May 2017 20:02:10 +0200
Message-Id: <20170510180214.16852-13-hch@lst.de>
In-Reply-To: <20170510180214.16852-1-hch@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
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
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Amir Goldstein <amir73il@gmail.com>

Use the common helper uuid_is_null() and remove the xfs specific
helper uuid_is_nil().

The common helper does not check for the NULL pointer value as
xfs helper did, but xfs code never calls the helper with a pointer
that can be NULL.

Conform comments and warning strings to use the term 'null uuid'
instead of 'nil uuid', because this is the terminology used by
lib/uuid.c and its users. It is also the terminology used in
userspace by libuuid and xfsprogs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[hch: remove now unused uuid.[ch]]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile          |  3 +--
 fs/xfs/uuid.c            | 32 --------------------------------
 fs/xfs/uuid.h            | 23 -----------------------
 fs/xfs/xfs_linux.h       |  1 -
 fs/xfs/xfs_log_recover.c |  6 +++---
 fs/xfs/xfs_mount.c       |  8 ++++----
 6 files changed, 8 insertions(+), 65 deletions(-)
 delete mode 100644 fs/xfs/uuid.c
 delete mode 100644 fs/xfs/uuid.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5c90f82b8f6b..a6e955bfead8 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -98,8 +98,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_sysfs.o \
 				   xfs_trans.o \
 				   xfs_xattr.o \
-				   kmem.o \
-				   uuid.o
+				   kmem.o
 
 # low-level transaction/log code
 xfs-y				+= xfs_log.o \
diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
deleted file mode 100644
index 737c186ea98b..000000000000
--- a/fs/xfs/uuid.c
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include <xfs.h>
-
-int
-uuid_is_nil(uuid_t *uuid)
-{
-	int	i;
-	char	*cp = (char *)uuid;
-
-	if (uuid == NULL)
-		return 0;
-	/* implied check of version number here... */
-	for (i = 0; i < sizeof *uuid; i++)
-		if (*cp++) return 0;	/* not nil */
-	return 1;	/* is nil */
-}
diff --git a/fs/xfs/uuid.h b/fs/xfs/uuid.h
deleted file mode 100644
index 5aea49bf0963..000000000000
--- a/fs/xfs/uuid.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_SUPPORT_UUID_H__
-#define __XFS_SUPPORT_UUID_H__
-
-extern int uuid_is_nil(uuid_t *uuid);
-
-#endif	/* __XFS_SUPPORT_UUID_H__ */
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 2c33d915e550..2d167fe643ec 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -43,7 +43,6 @@ typedef __u32			xfs_nlink_t;
 
 #include "kmem.h"
 #include "mrlock.h"
-#include "uuid.h"
 
 #include <linux/semaphore.h>
 #include <linux/mm.h>
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index cd0b077deb35..8cec1e5505a4 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -352,13 +352,13 @@ xlog_header_check_mount(
 {
 	ASSERT(head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM));
 
-	if (uuid_is_nil(&head->h_fs_uuid)) {
+	if (uuid_is_null(&head->h_fs_uuid)) {
 		/*
 		 * IRIX doesn't write the h_fs_uuid or h_fmt fields. If
-		 * h_fs_uuid is nil, we assume this log was last mounted
+		 * h_fs_uuid is null, we assume this log was last mounted
 		 * by IRIX and continue.
 		 */
-		xfs_warn(mp, "nil uuid in log - IRIX style log");
+		xfs_warn(mp, "null uuid in log - IRIX style log");
 	} else if (unlikely(!uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid))) {
 		xfs_warn(mp, "log has mismatched uuid - can't recover");
 		xlog_header_check_dump(mp, head);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 742e4a61c0bc..682b336a7a6a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -80,14 +80,14 @@ xfs_uuid_mount(
 	if (mp->m_flags & XFS_MOUNT_NOUUID)
 		return 0;
 
-	if (uuid_is_nil(uuid)) {
-		xfs_warn(mp, "Filesystem has nil UUID - can't mount");
+	if (uuid_is_null(uuid)) {
+		xfs_warn(mp, "Filesystem has null UUID - can't mount");
 		return -EINVAL;
 	}
 
 	mutex_lock(&xfs_uuid_table_mutex);
 	for (i = 0, hole = -1; i < xfs_uuid_table_size; i++) {
-		if (uuid_is_nil(&xfs_uuid_table[i])) {
+		if (uuid_is_null(&xfs_uuid_table[i])) {
 			hole = i;
 			continue;
 		}
@@ -124,7 +124,7 @@ xfs_uuid_unmount(
 
 	mutex_lock(&xfs_uuid_table_mutex);
 	for (i = 0; i < xfs_uuid_table_size; i++) {
-		if (uuid_is_nil(&xfs_uuid_table[i]))
+		if (uuid_is_null(&xfs_uuid_table[i]))
 			continue;
 		if (!uuid_equal(uuid, &xfs_uuid_table[i]))
 			continue;
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
