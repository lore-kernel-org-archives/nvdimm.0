Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3AE7321CAD9BA
 for <linux-nvdimm@lists.01.org>; Fri, 25 May 2018 15:01:01 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH resend 4/7] dm: prevent DAX mounts if not supported
Date: Fri, 25 May 2018 16:00:52 -0600
Message-Id: <20180525220055.18920-5-ross.zwisler@linux.intel.com>
In-Reply-To: <20180525220055.18920-1-ross.zwisler@linux.intel.com>
References: <20180525220055.18920-1-ross.zwisler@linux.intel.com>
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

Currently the code in dm_dax_direct_access() only checks whether the target
type has a direct_access() operation defined, not whether the underlying
block devices all support DAX.  This latter property can be seen by looking
at whether we set the QUEUE_FLAG_DAX request queue flag when creating the
DM device.

This is problematic if we have, for example, a dm-linear device made up of
a PMEM namespace in fsdax mode followed by a ramdisk from BRD.
QUEUE_FLAG_DAX won't be set on the dm-linear device's request queue, but
we have a working direct_access() entry point and the first member of the
dm-linear set *does* support DAX.

This allows the user to create a filesystem on the dm-linear device, and
then mount it with DAX.  The filesystem's bdev_dax_supported() test will
pass because it'll operate on the first member of the dm-linear device,
which happens to be a fsdax PMEM namespace.

All DAX I/O will then fail to that dm-linear device because the lack of
QUEUE_FLAG_DAX prevents fs_dax_get_by_bdev() from working.  This means that
the struct dax_device isn't ever set in the filesystem, so
dax_direct_access() will always return -EOPNOTSUPP.

By failing out of dm_dax_direct_access() if QUEUE_FLAG_DAX isn't set we let
the filesystem know we don't support DAX at mount time.  The filesystem
will then silently fall back and remove the dax mount option, causing it to
work properly.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: commit 545ed20e6df6 ("dm: add infrastructure for DAX support")
---
 drivers/md/dm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0a7b0107ca78..9728433362d1 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1050,14 +1050,13 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 
 	if (!ti)
 		goto out;
-	if (!ti->type->direct_access)
+	if (!blk_queue_dax(md->queue))
 		goto out;
 	len = max_io_len(sector, ti) / PAGE_SECTORS;
 	if (len < 1)
 		goto out;
 	nr_pages = min(len, nr_pages);
-	if (ti->type->direct_access)
-		ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
+	ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
 
  out:
 	dm_put_live_table(md, srcu_idx);
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
