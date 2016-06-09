Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x229.google.com (mail-wm0-x229.google.com
 [IPv6:2a00:1450:400c:c09::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F26A1A1DFA
 for <linux-nvdimm@lists.01.org>; Thu,  9 Jun 2016 10:42:56 -0700 (PDT)
Received: by mail-wm0-x229.google.com with SMTP id k204so70524356wmk.0
 for <linux-nvdimm@lists.01.org>; Thu, 09 Jun 2016 10:42:35 -0700 (PDT)
From: Yigal Korman <yigal@plexistor.com>
Subject: [PATCH] efi: kernel param for legacy NVDIMM support
Date: Thu,  9 Jun 2016 20:42:22 +0300
Message-Id: <1465494142-1456010-1-git-send-email-yigal@plexistor.com>
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
To: matt@codeblueprint.co.uk, linux-efi@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The 'efi_legacy_pmem' parameter will convert EFI persistent memory range
(type 14) into E820 legacy NVDIMM (type 12) memory range.

Background:

In contrast with the NVDIMM E820 types where we can clearly distinguish
between old NVDIMMs (type-12) and ACPI 6.0 NVDIMMs (type-7), the EFI
memory types for NVDIMMs are the same before ACPI 6.0 and after
(type-14).
This means that old NVDIMMs under EFI aren't supported even though
they work fine if booted with BIOS (E820).

So allow the user to explicitly request the kernel to identify NVDIMMs
as legacy under EFI.

Signed-off-by: Yigal Korman <yigal@plexistor.com>
---
 Documentation/kernel-parameters.txt |  3 +++
 arch/x86/platform/efi/efi.c         | 31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9a53c92..58f2a9b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -394,6 +394,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	add_efi_memmap	[EFI; X86] Include EFI memory map in
 			kernel's map of available physical RAM.
 
+	efi_legacy_pmem	[EFI; X86] Convert EFI_PERSISTENT_MEMORY to E820_PRAM
+			and add it to E820 memmap for legacy NVDIMM support.
+
 	agp=		[AGP]
 			{ off | try_unsupported }
 			off: disable AGP support
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ad28540..5e82532 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -78,6 +78,14 @@ static int __init setup_add_efi_memmap(char *arg)
 }
 early_param("add_efi_memmap", setup_add_efi_memmap);
 
+static int add_legacy_pmem __initdata;
+static int __init setup_add_legacy_pmem(char *arg)
+{
+	add_legacy_pmem = 1;
+	return 0;
+}
+early_param("efi_legacy_pmem", setup_add_legacy_pmem);
+
 static efi_status_t __init phys_efi_set_virtual_address_map(
 	unsigned long memory_map_size,
 	unsigned long descriptor_size,
@@ -191,6 +199,26 @@ static void __init do_add_efi_memmap(void)
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
 
+static void __init do_add_legacy_pmem(void)
+{
+	void *p;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		efi_memory_desc_t *md = p;
+
+		if (md->type == EFI_PERSISTENT_MEMORY) {
+			pr_info("Registering %lluMB as PRAM in E820\n",
+				(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+
+			e820_add_region(md->phys_addr,
+					md->num_pages << EFI_PAGE_SHIFT,
+					E820_PRAM);
+		}
+
+	}
+	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+}
+
 int __init efi_memblock_x86_reserve_range(void)
 {
 	struct efi_info *e = &boot_params.efi_info;
@@ -455,6 +483,9 @@ static int __init efi_memmap_init(void)
 	if (add_efi_memmap)
 		do_add_efi_memmap();
 
+	if (add_legacy_pmem)
+		do_add_legacy_pmem();
+
 	set_bit(EFI_MEMMAP, &efi.flags);
 
 	return 0;
-- 
1.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
