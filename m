Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 00/10] memremap for 4.3
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Aug 2015 23:37:50 -0400
Message-ID: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Toshi Kani <toshi.kani@hp.com>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, mcgrof@suse.com, hch@lst.de, Benjamin Romer <benjamin.romer@unisys.com>, David Kershner <david.kershner@unisys.com>, ross.zwisler@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

Changes since v3: [1]

1/ Include devm_memremap() support (Christoph)

2/ Rebase the series to defer the removal of ioremap_cache() and drop
   any of the ioremap_cache()-to-memremap() conversions that have yet to be
   acked by the appropriate maintainer. This avoids any potential for
   bisection breakage during the 4.3 merge and the cleanup can be done for
   4.4. (Christoph)

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-July/001649.html
---

While developing the pmem driver we noticed that the __iomem annotation
on the return value from ioremap_cache() was being mishandled by several
callers.  We also observed that all of the call sites expected to be
able to treat the return value from ioremap_cache() as normal
(non-__iomem) pointer to memory.

See also, the LWN write up: https://lwn.net/Articles/653585/

This has passed a 0day run and will appear in libnvdimm-for-next
shortly.

---

Christoph Hellwig (2):
      devres: add devm_memremap
      pmem: switch to devm_ allocations

Dan Williams (8):
      mm: enhance region_is_ram() to region_intersects()
      arch, drivers: don't include <asm/io.h> directly, use <linux/io.h> instead
      cleanup IORESOURCE_CACHEABLE vs ioremap()
      arch: introduce memremap()
      visorbus: switch from ioremap_cache to memremap
      libnvdimm, pmem: push call to ioremap_cache out of line
      pmem: switch from ioremap_wt to memremap
      pmem: convert to generic memremap


 arch/arm/mach-clps711x/board-cdb89712.c        |    2 
 arch/arm/mach-shmobile/pm-rcar.c               |    2 
 arch/ia64/include/asm/io.h                     |    1 
 arch/ia64/kernel/cyclone.c                     |    2 
 arch/powerpc/kernel/pci_of_scan.c              |    2 
 arch/sh/include/asm/io.h                       |    1 
 arch/sparc/kernel/pci.c                        |    3 -
 arch/x86/include/asm/io.h                      |    7 -
 arch/x86/mm/ioremap.c                          |   10 ++
 arch/xtensa/include/asm/io.h                   |    1 
 drivers/isdn/icn/icn.h                         |    2 
 drivers/mtd/devices/slram.c                    |    2 
 drivers/mtd/nand/diskonchip.c                  |    2 
 drivers/mtd/onenand/generic.c                  |    2 
 drivers/nvdimm/pmem.c                          |   36 ++----
 drivers/pci/probe.c                            |    3 -
 drivers/pnp/manager.c                          |    2 
 drivers/scsi/aic94xx/aic94xx_init.c            |    7 -
 drivers/scsi/arcmsr/arcmsr_hba.c               |    5 -
 drivers/scsi/mvsas/mv_init.c                   |   15 +--
 drivers/scsi/sun3x_esp.c                       |    2 
 drivers/staging/comedi/drivers/ii_pci20kc.c    |    1 
 drivers/staging/unisys/visorbus/visorchannel.c |   16 ++-
 drivers/staging/unisys/visorbus/visorchipset.c |   17 ++-
 drivers/tty/serial/8250/8250_core.c            |    2 
 drivers/video/fbdev/ocfb.c                     |    1 
 drivers/video/fbdev/s1d13xxxfb.c               |    3 -
 drivers/video/fbdev/stifb.c                    |    1 
 include/linux/io-mapping.h                     |    2 
 include/linux/io.h                             |   13 ++
 include/linux/mm.h                             |    9 +-
 include/linux/mtd/map.h                        |    2 
 include/linux/pmem.h                           |   30 +++--
 include/video/vga.h                            |    2 
 kernel/Makefile                                |    2 
 kernel/memremap.c                              |  138 ++++++++++++++++++++++++
 kernel/resource.c                              |   61 ++++++-----
 lib/devres.c                                   |   13 +-
 lib/pci_iomap.c                                |    7 -
 tools/testing/nvdimm/Kbuild                    |    4 -
 tools/testing/nvdimm/test/iomap.c              |   46 ++++++--
 41 files changed, 323 insertions(+), 156 deletions(-)
 create mode 100644 kernel/memremap.c
