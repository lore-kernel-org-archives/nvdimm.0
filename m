Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F0F421F3C185
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 17:50:30 -0700 (PDT)
Subject: [PATCH v9 5/6] fs, xfs, iomap: introduce break_layout_nowait()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Oct 2017 17:47:35 -0700
Message-ID: <150776925510.9144.2117153288971353589.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

In preparation for using FL_LAYOUT leases to allow coordination between
the kernel and processes doing userspace flushes / RDMA with DAX
mappings, add this helper that can be used to start the lease break
process in contexts where we can not sleep waiting for the lease break
timeout.

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
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_iomap.c  |    3 +++
 fs/xfs/xfs_layout.c |    5 ++++-
 include/linux/fs.h  |    9 +++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f179bdf1644d..840e4080afb5 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1055,6 +1055,9 @@ xfs_file_iomap_begin(
 			error = -EAGAIN;
 			goto out_unlock;
 		}
+		error = break_layout_nowait(inode);
+		if (error)
+			goto out_unlock;
 		/*
 		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
 		 * pages to keep the chunks of work done where somewhat symmetric
diff --git a/fs/xfs/xfs_layout.c b/fs/xfs/xfs_layout.c
index 71d95e1a910a..7a633b6e9397 100644
--- a/fs/xfs/xfs_layout.c
+++ b/fs/xfs/xfs_layout.c
@@ -19,7 +19,10 @@
  * about exposing unallocated blocks but just want to provide basic
  * synchronization between a local writer and pNFS clients.  mmap writes would
  * also benefit from this sort of synchronization, but due to the tricky locking
- * rules in the page fault path we don't bother.
+ * rules in the page fault path all we can do is start the lease break
+ * timeout. See usage of break_layout_nowait in xfs_file_iomap_begin to
+ * prevent write-faults from allocating blocks or performing extent
+ * conversion.
  */
 int
 xfs_break_layouts(
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 17e0e899e184..2b030a2fccc7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2364,6 +2364,15 @@ static inline int break_layout(struct inode *inode, bool wait)
 
 #endif /* CONFIG_FILE_LOCKING */
 
+/*
+ * For use in paths where we can not wait for the layout to be recalled,
+ * for example when we are holding mmap_sem.
+ */
+static inline int break_layout_nowait(struct inode *inode)
+{
+	return break_layout(inode, false);
+}
+
 /* fs/open.c */
 struct audit_names;
 struct filename {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
