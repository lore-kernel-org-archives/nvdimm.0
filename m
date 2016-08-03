Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id B049D1A1DF8
 for <linux-nvdimm@lists.01.org>; Wed,  3 Aug 2016 16:25:30 -0700 (PDT)
Subject: [ndctl PATCH 0/4] misc updates for v54
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 03 Aug 2016 16:23:06 -0700
Message-ID: <147026658649.11162.4510254495491443980.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Some test and output tidy-ups for the next release.

Speaking of ndctl-v54, there's still the pending "btt-size" patch from
Vishal that is awaiting the kernel enabling to land before the release
goes out.

---

Dan Williams (4):
      util: require --idle to list 0-sized device-dax instances
      test: ensure create.sh always picks a suitable BTT-host namespace
      test: skip pmem/blk-ns tests on KVM
      test: skip 4.7+ tests on older kernels


 ndctl/Makefile.am                 |    2 +
 ndctl/builtin-list.c              |    2 +
 ndctl/builtin-xaction-namespace.c |    2 +
 ndctl/util/json.c                 |   14 +++++--
 ndctl/util/json.h                 |    3 +-
 test/blk_namespaces.c             |   17 +++++++++
 test/create.sh                    |    2 +
 test/dax-errors.sh                |    9 +++++
 test/device-dax.sh                |   10 +++++
 test/libndctl.c                   |   70 +++++++++++++++++++++++--------------
 test/pmem_namespaces.c            |   18 ++++++++++
 11 files changed, 113 insertions(+), 36 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
