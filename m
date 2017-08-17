Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C628921D0A255
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 09:06:00 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/13] dax: Factor out getting of pfn out of iomap
Date: Thu, 17 Aug 2017 18:08:05 +0200
Message-Id: <20170817160815.30466-4-jack@suse.cz>
In-Reply-To: <20170817160815.30466-1-jack@suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Factor out code to get pfn out of iomap that is shared between PTE and
PMD fault path.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 81 +++++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 42 insertions(+), 39 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index fbbb6d176987..1122356f8b88 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -819,30 +819,53 @@ static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
 }
 
-static int dax_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
-			      loff_t pos, void *entry)
+static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
+			 pfn_t *pfnp)
 {
 	const sector_t sector = dax_iomap_sector(iomap, pos);
-	struct vm_area_struct *vma = vmf->vma;
-	struct address_space *mapping = vma->vm_file->f_mapping;
-	unsigned long vaddr = vmf->address;
-	void *ret, *kaddr;
 	pgoff_t pgoff;
+	void *kaddr;
 	int id, rc;
-	pfn_t pfn;
+	long length;
 
-	rc = bdev_dax_pgoff(iomap->bdev, sector, PAGE_SIZE, &pgoff);
+	rc = bdev_dax_pgoff(iomap->bdev, sector, size, &pgoff);
 	if (rc)
 		return rc;
-
 	id = dax_read_lock();
-	rc = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(PAGE_SIZE),
-			       &kaddr, &pfn);
-	if (rc < 0) {
-		dax_read_unlock(id);
-		return rc;
+	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
+				   &kaddr, pfnp);
+	if (length < 0) {
+		rc = length;
+		goto out;
 	}
+	rc = -EINVAL;
+	if (PFN_PHYS(length) < size)
+		goto out;
+	if (pfn_t_to_pfn(*pfnp) & (PHYS_PFN(size)-1))
+		goto out;
+	/* For larger pages we need devmap */
+	if (length > 1 && !pfn_t_devmap(*pfnp))
+		goto out;
+	rc = 0;
+out:
 	dax_read_unlock(id);
+	return rc;
+}
+
+static int dax_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
+			      loff_t pos, void *entry)
+{
+	const sector_t sector = dax_iomap_sector(iomap, pos);
+	struct vm_area_struct *vma = vmf->vma;
+	struct address_space *mapping = vma->vm_file->f_mapping;
+	unsigned long vaddr = vmf->address;
+	void *ret;
+	int rc;
+	pfn_t pfn;
+
+	rc = dax_iomap_pfn(iomap, pos, PAGE_SIZE, &pfn);
+	if (rc < 0)
+		return rc;
 
 	ret = dax_insert_mapping_entry(mapping, vmf, entry, sector, 0);
 	if (IS_ERR(ret))
@@ -1218,44 +1241,24 @@ static int dax_pmd_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	const sector_t sector = dax_iomap_sector(iomap, pos);
-	struct dax_device *dax_dev = iomap->dax_dev;
-	struct block_device *bdev = iomap->bdev;
 	struct inode *inode = mapping->host;
-	const size_t size = PMD_SIZE;
-	void *ret = NULL, *kaddr;
-	long length = 0;
-	pgoff_t pgoff;
+	void *ret = NULL;
 	pfn_t pfn;
-	int id;
+	int rc;
 
-	if (bdev_dax_pgoff(bdev, sector, size, &pgoff) != 0)
+	rc = dax_iomap_pfn(iomap, pos, PMD_SIZE, &pfn);
+	if (rc < 0)
 		goto fallback;
 
-	id = dax_read_lock();
-	length = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, &pfn);
-	if (length < 0)
-		goto unlock_fallback;
-	length = PFN_PHYS(length);
-
-	if (length < size)
-		goto unlock_fallback;
-	if (pfn_t_to_pfn(pfn) & PG_PMD_COLOUR)
-		goto unlock_fallback;
-	if (!pfn_t_devmap(pfn))
-		goto unlock_fallback;
-	dax_read_unlock(id);
-
 	ret = dax_insert_mapping_entry(mapping, vmf, entry, sector,
 			RADIX_DAX_PMD);
 	if (IS_ERR(ret))
 		goto fallback;
 
-	trace_dax_pmd_insert_mapping(inode, vmf, length, pfn, ret);
+	trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, ret);
 	return vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd,
 			pfn, vmf->flags & FAULT_FLAG_WRITE);
 
-unlock_fallback:
-	dax_read_unlock(id);
 fallback:
 	trace_dax_pmd_insert_mapping_fallback(inode, vmf, length, pfn, ret);
 	return VM_FAULT_FALLBACK;
-- 
2.12.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
