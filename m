From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v4] libnvdimm: Enable unit test infrastructure compile checks
Date: Wed, 04 Sep 2019 15:43:31 -0700
Message-ID: <156763690875.2556198.15786177395425033830.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jgg@ziepe.ca
Cc: =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

The infrastructure to mock core libnvdimm routines for unit testing
purposes is prone to bitrot relative to refactoring of that core.
Arrange for the unit test core to be built when CONFIG_COMPILE_TEST=y.
This does not result in a functional unit test environment, it is only a
helper for 0day to catch unit test build regressions.

Note that there are a few x86isms in the implementation, so this does
not bother compile testing this architectures other than 64-bit x86.

Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/156097224232.1086847.9463861924683372741.stgit@dwillia2-desk3.amr.corp.intel.com
---
Changes since v3:

- Switch the Makefile operator from := to += to make sure the unit test
  infrastructure is incrementally included.

Jason, lets try this again. This seems to resolve the build error for
me. I believe ":=" would have intermittent results in a parallel build
and sometimes result in other targets in drivers/nvdimm/Makefile being
bypassed. This has been exposed to the 0day robot for a day with no
reports.


 drivers/nvdimm/Kconfig  |   12 ++++++++++++
 drivers/nvdimm/Makefile |    4 ++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index a5fde15e91d3..36af7af6b7cf 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -118,4 +118,16 @@ config NVDIMM_KEYS
 	depends on ENCRYPTED_KEYS
 	depends on (LIBNVDIMM=ENCRYPTED_KEYS) || LIBNVDIMM=m
 
+config NVDIMM_TEST_BUILD
+	tristate "Build the unit test core"
+	depends on m
+	depends on COMPILE_TEST && X86_64
+	default m if COMPILE_TEST
+	help
+	  Build the core of the unit test infrastructure. The result of
+	  this build is non-functional for unit test execution, but it
+	  otherwise helps catch build errors induced by changes to the
+	  core devm_memremap_pages() implementation and other
+	  infrastructure.
+
 endif
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index cefe233e0b52..29203f3d3069 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -29,3 +29,7 @@ libnvdimm-$(CONFIG_BTT) += btt_devs.o
 libnvdimm-$(CONFIG_NVDIMM_PFN) += pfn_devs.o
 libnvdimm-$(CONFIG_NVDIMM_DAX) += dax_devs.o
 libnvdimm-$(CONFIG_NVDIMM_KEYS) += security.o
+
+TOOLS := ../../tools
+TEST_SRC := $(TOOLS)/testing/nvdimm/test
+obj-$(CONFIG_NVDIMM_TEST_BUILD) += $(TEST_SRC)/iomap.o
