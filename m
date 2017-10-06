Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D8E0E21FC748B
 for <linux-nvdimm@lists.01.org>; Fri,  6 Oct 2017 15:38:33 -0700 (PDT)
Subject: [PATCH v7 03/12] fs: introduce i_mapdcount
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 Oct 2017 15:35:32 -0700
Message-ID: <150732933283.22363.570426117546397495.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

When ->iomap_begin() sees this count being non-zero and determines that
the block map of the file needs to be modified to satisfy the I/O
request it will instead return an error. This is needed for MAP_DIRECT
where, due to locking constraints, we can't rely on xfs_break_layouts()
to protect against allocating write-faults either from the process that
setup the MAP_DIRECT mapping nor other processes that have the file
mapped.  xfs_break_layouts() requires XFS_IOLOCK which is problematic to
mix with the XFS_MMAPLOCK in the fault path.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_iomap.c |    9 +++++++++
 include/linux/fs.h |   31 +++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index a1909bc064e9..6816f8ebbdcf 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1053,6 +1053,15 @@ xfs_file_iomap_begin(
 			goto out_unlock;
 		}
 		/*
+		 * If a file has MAP_DIRECT mappings disable block map
+		 * updates. This should only effect mmap write faults as
+		 * other paths are protected by an FL_LAYOUT lease.
+		 */
+		if (i_mapdcount_read(inode)) {
+			error = -ETXTBSY;
+			goto out_unlock;
+		}
+		/*
 		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
 		 * pages to keep the chunks of work done where somewhat symmetric
 		 * with the work writeback does. This is a completely arbitrary
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c2b9bf3dc4e9..f83871b188ff 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -642,6 +642,9 @@ struct inode {
 	atomic_t		i_count;
 	atomic_t		i_dio_count;
 	atomic_t		i_writecount;
+#ifdef CONFIG_FS_DAX
+	atomic_t		i_mapdcount;	/* count of MAP_DIRECT vmas */
+#endif
 #ifdef CONFIG_IMA
 	atomic_t		i_readcount; /* struct files open RO */
 #endif
@@ -2784,6 +2787,34 @@ static inline void i_readcount_inc(struct inode *inode)
 	return;
 }
 #endif
+
+#ifdef CONFIG_FS_DAX
+static inline void i_mapdcount_dec(struct inode *inode)
+{
+	BUG_ON(!atomic_read(&inode->i_mapdcount));
+	atomic_dec(&inode->i_mapdcount);
+}
+static inline void i_mapdcount_inc(struct inode *inode)
+{
+	atomic_inc(&inode->i_mapdcount);
+}
+static inline int i_mapdcount_read(struct inode *inode)
+{
+	return atomic_read(&inode->i_mapdcount);
+}
+#else
+static inline void i_mapdcount_dec(struct inode *inode)
+{
+}
+static inline void i_mapdcount_inc(struct inode *inode)
+{
+}
+static inline int i_mapdcount_read(struct inode *inode)
+{
+	return 0;
+}
+#endif
+
 extern int do_pipe_flags(int *, int);
 
 #define __kernel_read_file_id(id) \

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
