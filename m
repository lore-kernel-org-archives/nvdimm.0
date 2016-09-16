From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 03/12] dax: don't pass buffer_head to dax_insert_mapping
Date: Fri, 16 Sep 2016 13:27:05 +0200
Message-ID: <1474025234-13804-4-git-send-email-hch@lst.de>
References: <1474025234-13804-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1474025234-13804-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

This way we can use this helper for the iomap based DAX implementation
as well.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 fs/dax.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 993dc6f..98463bb 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -790,14 +790,13 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
 static int dax_insert_mapping(struct address_space *mapping,
-			struct buffer_head *bh, void **entryp,
-			struct vm_area_struct *vma, struct vm_fault *vmf)
+		struct block_device *bdev, sector_t sector, size_t size,
+		void **entryp, struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	unsigned long vaddr = (unsigned long)vmf->virtual_address;
-	struct block_device *bdev = bh->b_bdev;
 	struct blk_dax_ctl dax = {
-		.sector = to_sector(bh, mapping->host),
-		.size = bh->b_size,
+		.sector = sector,
+		.size = size,
 	};
 	void *ret;
 	void *entry = *entryp;
@@ -898,7 +897,8 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 
 	/* Filesystem should not return unwritten buffers to us! */
 	WARN_ON_ONCE(buffer_unwritten(&bh) || buffer_new(&bh));
-	error = dax_insert_mapping(mapping, &bh, &entry, vma, vmf);
+	error = dax_insert_mapping(mapping, bh.b_bdev, to_sector(&bh, inode),
+			bh.b_size, &entry, vma, vmf);
  unlock_entry:
 	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
  out:
-- 
2.1.4
