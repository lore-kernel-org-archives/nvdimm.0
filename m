Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 84FBA1A1DF2
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 10:23:50 -0700 (PDT)
Subject: [ndctl PATCH 0/8] ndctl: device-dax tests
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Aug 2016 10:21:27 -0700
Message-ID: <147136808681.27902.14029119240021638000.stgit@dwillia2-desk3.amr.corp.intel.com>
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

- enable tests of the ndctl built-in commands to be authored in C rather
  than Shell

- add apis for retrieving the region-seed and available size

- test the creation and destruction of device-dax instances, and that
  destruction (region unbind) triggers unmap of current mappings.

---

Dan Williams (8):
      ndctl: centralize libndctl context init across commands
      libdaxctl: add daxctl_region_get_available_size()
      libdaxctl: add daxctl_region_get_seed()
      test: teach test/libndctl about device-dax seeds
      test: refactor / export ndctl_get_test_dev()
      test, create-namespace: reset global data
      test: convert device-dax test from shell to C
      test, device-dax: check mappings invalidated on namespace reconfiguration


 daxctl/lib/libdaxctl-private.h    |    3 +
 daxctl/lib/libdaxctl.c            |   77 ++++++++++++++++--
 daxctl/lib/libdaxctl.sym          |    7 ++
 daxctl/libdaxctl.h                |    4 +
 ndctl/builtin-bat.c               |    6 +
 ndctl/builtin-create-nfit.c       |    3 -
 ndctl/builtin-help.c              |    2 
 ndctl/builtin-list.c              |    9 --
 ndctl/builtin-read-labels.c       |    9 --
 ndctl/builtin-test.c              |    8 +-
 ndctl/builtin-xable-region.c      |   17 +---
 ndctl/builtin-xaction-namespace.c |   46 ++++++-----
 ndctl/builtin-zero-labels.c       |    9 --
 ndctl/builtin.h                   |   29 +++----
 ndctl/ndctl.c                     |   17 +++-
 test.h                            |   17 ++--
 test/Makefile.am                  |   13 +++
 test/blk_namespaces.c             |   24 +++---
 test/dax-dev.c                    |   42 ++++++----
 test/device-dax.c                 |  159 +++++++++++++++++++++++++++++++++----
 test/device-dax.sh                |   40 ---------
 test/dpa-alloc.c                  |   19 ++--
 test/libndctl.c                   |   33 ++++----
 test/parent-uuid.c                |   19 ++--
 test/pmem_namespaces.c            |   22 +++--
 25 files changed, 406 insertions(+), 228 deletions(-)
 delete mode 100755 test/device-dax.sh
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
