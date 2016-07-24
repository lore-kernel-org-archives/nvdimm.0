Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 0A8891A1E08
 for <linux-nvdimm@lists.01.org>; Sat, 23 Jul 2016 22:29:13 -0700 (PDT)
Subject: [PATCH v4 3/4] nfit: move to nfit/ sub-directory
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Jul 2016 22:26:48 -0700
Message-ID: <146933800882.26196.8524369982325500693.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146933799257.26196.10157809349693736359.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146933799257.26196.10157809349693736359.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

With the arrival of x86-machine-check support the nfit driver will add a
(conditionally-compiled) source file.  Prepare for this by moving all
nfit source to drivers/acpi/nfit/.  This is pure code movement, no
functional changes.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/Kconfig             |   27 +--------------------------
 drivers/acpi/Makefile            |    2 +-
 drivers/acpi/nfit/Kconfig        |   26 ++++++++++++++++++++++++++
 drivers/acpi/nfit/Makefile       |    2 ++
 drivers/acpi/nfit/core.c         |    0 
 drivers/acpi/nfit/nfit.h         |    0 
 tools/testing/nvdimm/Kbuild      |    4 ++--
 tools/testing/nvdimm/test/Kbuild |    2 +-
 8 files changed, 33 insertions(+), 30 deletions(-)
 create mode 100644 drivers/acpi/nfit/Kconfig
 create mode 100644 drivers/acpi/nfit/Makefile
 rename drivers/acpi/{nfit.c => nfit/core.c} (100%)
 rename drivers/acpi/{nfit.h => nfit/nfit.h} (100%)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index b7e2e776397d..415b148a8698 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -447,32 +447,7 @@ config ACPI_REDUCED_HARDWARE_ONLY
 
 	  If you are unsure what to do, do not enable this option.
 
-config ACPI_NFIT
-	tristate "ACPI NVDIMM Firmware Interface Table (NFIT)"
-	depends on PHYS_ADDR_T_64BIT
-	depends on BLK_DEV
-	depends on ARCH_HAS_MMIO_FLUSH
-	select LIBNVDIMM
-	help
-	  Infrastructure to probe ACPI 6 compliant platforms for
-	  NVDIMMs (NFIT) and register a libnvdimm device tree.  In
-	  addition to storage devices this also enables libnvdimm to pass
-	  ACPI._DSM messages for platform/dimm configuration.
-
-	  To compile this driver as a module, choose M here:
-	  the module will be called nfit.
-
-config ACPI_NFIT_DEBUG
-	bool "NFIT DSM debug"
-	depends on ACPI_NFIT
-	depends on DYNAMIC_DEBUG
-	default n
-	help
-	  Enabling this option causes the nfit driver to dump the
-	  input and output buffers of _DSM operations on the ACPI0012
-	  device and its children.  This can be very verbose, so leave
-	  it disabled unless you are debugging a hardware / firmware
-	  issue.
+source "drivers/acpi/nfit/Kconfig"
 
 source "drivers/acpi/apei/Kconfig"
 
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 251ce85a66fb..64a575a6f7ef 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -70,7 +70,7 @@ obj-$(CONFIG_ACPI_PCI_SLOT)	+= pci_slot.o
 obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
 obj-$(CONFIG_ACPI)		+= container.o
 obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
-obj-$(CONFIG_ACPI_NFIT)		+= nfit.o
+obj-$(CONFIG_ACPI_NFIT)		+= nfit/
 obj-$(CONFIG_ACPI)		+= acpi_memhotplug.o
 obj-$(CONFIG_ACPI_HOTPLUG_IOAPIC) += ioapic.o
 obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
diff --git a/drivers/acpi/nfit/Kconfig b/drivers/acpi/nfit/Kconfig
new file mode 100644
index 000000000000..dd0d53c52552
--- /dev/null
+++ b/drivers/acpi/nfit/Kconfig
@@ -0,0 +1,26 @@
+config ACPI_NFIT
+	tristate "ACPI NVDIMM Firmware Interface Table (NFIT)"
+	depends on PHYS_ADDR_T_64BIT
+	depends on BLK_DEV
+	depends on ARCH_HAS_MMIO_FLUSH
+	select LIBNVDIMM
+	help
+	  Infrastructure to probe ACPI 6 compliant platforms for
+	  NVDIMMs (NFIT) and register a libnvdimm device tree.  In
+	  addition to storage devices this also enables libnvdimm to pass
+	  ACPI._DSM messages for platform/dimm configuration.
+
+	  To compile this driver as a module, choose M here:
+	  the module will be called nfit.
+
+config ACPI_NFIT_DEBUG
+	bool "NFIT DSM debug"
+	depends on ACPI_NFIT
+	depends on DYNAMIC_DEBUG
+	default n
+	help
+	  Enabling this option causes the nfit driver to dump the
+	  input and output buffers of _DSM operations on the ACPI0012
+	  device and its children.  This can be very verbose, so leave
+	  it disabled unless you are debugging a hardware / firmware
+	  issue.
diff --git a/drivers/acpi/nfit/Makefile b/drivers/acpi/nfit/Makefile
new file mode 100644
index 000000000000..eb95c5aff83b
--- /dev/null
+++ b/drivers/acpi/nfit/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_ACPI_NFIT) := nfit.o
+nfit-y := core.o
diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit/core.c
similarity index 100%
rename from drivers/acpi/nfit.c
rename to drivers/acpi/nfit/core.c
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit/nfit.h
similarity index 100%
rename from drivers/acpi/nfit.h
rename to drivers/acpi/nfit/nfit.h
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 62d5ac3c988e..0dca8ff7557b 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -16,7 +16,7 @@ ldflags-y += --wrap=remove_resource
 
 DRIVERS := ../../../drivers
 NVDIMM_SRC := $(DRIVERS)/nvdimm
-ACPI_SRC := $(DRIVERS)/acpi
+ACPI_SRC := $(DRIVERS)/acpi/nfit
 DAX_SRC := $(DRIVERS)/dax
 ccflags-y := -I$(src)/$(NVDIMM_SRC)/
 
@@ -29,7 +29,7 @@ obj-$(CONFIG_ACPI_NFIT) += nfit.o
 obj-$(CONFIG_DEV_DAX) += dax.o
 obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
 
-nfit-y := $(ACPI_SRC)/nfit.o
+nfit-y := $(ACPI_SRC)/core.o
 nfit-y += config_check.o
 
 nd_pmem-y := $(NVDIMM_SRC)/pmem.o
diff --git a/tools/testing/nvdimm/test/Kbuild b/tools/testing/nvdimm/test/Kbuild
index 9241064970fe..d32f25bba42a 100644
--- a/tools/testing/nvdimm/test/Kbuild
+++ b/tools/testing/nvdimm/test/Kbuild
@@ -1,5 +1,5 @@
 ccflags-y := -I$(src)/../../../../drivers/nvdimm/
-ccflags-y += -I$(src)/../../../../drivers/acpi/
+ccflags-y += -I$(src)/../../../../drivers/acpi/nfit/
 
 obj-m += nfit_test.o
 obj-m += nfit_test_iomap.o

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
