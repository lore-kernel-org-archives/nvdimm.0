Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1310D21A18AAA
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 16:16:39 -0700 (PDT)
Subject: [PATCH v4 13/14] libnvdimm,
 pmem: gate cache management on QUEUE_FLAG_WC in pmem_dax_flush()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Jun 2017 16:11:26 -0700
Message-ID: <149748185051.10107.3746460181917620940.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149703989611.20620.6907872165215640212.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149703989611.20620.6907872165215640212.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Some platforms arrange for cpu caches to be flushed on power-fail. On
those platforms there is no requirement that the kernel track and flush
potentially dirty cache lines. Given that we still insert entries into
the radix for locking purposes this patch only disables the cache flush
loop, not the dirty tracking.

Userspace can override the default cache setting via the block device
queue "write_cache" attribute in sysfs.

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v3:
* move the check of QUEUE_FLAG_WC into the pmem driver directly (Jan)

 drivers/nvdimm/pmem.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 06f6c27ec1e9..49938b246a7b 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -244,7 +244,16 @@ static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 static void pmem_dax_flush(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t size)
 {
-	arch_wb_cache_pmem(addr, size);
+	struct pmem_device *pmem = dax_get_private(dax_dev);
+	struct gendisk *disk = pmem->disk;
+	struct request_queue *q = disk->queue;
+
+	/*
+	 * Only perform cache management when the queue has caching
+	 * enabled.
+	 */
+	if (test_bit(QUEUE_FLAG_WC, &q->queue_flags))
+		arch_wb_cache_pmem(addr, size);
 }
 
 static const struct dax_operations pmem_dax_ops = {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
