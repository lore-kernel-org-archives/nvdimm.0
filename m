Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 43C7321F30415
 for <linux-nvdimm@lists.01.org>; Thu, 28 Sep 2017 18:24:16 -0700 (PDT)
Subject: [PATCH v2 1/4] dax: quiet bdev_dax_supported()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Sep 2017 18:21:06 -0700
Message-ID: <150664806686.36094.15885850593435187213.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150664806143.36094.11882924009668860273.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150664806143.36094.11882924009668860273.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Leave it to the caller to decide if bdev_dax_supported() failures are
errors worth emitting to the log.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 30d8a5aedd23..b0cc8117eebe 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -92,21 +92,21 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 	long len;
 
 	if (blocksize != PAGE_SIZE) {
-		pr_err("VFS (%s): error: unsupported blocksize for dax\n",
+		pr_debug("VFS (%s): error: unsupported blocksize for dax\n",
 				sb->s_id);
 		return -EINVAL;
 	}
 
 	err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
 	if (err) {
-		pr_err("VFS (%s): error: unaligned partition for dax\n",
+		pr_debug("VFS (%s): error: unaligned partition for dax\n",
 				sb->s_id);
 		return err;
 	}
 
 	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
 	if (!dax_dev) {
-		pr_err("VFS (%s): error: device does not support dax\n",
+		pr_debug("VFS (%s): error: device does not support dax\n",
 				sb->s_id);
 		return -EOPNOTSUPP;
 	}
@@ -118,7 +118,7 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 	put_dax(dax_dev);
 
 	if (len < 1) {
-		pr_err("VFS (%s): error: dax access failed (%ld)\n",
+		pr_debug("VFS (%s): error: dax access failed (%ld)\n",
 				sb->s_id, len);
 		return len < 0 ? len : -EIO;
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
