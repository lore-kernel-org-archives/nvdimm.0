Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 163A62095A329
 for <linux-nvdimm@lists.01.org>; Wed, 24 May 2017 14:43:20 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Wed, 24 May 2017 15:42:27 -0600
Message-Id: <1495662147-18277-17-git-send-email-logang@deltatee.com>
In-Reply-To: <1495662147-18277-1-git-send-email-logang@deltatee.com>
References: <1495662147-18277-1-git-send-email-logang@deltatee.com>
Subject: [RFC PATCH 16/16] nvmet: use unmappable sgl in rdma target
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

This is incomplete but is given to test the unmappable sg page code.
Further work would actually use p2p memory in the rdma target. (One
should imagine something vaguely resembling our original p2pmem RFC[1]
being on top of this.)

We convert to using an unmappable sgl in the rdma nvme target driver and
nvme pci driver. We also fix up any remaining uses that would have caused
a BUG_ON.

This still needs a fair bit of work before it's fully safe. No bugs are hit
with nvme or nullb and Intel swiotlb but more testing (and likely fixes)
need to be done for other block drivers and dma_map arches.

It may make sense to add a flag in the request_queue which indicates
the driver is not going to BUG_ON with an unmappable SGL and it may also
make sense to have CONFIG_SG_UNMAPPABLE depend on architectures that
are known have unmappable safe dma mapping code.

[1] https://lwn.net/Articles/718593/

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 drivers/nvme/host/pci.c      |  3 ++-
 drivers/nvme/target/Kconfig  | 12 ++++++++++++
 drivers/nvme/target/io-cmd.c |  2 +-
 drivers/nvme/target/rdma.c   | 29 +++++++++++++++++++++++++----
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index adf4133..56becec 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -625,7 +625,8 @@ static int nvme_map_data(struct nvme_dev *dev, struct request *req,
 			DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	int ret = BLK_MQ_RQ_QUEUE_ERROR;
 
-	sg_init_table(iod->sg, blk_rq_nr_phys_segments(req));
+	sg_init_unmappable_table(iod->sg, blk_rq_nr_phys_segments(req));
+
 	iod->nents = blk_rq_map_sg(q, req, iod->sg);
 	if (!iod->nents)
 		goto out;
diff --git a/drivers/nvme/target/Kconfig b/drivers/nvme/target/Kconfig
index 03e4ab6..bc71cb1 100644
--- a/drivers/nvme/target/Kconfig
+++ b/drivers/nvme/target/Kconfig
@@ -35,6 +35,18 @@ config NVME_TARGET_RDMA
 
 	  If unsure, say N.
 
+config NVME_TARGET_RDMA_P2PMEM
+	bool "Support Peer-2-Peer memory (Experimental)"
+	depends on NVME_TARGET_RDMA
+	select SG_UNMAPPABLE
+	help
+	  This enable experimental support for using Peer 2 Peer PCI
+	  memory in the NVME RDMA target driver. Enabling this could trigger
+	  BUG_ONs when using the target with architectures or block devices
+	  that do not currently support DMAing to unmappable memory.
+
+	  If unsure, say N.
+
 config NVME_TARGET_FC
 	tristate "NVMe over Fabrics FC target driver"
 	depends on NVME_TARGET
diff --git a/drivers/nvme/target/io-cmd.c b/drivers/nvme/target/io-cmd.c
index c77940d..84f1804 100644
--- a/drivers/nvme/target/io-cmd.c
+++ b/drivers/nvme/target/io-cmd.c
@@ -75,7 +75,7 @@ static void nvmet_execute_rw(struct nvmet_req *req)
 	bio_set_op_attrs(bio, op, op_flags);
 
 	for_each_sg(req->sg, sg, req->sg_cnt, i) {
-		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
+		while (bio_add_pfn(bio, sg_pfn_t(sg), sg->length, sg->offset)
 				!= sg->length) {
 			struct bio *prev = bio;
 
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 9e45cde..6f926da 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -193,11 +193,30 @@ static void nvmet_rdma_free_sgl(struct scatterlist *sgl, unsigned int nents)
 	if (!sgl || !nents)
 		return;
 
-	for_each_sg(sgl, sg, nents, count)
-		__free_page(sg_page(sg));
+	for_each_sg(sgl, sg, nents, count) {
+		struct page *pg = pfn_t_to_page(sg_pfn_t(sg));
+
+		if (pg)
+			__free_page(pg);
+	}
+
 	kfree(sgl);
 }
 
+#ifdef CONFIG_NVME_TARGET_RDMA_P2PMEM
+static void nvmet_rdma_init_sg(struct scatterlist *sg,
+			       unsigned int nent)
+{
+	sg_init_unmappable_table(sg, nent);
+}
+#else
+static void nvmet_rdma_init_sg(struct scatterlist *sg,
+			       unsigned int nent)
+{
+	sg_init_table(sg, nent);
+}
+#endif
+
 static int nvmet_rdma_alloc_sgl(struct scatterlist **sgl, unsigned int *nents,
 		u32 length)
 {
@@ -211,7 +230,7 @@ static int nvmet_rdma_alloc_sgl(struct scatterlist **sgl, unsigned int *nents,
 	if (!sg)
 		goto out;
 
-	sg_init_table(sg, nent);
+	nvmet_rdma_init_sg(sg, nent);
 
 	while (length) {
 		u32 page_len = min_t(u32, length, PAGE_SIZE);
@@ -231,7 +250,9 @@ static int nvmet_rdma_alloc_sgl(struct scatterlist **sgl, unsigned int *nents,
 out_free_pages:
 	while (i > 0) {
 		i--;
-		__free_page(sg_page(&sg[i]));
+		page = pfn_t_to_page(sg_pfn_t(&sg[i]));
+		if (page)
+			__free_page(page);
 	}
 	kfree(sg);
 out:
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
