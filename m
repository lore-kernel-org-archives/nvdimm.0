Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A8E3E21BADAB6
 for <linux-nvdimm@lists.01.org>; Tue, 29 May 2018 12:51:11 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 3/7] dm: fix test for DAX device support
Date: Tue, 29 May 2018 13:51:02 -0600
Message-Id: <20180529195106.14268-4-ross.zwisler@linux.intel.com>
In-Reply-To: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
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
To: Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Currently device_supports_dax() just checks to see if the QUEUE_FLAG_DAX
flag is set on the device's request queue to decide whether or not the
device supports filesystem DAX.  This is insufficient because there are
devices like PMEM namespaces in raw mode which have QUEUE_FLAG_DAX set but
which don't actually support DAX.

This means that you could create a dm-linear device, for example, where the
first part of the dm-linear device was a PMEM namespace in fsdax mode and
the second part was a PMEM namespace in raw mode.  Both DM and the
filesystem you put on that dm-linear device would think the whole device
supports DAX, which would lead to bad behavior once your raw PMEM namespace
part using DAX needed struct page for something.

Fix this by using bdev_dax_supported() like filesystems do at mount time.
This checks for raw mode and also performs other tests like checking to
make sure the dax_direct_access() path works.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: commit 545ed20e6df6 ("dm: add infrastructure for DAX support")
---
 drivers/md/dm-table.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0589a4da12bb..5bb994b012ca 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -885,9 +885,7 @@ EXPORT_SYMBOL_GPL(dm_table_set_type);
 static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
 			       sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
-
-	return q && blk_queue_dax(q);
+	return bdev_dax_supported(dev->bdev, PAGE_SIZE);
 }
 
 static bool dm_table_supports_dax(struct dm_table *t)
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
