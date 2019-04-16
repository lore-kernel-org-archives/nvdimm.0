Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F5A8212108E6
 for <linux-nvdimm@lists.01.org>; Tue, 16 Apr 2019 09:42:24 -0700 (PDT)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 08/18] dax: memcpy page in case of IOMAP_DAX_COW for mmap
 faults
Date: Tue, 16 Apr 2019 11:41:44 -0500
Message-Id: <20190416164154.30390-9-rgoldwyn@suse.de>
In-Reply-To: <20190416164154.30390-1-rgoldwyn@suse.de>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
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
To: linux-btrfs@vger.kernel.org
Cc: kilobyte@angband.pl, jack@suse.cz, darrick.wong@oracle.com, nborisov@suse.com, linux-nvdimm@lists.01.org, david@fromorbit.com, dsterba@suse.cz, willy@infradead.org, linux-fsdevel@vger.kernel.org, hch@lst.de, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Change dax_iomap_pfn to return the address as well in order to
use it for performing a memcpy in case the type is IOMAP_DAX_COW.

Question:
The sequence of bdev_dax_pgoff() and dax_direct_access() is
used multiple times to calculate address and pfn's. Would it make
sense to call it while calculating address as well to reduce code?

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/dax.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4b4ac51fbd16..45fc2e18969a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -983,7 +983,7 @@ static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 }
 
 static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
-			 pfn_t *pfnp)
+			 pfn_t *pfnp, void **addr)
 {
 	const sector_t sector = dax_iomap_sector(iomap, pos);
 	pgoff_t pgoff;
@@ -995,7 +995,7 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 		return rc;
 	id = dax_read_lock();
 	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
-				   NULL, pfnp);
+				   addr, pfnp);
 	if (length < 0) {
 		rc = length;
 		goto out;
@@ -1280,6 +1280,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
 	struct inode *inode = mapping->host;
 	unsigned long vaddr = vmf->address;
+	void *addr;
 	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
 	struct iomap iomap = { 0 };
 	unsigned flags = IOMAP_FAULT;
@@ -1369,16 +1370,23 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	sync = dax_fault_is_synchronous(flags, vma, &iomap);
 
 	switch (iomap.type) {
+	case IOMAP_DAX_COW:
 	case IOMAP_MAPPED:
 		if (iomap.flags & IOMAP_F_NEW) {
 			count_vm_event(PGMAJFAULT);
 			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
-		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn);
+		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn, &addr);
 		if (error < 0)
 			goto error_finish_iomap;
 
+		if (iomap.type == IOMAP_DAX_COW) {
+			if (iomap.inline_data)
+				memcpy(addr, iomap.inline_data, PAGE_SIZE);
+			else
+				memset(addr, 0, PAGE_SIZE);
+		}
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
 						 0, write && !sync);
 
@@ -1577,7 +1585,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 	switch (iomap.type) {
 	case IOMAP_MAPPED:
-		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn);
+		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn, NULL);
 		if (error < 0)
 			goto finish_iomap;
 
-- 
2.16.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
