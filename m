Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3769F21D09187
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 10:09:02 -0700 (PDT)
Date: Wed, 26 Jul 2017 10:11:01 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: FIle copy to FAT FS on NVDIMM hits BUG_ON at fs/buffer.c:3305!
Message-ID: <20170726171101.GA15980@bombadil.infradead.org>
References: <1501018096.2042.70.camel@hpe.com>
 <20170725222247.GA26391@linux.intel.com>
 <20170726082159.GE4039@linux-x5ow.site> <87d18neemb.fsf@devron>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87d18neemb.fsf@devron>
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
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 26, 2017 at 06:23:08PM +0900, OGAWA Hirofumi wrote:
> The locking of this path seems to be broken. The guy familiar to
> bdev_write_page() path will made real fix though, The following patch
> should be explaining enough what is wrong.
> 
> In short, clean_buffers() must be called before unlocking lock_page().

Thanks for that.  This should fix the problem while not leaking the
unlock_page call outside bdev_write_page.

--- 8< ---

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9941dc8342df..3fbe75bdd257 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -716,10 +716,12 @@ int bdev_write_page(struct block_device *bdev, sector_t sector,
 
 	set_page_writeback(page);
 	result = ops->rw_page(bdev, sector + get_start_sect(bdev), page, true);
-	if (result)
+	if (result) {
 		end_page_writeback(page);
-	else
+	} else {
+		clean_page_buffers(page);
 		unlock_page(page);
+	}
 	blk_queue_exit(bdev->bd_queue);
 	return result;
 }
diff --git a/fs/mpage.c b/fs/mpage.c
index 2e4c41ccb5c9..d97b003f1607 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -468,6 +468,16 @@ static void clean_buffers(struct page *page, unsigned first_unmapped)
 		try_to_free_buffers(page);
 }
 
+/*
+ * For situations where we want to clean all buffers attached to a page.
+ * We don't need to calculate how many buffers are attached to the page,
+ * we just need to specify a number larger than the maximum number of buffers.
+ */
+void clean_page_buffers(struct page *page)
+{
+	clean_buffers(page, PAGE_SIZE);
+}
+
 static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 		      void *data)
 {
@@ -605,10 +615,8 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 	if (bio == NULL) {
 		if (first_unmapped == blocks_per_page) {
 			if (!bdev_write_page(bdev, blocks[0] << (blkbits - 9),
-								page, wbc)) {
-				clean_buffers(page, first_unmapped);
+								page, wbc))
 				goto out;
-			}
 		}
 		bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
 				BIO_MAX_PAGES, GFP_NOFS|__GFP_HIGH);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index c8dae555eccf..446b24cac67d 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -232,6 +232,7 @@ int generic_write_end(struct file *, struct address_space *,
 				loff_t, unsigned, unsigned,
 				struct page *, void *);
 void page_zero_new_buffers(struct page *page, unsigned from, unsigned to);
+void clean_page_buffers(struct page *page);
 int cont_write_begin(struct file *, struct address_space *, loff_t,
 			unsigned, unsigned, struct page **, void **,
 			get_block_t *, loff_t *);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
