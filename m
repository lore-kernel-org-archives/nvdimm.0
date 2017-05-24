Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E38F21B0E535
 for <linux-nvdimm@lists.01.org>; Wed, 24 May 2017 14:43:20 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Wed, 24 May 2017 15:42:22 -0600
Message-Id: <1495662147-18277-12-git-send-email-logang@deltatee.com>
In-Reply-To: <1495662147-18277-1-git-send-email-logang@deltatee.com>
References: <1495662147-18277-1-git-send-email-logang@deltatee.com>
Subject: [RFC PATCH 11/16] bvec: convert to using pfn_t internally
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
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Berg <johannes.berg@intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ming Lei <ming.lei@canonical.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

With bv_page fenced off, we can now convert it to a pfn_t fairly simply.
Everything should work the same with the exception of a BUG_ON
for potentially unmappable pfns.

A couple of initializers that assign {NULL} to a bio_vec had to also be
changed to {} to prevent a warning seeing pfn_t is actually a struct.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 block/blk-integrity.c |  4 ++--
 block/blk-merge.c     |  6 +++---
 include/linux/bvec.h  | 13 +++++++++----
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 857138a..2ba66f7 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -40,7 +40,7 @@
  */
 int blk_rq_count_integrity_sg(struct request_queue *q, struct bio *bio)
 {
-	struct bio_vec iv, ivprv = { NULL };
+	struct bio_vec iv, ivprv = {};
 	unsigned int segments = 0;
 	unsigned int seg_size = 0;
 	struct bvec_iter iter;
@@ -86,7 +86,7 @@ EXPORT_SYMBOL(blk_rq_count_integrity_sg);
 int blk_rq_map_integrity_sg(struct request_queue *q, struct bio *bio,
 			    struct scatterlist *sglist)
 {
-	struct bio_vec iv, ivprv = { NULL };
+	struct bio_vec iv, ivprv = {};
 	struct scatterlist *sg = NULL;
 	unsigned int segments = 0;
 	struct bvec_iter iter;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 65dcee9..93e87fe 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -245,7 +245,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 					     struct bio *bio,
 					     bool no_sg_merge)
 {
-	struct bio_vec bv, bvprv = { NULL };
+	struct bio_vec bv, bvprv = {};
 	int cluster, prev = 0;
 	unsigned int seg_size, nr_phys_segs;
 	struct bio *fbio, *bbio;
@@ -347,7 +347,7 @@ EXPORT_SYMBOL(blk_recount_segments);
 static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
 				   struct bio *nxt)
 {
-	struct bio_vec end_bv = { NULL }, nxt_bv;
+	struct bio_vec end_bv = {}, nxt_bv;
 
 	if (!blk_queue_cluster(q))
 		return 0;
@@ -430,7 +430,7 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 			     struct scatterlist *sglist,
 			     struct scatterlist **sg)
 {
-	struct bio_vec bvec, bvprv = { NULL };
+	struct bio_vec bvec, bvprv = {};
 	struct bvec_iter iter;
 	int cluster = blk_queue_cluster(q), nsegs = 0;
 
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index b53b879..d950288 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -22,12 +22,13 @@
 
 #include <linux/kernel.h>
 #include <linux/bug.h>
+#include <linux/pfn_t.h>
 
 /*
  * was unsigned short, but we might as well be ready for > 64kB I/O pages
  */
 struct bio_vec {
-	struct page	*bv_page;
+	pfn_t		bv_pfn;
 	unsigned int	bv_len;
 	unsigned int	bv_offset;
 };
@@ -45,12 +46,13 @@ struct bvec_iter {
 
 static inline struct page *bvec_page(const struct bio_vec *bvec)
 {
-	return bvec->bv_page;
+	BUG_ON(!pfn_t_is_always_mappable(bvec->bv_pfn));
+	return pfn_t_to_page(bvec->bv_pfn);
 }
 
 static inline void bvec_set_page(struct bio_vec *bvec, struct page *page)
 {
-	bvec->bv_page = page;
+	bvec->bv_pfn = page_to_pfn_t(page);
 }
 
 /*
@@ -59,6 +61,9 @@ static inline void bvec_set_page(struct bio_vec *bvec, struct page *page)
  */
 #define __bvec_iter_bvec(bvec, iter)	(&(bvec)[(iter).bi_idx])
 
+#define bvec_iter_pfn_t(bvec, iter)				\
+	(__bvec_iter_bvec((bvec), (iter))->bv_pfn)
+
 #define bvec_iter_page(bvec, iter)				\
 	(bvec_page(__bvec_iter_bvec((bvec), (iter))))
 
@@ -71,7 +76,7 @@ static inline void bvec_set_page(struct bio_vec *bvec, struct page *page)
 
 #define bvec_iter_bvec(bvec, iter)				\
 ((struct bio_vec) {						\
-	.bv_page	= bvec_iter_page((bvec), (iter)),	\
+	.bv_pfn		= bvec_iter_pfn_t((bvec), (iter)),	\
 	.bv_len		= bvec_iter_len((bvec), (iter)),	\
 	.bv_offset	= bvec_iter_offset((bvec), (iter)),	\
 })
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
