Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v6 09/21] libnvdimm, pmem: move pmem to drivers/nvdimm/
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Jun 2015 16:10:58 -0400
Message-ID: <20150611201058.25175.1129.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Prepare the pmem driver to consume PMEM namespaces emitted by regions of
an nvdimm_bus instance.  No functional change.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/Kconfig   |   11 -----------
 drivers/block/Makefile  |    1 -
 drivers/nvdimm/Kconfig  |   22 +++++++++++++++++++++-
 drivers/nvdimm/Makefile |    3 +++
 drivers/nvdimm/pmem.c   |    0 
 5 files changed, 24 insertions(+), 13 deletions(-)
 rename drivers/{block/pmem.c => nvdimm/pmem.c} (100%)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index eb1fed5bd516..1b8094d4d7af 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -404,17 +404,6 @@ config BLK_DEV_RAM_DAX
 	  and will prevent RAM block device backing store memory from being
 	  allocated from highmem (only a problem for highmem systems).
 
-config BLK_DEV_PMEM
-	tristate "Persistent memory block device support"
-	help
-	  Saying Y here will allow you to use a contiguous range of reserved
-	  memory as one or more persistent block devices.
-
-	  To compile this driver as a module, choose M here: the module will be
-	  called 'pmem'.
-
-	  If unsure, say N.
-
 config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
 	depends on !UML
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 9cc6c18a1c7e..02b688d1438d 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -14,7 +14,6 @@ obj-$(CONFIG_PS3_VRAM)		+= ps3vram.o
 obj-$(CONFIG_ATARI_FLOPPY)	+= ataflop.o
 obj-$(CONFIG_AMIGA_Z2RAM)	+= z2ram.o
 obj-$(CONFIG_BLK_DEV_RAM)	+= brd.o
-obj-$(CONFIG_BLK_DEV_PMEM)	+= pmem.o
 obj-$(CONFIG_BLK_DEV_LOOP)	+= loop.o
 obj-$(CONFIG_BLK_CPQ_DA)	+= cpqarray.o
 obj-$(CONFIG_BLK_CPQ_CISS_DA)  += cciss.o
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 92933551f846..b5e2f8b22423 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -1,4 +1,4 @@
-config LIBNVDIMM
+menuconfig LIBNVDIMM
 	tristate "NVDIMM (Non-Volatile Memory Device) Support"
 	depends on PHYS_ADDR_T_64BIT
 	depends on BLK_DEV
@@ -13,3 +13,23 @@ config LIBNVDIMM
 	  CONFIG_DAX).  A BLK namespace refers to an NVDIMM control
 	  region which exposes an mmio register set for windowed
 	  access mode to non-volatile memory.
+
+if LIBNVDIMM
+
+config BLK_DEV_PMEM
+	tristate "PMEM: Persistent memory block device support"
+	default LIBNVDIMM
+	help
+	  Memory ranges for PMEM are described by either an NFIT
+	  (NVDIMM Firmware Interface Table, see CONFIG_NFIT_ACPI), a
+	  non-standard OEM-specific E820 memory type (type-12, see
+	  CONFIG_X86_PMEM_LEGACY), or it is manually specified by the
+	  'memmap=nn[KMG]!ss[KMG]' kernel command line (see
+	  Documentation/kernel-parameters.txt).  This driver converts
+	  these persistent memory ranges into block devices that are
+	  capable of DAX (direct-access) file system mappings.  See
+	  Documentation/nvdimm/nvdimm.txt for more details.
+
+	  Say Y if you want to use an NVDIMM
+
+endif
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index af5e2760ddbd..4d2a27f52faa 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -1,4 +1,7 @@
 obj-$(CONFIG_LIBNVDIMM) += libnvdimm.o
+obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
+
+nd_pmem-y := pmem.o
 
 libnvdimm-y := core.o
 libnvdimm-y += bus.o
diff --git a/drivers/block/pmem.c b/drivers/nvdimm/pmem.c
similarity index 100%
rename from drivers/block/pmem.c
rename to drivers/nvdimm/pmem.c

