Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [RFC PATCH 4/7] scatterlist: use sg_phys()
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 Mar 2015 16:25:48 -0400
Message-ID: <20150316202548.33102.57882.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org, riel@redhat.com, linux-nvdimm@lists.01.org, linux-raid@vger.kernel.org, mgorman@suse.de, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Coccinelle cleanup to replace open coded sg to physical address
translations.  This is in preparation for introducing scatterlists that
reference pfn(s) without a backing struct page.

// sg_phys.cocci: convert usage page_to_phys(sg_page(sg)) to sg_phys(sg)
// usage: make coccicheck COCCI=sg_phys.cocci MODE=patch

virtual patch
virtual report
virtual org

@@
struct scatterlist *sg;
@@

- page_to_phys(sg_page(sg)) + sg->offset
+ sg_phys(sg)

@@
struct scatterlist *sg;
@@

- page_to_phys(sg_page(sg))
+ sg_phys(sg) - sg->offset

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/mm/dma-mapping.c                    |    2 +-
 arch/microblaze/kernel/dma.c                 |    2 +-
 drivers/iommu/intel-iommu.c                  |    4 ++--
 drivers/iommu/iommu.c                        |    2 +-
 drivers/staging/android/ion/ion_chunk_heap.c |    4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 170a116d1b29..ba7eeacfa8b1 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1472,7 +1472,7 @@ static int __map_sg_chunk(struct device *dev, struct scatterlist *sg,
 		return -ENOMEM;
 
 	for (count = 0, s = sg; count < (size >> PAGE_SHIFT); s = sg_next(s)) {
-		phys_addr_t phys = page_to_phys(sg_page(s));
+		phys_addr_t phys = sg_phys(s) - s->offset;
 		unsigned int len = PAGE_ALIGN(s->offset + s->length);
 
 		if (!is_coherent &&
diff --git a/arch/microblaze/kernel/dma.c b/arch/microblaze/kernel/dma.c
index ed7ba8a11822..dcb3c594d626 100644
--- a/arch/microblaze/kernel/dma.c
+++ b/arch/microblaze/kernel/dma.c
@@ -61,7 +61,7 @@ static int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
 	/* FIXME this part of code is untested */
 	for_each_sg(sgl, sg, nents, i) {
 		sg->dma_address = sg_phys(sg);
-		__dma_sync(page_to_phys(sg_page(sg)) + sg->offset,
+		__dma_sync(sg_phys(sg),
 							sg->length, direction);
 	}
 
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index ae4c1a854e57..e10d62f2e61f 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2003,7 +2003,7 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 			sg_res = aligned_nrpages(sg->offset, sg->length);
 			sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + sg->offset;
 			sg->dma_length = sg->length;
-			pteval = page_to_phys(sg_page(sg)) | prot;
+			pteval = (sg_phys(sg) - sg->offset) | prot;
 			phys_pfn = pteval >> VTD_PAGE_SHIFT;
 		}
 
@@ -3303,7 +3303,7 @@ static int intel_nontranslate_map_sg(struct device *hddev,
 
 	for_each_sg(sglist, sg, nelems, i) {
 		BUG_ON(!sg_page(sg));
-		sg->dma_address = page_to_phys(sg_page(sg)) + sg->offset;
+		sg->dma_address = sg_phys(sg);
 		sg->dma_length = sg->length;
 	}
 	return nelems;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 72e683df0731..d5e746370bbb 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1153,7 +1153,7 @@ size_t default_iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 	min_pagesz = 1 << __ffs(domain->ops->pgsize_bitmap);
 
 	for_each_sg(sg, s, nents, i) {
-		phys_addr_t phys = page_to_phys(sg_page(s)) + s->offset;
+		phys_addr_t phys = sg_phys(s);
 
 		/*
 		 * We are mapping on IOMMU page boundaries, so offset within
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 3e6ec2ee6802..b7da5d142aa9 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -81,7 +81,7 @@ static int ion_chunk_heap_allocate(struct ion_heap *heap,
 err:
 	sg = table->sgl;
 	for (i -= 1; i >= 0; i--) {
-		gen_pool_free(chunk_heap->pool, page_to_phys(sg_page(sg)),
+		gen_pool_free(chunk_heap->pool, sg_phys(sg) - sg->offset,
 			      sg->length);
 		sg = sg_next(sg);
 	}
@@ -109,7 +109,7 @@ static void ion_chunk_heap_free(struct ion_buffer *buffer)
 							DMA_BIDIRECTIONAL);
 
 	for_each_sg(table->sgl, sg, table->nents, i) {
-		gen_pool_free(chunk_heap->pool, page_to_phys(sg_page(sg)),
+		gen_pool_free(chunk_heap->pool, sg_phys(sg) - sg->offset,
 			      sg->length);
 	}
 	chunk_heap->allocated -= allocated_size;

