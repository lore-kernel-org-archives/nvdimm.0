Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 1598E1A1ED0
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 14:48:04 -0800 (PST)
Subject: [PATCH 2/3] libnvdimm, pmem: fix kmap_atomic() leak in error path
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 08 Mar 2016 14:47:23 -0800
Message-ID: <20160308224723.16298.74334.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160308224713.16298.33547.stgit@dwillia2-desk3.jf.intel.com>
References: <20160308224713.16298.33547.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When we enounter a bad block we need to kunmap_atomic() before
returning.

Cc: <stable@vger.kernel.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index efc2a5e671c6..e7b86a7fca0a 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -66,22 +66,25 @@ static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 			unsigned int len, unsigned int off, int rw,
 			sector_t sector)
 {
+	int rc = 0;
 	void *mem = kmap_atomic(page);
 	phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
 	void __pmem *pmem_addr = pmem->virt_addr + pmem_off;
 
 	if (rw == READ) {
 		if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
-			return -EIO;
-		memcpy_from_pmem(mem + off, pmem_addr, len);
-		flush_dcache_page(page);
+			rc = -EIO;
+		else {
+			memcpy_from_pmem(mem + off, pmem_addr, len);
+			flush_dcache_page(page);
+		}
 	} else {
 		flush_dcache_page(page);
 		memcpy_to_pmem(pmem_addr, mem + off, len);
 	}
 
 	kunmap_atomic(mem);
-	return 0;
+	return rc;
 }
 
 static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
