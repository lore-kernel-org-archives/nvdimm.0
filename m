Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 97722228392E0
 for <linux-nvdimm@lists.01.org>; Sat, 21 Apr 2018 17:17:28 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm fixes for 4.17-rc2
Date: Sun, 22 Apr 2018 00:17:25 +0000
Message-ID: <1524356236.26036.13.camel@intel.com>
Content-Language: en-US
Content-ID: <07665B705A136D459F8F248D670F4E73@intel.com>
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

Hi Linus, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

...to receive, a regression fix, new unit test infrastructure and a
build fix.

* The regression fix addresses support for the new NVDIMM label storage
area access commands (_LSI, _LSR, and _LSW). The Intel specific version
of these commands communicated the "Device Locked" status on the label-
storage-information command. However, these new commands (standardized
in ACPI 6.2) communicate the "Device Locked" status on the label-
storage-read command, and the driver was missing the indication.
Reading from locked persistent memory is similar to reading unmapped
PCI memory space, returns all 1's.

* Unit test infrastructure is added to regression test the "Device
Locked" detection failure.

* A build fix is included to allow the "of_pmem" driver to be built as
a module and translate an Open Firmware described device to its local
numa node.

---

The following changes since commit 60cc43fc888428bb2f18f08997432d426a243338:

  Linux 4.17-rc1 (2018-04-15 18:24:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

for you to fetch changes up to c5794510d7b5f210f05531ff9e82432cf7244367:

  MAINTAINERS: Add backup maintainers for libnvdimm and DAX (2018-04-19 15:22:50 -0700)

----------------------------------------------------------------
Dan Williams (6):
      libnvdimm, dimm: handle EACCES failures from label reads
      tools/testing/nvdimm: allow custom error code injection
      tools/testing/nvdimm: support nfit_test_dimm attributes under nfit_test.1
      tools/testing/nvdimm: fix missing newline in nfit_test_dimm 'handle' attribute
      tools/testing/nvdimm: enable labels for nfit_test.1 dimms
      Revert "libnvdimm, of_pmem: workaround OF_NUMA=n build error"

Dave Jiang (2):
      device-dax: allow MAP_SYNC to succeed
      MAINTAINERS: Add backup maintainers for libnvdimm and DAX

Rob Herring (1):
      libnvdimm, of_pmem: use dev_to_node() instead of of_node_to_nid()

 MAINTAINERS                      | 15 +++++++
 drivers/dax/device.c             |  2 +
 drivers/nvdimm/Kconfig           |  3 +-
 drivers/nvdimm/dimm_devs.c       | 22 ++++++-----
 drivers/nvdimm/of_pmem.c         |  2 +-
 tools/testing/nvdimm/test/nfit.c | 84 +++++++++++++++++++++++++++++++---------
 6 files changed, 96 insertions(+), 32 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
