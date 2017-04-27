Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B85D21954060
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 13:14:17 -0700 (PDT)
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-2-git-send-email-logang@deltatee.com>
 <20170426074416.GA7936@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <8658f080-f4de-221a-fce7-40398f8df95f@deltatee.com>
Date: Thu, 27 Apr 2017 14:13:47 -0600
MIME-Version: 1.0
In-Reply-To: <20170426074416.GA7936@lst.de>
Subject: Re: [PATCH v2 01/21] scatterlist: Introduce sg_map helper functions
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Christoph Hellwig <hch@lst.de>
Cc: dri-devel@lists.freedesktop.org, dm-devel@redhat.com, target-devel@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, devel@driverdev.osuosl.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, netdev@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <linux-nvdimm@lists.01.org>


On 26/04/17 01:44 AM, Christoph Hellwig wrote:
> I think we'll at least need a draft of those to make sense of these
> patches.  Otherwise they just look very clumsy.

Ok, what follows is a draft patch attempting to show where I'm thinking
of going with this. Obviously it will not compile because it assumes
the users throughout the kernel are a bit different than they are today.
Notably, there is no sg_page anymore.

There's also likely a ton of issues and arguments to have over a bunch
of the specifics below and I'd expect the concept to evolve more
as cleanup occurs. This itself is an evolution of the draft I posted
replying to you in my last RFC thread.

Also, before any of this is truly useful to us, pfn_t would have to
infect a few other places in the kernel.

Thanks,

Logan


diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index fad170b..85ef928 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -6,13 +6,14 @@
 #include <linux/bug.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/pfn_t.h>
 #include <asm/io.h>

 struct scatterlist {
 #ifdef CONFIG_DEBUG_SG
 	unsigned long	sg_magic;
 #endif
-	unsigned long	page_link;
+	pfn_t  		pfn;
 	unsigned int	offset;
 	unsigned int	length;
 	dma_addr_t	dma_address;
@@ -60,15 +61,68 @@ struct sg_table {

 #define SG_MAGIC	0x87654321

-/*
- * We overload the LSB of the page pointer to indicate whether it's
- * a valid sg entry, or whether it points to the start of a new
scatterlist.
- * Those low bits are there for everyone! (thanks mason :-)
- */
-#define sg_is_chain(sg)		((sg)->page_link & 0x01)
-#define sg_is_last(sg)		((sg)->page_link & 0x02)
-#define sg_chain_ptr(sg)	\
-	((struct scatterlist *) ((sg)->page_link & ~0x03))
+static inline bool sg_is_chain(struct scatterlist *sg)
+{
+	return sg->pfn.val & PFN_SG_CHAIN;
+}
+
+static inline bool sg_is_last(struct scatterlist *sg)
+{
+	return sg->pfn.val & PFN_SG_LAST;
+}
+
+static inline struct scatterlist *sg_chain_ptr(struct scatterlist *sg)
+{
+	unsigned long sgl = pfn_t_to_pfn(sg->pfn);
+	return (struct scatterlist *)(sgl << PAGE_SHIFT);
+}
+
+static inline bool sg_is_iomem(struct scatterlist *sg)
+{
+	return pfn_t_is_iomem(sg->pfn);
+}
+
+/**
+ * sg_assign_pfn - Assign a given pfn_t to an SG entry
+ * @sg:		    SG entry
+ * @pfn:	    The pfn
+ *
+ * Description:
+ *   Assign a pfn to sg entry. Also see sg_set_pfn(), the most commonly
used
+ *   variant.w
+ *
+ **/
+static inline void sg_assign_pfn(struct scatterlist *sg, pfn_t pfn)
+{
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+	BUG_ON(sg_is_chain(sg));
+	BUG_ON(pfn.val & (PFN_SG_CHAIN | PFN_SG_LAST));
+#endif
+
+	sg->pfn = pfn;
+}
+
+/**
+ * sg_set_pfn - Set sg entry to point at given pfn
+ * @sg:		 SG entry
+ * @pfn:	 The page
+ * @len:	 Length of data
+ * @offset:	 Offset into page
+ *
+ * Description:
+ *   Use this function to set an sg entry pointing at a pfn, never assign
+ *   the page directly. We encode sg table information in the lower bits
+ *   of the page pointer. See sg_pfn_t for looking up the pfn_t belonging
+ *   to an sg entry.
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
@@ -82,18 +136,13 @@ struct sg_table {
  **/
 static inline void sg_assign_page(struct scatterlist *sg, struct page
*page)
 {
-	unsigned long page_link = sg->page_link & 0x3;
+	if (!page) {
+		pfn_t null_pfn = {0};
+		sg_assign_pfn(sg, null_pfn);
+		return;
+	}

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
@@ -106,8 +155,7 @@ static inline void sg_assign_page(struct scatterlist
*sg, struct page *page)
  * Description:
  *   Use this function to set an sg entry pointing at a page, never assign
  *   the page directly. We encode sg table information in the lower bits
- *   of the page pointer. See sg_page() for looking up the page belonging
- *   to an sg entry.
+ *   of the page pointer.
  *
  **/
 static inline void sg_set_page(struct scatterlist *sg, struct page *page,
@@ -118,13 +166,53 @@ static inline void sg_set_page(struct scatterlist
*sg, struct page *page,
 	sg->length = len;
 }

-static inline struct page *sg_page(struct scatterlist *sg)
+/**
+ * sg_pfn_t - Return the pfn_t for the sg
+ * @sg:		 SG entry
+ *
+ **/
+static inline pfn_t sg_pfn_t(struct scatterlist *sg)
 {
 #ifdef CONFIG_DEBUG_SG
 	BUG_ON(sg->sg_magic != SG_MAGIC);
 	BUG_ON(sg_is_chain(sg));
 #endif
-	return (struct page *)((sg)->page_link & ~0x3);
+
+	return sg->pfn;
+}
+
+/**
+ * sg_to_mappable_page - Try to return a struct page safe for general
+ *	use in the kernel
+ * @sg:		 SG entry
+ * @page:	 A pointer to the returned page
+ *
+ * Description:
+ *   If possible, return a mappable page that's safe for use around the
+ *   kernel. Should only be used in legacy situations. sg_pfn_t() is a
+ *   better choice for new code. This is deliberately more awkward than
+ *   the old sg_page to enforce the __must_check rule and discourage future
+ *   use.
+ *
+ *   An example where this is required is in nvme-fabrics: a page from an
+ *   sgl is placed into a bio. This function would be required until we can
+ *   convert bios to use pfn_t as well. Similar issues with skbs, etc.
+ **/
+static inline __must_check int sg_to_mappable_page(struct scatterlist *sg,
+						   struct page **ret)
+{
+	struct page *pg;
+
+	if (unlikely(sg_is_iomem(sg)))
+		return -EFAULT;
+
+	pg = pfn_t_to_page(sg->pfn);
+	if (unlikely(!pg))
+		return -EFAULT;
+
+	*ret = pg;
+
+	return 0;
 }

 #define SG_KMAP		     (1 << 0)	/* create a mapping with kmap */
@@ -167,8 +255,19 @@ static inline void *sg_map(struct scatterlist *sg,
size_t offset, int flags)
 	unsigned int pg_off;
 	void *ret;

+	if (unlikely(sg_is_iomem(sg))) {
+		ret = ERR_PTR(-EFAULT);
+		goto out;
+	}
+
+	pg = pfn_t_to_page(sg->pfn);
+	if (unlikely(!pg)) {
+		ret = ERR_PTR(-EFAULT);
+		goto out;
+	}
+
 	offset += sg->offset;
-	pg = nth_page(sg_page(sg), offset >> PAGE_SHIFT);
+	pg = nth_page(pg, offset >> PAGE_SHIFT);
 	pg_off = offset_in_page(offset);

 	if (flags & SG_KMAP_ATOMIC)
@@ -178,12 +277,7 @@ static inline void *sg_map(struct scatterlist *sg,
size_t offset, int flags)
 	else
 		ret = ERR_PTR(-EINVAL);

-	/*
-	 * In theory, this can't happen yet. Once we start adding
-	 * unmapable memory, it also shouldn't happen unless developers
-	 * start putting unmappable struct pages in sgls and passing
-	 * it to code that doesn't support it.
-	 */
+out:
 	BUG_ON(flags & SG_MAP_MUST_NOT_FAIL && IS_ERR(ret));

 	return ret;
@@ -202,9 +296,15 @@ static inline void *sg_map(struct scatterlist *sg,
size_t offset, int flags)
 static inline void sg_unmap(struct scatterlist *sg, void *addr,
 			    size_t offset, int flags)
 {
-	struct page *pg = nth_page(sg_page(sg), offset >> PAGE_SHIFT);
+	struct page *pg;
 	unsigned int pg_off = offset_in_page(offset);

+	pg = pfn_t_to_page(sg->pfn);
+	if (unlikely(!pg))
+		return;
+
+	pg = nth_page(pg, offset >> PAGE_SHIFT);
+
 	if (flags & SG_KMAP_ATOMIC)
 		kunmap_atomic(addr - sg->offset - pg_off);
 	else if (flags & SG_KMAP)
@@ -246,17 +346,18 @@ static inline void sg_set_buf(struct scatterlist
*sg, const void *buf,
 static inline void sg_chain(struct scatterlist *prv, unsigned int
prv_nents,
 			    struct scatterlist *sgl)
 {
+	pfn_t pfn;
+	unsigned long _sgl = (unsigned long) sgl;
+
 	/*
 	 * offset and length are unused for chain entry.  Clear them.
 	 */
 	prv[prv_nents - 1].offset = 0;
 	prv[prv_nents - 1].length = 0;

-	/*
-	 * Set lowest bit to indicate a link pointer, and make sure to clear
-	 * the termination bit if it happens to be set.
-	 */
-	prv[prv_nents - 1].page_link = ((unsigned long) sgl | 0x01) & ~0x02;
+	BUG_ON(_sgl & PAGE_MASK);
+	pfn = __pfn_to_pfn_t(_sgl >> PAGE_SHIFT, PFN_SG_CHAIN);
+	prv[prv_nents - 1].pfn = pfn;
 }

 /**
@@ -276,8 +377,8 @@ static inline void sg_mark_end(struct scatterlist *sg)
 	/*
 	 * Set termination bit, clear potential chain bit
 	 */
-	sg->page_link |= 0x02;
-	sg->page_link &= ~0x01;
+	sg->pfn.val |= PFN_SG_LAST;
+	sg->pfn.val &= ~PFN_SG_CHAIN;
 }

 /**
@@ -293,7 +394,7 @@ static inline void sg_unmark_end(struct scatterlist *sg)
 #ifdef CONFIG_DEBUG_SG
 	BUG_ON(sg->sg_magic != SG_MAGIC);
 #endif
-	sg->page_link &= ~0x02;
+	sg->pfn.val &= ~PFN_SG_LAST;
 }

 /**
@@ -301,14 +402,13 @@ static inline void sg_unmark_end(struct
scatterlist *sg)
  * @sg:	     SG entry
  *
  * Description:
- *   This calls page_to_phys() on the page in this sg entry, and adds the
- *   sg offset. The caller must know that it is legal to call
page_to_phys()
- *   on the sg page.
+ *   This calls pfn_t_to_phys() on the pfn in this sg entry, and adds the
+ *   sg offset.
  *
  **/
 static inline dma_addr_t sg_phys(struct scatterlist *sg)
 {
-	return page_to_phys(sg_page(sg)) + sg->offset;
+	return pfn_t_to_phys(sg->pfn) + sg->offset;
 }

 /**
@@ -323,7 +423,12 @@ static inline dma_addr_t sg_phys(struct scatterlist
*sg)
  **/
 static inline void *sg_virt(struct scatterlist *sg)
 {
-	return page_address(sg_page(sg)) + sg->offset;
+	struct page *pg = pfn_t_to_page(sg->pfn);
+
+	BUG_ON(sg_is_iomem(sg));
+	BUG_ON(!pg);
+
+	return page_address(pg) + sg->offset;
 }

 int sg_nents(struct scatterlist *sg);
@@ -422,10 +527,18 @@ void __sg_page_iter_start(struct sg_page_iter *piter,
 /**
  * sg_page_iter_page - get the current page held by the page iterator
  * @piter:	page iterator holding the page
+ *
+ * This function will require some cleanup. Some users simply mark
+ * attributes of the pages which are fine, others actually map it and
+ * will require some saftey there.
  */
 static inline struct page *sg_page_iter_page(struct sg_page_iter *piter)
 {
-	return nth_page(sg_page(piter->sg), piter->sg_pgoffset);
+	struct page *pg = pfn_t_to_page(piter->sg->pfn);
+	if (!pg)
+		return NULL;
+
+	return nth_page(pg, piter->sg_pgoffset);
 }

 /**
@@ -468,11 +581,13 @@ static inline dma_addr_t
sg_page_iter_dma_address(struct sg_page_iter *piter)
 #define SG_MITER_ATOMIC		(1 << 0)	 /* use kmap_atomic */
 #define SG_MITER_TO_SG		(1 << 1)	/* flush back to phys on unmap */
 #define SG_MITER_FROM_SG	(1 << 2)	/* nop */
+#define SG_MITER_SUPPORTS_IOMEM (1 << 3)        /* iteratee supports
iomem */

 struct sg_mapping_iter {
 	/* the following three fields can be accessed directly */
 	struct page		*page;		/* currently mapped page */
 	void			*addr;		/* pointer to the mapped area */
+	void __iomem            *ioaddr;        /* pointer to iomem */
 	size_t			length;		/* length of the mapped area */
 	size_t			consumed;	/* number of consumed bytes */
 	struct sg_page_iter	piter;		/* page iterator */
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index c6cf822..2d1c58c 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -571,6 +571,8 @@ EXPORT_SYMBOL(sg_miter_skip);
  */
 bool sg_miter_next(struct sg_mapping_iter *miter)
 {
+	void *addr;
+
 	sg_miter_stop(miter);

 	/*
@@ -580,13 +582,25 @@ bool sg_miter_next(struct sg_mapping_iter *miter)
 	if (!sg_miter_get_next_page(miter))
 		return false;

+	if (sg_is_iomem(miter->piter.sg) &&
+	    !(miter->__flags & SG_MITER_SUPPORTS_IOMEM))
+		return false;
+
 	miter->page = sg_page_iter_page(&miter->piter);
 	miter->consumed = miter->length = miter->__remaining;

 	if (miter->__flags & SG_MITER_ATOMIC)
-		miter->addr = kmap_atomic(miter->page) + miter->__offset;
+		addr = kmap_atomic(miter->page) + miter->__offset;
 	else
-		miter->addr = kmap(miter->page) + miter->__offset;
+		addr = kmap(miter->page) + miter->__offset;
+
+	if (sg_is_iomem(miter->piter.sg)) {
+		miter->addr = NULL;
+		miter->ioaddr = (void * __iomem) addr;
+	} else {
+		miter->addr = addr;
+		miter->ioaddr = NULL;
+	}

 	return true;
 }
@@ -651,7 +665,7 @@ size_t sg_copy_buffer(struct scatterlist *sgl,
unsigned int nents, void *buf,
 {
 	unsigned int offset = 0;
 	struct sg_mapping_iter miter;
-	unsigned int sg_flags = SG_MITER_ATOMIC;
+	unsigned int sg_flags = SG_MITER_ATOMIC | SG_MITER_SUPPORTS_IOMEM;

 	if (to_buffer)
 		sg_flags |= SG_MITER_FROM_SG;
@@ -668,10 +682,17 @@ size_t sg_copy_buffer(struct scatterlist *sgl,
unsigned int nents, void *buf,

 		len = min(miter.length, buflen - offset);

-		if (to_buffer)
-			memcpy(buf + offset, miter.addr, len);
-		else
-			memcpy(miter.addr, buf + offset, len);
+		if (miter.addr) {
+			if (to_buffer)
+				memcpy(buf + offset, miter.addr, len);
+			else
+				memcpy(miter.addr, buf + offset, len);
+		} else if (miter.ioaddr) {
+			if (to_buffer)
+				memcpy_fromio(buf + offset, miter.addr, len);
+			else
+				memcpy_toio(miter.addr, buf + offset, len);
+		}

 		offset += len;
 	}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
