From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 02/12] iomap: expose iomap_apply outside iomap.c
Date: Fri, 16 Sep 2016 13:27:04 +0200
Message-ID: <1474025234-13804-3-git-send-email-hch@lst.de>
References: <1474025234-13804-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1474025234-13804-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

This allows the DAX code to use it.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 fs/internal.h | 11 +++++++++++
 fs/iomap.c    |  5 +----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index ba07376..8591786 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -12,6 +12,7 @@
 struct super_block;
 struct file_system_type;
 struct iomap;
+struct iomap_ops;
 struct linux_binprm;
 struct path;
 struct mount;
@@ -164,3 +165,13 @@ extern struct dentry_operations ns_dentry_operations;
 extern int do_vfs_ioctl(struct file *file, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
 extern long vfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+
+/*
+ * iomap support:
+ */
+typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
+		void *data, struct iomap *iomap);
+
+loff_t iomap_apply(struct inode *inode, loff_t pos, loff_t length,
+		unsigned flags, struct iomap_ops *ops, void *data,
+		iomap_actor_t actor);
diff --git a/fs/iomap.c b/fs/iomap.c
index 706270f..f4df9c6 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -27,9 +27,6 @@
 #include <linux/dax.h>
 #include "internal.h"
 
-typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
-		void *data, struct iomap *iomap);
-
 /*
  * Execute a iomap write on a segment of the mapping that spans a
  * contiguous range of pages that have identical block mapping state.
@@ -41,7 +38,7 @@ typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
  * resources they require in the iomap_begin call, and release them in the
  * iomap_end call.
  */
-static loff_t
+loff_t
 iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
 		struct iomap_ops *ops, void *data, iomap_actor_t actor)
 {
-- 
2.1.4
