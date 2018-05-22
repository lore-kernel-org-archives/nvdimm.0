Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9212D203BA4FF
 for <linux-nvdimm@lists.01.org>; Tue, 22 May 2018 07:49:49 -0700 (PDT)
Subject: [PATCH 04/11] device-dax: set page->index
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 May 2018 07:39:52 -0700
Message-ID: <152699999266.24093.18001031234939470569.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152699997165.24093.12194490924829406111.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152699997165.24093.12194490924829406111.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, tony.luck@intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

In support of enabling memory_failure() handling for device-dax
mappings, set ->index to the pgoff of the page. The rmap implementation
requires ->index to bound the search through the vma interval tree.

The ->index value is never cleared. There is no possibility for the
page to become associated with another pgoff while the device is
enabled. When the device is disabled the 'struct page' array for the
device is destroyed and ->index is reinitialized to zero.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 8e986478d48d..b33e45ee4f70 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -418,7 +418,10 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 
 	if (rc == VM_FAULT_NOPAGE) {
 		unsigned long i;
+		pgoff_t pgoff;
 
+		pgoff = linear_page_index(vma, vmf->address
+				& ~(fault_size - 1));
 		for (i = 0; i < fault_size / PAGE_SIZE; i++) {
 			struct page *page;
 
@@ -426,6 +429,7 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
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
