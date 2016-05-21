Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 824251A1E1A
 for <linux-nvdimm@lists.01.org>; Sat, 21 May 2016 14:56:04 -0700 (PDT)
Subject: [ndctl PATCH 0/5] Device DAX support
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 21 May 2016 14:55:10 -0700
Message-ID: <146386771020.1884.14405221977201209581.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Extend libndctl with a libdaxctl helper library to enumerate the devices
that appear underneath a libnvdimm namespace in "dax" mode.  libdaxctl
is meant to be independent from libndctl as device-dax instances may
arise from other memory ranges besides persistent memory.  It is a
generic enumeration facility for performance / featured differentiated
memory ranges when the kernel arranges for them to be exposed as a
devices.


---

Dan Williams (5):
      util: centralize logging
      util: centralize sysfs helpers
      test: fix 'pfn alignment too big' checks
      daxctl: initial boilerplate
      daxctl: enumeration api and unit test for "Device DAX"


 Makefile.am                    |    2 
 Makefile.am.in                 |    3 
 configure.ac                   |    1 
 daxctl/Makefile.am             |   28 ++
 daxctl/lib/libdaxctl-private.h |   40 +++
 daxctl/lib/libdaxctl.c         |  353 ++++++++++++++++++++++++++++
 daxctl/lib/libdaxctl.pc.in     |   11 +
 daxctl/lib/libdaxctl.sym       |   32 +++
 daxctl/libdaxctl.h             |   64 +++++
 ndctl/Makefile.am              |   21 +-
 ndctl/lib/libndctl-private.h   |   65 ++---
 ndctl/lib/libndctl-smart.c     |    1 
 ndctl/lib/libndctl.c           |  219 ++++--------------
 ndctl/lib/libndctl.sym         |    2 
 ndctl/libndctl.h.in            |    3 
 test/Makefile.am               |    4 
 test/libndctl.c                |  500 ++++++++++++++++++++++++++++++++++------
 util/log.c                     |   65 +++++
 util/log.h                     |   69 ++++++
 util/sysfs.c                   |  128 ++++++++++
 util/sysfs.h                   |   40 +++
 21 files changed, 1350 insertions(+), 301 deletions(-)
 create mode 100644 daxctl/Makefile.am
 create mode 100644 daxctl/lib/libdaxctl-private.h
 create mode 100644 daxctl/lib/libdaxctl.c
 create mode 100644 daxctl/lib/libdaxctl.pc.in
 create mode 100644 daxctl/lib/libdaxctl.sym
 create mode 100644 daxctl/libdaxctl.h
 create mode 100644 util/log.c
 create mode 100644 util/log.h
 create mode 100644 util/sysfs.c
 create mode 100644 util/sysfs.h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
