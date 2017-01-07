Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7B3C681A40
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jan 2017 17:46:13 -0800 (PST)
Subject: [ndctl PATCH 0/7] introduce 'daxctl list', and 'ndctl list' updates
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 Jan 2017 17:42:06 -0800
Message-ID: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
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

* The 'ndctl list' command awkwardly prints out all the corresponding
  device-dax information when a namespace is in 'dax' mode. Conversely if
  someone is only interested in listing device-dax information they need to
  contend with libnvdimm data.

  Introduce a separate daxctl utility with its own 'list' command for this
  purpose, and make the listing of device-dax data through 'ndctl list'
  optional (new --device-dax option).

* Enhance 'ndctl list' with the option to filter by namespace mode (new
  --mode option).

* Allow 'ndctl {enable,disable}-region' to limit itself to regions
  matching a given type (blk or pmem).

* Fix 'ndctl list' to trim region mapping data (i.e. the dimms in a
  region), when a specific dimm is indicated with --dimm.

---

Dan Williams (7):
      ndctl, daxctl: refactor main boilerplate for a new 'daxctl' utility
      ndctl, daxctl: move json helpers to be available across both utilities
      ndctl, list: add option to filter namespace by mode
      ndctl, list: add '--device-dax' option
      daxctl: add list command
      ndctl, {enable,disable}-region: filter by type
      ndctl, list: limit mappings when --dimm is specified


 Makefile.am                       |    4 +
 builtin.h                         |   31 +++++++
 configure.ac                      |    1 
 daxctl/Makefile.am                |   13 +++
 daxctl/daxctl.c                   |   91 +++++++++++++++++++++
 daxctl/lib/Makefile.am            |    3 +
 daxctl/libdaxctl.h                |    1 
 daxctl/list.c                     |  112 ++++++++++++++++++++++++++
 ndctl.spec.in                     |   12 +++
 ndctl/Makefile.am                 |    3 -
 ndctl/builtin-bat.c               |    2 
 ndctl/builtin-create-nfit.c       |    2 
 ndctl/builtin-dimm.c              |   14 ++-
 ndctl/builtin-list.c              |   45 ++++++++++
 ndctl/builtin-test.c              |    2 
 ndctl/builtin-xable-region.c      |   35 +++++++-
 ndctl/builtin-xaction-namespace.c |   10 +-
 ndctl/builtin.h                   |   33 --------
 ndctl/libndctl.h.in               |    1 
 ndctl/ndctl.c                     |  160 +++++++++----------------------------
 test/Makefile.am                  |    4 -
 test/device-dax.c                 |    4 -
 test/multi-pmem.c                 |    2 
 util/filter.c                     |   21 +++++
 util/filter.h                     |    6 +
 util/help.c                       |   44 ++--------
 util/json.c                       |  121 ++++++++++++++++++++++------
 util/json.h                       |    8 ++
 util/main.c                       |  123 ++++++++++++++++++++++++++++
 util/main.h                       |   10 ++
 30 files changed, 671 insertions(+), 247 deletions(-)
 create mode 100644 builtin.h
 create mode 100644 daxctl/Makefile.am
 create mode 100644 daxctl/daxctl.c
 create mode 100644 daxctl/list.c
 delete mode 100644 ndctl/builtin.h
 rename ndctl/builtin-help.c => util/help.c
 rename ndctl/util/json.c => util/json.c
 rename ndctl/util/json.h => util/json.h
 create mode 100644 util/main.c
 create mode 100644 util/main.h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
