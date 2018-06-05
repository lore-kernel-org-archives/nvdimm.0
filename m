Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6147F211E1F6F
 for <linux-nvdimm@lists.01.org>; Tue,  5 Jun 2018 16:58:09 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 3/3] libnvdimm: don't flush power-fail protected CPU caches
Date: Tue,  5 Jun 2018 17:58:02 -0600
Message-Id: <20180605235802.14531-3-ross.zwisler@linux.intel.com>
In-Reply-To: <20180605235802.14531-1-ross.zwisler@linux.intel.com>
References: <20180605235802.14531-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This commit:

5fdf8e5ba566 ("libnvdimm: re-enable deep flush for pmem devices via fsync()")

intended to make sure that deep flush was always available even on
platforms which support a power-fail protected CPU cache.  An unintended
side effect of this change was that we also lost the ability to skip
flushing CPU caches on those power-fail protected CPU cache.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: 5fdf8e5ba566 ("libnvdimm: re-enable deep flush for pmem devices via fsync()")
---
 drivers/dax/super.c   | 14 +++++++++++++-
 drivers/nvdimm/pmem.c |  2 ++
 include/linux/dax.h   |  4 ++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index c2c46f96b18c..80253c531a9b 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -152,6 +152,8 @@ enum dax_device_flags {
 	DAXDEV_ALIVE,
 	/* gate whether dax_flush() calls the low level flush routine */
 	DAXDEV_WRITE_CACHE,
+	/* only flush the CPU caches if they are not power fail protected */
+	DAXDEV_FLUSH_ON_SYNC,
 };
 
 /**
@@ -283,7 +285,8 @@ EXPORT_SYMBOL_GPL(dax_copy_from_iter);
 void arch_wb_cache_pmem(void *addr, size_t size);
 void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
 {
-	if (unlikely(!dax_write_cache_enabled(dax_dev)))
+	if (unlikely(!dax_write_cache_enabled(dax_dev)) ||
+			!test_bit(DAXDEV_FLUSH_ON_SYNC, &dax_dev->flags))
 		return;
 
 	arch_wb_cache_pmem(addr, size);
@@ -310,6 +313,15 @@ bool dax_write_cache_enabled(struct dax_device *dax_dev)
 }
 EXPORT_SYMBOL_GPL(dax_write_cache_enabled);
 
+void dax_flush_on_sync(struct dax_device *dax_dev, bool flush)
+{
+	if (flush)
+		set_bit(DAXDEV_FLUSH_ON_SYNC, &dax_dev->flags);
+	else
+		clear_bit(DAXDEV_FLUSH_ON_SYNC, &dax_dev->flags);
+}
+EXPORT_SYMBOL_GPL(dax_flush_on_sync);
+
 bool dax_alive(struct dax_device *dax_dev)
 {
 	lockdep_assert_held(&dax_srcu);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index a152dd9e4134..e8c2795bf766 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -413,6 +413,8 @@ static int pmem_attach_disk(struct device *dev,
 		return -ENOMEM;
 	}
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
+	dax_flush_on_sync(dax_dev,
+			!test_bit(ND_REGION_PERSIST_CACHE, &nd_region->flags));
 	pmem->dax_dev = dax_dev;
 
 	gendev = disk_to_dev(disk);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index f9eb22ad341e..4575742508b0 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -32,6 +32,7 @@ void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
 bool dax_write_cache_enabled(struct dax_device *dax_dev);
+void dax_flush_on_sync(struct dax_device *dax_dev, bool flush);
 #else
 static inline struct dax_device *dax_get_by_host(const char *host)
 {
@@ -59,6 +60,9 @@ static inline bool dax_write_cache_enabled(struct dax_device *dax_dev)
 {
 	return false;
 }
+static inline void dax_flush_on_sync(struct dax_device *dax_dev, bool flush)
+{
+}
 #endif
 
 struct writeback_control;
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
