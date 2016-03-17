Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id C207B1A1DE8
 for <linux-nvdimm@lists.01.org>; Wed, 16 Mar 2016 17:55:15 -0700 (PDT)
Subject: [ndctl PATCH 0/5] refresh 'ndctl bat' tests and other misc updates
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Mar 2016 17:54:30 -0700
Message-ID: <20160317005429.3025.395.stgit@dwillia2-desk3.jf.intel.com>
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

After discovering a segfault in test/blk-ns (fixed in patch 2) it became
clear that these tests could stand to have some more exposure.  These
updates make the tests fallback to nfit_test resources when run on a
platform that lacks an ACPI.NFIT.


---

Dan Williams (5):
      ndctl: update pkg-config description
      ndctl: fix blk-ns test cleanup
      Revert "ndctl: fix error handling in ND_BLK & PMEM tests"
      ndctl: convert 'ndctl bat' to use struct ndctl_test
      ndctl: fall back to nfit_test for test/{blk|pmem}-ns


 Makefile.am            |   12 ++--
 builtin-bat.c          |   27 +++++++--
 lib/libndctl.pc.in     |    2 -
 test.h                 |    6 +-
 test/blk_namespaces.c  |  149 +++++++++++++++++++++++++++++++-----------------
 test/pcommit.c         |   19 +++++-
 test/pmem_namespaces.c |  124 ++++++++++++++++++++++++++++------------
 7 files changed, 232 insertions(+), 107 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
