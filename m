Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH RESEND] ACPI/Kconfig: Make ACPI_NFIT depend on EFI_STUB on X86
Date: Tue, 15 Dec 2015 09:59:06 -0700
Message-Id: <1450198746-14161-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, dan.j.williams@intel.com
Cc: elliott@hpe.com, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.0 defines NFIT table and new persistent memory types for
EFI memory table (EFI_PERSISTENT_MEMORY) and e820 table (E820_PMEM).

setup_e820() enabled by EFI_STUB converts EFI_PERSISTENT_MEMORY to
E820_PMEM for the e820_map table on x86 EFI platforms.  When EFI_STUB
is disabled, x86 kernels rely on the bootloader to perform this
conversion.

It was found that the upstream grub bootloader since 2012 has a bug
that converts EFI_PERSISTENT_MEMORY (or any new type) to E820_RAM,
which causes the kernel to use persistent memory ranges as regular
memory and corrupts the data in NVDIMM.

Therefore, this patch sets ACPI_NFIT to depend on EFI_STUB on x86.
This assures that ACPI_NFIT kernels are self-contained and are
protected from the upstream grub bug on x86.

Note, X86_PMEM_LEGACY allows the kernel to use the pmem driver on
pre-ACPI 6.0 platforms, and does not require ACPI_NFIT enabled.

References: http://www.mail-archive.com/grub-devel@gnu.org/msg23961.html
Reported-by: Robert Elliott <elliott@hpe.com>
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 5eef4cb..5368baa 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -441,6 +441,7 @@ config ACPI_NFIT
 	depends on PHYS_ADDR_T_64BIT
 	depends on BLK_DEV
 	depends on ARCH_HAS_MMIO_FLUSH
+	depends on !X86 || (X86 && EFI_STUB)
 	select LIBNVDIMM
 	help
 	  Infrastructure to probe ACPI 6 compliant platforms for
