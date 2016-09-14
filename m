Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6979F1A1E57
 for <linux-nvdimm@lists.01.org>; Tue, 13 Sep 2016 18:03:21 -0700 (PDT)
Subject: [ndctl PATCH 0/3] ndctl disable-dimm and label-read-failure unit test
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Sep 2016 18:00:17 -0700
Message-ID: <147381481774.12944.1660067055752367684.stgit@dwillia2-desk3.amr.corp.intel.com>
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

We recently discovered that the kernel does not properly check and fail
unknown status results in DSM commands.  This highlighted a larger
concern that we expect the kernel to fail regions when one of the
required dimm-label-areas is unavailable.

- Add ndctl commands for disabling/enabling dimms as helper for cases
  where a platform owner wants to refresh the driver's cached copy of
  the labels.

- Add a new unit test to validate that when a disabled dimm is detected
  any attempt to enable a related region fails.

- Fix up the build system to allow util/log.c and util/sysfs.c to be
  used in tests as well as the libraries.

---

Dan Williams (3):
      ndctl: {enable|disable}-dimm commands
      build: build libraries and utilities in separate directories
      test, dsm-fail: test get_config_size DSM failures


 Documentation/Makefile.am            |    4 +
 Documentation/dimm-description.txt   |   15 ++
 Documentation/ndctl-disable-dimm.txt |   22 +++
 Documentation/ndctl-enable-dimm.txt  |   22 +++
 Documentation/xable-dimm-options.txt |    9 +
 Makefile.am                          |    2 
 configure.ac                         |    3 
 daxctl/Makefile.am                   |   27 ----
 daxctl/lib/Makefile.am               |   28 ++++
 ndctl/Makefile.am                    |   51 +-------
 ndctl/builtin-test.c                 |    5 +
 ndctl/builtin-xable-dimm.c           |  115 ++++++++++++++++++
 ndctl/builtin.h                      |    2 
 ndctl/lib/Makefile.am                |   46 +++++++
 ndctl/ndctl.c                        |    2 
 test.h                               |    1 
 test/Makefile.am                     |   10 ++
 test/dsm-fail.c                      |  216 ++++++++++++++++++++++++++++++++++
 18 files changed, 504 insertions(+), 76 deletions(-)
 create mode 100644 Documentation/dimm-description.txt
 create mode 100644 Documentation/ndctl-disable-dimm.txt
 create mode 100644 Documentation/ndctl-enable-dimm.txt
 create mode 100644 Documentation/xable-dimm-options.txt
 delete mode 100644 daxctl/Makefile.am
 create mode 100644 daxctl/lib/Makefile.am
 create mode 100644 ndctl/builtin-xable-dimm.c
 create mode 100644 ndctl/lib/Makefile.am
 create mode 100644 test/dsm-fail.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
