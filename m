From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 10/18] dax: replace mmap entry in case of CoW
Date: Tue, 16 Apr 2019 11:41:46 -0500
Message-ID: <20190416164154.30390-11-rgoldwyn@suse.de>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190416164154.30390-1-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nborisov-IBi9RG/b67k@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, dsterba-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>

We replace the existing entry to the newly allocated one
in case of CoW. Also, we mark the entry as PAGECACHE_TAG_TOWRITE
so writeback marks this entry as writeprotected. This
helps us snapshots so new write pagefaults after snapshots
trigger a CoW.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
---
 fs/dax.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 45fc2e18969a..d5100cbe8bd2 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -708,14 +708,15 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
  */
 static void *dax_insert_entry(struct xa_state *xas,
 		struct address_space *mapping, struct vm_fault *vmf,
-		void *entry, pfn_t pfn, unsigned long flags, bool dirty)
+		void *entry, pfn_t pfn, unsigned long flags, bool dirty,
+		bool cow)
 {
 	void *new_entry = dax_make_entry(pfn, flags);
 
 	if (dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 
-	if (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE)) {
+	if (cow || (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE))) {
 		unsigned long index = xas->xa_index;
 		/* we are replacing a zero page with block mapping */
 		if (dax_is_pmd_entry(entry))
@@ -727,12 +728,12 @@ static void *dax_insert_entry(struct xa_state *xas,
 
 	xas_reset(xas);
 	xas_lock_irq(xas);
-	if (dax_entry_size(entry) != dax_entry_size(new_entry)) {
+	if (cow || (dax_entry_size(entry) != dax_entry_size(new_entry))) {
 		dax_disassociate_entry(entry, mapping, false);
 		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
 	}
 
-	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
+	if (cow || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		/*
 		 * Only swap our new entry into the page cache if the current
 		 * entry is a zero page or an empty entry.  If a normal PTE or
@@ -752,6 +753,9 @@ static void *dax_insert_entry(struct xa_state *xas,
 	if (dirty)
 		xas_set_mark(xas, PAGECACHE_TAG_DIRTY);
 
+	if (cow)
+		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
+
 	xas_unlock_irq(xas);
 	return entry;
 }
@@ -1031,7 +1035,7 @@ static vm_fault_t dax_load_hole(struct xa_state *xas,
 	vm_fault_t ret;
 
 	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
-			DAX_ZERO_PAGE, false);
+			DAX_ZERO_PAGE, false, false);
 
 	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
 	trace_dax_load_hole(inode, vmf, ret);
@@ -1388,7 +1392,8 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 				memset(addr, 0, PAGE_SIZE);
 		}
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
-						 0, write && !sync);
+						 0, write && !sync,
+						 iomap.type == IOMAP_DAX_COW);
 
 		/*
 		 * If we are doing synchronous page fault and inode needs fsync,
@@ -1467,7 +1472,8 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 
 	pfn = page_to_pfn_t(zero_page);
 	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
-			DAX_PMD | DAX_ZERO_PAGE, false);
+			DAX_PMD | DAX_ZERO_PAGE, false,
+			iomap->type == IOMAP_DAX_COW);
 
 	ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
 	if (!pmd_none(*(vmf->pmd))) {
@@ -1590,7 +1596,8 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			goto finish_iomap;
 
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
-						DAX_PMD, write && !sync);
+						DAX_PMD, write && !sync,
+						false);
 
 		/*
 		 * If we are doing synchronous page fault and inode needs fsync,
-- 
2.16.4
