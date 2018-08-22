Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA066210F4BB0
 for <linux-nvdimm@lists.01.org>; Wed, 22 Aug 2018 13:22:38 -0700 (PDT)
From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: [GIT PULL]: libnvdimm updates for 4.19-rc1 v2 [1/2]
Date: Wed, 22 Aug 2018 20:22:36 +0000
Message-ID: <05a8a38a69c0f2650d25b9f1fca4a8cff7a62142.camel@intel.com>
Content-Language: en-US
Content-ID: <DD7BE12451AA81469349F3AF124930C9@intel.com>
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus,

Please pull to receive libnvdimm contributions for v4.19-rc1. I have separated out the topic branches and
will be sending pull requests for them individually.
This branch contains all the original patches from the first pull request without the dax-memory-failure series.

The following changes since commit 1273c253c32b9a073a4d8921ed079177ccc7c8af:

  tools/testing/nvdimm: advertise a write cache for nfit_test (2018-06-30 10:45:48 -0700)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-4.19_misc

for you to fetch changes up to 286e87718103acdf85f4ed323a37e4839a8a7c05:

  libnvdimm: fix ars_status output length calculation (2018-08-20 08:56:38 -0700)

----------------------------------------------------------------
libnvdimm-for-4.19_misc

Collection of misc libnvdimm patches for 4.19 submission
* Adding support to read locked nvdimm capacity.

* Change test code to make DSM failure code injection an override.

* Add support for calculate maximum contiguous area for namespace.

* Add support for queueing a short ARS when there is on going ARS for
  nvdimm.

* Allow NULL to be passed in to ->direct_access() for kaddr and
  pfn params.

* Improve smart injection support for nvdimm emulation testing.

* Fix test code that supports for emulating controller temperature.

* Fix hang on error before devm_memremap_pages()

* Fix a bug that causes user memory corruption when data returned
  to user for ars_status.

* Maintainer updates for Ross Zwisler emails and adding Jan Kara to fsdax.

----------------------------------------------------------------
Dan Williams (4):
      libnvdimm: Introduce locked DIMM capacity support
      acpi, nfit: Prefer _DSM over _LSR for namespace label reads
      tools/testing/nvdimm: Make DSM failure code injection an override
      tools/testing/nvdimm: Fix support for emulating controller temperature

Dave Jiang (1):
      acpi/nfit: queue issuing of ars when an uc error notification comes in

Huaisheng Ye (6):
      libnvdimm, pmem: kaddr and pfn can be NULL to ->direct_access()
      s390, dcssblk: kaddr and pfn can be NULL to ->direct_access()
      tools/testing/nvdimm: kaddr and pfn can be NULL to ->direct_access()
      dax/super: Do not request a pointer kaddr when not required
      md/dm-writecache: Don't request pointer dummy_addr when not required
      filesystem-dax: Do not request kaddr and pfn when not required

Keith Busch (2):
      libnvdimm: Use max contiguous area for namespace size
      libnvdimm: Export max available extent

Ross Zwisler (2):
      MAINTAINERS: update Ross Zwisler's email address
      MAINTAINERS: Add Jan Kara for filesystem DAX

Stefan Hajnoczi (1):
      device-dax: avoid hang on error before devm_memremap_pages()

Vishal Verma (2):
      tools/testing/nvdimm: improve emulation of smart injection
      libnvdimm: fix ars_status output length calculation

 .mailmap                         |   1 +
 MAINTAINERS                      |  13 ++--
 drivers/acpi/nfit/core.c         |  24 ++++++--
 drivers/acpi/nfit/nfit.h         |   1 +
 drivers/dax/pmem.c               |  12 ++--
 drivers/dax/super.c              |   3 +-
 drivers/md/dm-writecache.c       |   3 +-
 drivers/nvdimm/bus.c             |   4 +-
 drivers/nvdimm/dimm.c            |  24 +++++++-
 drivers/nvdimm/dimm_devs.c       |  31 ++++++++++
 drivers/nvdimm/namespace_devs.c  |  29 ++++++++-
 drivers/nvdimm/nd-core.h         |   8 +++
 drivers/nvdimm/nd.h              |   1 +
 drivers/nvdimm/pmem.c            |   7 ++-
 drivers/nvdimm/region_devs.c     |  40 +++++++++++++
 drivers/s390/block/dcssblk.c     |   8 ++-
 fs/dax.c                         |  13 ++--
 tools/testing/nvdimm/pmem-dax.c  |  12 ++--
 tools/testing/nvdimm/test/nfit.c | 126 ++++++++++++++++++++++++---------------
 19 files changed, 270 insertions(+), 90 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
