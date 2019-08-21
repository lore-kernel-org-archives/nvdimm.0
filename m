Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA81320212CA7
 for <linux-nvdimm@lists.01.org>; Wed, 21 Aug 2019 10:58:52 -0700 (PDT)
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 01/19] dax: remove block device dependencies
Date: Wed, 21 Aug 2019 13:57:02 -0400
Message-Id: <20190821175720.25901-2-vgoyal@redhat.com>
In-Reply-To: <20190821175720.25901-1-vgoyal@redhat.com>
References: <20190821175720.25901-1-vgoyal@redhat.com>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: miklos@szeredi.hu, dgilbert@redhat.com, virtio-fs@redhat.com, stefanha@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

From: Stefan Hajnoczi <stefanha@redhat.com>

Although struct dax_device itself is not tied to a block device, some
DAX code assumes there is a block device.  Make block devices optional
by allowing bdev to be NULL in commonly used DAX APIs.

When there is no block device:
 * Skip the partition offset calculation in bdev_dax_pgoff()
 * Skip the blkdev_issue_zeroout() optimization

Note that more block device assumptions remain but I haven't reach those
code paths yet.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 drivers/dax/super.c | 3 ++-
 fs/dax.c            | 7 ++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 26a654dbc69a..3cbc97f3e653 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -46,7 +46,8 @@ EXPORT_SYMBOL_GPL(dax_read_unlock);
 int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
 		pgoff_t *pgoff)
 {
-	phys_addr_t phys_off = (get_start_sect(bdev) + sector) * 512;
+	sector_t start_sect = bdev ? get_start_sect(bdev) : 0;
+	phys_addr_t phys_off = (start_sect + sector) * 512;
 
 	if (pgoff)
 		*pgoff = PHYS_PFN(phys_off);
diff --git a/fs/dax.c b/fs/dax.c
index 6bf81f931de3..a11147bbaf9e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1046,7 +1046,12 @@ static vm_fault_t dax_load_hole(struct xa_state *xas,
 static bool dax_range_is_aligned(struct block_device *bdev,
 				 unsigned int offset, unsigned int length)
 {
-	unsigned short sector_size = bdev_logical_block_size(bdev);
+	unsigned short sector_size;
+
+	if (!bdev)
+		return false;
+
+	sector_size = bdev_logical_block_size(bdev);
 
 	if (!IS_ALIGNED(offset, sector_size))
 		return false;
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
