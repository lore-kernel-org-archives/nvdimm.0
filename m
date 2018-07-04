Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 414782097215D
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 14:50:47 -0700 (PDT)
Subject: [PATCH v5 03/11] device-dax: Set page->index
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Jul 2018 14:40:39 -0700
Message-ID: <153074043918.27838.10612469015732111514.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153074042316.27838.17319837331947007626.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153074042316.27838.17319837331947007626.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

In support of enabling memory_failure() handling for device-dax
mappings, set ->index to the pgoff of the page. The rmap implementation
requires ->index to bound the search through the vma interval tree.

The ->index value is never cleared. There is no possibility for the
page to become associated with another pgoff while the device is
enabled. When the device is disabled the 'struct page' array for the
device is destroyed and ->index is reinitialized to zero.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 95cfcfd612df..361a11089591 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -416,6 +416,7 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 
 	if (rc == VM_FAULT_NOPAGE) {
 		unsigned long i;
+		pgoff_t pgoff;
 
 		/*
 		 * In the device-dax case the only possibility for a
@@ -423,6 +424,8 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		 * mapped. No need to consider the zero page, or racing
 		 * conflicting mappings.
 		 */
+		pgoff = linear_page_index(vmf->vma, vmf->address
+				& ~(fault_size - 1));
 		for (i = 0; i < fault_size / PAGE_SIZE; i++) {
 			struct page *page;
 
@@ -430,6 +433,7 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 			if (page->mapping)
 				continue;
 			page->mapping = filp->f_mapping;
+			page->index = pgoff + i;
 		}
 	}
 	dax_read_unlock(id);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
