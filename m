Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 23D16211EA9EC
 for <linux-nvdimm@lists.01.org>; Fri, 29 Mar 2019 08:40:19 -0700 (PDT)
Subject: [PATCH 3/6] pci/p2pdma: Fix the gen_pool_add_virt() failure path
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Mar 2019 08:27:39 -0700
Message-ID: <155387325926.2443841.6674640070856872301.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155387324370.2443841.574715745262628837.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155387324370.2443841.574715745262628837.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

The pci_p2pdma_add_resource() implementation immediately frees the pgmap
if gen_pool_add_virt() fails. However, that means that when @dev
triggers a devres release devm_memremap_pages_release() will crash
trying to access the freed @pgmap.

Use the new devm_memunmap_pages() to manually free the mapping in the
error path.

Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/pci/p2pdma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index c52298d76e64..595a534bd749 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -208,13 +208,15 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 			pci_bus_address(pdev, bar) + offset,
 			resource_size(&pgmap->res), dev_to_node(&pdev->dev));
 	if (error)
-		goto pgmap_free;
+		goto pages_free;
 
 	pci_info(pdev, "added peer-to-peer DMA memory %pR\n",
 		 &pgmap->res);
 
 	return 0;
 
+pages_free:
+	devm_memunmap_pages(&pdev->dev, pgmap);
 pgmap_free:
 	devm_kfree(&pdev->dev, pgmap);
 	return error;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
