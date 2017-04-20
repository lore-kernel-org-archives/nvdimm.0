Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5ED442194EB63
 for <linux-nvdimm@lists.01.org>; Thu, 20 Apr 2017 14:04:54 -0700 (PDT)
Subject: [ndctl PATCH 0/5] ndctl: fixups to run tests against 4.4-stable
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Apr 2017 13:58:59 -0700
Message-ID: <149272193912.23427.11500536718990091103.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Given that some of our stability fixes are being backported to 4.4,
fixup the unit tests to either "PASS" or "SKIP" for 4.4.

---

Dan Williams (5):
      test: teach nfit_test_init to only expect device-dax on v4.7+
      test, libndctl: gate dax and pfn tests on 4.8
      test, libndctl: gate ndctl_namespace_get_mode() on v4.5+
      test, libndctl: get ndctl_btt_get_size() on v4.8+
      test, create.sh: gate test on v4.5+


 test.h                 |    2 +-
 test/blk_namespaces.c  |    2 +-
 test/core.c            |   11 ++++++++++-
 test/create.sh         |   11 +++++++++++
 test/dpa-alloc.c       |    2 +-
 test/dsm-fail.c        |    2 +-
 test/libndctl.c        |   36 ++++++++++++++++++++++++++----------
 test/multi-pmem.c      |    2 +-
 test/parent-uuid.c     |    2 +-
 test/pmem_namespaces.c |    2 +-
 10 files changed, 54 insertions(+), 18 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
