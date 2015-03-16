Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [RFC PATCH 5/7] scatterlist: support "page-less" (__pfn_t only)
 entries
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 Mar 2015 16:25:54 -0400
Message-ID: <20150316202554.33102.66745.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org, riel@redhat.com, linux-nvdimm@lists.01.org, linux-raid@vger.kernel.org, mgorman@suse.de, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Matthew Wilcox <willy@linux.intel.com>

Given that an offset will never be more than PAGE_SIZE, steal the unused
bits of the offset to implement a flags field.  Move the existing "this
is a sg_chain() entry" flag to the new flags field, and add a new flag
(SG_FLAGS_PAGE) to indicate that there is a struct page backing for the
entry.

[djbw: convert to pfn_to_phys() / HAVE_DMA_PFN]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 block/blk-merge.c                 |    2 -
 drivers/dma/ste_dma40.c           |    5 --
 drivers/mmc/card/queue.c          |    4 +-
 include/asm-generic/scatterlist.h |    6 +++
 include/crypto/scatterwalk.h      |   10 ++++
 include/linux/scatterlist.h       |   85 ++++++++++++++++++++++++++++++++++---
 6 files changed, 97 insertions(+), 15 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 8420d553b8ef..727a30aa5990 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -267,7 +267,7 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 		if (rq->cmd_flags & REQ_WRITE)
 			memset(q->dma_drain_buffer, 0, q->dma_drain_size);
 
-		sg->page_link &= ~0x02;
+		sg_unmark_end(sg);
 		sg = sg_next(sg);
 		sg_set_page(sg, virt_to_page(q->dma_drain_buffer),
 			    q->dma_drain_size,
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 68aca3334a17..7c28467eb366 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2560,10 +2560,7 @@ dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 		dma_addr += period_len;
 	}
 
-	sg[periods].offset = 0;
-	sg_dma_len(&sg[periods]) = 0;
-	sg[periods].page_link =
-		((unsigned long)sg | 0x01) & ~0x02;
+	sg_chain(sg, periods + 1, sg);
 
 	txd = d40_prep_sg(chan, sg, sg, periods, direction,
 			  DMA_PREP_INTERRUPT);
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 236d194c2883..127f76294e71 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -469,7 +469,7 @@ static unsigned int mmc_queue_packed_map_sg(struct mmc_queue *mq,
 			sg_set_buf(__sg, buf + offset, len);
 			offset += len;
 			remain -= len;
-			(__sg++)->page_link &= ~0x02;
+			sg_unmark_end(__sg++);
 			sg_len++;
 		} while (remain);
 	}
@@ -477,7 +477,7 @@ static unsigned int mmc_queue_packed_map_sg(struct mmc_queue *mq,
 	list_for_each_entry(req, &packed->list, queuelist) {
 		sg_len += blk_rq_map_sg(mq->queue, req, __sg);
 		__sg = sg + (sg_len - 1);
-		(__sg++)->page_link &= ~0x02;
+		sg_unmark_end(__sg++);
 	}
 	sg_mark_end(sg + (sg_len - 1));
 	return sg_len;
diff --git a/include/asm-generic/scatterlist.h b/include/asm-generic/scatterlist.h
index 5de07355fad4..51174ad11664 100644
--- a/include/asm-generic/scatterlist.h
+++ b/include/asm-generic/scatterlist.h
@@ -7,8 +7,14 @@ struct scatterlist {
 #ifdef CONFIG_DEBUG_SG
 	unsigned long	sg_magic;
 #endif
+#ifdef CONFIG_HAVE_DMA_PFN
+	__pfn_t		pfn;
+	unsigned short	offset;
+	unsigned short	sg_flags;
+#else
 	unsigned long	page_link;
 	unsigned int	offset;
+#endif
 	unsigned int	length;
 	dma_addr_t	dma_address;
 #ifdef CONFIG_NEED_SG_DMA_LENGTH
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 20e4226a2e14..7296d89a50b2 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -25,6 +25,15 @@
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 
+#ifdef CONFIG_HAVE_DMA_PFN
+/*
+ * If we're using PFNs, the architecture must also have been converted to
+ * support SG_CHAIN.  So we can use the generic code instead of custom
+ * code.
+ */
+#define scatterwalk_sg_chain(prv, num, sgl)	sg_chain(prv, num, sgl)
+#define scatterwalk_sg_next(sgl)		sg_next(sgl)
+#else
 static inline void scatterwalk_sg_chain(struct scatterlist *sg1, int num,
 					struct scatterlist *sg2)
 {
@@ -32,6 +41,7 @@ static inline void scatterwalk_sg_chain(struct scatterlist *sg1, int num,
 	sg1[num - 1].page_link &= ~0x02;
 	sg1[num - 1].page_link |= 0x01;
 }
+#endif
 
 static inline void scatterwalk_crypto_chain(struct scatterlist *head,
 					    struct scatterlist *sg,
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 5a15b1ce3c9e..891542c7dda0 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -5,6 +5,7 @@
 #include <linux/bug.h>
 #include <linux/mm.h>
 
+#include <asm/page.h>
 #include <asm/types.h>
 #include <asm/scatterlist.h>
 #include <asm/io.h>
@@ -34,8 +35,14 @@ struct sg_table {
 /*
  * Notes on SG table design.
  *
- * Architectures must provide an unsigned long page_link field in the
- * scatterlist struct. We use that to place the page pointer AND encode
+ * Architectures may define CONFIG_HAVE_DMA_PFN to indicate that they wish
+ * to support SGLs that point to pages which do not have a struct page to
+ * describe them.  If so, they should provide an sg_flags field in their
+ * scatterlist struct (see asm-generic for an example) as well as a pfn
+ * field.
+ *
+ * Otherwise, architectures must provide an unsigned long page_link field in
+ * the scatterlist struct. We use that to place the page pointer AND encode
  * information about the sg table as well. The two lower bits are reserved
  * for this information.
  *
@@ -49,16 +56,25 @@ struct sg_table {
  */
 
 #define SG_MAGIC	0x87654321
-
+#define SG_FLAGS_CHAIN	0x0001
+#define SG_FLAGS_LAST	0x0002
+#define SG_FLAGS_PAGE	0x0004
+
+#ifdef CONFIG_HAVE_DMA_PFN
+#define sg_is_chain(sg)		((sg)->sg_flags & SG_FLAGS_CHAIN)
+#define sg_is_last(sg)		((sg)->sg_flags & SG_FLAGS_LAST)
+#define sg_chain_ptr(sg)	((struct scatterlist *)((sg)->pfn.pfn))
+#else /* !CONFIG_HAVE_DMA_PFN */
 /*
  * We overload the LSB of the page pointer to indicate whether it's
  * a valid sg entry, or whether it points to the start of a new scatterlist.
  * Those low bits are there for everyone! (thanks mason :-)
  */
-#define sg_is_chain(sg)		((sg)->page_link & 0x01)
-#define sg_is_last(sg)		((sg)->page_link & 0x02)
+#define sg_is_chain(sg)		((sg)->page_link & SG_FLAGS_CHAIN)
+#define sg_is_last(sg)		((sg)->page_link & SG_FLAGS_LAST)
 #define sg_chain_ptr(sg)	\
 	((struct scatterlist *) ((sg)->page_link & ~0x03))
+#endif /* !CONFIG_HAVE_DMA_PFN */
 
 /**
  * sg_assign_page - Assign a given page to an SG entry
@@ -72,6 +88,14 @@ struct sg_table {
  **/
 static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
 {
+#ifdef CONFIG_HAVE_DMA_PFN
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+	BUG_ON(sg_is_chain(sg));
+#endif
+	sg->pfn = page_to_pfn_typed(page);
+	sg->sg_flags |= SG_FLAGS_PAGE;
+#else /* !CONFIG_HAVE_DMA_PFN */
 	unsigned long page_link = sg->page_link & 0x3;
 
 	/*
@@ -84,6 +108,7 @@ static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
 	BUG_ON(sg_is_chain(sg));
 #endif
 	sg->page_link = page_link | (unsigned long) page;
+#endif /* !CONFIG_HAVE_DMA_PFN */
 }
 
 /**
@@ -104,9 +129,26 @@ static inline void sg_set_page(struct scatterlist *sg, struct page *page,
 			       unsigned int len, unsigned int offset)
 {
 	sg_assign_page(sg, page);
+	BUG_ON(offset > 65535);
+	sg->offset = offset;
+	sg->length = len;
+}
+
+#ifdef CONFIG_HAVE_DMA_PFN
+static inline void sg_set_pfn(struct scatterlist *sg, __pfn_t pfn,
+			      unsigned int len, unsigned int offset)
+{
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+	BUG_ON(sg_is_chain(sg));
+#endif
+	sg->pfn = pfn;
+	BUG_ON(offset > 65535);
 	sg->offset = offset;
+	sg->sg_flags = 0;
 	sg->length = len;
 }
+#endif
 
 static inline struct page *sg_page(struct scatterlist *sg)
 {
@@ -114,7 +156,12 @@ static inline struct page *sg_page(struct scatterlist *sg)
 	BUG_ON(sg->sg_magic != SG_MAGIC);
 	BUG_ON(sg_is_chain(sg));
 #endif
+#ifdef CONFIG_HAVE_DMA_PFN
+	BUG_ON(!(sg->sg_flags & SG_FLAGS_PAGE));
+	return pfn_to_page(sg->pfn.pfn);
+#else
 	return (struct page *)((sg)->page_link & ~0x3);
+#endif
 }
 
 /**
@@ -166,7 +213,12 @@ static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 	 * Set lowest bit to indicate a link pointer, and make sure to clear
 	 * the termination bit if it happens to be set.
 	 */
+#ifdef CONFIG_HAVE_DMA_PFN
+	prv[prv_nents - 1].pfn.pfn = (unsigned long) sgl;
+	prv[prv_nents - 1].sg_flags = SG_FLAGS_CHAIN;
+#else
 	prv[prv_nents - 1].page_link = ((unsigned long) sgl | 0x01) & ~0x02;
+#endif
 }
 
 /**
@@ -186,8 +238,13 @@ static inline void sg_mark_end(struct scatterlist *sg)
 	/*
 	 * Set termination bit, clear potential chain bit
 	 */
-	sg->page_link |= 0x02;
-	sg->page_link &= ~0x01;
+#ifdef CONFIG_HAVE_DMA_PFN
+	sg->sg_flags |= SG_FLAGS_LAST;
+	sg->sg_flags &= ~SG_FLAGS_CHAIN;
+#else
+	sg->page_link |= SG_FLAGS_LAST;
+	sg->page_link &= ~SG_FLAGS_CHAIN;
+#endif
 }
 
 /**
@@ -203,7 +260,11 @@ static inline void sg_unmark_end(struct scatterlist *sg)
 #ifdef CONFIG_DEBUG_SG
 	BUG_ON(sg->sg_magic != SG_MAGIC);
 #endif
-	sg->page_link &= ~0x02;
+#ifdef CONFIG_HAVE_DMA_PFN
+	sg->sg_flags &= ~SG_FLAGS_LAST;
+#else
+	sg->page_link &= ~SG_FLAGS_LAST;
+#endif
 }
 
 /**
@@ -218,7 +279,11 @@ static inline void sg_unmark_end(struct scatterlist *sg)
  **/
 static inline dma_addr_t sg_phys(struct scatterlist *sg)
 {
+#ifdef CONFIG_HAVE_DMA_PFN
+	return pfn_to_phys(sg->pfn) + sg->offset;
+#else
 	return page_to_phys(sg_page(sg)) + sg->offset;
+#endif
 }
 
 /**
@@ -233,7 +298,11 @@ static inline dma_addr_t sg_phys(struct scatterlist *sg)
  **/
 static inline void *sg_virt(struct scatterlist *sg)
 {
+#ifdef CONFIG_HAVE_DMA_PFN
+	return __va(pfn_to_phys(sg->pfn)) + sg->offset;
+#else
 	return page_address(sg_page(sg)) + sg->offset;
+#endif
 }
 
 int sg_nents(struct scatterlist *sg);

