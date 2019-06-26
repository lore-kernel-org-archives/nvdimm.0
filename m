Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 04B36212AAB70
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jun 2019 05:28:24 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/25] mm: remove hmm_vma_alloc_locked_page
Date: Wed, 26 Jun 2019 14:27:19 +0200
Message-Id: <20190626122724.13313-21-hch@lst.de>
In-Reply-To: <20190626122724.13313-1-hch@lst.de>
References: <20190626122724.13313-1-hch@lst.de>
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

The only user of it has just been removed, and there wasn't really any need
to wrap a basic memory allocator to start with.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/hmm.h |  3 ---
 mm/hmm.c            | 14 --------------
 2 files changed, 17 deletions(-)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index ba19c19e24ed..1d55b7ea2da6 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -587,9 +587,6 @@ static inline void hmm_mm_init(struct mm_struct *mm) {}
 #if IS_ENABLED(CONFIG_DEVICE_PRIVATE)
 struct hmm_devmem;
 
-struct page *hmm_vma_alloc_locked_page(struct vm_area_struct *vma,
-				       unsigned long addr);
-
 /*
  * struct hmm_devmem_ops - callback for ZONE_DEVICE memory events
  *
diff --git a/mm/hmm.c b/mm/hmm.c
index e4470462298f..fdbd48771292 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -1330,20 +1330,6 @@ EXPORT_SYMBOL(hmm_range_dma_unmap);
 
 
 #if IS_ENABLED(CONFIG_DEVICE_PRIVATE)
-struct page *hmm_vma_alloc_locked_page(struct vm_area_struct *vma,
-				       unsigned long addr)
-{
-	struct page *page;
-
-	page = alloc_page_vma(GFP_HIGHUSER, vma, addr);
-	if (!page)
-		return NULL;
-	lock_page(page);
-	return page;
-}
-EXPORT_SYMBOL(hmm_vma_alloc_locked_page);
-
-
 static void hmm_devmem_ref_release(struct percpu_ref *ref)
 {
 	struct hmm_devmem *devmem;
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
