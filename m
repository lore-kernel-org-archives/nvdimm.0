Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 45AA421B0E538
 for <linux-nvdimm@lists.01.org>; Wed, 24 May 2017 14:43:20 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Wed, 24 May 2017 15:42:26 -0600
Message-Id: <1495662147-18277-16-git-send-email-logang@deltatee.com>
In-Reply-To: <1495662147-18277-1-git-send-email-logang@deltatee.com>
References: <1495662147-18277-1-git-send-email-logang@deltatee.com>
Subject: [RFC PATCH 15/16] dma-mapping: introduce and use unmappable safe
 sg_virt call
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

Introduce sg_try_virt which is safe to call with a potentially
unmappable sgl. sg_try_virt returns NULL in cases that the sgl doesn't
have an accessible virtual address to return.

Then, in dma_map_sg_attrs, we use the new function instead of sg_virt
when marking memory as initialized.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 include/linux/dma-mapping.h |  9 +++++++--
 include/linux/scatterlist.h | 16 ++++++++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 4f3eece..5ef1ab5 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -241,8 +241,13 @@ static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
 	int i, ents;
 	struct scatterlist *s;
 
-	for_each_sg(sg, s, nents, i)
-		kmemcheck_mark_initialized(sg_virt(s), s->length);
+	for_each_sg(sg, s, nents, i) {
+		void *addr = sg_try_virt(sg);
+
+		if (addr)
+			kmemcheck_mark_initialized(addr, s->length);
+	}
+
 	BUG_ON(!valid_dma_direction(dir));
 	ents = ops->map_sg(dev, sg, nents, dir, attrs);
 	BUG_ON(ents < 0);
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 2c54c6c..1e11af9 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -298,6 +298,22 @@ static inline void *sg_virt(struct scatterlist *sg)
 	return page_address(sg_page(sg)) + sg->offset;
 }
 
+/**
+ * sg_try_virt - Return virtual address of an sg entry or NULL if it is
+ *	unmappable
+ * @sg:      SG entry
+ *
+ * Description:
+ *   This is the same as sg_virt but is safe to call with unmappable
+ *   memory. This function will return NULL in case the sg is is
+ *   unmappable.
+ *
+ **/
+static inline void *sg_try_virt(struct scatterlist *sg)
+{
+	return pfn_t_to_virt(sg->__pfn);
+}
+
 int sg_nents(struct scatterlist *sg);
 int sg_nents_for_len(struct scatterlist *sg, u64 len);
 struct scatterlist *sg_next(struct scatterlist *);
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
