Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 2/3] resource: Add iomem_set_desc() to set I/O descriptor
Date: Tue,  2 Feb 2016 11:55:10 -0700
Message-Id: <1454439311-23690-3-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1454439311-23690-1-git-send-email-toshi.kani@hpe.com>
References: <1454439311-23690-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mingo@kernel.org, bp@suse.de, dan.j.williams@intel.com, rjw@rjwysocki.net, akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.0 defines persistent memory ranges in multiple firmware
interfaces, E820_PMEM type in e820, EFI_PERSISTENT_MEMORY type
in EFI, and ACPI NFIT table.  This EFI spec change, however,
hit a bug in the grub bootloader, which handles EFI_PERSISTENT_MEMORY
as regular memory and potentially corrupts stored user data [1].

This issue leads FW vendors to consider using generic reserved
type in e820 and EFI to cover persistent memory, so that no new
type is used in e820 and EFI.  The kernel can initialize persistent
memory from ACPI NFIT table alone.  This basic approach may
continue in future that new types will only be defined to ACPI
tables.

This however causes a problem in the iomem table.  On x86, for
instance, e820_reserve_resources() initializes top-level entries
(iomem_resource.child) from the e820 table in early boot-time.
The reserved type does not provide any specific type information.

Hence, this patch adds iomem_set_desc(), which allows drivers
to set IO descriptor to a corresponding top-level iomem entry
that is not marked as BUSY.  Drivers, such as ACPI drivers, can
call this interface to set a specific type when they enumerate
ACPI tables later in the boot sequence or run-time.

[1] https://lists.gnu.org/archive/html/grub-devel/2015-11/msg00209.html
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/ioport.h |    2 ++
 kernel/resource.c      |   41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index afb4559..54f7435 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -260,6 +260,8 @@ extern void __devm_release_region(struct device *dev, struct resource *parent,
 				  resource_size_t start, resource_size_t n);
 extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
 extern int iomem_is_exclusive(u64 addr);
+extern int iomem_set_desc(resource_size_t start, size_t size,
+	unsigned long desc);
 
 extern int
 walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
diff --git a/kernel/resource.c b/kernel/resource.c
index 9df79ff..7d68297 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1534,6 +1534,47 @@ int iomem_is_exclusive(u64 addr)
 	return err;
 }
 
+/**
+ * iomem_set_desc - set I/O descriptor to the corresponding iomem entry
+ * @start: start address
+ * @size: size of the range
+ * @desc: I/O descriptor
+ *
+ * Set IO descriptor to the corresponding top-level iomem entry.
+ * Return 0 for success, -EBUSY when the entry is marked as BUSY,
+ * -EINVAL when no corresponding entry is found.
+ */
+int iomem_set_desc(resource_size_t start, size_t size, unsigned long desc)
+{
+	resource_size_t end = start + size - 1;
+	struct resource *p;
+	int match = 0, ret = -EINVAL;
+
+	write_lock(&resource_lock);
+
+	for (p = iomem_resource.child; p ; p = p->sibling) {
+		if (p->start < start)
+			continue;
+		if ((p->start == start) && (p->end == end))
+			match = 1;
+		break;
+	}
+
+	if (match) {
+		if (p->flags & IORESOURCE_BUSY) {
+			ret = -EBUSY;
+		} else {
+			p->desc = desc;
+			ret = 0;
+		}
+	}
+
+	write_unlock(&resource_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iomem_set_desc);
+
 struct resource_entry *resource_list_create_entry(struct resource *res,
 						  size_t extra_size)
 {
