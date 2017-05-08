Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 84C4121A0BA8E
 for <linux-nvdimm@lists.01.org>; Mon,  8 May 2017 14:09:37 -0700 (PDT)
Subject: [PATCH 1/2] block, dax: move "select DAX" from BLOCK to FS_DAX
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 08 May 2017 14:03:43 -0700
Message-ID: <149427742346.38205.12361226658239922137.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-block@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

For configurations that do not enable DAX filesystems or drivers, do not
require the DAX core to be built.

The only core block routine that calls a DAX routine is
bdev_dax_supported(), that now fails by default as expected if FS_DAX=n,
or no DAX-capable drivers are configured.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/Kconfig       |    1 -
 fs/Kconfig          |    1 +
 include/linux/dax.h |   37 ++++++++++++++++++++++++++++++++++---
 3 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 93da7fc3f254..e9f780f815f5 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -6,7 +6,6 @@ menuconfig BLOCK
        default y
        select SBITMAP
        select SRCU
-       select DAX
        help
 	 Provide block layer support for the kernel.
 
diff --git a/fs/Kconfig b/fs/Kconfig
index 83eab52fb3f6..b0e42b6a96b9 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -39,6 +39,7 @@ config FS_DAX
 	depends on MMU
 	depends on !(ARM || MIPS || SPARC)
 	select FS_IOMAP
+	select DAX
 	help
 	  Direct Access (DAX) can be used on memory-backed block devices.
 	  If the block device supports DAX and the filesystem supports DAX,
diff --git a/include/linux/dax.h b/include/linux/dax.h
index d3158e74a59e..e3fa0ad5a12d 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -18,17 +18,48 @@ struct dax_operations {
 			void **, pfn_t *);
 };
 
+#if IS_ENABLED(CONFIG_DAX)
 int dax_read_lock(void);
 void dax_read_unlock(int id);
 struct dax_device *dax_get_by_host(const char *host);
+void put_dax(struct dax_device *dax_dev);
+long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
+		void **kaddr, pfn_t *pfn);
+#else
+static inline int dax_read_lock(void)
+{
+	/* all dax operations inside this lock will fail below */
+	return 0;
+}
+
+static inline void dax_read_unlock(int id)
+{
+}
+
+static inline struct dax_device *dax_get_by_host(const char *host)
+{
+	return NULL;
+}
+
+static inline void put_dax(struct dax_device *dax_dev)
+{
+}
+
+static inline long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn)
+{
+	/* avoid 'uninitialized variable' warnings for @kaddr and @pfn */
+	*pfn = (pfn_t) { .val = ULLONG_MAX };
+	*kaddr = (void *) ULONG_MAX;
+
+	return -EOPNOTSUPP;
+}
+#endif
 struct dax_device *alloc_dax(void *private, const char *host,
 		const struct dax_operations *ops);
-void put_dax(struct dax_device *dax_dev);
 bool dax_alive(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
 void *dax_get_private(struct dax_device *dax_dev);
-long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
-		void **kaddr, pfn_t *pfn);
 
 /*
  * We use lowest available bit in exceptional entry for locking, one bit for

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
