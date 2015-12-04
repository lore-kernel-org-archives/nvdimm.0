Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm fixes for 4.4-rc4
Date: Fri, 4 Dec 2015 19:18:41 +0000
Message-ID: <1449256717.24881.11.camel@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <B06AD95D3ACCDE44A7F696505E73D8EE@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Zwisler, Ross" <ross.zwisler@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from...

    git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

...to receive:

1/ NFIT parsing regression fixes from Linda. +AKA-The nvdimm hot-add
implementation merged in 4.4-rc1 interpreted the specification in a way
that breaks actual HPE platforms. +AKA-We are also closing the loop with
the ACPI Working Group to get this clarification added to the spec.

2/ Andy pointed out that his laptop without nvdimm resources is loading
the e820-nvdimm module by default, fix that up to only load the module
when an e820-type-12 range is present.

The following changes since commit 31ade3b83e1821da5fbb2f11b5b3d4ab2ec39db8:

+AKA- Linux 4.4-rc3 (2015-11-29 18:58:26 -0800)

are available in the git repository at:

+AKA- git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

for you to fetch changes up to 6b577c9d772c45448aec784ec235cea228b4d3ad:

+AKA- nfit: Adjust for different +AF8-FIT and NFIT headers (2015-11-30 14:51:46 -0800)

----------------------------------------------------------------
Dan Williams (1):
+AKAAoACgAKAAoACg-libnvdimm, e820: skip module loading when no type-12

Linda Knippers (3):
+AKAAoACgAKAAoACg-nfit: Account for table size length variation
+AKAAoACgAKAAoACg-nfit: Fix the check for a successful NFIT merge
+AKAAoACgAKAAoACg-nfit: Adjust for different +AF8-FIT and NFIT headers

+AKA-arch/x86/kernel/pmem.c+AKAAoACgAKAAoACgAKAAoACgAKAAoAB8- 12 +-+-+-+-+-+-+-+-
+AKA-drivers/acpi/nfit.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoAB8- 65 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+------------
+AKA-drivers/acpi/nfit.h+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoAB8AKAAoA-3 +--
+AKA-tools/testing/nvdimm/test/nfit.c +AHw- 49 +-+-+-+-+-+-+-+-+-+---------------------
+AKA-4 files changed, 76 insertions(+-), 53 deletions(-)

commit 6b577c9d772c45448aec784ec235cea228b4d3ad
Author: Linda Knippers +ADw-linda.knippers+AEA-hpe.com+AD4-
Date:+AKAAoACg-Fri Nov 20 19:05:49 2015 -0500

+AKAAoACgAKA-nfit: Adjust for different +AF8-FIT and NFIT headers
+AKAAoACgAKA-
+AKAAoACgAKA-When support for +AF8-FIT was added, the code presumed that the data
+AKAAoACgAKA-returned by the +AF8-FIT method is identical to the NFIT table, which
+AKAAoACgAKA-starts with an acpi+AF8-table+AF8-header.+AKAAoA-However, the +AF8-FIT is defined
+AKAAoACgAKA-to return a data in the format of a series of NFIT type structure
+AKAAoACgAKA-entries and as a method, has an acpi+AF8-object header rather tahn
+AKAAoACgAKA-an acpi+AF8-table+AF8-header.
+AKAAoACgAKA-
+AKAAoACgAKA-To address the differences, explicitly save the acpi+AF8-table+AF8-header
+AKAAoACgAKA-from the NFIT, since it is accessible through /sys, and change
+AKAAoACgAKA-the nfit pointer in the acpi+AF8-desc structure to point to the
+AKAAoACgAKA-table entries rather than the headers.
+AKAAoACgAKA-
+AKAAoACgAKA-Reported-by: Jeff Moyer (jmoyer+AEA-redhat.com+AD4-
+AKAAoACgAKA-Signed-off-by: Linda Knippers +ADw-linda.knippers+AEA-hpe.com+AD4-
+AKAAoACgAKA-Acked-by: Vishal Verma +ADw-vishal.l.verma+AEA-intel.com+AD4-
+AKAAoACgAKAAWw-vishal: fix up unit test for new header assumptions+AF0-
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit ff5a55f89c6690a0b292f1a7e0cd4532961588d5
Author: Linda Knippers +ADw-linda.knippers+AEA-hpe.com+AD4-
Date:+AKAAoACg-Fri Nov 20 19:05:48 2015 -0500

+AKAAoACgAKA-nfit: Fix the check for a successful NFIT merge
+AKAAoACgAKA-
+AKAAoACgAKA-Missed previously due to a lack of test coverage on a platform that
+AKAAoACgAKA-provided an valid response to +AF8-FIT.
+AKAAoACgAKA-
+AKAAoACgAKA-Signed-off-by: Linda Knippers +ADw-linda.knippers+AEA-hpe.com+AD4-
+AKAAoACgAKA-Acked-by: Vishal Verma +ADw-vishal.l.verma+AEA-intel.com+AD4-
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit 826c416f3c9493b69630a811832cfb7c9007f840
Author: Linda Knippers +ADw-linda.knippers+AEA-hpe.com+AD4-
Date:+AKAAoACg-Fri Nov 20 19:05:47 2015 -0500

+AKAAoACgAKA-nfit: Account for table size length variation
+AKAAoACgAKA-
+AKAAoACgAKA-The size of NFIT tables don't necessarily match the size of the
+AKAAoACgAKA-data structures that we use for them.+AKAAoA-For example, the NVDIMM
+AKAAoACgAKA-Control Region Structure table is shorter for a device with
+AKAAoACgAKA-no block control windows than for a device with block control windows.
+AKAAoACgAKA-Other tables, such as Flush Hint Address Structure and the Interleave
+AKAAoACgAKA-Structure are variable length by definition.
+AKAAoACgAKA-
+AKAAoACgAKA-Account for the size difference when comparing table entries by
+AKAAoACgAKA-using the actual table size from the table header if it's less
+AKAAoACgAKA-than the structure size.
+AKAAoACgAKA-
+AKAAoACgAKA-Signed-off-by: Linda Knippers +ADw-linda.knippers+AEA-hpe.com+AD4-
+AKAAoACgAKA-Acked-by: Vishal Verma +ADw-vishal.l.verma+AEA-intel.com+AD4-
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit bc0d0d093b379b0b379c429e3348498287c8a9ca
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:+AKAAoACg-Mon Nov 30 09:10:33 2015 -0800

+AKAAoACgAKA-libnvdimm, e820: skip module loading when no type-12
+AKAAoACgAKA-
+AKAAoACgAKA-If there are no persistent memory ranges present then don't bother
+AKAAoACgAKA-creating the platform device.+AKAAoA-Otherwise, it loads the full libnvdimm
+AKAAoACgAKA-sub-system only to discover no resources present.
+AKAAoACgAKA-
+AKAAoACgAKA-Reported-by: Andy Lutomirski +ADw-luto+AEA-amacapital.net+AD4-
+AKAAoACgAKA-Acked-by: Andy Lutomirski +ADw-luto+AEA-amacapital.net+AD4-
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4