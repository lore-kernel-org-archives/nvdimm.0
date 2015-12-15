Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 6/9] libnvdimm, pfn: enable pfn sysfs interface unit testing
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Dec 2015 18:15:00 -0800
Message-ID: <20151215021500.37090.54924.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
References: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: willy@linux.intel.com, ross.zwisler@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The unit test infrastructure uses CMA and real memory to emulate nvdimm
resources.  The call to devm_memremap_pages() can simply be mocked in
the same manner as memremap and we mock phys_to_pfn_t() to clear PFN_MAP
since these resources are not registered with in the pgmap_radix.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/Kbuild       |    2 ++
 tools/testing/nvdimm/test/iomap.c |   30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 38b00ecb2ed5..a34bfd0c8928 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -9,6 +9,8 @@ ldflags-y += --wrap=memunmap
 ldflags-y += --wrap=__devm_request_region
 ldflags-y += --wrap=__request_region
 ldflags-y += --wrap=__release_region
+ldflags-y += --wrap=devm_memremap_pages
+ldflags-y += --wrap=phys_to_pfn_t
 
 DRIVERS := ../../../drivers
 NVDIMM_SRC := $(DRIVERS)/nvdimm
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index b7251314bbc0..802d3a173ccf 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -94,6 +94,36 @@ void *__wrap_devm_memremap(struct device *dev, resource_size_t offset,
 }
 EXPORT_SYMBOL(__wrap_devm_memremap);
 
+void *__wrap_devm_memremap_pages(struct device *dev, struct resource *res)
+{
+	struct nfit_test_resource *nfit_res;
+	resource_size_t offset = res->start;
+
+	rcu_read_lock();
+	nfit_res = get_nfit_res(offset);
+	rcu_read_unlock();
+	if (nfit_res)
+		return nfit_res->buf + offset - nfit_res->res->start;
+	return devm_memremap_pages(dev, res);
+}
+EXPORT_SYMBOL(__wrap_devm_memremap_pages);
+
+#ifdef PFN_MAP
+pfn_t __wrap_phys_to_pfn_t(dma_addr_t addr, unsigned long flags)
+{
+	struct nfit_test_resource *nfit_res;
+
+	rcu_read_lock();
+	nfit_res = get_nfit_res(offset);
+	rcu_read_unlock();
+
+	if (nfit_res)
+		flags &= ~PFN_MAP;
+        return phys_to_pfn_t(addr >> PAGE_SHIFT, flags);
+}
+EXPORT_SYMBOL(__wrap_phys_to_pfn_t);
+#endif
+
 void *__wrap_memremap(resource_size_t offset, size_t size,
 		unsigned long flags)
 {

