Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 8/9] scatterlist: convert to __pfn_t
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 05 Jun 2015 17:19:49 -0400
Message-ID: <20150605211949.20751.59262.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, linux-arch@vger.kernel.org, arnd@arndb.de, ross.zwisler@linux.intel.com, linux-nvdimm@lists.01.org, benh@kernel.crashing.org, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, hch@lst.de, tj@kernel.org, paulus@samba.org, hpa@zytor.com, schwidefsky@de.ibm.com, willy@linux.intel.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

__pfn_t replaces the struct page reference in struct scatterlist.  Given
__pfn_t implements the same bits at the same bit positions for denoting
sg_is_chain() + sg_is_last() this conversion is binary identical to the
previous state.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/asm-generic/pfn.h   |    9 ++++
 include/linux/scatterlist.h |  103 ++++++++++++++++++++++++++++++-------------
 samples/kfifo/dma-example.c |    8 ++-
 3 files changed, 86 insertions(+), 34 deletions(-)

diff --git a/include/asm-generic/pfn.h b/include/asm-generic/pfn.h
index e9fed20d606a..f826c50ed025 100644
--- a/include/asm-generic/pfn.h
+++ b/include/asm-generic/pfn.h
@@ -108,4 +108,13 @@ static inline __pfn_t page_to_pfn_t(struct page *page)
 
 	return pfn;
 }
+
+static inline __pfn_t nth_pfn(__pfn_t pfn, unsigned int n)
+{
+	__pfn_t ret;
+
+	ret.data = (__pfn_t_to_pfn(pfn) + n) << PFN_SHIFT
+		| (pfn.data & PFN_MASK);
+	return ret;
+}
 #endif /* __ASM_PFN_H */
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index eca1ec93775c..49054374646e 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -11,7 +11,7 @@ struct scatterlist {
 #ifdef CONFIG_DEBUG_SG
 	unsigned long	sg_magic;
 #endif
-	unsigned long	page_link;
+	__pfn_t		pfn;
 	unsigned int	offset;
 	unsigned int	length;
 	dma_addr_t	dma_address;
@@ -44,14 +44,14 @@ struct sg_table {
 /*
  * Notes on SG table design.
  *
- * We use the unsigned long page_link field in the scatterlist struct to place
+ * We use the __pfn_t pfn field in the scatterlist struct to place
  * the page pointer AND encode information about the sg table as well. The two
  * lower bits are reserved for this information.
  *
- * If bit 0 is set, then the page_link contains a pointer to the next sg
+ * If PFN_SG_CHAIN is set, then the pfn contains a pointer to the next sg
  * table list. Otherwise the next entry is at sg + 1.
  *
- * If bit 1 is set, then this sg entry is the last element in a list.
+ * If PFN_SG_LAST is set, then this sg entry is the last element in a list.
  *
  * See sg_next().
  *
@@ -64,10 +64,30 @@ struct sg_table {
  * a valid sg entry, or whether it points to the start of a new scatterlist.
  * Those low bits are there for everyone! (thanks mason :-)
  */
-#define sg_is_chain(sg)		((sg)->page_link & 0x01)
-#define sg_is_last(sg)		((sg)->page_link & 0x02)
-#define sg_chain_ptr(sg)	\
-	((struct scatterlist *) ((sg)->page_link & ~0x03))
+static inline bool sg_is_chain(struct scatterlist *sg)
+{
+	return (sg->pfn.data & PFN_MASK) == PFN_SG_CHAIN;
+}
+
+static inline bool sg_is_last(struct scatterlist *sg)
+{
+	return (sg->pfn.data & PFN_MASK) == PFN_SG_LAST;
+}
+
+static inline struct scatterlist *sg_chain_ptr(struct scatterlist *sg)
+{
+	return (struct scatterlist *) (sg->pfn.data & ~PFN_MASK);
+}
+
+static inline void sg_assign_pfn(struct scatterlist *sg, __pfn_t pfn)
+{
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+	BUG_ON(sg_is_chain(sg));
+#endif
+	pfn.data &= ~PFN_SG_LAST;
+	sg->pfn.data = (sg->pfn.data & PFN_SG_LAST) | pfn.data;
+}
 
 /**
  * sg_assign_page - Assign a given page to an SG entry
@@ -81,18 +101,23 @@ struct sg_table {
  **/
 static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
 {
-	unsigned long page_link = sg->page_link & 0x3;
+	__pfn_t pfn = page_to_pfn_t(page);
 
 	/*
 	 * In order for the low bit stealing approach to work, pages
-	 * must be aligned at a 32-bit boundary as a minimum.
+	 * must be aligned at a sizeof(unsigned long) boundary.
 	 */
-	BUG_ON((unsigned long) page & 0x03);
-#ifdef CONFIG_DEBUG_SG
-	BUG_ON(sg->sg_magic != SG_MAGIC);
-	BUG_ON(sg_is_chain(sg));
-#endif
-	sg->page_link = page_link | (unsigned long) page;
+	BUG_ON(pfn.data & PFN_MASK);
+
+	sg_assign_pfn(sg, pfn);
+}
+
+static inline void sg_set_pfn(struct scatterlist *sg, __pfn_t pfn,
+	unsigned int len, unsigned int offset)
+{
+	sg_assign_pfn(sg, pfn);
+	sg->offset = offset;
+	sg->length = len;
 }
 
 /**
@@ -112,18 +137,30 @@ static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
 static inline void sg_set_page(struct scatterlist *sg, struct page *page,
 			       unsigned int len, unsigned int offset)
 {
-	sg_assign_page(sg, page);
-	sg->offset = offset;
-	sg->length = len;
+	sg_set_pfn(sg, page_to_pfn_t(page), len, offset);
 }
 
 static inline struct page *sg_page(struct scatterlist *sg)
 {
+	__pfn_t pfn = sg->pfn;
+	struct page *page;
+
 #ifdef CONFIG_DEBUG_SG
 	BUG_ON(sg->sg_magic != SG_MAGIC);
 	BUG_ON(sg_is_chain(sg));
 #endif
-	return (struct page *)((sg)->page_link & ~0x3);
+
+	pfn.data &= ~PFN_SG_LAST;
+	page = __pfn_t_to_page(pfn);
+
+	/* don't use sg_page() on non linear-mapped memory */
+	BUG_ON(!page);
+	return page;
+}
+
+static inline unsigned long sg_pfn(struct scatterlist *sg)
+{
+	return __pfn_t_to_pfn(sg->pfn);
 }
 
 /**
@@ -175,7 +212,8 @@ static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 	 * Set lowest bit to indicate a link pointer, and make sure to clear
 	 * the termination bit if it happens to be set.
 	 */
-	prv[prv_nents - 1].page_link = ((unsigned long) sgl | 0x01) & ~0x02;
+	prv[prv_nents - 1].pfn.data = ((unsigned long) sgl | PFN_SG_CHAIN)
+		& ~PFN_SG_LAST;
 }
 
 /**
@@ -195,8 +233,8 @@ static inline void sg_mark_end(struct scatterlist *sg)
 	/*
 	 * Set termination bit, clear potential chain bit
 	 */
-	sg->page_link |= 0x02;
-	sg->page_link &= ~0x01;
+	sg->pfn.data |= PFN_SG_LAST;
+	sg->pfn.data &= ~PFN_SG_CHAIN;
 }
 
 /**
@@ -212,7 +250,7 @@ static inline void sg_unmark_end(struct scatterlist *sg)
 #ifdef CONFIG_DEBUG_SG
 	BUG_ON(sg->sg_magic != SG_MAGIC);
 #endif
-	sg->page_link &= ~0x02;
+	sg->pfn.data &= ~PFN_SG_LAST;
 }
 
 /**
@@ -220,14 +258,13 @@ static inline void sg_unmark_end(struct scatterlist *sg)
  * @sg:	     SG entry
  *
  * Description:
- *   This calls page_to_phys() on the page in this sg entry, and adds the
- *   sg offset. The caller must know that it is legal to call page_to_phys()
- *   on the sg page.
+ *   This calls __pfn_t_to_phys() on the pfn in this sg entry, and adds the
+ *   sg offset.
  *
  **/
 static inline dma_addr_t sg_phys(struct scatterlist *sg)
 {
-	return page_to_phys(sg_page(sg)) + sg->offset;
+	return __pfn_t_to_phys(sg->pfn) + sg->offset;
 }
 
 /**
@@ -281,7 +318,7 @@ size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 #define SG_MAX_SINGLE_ALLOC		(PAGE_SIZE / sizeof(struct scatterlist))
 
 /*
- * sg page iterator
+ * sg page / pfn iterator
  *
  * Iterates over sg entries page-by-page.  On each successful iteration,
  * you can call sg_page_iter_page(@piter) and sg_page_iter_dma_address(@piter)
@@ -304,13 +341,19 @@ bool __sg_page_iter_next(struct sg_page_iter *piter);
 void __sg_page_iter_start(struct sg_page_iter *piter,
 			  struct scatterlist *sglist, unsigned int nents,
 			  unsigned long pgoffset);
+
+static inline __pfn_t sg_page_iter_pfn(struct sg_page_iter *piter)
+{
+	return nth_pfn(piter->sg->pfn, piter->sg_pgoffset);
+}
+
 /**
  * sg_page_iter_page - get the current page held by the page iterator
  * @piter:	page iterator holding the page
  */
 static inline struct page *sg_page_iter_page(struct sg_page_iter *piter)
 {
-	return nth_page(sg_page(piter->sg), piter->sg_pgoffset);
+	return __pfn_t_to_page(sg_page_iter_pfn(piter));
 }
 
 /**
diff --git a/samples/kfifo/dma-example.c b/samples/kfifo/dma-example.c
index aa243db93f01..3eeff9a56e0e 100644
--- a/samples/kfifo/dma-example.c
+++ b/samples/kfifo/dma-example.c
@@ -75,8 +75,8 @@ static int __init example_init(void)
 	for (i = 0; i < nents; i++) {
 		printk(KERN_INFO
 		"sg[%d] -> "
-		"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
-			i, sg[i].page_link, sg[i].offset, sg[i].length);
+		"pfn_data 0x%.8lx offset 0x%.8x length 0x%.8x\n",
+			i, sg[i].pfn.data, sg[i].offset, sg[i].length);
 
 		if (sg_is_last(&sg[i]))
 			break;
@@ -104,8 +104,8 @@ static int __init example_init(void)
 	for (i = 0; i < nents; i++) {
 		printk(KERN_INFO
 		"sg[%d] -> "
-		"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
-			i, sg[i].page_link, sg[i].offset, sg[i].length);
+		"pfn_data 0x%.8lx offset 0x%.8x length 0x%.8x\n",
+			i, sg[i].pfn.data, sg[i].offset, sg[i].length);
 
 		if (sg_is_last(&sg[i]))
 			break;

