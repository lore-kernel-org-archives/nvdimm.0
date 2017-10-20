Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E91A72034C0B7
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 22:20:31 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/2] dm log writes: Add support for inline data buffers
Date: Thu, 19 Oct 2017 23:24:03 -0600
Message-Id: <20171020052404.13762-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Currently dm-log-writes supports writing filesystem data via BIOs, and
writing internal metadata from a flat buffer via write_metadata().

For DAX writes, though, we won't have a BIO, but will instead have an
iterator that we'll want to use to fill a flat data buffer.

So, create write_inline_data() which allows us to write filesystem data
using a flat buffer as a source, and wire it up in log_one_block().

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/md/dm-log-writes.c | 90 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 86 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 8b80a9c..c65f9d1 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -246,27 +246,109 @@ static int write_metadata(struct log_writes_c *lc, void *entry,
 	return -1;
 }
 
+static int write_inline_data(struct log_writes_c *lc, void *entry,
+			  size_t entrylen, void *data, size_t datalen,
+			  sector_t sector)
+{
+	int num_pages, bio_pages, pg_datalen, pg_sectorlen, i;
+	struct page *page;
+	struct bio *bio;
+	size_t ret;
+	void *ptr;
+
+	while (datalen) {
+		num_pages = ALIGN(datalen, PAGE_SIZE) >> PAGE_SHIFT;
+		bio_pages = min(num_pages, BIO_MAX_PAGES);
+
+		atomic_inc(&lc->io_blocks);
+
+		bio = bio_alloc(GFP_KERNEL, bio_pages);
+		if (!bio) {
+			DMERR("Couldn't alloc inline data bio");
+			goto error;
+		}
+
+		bio->bi_iter.bi_size = 0;
+		bio->bi_iter.bi_sector = sector;
+		bio_set_dev(bio, lc->logdev->bdev);
+		bio->bi_end_io = log_end_io;
+		bio->bi_private = lc;
+		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+
+		for (i = 0; i < bio_pages; i++) {
+			pg_datalen = min(datalen, PAGE_SIZE);
+			pg_sectorlen = ALIGN(pg_datalen, lc->sectorsize);
+
+			page = alloc_page(GFP_KERNEL);
+			if (!page) {
+				DMERR("Couldn't alloc inline data page");
+				goto error_bio;
+			}
+
+			ptr = kmap_atomic(page);
+			memcpy(ptr, data, pg_datalen);
+			if (pg_sectorlen > pg_datalen)
+				memset(ptr + pg_datalen, 0,
+						pg_sectorlen - pg_datalen);
+			kunmap_atomic(ptr);
+
+			ret = bio_add_page(bio, page, pg_sectorlen, 0);
+			if (ret != pg_sectorlen) {
+				DMERR("Couldn't add page of inline data");
+				__free_page(page);
+				goto error_bio;
+			}
+
+			datalen -= pg_datalen;
+			data	+= pg_datalen;
+		}
+		submit_bio(bio);
+
+		sector += bio_pages * PAGE_SECTORS;
+	}
+	return 0;
+error_bio:
+	bio_free_pages(bio);
+	bio_put(bio);
+error:
+	put_io_block(lc);
+	return -1;
+}
+
 static int log_one_block(struct log_writes_c *lc,
 			 struct pending_block *block, sector_t sector)
 {
 	struct bio *bio;
 	struct log_write_entry entry;
-	size_t ret;
+	size_t metadlen, ret;
 	int i;
 
 	entry.sector = cpu_to_le64(block->sector);
 	entry.nr_sectors = cpu_to_le64(block->nr_sectors);
 	entry.flags = cpu_to_le64(block->flags);
 	entry.data_len = cpu_to_le64(block->datalen);
-	if (write_metadata(lc, &entry, sizeof(entry), block->data,
-			   block->datalen, sector)) {
+
+	metadlen = (block->flags & LOG_MARK_FLAG) ?  block->datalen : 0;
+	if (write_metadata(lc, &entry, sizeof(entry), block->data, metadlen,
+				sector)) {
 		free_pending_block(lc, block);
 		return -1;
 	}
 
+	sector += dev_to_bio_sectors(lc, 1);
+
+	if (block->datalen && metadlen == 0) {
+		if (write_inline_data(lc, &entry, sizeof(entry), block->data,
+					block->datalen, sector)) {
+			free_pending_block(lc, block);
+			return -1;
+		}
+		/* we don't support both inline data & bio data */
+		goto out;
+	}
+
 	if (!block->vec_cnt)
 		goto out;
-	sector += dev_to_bio_sectors(lc, 1);
 
 	atomic_inc(&lc->io_blocks);
 	bio = bio_alloc(GFP_KERNEL, min(block->vec_cnt, BIO_MAX_PAGES));
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
