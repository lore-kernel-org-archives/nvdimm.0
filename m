Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] pmem: add proper synchronization to pmem_rw_page()
Date: Wed, 16 Sep 2015 14:52:21 -0600
Message-Id: <1442436741-32112-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

pmem_rw_page() needs to call wmb_pmem() on writes to make sure that the
newly written data is durable.  This flow was added to pmem_rw_bytes()
and pmem_make_request() with this commit:

commit 61031952f4c8 ("arch, x86: pmem api for ensuring durability of
	persistent memory updates")

but it looks like the pmem_rw_page() path was missed.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/nvdimm/pmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index b952538..0ba6a97 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -92,6 +92,8 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	struct pmem_device *pmem = bdev->bd_disk->private_data;
 
 	pmem_do_bvec(pmem, page, PAGE_CACHE_SIZE, 0, rw, sector);
+	if (rw & WRITE)
+		wmb_pmem();
 	page_endio(page, rw & WRITE, 0);
 
 	return 0;
-- 
2.1.0

