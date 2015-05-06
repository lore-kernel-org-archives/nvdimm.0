Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 03/10] block: convert .bv_page to .bv_pfn bio_vec
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 06 May 2015 16:05:12 -0400
Message-ID: <20150506200511.40425.85612.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, riel@redhat.com, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, hch@lst.de, Julia Lawall <Julia.Lawall@lip6.fr>, mgorman@suse.de, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, akpm@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Carry an __pfn_t in a bio_vec rather than a 'struct page *' in support
of allowing a bio to reference unmapped (not struct page backed)
persistent memory.

This also fixes up the macros and static initializers that we were not
automatically converted by the Coccinelle script that introduced the
bvec_page() and bvec_set_page() helpers.

If CONFIG_PMEM_IO=n this is functionally equivalent to the status quo as
the __pfn_t helpers can assume that a __pfn_t always has a corresponding
struct page.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/blk-integrity.c     |    4 ++--
 block/blk-merge.c         |    6 +++---
 block/bounce.c            |    2 +-
 drivers/md/bcache/btree.c |    2 +-
 include/linux/bio.h       |   24 +++++++++++++-----------
 include/linux/blk_types.h |   13 ++++++++++---
 lib/iov_iter.c            |   22 +++++++++++-----------
 mm/page_io.c              |    4 ++--
 8 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 0458f31f075a..351198fbda3c 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -43,7 +43,7 @@ static const char *bi_unsupported_name = "unsupported";
  */
 int blk_rq_count_integrity_sg(struct request_queue *q, struct bio *bio)
 {
-	struct bio_vec iv, ivprv = { NULL };
+	struct bio_vec iv, ivprv = BIO_VEC_INIT(ivprv);
 	unsigned int segments = 0;
 	unsigned int seg_size = 0;
 	struct bvec_iter iter;
@@ -89,7 +89,7 @@ EXPORT_SYMBOL(blk_rq_count_integrity_sg);
 int blk_rq_map_integrity_sg(struct request_queue *q, struct bio *bio,
 			    struct scatterlist *sglist)
 {
-	struct bio_vec iv, ivprv = { NULL };
+	struct bio_vec iv, ivprv = BIO_VEC_INIT(ivprv);
 	struct scatterlist *sg = NULL;
 	unsigned int segments = 0;
 	struct bvec_iter iter;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 47ceefacd320..218ad1e57a49 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -13,7 +13,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 					     struct bio *bio,
 					     bool no_sg_merge)
 {
-	struct bio_vec bv, bvprv = { NULL };
+	struct bio_vec bv, bvprv = BIO_VEC_INIT(bvprv);
 	int cluster, high, highprv = 1;
 	unsigned int seg_size, nr_phys_segs;
 	struct bio *fbio, *bbio;
@@ -123,7 +123,7 @@ EXPORT_SYMBOL(blk_recount_segments);
 static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
 				   struct bio *nxt)
 {
-	struct bio_vec end_bv = { NULL }, nxt_bv;
+	struct bio_vec end_bv = BIO_VEC_INIT(end_bv), nxt_bv;
 	struct bvec_iter iter;
 
 	if (!blk_queue_cluster(q))
@@ -202,7 +202,7 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 			     struct scatterlist *sglist,
 			     struct scatterlist **sg)
 {
-	struct bio_vec bvec, bvprv = { NULL };
+	struct bio_vec bvec, bvprv = BIO_VEC_INIT(bvprv);
 	struct bvec_iter iter;
 	int nsegs, cluster;
 
diff --git a/block/bounce.c b/block/bounce.c
index 0390e44d6e1b..4a3098067c81 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -64,7 +64,7 @@ static void bounce_copy_vec(struct bio_vec *to, unsigned char *vfrom)
 #else /* CONFIG_HIGHMEM */
 
 #define bounce_copy_vec(to, vfrom)	\
-	memcpy(page_address((to)->bv_page) + (to)->bv_offset, vfrom, (to)->bv_len)
+	memcpy(page_address(bvec_page(to)) + (to)->bv_offset, vfrom, (to)->bv_len)
 
 #endif /* CONFIG_HIGHMEM */
 
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 2e76e8b62902..36bbe29a806b 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -426,7 +426,7 @@ static void do_btree_node_write(struct btree *b)
 		void *base = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
 
 		bio_for_each_segment_all(bv, b->bio, j)
-			memcpy(page_address(bv->bv_page),
+			memcpy(page_address(bvec_page(bv)),
 			       base + j * PAGE_SIZE, PAGE_SIZE);
 
 		bch_submit_bbio(b->bio, b->c, &k.key, 0);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index da3a127c9958..a59d97cbfe13 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -63,8 +63,8 @@
  */
 #define __bvec_iter_bvec(bvec, iter)	(&(bvec)[(iter).bi_idx])
 
-#define bvec_iter_page(bvec, iter)				\
-	(__bvec_iter_bvec((bvec), (iter))->bv_page)
+#define bvec_iter_pfn(bvec, iter)				\
+	(__bvec_iter_bvec((bvec), (iter))->bv_pfn)
 
 #define bvec_iter_len(bvec, iter)				\
 	min((iter).bi_size,					\
@@ -75,7 +75,7 @@
 
 #define bvec_iter_bvec(bvec, iter)				\
 ((struct bio_vec) {						\
-	.bv_page	= bvec_iter_page((bvec), (iter)),	\
+	.bv_pfn		= bvec_iter_pfn((bvec), (iter)),	\
 	.bv_len		= bvec_iter_len((bvec), (iter)),	\
 	.bv_offset	= bvec_iter_offset((bvec), (iter)),	\
 })
@@ -83,14 +83,16 @@
 #define bio_iter_iovec(bio, iter)				\
 	bvec_iter_bvec((bio)->bi_io_vec, (iter))
 
-#define bio_iter_page(bio, iter)				\
-	bvec_iter_page((bio)->bi_io_vec, (iter))
+#define bio_iter_pfn(bio, iter)				\
+	bvec_iter_pfn((bio)->bi_io_vec, (iter))
 #define bio_iter_len(bio, iter)					\
 	bvec_iter_len((bio)->bi_io_vec, (iter))
 #define bio_iter_offset(bio, iter)				\
 	bvec_iter_offset((bio)->bi_io_vec, (iter))
 
-#define bio_page(bio)		bio_iter_page((bio), (bio)->bi_iter)
+#define bio_page(bio)	\
+		pfn_to_page((bio_iter_pfn((bio), (bio)->bi_iter)).pfn)
+#define bio_pfn(bio)		bio_iter_pfn((bio), (bio)->bi_iter)
 #define bio_offset(bio)		bio_iter_offset((bio), (bio)->bi_iter)
 #define bio_iovec(bio)		bio_iter_iovec((bio), (bio)->bi_iter)
 
@@ -150,8 +152,8 @@ static inline void *bio_data(struct bio *bio)
 /*
  * will die
  */
-#define bio_to_phys(bio)	(page_to_phys(bio_page((bio))) + (unsigned long) bio_offset((bio)))
-#define bvec_to_phys(bv)	(page_to_phys((bv)->bv_page) + (unsigned long) (bv)->bv_offset)
+#define bio_to_phys(bio)	(__pfn_t_to_phys(bio_pfn((bio))) + (unsigned long) bio_offset((bio)))
+#define bvec_to_phys(bv)	(__pfn_t_to_phys((bv)->bv_pfn) + (unsigned long) (bv)->bv_offset)
 
 /*
  * queues that have highmem support enabled may still need to revert to
@@ -160,7 +162,7 @@ static inline void *bio_data(struct bio *bio)
  * I/O completely on that queue (see ide-dma for example)
  */
 #define __bio_kmap_atomic(bio, iter)				\
-	(kmap_atomic(bio_iter_iovec((bio), (iter)).bv_page) +	\
+	(kmap_atomic(bio_iter_iovec((bio), bvec_page(iter)) +	\
 		bio_iter_iovec((bio), (iter)).bv_offset)
 
 #define __bio_kunmap_atomic(addr)	kunmap_atomic(addr)
@@ -490,7 +492,7 @@ static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
 	 * balancing is a lot nicer this way
 	 */
 	local_irq_save(*flags);
-	addr = (unsigned long) kmap_atomic(bvec->bv_page);
+	addr = (unsigned long) kmap_atomic(bvec_page(bvec));
 
 	BUG_ON(addr & ~PAGE_MASK);
 
@@ -508,7 +510,7 @@ static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
 #else
 static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
 {
-	return page_address(bvec->bv_page) + bvec->bv_offset;
+	return page_address(bvec_page(bvec)) + bvec->bv_offset;
 }
 
 static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d7167b50299f..2a15c4943db6 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -6,6 +6,7 @@
 #define __LINUX_BLK_TYPES_H
 
 #include <linux/types.h>
+#include <linux/mm.h>
 
 struct bio_set;
 struct bio;
@@ -21,19 +22,25 @@ typedef void (bio_destructor_t) (struct bio *);
  * was unsigned short, but we might as well be ready for > 64kB I/O pages
  */
 struct bio_vec {
-	struct page	*bv_page;
+	__pfn_t		bv_pfn;
 	unsigned int	bv_len;
 	unsigned int	bv_offset;
 };
 
+#define BIO_VEC_INIT(name) { .bv_pfn = { .pfn = 0 }, .bv_len = 0, \
+	.bv_offset = 0 }
+
+#define BIO_VEC(name) \
+	struct bio_vec name = BIO_VEC_INIT(name)
+
 static inline struct page *bvec_page(const struct bio_vec *bvec)
 {
-	return bvec->bv_page;
+	return __pfn_t_to_page(bvec->bv_pfn);
 }
 
 static inline void bvec_set_page(struct bio_vec *bvec, struct page *page)
 {
-	bvec->bv_page = page;
+	bvec->bv_pfn = page_to_pfn_t(page);
 }
 
 #ifdef CONFIG_BLOCK
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 75232ad0a5e7..4276f6d1826c 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -61,7 +61,7 @@
 	__p = i->bvec;					\
 	__v.bv_len = min_t(size_t, n, __p->bv_len - skip);	\
 	if (likely(__v.bv_len)) {			\
-		__v.bv_page = __p->bv_page;		\
+		__v.bv_pfn = __p->bv_pfn;		\
 		__v.bv_offset = __p->bv_offset + skip; 	\
 		(void)(STEP);				\
 		skip += __v.bv_len;			\
@@ -72,7 +72,7 @@
 		__v.bv_len = min_t(size_t, n, __p->bv_len);	\
 		if (unlikely(!__v.bv_len))		\
 			continue;			\
-		__v.bv_page = __p->bv_page;		\
+		__v.bv_pfn = __p->bv_pfn;		\
 		__v.bv_offset = __p->bv_offset;		\
 		(void)(STEP);				\
 		skip = __v.bv_len;			\
@@ -395,7 +395,7 @@ size_t copy_to_iter(void *addr, size_t bytes, struct iov_iter *i)
 	iterate_and_advance(i, bytes, v,
 		__copy_to_user(v.iov_base, (from += v.iov_len) - v.iov_len,
 			       v.iov_len),
-		memcpy_to_page(v.bv_page, v.bv_offset,
+		memcpy_to_page(bvec_page(&v), v.bv_offset,
 			       (from += v.bv_len) - v.bv_len, v.bv_len),
 		memcpy(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len)
 	)
@@ -416,7 +416,7 @@ size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 	iterate_and_advance(i, bytes, v,
 		__copy_from_user((to += v.iov_len) - v.iov_len, v.iov_base,
 				 v.iov_len),
-		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((to += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -437,7 +437,7 @@ size_t copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i)
 	iterate_and_advance(i, bytes, v,
 		__copy_from_user_nocache((to += v.iov_len) - v.iov_len,
 					 v.iov_base, v.iov_len),
-		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((to += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -482,7 +482,7 @@ size_t iov_iter_zero(size_t bytes, struct iov_iter *i)
 
 	iterate_and_advance(i, bytes, v,
 		__clear_user(v.iov_base, v.iov_len),
-		memzero_page(v.bv_page, v.bv_offset, v.bv_len),
+		memzero_page(bvec_page(&v), v.bv_offset, v.bv_len),
 		memset(v.iov_base, 0, v.iov_len)
 	)
 
@@ -497,7 +497,7 @@ size_t iov_iter_copy_from_user_atomic(struct page *page,
 	iterate_all_kinds(i, bytes, v,
 		__copy_from_user_inatomic((p += v.iov_len) - v.iov_len,
 					  v.iov_base, v.iov_len),
-		memcpy_from_page((p += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((p += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((p += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -596,7 +596,7 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 	0;}),({
 		/* can't be more than PAGE_SIZE */
 		*start = v.bv_offset;
-		get_page(*pages = v.bv_page);
+		get_page(*pages = bvec_page(&v));
 		return v.bv_len;
 	}),({
 		return -EFAULT;
@@ -650,7 +650,7 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 		*pages = p = get_pages_array(1);
 		if (!p)
 			return -ENOMEM;
-		get_page(*p = v.bv_page);
+		get_page(*p = bvec_page(&v));
 		return v.bv_len;
 	}),({
 		return -EFAULT;
@@ -684,7 +684,7 @@ size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum,
 		}
 		err ? v.iov_len : 0;
 	}), ({
-		char *p = kmap_atomic(v.bv_page);
+		char *p = kmap_atomic(bvec_page(&v));
 		next = csum_partial_copy_nocheck(p + v.bv_offset,
 						 (to += v.bv_len) - v.bv_len,
 						 v.bv_len, 0);
@@ -728,7 +728,7 @@ size_t csum_and_copy_to_iter(void *addr, size_t bytes, __wsum *csum,
 		}
 		err ? v.iov_len : 0;
 	}), ({
-		char *p = kmap_atomic(v.bv_page);
+		char *p = kmap_atomic(bvec_page(&v));
 		next = csum_partial_copy_nocheck((from += v.bv_len) - v.bv_len,
 						 p + v.bv_offset,
 						 v.bv_len, 0);
diff --git a/mm/page_io.c b/mm/page_io.c
index 75738896b691..33c248527fd2 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -265,8 +265,8 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 		struct bio_vec bv = {
-			.bv_page = page,
-			.bv_len  = PAGE_SIZE,
+			.bv_pfn = page_to_pfn_t(page),
+			.bv_len = PAGE_SIZE,
 			.bv_offset = 0
 		};
 		struct iov_iter from;

