Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6AE6B21F3C1AE
 for <linux-nvdimm@lists.01.org>; Tue, 10 Oct 2017 07:52:23 -0700 (PDT)
Subject: [PATCH v8 05/14] fs, xfs, iomap: introduce iomap_can_allocate()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Oct 2017 07:49:24 -0700
Message-ID: <150764696413.16882.17741758404259343219.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150764693502.16882.15848797003793552156.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150764693502.16882.15848797003793552156.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

In preparation for using FL_LAYOUT leases to allow coordination between
the kernel and processes doing userspace flushes / RDMA with DAX
mappings, add this helper that can be used to detect when block-map
updates are not allowed.

This is targeted to be used in an ->iomap_begin() implementation where
we may have various filesystem locks held and can not synchronously wait
for any FL_LAYOUT leases to be released. In particular an iomap mmap
fault handler running under mmap_sem can not unlock that semaphore and
wait for these leases to be unlocked. Instead, this signals the lease
holder(s) that a break is requested and immediately returns with an
error.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_iomap.c    |    3 +++
 fs/xfs/xfs_layout.c   |    5 ++++-
 include/linux/iomap.h |   10 ++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index a1909bc064e9..b3cda11e9515 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1052,6 +1052,9 @@ xfs_file_iomap_begin(
 			error = -EAGAIN;
 			goto out_unlock;
 		}
+		error = iomap_can_allocate(inode);
+		if (error)
+			goto out_unlock;
 		/*
 		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
 		 * pages to keep the chunks of work done where somewhat symmetric
diff --git a/fs/xfs/xfs_layout.c b/fs/xfs/xfs_layout.c
index 71d95e1a910a..88c533bf5b7c 100644
--- a/fs/xfs/xfs_layout.c
+++ b/fs/xfs/xfs_layout.c
@@ -19,7 +19,10 @@
  * about exposing unallocated blocks but just want to provide basic
  * synchronization between a local writer and pNFS clients.  mmap writes would
  * also benefit from this sort of synchronization, but due to the tricky locking
- * rules in the page fault path we don't bother.
+ * rules in the page fault path all we can do is start the lease break
+ * timeout. See usage of iomap_can_allocate in xfs_file_iomap_begin to
+ * prevent write-faults from allocating blocks or performing extent
+ * conversion.
  */
 int
 xfs_break_layouts(
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index f64dc6ce5161..e24b4e81d41a 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -2,6 +2,7 @@
 #define LINUX_IOMAP_H 1
 
 #include <linux/types.h>
+#include <linux/fs.h>
 
 struct fiemap_extent_info;
 struct inode;
@@ -88,6 +89,15 @@ loff_t iomap_seek_hole(struct inode *inode, loff_t offset,
 		const struct iomap_ops *ops);
 loff_t iomap_seek_data(struct inode *inode, loff_t offset,
 		const struct iomap_ops *ops);
+/*
+ * Check if there are any file layout leases preventing block map
+ * changes and if so start the lease break process, but do not wait for
+ * it to complete (return -EWOULDBLOCK);
+ */
+static inline int iomap_can_allocate(struct inode *inode)
+{
+	return break_layout(inode, false);
+}
 
 /*
  * Flags for direct I/O ->end_io:

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
