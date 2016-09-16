From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 04/12] dax: don't pass buffer_head to copy_user_dax
Date: Fri, 16 Sep 2016 13:27:06 +0200
Message-ID: <1474025234-13804-5-git-send-email-hch@lst.de>
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
index 98463bb..84343ce 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -580,14 +580,13 @@ static int dax_load_hole(struct address_space *mapping, void *entry,
 	return VM_FAULT_LOCKED;
 }
 
-static int copy_user_bh(struct page *to, struct inode *inode,
-		struct buffer_head *bh, unsigned long vaddr)
+static int copy_user_dax(struct block_device *bdev, sector_t sector, size_t size,
+		struct page *to, unsigned long vaddr)
 {
 	struct blk_dax_ctl dax = {
-		.sector = to_sector(bh, inode),
-		.size = bh->b_size,
+		.sector = sector,
+		.size = size,
 	};
-	struct block_device *bdev = bh->b_bdev;
 	void *vto;
 
 	if (dax_map_atomic(bdev, &dax) < 0)
@@ -867,7 +866,8 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	if (vmf->cow_page) {
 		struct page *new_page = vmf->cow_page;
 		if (buffer_written(&bh))
-			error = copy_user_bh(new_page, inode, &bh, vaddr);
+			error = copy_user_dax(bh.b_bdev, to_sector(&bh, inode),
+					bh.b_size, new_page, vaddr);
 		else
 			clear_user_highpage(new_page, vaddr);
 		if (error)
-- 
2.1.4
