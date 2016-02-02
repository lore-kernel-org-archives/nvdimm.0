Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 0/3] Support persistent memory as reserved type in e820/EFI
Date: Tue,  2 Feb 2016 11:55:08 -0700
Message-Id: <1454439311-23690-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mingo@kernel.org, bp@suse.de, dan.j.williams@intel.com, rjw@rjwysocki.net, akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch-set introduces iomem_set_desc() to allow drivers, such
as ACPI drivers, to set I/O descriptor to a corresponding top-level
iomem entry when they enumerate ACPI tables later in the boot sequence
or run-time.

[1] https://lists.gnu.org/archive/html/grub-devel/2015-11/msg00209.html

Patch 1 fixes __request_region() to handle inheritance of attribute
properly, which I noticed while testing this patch-set.

Patch 2 adds iomem_set_desc(), which allows drivers (ex. ACPI) to set
I/O descriptor to a corresponding iomem entry. 

Patch 3 changes the ACPI nfit driver to call iomem_set_desc() for
persistent memory ranges described in ACPI NFIT table.

---
This patch-set applies on top of the io resource patch-set below, and
is based on the tip tree.
https://lkml.org/lkml/2016/1/26/886

---
Toshi Kani (3):
 1/3 resource: Make __request_region to inherit from immediate parent
 2/3 resource: Add iomem_set_desc() to set I/O descriptor
 3/3 ACPI: change NFIT driver to set pmem type to iomem entry

---
 drivers/acpi/nfit.c    |  6 ++++++
 include/linux/ioport.h |  2 ++
 kernel/resource.c      | 48 +++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 53 insertions(+), 3 deletions(-)
