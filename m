Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
 by ml01.01.org (Postfix) with ESMTP id AB4E0212017C0
 for <linux-nvdimm@lists.01.org>; Tue, 16 Apr 2019 18:27:32 -0700 (PDT)
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 4/4] fs/xfs: iomap: update the extent list after a COW
Date: Wed, 17 Apr 2019 09:27:15 +0800
Message-ID: <20190417012715.8287-5-ruansy.fnst@cn.fujitsu.com>
In-Reply-To: <20190417012715.8287-1-ruansy.fnst@cn.fujitsu.com>
References: <20190417012715.8287-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

COW allocated new extents, which are new part of the inode,  So we
need to update the metadata.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 fs/xfs/xfs_iomap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index a45b4e5a1d87..5c05c11e0cb2 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1146,6 +1146,9 @@ xfs_file_iomap_end(
 	if ((flags & IOMAP_WRITE) && iomap->type == IOMAP_DELALLOC)
 		return xfs_file_iomap_end_delalloc(XFS_I(inode), offset,
 				length, written, iomap);
+	/* update the extent list after a COW operation */
+	if (iomap->flags & IOMAP_F_SHARED && iomap->src_addr)
+		return xfs_reflink_end_cow(XFS_I(inode), offset, length);
 	return 0;
 }
 
-- 
2.17.0



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
