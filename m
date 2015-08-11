Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 09/10] devres: add devm_memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Aug 2015 23:38:38 -0400
Message-ID: <20150811033838.4987.61972.stgit@otcpl-bsw-rvp-2.jf.intel.com>
In-Reply-To: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com>
References: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: ross.zwisler@linux.intel.com, mcgrof@suse.com, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/io.h |    4 ++++
 kernel/memremap.c  |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/linux/io.h b/include/linux/io.h
index 3fcf6256c088..d8d749abd665 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -80,6 +80,10 @@ int check_signature(const volatile void __iomem *io_addr,
 			const unsigned char *signature, int length);
 void devm_ioremap_release(struct device *dev, void *res);
 
+void *devm_memremap(struct device *dev, resource_size_t offset,
+		size_t size, unsigned long flags);
+void devm_memunmap(struct device *dev, void *addr);
+
 /*
  * Some systems do not have legacy ISA devices.
  * /dev/port is not a valid interface on these systems.
diff --git a/kernel/memremap.c b/kernel/memremap.c
index a293de52e837..1dbe88088aa1 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -10,6 +10,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
+#include <linux/device.h>
 #include <linux/types.h>
 #include <linux/io.h>
 #include <linux/mm.h>
@@ -96,3 +97,42 @@ void memunmap(void *addr)
 		iounmap((void __iomem *) addr);
 }
 EXPORT_SYMBOL(memunmap);
+
+static void devm_memremap_release(struct device *dev, void *res)
+{
+	memunmap(res);
+}
+
+static int devm_memremap_match(struct device *dev, void *res, void *match_data)
+{
+	return *(void **)res == match_data;
+}
+
+void *devm_memremap(struct device *dev, resource_size_t offset,
+		size_t size, unsigned long flags)
+{
+	void **ptr, *addr;
+
+	ptr = devres_alloc(devm_memremap_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	addr = memremap(offset, size, flags);
+	if (addr) {
+		*ptr = addr;
+		devres_add(dev, ptr);
+	} else
+		devres_free(ptr);
+
+	return addr;
+}
+EXPORT_SYMBOL(devm_memremap);
+
+void devm_memunmap(struct device *dev, void *addr)
+{
+	WARN_ON(devres_destroy(dev, devm_memremap_release, devm_memremap_match,
+			       addr));
+	memunmap(addr);
+}
+EXPORT_SYMBOL(devm_memunmap);
+

