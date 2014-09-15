Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Subject: RE: [PATCH] SQUASHME: pmem: no need to copy a page at a time
Date: Mon, 15 Sep 2014 00:23:33 +0000
Message-ID: <100D68C7BA14664A8938383216E40DE0407E3B06@FMSMSX114.amr.corp.intel.com>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
 <540F1EC6.4000504@plexistor.com> <54108149.3060506@plexistor.com>
 <5415AD2C.6040004@plexistor.com>,<5415BC2A.7090003@plexistor.com>
In-Reply-To: <5415BC2A.7090003@plexistor.com>
Content-Language: en-CA
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Ummpf.  No.  The current code needs a cond_resched() thrown into that loop, but we can't afford the latency of calling memcpy() for a potentially 2GB+ write.  (current CPUs have memory bandwidth somewhere around 20GB/s, iirc, so that would take a tenth of a second; utterly unacceptalbe scheduling latency).

Also, copying to pmem should be using cache-bypassing stores, since there's not going to be any discernible benefit to having this data in cache.  Copying from pmem is arguable ... surely it's being read so that it can be used, but on the other hand if we have a 2GB write, we're going to blow away the entire LLC.

________________________________________
From: Boaz Harrosh [boaz@plexistor.com]
Sent: September 14, 2014 9:02 AM
To: Ross Zwisler
Cc: Jens Axboe; Wilcox, Matthew R; linux-fsdevel; linux-nvdimm@lists.01.org
Subject: [PATCH] SQUASHME: pmem: no need to copy a page at a time

With current code structure a single pmem device always spans
a single contiguous memory range both in the physical as well
as the Kernel virtual space. So this means a contiguous block's
sectors means contiguous virtual addressing.

So we do not need to memcpy a page boundary at a time we can
memcpy any arbitrary memory range.

TODO: Further optimization can be done at callers of
        copy_to/from_pmem

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/pmem.c | 37 +++----------------------------------
 1 file changed, 3 insertions(+), 34 deletions(-)

diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index 8e15c19..780ed94 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -56,12 +56,10 @@ static int pmem_getgeo(struct block_device *bd, struct hd_geometry *geo)
 /*
  * direct translation from (pmem,sector) => void*
  * We do not require that sector be page aligned.
- * The return value will point to the beginning of the page containing the
- * given sector, not to the sector itself.
  */
 static void *pmem_lookup_pg_addr(struct pmem_device *pmem, sector_t sector)
 {
-       size_t offset = round_down(sector << SECTOR_SHIFT, PAGE_SIZE);
+       size_t offset = sector << SECTOR_SHIFT;

        BUG_ON(offset >= pmem->size);
        return pmem->virt_addr + offset;
@@ -69,55 +67,26 @@ static void *pmem_lookup_pg_addr(struct pmem_device *pmem, sector_t sector)

 /*
  * sector is not required to be page aligned.
- * n is at most a single page, but could be less.
  */
 static void copy_to_pmem(struct pmem_device *pmem, const void *src,
                        sector_t sector, size_t n)
 {
        void *dst;
-       unsigned int offset = (sector & (PAGE_SECTORS - 1)) << SECTOR_SHIFT;
-       size_t copy;
-
-       BUG_ON(n > PAGE_SIZE);

-       copy = min_t(size_t, n, PAGE_SIZE - offset);
        dst = pmem_lookup_pg_addr(pmem, sector);
-       memcpy(dst + offset, src, copy);
-
-       if (copy < n) {
-               src += copy;
-               sector += copy >> SECTOR_SHIFT;
-               copy = n - copy;
-               dst = pmem_lookup_pg_addr(pmem, sector);
-               memcpy(dst, src, copy);
-       }
+       memcpy(dst, src, n);
 }

 /*
  * sector is not required to be page aligned.
- * n is at most a single page, but could be less.
  */
 static void copy_from_pmem(void *dst, struct pmem_device *pmem,
                          sector_t sector, size_t n)
 {
        void *src;
-       unsigned int offset = (sector & (PAGE_SECTORS - 1)) << SECTOR_SHIFT;
-       size_t copy;
-
-       BUG_ON(n > PAGE_SIZE);

-       copy = min_t(size_t, n, PAGE_SIZE - offset);
        src = pmem_lookup_pg_addr(pmem, sector);
-
-       memcpy(dst, src + offset, copy);
-
-       if (copy < n) {
-               dst += copy;
-               sector += copy >> SECTOR_SHIFT;
-               copy = n - copy;
-               src = pmem_lookup_pg_addr(pmem, sector);
-               memcpy(dst, src, copy);
-       }
+       memcpy(dst, src, n);
 }

 static void pmem_do_bvec(struct pmem_device *pmem, struct page *page,
--
1.9.3

