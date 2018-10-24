Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 89F452116DA10
 for <linux-nvdimm@lists.01.org>; Wed, 24 Oct 2018 16:45:56 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm for 4.20
Date: Wed, 24 Oct 2018 23:45:54 +0000
Message-ID: <47580ee876c884c91fdb8c29791257cf715facfa.camel@intel.com>
Content-Language: en-US
Content-ID: <AF22FDF13B095F4B8774C951FE46689C@intel.com>
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
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-4.20

...to receive the libnvdimm updates for this cycle. No interactions
with other trees this time around. There are updates to the core to
improve driver initialization time, and updates to the 'nfit' driver
for fixing ARS corner cases and exposing some more hardware attributes
to userspace. It has all been in -next for a few releases now with no
reported issues.

---

The following changes since commit 7876320f88802b22d4e2daf7eb027dd14175a0f8:

  Linux 4.19-rc4 (2018-09-16 11:52:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-4.20

for you to fetch changes up to 594861215c834e4b59a30d4b794f6372717bc197:

  acpi, nfit: Further restrict userspace ARS start requests (2018-10-17 14:02:32 -0700)

----------------------------------------------------------------
libnvdimm for 4.20

* Improve the efficiency and performance of reading nvdimm-namespace
  labels. Reduce the amount of label data read at driver load time by a
  few orders of magnitude. Reduce heavyweight call-outs to
  platform-firmware routines.

* Handle media errors located in the 'struct page' array stored on a
  persistent memory namespace. Let the kernel clear these errors rather
  than an awkward userspace workaround.

* Fix Address Range Scrub (ARS) completion tracking. Correct occasions
  where the kernel indicates completion of ARS before submission.

* Fix asynchronous device registration reference counting.

* Add support for reporting an nvdimm dirty-shutdown-count via sysfs.

* Fix various small libnvdimm core and uapi issues.

----------------------------------------------------------------
Alexander Duyck (7):
      libnvdimm: Hold reference on parent while scheduling async init
      libnvdimm: Set device node in nd_device_register
      nvdimm: Sanity check labeloff
      nvdimm: Clarify comment in sizeof_namespace_index
      nvdimm: Remove empty if statement
      nvdimm: Split label init out from the logic for getting config data
      nvdimm: Use namespace index data to reduce number of label reads needed

Dan Williams (9):
      libnvdimm, region: Fail badblocks listing for inactive regions
      libnvdimm, pmem: Fix badblocks population for 'raw' namespaces
      libnvdimm, dimm: Maximize label transfer size
      libnvdimm, label: Fix sparse warning
      acpi, nfit: Introduce nfit_mem flags
      acpi, nfit: Collect shutdown status
      tools/testing/nvdimm: Populate dirty shutdown data
      acpi, nfit: Fix Address Range Scrub completion tracking
      acpi, nfit: Further restrict userspace ARS start requests

David Howells (2):
      UAPI: ndctl: Fix g++-unsupported initialisation in headers
      UAPI: ndctl: Remove use of PAGE_SIZE

GuangZhe Fu (1):
      libnvdimm, namespace: Drop the repeat assignment for variable dev->parent

Pankaj Gupta (1):
      libnvdimm: remove duplicate include

Vishal Verma (1):
      libnvdimm, pfn: during init, clear errors in the metadata area

 drivers/acpi/nfit/core.c              | 297 +++++++++++++++++++++++-----------
 drivers/acpi/nfit/intel.h             |  38 +++++
 drivers/acpi/nfit/nfit.h              |  21 ++-
 drivers/nvdimm/bus.c                  |  20 ++-
 drivers/nvdimm/dimm.c                 |   6 +-
 drivers/nvdimm/dimm_devs.c            |  60 +++----
 drivers/nvdimm/label.c                | 144 ++++++++++++++++-
 drivers/nvdimm/label.h                |   4 +-
 drivers/nvdimm/namespace_devs.c       |   1 -
 drivers/nvdimm/nd-core.h              |   1 -
 drivers/nvdimm/nd.h                   |   2 +
 drivers/nvdimm/pfn_devs.c             |  61 ++++++-
 drivers/nvdimm/pmem.c                 |   4 +-
 drivers/nvdimm/region_devs.c          |  11 +-
 include/linux/ndctl.h                 |  22 +++
 include/uapi/linux/ndctl.h            |  52 +++---
 tools/testing/nvdimm/Kbuild           |   1 +
 tools/testing/nvdimm/acpi_nfit_test.c |   8 +
 tools/testing/nvdimm/test/nfit.c      |   4 +-
 tools/testing/nvdimm/test/nfit_test.h |  24 ---
 20 files changed, 564 insertions(+), 217 deletions(-)
 create mode 100644 drivers/acpi/nfit/intel.h
 create mode 100644 include/linux/ndctl.h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
