Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 7D3AD1A1ECD
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 18:18:00 -0700 (PDT)
Subject: [ndctl PATCH 0/2] fix the nfit_test fallback for 'ndctl bat'
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Mar 2016 18:16:48 -0700
Message-ID: <20160324011648.20651.33434.stgit@dwillia2-desk3.jf.intel.com>
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

Per test results from Ross [1] we don't want 'ndctl bat' to require
nfit_test.  Patch2 rearranges the fallback to only trigger when an
ACPI.NFIT provider is found.

This uncovered an interesting failure mode whereby
ndctl_bus_get_by_provider() failed to locate an expected bus.  The fix
for that lead to the creation of a new ndctl_invalidate() api, see
patch1 for the details.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-March/005017.html

---

Dan Williams (2):
      ndctl: provide a method to invalidate the bus list
      ndctl: don't skip bat tests if nfit_test not available


 lib/libndctl.c          |   22 ++++++++++++++---
 lib/libndctl.sym        |    1 +
 lib/ndctl/libndctl.h.in |    1 +
 test/blk_namespaces.c   |   62 +++++++++++++++++++++++------------------------
 test/pmem_namespaces.c  |   55 ++++++++++++++++++++----------------------
 5 files changed, 76 insertions(+), 65 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
