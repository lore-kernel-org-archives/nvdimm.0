Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 461062193B804
 for <linux-nvdimm@lists.01.org>; Sun, 23 Jul 2017 22:16:57 -0700 (PDT)
From: "Huang, Ying" <ying.huang@intel.com>
Subject: [PATCH -mm -v3 05/12] block,
 THP: Make block_device_operations.rw_page support THP
Date: Mon, 24 Jul 2017 13:18:33 +0800
Message-Id: <20170724051840.2309-6-ying.huang@intel.com>
In-Reply-To: <20170724051840.2309-1-ying.huang@intel.com>
References: <20170724051840.2309-1-ying.huang@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>, Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Huang Ying <ying.huang@intel.com>

The .rw_page in struct block_device_operations is used by the swap
subsystem to read/write the page contents from/into the corresponding
swap slot in the swap device.  To support the THP (Transparent Huge
Page) swap optimization, the .rw_page is enhanced to support to
read/write THP if possible.

Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@intel.com> [for brd.c, zram_drv.c, pmem.c]
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal L Verma <vishal.l.verma@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-nvdimm@lists.01.org
---
 drivers/block/brd.c           |  6 +++++-
 drivers/block/zram/zram_drv.c |  2 ++
 drivers/nvdimm/btt.c          |  4 +++-
 drivers/nvdimm/pmem.c         | 41 ++++++++++++++++++++++++++++++-----------
 4 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 104b71c0490d..5d9ed0616413 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -326,7 +326,11 @@ static int brd_rw_page(struct block_device *bdev, sector_t sector,
 		       struct page *page, bool is_write)
 {
 	struct brd_device *brd = bdev->bd_disk->private_data;
-	int err = brd_do_bvec(brd, page, PAGE_SIZE, 0, is_write, sector);
+	int err;
+
+	if (PageTransHuge(page))
+		return -ENOTSUPP;
+	err = brd_do_bvec(brd, page, PAGE_SIZE, 0, is_write, sector);
 	page_endio(page, is_write, err);
 	return err;
 }
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 856d5dc02451..e2a305b41cd4 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -927,6 +927,8 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	struct zram *zram;
 	struct bio_vec bv;
 
+	if (PageTransHuge(page))
+		return -ENOTSUPP;
 	zram = bdev->bd_disk->private_data;
 
 	if (!valid_io_request(zram, sector, PAGE_SIZE)) {
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 14323faf8bd9..60491641a8d6 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1241,8 +1241,10 @@ static int btt_rw_page(struct block_device *bdev, sector_t sector,
 {
 	struct btt *btt = bdev->bd_disk->private_data;
 	int rc;
+	unsigned int len;
 
-	rc = btt_do_bvec(btt, NULL, page, PAGE_SIZE, 0, is_write, sector);
+	len = hpage_nr_pages(page) * PAGE_SIZE;
+	rc = btt_do_bvec(btt, NULL, page, len, 0, is_write, sector);
 	if (rc == 0)
 		page_endio(page, is_write, 0);
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index f7099adaabc0..e9aa453da50c 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -80,22 +80,40 @@ static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
 static void write_pmem(void *pmem_addr, struct page *page,
 		unsigned int off, unsigned int len)
 {
-	void *mem = kmap_atomic(page);
-
-	memcpy_flushcache(pmem_addr, mem + off, len);
-	kunmap_atomic(mem);
+	unsigned int chunk;
+	void *mem;
+
+	while (len) {
+		mem = kmap_atomic(page);
+		chunk = min_t(unsigned int, len, PAGE_SIZE);
+		memcpy_flushcache(pmem_addr, mem + off, chunk);
+		kunmap_atomic(mem);
+		len -= chunk;
+		off = 0;
+		page++;
+		pmem_addr += PAGE_SIZE;
+	}
 }
 
 static blk_status_t read_pmem(struct page *page, unsigned int off,
 		void *pmem_addr, unsigned int len)
 {
+	unsigned int chunk;
 	int rc;
-	void *mem = kmap_atomic(page);
-
-	rc = memcpy_mcsafe(mem + off, pmem_addr, len);
-	kunmap_atomic(mem);
-	if (rc)
-		return BLK_STS_IOERR;
+	void *mem;
+
+	while (len) {
+		mem = kmap_atomic(page);
+		chunk = min_t(unsigned int, len, PAGE_SIZE);
+		rc = memcpy_mcsafe(mem + off, pmem_addr, chunk);
+		kunmap_atomic(mem);
+		if (rc)
+			return BLK_STS_IOERR;
+		len -= chunk;
+		off = 0;
+		page++;
+		pmem_addr += PAGE_SIZE;
+	}
 	return BLK_STS_OK;
 }
 
@@ -188,7 +206,8 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	struct pmem_device *pmem = bdev->bd_queue->queuedata;
 	blk_status_t rc;
 
-	rc = pmem_do_bvec(pmem, page, PAGE_SIZE, 0, is_write, sector);
+	rc = pmem_do_bvec(pmem, page, hpage_nr_pages(page) * PAGE_SIZE,
+			  0, is_write, sector);
 
 	/*
 	 * The ->rw_page interface is subtle and tricky.  The core
-- 
2.13.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
