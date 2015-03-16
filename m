Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [RFC PATCH 2/7] block: convert bio_vec.bv_page to bv_pfn
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 Mar 2015 16:25:37 -0400
Message-ID: <20150316202537.33102.12944.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, axboe@kernel.dk, riel@redhat.com, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, hch@infradead.org, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Carry a pfn in a bio_vec rather than a page in support of allowing
bio(s) to reference unmapped (not struct page backed) persistent memory.

As Dave Hansen points out, it would be unfortunate if we ended up with
less type safety after this conversion, so introduce __pfn_t.

Cc: Matthew Wilcox <willy@linux.intel.com>
[willy: use pfn_t]
[kvm: "no, use __pfn_t, we already stole pfn_t"]
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/bio.c                        |    1 +
 block/blk-integrity.c              |    4 ++--
 block/blk-merge.c                  |    6 +++---
 block/bounce.c                     |    2 +-
 drivers/md/bcache/btree.c          |    2 +-
 include/asm-generic/memory_model.h |    4 ++++
 include/linux/bio.h                |   20 +++++++++++---------
 include/linux/blk_types.h          |   14 +++++++++++---
 include/linux/scatterlist.h        |   16 ++++++++++++++++
 include/linux/swiotlb.h            |    1 +
 mm/iov_iter.c                      |   22 +++++++++++-----------
 mm/page_io.c                       |    2 +-
 12 files changed, 63 insertions(+), 31 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 7100fd6d5898..3d494e85e16d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -28,6 +28,7 @@
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
+#include <linux/scatterlist.h>
 
 #include <trace/events/block.h>
 
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 6c8b1d63e90b..34e53951a0d1 100644
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
index 39bd9925c057..8420d553b8ef 100644
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
diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
index 14909b0b9cae..e6c2fda25820 100644
--- a/include/asm-generic/memory_model.h
+++ b/include/asm-generic/memory_model.h
@@ -72,6 +72,10 @@
 #define page_to_pfn __page_to_pfn
 #define pfn_to_page __pfn_to_page
 
+typedef struct {
+	unsigned long pfn;
+} __pfn_t;
+
 #endif /* __ASSEMBLY__ */
 
 #endif
diff --git a/include/linux/bio.h b/include/linux/bio.h
index f6a2427980f3..f35c90d5fd4d 100644
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
+#define bio_to_phys(bio)	(pfn_to_phys(bio_pfn((bio))) + (unsigned long) bio_offset((bio)))
+#define bvec_to_phys(bv)	(pfn_to_phys((bv)->bv_pfn) + (unsigned long) (bv)->bv_offset)
 
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
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 3193a0b7051f..7f63fa3e4fda 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -5,7 +5,9 @@
 #ifndef __LINUX_BLK_TYPES_H
 #define __LINUX_BLK_TYPES_H
 
+#include <linux/scatterlist.h>
 #include <linux/types.h>
+#include <asm/pgtable.h>
 
 struct bio_set;
 struct bio;
@@ -21,19 +23,25 @@ typedef void (bio_destructor_t) (struct bio *);
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
+	return pfn_to_page(bvec->bv_pfn.pfn);
 }
 
 static inline void bvec_set_page(struct bio_vec *bvec, struct page *page)
 {
-	bvec->bv_page = page;
+	bvec->bv_pfn = page_to_pfn_typed(page);
 }
 
 #ifdef CONFIG_BLOCK
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index ed8f9e70df9b..5a15b1ce3c9e 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -9,6 +9,22 @@
 #include <asm/scatterlist.h>
 #include <asm/io.h>
 
+#ifndef __pfn_to_phys
+#define __pfn_to_phys(pfn)      ((dma_addr_t)(pfn) << PAGE_SHIFT)
+#endif
+
+static inline dma_addr_t pfn_to_phys(__pfn_t pfn)
+{
+	return __pfn_to_phys(pfn.pfn);
+}
+
+static inline __pfn_t page_to_pfn_typed(struct page *page)
+{
+	__pfn_t pfn = { .pfn = page_to_pfn(page) };
+
+	return pfn;
+}
+
 struct sg_table {
 	struct scatterlist *sgl;	/* the list */
 	unsigned int nents;		/* number of mapped entries */
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index e7a018eaf3a2..dc3a94ce3b45 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_SWIOTLB_H
 #define __LINUX_SWIOTLB_H
 
+#include <linux/dma-direction.h>
 #include <linux/types.h>
 
 struct device;
diff --git a/mm/iov_iter.c b/mm/iov_iter.c
index 827732047da1..be9a7c5b8703 100644
--- a/mm/iov_iter.c
+++ b/mm/iov_iter.c
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
@@ -369,7 +369,7 @@ size_t copy_to_iter(void *addr, size_t bytes, struct iov_iter *i)
 	iterate_and_advance(i, bytes, v,
 		__copy_to_user(v.iov_base, (from += v.iov_len) - v.iov_len,
 			       v.iov_len),
-		memcpy_to_page(v.bv_page, v.bv_offset,
+		memcpy_to_page(bvec_page(&v), v.bv_offset,
 			       (from += v.bv_len) - v.bv_len, v.bv_len),
 		memcpy(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len)
 	)
@@ -390,7 +390,7 @@ size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 	iterate_and_advance(i, bytes, v,
 		__copy_from_user((to += v.iov_len) - v.iov_len, v.iov_base,
 				 v.iov_len),
-		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((to += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -411,7 +411,7 @@ size_t copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i)
 	iterate_and_advance(i, bytes, v,
 		__copy_from_user_nocache((to += v.iov_len) - v.iov_len,
 					 v.iov_base, v.iov_len),
-		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((to += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -456,7 +456,7 @@ size_t iov_iter_zero(size_t bytes, struct iov_iter *i)
 
 	iterate_and_advance(i, bytes, v,
 		__clear_user(v.iov_base, v.iov_len),
-		memzero_page(v.bv_page, v.bv_offset, v.bv_len),
+		memzero_page(bvec_page(&v), v.bv_offset, v.bv_len),
 		memset(v.iov_base, 0, v.iov_len)
 	)
 
@@ -471,7 +471,7 @@ size_t iov_iter_copy_from_user_atomic(struct page *page,
 	iterate_all_kinds(i, bytes, v,
 		__copy_from_user_inatomic((p += v.iov_len) - v.iov_len,
 					  v.iov_base, v.iov_len),
-		memcpy_from_page((p += v.bv_len) - v.bv_len, v.bv_page,
+		memcpy_from_page((p += v.bv_len) - v.bv_len, bvec_page(&v),
 				 v.bv_offset, v.bv_len),
 		memcpy((p += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
@@ -570,7 +570,7 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 	0;}),({
 		/* can't be more than PAGE_SIZE */
 		*start = v.bv_offset;
-		get_page(*pages = v.bv_page);
+		get_page(*pages = bvec_page(&v));
 		return v.bv_len;
 	}),({
 		return -EFAULT;
@@ -624,7 +624,7 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 		*pages = p = get_pages_array(1);
 		if (!p)
 			return -ENOMEM;
-		get_page(*p = v.bv_page);
+		get_page(*p = bvec_page(&v));
 		return v.bv_len;
 	}),({
 		return -EFAULT;
@@ -658,7 +658,7 @@ size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum,
 		}
 		err ? v.iov_len : 0;
 	}), ({
-		char *p = kmap_atomic(v.bv_page);
+		char *p = kmap_atomic(bvec_page(&v));
 		next = csum_partial_copy_nocheck(p + v.bv_offset,
 						 (to += v.bv_len) - v.bv_len,
 						 v.bv_len, 0);
@@ -702,7 +702,7 @@ size_t csum_and_copy_to_iter(void *addr, size_t bytes, __wsum *csum,
 		}
 		err ? v.iov_len : 0;
 	}), ({
-		char *p = kmap_atomic(v.bv_page);
+		char *p = kmap_atomic(bvec_page(&v));
 		next = csum_partial_copy_nocheck((from += v.bv_len) - v.bv_len,
 						 p + v.bv_offset,
 						 v.bv_len, 0);
diff --git a/mm/page_io.c b/mm/page_io.c
index c540dbc6a9e5..b7c8d2c3f8f9 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -265,7 +265,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 		struct bio_vec bv = {
-			.bv_page = page,
+			.bv_pfn = page_to_pfn_typed(page),
 			.bv_len  = PAGE_SIZE,
 			.bv_offset = 0
 		};

