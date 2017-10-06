Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A1B3A21EA15C1
 for <linux-nvdimm@lists.01.org>; Thu,  5 Oct 2017 18:52:48 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/8] add an inject-error command to ndctl
Date: Thu,  5 Oct 2017 19:53:57 -0600
Message-Id: <20171006015405.29908-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

These patches add a new command to ndctl for error injection. They are
implemented such that the interface provided to a user is consistent
with the kernel - i.e. all media errors are expected/displayed in terms
of 512 byte sectors. The underlying ACPI DSMs need and provide byte
relative offsets/lengths, but these are converted to 512B sectors for
consistency.

These also update unit tests to use the new error injection commands,
and add two new unit tests - first, to test the error injection commands
themselves, and second, to test BTT error clearing.

Vishal Verma (8):
  libndctl: fix a memory leak in add_bus
  ndctl, list: move the --human description to an include
  libndctl: add APIs to get scrub count and to wait for a scrub
  ccan/list: add a list_add_after helper
  ndctl: add an inject-error command
  ndctl/test: add a new unit test for inject-error
  ndctl/test: update existing unit tests to use error-inject
  ndctl/test: add a new unit test for BTT error clearing

 Documentation/ndctl/Makefile.am            |   1 +
 Documentation/ndctl/human-option.txt       |   5 +
 Documentation/ndctl/ndctl-inject-error.txt | 108 +++++
 Documentation/ndctl/ndctl-list.txt         |   8 +-
 Documentation/ndctl/ndctl.txt              |   1 +
 builtin.h                                  |   1 +
 ccan/list/list.h                           |  32 ++
 contrib/ndctl                              |   5 +-
 ndctl/Makefile.am                          |   3 +-
 ndctl/inject-error.c                       | 745 +++++++++++++++++++++++++++++
 ndctl/lib/libndctl.c                       |  86 ++++
 ndctl/lib/libndctl.sym                     |   2 +
 ndctl/lib/private.h                        |   1 +
 ndctl/libndctl-nfit.h                      |   8 +
 ndctl/libndctl.h.in                        |   2 +
 ndctl/ndctl.c                              |   1 +
 test/Makefile.am                           |   4 +-
 test/btt-errors.sh                         | 152 ++++++
 test/clear.sh                              |   5 +-
 test/dax-errors.sh                         |   5 +-
 test/daxdev-errors.sh                      |  17 +-
 test/inject-error.sh                       |  89 ++++
 util/json.c                                |  26 +
 util/json.h                                |   3 +
 util/size.h                                |   1 +
 25 files changed, 1297 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/ndctl/human-option.txt
 create mode 100644 Documentation/ndctl/ndctl-inject-error.txt
 create mode 100644 ndctl/inject-error.c
 create mode 100755 test/btt-errors.sh
 create mode 100755 test/inject-error.sh

-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
