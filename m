Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 270A921B0E535
 for <linux-nvdimm@lists.01.org>; Wed, 24 May 2017 14:43:20 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Wed, 24 May 2017 15:42:18 -0600
Message-Id: <1495662147-18277-8-git-send-email-logang@deltatee.com>
In-Reply-To: <1495662147-18277-1-git-send-email-logang@deltatee.com>
References: <1495662147-18277-1-git-send-email-logang@deltatee.com>
Subject: [RFC PATCH 07/16] scatterlist: support unmappable memory in the
 scatterlist
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

This patch introduces the PFN_MAYBE_UNMAPPABLE flag which indicates the
sgl or pfn may point to unmappable memory. This flag would be set by a
call to sg_init_unmappable_table which sets the flag for all entries in
the table. Once set, any attempt to call sg_page, sg_virt, etc on the sgl
will BUG_ON. It can also indicate to other parts of the kernel that
a specific pfn_t may not always return a valid page or virtual address.

When it is set, it also allows assigning pfns that may be backed by
IO memory or may not have struct pages. (Indicated by the new PFN_IOMEM
flags).

This new functionality is disabled unless a driver explicitly selects
CONFIG_SG_UNMAPPABLE seeing it may cause unexpected BUG_ONs with drivers
or dma_map implementations that aren't prepared for it.

With this patch, we can start safely supporting IO memory in sgl lists
without needing to cleanup all the existing use cases in the kernel
and deal with the ugly cases that assume memory within an sgl is always
mappable. Developers that want to support io memory then just need
to optionally depend on CONFIG_SG_UNMAPPABLE, call
sg_init_unmappable_table and fix any BUG_ONs that may result. They may
then safely DMA to io memory, memory that is unmappable, or memory that
doesn't have struct page backings.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 include/linux/pfn_t.h       | 37 ++++++++++++++++++++++++++++++++++++-
 include/linux/scatterlist.h | 31 +++++++++++++++++++++++++++++--
 lib/Kconfig                 | 11 +++++++++++
 lib/scatterlist.c           | 30 ++++++++++++++++++++++++++++++
 4 files changed, 106 insertions(+), 3 deletions(-)

diff --git a/include/linux/pfn_t.h b/include/linux/pfn_t.h
index a49b325..07bd5ba 100644
--- a/include/linux/pfn_t.h
+++ b/include/linux/pfn_t.h
@@ -8,6 +8,10 @@
  * PFN_SG_LAST - pfn references a page and is the last scatterlist entry
  * PFN_DEV - pfn is not covered by system memmap by default
  * PFN_MAP - pfn has a dynamic page mapping established by a device driver
+ * PFN_MAYBE_UNMAPPABLE - flag used by SG and others to indicate that the
+ *	pfn may sometimes be unmappable and should not be mixed with
+ *	code that tries to map it.
+ * PFN_IOMEM - pfn points to io memory
  */
 #define PFN_FLAGS_MASK (((u64) ~PAGE_MASK) << (BITS_PER_LONG_LONG - PAGE_SHIFT))
 #define PFN_SG_CHAIN (1ULL << (BITS_PER_LONG_LONG - 1))
@@ -15,6 +19,11 @@
 #define PFN_DEV (1ULL << (BITS_PER_LONG_LONG - 3))
 #define PFN_MAP (1ULL << (BITS_PER_LONG_LONG - 4))
 
+#ifdef CONFIG_SG_UNMAPPABLE
+#define PFN_MAYBE_UNMAPPABLE (1ULL << (BITS_PER_LONG_LONG - 5))
+#define PFN_IOMEM (1ULL << (BITS_PER_LONG_LONG - 6))
+#endif
+
 #define PFN_FLAGS_TRACE \
 	{ PFN_SG_CHAIN,	"SG_CHAIN" }, \
 	{ PFN_SG_LAST,	"SG_LAST" }, \
@@ -44,6 +53,32 @@ static inline bool pfn_t_has_page(pfn_t pfn)
 	return (pfn.val & PFN_MAP) == PFN_MAP || (pfn.val & PFN_DEV) == 0;
 }
 
+#ifdef CONFIG_SG_UNMAPPABLE
+
+static inline bool pfn_t_is_always_mappable(pfn_t pfn)
+{
+	return !(pfn.val & (PFN_MAYBE_UNMAPPABLE | PFN_IOMEM));
+}
+
+static inline bool pfn_t_is_iomem(pfn_t pfn)
+{
+	return pfn.val & PFN_IOMEM;
+}
+
+#else
+
+static inline bool pfn_t_is_always_mappable(pfn_t pfn)
+{
+	return 1;
+}
+
+static inline bool pfn_t_is_iomem(pfn_t pfn)
+{
+	return 0;
+}
+
+#endif /* CONFIG_SG_UNMAPPABLE */
+
 static inline unsigned long pfn_t_to_pfn(pfn_t pfn)
 {
 	return pfn.val & ~PFN_FLAGS_MASK;
@@ -63,7 +98,7 @@ static inline phys_addr_t pfn_t_to_phys(pfn_t pfn)
 
 static inline void *pfn_t_to_virt(pfn_t pfn)
 {
-	if (pfn_t_has_page(pfn))
+	if (pfn_t_has_page(pfn) && !pfn_t_is_iomem(pfn))
 		return __va(pfn_t_to_phys(pfn));
 	return NULL;
 }
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index cce3af9..8cb662c 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -71,6 +71,12 @@ static inline struct scatterlist *sg_chain_ptr(struct scatterlist *sg)
 	return sg->__chain;
 }
 
+#ifdef CONFIG_SG_UNMAPPABLE
+#define SG_STICKY_FLAGS (PFN_SG_LAST | PFN_MAYBE_UNMAPPABLE)
+#else
+#define SG_STICKY_FLAGS PFN_SG_LAST
+#endif
+
 /**
  * sg_assign_pfn - Assign a given pfn to an SG entry
  * @sg:		   SG entry
@@ -83,10 +89,14 @@ static inline struct scatterlist *sg_chain_ptr(struct scatterlist *sg)
  **/
 static inline void sg_assign_pfn(struct scatterlist *sg, pfn_t pfn)
 {
-	u64 flags = sg->__pfn.val & PFN_SG_LAST;
+	u64 flags = sg->__pfn.val & SG_STICKY_FLAGS;
 
 	pfn.val &= ~(PFN_SG_CHAIN | PFN_SG_LAST);
-	BUG_ON(!pfn_t_has_page(pfn));
+
+	if (likely(pfn_t_is_always_mappable(sg->__pfn))) {
+		BUG_ON(!pfn_t_has_page(pfn) ||
+		       !pfn_t_is_always_mappable(pfn));
+	}
 
 #ifdef CONFIG_DEBUG_SG
 	BUG_ON(sg->sg_magic != SG_MAGIC);
@@ -159,6 +169,8 @@ static inline struct page *sg_page(struct scatterlist *sg)
 	BUG_ON(sg->sg_magic != SG_MAGIC);
 	BUG_ON(sg_is_chain(sg));
 #endif
+
+	BUG_ON(!pfn_t_is_always_mappable(sg->__pfn));
 	return pfn_t_to_page(sg->__pfn);
 }
 
@@ -172,6 +184,11 @@ static inline pfn_t sg_pfn_t(struct scatterlist *sg)
 	return sg->__pfn;
 }
 
+static inline bool sg_is_always_mappable(struct scatterlist *sg)
+{
+	return pfn_t_is_always_mappable(sg->__pfn);
+}
+
 /**
  * sg_set_buf - Set sg entry to point at given data
  * @sg:		 SG entry
@@ -207,6 +224,9 @@ static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 			    struct scatterlist *sgl)
 {
+	BUG_ON(pfn_t_is_always_mappable(prv->__pfn) !=
+	       pfn_t_is_always_mappable(sgl->__pfn));
+
 	prv[prv_nents - 1].__pfn = __pfn_to_pfn_t(0, PFN_SG_CHAIN);
 	prv[prv_nents - 1].__chain = sgl;
 }
@@ -283,6 +303,13 @@ int sg_nents_for_len(struct scatterlist *sg, u64 len);
 struct scatterlist *sg_next(struct scatterlist *);
 struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
 void sg_init_table(struct scatterlist *, unsigned int);
+
+#ifdef CONFIG_SG_UNMAPPABLE
+void sg_init_unmappable_table(struct scatterlist *sg, unsigned int nents);
+#else
+#define sg_init_unmappable_table sg_init_table
+#endif
+
 void sg_init_one(struct scatterlist *, const void *, unsigned int);
 int sg_split(struct scatterlist *in, const int in_mapped_nents,
 	     const off_t skip, const int nb_splits,
diff --git a/lib/Kconfig b/lib/Kconfig
index 0c8b78a..a953cf7 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -538,6 +538,17 @@ config SG_POOL
 	 selected by a driver or an API which whishes to allocate chained
 	 scatterlist.
 
+config SG_UNMAPPABLE
+	def_bool n
+	help
+	  This turns on support to enable safely putting unmappable memory
+	  into scatter-gather lists. It turns on a number of BUG_ONs
+	  that may prevent drivers that expect memory to always be mappable
+	  from working with drivers that are using unmappable memory.
+	  This should be selected by a driver wishing to enable
+	  DMA transfers to unmappable memory (eg. Peer-2-Peer DMA transfers
+	  or struct page-less dma).
+
 #
 # sg chaining option
 #
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index c6cf822..6bc33e0 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -143,6 +143,36 @@ void sg_init_table(struct scatterlist *sgl, unsigned int nents)
 }
 EXPORT_SYMBOL(sg_init_table);
 
+#ifdef CONFIG_SG_UNMAPPABLE
+
+/**
+ * sg_init_unmappable_table - Initialize SG table for use with unmappable
+ *	memory
+ * @sgl:	   The SG table
+ * @nents:	   Number of entries in table
+ *
+ * Notes:
+ *   Unmappable scatterlists have more restrictions than regular scatter
+ *   list that may trigger unexpected BUG_ONs with code that is not ready
+ *   for them. However, they are safe to add IO memory or struct page-less
+ *   memory.
+ *
+ *   Also see the notes for sg_init_table
+ *
+ **/
+void sg_init_unmappable_table(struct scatterlist *sgl, unsigned int nents)
+{
+	unsigned int i;
+
+	sg_init_table(sgl, nents);
+
+	for (i = 0; i < nents; i++)
+		sgl[i].__pfn.val |= PFN_MAYBE_UNMAPPABLE;
+}
+EXPORT_SYMBOL(sg_init_unmappable_table);
+
+#endif
+
 /**
  * sg_init_one - Initialize a single entry sg list
  * @sg:		 SG entry
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
