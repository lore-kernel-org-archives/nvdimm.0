Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9FD202131D597
 for <linux-nvdimm@lists.01.org>; Fri,  9 Aug 2019 16:01:34 -0700 (PDT)
From: ira.weiny@intel.com
Subject: [RFC PATCH v2 08/19] fs/xfs: Fail truncate if page lease can't be
 broken
Date: Fri,  9 Aug 2019 15:58:22 -0700
Message-Id: <20190809225833.6657-9-ira.weiny@intel.com>
In-Reply-To: <20190809225833.6657-1-ira.weiny@intel.com>
References: <20190809225833.6657-1-ira.weiny@intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

From: Ira Weiny <ira.weiny@intel.com>

If pages are under a lease fail the truncate operation.  We change the order of
lease breaks to directly fail the operation if the lease exists.

Select EXPORT_BLOCK_OPS for FS_DAX to ensure that xfs_break_lease_layouts() is
defined for FS_DAX as well as pNFS.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/Kconfig        | 1 +
 fs/xfs/xfs_file.c | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 14cd4abdc143..c10b91f92528 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -48,6 +48,7 @@ config FS_DAX
 	select DEV_PAGEMAP_OPS if (ZONE_DEVICE && !FS_DAX_LIMITED)
 	select FS_IOMAP
 	select DAX
+	select EXPORTFS_BLOCK_OPS
 	help
 	  Direct Access (DAX) can be used on memory-backed block devices.
 	  If the block device supports DAX and the filesystem supports DAX,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 447571e3cb02..850d0a0953a2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -773,10 +773,11 @@ xfs_break_layouts(
 		retry = false;
 		switch (reason) {
 		case BREAK_UNMAP:
-			error = xfs_break_dax_layouts(inode, &retry, off, len);
+			error = xfs_break_leased_layouts(inode, iolock, &retry);
 			if (error || retry)
 				break;
-			/* fall through */
+			error = xfs_break_dax_layouts(inode, &retry, off, len);
+			break;
 		case BREAK_WRITE:
 			error = xfs_break_leased_layouts(inode, iolock, &retry);
 			break;
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
