Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E74F1201B0448
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 13:41:26 -0800 (PST)
Subject: [ndctl PATCH 0/8] Improve support + testing for labels + info-blocks
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Feb 2019 13:28:48 -0800
Message-ID: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

As noted in the kernel patches for this issue:

    Lately Linux has encountered platforms that collide Persistent
    Memory regions between each other, specifically cases where
    ->start_pad needed to be non-zero. This lead to commit ae86cbfef381
    "libnvdimm, pfn: Pad pfn namespaces relative to other regions". That
    commit allowed namespaces to be mapped with devm_memremap_pages().
    However dax operations on those configurations currently fail if
    attempted within the ->start_pad range because
    pmem_device->data_offset was still relative to raw resource base not
    relative to the section aligned resource range mapped by
    devm_memremap_pages().

    Luckily __bdev_dax_supported() caught these failures and simply
    disabled dax. However, to fix this situation a non-backwards
    compatible change needs to be made to the interpretation of the
    nd_pfn info-block.  ->start_pad needs to be accounted in
    ->map.map_offset (formerly ->data_offset), and ->map.map_base
    (formerly ->phys_addr) needs to be adjusted to the section aligned
    resource base used to establish ->map.map formerly (formerly
    ->virt_addr).

Towards preventing similar bugs in this area introduce a regression
test "test/collide.sh" to validate support for pre- and post-fixed
kernels. In the course of developing this test a few missing
capabilities and fixes also surfaced.

---

Dan Williams (8):
      ndctl/dimm: Add 'flags' field to read-labels output
      ndctl/dimm: Add --human support to read-labels
      ndctl/build: Drop -Wpointer-arith
      ndctl/namespace: Add read-info-block command
      ndctl/test: Update dax-dev to handle multiple e820 ranges
      ndctl/test: Make dax.sh more robust vs small namespaces
      ndctl/namespace: Always zero info-blocks
      ndctl/test: Test inter-region collision handling


 configure.ac         |    1 
 ndctl/action.h       |    1 
 ndctl/builtin.h      |    1 
 ndctl/check.c        |   20 --
 ndctl/dimm.c         |   21 ++-
 ndctl/namespace.c    |  416 +++++++++++++++++++++++++++++++++++++++++++++++++-
 ndctl/namespace.h    |   51 ++++++
 ndctl/ndctl.c        |    1 
 test/Makefile.am     |    1 
 test/collide.sh      |  226 +++++++++++++++++++++++++++
 test/dax-dev.c       |   17 ++
 test/dax.sh          |    4 
 test/fsdax-info0.xxd |   11 +
 test/fsdax-info1.xxd |   11 +
 test/fsdax-info2.xxd |   11 +
 test/fsdax-info3.xxd |   11 +
 util/fletcher.h      |    1 
 util/size.h          |    1 
 18 files changed, 763 insertions(+), 43 deletions(-)
 create mode 100755 test/collide.sh
 create mode 100644 test/fsdax-info0.xxd
 create mode 100644 test/fsdax-info1.xxd
 create mode 100644 test/fsdax-info2.xxd
 create mode 100644 test/fsdax-info3.xxd
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
