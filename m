Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 11BB82129DB98
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jun 2019 05:28:01 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/25] memremap: pass a struct dev_pagemap to ->kill and
 ->cleanup
Date: Mon, 17 Jun 2019 14:27:17 +0200
Message-Id: <20190617122733.22432-10-hch@lst.de>
In-Reply-To: <20190617122733.22432-1-hch@lst.de>
References: <20190617122733.22432-1-hch@lst.de>
MIME-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, nouveau@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

Passing the actual typed structure leads to more understandable code
vs just passing the ref member.

Reported-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c              | 12 ++++++------
 drivers/nvdimm/pmem.c             | 18 +++++++++---------
 drivers/pci/p2pdma.c              | 11 ++++++-----
 include/linux/memremap.h          |  4 ++--
 kernel/memremap.c                 |  8 ++++----
 mm/hmm.c                          | 10 +++++-----
 tools/testing/nvdimm/test/iomap.c |  4 ++--
 7 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index cd483050a775..17b46c1a76b4 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -27,21 +27,21 @@ static void dev_dax_percpu_release(struct percpu_ref *ref)
 	complete(&dev_dax->cmp);
 }
 
-static void dev_dax_percpu_exit(struct percpu_ref *ref)
+static void dev_dax_percpu_exit(struct dev_pagemap *pgmap)
 {
-	struct dev_dax *dev_dax = ref_to_dev_dax(ref);
+	struct dev_dax *dev_dax = container_of(pgmap, struct dev_dax, pgmap);
 
 	dev_dbg(&dev_dax->dev, "%s\n", __func__);
 	wait_for_completion(&dev_dax->cmp);
-	percpu_ref_exit(ref);
+	percpu_ref_exit(pgmap->ref);
 }
 
-static void dev_dax_percpu_kill(struct percpu_ref *ref)
+static void dev_dax_percpu_kill(struct dev_pagemap *pgmap)
 {
-	struct dev_dax *dev_dax = ref_to_dev_dax(ref);
+	struct dev_dax *dev_dax = container_of(pgmap, struct dev_dax, pgmap);
 
 	dev_dbg(&dev_dax->dev, "%s\n", __func__);
-	percpu_ref_kill(ref);
+	percpu_ref_kill(pgmap->ref);
 }
 
 static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 1a9986dc4dc6..469a0f5b3380 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -311,24 +311,24 @@ static const struct attribute_group *pmem_attribute_groups[] = {
 	NULL,
 };
 
-static void pmem_pagemap_cleanup(struct percpu_ref *ref)
+static void pmem_pagemap_cleanup(struct dev_pagemap *pgmap)
 {
-	struct request_queue *q;
+	struct request_queue *q =
+		container_of(pgmap->ref, struct request_queue, q_usage_counter);
 
-	q = container_of(ref, typeof(*q), q_usage_counter);
 	blk_cleanup_queue(q);
 }
 
-static void pmem_release_queue(void *ref)
+static void pmem_release_queue(void *pgmap)
 {
-	pmem_pagemap_cleanup(ref);
+	pmem_pagemap_cleanup(pgmap);
 }
 
-static void pmem_pagemap_kill(struct percpu_ref *ref)
+static void pmem_pagemap_kill(struct dev_pagemap *pgmap)
 {
-	struct request_queue *q;
+	struct request_queue *q =
+		container_of(pgmap->ref, struct request_queue, q_usage_counter);
 
-	q = container_of(ref, typeof(*q), q_usage_counter);
 	blk_freeze_queue_start(q);
 }
 
@@ -443,7 +443,7 @@ static int pmem_attach_disk(struct device *dev,
 		memcpy(&bb_res, &pmem->pgmap.res, sizeof(bb_res));
 	} else {
 		if (devm_add_action_or_reset(dev, pmem_release_queue,
-					&q->q_usage_counter))
+					&pmem->pgmap))
 			return -ENOMEM;
 		addr = devm_memremap(dev, pmem->phys_addr,
 				pmem->size, ARCH_MEMREMAP_PMEM);
diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index e083567d26ef..48a88158e46a 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -90,17 +90,18 @@ static void pci_p2pdma_percpu_release(struct percpu_ref *ref)
 	complete(&p2p_pgmap->ref_done);
 }
 
-static void pci_p2pdma_percpu_kill(struct percpu_ref *ref)
+static void pci_p2pdma_percpu_kill(struct dev_pagemap *pgmap)
 {
-	percpu_ref_kill(ref);
+	percpu_ref_kill(pgmap->ref);
 }
 
-static void pci_p2pdma_percpu_cleanup(struct percpu_ref *ref)
+static void pci_p2pdma_percpu_cleanup(struct dev_pagemap *pgmap)
 {
-	struct p2pdma_pagemap *p2p_pgmap = to_p2p_pgmap(ref);
+	struct p2pdma_pagemap *p2p_pgmap =
+		container_of(pgmap, struct p2pdma_pagemap, pgmap);
 
 	wait_for_completion(&p2p_pgmap->ref_done);
-	percpu_ref_exit(ref);
+	percpu_ref_exit(&p2p_pgmap->ref);
 }
 
 static void pci_p2pdma_release(void *data)
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 1cdcfd595770..cec02d5400f1 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -74,12 +74,12 @@ struct dev_pagemap_ops {
 	/*
 	 * Transition the refcount in struct dev_pagemap to the dead state.
 	 */
-	void (*kill)(struct percpu_ref *ref);
+	void (*kill)(struct dev_pagemap *pgmap);
 
 	/*
 	 * Wait for refcount in struct dev_pagemap to be idle and reap it.
 	 */
-	void (*cleanup)(struct percpu_ref *ref);
+	void (*cleanup)(struct dev_pagemap *pgmap);
 };
 
 /**
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 85635ff57e04..ba7156bd52d1 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -92,10 +92,10 @@ static void devm_memremap_pages_release(void *data)
 	unsigned long pfn;
 	int nid;
 
-	pgmap->ops->kill(pgmap->ref);
+	pgmap->ops->kill(pgmap);
 	for_each_device_pfn(pfn, pgmap)
 		put_page(pfn_to_page(pfn));
-	pgmap->ops->cleanup(pgmap->ref);
+	pgmap->ops->cleanup(pgmap);
 
 	/* pages are dead and unused, undo the arch mapping */
 	align_start = res->start & ~(SECTION_SIZE - 1);
@@ -299,8 +299,8 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
  err_pfn_remap:
 	pgmap_array_delete(res);
  err_array:
-	pgmap->ops->kill(pgmap->ref);
-	pgmap->ops->cleanup(pgmap->ref);
+	pgmap->ops->kill(pgmap);
+	pgmap->ops->cleanup(pgmap);
 	return ERR_PTR(error);
 }
 EXPORT_SYMBOL_GPL(devm_memremap_pages);
diff --git a/mm/hmm.c b/mm/hmm.c
index 694e53bc55f4..ec3bf2c5c699 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -1349,18 +1349,18 @@ static void hmm_devmem_ref_release(struct percpu_ref *ref)
 	complete(&devmem->completion);
 }
 
-static void hmm_devmem_ref_exit(struct percpu_ref *ref)
+static void hmm_devmem_ref_exit(struct dev_pagemap *pgmap)
 {
 	struct hmm_devmem *devmem;
 
-	devmem = container_of(ref, struct hmm_devmem, ref);
+	devmem = container_of(pgmap, struct hmm_devmem, pagemap);
 	wait_for_completion(&devmem->completion);
-	percpu_ref_exit(ref);
+	percpu_ref_exit(pgmap->ref);
 }
 
-static void hmm_devmem_ref_kill(struct percpu_ref *ref)
+static void hmm_devmem_ref_kill(struct dev_pagemap *pgmap)
 {
-	percpu_ref_kill(ref);
+	percpu_ref_kill(pgmap->ref);
 }
 
 static vm_fault_t hmm_devmem_fault(struct vm_area_struct *vma,
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index a667d974155e..3a1fa7735f47 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -108,8 +108,8 @@ static void nfit_test_kill(void *_pgmap)
 {
 	WARN_ON(!pgmap || !pgmap->ref || !pgmap->ops->kill ||
 		!pgmap->ops->cleanup);
-	pgmap->ops->kill(pgmap->ref);
-	pgmap->ops->cleanup(pgmap->ref);
+	pgmap->ops->kill(pgmap);
+	pgmap->ops->cleanup(pgmap);
 }
 
 void *__wrap_devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
