Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v3 09/11] block: convert kmap helpers to kmap_atomic_pfn_t()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 May 2015 00:30:17 -0400
Message-ID: <20150512043017.11521.98110.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150512042629.11521.70356.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150512042629.11521.70356.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, axboe@kernel.dk, riel@redhat.com, linux-nvdimm@lists.01.org, david@fromorbit.com, hch@lst.de, j.glisse@gmail.com, mgorman@suse.de, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Convert the generic helpers to the __pfn_t version of kmap_atomic() in
support of generically enabling "page-less" block i/o.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/bio.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index a569e6ea1cd2..6537d78e78b3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -161,7 +161,7 @@ static inline void *bio_data(struct bio *bio)
  * I/O completely on that queue (see ide-dma for example)
  */
 #define __bio_kmap_atomic(bio, iter)				\
-	(kmap_atomic(bvec_page(bio_iter_iovec((bio), (iter)))) +   \
+	(kmap_atomic_pfn_t(bio_iter_iovec((bio), (iter)).pfn) +   \
 		bio_iter_iovec((bio), (iter)).bv_offset)
 
 #define __bio_kunmap_atomic(addr)	kunmap_atomic(addr)
@@ -491,7 +491,7 @@ static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
 	 * balancing is a lot nicer this way
 	 */
 	local_irq_save(*flags);
-	addr = (unsigned long) kmap_atomic(bvec_page(bvec));
+	addr = (unsigned long) kmap_atomic_pfn_t(bvec.pfn);
 
 	BUG_ON(addr & ~PAGE_MASK);
 
@@ -502,18 +502,21 @@ static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
 {
 	unsigned long ptr = (unsigned long) buffer & PAGE_MASK;
 
-	kunmap_atomic((void *) ptr);
+	kunmap_atomic_pfn_t((void *) ptr);
 	local_irq_restore(*flags);
 }
 
 #else
 static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
 {
-	return page_address(bvec_page(bvec)) + bvec->bv_offset;
+	return kmap_atomic_pfn_t(bvec->bv_pfn) + bvec->bv_offset;
 }
 
 static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
 {
+	unsigned long ptr = (unsigned long) buffer & PAGE_MASK;
+
+	kunmap_atomic_pfn_t((void *) ptr);
 	*flags = 0;
 }
 #endif

