Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 01/21] e820, efi: add ACPI 6.0 persistent memory types
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Apr 2015 21:35:19 -0400
Message-ID: <20150418013519.25237.16129.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Boaz Harrosh <boaz@plexistor.com>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.0 formalizes e820-type-7 and efi-type-14 as persistent memory.
Mark it "reserved" and allow it to be claimed by a persistent memory
device driver.

This definition is in addition to the Linux kernel's existing type-12
definition that was recently added in support of shipping platforms with
NVDIMM support that predate ACPI 6.0 (which now classifies type-12 as
OEM reserved).  We may choose to exploit this wealth of definitions for
NVDIMMs to differentiate E820_PRAM (type-12) from E820_PMEM (type-7).
One potential differentiation is that PMEM is not backed by struct page
by default in contrast to PRAM.  For now, they are effectively treated
as aliases by the mm.

Note, /proc/iomem can be consulted for differentiating legacy
"Persistent RAM" E820_PRAM vs standard "Persistent I/O Memory"
E820_PMEM.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 arch/arm64/kernel/efi.c          |    1 +
 arch/ia64/kernel/efi.c           |    1 +
 arch/x86/boot/compressed/eboot.c |    4 ++++
 arch/x86/include/uapi/asm/e820.h |    1 +
 arch/x86/kernel/e820.c           |   25 +++++++++++++++++++------
 arch/x86/platform/efi/efi.c      |    3 +++
 include/linux/efi.h              |    3 ++-
 7 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index ab21e0d58278..9d4aa18f2a82 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -158,6 +158,7 @@ static __init int is_reserve_region(efi_memory_desc_t *md)
 	case EFI_BOOT_SERVICES_CODE:
 	case EFI_BOOT_SERVICES_DATA:
 	case EFI_CONVENTIONAL_MEMORY:
+	case EFI_PERSISTENT_MEMORY:
 		return 0;
 	default:
 		break;
diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index c52d7540dc05..cd8b7485e396 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -1227,6 +1227,7 @@ efi_initialize_iomem_resources(struct resource *code_resource,
 			case EFI_RUNTIME_SERVICES_CODE:
 			case EFI_RUNTIME_SERVICES_DATA:
 			case EFI_ACPI_RECLAIM_MEMORY:
+			case EFI_PERSISTENT_MEMORY:
 			default:
 				name = "reserved";
 				break;
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ef17683484e9..dde5bf7726f4 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1222,6 +1222,10 @@ static efi_status_t setup_e820(struct boot_params *params,
 			e820_type = E820_NVS;
 			break;
 
+		case EFI_PERSISTENT_MEMORY:
+			e820_type = E820_PMEM;
+			break;
+
 		default:
 			continue;
 		}
diff --git a/arch/x86/include/uapi/asm/e820.h b/arch/x86/include/uapi/asm/e820.h
index 960a8a9dc4ab..0f457e6eab18 100644
--- a/arch/x86/include/uapi/asm/e820.h
+++ b/arch/x86/include/uapi/asm/e820.h
@@ -32,6 +32,7 @@
 #define E820_ACPI	3
 #define E820_NVS	4
 #define E820_UNUSABLE	5
+#define E820_PMEM	7
 
 /*
  * This is a non-standardized way to represent ADR or NVDIMM regions that
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 11cc7d54ec3f..410af501a941 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -137,6 +137,8 @@ static void __init e820_print_type(u32 type)
 	case E820_RESERVED_KERN:
 		printk(KERN_CONT "usable");
 		break;
+	case E820_PMEM:
+	case E820_PRAM:
 	case E820_RESERVED:
 		printk(KERN_CONT "reserved");
 		break;
@@ -149,9 +151,6 @@ static void __init e820_print_type(u32 type)
 	case E820_UNUSABLE:
 		printk(KERN_CONT "unusable");
 		break;
-	case E820_PRAM:
-		printk(KERN_CONT "persistent (type %u)", type);
-		break;
 	default:
 		printk(KERN_CONT "type %u", type);
 		break;
@@ -919,10 +918,26 @@ static inline const char *e820_type_to_string(int e820_type)
 	case E820_NVS:	return "ACPI Non-volatile Storage";
 	case E820_UNUSABLE:	return "Unusable memory";
 	case E820_PRAM: return "Persistent RAM";
+	case E820_PMEM: return "Persistent I/O Memory";
 	default:	return "reserved";
 	}
 }
 
+static bool do_mark_busy(u32 type, struct resource *res)
+{
+	if (res->start < (1ULL<<20))
+		return true;
+
+	switch (type) {
+	case E820_RESERVED:
+	case E820_PRAM:
+	case E820_PMEM:
+		return false;
+	default:
+		return true;
+	}
+}
+
 /*
  * Mark e820 reserved areas as busy for the resource manager.
  */
@@ -952,9 +967,7 @@ void __init e820_reserve_resources(void)
 		 * pci device BAR resource and insert them later in
 		 * pcibios_resource_survey()
 		 */
-		if (((e820.map[i].type != E820_RESERVED) &&
-		     (e820.map[i].type != E820_PRAM)) ||
-		     res->start < (1ULL<<20)) {
+		if (do_mark_busy(e820.map[i].type, res)) {
 			res->flags |= IORESOURCE_BUSY;
 			insert_resource(&iomem_resource, res);
 		}
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index dbc8627a5cdf..a116e236ac3f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -145,6 +145,9 @@ static void __init do_add_efi_memmap(void)
 		case EFI_UNUSABLE_MEMORY:
 			e820_type = E820_UNUSABLE;
 			break;
+		case EFI_PERSISTENT_MEMORY:
+			e820_type = E820_PMEM;
+			break;
 		default:
 			/*
 			 * EFI_RESERVED_TYPE EFI_RUNTIME_SERVICES_CODE
diff --git a/include/linux/efi.h b/include/linux/efi.h
index cf7e431cbc73..28868504aa17 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -85,7 +85,8 @@ typedef	struct {
 #define EFI_MEMORY_MAPPED_IO		11
 #define EFI_MEMORY_MAPPED_IO_PORT_SPACE	12
 #define EFI_PAL_CODE			13
-#define EFI_MAX_MEMORY_TYPE		14
+#define EFI_PERSISTENT_MEMORY		14
+#define EFI_MAX_MEMORY_TYPE		15
 
 /* Attribute values: */
 #define EFI_MEMORY_UC		((u64)0x0000000000000001ULL)	/* uncached */

