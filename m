Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 90B0621F3C1AE
 for <linux-nvdimm@lists.01.org>; Tue, 10 Oct 2017 07:52:45 -0700 (PDT)
Subject: [PATCH v8 09/14] xfs: wire up ->lease_direct()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Oct 2017 07:49:48 -0700
Message-ID: <150764698865.16882.6963827339963112876.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

A 'lease_direct' lease requires that the vma have a valid MAP_DIRECT
mapping established. For xfs we use the generic_map_direct_lease()
handler for ->lease_direct(). It establishes a new lease and then checks
if the MAP_DIRECT mapping has been broken. We want to be sure that the
process will receive notification that the MAP_DIRECT mapping is being
torn down so it knows why other code paths are throwing failures.

For example in the RDMA/ibverbs case we want ibv_reg_mr() to fail if the
MAP_DIRECT mapping is invalid or in the process of being invalidated.

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
 fs/xfs/xfs_file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4bee027c9366..bc512a9a8df5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1157,6 +1157,7 @@ static const struct vm_operations_struct xfs_file_vm_direct_ops = {
 
 	.open		= generic_map_direct_open,
 	.close		= generic_map_direct_close,
+	.lease_direct	= generic_map_direct_lease,
 };
 
 static const struct vm_operations_struct xfs_file_vm_ops = {
@@ -1209,8 +1210,8 @@ xfs_file_mmap_direct(
 	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
 
 	/*
-	 * generic_map_direct_{open,close} expect ->vm_private_data is
-	 * set to the result of map_direct_register
+	 * generic_map_direct_{open,close,lease} expect
+	 * ->vm_private_data is set to the result of map_direct_register
 	 */
 	vma->vm_private_data = mds;
 	return 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
