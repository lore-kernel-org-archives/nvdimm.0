Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 0/9] libnvdimm, pfn updates for 4.5
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Dec 2015 18:14:28 -0800
Message-ID: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: willy@linux.intel.com, ross.zwisler@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

With the impending merge of the dax-gup patchset [1], a new set of unit
tests for 'pfn' devices was added to ndctl.  These are the cleanups and
fixups identified from that testing.

The unit test updates will be posted separately on the linux-nvdimm list.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-December/003213.html

---

Dan Williams (9):
      libnvdimm, pfn: kill ND_PFN_ALIGN
      libnvdimm, pfn: clean up pfn create parameters
      libnvdimm, pfn: add 'align' attribute, default to HPAGE_SIZE
      libnvdimm, pfn: add parent uuid validation
      libnvdimm, pfn: fix pfn seed creation
      libnvdimm, pfn: enable pfn sysfs interface unit testing
      libnvdimm, pfn: fix nd_pfn_validate() return value handling
      tools/testing/libnvdimm: cleanup mock resource lookup
      libnvdimm, pfn: move 'memory mode' indication to sysfs


 drivers/nvdimm/namespace_devs.c   |   53 ++++++++++++++++-----
 drivers/nvdimm/nd-core.h          |    1 
 drivers/nvdimm/nd.h               |    8 ---
 drivers/nvdimm/pfn_devs.c         |   93 +++++++++++++++++++++++++++++--------
 drivers/nvdimm/pmem.c             |   26 +++-------
 drivers/nvdimm/region_devs.c      |    7 +++
 tools/testing/nvdimm/Kbuild       |    2 +
 tools/testing/nvdimm/test/iomap.c |   90 ++++++++++++++++++++++--------------
 8 files changed, 186 insertions(+), 94 deletions(-)
