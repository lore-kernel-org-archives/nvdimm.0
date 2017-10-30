Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1C10A21F3B3F2
 for <linux-nvdimm@lists.01.org>; Mon, 30 Oct 2017 10:42:02 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 0/6] add an inject-error command to ndctl
Date: Mon, 30 Oct 2017 11:43:29 -0600
Message-Id: <20171030174335.6806-1-vishal.l.verma@intel.com>
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

v3:
 patch 2:
   - Don't export ndctl_namespace_get_injection_bounds (Dan).

v2:
 patch 1:
   - use poll() instead of a sleep loop when waiting for a scrub. (Dan)
 patch 2 (new):
   - move the acpi nfit specific routines into generic wrappers exported
     by the library. (Dan)
 patch 3:
   - rename 'clear' to 'uninject' use 'block' instead of 'sector' (Dan)
   - cleanup the manpage to remove ACPI/NFIT references.
 patch 4:
   - Add the actual inject-error unit test instead of just test
     boilerplate


These patches add a new command to ndctl for error injection. They are
implemented such that the interface provided to a user is consistent
with the kernel - i.e. all media errors are expected/displayed in terms
of 512 byte sectors. The underlying ACPI DSMs need and provide byte
relative offsets/lengths, but these are converted to 512B sectors for
consistency.

These also update unit tests to use the new error injection commands,
and add two new unit tests - first, to test the error injection commands
themselves, and second, to test BTT error clearing.


Vishal Verma (6):
  libndctl: add APIs to get scrub count and to wait for a scrub
  libndctl: add error injection related interfaces
  ndctl: add an inject-error command
  ndctl/test: add a new unit test for inject-error
  ndctl/test: update existing unit tests to use inject-error
  ndctl/test: add a new unit test for BTT error clearing

 Documentation/ndctl/Makefile.am            |   1 +
 Documentation/ndctl/ndctl-inject-error.txt | 108 ++++++++
 Documentation/ndctl/ndctl.txt              |   1 +
 builtin.h                                  |   1 +
 contrib/ndctl                              |   5 +-
 ndctl/Makefile.am                          |   3 +-
 ndctl/inject-error.c                       | 373 +++++++++++++++++++++++++++
 ndctl/lib/Makefile.am                      |   1 +
 ndctl/lib/inject.c                         | 391 +++++++++++++++++++++++++++++
 ndctl/lib/libndctl.c                       | 147 +++++++----
 ndctl/lib/libndctl.sym                     |  10 +
 ndctl/lib/nfit.c                           |  89 +++++++
 ndctl/lib/private.h                        |  54 ++++
 ndctl/libndctl-nfit.h                      |  10 +
 ndctl/libndctl.h.in                        |  22 ++
 ndctl/ndctl.c                              |   1 +
 test/Makefile.am                           |   4 +-
 test/btt-errors.sh                         | 149 +++++++++++
 test/clear.sh                              |   5 +-
 test/dax-errors.sh                         |   5 +-
 test/daxdev-errors.sh                      |  17 +-
 test/inject-error.sh                       | 120 +++++++++
 util/json.c                                |  26 ++
 util/json.h                                |   3 +
 util/list.h                                |  50 ++++
 util/size.h                                |   1 +
 26 files changed, 1547 insertions(+), 50 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-inject-error.txt
 create mode 100644 ndctl/inject-error.c
 create mode 100644 ndctl/lib/inject.c
 create mode 100755 test/btt-errors.sh
 create mode 100755 test/inject-error.sh
 create mode 100644 util/list.h

-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
