Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BEBB321962301
 for <linux-nvdimm@lists.01.org>; Thu,  4 Apr 2019 12:21:08 -0700 (PDT)
Subject: [RFC PATCH 0/5] EFI Special Purpose Memory Support
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 04 Apr 2019 12:08:28 -0700
Message-ID: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Darren Hart <dvhart@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Shevchenko <andy@infradead.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

The EFI 2.8 Specification [1] introduces the EFI_MEMORY_SP ("special
purpose") memory attribute. This attribute bit replaces the deprecated
"reservation hint" that was introduced in ACPI 6.2 and removed in ACPI
6.3.

Given the increasing diversity of memory types that might be advertised
to the operating system, there is a need for platform firmware to hint
which memory ranges are free for the OS to use as general purpose memory
and which ranges are intended for application specific usage. For
example, an application with prior knowledge of the platform may expect
to be able to exclusively allocate a precious / limited pool of high
bandwidth memory. Alternatively, for the general purpose case, the
operating system may want to make the memory available on a best effort
basis as a unique numa-node with performance properties by the new
CONFIG_HMEM_REPORTING [2] facility.

In support of allowing for both exclusive and core-kernel-mm managed
access to differentiated memory, claim EFI_MEMORY_SP ranges for exposure
as device-dax instances by default. Those instances can be directly
owned / mapped by a platform-topology-aware application. However, with
the new kmem facility [3], the administrator has the option to instead
designate that those memory ranges be hot-added to the core-kernel-mm as
a unique memory numa-node. In short, allow for the decision about what
software agent manages special purpose memory to be made at runtime.

The patches are based on v8 of Keith's "HMEM" series currently in Greg's
driver-core-testing branch [4], and have not been tested. This is an RFC
proposal on how to handle the new EFI memory attribute.

[1]: https://uefi.org/sites/default/files/resources/UEFI_Spec_2_8_final.pdf
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/commit/?h=driver-core-testing&id=b6efba75c449
[3]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c221c0b0308f
[4]: https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/log/?h=driver-core-testing

---

Dan Williams (5):
      efi: Detect UEFI 2.8 Special Purpose Memory
      lib/memregion: Uplevel the pmem "region" ida to a global allocator
      acpi/hmat: Track target address ranges
      acpi/hmat: Register special purpose memory as a device
      device-dax: Add a driver for "hmem" devices


 arch/x86/Kconfig                  |   18 +++++
 arch/x86/boot/compressed/eboot.c  |    5 +
 arch/x86/boot/compressed/kaslr.c  |    2 -
 arch/x86/include/asm/e820/types.h |    9 ++
 arch/x86/kernel/e820.c            |    9 ++
 arch/x86/platform/efi/efi.c       |   10 ++-
 drivers/acpi/hmat/Kconfig         |    1 
 drivers/acpi/hmat/hmat.c          |  140 +++++++++++++++++++++++++++++++------
 drivers/dax/Kconfig               |   26 ++++++-
 drivers/dax/Makefile              |    2 +
 drivers/dax/hmem.c                |   58 +++++++++++++++
 drivers/nvdimm/Kconfig            |    1 
 drivers/nvdimm/core.c             |    1 
 drivers/nvdimm/nd-core.h          |    1 
 drivers/nvdimm/region_devs.c      |   13 +--
 include/linux/efi.h               |   14 ++++
 include/linux/ioport.h            |    1 
 include/linux/memregion.h         |    9 ++
 lib/Kconfig                       |    6 ++
 lib/Makefile                      |    1 
 lib/memregion.c                   |   22 ++++++
 21 files changed, 304 insertions(+), 45 deletions(-)
 create mode 100644 drivers/dax/hmem.c
 create mode 100644 include/linux/memregion.h
 create mode 100644 lib/memregion.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
