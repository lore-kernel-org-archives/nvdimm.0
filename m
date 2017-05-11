Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BAEF721A13484
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 19:55:39 -0700 (PDT)
Subject: [PATCH] filesystem-dax: fix broken __dax_zero_page_range() conversion
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 10 May 2017 19:49:47 -0700
Message-ID: <149447098770.22897.1499086717635335664.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

The conversion of __dax_zero_page_range() to 'struct dax_operations'
caused it to frequently fail. The mistake was treating the @size
parameter as a dax mapping length rather than just a length of the
clear_pmem() operation. The dax mapping length is assumed to be hard
coded as PAGE_SIZE.

Without this fix any page unaligned zeroing request will trigger a
-EINVAL return from bdev_dax_pgoff().

Cc: Jan Kara <jack@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: cccbce671582 ("filesystem-dax: convert to dax_direct_access()")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index ce9dc9c3e829..5ee1d212d81f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -971,12 +971,12 @@ int __dax_zero_page_range(struct block_device *bdev,
 		void *kaddr;
 		pfn_t pfn;
 
-		rc = bdev_dax_pgoff(bdev, sector, size, &pgoff);
+		rc = bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
 		if (rc)
 			return rc;
 
 		id = dax_read_lock();
-		rc = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr,
+		rc = dax_direct_access(dax_dev, pgoff, 1, &kaddr,
 				&pfn);
 		if (rc < 0) {
 			dax_read_unlock(id);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
