Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm, nfit: fixes for 4.5-rc6
Date: Thu, 25 Feb 2016 05:47:31 +0000
Message-ID: <1456379247.29791.20.camel@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <AAFD07A2ED9D9A42B24E672C8AB16578@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

+AKA- git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

...to receive:

1/ Two fixes for compatibility with the ACPI 6.1 specification.
+AKA-Without these fixes multi-interface DIMMs will fail to be probed, and
address range scrub commands to find memory errors will give results
that the kernel will mis-interpret. +AKA-For multi-interface DIMMs Linux
will accept either the original 6.0 implementation or 6.1. +AKA-For address
range scrub we'll only support 6.1 since ACPI formalized this DSM
differently than the original example +AFs-1+AF0- implemented in v4.2. +AKA-The
expectation is that production systems will only ever ship the ACPI 6.1
address range scrub command definition.+AKA-

2/ The wider async address range scrub work targeting 4.6 discovered
that the original synchronous implementation in 4.5 is not sizing its
return buffer correctly.

3/ Arnd caught that my recent fix to the size of the pfn+AF8-t flags missed
updating the flags variable used in the pmem driver.

4/ Toshi found that we mishandle the memremap() return value in
devm+AF8-memremap().

This branch has received a clean build success notification from the
kbuild robot across 105 configs.

+AFs-1+AF0-:+AKA-http://pmem.io/documents/NVDIMM+AF8-DSM+AF8-Interface+AF8-Example.pdf


The following changes since commit 18558cae0272f8fd9647e69d3fec1565a7949865:

+AKA- Linux 4.5-rc4 (2016-02-14 13:05:20 -0800)

are available in the git repository at:

+AKA- git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

for you to fetch changes up to c45442055dfdeb265cc20c9eeaa9fd11a75fbf51:

+AKA- nvdimm: use 'u64' for pfn flags (2016-02-23 17:17:20 -0800)

----------------------------------------------------------------
Arnd Bergmann (1):
+AKAAoACgAKAAoACg-nvdimm: use 'u64' for pfn flags

Dan Williams (3):
+AKAAoACgAKAAoACg-nfit: fix multi-interface dimm handling, acpi6.1 compatibility
+AKAAoACgAKAAoACg-libnvdimm, tools/testing/nvdimm: fix 'ars+AF8-status' output buffer sizing
+AKAAoACgAKAAoACg-nfit: update address range scrub commands to the acpi 6.1 format

Toshi Kani (1):
+AKAAoACgAKAAoACg-devm+AF8-memremap: Fix error value when memremap failed

+AKA-drivers/acpi/nfit.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoAB8- 90 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+---------------------
+AKA-drivers/nvdimm/bus.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAfA- 20 +-+-+-+------
+AKA-drivers/nvdimm/pmem.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAHwAoACg-2 +--
+AKA-include/linux/libnvdimm.h+AKAAoACgAKAAoACgAKAAoAB8AKAAoA-3 +--
+AKA-include/uapi/linux/ndctl.h+AKAAoACgAKAAoACgAKAAfA- 11 +-+-+-+--
+AKA-kernel/memremap.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAfACgAKA-4 +--
+AKA-tools/testing/nvdimm/test/nfit.c +AHwAoACg-8 +-+-+--
+AKA-7 files changed, 75 insertions(+-), 63 deletions(-)

commit c45442055dfdeb265cc20c9eeaa9fd11a75fbf51
Author: Arnd Bergmann +ADw-arnd+AEA-arndb.de+AD4-
Date:+AKAAoACg-Mon Feb 22 22:58:34 2016 +-0100

+AKAAoACgAKA-nvdimm: use 'u64' for pfn flags
+AKAAoACgAKA-
+AKAAoACgAKA-A recent bugfix changed pfn+AF8-t to always be 64-bit wide, but did not
+AKAAoACgAKA-change the code in pmem.c, which is now broken on 32-bit architectures
+AKAAoACgAKA-as reported by gcc:
+AKAAoACgAKA-
+AKAAoACgAKA-In file included from ../drivers/nvdimm/pmem.c:28:0:
+AKAAoACgAKA-drivers/nvdimm/pmem.c: In function 'pmem+AF8-alloc':
+AKAAoACgAKA-include/linux/pfn+AF8-t.h:15:17: error: large integer implicitly truncated to unsigned type +AFs--Werror+AD0-overflow+AF0-
+AKAAoACgAKAAoAAj-define PFN+AF8-DEV (1ULL +ADwAPA- (BITS+AF8-PER+AF8-LONG+AF8-LONG - 3))
+AKAAoACgAKA-
+AKAAoACgAKA-This changes the intermediate pfn+AF8-flags in struct pmem+AF8-device to
+AKAAoACgAKA-be 64 bit wide as well, so they can store the flags correctly.
+AKAAoACgAKA-
+AKAAoACgAKA-Signed-off-by: Arnd Bergmann +ADw-arnd+AEA-arndb.de+AD4-
+AKAAoACgAKA-Fixes: db78c22230d0 (+ACI-mm: fix pfn+AF8-t vs highmem+ACI-)
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit 93f834df9c2d4e362dfdc4b05daa0a4e18814836
Author: Toshi Kani +ADw-toshi.kani+AEA-hpe.com+AD4-
Date:+AKAAoACg-Sat Feb 20 14:32:24 2016 -0800

+AKAAoACgAKA-devm+AF8-memremap: Fix error value when memremap failed
+AKAAoACgAKA-
+AKAAoACgAKA-devm+AF8-memremap() returns an ERR+AF8-PTR() value in case of error.
+AKAAoACgAKA-However, it returns NULL when memremap() failed.+AKAAoA-This causes
+AKAAoACgAKA-the caller, such as the pmem driver, to proceed and oops later.
+AKAAoACgAKA-
+AKAAoACgAKA-Change devm+AF8-memremap() to return ERR+AF8-PTR(-ENXIO) when memremap()
+AKAAoACgAKA-failed.
+AKAAoACgAKA-
+AKAAoACgAKA-Signed-off-by: Toshi Kani +ADw-toshi.kani+AEA-hpe.com+AD4-
+AKAAoACgAKA-Cc: Andrew Morton +ADw-akpm+AEA-linux-foundation.org+AD4-
+AKAAoACgAKA-Cc: +ADw-stable+AEA-vger.kernel.org+AD4-
+AKAAoACgAKA-Reviewed-by: Ross Zwisler +ADw-ross.zwisler+AEA-linux.intel.com+AD4-
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit 4577b0665515e0abc7bc72562d6328d179598815
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:+AKAAoACg-Wed Feb 17 13:08:58 2016 -0800

+AKAAoACgAKA-nfit: update address range scrub commands to the acpi 6.1 format
+AKAAoACgAKA-
+AKAAoACgAKA-The original format of these commands from the +ACI-NVDIMM DSM Interface
+AKAAoACgAKA-Example+ACI- +AFs-1+AF0- are superseded by the ACPI 6.1 definition of the +ACI-NVDIMM Root
+AKAAoACgAKA-Device +AF8-DSMs+ACI- +AFs-2+AF0-.
+AKAAoACgAKA-
+AKAAoACgAKAAWw-1+AF0-: http://pmem.io/documents/NVDIMM+AF8-DSM+AF8-Interface+AF8-Example.pdf
+AKAAoACgAKAAWw-2+AF0-: http://www.uefi.org/sites/default/files/resources/ACPI+AF8-6+AF8-1.pdf
+AKAAoACgAKAAoACgAKAAoACgACI-9.20.7 NVDIMM Root Device +AF8-DSMs+ACI-
+AKAAoACgAKA-
+AKAAoACgAKA-Changes include:
+AKAAoACgAKA-1/ New 'restart' fields in ars+AF8-status, unfortunately these are
+AKAAoACgAKAAoACgAKA-implemented in the middle of the existing definition so this change
+AKAAoACgAKAAoACgAKA-is not backwards compatible.+AKAAoA-The expectation is that shipping
+AKAAoACgAKAAoACgAKA-platforms will only ever support the ACPI 6.1 definition.
+AKAAoACgAKA-
+AKAAoACgAKA-2/ New status values for ars+AF8-start ('busy') and ars+AF8-status ('overflow').
+AKAAoACgAKA-
+AKAAoACgAKA-Cc: Vishal Verma +ADw-vishal.l.verma+AEA-intel.com+AD4-
+AKAAoACgAKA-Cc: Linda Knippers +ADw-linda.knippers+AEA-hpe.com+AD4-
+AKAAoACgAKA-Cc: +ADw-stable+AEA-vger.kernel.org+AD4-
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit 747ffe11b440ef9ea752888806d3aac677ca52a4
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:+AKAAoACg-Fri Feb 19 15:21:14 2016 -0800

+AKAAoACgAKA-libnvdimm, tools/testing/nvdimm: fix 'ars+AF8-status' output buffer sizing
+AKAAoACgAKA-
+AKAAoACgAKA-Use the output length specified in the command to size the receive
+AKAAoACgAKA-buffer rather than the arbitrary 4K limit.
+AKAAoACgAKA-
+AKAAoACgAKA-This bug was hiding the fact that the ndctl implementation of
+AKAAoACgAKA-ndctl+AF8-bus+AF8-cmd+AF8-new+AF8-ars+AF8-status() was not specifying an output buffer size.
+AKAAoACgAKA-
+AKAAoACgAKA-Cc: +ADw-stable+AEA-vger.kernel.org+AD4-
+AKAAoACgAKA-Cc: Vishal Verma +ADw-vishal.l.verma+AEA-intel.com+AD4-
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit 6697b2cf69d4363266ca47eaebc49ef13dabc1c9
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:+AKAAoACg-Thu Feb 4 16:51:00 2016 -0800

+AKAAoACgAKA-nfit: fix multi-interface dimm handling, acpi6.1 compatibility
+AKAAoACgAKA-
+AKAAoACgAKA-ACPI 6.1 clarified that multi-interface dimms require multiple control
+AKAAoACgAKA-region entries (DCRs) per dimm.+AKAAoA-Previously we were assuming that a
+AKAAoACgAKA-control region is only present when block-data-windows are present.
+AKAAoACgAKA-This implementation was done with an eye to be compatibility with the
+AKAAoACgAKA-looser ACPI 6.0 interpretation of this table.
+AKAAoACgAKA-
+AKAAoACgAKA-1/ When coalescing the memory device (MEMDEV) tables for a single dimm,
+AKAAoACgAKA-coalesce on device+AF8-handle rather than control region index.
+AKAAoACgAKA-
+AKAAoACgAKA-2/ Whenever we disocver a control region with non-zero block windows
+AKAAoACgAKA-re-scan for block-data-window (BDW) entries.
+AKAAoACgAKA-
+AKAAoACgAKA-We may need to revisit this if a DIMM ever implements a format interface
+AKAAoACgAKA-outside of blk or pmem, but that is not on the foreseeable horizon.
+AKAAoACgAKA-
+AKAAoACgAKA-Cc: +ADw-stable+AEA-vger.kernel.org+AD4-
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
