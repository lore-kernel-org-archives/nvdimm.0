Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 98106201B0443
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 13:37:34 -0800 (PST)
Subject: [PATCH 3/7] dax: Check the end of the block-device capacity with
 dax_direct_access()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Feb 2019 13:24:56 -0800
Message-ID: <155000669646.348031.16690970886357498896.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

The checks in __bdev_dax_supported() helped mitigate a potential data
corruption bug in the pmem driver's handling of section alignment
padding. Strengthen the checks, including checking the end of the range,
to validate the dev_pagemap, Xarray entries, and sector-to-pfn
translation established for pmem namespaces.

Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c |   39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 6e928f37d084..a27395cfcec6 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -86,12 +86,14 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
 {
 	struct dax_device *dax_dev;
 	bool dax_enabled = false;
+	pgoff_t pgoff, pgoff_end;
 	struct request_queue *q;
-	pgoff_t pgoff;
-	int err, id;
-	pfn_t pfn;
-	long len;
 	char buf[BDEVNAME_SIZE];
+	void *kaddr, *end_kaddr;
+	pfn_t pfn, end_pfn;
+	sector_t last_page;
+	long len, len2;
+	int err, id;
 
 	if (blocksize != PAGE_SIZE) {
 		pr_debug("%s: error: unsupported blocksize for dax\n",
@@ -113,6 +115,15 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
 		return false;
 	}
 
+	last_page = ALIGN_DOWN(part_nr_sects_read(bdev->bd_part)
+			- PAGE_SIZE / 512, PAGE_SIZE / 512);
+	err = bdev_dax_pgoff(bdev, last_page, PAGE_SIZE, &pgoff_end);
+	if (err) {
+		pr_debug("%s: error: unaligned partition for dax\n",
+				bdevname(bdev, buf));
+		return false;
+	}
+
 	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
 	if (!dax_dev) {
 		pr_debug("%s: error: device does not support dax\n",
@@ -121,14 +132,15 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
 	}
 
 	id = dax_read_lock();
-	len = dax_direct_access(dax_dev, pgoff, 1, NULL, &pfn);
+	len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
+	len2 = dax_direct_access(dax_dev, pgoff_end, 1, &end_kaddr, &end_pfn);
 	dax_read_unlock(id);
 
 	put_dax(dax_dev);
 
-	if (len < 1) {
+	if (len < 1 || len2 < 1) {
 		pr_debug("%s: error: dax access failed (%ld)\n",
-				bdevname(bdev, buf), len);
+				bdevname(bdev, buf), len < 1 ? len : len2);
 		return false;
 	}
 
@@ -143,13 +155,20 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
 		 */
 		WARN_ON(IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API));
 		dax_enabled = true;
-	} else if (pfn_t_devmap(pfn)) {
-		struct dev_pagemap *pgmap;
+	} else if (pfn_t_devmap(pfn) && pfn_t_devmap(end_pfn)) {
+		struct dev_pagemap *pgmap, *end_pgmap;
 
 		pgmap = get_dev_pagemap(pfn_t_to_pfn(pfn), NULL);
-		if (pgmap && pgmap->type == MEMORY_DEVICE_FS_DAX)
+		end_pgmap = get_dev_pagemap(pfn_t_to_pfn(end_pfn), NULL);
+		if (pgmap && pgmap == end_pgmap && pgmap->type == MEMORY_DEVICE_FS_DAX
+				&& pfn_t_to_page(pfn)->pgmap == pgmap
+				&& pfn_t_to_page(end_pfn)->pgmap == pgmap
+				&& pfn_t_to_pfn(pfn) == PHYS_PFN(__pa(kaddr))
+				&& pfn_t_to_pfn(end_pfn) == PHYS_PFN(__pa(end_kaddr)))
 			dax_enabled = true;
 		put_dev_pagemap(pgmap);
+		put_dev_pagemap(end_pgmap);
+
 	}
 
 	if (!dax_enabled) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
