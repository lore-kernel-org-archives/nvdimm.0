Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id CC6DE1A1E56
 for <linux-nvdimm@lists.01.org>; Mon, 25 Apr 2016 12:50:38 -0700 (PDT)
Subject: [ndctl PATCH 0/7] miscellaneous fixes
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Apr 2016 12:49:49 -0700
Message-ID: <146161378966.21779.1219526957524644729.stgit@dwillia2-desk3.amr.corp.intel.com>
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

1/ Resend "ndctl, create-namespace: report failures due to namespace
   being mounted" with the strerror() fixup recommended by Linda.

2/ Resend "ndctl, create-namespace: check for ZONE_DEVICE=n kernels"
   with a fixup for ndns being NULL in validate_namespace_options().

3/ A configure.ac fix to stop depending on documentation utilities in
   the --disable-docs case.

4/ A collection of static analysis fixes.

---

Dan Williams (7):
      ndctl, create-namespace: report failures due to namespace being mounted
      ndctl, create-namespace: check for ZONE_DEVICE=n kernels
      ndctl: fix some warnings
      ndctl: drop asciidocs and xmlto requirement for --disable-docs
      ndctl: fix to_dsm_index() static analysis warning
      ndctl: fix uninitialized variable in add_dimm()
      ndctl: fix unchecked return value


 builtin-read-labels.c       |    3 +--
 builtin-xaction-namespace.c |   41 +++++++++++++++++++++++++++++++----------
 configure.ac                |   23 ++++++++++++-----------
 lib/libndctl-private.h      |   15 +++++++++++++++
 lib/libndctl.c              |   12 ++++--------
 test/core.c                 |    3 ++-
 6 files changed, 65 insertions(+), 32 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
