Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1ECDF21951C95
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 11:21:29 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Tue, 25 Apr 2017 12:20:48 -0600
Message-Id: <1493144468-22493-2-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 01/21] scatterlist: Introduce sg_map helper functions
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
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, target-devel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sumit Semwal <sumit.semwal@linaro.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

This patch introduces functions which kmap the pages inside an sgl.
These functions replace a common pattern of kmap(sg_page(sg)) that is
used in more than 50 places within the kernel.

The motivation for this work is to eventually safely support sgls that
contain io memory. In order for that to work, any access to the contents
of an iomem SGL will need to be done with iomemcpy or hit some warning.
(The exact details of how this will work have yet to be worked out.)
Having all the kmaps in one place is just a first step in that
direction. Additionally, seeing this helps cut down the users of sg_page,
it should make any effort to go to struct-page-less DMAs a little
easier (should that idea ever swing back into favour again).

A flags option is added to select between a regular or atomic mapping so
these functions can replace kmap(sg_page or kmap_atomic(sg_page.
Future work may expand this to have flags for using page_address or
vmap. We include a flag to require the function not to fail to
support legacy code that has no easy error path. Much further in the
future, there may be a flag to allocate memory and copy the data
from/to iomem.

We also add the semantic that sg_map can fail to create a mapping,
despite the fact that the current code this is replacing is assumed to
never fail and the current version of these functions cannot fail. This
is to support iomem which may either have to fail to create the mapping or
allocate memory as a bounce buffer which itself can fail.

Also, in terms of cleanup, a few of the existing kmap(sg_page) users
play things a bit loose in terms of whether they apply sg->offset
so using these helper functions should help avoid such issues.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 include/linux/scatterlist.h | 85 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index cb3c8fe..fad170b 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/bug.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <asm/io.h>
 
 struct scatterlist {
@@ -126,6 +127,90 @@ static inline struct page *sg_page(struct scatterlist *sg)
 	return (struct page *)((sg)->page_link & ~0x3);
 }
 
+#define SG_KMAP		     (1 << 0)	/* create a mapping with kmap */
+#define SG_KMAP_ATOMIC	     (1 << 1)	/* create a mapping with kmap_atomic */
+#define SG_MAP_MUST_NOT_FAIL (1 << 2)	/* indicate sg_map should not fail */
+
+/**
+ * sg_map - kmap a page inside an sgl
+ * @sg:		SG entry
+ * @offset:	Offset into entry
+ * @flags:	Flags for creating the mapping
+ *
+ * Description:
+ *   Use this function to map a page in the scatterlist at the specified
+ *   offset. sg->offset is already added for you. Note: the semantics of
+ *   this function are that it may fail. Thus, its output should be checked
+ *   with IS_ERR and PTR_ERR. Otherwise, a pointer to the specified offset
+ *   in the mapped page is returned.
+ *
+ *   Flags can be any of:
+ *	* SG_KMAP		- Use kmap to create the mapping
+ *	* SG_KMAP_ATOMIC	- Use kmap_atomic to map the page atommically.
+ *				  Thus, the rules of that function apply: the
+ *				  cpu may not sleep until it is unmaped.
+ *	* SG_MAP_MUST_NOT_FAIL	- Indicate that sg_map must not fail.
+ *				  If it does, it will issue a BUG_ON instead.
+ *				  This is intended for legacy code only, it
+ *				  is not to be used in new code.
+ *
+ *   Also, consider carefully whether this function is appropriate. It is
+ *   largely not recommended for new code and if the sgl came from another
+ *   subsystem and you don't know what kind of memory might be in the list
+ *   then you definitely should not call it. Non-mappable memory may be in
+ *   the sgl and thus this function may fail unexpectedly. Consider using
+ *   sg_copy_to_buffer instead.
+ **/
+static inline void *sg_map(struct scatterlist *sg, size_t offset, int flags)
+{
+	struct page *pg;
+	unsigned int pg_off;
+	void *ret;
+
+	offset += sg->offset;
+	pg = nth_page(sg_page(sg), offset >> PAGE_SHIFT);
+	pg_off = offset_in_page(offset);
+
+	if (flags & SG_KMAP_ATOMIC)
+		ret = kmap_atomic(pg) + pg_off;
+	else if (flags & SG_KMAP)
+		ret = kmap(pg) + pg_off;
+	else
+		ret = ERR_PTR(-EINVAL);
+
+	/*
+	 * In theory, this can't happen yet. Once we start adding
+	 * unmapable memory, it also shouldn't happen unless developers
+	 * start putting unmappable struct pages in sgls and passing
+	 * it to code that doesn't support it.
+	 */
+	BUG_ON(flags & SG_MAP_MUST_NOT_FAIL && IS_ERR(ret));
+
+	return ret;
+}
+
+/**
+ * sg_unmap - unmap a page that was mapped with sg_map_offset
+ * @sg:		SG entry
+ * @addr:	address returned by sg_map_offset
+ * @offset:	Offset into entry (same as specified for sg_map)
+ * @flags:	Flags, which are the same specified for sg_map
+ *
+ * Description:
+ *   Unmap the page that was mapped with sg_map_offset
+ **/
+static inline void sg_unmap(struct scatterlist *sg, void *addr,
+			    size_t offset, int flags)
+{
+	struct page *pg = nth_page(sg_page(sg), offset >> PAGE_SHIFT);
+	unsigned int pg_off = offset_in_page(offset);
+
+	if (flags & SG_KMAP_ATOMIC)
+		kunmap_atomic(addr - sg->offset - pg_off);
+	else if (flags & SG_KMAP)
+		kunmap(pg);
+}
+
 /**
  * sg_set_buf - Set sg entry to point at given data
  * @sg:		 SG entry
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
