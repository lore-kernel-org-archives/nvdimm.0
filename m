Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ABEF621B02B9D
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 10:59:00 -0700 (PDT)
Subject: [PATCH v4 13/16] dax: remove default copy_from_iter fallback
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 10:54:07 -0700
Message-ID: <149875884723.10031.5829298075873663997.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, hch@lst.de, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

Require all dax-drivers to register a ->copy_from_iter() operation so
that it is clear which dax_operations are optional and which must be
implemented for filesystem-dax to operate.

Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/powerpc/sysdev/axonram.c |    8 ++++++++
 drivers/block/brd.c           |    8 ++++++++
 drivers/dax/super.c           |    2 --
 drivers/s390/block/dcssblk.c  |    8 ++++++++
 include/linux/dax.h           |    2 +-
 5 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index a7fe5fee744f..2799706106c6 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -45,6 +45,7 @@
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
 #include <linux/pfn_t.h>
+#include <linux/uio.h>
 
 #include <asm/page.h>
 #include <asm/prom.h>
@@ -163,8 +164,15 @@ axon_ram_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pa
 	return __axon_ram_direct_access(bank, pgoff, nr_pages, kaddr, pfn);
 }
 
+static size_t axon_ram_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i)
+{
+	return copy_from_iter(addr, bytes, i);
+}
+
 static const struct dax_operations axon_ram_dax_ops = {
 	.direct_access = axon_ram_dax_direct_access,
+	.copy_from_iter = axon_ram_copy_from_iter,
 };
 
 /**
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 57b574f2f66a..f2a7ac350f6a 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -22,6 +22,7 @@
 #ifdef CONFIG_BLK_DEV_RAM_DAX
 #include <linux/pfn_t.h>
 #include <linux/dax.h>
+#include <linux/uio.h>
 #endif
 
 #include <linux/uaccess.h>
@@ -354,8 +355,15 @@ static long brd_dax_direct_access(struct dax_device *dax_dev,
 	return __brd_direct_access(brd, pgoff, nr_pages, kaddr, pfn);
 }
 
+static size_t brd_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i)
+{
+	return copy_from_iter(addr, bytes, i);
+}
+
 static const struct dax_operations brd_dax_ops = {
 	.direct_access = brd_dax_direct_access,
+	.copy_from_iter = brd_dax_copy_from_iter,
 };
 #endif
 
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index b7729e4d351a..9e0160b950d7 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -179,8 +179,6 @@ size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 	if (!dax_alive(dax_dev))
 		return 0;
 
-	if (!dax_dev->ops->copy_from_iter)
-		return copy_from_iter(addr, bytes, i);
 	return dax_dev->ops->copy_from_iter(dax_dev, pgoff, addr, bytes, i);
 }
 EXPORT_SYMBOL_GPL(dax_copy_from_iter);
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 36e5280af3e4..88fa7b3f7a9d 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/pfn_t.h>
+#include <linux/uio.h>
 #include <linux/dax.h>
 #include <asm/extmem.h>
 #include <asm/io.h>
@@ -43,8 +44,15 @@ static const struct block_device_operations dcssblk_devops = {
 	.release 	= dcssblk_release,
 };
 
+static size_t dcssblk_dax_copy_from_iter(struct dax_device *dax_dev,
+		pgoff_t pgoff, void *addr, size_t bytes, struct iov_iter *i)
+{
+	return copy_from_iter(addr, bytes, i);
+}
+
 static const struct dax_operations dcssblk_dax_ops = {
 	.direct_access = dcssblk_dax_direct_access,
+	.copy_from_iter = dcssblk_dax_copy_from_iter,
 };
 
 struct dcssblk_dev_info {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 1f6b6072af64..73fca1bebaf3 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -16,7 +16,7 @@ struct dax_operations {
 	 */
 	long (*direct_access)(struct dax_device *, pgoff_t, long,
 			void **, pfn_t *);
-	/* copy_from_iter: dax-driver override for default copy_from_iter */
+	/* copy_from_iter: required operation for fs-dax direct-i/o */
 	size_t (*copy_from_iter)(struct dax_device *, pgoff_t, void *, size_t,
 			struct iov_iter *);
 	/* flush: optional driver-specific cache management after writes */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
