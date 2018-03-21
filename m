Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D97D7225B02BE
 for <linux-nvdimm@lists.01.org>; Wed, 21 Mar 2018 16:00:01 -0700 (PDT)
Subject: [PATCH v7 03/14] block, dax: remove dead code in blkdev_writepages()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 21 Mar 2018 15:57:27 -0700
Message-ID: <152167304720.5268.4517441516790980453.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Block device inodes never have S_DAX set, so kill the check for DAX and
diversion to dax_writeback_mapping_range().

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/block_dev.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index fe09ef9c21f3..846ee2d31781 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1946,11 +1946,6 @@ static int blkdev_releasepage(struct page *page, gfp_t wait)
 static int blkdev_writepages(struct address_space *mapping,
 			     struct writeback_control *wbc)
 {
-	if (dax_mapping(mapping)) {
-		struct block_device *bdev = I_BDEV(mapping->host);
-
-		return dax_writeback_mapping_range(mapping, bdev, wbc);
-	}
 	return generic_writepages(mapping, wbc);
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
