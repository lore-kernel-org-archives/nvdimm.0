Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B37821B0E53A
 for <linux-nvdimm@lists.01.org>; Wed, 24 May 2017 14:43:20 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Wed, 24 May 2017 15:42:17 -0600
Message-Id: <1495662147-18277-7-git-send-email-logang@deltatee.com>
In-Reply-To: <1495662147-18277-1-git-send-email-logang@deltatee.com>
References: <1495662147-18277-1-git-send-email-logang@deltatee.com>
Subject: [RFC PATCH 06/16] scatterlist: convert page_link to pfn_t
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

This patch replaces the old page_link bits with the somewhat safer
pfn_t. This change seems to have been planned for in the design of pfn_t
by Dan.

The conversion is surprisingly straightforward. sg_assign_pfn and
sg_set_pfn helpers are added which are similar analogs to their
page_link versions. A union for the chain pointer (with length and
offset) is also used instead of trying to shoehorn a pointer (that may
not be page aligned) into a pfn_t.

This results in some code that feels a fair bit cleaner seeing it avoids
a lot of casting and use of hard coded ones and twos.

The one side affect is that, on 32 bit systems, the sgl entry will be
32 bits larger seeing pfn_t is always 64 bits and the unsigned long it
replaced was 32 bits. However, it should still fit the same
SG_CHUNK_SIZE entries into a single page so this probably isn't a huge
issue.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 drivers/memstick/core/mspro_block.c |   2 +-
 include/linux/scatterlist.h         | 145 ++++++++++++++++++++++--------------
 2 files changed, 92 insertions(+), 55 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index c00d8a2..38ae9ef 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -580,7 +580,7 @@ static int h_mspro_block_transfer_data(struct memstick_dev *card,
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	unsigned char t_val = 0;
-	struct scatterlist t_sg = { 0 };
+	struct scatterlist t_sg = {};
 	size_t t_offset;
 
 	if ((*mrq)->error)
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index cb3c8fe..cce3af9 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -5,16 +5,25 @@
 #include <linux/types.h>
 #include <linux/bug.h>
 #include <linux/mm.h>
+#include <linux/pfn_t.h>
 #include <asm/io.h>
 
 struct scatterlist {
 #ifdef CONFIG_DEBUG_SG
 	unsigned long	sg_magic;
 #endif
-	unsigned long	page_link;
-	unsigned int	offset;
-	unsigned int	length;
+	pfn_t		__pfn;
+	union {
+		struct {
+			unsigned int	offset;
+			unsigned int	length;
+		};
+
+		struct scatterlist *__chain;
+	};
+
 	dma_addr_t	dma_address;
+
 #ifdef CONFIG_NEED_SG_DMA_LENGTH
 	unsigned int	dma_length;
 #endif
@@ -41,33 +50,71 @@ struct sg_table {
 	unsigned int orig_nents;	/* original size of list */
 };
 
-/*
- * Notes on SG table design.
- *
- * We use the unsigned long page_link field in the scatterlist struct to place
- * the page pointer AND encode information about the sg table as well. The two
- * lower bits are reserved for this information.
- *
- * If bit 0 is set, then the page_link contains a pointer to the next sg
- * table list. Otherwise the next entry is at sg + 1.
- *
- * If bit 1 is set, then this sg entry is the last element in a list.
+#define SG_MAGIC	0x87654321
+
+static inline bool sg_is_chain(struct scatterlist *sg)
+{
+	return sg->__pfn.val & PFN_SG_CHAIN;
+}
+
+static inline bool sg_is_last(struct scatterlist *sg)
+{
+	return sg->__pfn.val & PFN_SG_LAST;
+}
+
+static inline struct scatterlist *sg_chain_ptr(struct scatterlist *sg)
+{
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(!sg_is_chain(sg));
+#endif
+
+	return sg->__chain;
+}
+
+/**
+ * sg_assign_pfn - Assign a given pfn to an SG entry
+ * @sg:		   SG entry
+ * @pfn:	   The pfn
  *
- * See sg_next().
+ * Description:
+ *   Assign a to sg entry. Also see sg_set_pfn(), the most commonly used
+ *   variant.
  *
- */
+ **/
+static inline void sg_assign_pfn(struct scatterlist *sg, pfn_t pfn)
+{
+	u64 flags = sg->__pfn.val & PFN_SG_LAST;
 
-#define SG_MAGIC	0x87654321
+	pfn.val &= ~(PFN_SG_CHAIN | PFN_SG_LAST);
+	BUG_ON(!pfn_t_has_page(pfn));
 
-/*
- * We overload the LSB of the page pointer to indicate whether it's
- * a valid sg entry, or whether it points to the start of a new scatterlist.
- * Those low bits are there for everyone! (thanks mason :-)
- */
-#define sg_is_chain(sg)		((sg)->page_link & 0x01)
-#define sg_is_last(sg)		((sg)->page_link & 0x02)
-#define sg_chain_ptr(sg)	\
-	((struct scatterlist *) ((sg)->page_link & ~0x03))
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+	BUG_ON(sg_is_chain(sg));
+#endif
+
+	sg->__pfn.val = pfn.val | flags;
+}
+
+/**
+ * sg_set_pfn - Set sg entry to point at given pfn
+ * @sg:		 SG entry
+ * @pfn:	 The pfn
+ * @len:	 Length of data
+ * @offset:	 Offset into page
+ *
+ * Description:
+ *   Use this function to set an sg entry pointing at a pfn, never assign
+ *   the pfn directly.
+ *
+ **/
+static inline void sg_set_pfn(struct scatterlist *sg, pfn_t pfn,
+			      unsigned int len, unsigned int offset)
+{
+	sg_assign_pfn(sg, pfn);
+	sg->offset = offset;
+	sg->length = len;
+}
 
 /**
  * sg_assign_page - Assign a given page to an SG entry
@@ -81,18 +128,7 @@ struct sg_table {
  **/
 static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
 {
-	unsigned long page_link = sg->page_link & 0x3;
-
-	/*
-	 * In order for the low bit stealing approach to work, pages
-	 * must be aligned at a 32-bit boundary as a minimum.
-	 */
-	BUG_ON((unsigned long) page & 0x03);
-#ifdef CONFIG_DEBUG_SG
-	BUG_ON(sg->sg_magic != SG_MAGIC);
-	BUG_ON(sg_is_chain(sg));
-#endif
-	sg->page_link = page_link | (unsigned long) page;
+	sg_assign_pfn(sg, page_to_pfn_t(page));
 }
 
 /**
@@ -123,7 +159,17 @@ static inline struct page *sg_page(struct scatterlist *sg)
 	BUG_ON(sg->sg_magic != SG_MAGIC);
 	BUG_ON(sg_is_chain(sg));
 #endif
-	return (struct page *)((sg)->page_link & ~0x3);
+	return pfn_t_to_page(sg->__pfn);
+}
+
+static inline pfn_t sg_pfn_t(struct scatterlist *sg)
+{
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+	BUG_ON(sg_is_chain(sg));
+#endif
+
+	return sg->__pfn;
 }
 
 /**
@@ -161,17 +207,8 @@ static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 			    struct scatterlist *sgl)
 {
-	/*
-	 * offset and length are unused for chain entry.  Clear them.
-	 */
-	prv[prv_nents - 1].offset = 0;
-	prv[prv_nents - 1].length = 0;
-
-	/*
-	 * Set lowest bit to indicate a link pointer, and make sure to clear
-	 * the termination bit if it happens to be set.
-	 */
-	prv[prv_nents - 1].page_link = ((unsigned long) sgl | 0x01) & ~0x02;
+	prv[prv_nents - 1].__pfn = __pfn_to_pfn_t(0, PFN_SG_CHAIN);
+	prv[prv_nents - 1].__chain = sgl;
 }
 
 /**
@@ -191,8 +228,8 @@ static inline void sg_mark_end(struct scatterlist *sg)
 	/*
 	 * Set termination bit, clear potential chain bit
 	 */
-	sg->page_link |= 0x02;
-	sg->page_link &= ~0x01;
+	sg->__pfn.val |= PFN_SG_LAST;
+	sg->__pfn.val &= ~PFN_SG_CHAIN;
 }
 
 /**
@@ -208,7 +245,7 @@ static inline void sg_unmark_end(struct scatterlist *sg)
 #ifdef CONFIG_DEBUG_SG
 	BUG_ON(sg->sg_magic != SG_MAGIC);
 #endif
-	sg->page_link &= ~0x02;
+	sg->__pfn.val &= ~PFN_SG_LAST;
 }
 
 /**
@@ -223,7 +260,7 @@ static inline void sg_unmark_end(struct scatterlist *sg)
  **/
 static inline dma_addr_t sg_phys(struct scatterlist *sg)
 {
-	return page_to_phys(sg_page(sg)) + sg->offset;
+	return pfn_t_to_phys(sg->__pfn) + sg->offset;
 }
 
 /**
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
