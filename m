Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 2/6] tools/testing/nvdimm: mock ioremap_wt
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 11 Jul 2015 10:40:48 -0400
Message-ID: <20150711144047.25013.78168.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150711142806.25013.16924.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150711142806.25013.16924.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, ross.zwisler@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In the 4.2-rc1 merge the default_memremap_pmem() implementation switched
from ioremap_nocache() to ioremap_wt().  Add it to the list of mocked
routines to restore the ability to run the unit tests.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/Kbuild       |    1 +
 tools/testing/nvdimm/test/iomap.c |    6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 8e9b64520ec1..8e020601c773 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -1,3 +1,4 @@
+ldflags-y += --wrap=ioremap_wt
 ldflags-y += --wrap=ioremap_cache
 ldflags-y += --wrap=ioremap_nocache
 ldflags-y += --wrap=iounmap
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index c85a6f6ba559..9f21b150396b 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -77,6 +77,12 @@ void __iomem *__wrap_ioremap_nocache(resource_size_t offset, unsigned long size)
 }
 EXPORT_SYMBOL(__wrap_ioremap_nocache);
 
+void __iomem *__wrap_ioremap_wt(resource_size_t offset, unsigned long size)
+{
+	return __nfit_test_ioremap(offset, size, ioremap_wt);
+}
+EXPORT_SYMBOL(__wrap_ioremap_wt);
+
 void __wrap_iounmap(volatile void __iomem *addr)
 {
 	struct nfit_test_resource *nfit_res;

