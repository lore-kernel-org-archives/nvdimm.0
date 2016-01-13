Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm for 4.5
Date: Wed, 13 Jan 2016 21:05:07 +0000
Message-ID: <1452719108.15527.23.camel@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <B51361E31A2749419C57CAFAA3784F1A@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from...

+AKA- git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-4.5

...to receive the libnvdimm update for 4.5.

The bulk of this has appeared in -next and independently received a
+AKA-build success notification from the kbuild robot. +AKA-The 'for-4.5/block-
dax' topic branch was rebased over the weekend to drop the +ACI-block
device end-of-life+ACI- rework that Al would like to see re-implemented
with a notifier, and to address bug reports against the badblocks
integration.

There is pending feedback against +ACI-libnvdimm: Add a poison list and
export badblocks+ACI- received last week. +AKA-Linda identified some localized
fixups that we will handle incrementally.

This update has a minor conflict with the dax updates pending in -mm,
but only for both sides wanting to add a new header-file-include to
drivers/nvdimm/pmem.c.

---

The following changes since commit 9f9499ae8e6415cefc4fe0a96ad0e27864353c89:

+AKA- Linux 4.4-rc5 (2015-12-13 17:42:58 -0800)

are available in the git repository at:

+AKA- git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-4.5

for you to fetch changes up to 8b63b6bfc1a551acf154061699028c7032d7890c:

+AKA- Merge branch 'for-4.5/block-dax' into for-4.5/libnvdimm (2016-01-10 07:53:55 -0800)

----------------------------------------------------------------
libnvdimm for 4.5

1/ Media error handling: The 'badblocks' implementation that originated
+AKAAoACg-in md-raid is up-levelled to a generic capability of a block device.
+AKAAoACg-This initial implementation is limited to being consulted in the pmem
+AKAAoACg-block-i/o path.+AKAAoA-Later, 'badblocks' will be consulted when creating
+AKAAoACg-dax mappings.

2/ Raw block device dax: For virtualization and other cases that want
+AKAAoACg-large contiguous mappings of persistent memory, add the capability to
+AKAAoACg-dax-mmap a block device directly.

3/ Increased /dev/mem restrictions: Add an option to treat all io-memory
+AKAAoACg-as IORESOURCE+AF8-EXCLUSIVE, i.e. disable /dev/mem access while a driver is
+AKAAoACg-actively using an address range.+AKAAoA-This behavior is controlled via the
+AKAAoACg-new CONFIG+AF8-IO+AF8-STRICT+AF8-DEVMEM option and can be overridden by the
+AKAAoACg-existing +ACI-iomem+AD0-relaxed+ACI- kernel command line option.

4/ Miscellaneous fixes include a 'pfn'-device huge page alignment fix,
+AKAAoACg-block device shutdown crash fix, and other small libnvdimm fixes.

----------------------------------------------------------------
Dan Williams (27):
+AKAAoACgAKAAoACg-libnvdimm, pfn: kill ND+AF8-PFN+AF8-ALIGN
+AKAAoACgAKAAoACg-libnvdimm, pfn: clean up pfn create parameters
+AKAAoACgAKAAoACg-libnvdimm, pfn: add 'align' attribute, default to HPAGE+AF8-SIZE
+AKAAoACgAKAAoACg-libnvdimm, pfn: add parent uuid validation
+AKAAoACgAKAAoACg-libnvdimm, pfn: fix pfn seed creation
+AKAAoACgAKAAoACg-libnvdimm, pfn: enable pfn sysfs interface unit testing
+AKAAoACgAKAAoACg-libnvdimm, pfn: fix nd+AF8-pfn+AF8-validate() return value handling
+AKAAoACgAKAAoACg-tools/testing/libnvdimm: cleanup mock resource lookup
+AKAAoACgAKAAoACg-libnvdimm, pfn: move 'memory mode' indication to sysfs
+AKAAoACgAKAAoACg-libnvdimm: fix namespace object confusion in is+AF8-uuid+AF8-busy()
+AKAAoACgAKAAoACg-arch: consolidate CONFIG+AF8-STRICT+AF8-DEVM in lib/Kconfig.debug
+AKAAoACgAKAAoACg-restrict /dev/mem to idle io memory ranges
+AKAAoACgAKAAoACg-block: introduce bdev+AF8-file+AF8-inode()
+AKAAoACgAKAAoACg-block: enable dax for raw block devices
+AKAAoACgAKAAoACg-block: fix del+AF8-gendisk() vs blkdev+AF8-ioctl crash
+AKAAoACgAKAAoACg-nfit+AF8-test: Enable DSMs for all test NFITs
+AKAAoACgAKAAoACg-libnvdimm, pmem: move definition of nvdimm+AF8-namespace+AF8-add+AF8-poison to nd.h
+AKAAoACgAKAAoACg-badblocks: rename badblocks+AF8-free to badblocks+AF8-exit
+AKAAoACgAKAAoACg-block: clarify badblocks lifetime
+AKAAoACgAKAAoACg-block, badblocks: introduce devm+AF8-init+AF8-badblocks
+AKAAoACgAKAAoACg-libnvdimm: don't fail init for full badblocks list
+AKAAoACgAKAAoACg-libnvdimm: convert to statically allocated badblocks
+AKAAoACgAKAAoACg-pmem: fail io-requests to known bad blocks
+AKAAoACgAKAAoACg-pmem, dax: disable dax in the presence of bad blocks
+AKAAoACgAKAAoACg-libnvdimm, pmem: nvdimm+AF8-read+AF8-bytes() badblocks support
+AKAAoACgAKAAoACg-block: kill disk+AF8Aew-check+AHw-set+AHw-clear+AHw-alloc+AH0AXw-badblocks
+AKAAoACgAKAAoACg-Merge branch 'for-4.5/block-dax' into for-4.5/libnvdimm

Dmitry Krivenok (2):
+AKAAoACgAKAAoACg-nvdimm: improve diagnosibility of namespaces
+AKAAoACgAKAAoACg-nvdimm: do not show pfn+AF8-seed for non pmem regions

Vishal Verma (4):
+AKAAoACgAKAAoACg-badblocks: Add core badblock management code
+AKAAoACgAKAAoACg-block: Add badblock management for gendisks
+AKAAoACgAKAAoACg-md: convert to use the generic badblocks code
+AKAAoACgAKAAoACg-libnvdimm: Add a poison list and export badblocks

+AKA-arch/arm/Kconfig+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAHwAoACgAKA-1 +-
+AKA-arch/arm/Kconfig.debug+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAHwAoACg-14 -
+AKA-arch/arm64/Kconfig+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAfACgAKAAoA-1 +-
+AKA-arch/arm64/Kconfig.debug+AKAAoACgAKAAoACgAKAAoACgAKAAfACgAKA-14 -
+AKA-arch/frv/Kconfig+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAHwAoACgAKA-1 +-
+AKA-arch/m32r/Kconfig+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoAB8AKAAoACg-1 +-
+AKA-arch/powerpc/Kconfig+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoAB8AKAAoACg-1 +-
+AKA-arch/powerpc/Kconfig.debug+AKAAoACgAKAAoACgAKAAoAB8AKAAoA-12 -
+AKA-arch/s390/Kconfig+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoAB8AKAAoACg-1 +-
+AKA-arch/s390/Kconfig.debug+AKAAoACgAKAAoACgAKAAoACgAKAAoAB8AKAAoA-12 -
+AKA-arch/tile/Kconfig+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoAB8AKAAoACg-4 +--
+AKA-arch/unicore32/Kconfig+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAHwAoACgAKA-1 +-
+AKA-arch/unicore32/Kconfig.debug+AKAAoACgAKAAoACgAHwAoACg-14 -
+AKA-arch/x86/Kconfig+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAHwAoACgAKA-1 +-
+AKA-arch/x86/Kconfig.debug+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAHwAoACg-17 --
+AKA-block/Makefile+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoAB8AKAAoACg-2 +--
+AKA-block/badblocks.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoAB8- 585 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
+AKA-block/genhd.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAHwAoACg-30 +--
+AKA-block/ioctl.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAHwAoACg-71 +-+-+-+-+-
+AKA-drivers/acpi/nfit.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAHw- 203 +-+-+-+-+-+-+-+-+-+-+-+-+-
+AKA-drivers/md/md.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAfA- 516 +-+--------------------------------
+AKA-drivers/md/md.h+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAfACgAKA-40 +---
+AKA-drivers/nvdimm/core.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAfA- 169 +-+-+-+-+-+-+-+-+-+-+-
+AKA-drivers/nvdimm/namespace+AF8-devs.c+AKAAoACgAHw- 132 +-+-+-+-+-+-+---
+AKA-drivers/nvdimm/nd-core.h+AKAAoACgAKAAoACgAKAAoACgAKAAfACgAKAAoA-2 +-
+AKA-drivers/nvdimm/nd.h+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAHwAoACg-16 +--
+AKA-drivers/nvdimm/pfn+AF8-devs.c+AKAAoACgAKAAoACgAKAAoACgAHwAoACg-93 +-+-+-+---
+AKA-drivers/nvdimm/pmem.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAfACgAKA-90 +-+-+-+---
+AKA-drivers/nvdimm/region+AF8-devs.c+AKAAoACgAKAAoACgAHwAoACg-66 +-----
+AKA-fs/block+AF8-dev.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoAB8- 122 +-+-+-+-+-+-+--
+AKA-include/linux/badblocks.h+AKAAoACgAKAAoACgAKAAoACgAHwAoACg-65 +-+-+-+-+-
+AKA-include/linux/fs.h+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAfACgAKA-11 +-
+AKA-include/linux/genhd.h+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAfACgAKAAoA-2 +-
+AKA-include/linux/libnvdimm.h+AKAAoACgAKAAoACgAKAAoACgAHwAoACgAKA-1 +-
+AKA-include/uapi/linux/fs.h+AKAAoACgAKAAoACgAKAAoACgAKAAoAB8AKAAoACg-2 +-
+AKA-kernel/resource.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoAB8AKAAoA-11 +--
+AKA-lib/Kconfig.debug+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoAB8AKAAoA-39 +-+-+-
+AKA-tools/testing/nvdimm/Kbuild+AKAAoACgAKAAoACgAKAAfACgAKAAoA-2 +-
+AKA-tools/testing/nvdimm/test/iomap.c +AHwAoACg-93 +-+-+----
+AKA-tools/testing/nvdimm/test/nfit.c+AKAAoAB8AKAAoA-11 +-
+AKA-40 files changed, 1673 insertions(+-), 796 deletions(-)
+AKA-create mode 100644 block/badblocks.c
+AKA-create mode 100644 include/linux/badblocks.h
