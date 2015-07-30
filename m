Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 00/24] replace ioremap_{cache|wt} with memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Jul 2015 12:53:39 -0400
Message-ID: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, Lv Zheng <lv.zheng@intel.com>, Daniel Vetter <daniel.vetter@intel.com>, Benjamin Romer <benjamin.romer@unisys.com>, hch@lst.de, linux-arch@vger.kernel.org, linux-nvdimm@lists.01.org, Joerg Roedel <joro@8bytes.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Bob Moore <robert.moore@intel.com>, Mike Waychison <mikew@google.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, rmk+kernel@arm.linux.org.uk, Ross Zwisler <ross.zwisler@linux.intel.com>, David Kershner <david.kershner@unisys.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, intel-gfx@lists.freedesktop.org, Len Brown <lenb@kernel.org>, Joerg Roedel <jroedel@suse.de>, Arnd Bergmann <arnd@arndb.de>, mcgrof@suse.com, Jani Nikula <jani.nikula@linux.intel.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, linux-arm-kernel@lists.infradead.org, Tony Luck <tony.luck@intel.com>, toshi.kani@hp.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Buzzard <jonathan@buzzard.org.uk>, linux-kernel@vger.kernel.org, Brian Norris <computersforpeace@gmail.com>, David Woodhouse <dwmw2@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v2 [1]:

1/ Move arch_memremap() and arch_memunmap() out of line (Christoph)

2/ Convert region_is_ram() to region_intersects() and define an enum for
   its 3 return values. (Luis)

3/ Fix gma500 and i915 to explicitly use cached mappings and clean up
   the __iomem usage. (Daniel)

4/ Kill unused ioremap aliases (ioremap_cached() and
   ioremap_fullcache()) (Christoph)

5/ Clarify some change logs and documentation (Luis, Christoph, and
   Ross)

6/ Add a unified CONFIG_MMU=n implementation with __weak symbols. (Luis)

---
While developing the pmem driver we noticed that the __iomem annotation
on the return value from ioremap_cache() was being mishandled by several
callers.  We also observed that all of the call sites expected to be
able to treat the return value from ioremap_cache() as normal
(non-__iomem) pointer to memory.

This patchset takes the opportunity to clean up the above confusion as
well as a few issues with the ioremap_{cache|wt} interface, including:

1/ Eliminating the possibility of function prototypes differing between
   architectures by defining a central memremap() prototype that takes
   flags to determine the mapping type.

2/ Returning NULL rather than falling back silently to a different
   mapping-type.  This allows drivers to be stricter about the
   mapping-type fallbacks that are permissible.

[1]: http://marc.info/?l=linux-arch&m=143779222217405&w=2

---

Dan Williams (24):
      mm: enhance region_is_ram() to region_intersects()
      arch, drivers: don't include <asm/io.h> directly, use <linux/io.h> instead
      cleanup IORESOURCE_CACHEABLE vs ioremap()
      intel_iommu: fix leaked ioremap mapping
      arch: introduce memremap()
      arm: switch from ioremap_cache to memremap
      x86: switch from ioremap_cache to memremap
      gma500: switch from acpi_os_ioremap to memremap
      i915: switch from acpi_os_ioremap to memremap
      acpi: switch from ioremap_cache to memremap
      toshiba laptop: replace ioremap_cache with ioremap
      memconsole: fix __iomem mishandling, switch to memremap
      visorbus: switch from ioremap_cache to memremap
      intel-iommu: switch from ioremap_cache to memremap
      libnvdimm, pmem: push call to ioremap_cache out of line
      pxa2xx-flash: switch from ioremap_cache to memremap
      sfi: switch from ioremap_cache to memremap
      fbdev: switch from ioremap_wt to memremap
      pmem: switch from ioremap_wt to memremap
      arch: kill ioremap_cached()
      arch: kill ioremap_fullcache()
      arch: remove ioremap_cache, replace with arch_memremap
      arch: remove ioremap_wt, optionally replace with arch_memremap
      pmem: convert to generic memremap


 Documentation/x86/pat.txt                      |    6 +
 arch/arc/include/asm/io.h                      |    1 
 arch/arm/Kconfig                               |    1 
 arch/arm/include/asm/io.h                      |    7 --
 arch/arm/include/asm/xen/page.h                |    4 -
 arch/arm/mach-clps711x/board-cdb89712.c        |    2 
 arch/arm/mach-shmobile/pm-rcar.c               |    2 
 arch/arm/mm/ioremap.c                          |   18 +++-
 arch/arm/mm/mmu.c                              |    2 
 arch/arm/mm/nommu.c                            |   11 ++
 arch/arm64/Kconfig                             |    1 
 arch/arm64/include/asm/acpi.h                  |   11 --
 arch/arm64/include/asm/dmi.h                   |    8 +-
 arch/arm64/include/asm/io.h                    |    2 
 arch/arm64/kernel/efi.c                        |    9 +-
 arch/arm64/kernel/smp_spin_table.c             |   19 ++--
 arch/arm64/mm/ioremap.c                        |   20 ++--
 arch/avr32/include/asm/io.h                    |    1 
 arch/frv/include/asm/io.h                      |   12 ---
 arch/ia64/Kconfig                              |    1 
 arch/ia64/include/asm/io.h                     |    5 -
 arch/ia64/kernel/cyclone.c                     |    2 
 arch/ia64/mm/ioremap.c                         |   16 +++
 arch/m32r/include/asm/io.h                     |    1 
 arch/m68k/Kconfig                              |    1 
 arch/m68k/include/asm/io_mm.h                  |   12 ---
 arch/m68k/include/asm/io_no.h                  |   11 --
 arch/m68k/include/asm/raw_io.h                 |    1 
 arch/m68k/mm/kmap.c                            |   17 +++-
 arch/m68k/mm/sun3kmap.c                        |    6 +
 arch/metag/include/asm/io.h                    |    6 -
 arch/microblaze/include/asm/io.h               |    2 
 arch/mn10300/include/asm/io.h                  |    1 
 arch/nios2/include/asm/io.h                    |    1 
 arch/powerpc/kernel/pci_of_scan.c              |    2 
 arch/s390/include/asm/io.h                     |    1 
 arch/sh/Kconfig                                |    1 
 arch/sh/include/asm/io.h                       |    6 -
 arch/sh/mm/ioremap.c                           |   15 +++
 arch/sparc/include/asm/io_32.h                 |    1 
 arch/sparc/include/asm/io_64.h                 |    1 
 arch/sparc/kernel/pci.c                        |    3 -
 arch/tile/include/asm/io.h                     |    2 
 arch/unicore32/include/asm/io.h                |    4 -
 arch/unicore32/mm/ioremap.c                    |    8 --
 arch/x86/Kconfig                               |    1 
 arch/x86/include/asm/efi.h                     |    3 -
 arch/x86/include/asm/io.h                      |   11 --
 arch/x86/kernel/crash_dump_64.c                |    6 +
 arch/x86/kernel/kdebugfs.c                     |    8 +-
 arch/x86/kernel/ksysfs.c                       |   28 +++---
 arch/x86/mm/ioremap.c                          |   59 +++++++------
 arch/xtensa/include/asm/io.h                   |   11 --
 drivers/acpi/apei/einj.c                       |    9 +-
 drivers/acpi/apei/erst.c                       |    6 +
 drivers/acpi/nvs.c                             |    6 +
 drivers/acpi/osl.c                             |   70 ++++-----------
 drivers/char/toshiba.c                         |    2 
 drivers/firmware/google/memconsole.c           |    7 +-
 drivers/gpu/drm/gma500/opregion.c              |    8 +-
 drivers/gpu/drm/gma500/psb_drv.h               |    2 
 drivers/gpu/drm/gma500/psb_lid.c               |    8 +-
 drivers/gpu/drm/i915/i915_debugfs.c            |    2 
 drivers/gpu/drm/i915/i915_drv.h                |   12 +--
 drivers/gpu/drm/i915/intel_bios.c              |    7 +-
 drivers/gpu/drm/i915/intel_opregion.c          |   87 +++++++++----------
 drivers/gpu/drm/i915/intel_panel.c             |    2 
 drivers/iommu/intel-iommu.c                    |   10 +-
 drivers/iommu/intel_irq_remapping.c            |    4 +
 drivers/isdn/icn/icn.h                         |    2 
 drivers/mtd/devices/slram.c                    |    2 
 drivers/mtd/maps/pxa2xx-flash.c                |    4 -
 drivers/mtd/nand/diskonchip.c                  |    2 
 drivers/mtd/onenand/generic.c                  |    2 
 drivers/nvdimm/Kconfig                         |    2 
 drivers/pci/probe.c                            |    3 -
 drivers/pnp/manager.c                          |    2 
 drivers/scsi/aic94xx/aic94xx_init.c            |    7 --
 drivers/scsi/arcmsr/arcmsr_hba.c               |    5 -
 drivers/scsi/mvsas/mv_init.c                   |   15 +--
 drivers/scsi/sun3x_esp.c                       |    2 
 drivers/sfi/sfi_core.c                         |    4 -
 drivers/staging/comedi/drivers/ii_pci20kc.c    |    1 
 drivers/staging/unisys/visorbus/visorchannel.c |   16 ++-
 drivers/staging/unisys/visorbus/visorchipset.c |   17 ++--
 drivers/tty/serial/8250/8250_core.c            |    2 
 drivers/video/fbdev/Kconfig                    |    2 
 drivers/video/fbdev/amifb.c                    |    5 +
 drivers/video/fbdev/atafb.c                    |    5 +
 drivers/video/fbdev/hpfb.c                     |    6 +
 drivers/video/fbdev/ocfb.c                     |    1 
 drivers/video/fbdev/s1d13xxxfb.c               |    3 -
 drivers/video/fbdev/stifb.c                    |    1 
 include/acpi/acpi_io.h                         |    6 -
 include/asm-generic/io.h                       |    8 --
 include/asm-generic/iomap.h                    |    4 -
 include/linux/io-mapping.h                     |    2 
 include/linux/io.h                             |   11 ++
 include/linux/mm.h                             |    9 ++
 include/linux/mtd/map.h                        |    2 
 include/linux/pmem.h                           |   26 +++---
 include/video/vga.h                            |    2 
 kernel/Makefile                                |    2 
 kernel/memremap.c                              |  110 ++++++++++++++++++++++++
 kernel/resource.c                              |   61 ++++++++-----
 lib/Kconfig                                    |    5 +
 lib/devres.c                                   |   13 +--
 lib/pci_iomap.c                                |    7 --
 tools/testing/nvdimm/Kbuild                    |    4 -
 tools/testing/nvdimm/test/iomap.c              |   34 +++++--
 110 files changed, 553 insertions(+), 497 deletions(-)
 create mode 100644 kernel/memremap.c
