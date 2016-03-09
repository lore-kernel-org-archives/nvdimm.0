Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 46FD21A1F4D
 for <linux-nvdimm@lists.01.org>; Wed,  9 Mar 2016 10:54:40 -0800 (PST)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 0/4] Support persistent memory as reserved type in e820/EFI
Date: Wed,  9 Mar 2016 12:46:57 -0700
Message-Id: <1457552817-13938-1-git-send-email-toshi.kani@hpe.com>
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
To: mingo@kernel.org, bp@suse.de, dan.j.williams@intel.com, rjw@rjwysocki.net, akpm@linux-foundation.org
Cc: linux-acpi@vger.kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6 defines persistent memory (PMEM) ranges in multiple
firmware interfaces, e820, EFI, and ACPI NFIT table.  This EFI
change, however, leads to hit a bug in the grub bootloader, which
treats EFI_PERSISTENT_MEMORY type as regular memory and corrupts
stored user data [1].

Therefore, BIOS may set generic reserved type in e820 and EFI
to cover PMEM ranges.  The kernel can initialize PMEM ranges
from ACPI NFIT table alone.

This scheme cause a problem in the iomem table, though.  On x86,
for instance, e820_reserve_resources() initializes top-level entries
(iomem_resource.child) from the e820 table at early boot-time.
This creates "reserved" entry for a PMEM range, which does not allow
region_intersects() to check with PMEM type.

This patch-set adds remove_resource(), exports insert/remove_resource(),
and changes the NFIT driver to insert a PMEM entry to the iomem table.

[1] https://lists.gnu.org/archive/html/grub-devel/2015-11/msg00209.html

- Patch 1 fixes __request_region() to handle inheritance of attribute
  properly.  This patch is independent from this series.
- Patch 2 adds remove_resource() interface.
- Patch 3 exports insert_resource() and remove_resource().
- Patch 4 changes the ACPI nfit driver to call insert_resource() to
  insert a PMEM range from NFIT.

---
v3:
 - Drop devm_insert/remove_resource(), and export insert/remove_resource().
   (Linus Torvalds)

v2:
 - Change the NFIT driver to call insert_resource() to insert a PMEM entry
   when necessary. (Dan Williams)
 - The NFIT driver still needs to allow unloading. (Dan Williams)

---
This patch-set is based on the tip tree, which has the following patchset.
https://lkml.org/lkml/2016/1/26/886

---
Toshi Kani (4):
 1/4 resource: Change __request_region to inherit from immediate parent
 2/4 resource: Add remove_resource interface
 3/4 resource: Export insert_resource and remove_resource
 4/4 ACPI: Change NFIT driver to insert new resource

---
 drivers/acpi/nfit.c    | 48 ++++++++++++++++++++++++++++++++++++++++
 include/linux/ioport.h |  1 +
 kernel/resource.c      | 60 +++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 101 insertions(+), 8 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
