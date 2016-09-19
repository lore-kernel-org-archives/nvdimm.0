Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 10FB11A1E31
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 14:40:40 -0700 (PDT)
Subject: [ndctl PATCH 0/6] miscellaneous updates / static analysis fixes
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Sep 2016 14:37:36 -0700
Message-ID: <147432105652.39548.8883834720654751375.stgit@dwillia2-desk3.amr.corp.intel.com>
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

- refreshed "build: build libraries and utilities in separate
  directories" on top of the HPE S.M.A.R.T. enabling patches.

- fixed static analysis problems in "test, dsm-fail: test
  get_config_size DSM failures"

- miscellaneous updates and fixes, see the shortlog below

---

Dan Williams (6):
      build: build libraries and utilities in separate directories
      test, dsm-fail: test get_config_size DSM failures
      Documentation: update top-level man page with latest commands
      test, libndctl: fix uninitialized variable usage in check_btt_size()
      libdaxctl: fix deref-before-null-check in daxctl_new_region
      ndctl: fix potential null deref in util_namespace_to_json()


 Documentation/ndctl.txt |    6 +
 Makefile.am             |    2 
 configure.ac            |    3 -
 daxctl/Makefile.am      |   27 ------
 daxctl/lib/Makefile.am  |   28 ++++++
 daxctl/lib/libdaxctl.c  |   11 ++
 ndctl/Makefile.am       |   51 +----------
 ndctl/builtin-test.c    |    5 +
 ndctl/lib/Makefile.am   |   47 ++++++++++
 ndctl/util/json.c       |    2 
 test.h                  |    1 
 test/Makefile.am        |   10 ++
 test/dsm-fail.c         |  220 +++++++++++++++++++++++++++++++++++++++++++++++
 test/libndctl.c         |    2 
 14 files changed, 334 insertions(+), 81 deletions(-)
 delete mode 100644 daxctl/Makefile.am
 create mode 100644 daxctl/lib/Makefile.am
 create mode 100644 ndctl/lib/Makefile.am
 create mode 100644 test/dsm-fail.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
